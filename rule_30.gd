extends Node2D

@onready var layer: TileMapLayer = $TileMapLayer

const SOURCE_ID := 0
const WHITE_TILE : Vector2i = Vector2i(0, 0)
const BLACK_TILE : Vector2i = Vector2i(1, 0)

const GRID_WIDTH : int = 500
const GRID_HEIGHT : int = 150

var arr : PackedInt32Array = PackedInt32Array()
var atlas

func _ready() -> void:
	arr.resize(GRID_WIDTH)
	arr[int(GRID_WIDTH / 2)] = 1
	
	#for z in range(GRID_WIDTH):
		#arr[z] = randi() & 1   # 0 or 1
		
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if arr[x] == 1:
				atlas = BLACK_TILE
			else:
				atlas = WHITE_TILE

			layer.set_cell(Vector2i(x, y), SOURCE_ID, atlas, 0)
			
		arr = get_new_arr(arr)
			
func get_new_arr(arr: PackedInt32Array) -> PackedInt32Array:
	var offset_arr := PackedInt32Array([arr[GRID_WIDTH - 1]]) + arr + PackedInt32Array([arr[0]])

	var out := PackedInt32Array()
	out.resize(GRID_WIDTH)

	for i in range(GRID_WIDTH):
		var a := offset_arr[i]
		var b := offset_arr[i + 1]
		var c := offset_arr[i + 2]

		var new_val: int = 0
		match [a, b, c]:
			[0,0,0]: new_val = 0
			[0,0,1]: new_val = 1
			[0,1,0]: new_val = 1
			[0,1,1]: new_val = 1
			[1,0,0]: new_val = 1
			[1,0,1]: new_val = 0
			[1,1,0]: new_val = 0
			[1,1,1]: new_val = 0
			_: new_val = 0 # safety

		out[i] = new_val

	return out
	
