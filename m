From: akpm@linux-foundation.org
Subject: [merged] h8300-use-the-declarations-provided-by-asm-sectionsh.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:27 -0700
Message-ID: <20120621192527.5AD69A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59484 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab2FUTZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:29 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so63386bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: use the declarations provided by <asm/sections.h>
has been removed from the -mm tree.  Its filename was
     h8300-use-the-declarations-provided-by-asm-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: h8300: use the declarations provided by <asm/sections.h>

  - Include <asm/sections.h>,
  - Remove the (different) extern declarations,
  - Remove the no longer needed address-of ('&') operators,
  - Remove the superfluous casts, use proper printk formatting instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |   23 ++++++++++-------------
 arch/h8300/mm/init.c      |   17 ++++++++---------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff -puN arch/h8300/kernel/setup.c~h8300-use-the-declarations-provided-by-asm-sectionsh arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~h8300-use-the-declarations-provided-by-asm-sectionsh
+++ a/arch/h8300/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 
 #if defined(__H8300H__)
 #define CPU "H8/300H"
@@ -54,7 +55,6 @@ unsigned long memory_end;
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-extern int _stext, _etext, _sdata, _edata, __bss_start, __bss_stop, _end;
 extern int _ramstart, _ramend;
 extern char _target_name[];
 extern void h8300_gpio_init(void);
@@ -119,9 +119,9 @@ void __init setup_arch(char **cmdline_p)
 	    memory_end = CONFIG_BLKDEV_RESERVE_ADDRESS; 
 #endif
 
-	init_mm.start_code = (unsigned long) &_stext;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
+	init_mm.start_code = (unsigned long) _stext;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
 	init_mm.brk = (unsigned long) 0; 
 
 #if (defined(CONFIG_H8300H_SIM) || defined(CONFIG_H8S_SIM)) && defined(CONFIG_GDB_MAGICPRINT)
@@ -134,15 +134,12 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "H8/300 series support by Yoshinori Sato <ysato@users.sourceforge.jp>\n");
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
-		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
-		(int) &_sdata, (int) &_edata,
-		(int) &__bss_start, (int) &__bss_stop);
-	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
-		"STACK=0x%06x-0x%06x\n",
-	       (int) &__bss_stop, (int) memory_start,
-		(int) memory_start, (int) memory_end,
-		(int) memory_end, (int) &_ramend);
+	printk(KERN_DEBUG "KERNEL -> TEXT=0x%p-0x%p DATA=0x%p-0x%p "
+		"BSS=0x%p-0x%p\n", _stext, _etext, _sdata, _edata, __bss_start,
+		__bss_stop);
+	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%p-0x%06lx MEM=0x%06lx-0x%06lx "
+		"STACK=0x%06lx-0x%p\n", __bss_stop, memory_start, memory_start,
+		memory_end, memory_end, &_ramend);
 #endif
 
 #ifdef CONFIG_DEFAULT_CMDLINE
diff -puN arch/h8300/mm/init.c~h8300-use-the-declarations-provided-by-asm-sectionsh arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~h8300-use-the-declarations-provided-by-asm-sectionsh
+++ a/arch/h8300/mm/init.c
@@ -36,6 +36,7 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 
 #undef DEBUG
 
@@ -123,7 +124,6 @@ void __init mem_init(void)
 	int codek = 0, datak = 0, initk = 0;
 	/* DAVIDM look at setup memory map generically with reserved area */
 	unsigned long tmp;
-	extern char _etext, _stext, _sdata, __bss_stop, __init_begin, __init_end;
 	extern unsigned long  _ramend, _ramstart;
 	unsigned long len = &_ramend - &_ramstart;
 	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
@@ -142,9 +142,9 @@ void __init mem_init(void)
 	/* this will put all memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
-	codek = (&_etext - &_stext) >> 10;
-	datak = (&__bss_stop - &_sdata) >> 10;
-	initk = (&__init_begin - &__init_end) >> 10;
+	codek = (_etext - _stext) >> 10;
+	datak = (__bss_stop - _sdata) >> 10;
+	initk = (__init_begin - __init_end) >> 10;
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
 	printk(KERN_INFO "Memory available: %luk/%luk RAM, %luk/%luk ROM (%dk kernel code, %dk data)\n",
@@ -178,22 +178,21 @@ free_initmem(void)
 {
 #ifdef CONFIG_RAMKERNEL
 	unsigned long addr;
-	extern char __init_begin, __init_end;
 /*
  *	the following code should be cool even if these sections
  *	are not page aligned.
  */
-	addr = PAGE_ALIGN((unsigned long)(&__init_begin));
+	addr = PAGE_ALIGN((unsigned long)(__init_begin));
 	/* next to check that the page we free is not a partial page */
-	for (; addr + PAGE_SIZE < (unsigned long)(&__init_end); addr +=PAGE_SIZE) {
+	for (; addr + PAGE_SIZE < (unsigned long)__init_end; addr +=PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
 		free_page(addr);
 		totalram_pages++;
 	}
 	printk(KERN_INFO "Freeing unused kernel memory: %ldk freed (0x%x - 0x%x)\n",
-			(addr - PAGE_ALIGN((long) &__init_begin)) >> 10,
-			(int)(PAGE_ALIGN((unsigned long)(&__init_begin))),
+			(addr - PAGE_ALIGN((long) __init_begin)) >> 10,
+			(int)(PAGE_ALIGN((unsigned long)__init_begin)),
 			(int)(addr - PAGE_SIZE));
 #endif
 }
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch

