From: akpm@linux-foundation.org
Subject: - markers-use-extra_rwdata-in-architectures.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:34 -0700
Message-ID: <200705102232.l4AMWYxs032632@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759523AbXEJWcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     markers: use EXTRA_RWDATA in architectures
has been removed from the -mm tree.  Its filename was
     markers-use-extra_rwdata-in-architectures.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: markers: use EXTRA_RWDATA in architectures
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <>
---

 arch/alpha/kernel/vmlinux.lds.S            |    1 +
 arch/arm/kernel/vmlinux.lds.S              |    1 +
 arch/arm26/kernel/vmlinux-arm26-xip.lds.in |    1 +
 arch/arm26/kernel/vmlinux-arm26.lds.in     |    1 +
 arch/avr32/kernel/vmlinux.lds.c            |    1 +
 arch/cris/arch-v10/vmlinux.lds.S           |    1 +
 arch/cris/arch-v32/vmlinux.lds.S           |    1 +
 arch/frv/kernel/vmlinux.lds.S              |    1 +
 arch/h8300/kernel/vmlinux.lds.S            |    4 +++-
 arch/i386/kernel/vmlinux.lds.S             |    1 +
 arch/ia64/kernel/vmlinux.lds.S             |    2 +-
 arch/m32r/kernel/vmlinux.lds.S             |    1 +
 arch/m68k/kernel/vmlinux-std.lds           |    1 +
 arch/m68k/kernel/vmlinux-sun3.lds          |    1 +
 arch/m68knommu/kernel/vmlinux.lds.S        |    1 +
 arch/mips/kernel/vmlinux.lds.S             |    2 ++
 arch/parisc/kernel/vmlinux.lds.S           |    1 +
 arch/powerpc/kernel/vmlinux.lds.S          |    2 ++
 arch/ppc/kernel/vmlinux.lds.S              |    1 +
 arch/s390/kernel/vmlinux.lds.S             |    1 +
 arch/sh/kernel/vmlinux.lds.S               |    1 +
 arch/sh64/kernel/vmlinux.lds.S             |    1 +
 arch/sparc/kernel/vmlinux.lds.S            |    1 +
 arch/sparc64/kernel/vmlinux.lds.S          |    1 +
 arch/um/kernel/dyn.lds.S                   |    1 +
 arch/um/kernel/uml.lds.S                   |    1 +
 arch/v850/kernel/vmlinux.lds.S             |    1 +
 arch/x86_64/kernel/vmlinux.lds.S           |    1 +
 arch/xtensa/kernel/vmlinux.lds.S           |    2 +-
 29 files changed, 33 insertions(+), 3 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -87,6 +87,7 @@ SECTIONS
   _data = .;
   .data : {					/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
   }
 
