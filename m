From: akpm@osdl.org
Subject: + disable-init-initramfsc-architectures.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:39:36 -0800
Message-ID: <200612142139.kBELdaHG028932@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947AbWLNVjl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:39:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jean-paul.saman@nxp.com, linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     disable init/initramfs.c: architectures
has been added to the -mm tree.  Its filename is
     disable-init-initramfsc-architectures.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: disable init/initramfs.c: architectures
From: Jean-Paul Saman <jean-paul.saman@nxp.com>

Update all arch/*/kernel/vmlinux.lds.S to not include space for initramfs
when CONFIG_BLK_DEV_INITRAMFS is not selected.  This saves another 4 kbytes
on most platfoms (some reserve PAGE_SIZE for initramfs).

Signed-off-by: Jean-Paul Saman <jean-paul.saman@nxp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/kernel/vmlinux.lds.S            |    2 ++
 arch/arm/kernel/vmlinux.lds.S              |    2 ++
 arch/arm26/kernel/vmlinux-arm26-xip.lds.in |    2 ++
 arch/arm26/kernel/vmlinux-arm26.lds.in     |    2 ++
 arch/avr32/kernel/vmlinux.lds.c            |    2 ++
 arch/cris/arch-v10/vmlinux.lds.S           |    4 +++-
 arch/cris/arch-v32/vmlinux.lds.S           |    2 ++
 arch/frv/kernel/vmlinux.lds.S              |    2 ++
 arch/h8300/kernel/vmlinux.lds.S            |    2 ++
 arch/i386/kernel/vmlinux.lds.S             |    2 ++
 arch/ia64/kernel/vmlinux.lds.S             |    2 ++
 arch/m32r/kernel/vmlinux.lds.S             |    4 ++++
 arch/m68k/kernel/vmlinux-std.lds           |    2 ++
 arch/m68k/kernel/vmlinux-sun3.lds          |    2 ++
 arch/m68knommu/kernel/vmlinux.lds.S        |    2 ++
 arch/mips/kernel/vmlinux.lds.S             |    2 ++
 arch/parisc/kernel/vmlinux.lds.S           |    2 ++
 arch/powerpc/kernel/vmlinux.lds.S          |    4 ++--
 arch/ppc/kernel/vmlinux.lds.S              |    2 ++
 arch/s390/kernel/vmlinux.lds.S             |    3 +++
 arch/sh/kernel/vmlinux.lds.S               |    4 ++++
 arch/sh64/kernel/vmlinux.lds.S             |    4 ++++
 arch/sparc/kernel/vmlinux.lds.S            |    4 ++++
 arch/sparc64/kernel/vmlinux.lds.S          |    4 ++++
 arch/v850/kernel/vmlinux.lds.S             |    4 ++++
 arch/x86_64/kernel/vmlinux.lds.S           |    4 ++++
 arch/xtensa/kernel/vmlinux.lds.S           |    2 ++
 27 files changed, 70 insertions(+), 3 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -52,10 +52,12 @@ SECTIONS
   }
   __initcall_end = .;
 
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(8192);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
 
   . = ALIGN(8);
   .con_initcall.init : {
diff -puN arch/arm/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -53,10 +53,12 @@ SECTIONS
 		__security_initcall_start = .;
 			*(.security_initcall.init)
 		__security_initcall_end = .;
+#ifdef CONFIG_BLK_DEV_INITRD
 		. = ALIGN(32);
 		__initramfs_start = .;
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
+#endif
 		. = ALIGN(64);
 		__per_cpu_start = .;
 			*(.data.percpu)
diff -puN arch/arm26/kernel/vmlinux-arm26-xip.lds.in~disable-init-initramfsc-architectures arch/arm26/kernel/vmlinux-arm26-xip.lds.in
--- a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in~disable-init-initramfsc-architectures
+++ a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
@@ -46,10 +46,12 @@ SECTIONS
 		__con_initcall_start = .;
 			*(.con_initcall.init)
 		__con_initcall_end = .;
+#ifdef CONFIG_BLK_DEV_INITRD
 		. = ALIGN(32);
 		__initramfs_start = .;
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
+#endif
 		. = ALIGN(32768);
 		__init_end = .;
 	}
diff -puN arch/arm26/kernel/vmlinux-arm26.lds.in~disable-init-initramfsc-architectures arch/arm26/kernel/vmlinux-arm26.lds.in
--- a/arch/arm26/kernel/vmlinux-arm26.lds.in~disable-init-initramfsc-architectures
+++ a/arch/arm26/kernel/vmlinux-arm26.lds.in
@@ -47,10 +47,12 @@ SECTIONS
 		__con_initcall_start = .;
 			*(.con_initcall.init)
 		__con_initcall_end = .;
+#ifdef CONFIG_BLK_DEV_INITRD
 		. = ALIGN(32);
 		__initramfs_start = .;
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
+#endif
 		. = ALIGN(32768);
 		__init_end = .;
 	}
diff -puN arch/avr32/kernel/vmlinux.lds.c~disable-init-initramfsc-architectures arch/avr32/kernel/vmlinux.lds.c
--- a/arch/avr32/kernel/vmlinux.lds.c~disable-init-initramfsc-architectures
+++ a/arch/avr32/kernel/vmlinux.lds.c
@@ -46,10 +46,12 @@ SECTIONS
 		__security_initcall_start = .;
 			*(.security_initcall.init)
 		__security_initcall_end = .;
+#ifdef CONFIG_BLK_DEV_INITRD
 		. = ALIGN(32);
 		__initramfs_start = .;
 			*(.init.ramfs)
 		__initramfs_end = .;
+#endif
 		. = ALIGN(4096);
 		__init_end = .;
 	}
diff -puN arch/cris/arch-v10/vmlinux.lds.S~disable-init-initramfsc-architectures arch/cris/arch-v10/vmlinux.lds.S
--- a/arch/cris/arch-v10/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/cris/arch-v10/vmlinux.lds.S
@@ -82,7 +82,8 @@ SECTIONS
 		__con_initcall_end = .;
 	}	
 	SECURITY_INIT
-		
+
+#ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
 		__initramfs_start = .;
 		*(.init.ramfs)
@@ -93,6 +94,7 @@ SECTIONS
 		FILL (0); 
 		. = ALIGN (8192);
 	}
+#endif
 	
 	__vmlinux_end = .;            /* last address of the physical file */
   	__init_end = .;
