From: akpm@osdl.org
Subject: + sun3-general-updates.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:33:22 -0800
Message-ID: <200612092233.kB9MXMIU006103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846AbWLIWeJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sammy@sammy.net, geert@linux-m68k.org


The patch titled
     Sun3: General updates
has been added to the -mm tree.  Its filename is
     sun3-general-updates.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sun3: General updates
From: Sam Creasey <sammy@sammy.net>

General compile fixes for 2.6.16 for sun3, and some updates to make the new
bootloader work correctly.  Tested on 3/50, 3/60, 3/80.

Signed-off-by: Sam Creasey <sammy@sammy.net>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m68k/kernel/sun3-head.S      |   10 ----------
 arch/m68k/kernel/vmlinux-sun3.lds |    2 +-
 arch/m68k/mm/sun3mmu.c            |    7 +++++--
 include/asm-m68k/sun3-head.h      |    1 -
 include/asm-m68k/sun3ints.h       |    1 +
 5 files changed, 7 insertions(+), 14 deletions(-)

diff -puN arch/m68k/kernel/sun3-head.S~sun3-general-updates arch/m68k/kernel/sun3-head.S
--- a/arch/m68k/kernel/sun3-head.S~sun3-general-updates
+++ a/arch/m68k/kernel/sun3-head.S
@@ -67,16 +67,6 @@ ENTRY(_start)
 1:	lea	init_task,%curptr			| get initial thread...
 	lea	init_thread_union+THREAD_SIZE,%sp	| ...and its stack.
 
-/* copy bootinfo records from the loader to _end */
-	lea	_end, %a1
-	lea	BI_START, %a0
-	/* number of longs to copy */
-	movel	%a0@, %d0
-1:	addl	#4, %a0
-	movel   %a0@, %a1@
-	addl	#4, %a1
-	dbf	%d0, 1b
-
 /* Point MSP at an invalid page to trap if it's used. --m */
 	movl	#(PAGESIZE),%d0
 	movc	%d0,%msp
diff -puN arch/m68k/kernel/vmlinux-sun3.lds~sun3-general-updates arch/m68k/kernel/vmlinux-sun3.lds
--- a/arch/m68k/kernel/vmlinux-sun3.lds~sun3-general-updates
+++ a/arch/m68k/kernel/vmlinux-sun3.lds
@@ -8,7 +8,7 @@ ENTRY(_start)
 jiffies = jiffies_64 + 4;
 SECTIONS
 {
-  . = 0xE004000;
+  . = 0xE002000;
   _text = .;			/* Text and read-only data */
   .text : {
 	*(.head)
diff -puN arch/m68k/mm/sun3mmu.c~sun3-general-updates arch/m68k/mm/sun3mmu.c
--- a/arch/m68k/mm/sun3mmu.c~sun3-general-updates
+++ a/arch/m68k/mm/sun3mmu.c
@@ -49,7 +49,6 @@ void __init paging_init(void)
 	unsigned long zones_size[MAX_NR_ZONES] = { 0, };
 	unsigned long size;
 
-
 #ifdef TEST_VERIFY_AREA
 	wp_works_ok = 0;
 #endif
@@ -94,7 +93,11 @@ void __init paging_init(void)
 	/* memory sizing is a hack stolen from motorola.c..  hope it works for us */
 	zones_size[ZONE_DMA] = ((unsigned long)high_memory - PAGE_OFFSET) >> PAGE_SHIFT;
 
-	free_area_init(zones_size);
+	/* I really wish I knew why the following change made things better...  -- Sam */
+/*	free_area_init(zones_size); */
+	free_area_init_node(0, NODE_DATA(0), zones_size,
+			    (__pa(PAGE_OFFSET) >> PAGE_SHIFT) + 1, NULL);
+
 
 }
 
diff -puN include/asm-m68k/sun3-head.h~sun3-general-updates include/asm-m68k/sun3-head.h
--- a/include/asm-m68k/sun3-head.h~sun3-general-updates
+++ a/include/asm-m68k/sun3-head.h
@@ -4,7 +4,6 @@
 
 #define KERNBASE        0xE000000  /* First address the kernel will eventually be */
 #define LOAD_ADDR       0x4000      /* prom jumps to us here unless this is elf /boot */
-#define BI_START (KERNBASE + 0x3000) /* beginning of the bootinfo records */
 #define FC_CONTROL  3
 #define FC_SUPERD    5
 #define FC_CPU      7
diff -puN include/asm-m68k/sun3ints.h~sun3-general-updates include/asm-m68k/sun3ints.h
--- a/include/asm-m68k/sun3ints.h~sun3-general-updates
+++ a/include/asm-m68k/sun3ints.h
@@ -16,6 +16,7 @@
 #include <asm/intersil.h>
 #include <asm/oplib.h>
 #include <asm/traps.h>
+#include <asm/irq.h>
 
 #define SUN3_INT_VECS 192
 
_

Patches currently in -mm which might be from sammy@sammy.net are

sun3-general-updates.patch
sun3-scsi-make-sun3-scsi-drivers-compile-work-again.patch

