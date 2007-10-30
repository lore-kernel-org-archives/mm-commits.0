From: akpm@linux-foundation.org
Subject: - x86-boot-document-for-32-bit-boot-protocol.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:58 -0700
Message-ID: <200710301806.l9UI6wwG020564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbXJ3STR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     x86 boot: document for 32 bit boot protocol
has been removed from the -mm tree.  Its filename was
     x86-boot-document-for-32-bit-boot-protocol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86 boot: document for 32 bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>

This patch documents the 32-bit boot protocol of x86. It has been used
by Kexec and LinuxBIOS. This patch is based on the proposal of Peter
Anvin.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i386/boot.txt      |   38 ++++++++
 Documentation/i386/zero-page.txt |  130 ++++++-----------------------
 2 files changed, 69 insertions(+), 99 deletions(-)

diff -puN Documentation/i386/boot.txt~x86-boot-document-for-32-bit-boot-protocol Documentation/i386/boot.txt
--- a/Documentation/i386/boot.txt~x86-boot-document-for-32-bit-boot-protocol
+++ a/Documentation/i386/boot.txt
@@ -785,3 +785,41 @@ IMPORTANT: All the hooks are required to
 	After completing your hook, you should jump to the address
 	that was in this field before your boot loader overwrote it
 	(relocated, if appropriate.)