diff -puN arch/cris/arch-v32/vmlinux.lds.S~disable-init-initramfsc-architectures arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/cris/arch-v32/vmlinux.lds.S
@@ -95,6 +95,7 @@ SECTIONS
 	.data.percpu  : { *(.data.percpu) }
 	__per_cpu_end = .;
 
+#ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
 		__initramfs_start = .;
 		*(.init.ramfs)
@@ -107,6 +108,7 @@ SECTIONS
 		FILL (0);
 		. = ALIGN (8192);
 	}
+#endif
 
 	__vmlinux_end = .;	/* Last address of the physical file. */
   	__init_end = .;
diff -puN arch/frv/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -61,10 +61,12 @@ SECTIONS
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
 
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
 
   . = ALIGN(THREAD_SIZE);
   __init_end = .;
diff -puN arch/h8300/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/h8300/kernel/vmlinux.lds.S
--- a/arch/h8300/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/h8300/kernel/vmlinux.lds.S
@@ -126,10 +126,12 @@ SECTIONS
 	___con_initcall_end = .;
 		*(.exit.text)
 		*(.exit.data)
+#if defined(CONFIG_BLK_DEV_INITRD)
 		. = ALIGN(4);
 	___initramfs_start = .;
   		*(.init.ramfs)
   	___initramfs_end = .;
+#endif
 	. = ALIGN(0x4) ;
 	___init_end = .;
 	__edata = . ;
diff -puN arch/i386/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -184,12 +184,14 @@ SECTIONS
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
+#if defined(CONFIG_BLK_DEV_INITRD)
   . = ALIGN(4096);
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 	__initramfs_start = .;
 	*(.init.ramfs)
 	__initramfs_end = .;
   }
+#endif
   . = ALIGN(L1_CACHE_BYTES);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
diff -puN arch/ia64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -115,12 +115,14 @@ SECTIONS
   .init.data : AT(ADDR(.init.data) - LOAD_OFFSET)
 	{ *(.init.data) }
 
+#ifdef CONFIG_BLK_DEV_INITRD
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET)
 	{
 	  __initramfs_start = .;
 	  *(.init.ramfs)
 	  __initramfs_end = .;
 	}
+#endif
 
    . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET)
diff -puN arch/m32r/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -102,10 +102,14 @@ SECTIONS
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
   .exit.data : { *(.exit.data) }
+
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
+
   . = ALIGN(32);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
diff -puN arch/m68k/kernel/vmlinux-std.lds~disable-init-initramfsc-architectures arch/m68k/kernel/vmlinux-std.lds
--- a/arch/m68k/kernel/vmlinux-std.lds~disable-init-initramfsc-architectures
+++ a/arch/m68k/kernel/vmlinux-std.lds
@@ -61,10 +61,12 @@ SECTIONS
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(8192);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
   . = ALIGN(8192);
   __init_end = .;
 
diff -puN arch/m68k/kernel/vmlinux-sun3.lds~disable-init-initramfsc-architectures arch/m68k/kernel/vmlinux-sun3.lds
--- a/arch/m68k/kernel/vmlinux-sun3.lds~disable-init-initramfsc-architectures
+++ a/arch/m68k/kernel/vmlinux-sun3.lds
@@ -55,10 +55,12 @@ __init_begin = .;
 	.con_initcall.init : { *(.con_initcall.init) }
 	__con_initcall_end = .;
 	SECURITY_INIT
