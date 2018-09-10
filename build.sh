    #!/bin/bash
############################################################

# This is the full build script used to build the official kernel zip.

# Minimum requirements to build:
# Already working build environment :P 
#
# In this script: 
# You will need to change the 'Source path to kernel tree' to match your current path to this source.
# You will need to change the 'Compile Path to out' to match your current path to this source.
# You will also need to edit the '-j32' under 'Start Compile' section and adjust that to match the amount of cores you want to use to build.
# 
# In Makefile: 
# You will need to edit the 'CROSS_COMPILE=' line to match your current path to this source.
# 
# Once those are done, you should be able to execute './build.sh' from terminal and receive a working zip.

############################################################
# Build Script Variables
############################################################ 

# Source defconfig used to build
	dc=oneplus5_defconfig

# Source Path to kernel tree
	k=/home/syrklesloveskeri/CR7/kernel/oneplus/msm8998

# Source Path to clean(empty) out folder
	co=$k/out

# Compile Path to out 
	o="O=$k/out"

# Source Path to compiled Image.gz-dtb
	i=$k/out/arch/arm64/boot/Image.gz-dtb

# Destination Path for compiled modules
	zm=$k/build/system/lib/modules

# Destination path for compiled Image.gz-dtb
	zi=$k/build/Image.gz-dtb
	
# Source path for building kernel zip
	zp=$k/build/
	
# Destination Path for uploading kernel zip
	zu=$k/upload/

# Kernel zip Name
##############################
	kn=Liquid_High-Kernel-HMP.zip

# Toolchain
##############################
    ac=arm64
    tc=/home/syrklesloveskeri/kernel/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
    clang=/home/syrklesloveskeri/kernel/prebuilts/clang/host/linux-x86/clang-r328903/bin/clang
    triple=aarch64-linux-gnu-

############################################################
# Cleanup
############################################################

	echo "	Cleaning up out directory"
	rm -Rf out/
	echo "	Out directory removed!"

############################################################
# Make out folder
############################################################

	echo "	Making new out directory"
	mkdir -p "$co"
	echo "	Created new out directory"

############################################################
# Make upload folder
############################################################

	echo "	Making new out directory"
	mkdir -p "$up"
	echo "	Created new out directory"

############################################################
# Establish defconfig
############################################################

	echo "	Establishing build environment.."
	make "$o" "$dc" ARCH=arm64

############################################################
# Start Compile
############################################################

	echo "	First pass started.."
    make "$o" -j4 ARCH="$ac" CC="$clang" CLANG_TRIPLE="$triple" CROSS_COMPILE="$tc"
	echo "	First pass completed!"
	echo "	"
	echo "	Starting Second Pass.."
    make "$o" -j4 ARCH="$ac" CC="$clang" CLANG_TRIPLE="$triple" CROSS_COMPILE="$tc"
	echo "	Second pass completed!"

############################################################
# Copy image.gz-dtb to /build
############################################################

	echo "	Copying kernel to zip directory"
	cp "$i" "$zi"
#	find . -name "*.ko" -exec cp {} "$zm" \;
	echo "	Copying kernel completed!"

############################################################
# Make zip and move to /upload
############################################################

	echo "	Making zip file.."
	cd "$zp"
	zip -r "$kn" *
	echo "	Moving zip to upload directory"
	mv "$kn" "$zu" 
	echo "	Completed build script!"
	echo "	Returning to start.."
	cd "$k"