diff -puN arch/arm/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -156,6 +156,7 @@ SECTIONS
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
diff -puN arch/arm26/kernel/vmlinux-arm26-xip.lds.in~markers-use-extra_rwdata-in-architectures arch/arm26/kernel/vmlinux-arm26-xip.lds.in
--- a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in~markers-use-extra_rwdata-in-architectures
+++ a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
@@ -112,6 +112,7 @@ SECTIONS
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		*(.init.data)
diff -puN arch/arm26/kernel/vmlinux-arm26.lds.in~markers-use-extra_rwdata-in-architectures arch/arm26/kernel/vmlinux-arm26.lds.in
--- a/arch/arm26/kernel/vmlinux-arm26.lds.in~markers-use-extra_rwdata-in-architectures
+++ a/arch/arm26/kernel/vmlinux-arm26.lds.in
@@ -107,6 +107,7 @@ SECTIONS
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
diff -puN arch/avr32/kernel/vmlinux.lds.c~markers-use-extra_rwdata-in-architectures arch/avr32/kernel/vmlinux.lds.c
--- a/arch/avr32/kernel/vmlinux.lds.c~markers-use-extra_rwdata-in-architectures
+++ a/arch/avr32/kernel/vmlinux.lds.c
@@ -113,6 +113,7 @@ SECTIONS
 		/* And the rest... */
 		*(.data.rel*)
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
diff -puN arch/cris/arch-v10/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/cris/arch-v10/vmlinux.lds.S
--- a/arch/cris/arch-v10/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/cris/arch-v10/vmlinux.lds.S
@@ -45,6 +45,7 @@ SECTIONS
 	__Sdata = . ;
 	.data : {                     /* Data */
 		*(.data)
+		EXTRA_RWDATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
diff -puN arch/cris/arch-v32/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/cris/arch-v32/vmlinux.lds.S
@@ -50,6 +50,7 @@ SECTIONS
 	__Sdata = . ;
 	.data : {                     /* Data */
 		*(.data)
+		EXTRA_RWDATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
diff -puN arch/frv/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -134,6 +134,7 @@ SECTIONS
   .data : {			/* Data */
 	*(.data .data.*)
 	*(.exit.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
diff -puN arch/h8300/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/h8300/kernel/vmlinux.lds.S
--- a/arch/h8300/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/h8300/kernel/vmlinux.lds.S
@@ -105,7 +105,9 @@ SECTIONS
 	. = ALIGN(0x4) ;
 		*(.data)
 	. = ALIGN(0x4) ;
-		*(.data.*)	
+		*(.data.*)
+	. = ALIGN(0x4) ;
+	EXTRA_RWDATA
 
 	. = ALIGN(0x4) ;
 	___init_begin = .;
diff -puN arch/i386/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -77,6 +77,7 @@ SECTIONS
   . = ALIGN(4096);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	} :data
 
diff -puN arch/ia64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -215,7 +215,7 @@ SECTIONS
 
   data : { } :data
   .data : AT(ADDR(.data) - LOAD_OFFSET)
-	{ *(.data) *(.data1) *(.gnu.linkonce.d*) CONSTRUCTORS }
+	{ *(.data) *(.data1) *(.gnu.linkonce.d*) EXTRA_RWDATA CONSTRUCTORS }
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
   .got : AT(ADDR(.got) - LOAD_OFFSET)
diff -puN arch/m32r/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -51,6 +51,7 @@ SECTIONS
 	*(.spu)
 	*(.spi)
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
diff -puN arch/m68k/kernel/vmlinux-std.lds~markers-use-extra_rwdata-in-architectures arch/m68k/kernel/vmlinux-std.lds
--- a/arch/m68k/kernel/vmlinux-std.lds~markers-use-extra_rwdata-in-architectures
+++ a/arch/m68k/kernel/vmlinux-std.lds
@@ -29,6 +29,7 @@ SECTIONS
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
diff -puN arch/m68k/kernel/vmlinux-sun3.lds~markers-use-extra_rwdata-in-architectures arch/m68k/kernel/vmlinux-sun3.lds
--- a/arch/m68k/kernel/vmlinux-sun3.lds~markers-use-extra_rwdata-in-architectures
+++ a/arch/m68k/kernel/vmlinux-sun3.lds
@@ -24,6 +24,7 @@ SECTIONS
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
diff -puN arch/m68knommu/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/m68knommu/kernel/vmlinux.lds.S
--- a/arch/m68knommu/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/m68knommu/kernel/vmlinux.lds.S
@@ -134,6 +134,7 @@ SECTIONS {
 		. = ALIGN(4);
 		_sdata = . ;
 		*(.data)
+		EXTRA_RWDATA
 		. = ALIGN(8192) ;
 		*(.data.init_task)
 		_edata = . ;
diff -puN arch/mips/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -64,6 +64,8 @@ SECTIONS
 
     *(.data)
 
+    EXTRA_RWDATA
+
     CONSTRUCTORS
   }
   _gp = . + 0x8000;
diff -puN arch/parisc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -92,6 +92,7 @@ SECTIONS
   . = ALIGN(L1_CACHE_BYTES);
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
diff -puN arch/powerpc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -165,11 +165,13 @@ SECTIONS
 		*(.data)
 		*(.sdata)
 		*(.got.plt) *(.got)
+		EXTRA_RWDATA
 	}
 #else
 	.data : {
 		*(.data .data.rel* .toc1)
 		*(.branch_lt)
+		EXTRA_RWDATA
 	}
 
 	.opd : {
diff -puN arch/ppc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/ppc/kernel/vmlinux.lds.S
@@ -73,6 +73,7 @@ SECTIONS
     *(.sdata2)
     *(.got.plt) *(.got)
     *(.dynamic)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
 
diff -puN arch/s390/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -49,6 +49,7 @@ SECTIONS
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
diff -puN arch/sh/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -42,6 +42,7 @@ SECTIONS
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 
  	 /* Align the initial ramdisk image (INITRD) on page boundaries. */
  	 . = ALIGN(PAGE_SIZE);
diff -puN arch/sh64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/sh64/kernel/vmlinux.lds.S
--- a/arch/sh64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/sh64/kernel/vmlinux.lds.S
@@ -79,6 +79,7 @@ SECTIONS
 
   .data : C_PHYS(.data) {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
diff -puN arch/sparc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -23,6 +23,7 @@ SECTIONS
   .data    :
   {
     *(.data)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff -puN arch/sparc64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/sparc64/kernel/vmlinux.lds.S
--- a/arch/sparc64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/sparc64/kernel/vmlinux.lds.S
@@ -28,6 +28,7 @@ SECTIONS
   .data    :
   {
     *(.data)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff -puN arch/um/kernel/dyn.lds.S~markers-use-extra_rwdata-in-architectures arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/um/kernel/dyn.lds.S
@@ -98,6 +98,7 @@ SECTIONS
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
     *(.data.init_task)
     *(.data .data.* .gnu.linkonce.d.*)
+    EXTRA_RWDATA
     SORT(CONSTRUCTORS)
   }
   .data1          : { *(.data1) }
diff -puN arch/um/kernel/uml.lds.S~markers-use-extra_rwdata-in-architectures arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/um/kernel/uml.lds.S
@@ -61,6 +61,7 @@ SECTIONS
     *(.data.init_task)
     *(.data)
     *(.gnu.linkonce.d*)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff -puN arch/v850/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/v850/kernel/vmlinux.lds.S
--- a/arch/v850/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/v850/kernel/vmlinux.lds.S
@@ -116,6 +116,7 @@
         	*(.data)						      \
 			*(.exit.data)	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
+		EXTRA_RWDATA						      \
 		. = ALIGN (16) ;					      \
 		*(.data.cacheline_aligned)				      \
 		. = ALIGN (0x2000) ;					      \
diff -puN arch/x86_64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -56,6 +56,7 @@ SECTIONS
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	} :data
 
diff -puN arch/xtensa/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~markers-use-extra_rwdata-in-architectures
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -144,7 +144,7 @@ SECTIONS
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    *(.data) EXTRA_RWDATA CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