+
+
+**** 32-bit BOOT PROTOCOL
+
+For machine with some new BIOS other than legacy BIOS, such as EFI,
+LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
+based on legacy BIOS can not be used, so a 32-bit boot protocol needs
+to be defined.
+
+In 32-bit boot protocol, the first step in loading a Linux kernel
+should be to setup the boot parameters (struct boot_params,
+traditionally known as "zero page"). The memory for struct boot_params
+should be allocated and initialized to all zero. Then the setup header
+from offset 0x01f1 of kernel image on should be loaded into struct
+boot_params and examined. The end of setup header can be calculated as
+follow:
+
+	0x0202 + byte value at offset 0x0201
+
+In addition to read/modify/write the setup header of the struct
+boot_params as that of 16-bit boot protocol, the boot loader should
+also fill the additional fields of the struct boot_params as that
+described in zero-page.txt.
+
+After setupping the struct boot_params, the boot loader can load the
+32/64-bit kernel in the same way as that of 16-bit boot protocol.
+
+In 32-bit boot protocol, the kernel is started by jumping to the
+32-bit kernel entry point, which is the start address of loaded
+32/64-bit kernel.
+
+At entry, the CPU must be in 32-bit protected mode with paging
+disabled; a GDT must be loaded with the descriptors for selectors
+__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
+segment; __BOOS_CS must have execute/read permission, and __BOOT_DS
+must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
+must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
+address of the struct boot_params; %ebp, %edi and %ebx must be zero.
diff -puN Documentation/i386/zero-page.txt~x86-boot-document-for-32-bit-boot-protocol Documentation/i386/zero-page.txt
--- a/Documentation/i386/zero-page.txt~x86-boot-document-for-32-bit-boot-protocol
+++ a/Documentation/i386/zero-page.txt
@@ -1,99 +1,31 @@
----------------------------------------------------------------------------
-!!!!!!!!!!!!!!!WARNING!!!!!!!!
-The zero page is a kernel internal data structure, not a stable ABI.  It might change
-without warning and the kernel has no way to detect old version of it.
-If you're writing some external code like a boot loader you should only use
-the stable versioned real mode boot protocol described in boot.txt. Otherwise the kernel
-might break you at any time.
-!!!!!!!!!!!!!WARNING!!!!!!!!!!!
-----------------------------------------------------------------------------
-
-Summary of boot_params layout (kernel point of view)
-     ( collected by Hans Lermen and Martin Mares )
- 
-The contents of boot_params are used to pass parameters from the
-16-bit realmode code of the kernel to the 32-bit part. References/settings
-to it mainly are in:
-
-  arch/i386/boot/setup.S
-  arch/i386/boot/video.S
-  arch/i386/kernel/head.S
-  arch/i386/kernel/setup.c
- 
-
-Offset	Type		Description
-------  ----		-----------
-    0	32 bytes	struct screen_info, SCREEN_INFO
-			ATTENTION, overlaps the following !!!
-    2	unsigned short	EXT_MEM_K, extended memory size in Kb (from int 0x15)
- 0x20	unsigned short	CL_MAGIC, commandline magic number (=0xA33F)
- 0x22	unsigned short	CL_OFFSET, commandline offset
-			Address of commandline is calculated:
-			  0x90000 + contents of CL_OFFSET
-			(only taken, when CL_MAGIC = 0xA33F)
- 0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
- 0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
- 0x80	16 bytes	hd0-disk-parameter from intvector 0x41
- 0x90	16 bytes	hd1-disk-parameter from intvector 0x46
-
- 0xa0	16 bytes	System description table truncated to 16 bytes.
-			( struct sys_desc_table_struct )
- 0xb0 - 0x13f		Free. Add more parameters here if you really need them.
- 0x140- 0x1be		EDID_INFO Video mode setup
-
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
-0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
-0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
-0x1e4	unsigned long	Scratch field for the kernel setup code
-0x1e8	char		number of entries in E820MAP (below)
-0x1e9	unsigned char	number of entries in EDDBUF (below)
-0x1ea	unsigned char	number of entries in EDD_MBR_SIG_BUFFER (below)
-0x1f1	char		size of setup.S, number of sectors
-0x1f2	unsigned short	MOUNT_ROOT_RDONLY (if !=0)
-0x1f4	unsigned short	size of compressed kernel-part in the
-			(b)zImage-file (in 16 byte units, rounded up)
-0x1f6	unsigned short	swap_dev (unused AFAIK)
-0x1f8	unsigned short	RAMDISK_FLAGS
-0x1fa	unsigned short	VGA-Mode (old one)
-0x1fc	unsigned short	ORIG_ROOT_DEV (high=Major, low=minor)
-0x1ff	char		AUX_DEVICE_INFO
-
-0x200	short jump to start of setup code aka "reserved" field.
-0x202	4 bytes		Signature for SETUP-header, ="HdrS"
-0x206	unsigned short	Version number of header format
-			Current version is 0x0201...
-0x208	8 bytes		(used by setup.S for communication with boot loaders,
-			 look there)
-0x210	char		LOADER_TYPE, = 0, old one
-			else it is set by the loader:
-			0xTV: T=0 for LILO
-				1 for Loadlin
-				2 for bootsect-loader
-				3 for SYSLINUX
-				4 for ETHERBOOT
-				5 for ELILO
-				7 for GRuB
-				8 for U-BOOT
-				9 for Xen
-				V = version
-0x211	char		loadflags:
-			bit0 = 1: kernel is loaded high (bzImage)
-			bit7 = 1: Heap and pointer (see below) set by boot
-				  loader.
-0x212	unsigned short	(setup.S)
-0x214	unsigned long	KERNEL_START, where the loader started the kernel
-0x218	unsigned long	INITRD_START, address of loaded ramdisk image
-0x21c	unsigned long	INITRD_SIZE, size in bytes of ramdisk image
-0x220	4 bytes		(setup.S)
-0x224	unsigned short	setup.S heap end pointer
-0x226   unsigned short	zero_pad
-0x228   unsigned long	cmd_line_ptr
-0x22c   unsigned long	ramdisk_max
-0x230   16 bytes 	trampoline
-0x290 - 0x2cf		EDD_MBR_SIG_BUFFER (edd.S)
-0x2d0 - 0xd00		E820MAP
-0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
-0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+The additional fields in struct boot_params as a part of 32-bit boot
+protocol of kernel. These should be filled by bootloader or 16-bit
+real-mode setup code of the kernel. References/settings to it mainly
+are in:
+
+  include/asm-x86/bootparam.h
+
+
+Offset	Proto	Name		Meaning
+/Size
+
+000/040	ALL	screen_info	Text mode or frame buffer information
+				(struct screen_info)
+040/014	ALL	apm_bios_info	APM BIOS information (struct apm_bios_info)
+060/010	ALL	ist_info	Intel SpeedStep (IST) BIOS support information
+				(struct ist_info)
+080/010	ALL	hd0_info	hd0 disk parameter, OBSOLETE!!
+090/010	ALL	hd1_info	hd1 disk parameter, OBSOLETE!!
+0A0/010	ALL	sys_desc_table	System description table (struct sys_desc_table)
+140/080	ALL	edid_info	Video mode setup (struct edid_info)
+1C0/020	ALL	efi_info	EFI 32 information (struct efi_info)
+1E0/004	ALL	alk_mem_k	Alternative mem check, in KB
+1E4/004	ALL	scratch		Scratch field for the kernel setup code
+1E8/001	ALL	e820_entries	Number of entries in e820_map (below)
+1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
+1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
+				(below)
+290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
+2D0/A00	ALL	e820_map	E820 memory map table
+				(array of struct e820entry)
+D00/1EC	ALL	eddbuf		EDD data (array of struct edd_info)
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
