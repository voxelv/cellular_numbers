extends Node

var grid_button_preload = preload("res://test_cell_button.tscn")

export(int, 1, 7) var cell_size

onready var ui := find_node("ui") as Control
onready var cell_size_label := find_node("cell_size_label") as Label
onready var decrease_size_button := find_node("decrease_size_button") as Button
onready var increase_size_button := find_node("increase_size_button") as Button
onready var grid_buttons_container := find_node("grid_buttons_container") as GridContainer
onready var number_label := find_node("number_label") as Label
onready var number_label_hex := find_node("number_label_hex") as Label
onready var number_lineedit := find_node("number_lineedit") as LineEdit
onready var number_lineedit_hex := find_node("number_lineedit_hex") as LineEdit

func _ready():
	decrease_size_button.connect("pressed", self, "_on_change_size_button_pressed", [-1])
	increase_size_button.connect("pressed", self, "_on_change_size_button_pressed", [1])
	_setup()
	
func _setup():
	# Set Cell Size Label
	cell_size_label.text = "%dx%d" % [cell_size, cell_size]
	
	# Remove all grid buttons
	for c in grid_buttons_container.get_children():
		c.queue_free()
	
	# Wait until next frame to add buttons
	yield(get_tree(), "idle_frame")
	grid_buttons_container.columns = cell_size
	for i in range(cell_size * cell_size):
		var new_grid_button = grid_button_preload.instance()
		grid_buttons_container.add_child(new_grid_button)
		new_grid_button.connect("toggled", self, "_on_button_toggled")
	
	# Update output numbers
	_update_numbers()

func _on_change_size_button_pressed(incr):
	var prev_cell_size = cell_size
	cell_size = clamp(cell_size + incr, 1, 7)
	if cell_size != prev_cell_size:
		_setup()

func _on_button_toggled(pressed):
	_update_numbers()

func _update_numbers():
	var idx = 0
	var result = 0
	for b in grid_buttons_container.get_children():
		if b.pressed:
			result = result | (0x1 << idx)
		idx += 1
	number_label.text = str(result)
	number_label_hex.text = "0x%X" % result
	number_lineedit.text = number_label.text
	number_lineedit_hex.text = number_label_hex.text
	pass