+#ifdef CONFIG_BLK_DEV_INITRD
 	. = ALIGN(8192);
 	__initramfs_start = .;
 	.init.ramfs : { *(.init.ramfs) }
 	__initramfs_end = .;
+#endif
 	. = ALIGN(8192);
 	__init_end = .;
 	.data.init.task : { *(.data.init_task) }
diff -puN arch/m68knommu/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/m68knommu/kernel/vmlinux.lds.S
--- a/arch/m68knommu/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/m68knommu/kernel/vmlinux.lds.S
@@ -149,10 +149,12 @@ SECTIONS {
 		__security_initcall_start = .;
 		*(.security_initcall.init)
 		__security_initcall_end = .;
+#ifdef CONFIG_BLK_DEV_INITRD
 		. = ALIGN(4);
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
+#endif
 		. = ALIGN(4096);
 		__init_end = .;
 	} > INIT
diff -puN arch/mips/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -113,10 +113,12 @@ SECTIONS
      references from .rodata */
   .exit.text : { *(.exit.text) }
   .exit.data : { *(.exit.data) }
+#if defined(CONFIG_BLK_DEV_INITRD)
   . = ALIGN(_PAGE_SIZE);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
   . = ALIGN(32);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
diff -puN arch/parisc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -173,10 +173,12 @@ SECTIONS
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
   .exit.data : { *(.exit.data) }
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(ASM_PAGE_SIZE);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
   . = ALIGN(32);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
diff -puN arch/powerpc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -131,14 +131,14 @@ SECTIONS
 		__stop___fw_ftr_fixup = .;
 	}
 #endif
-
+#ifdef CONFIG_BLK_DEV_INITRD
 	. = ALIGN(PAGE_SIZE);
 	.init.ramfs : {
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
 	}
-
+#endif
 #ifdef CONFIG_PPC32
 	. = ALIGN(32);
 #else
diff -puN arch/ppc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/ppc/kernel/vmlinux.lds.S
@@ -135,10 +135,12 @@ SECTIONS
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
 
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
 
   . = ALIGN(4096);
   __init_end = .;
diff -puN arch/s390/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -90,11 +90,14 @@ SECTIONS
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
+
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(256);
   __initramfs_start = .;
   .init.ramfs : { *(.init.initramfs) }
   . = ALIGN(2);
   __initramfs_end = .;
+#endif
   . = ALIGN(256);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
diff -puN arch/sh/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -83,9 +83,13 @@ SECTIONS
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
+
+#ifdef CONFIG_BLK_DEV_INITRD
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
+
   __machvec_start = .;
   .init.machvec : { *(.init.machvec) }
   __machvec_end = .;
diff -puN arch/sh64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/sh64/kernel/vmlinux.lds.S
--- a/arch/sh64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/sh64/kernel/vmlinux.lds.S
@@ -115,9 +115,13 @@ SECTIONS
   .con_initcall.init : C_PHYS(.con_initcall.init) { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
+
+#ifdef CONFIG_BLK_DEV_INITRD
   __initramfs_start = .;
   .init.ramfs : C_PHYS(.init.ramfs) { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
+
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
diff -puN arch/sparc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -57,10 +57,14 @@ SECTIONS
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
+
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
+
   . = ALIGN(32);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
diff -puN arch/sparc64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/sparc64/kernel/vmlinux.lds.S
--- a/arch/sparc64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/sparc64/kernel/vmlinux.lds.S
@@ -81,10 +81,14 @@ SECTIONS
   __sun4v_2insn_patch = .;
   .sun4v_2insn_patch : { *(.sun4v_2insn_patch) }
   __sun4v_2insn_patch_end = .;
+
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(8192); 
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
+
   . = ALIGN(8192);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
diff -puN arch/v850/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/v850/kernel/vmlinux.lds.S
--- a/arch/v850/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/v850/kernel/vmlinux.lds.S
@@ -190,12 +190,16 @@
 		__root_fs_image_start = . ;				      \
 		*(.root)						      \
 		__root_fs_image_end = . ;
+
+#ifdef CONFIG_BLK_DEV_INITRD
 /* The initramfs archive.  */
 #define INITRAMFS_CONTENTS						      \
 		. = ALIGN (4) ;						      \
 		___initramfs_start = . ;				      \
 			*(.init.ramfs)					      \
 		___initramfs_end = . ;
+#endif
+
 /* Where the initial bootmap (bitmap for the boot-time memory allocator) 
    should be place.  */
 #define BOOTMAP_CONTENTS						      \
diff -puN arch/x86_64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -186,10 +186,14 @@ SECTIONS
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
+
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
+
     . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
   __per_cpu_start = .;
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
diff -puN arch/xtensa/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~disable-init-initramfsc-architectures
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -203,10 +203,12 @@ SECTIONS
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
 
+#ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start =.;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
+#endif
 
   /* We need this dummy segment here */
 
_

Patches currently in -mm which might be from jean-paul.saman@nxp.com are

disable-init-initramfsc-updated.patch
disable-init-initramfsc-architectures.patch

