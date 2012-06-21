From: akpm@linux-foundation.org
Subject: [merged] h8300-fix-use-of-extinct-_sbss-and-_ebss.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:25 -0700
Message-ID: <20120621192525.53DC7A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43415 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab2FUTZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:27 -0400
Received: by vbnl22 with SMTP id l22so95172vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: fix use of extinct _sbss and _ebss
has been removed from the -mm tree.  Its filename was
     h8300-fix-use-of-extinct-_sbss-and-_ebss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: h8300: fix use of extinct _sbss and _ebss

Nowadays it should use __bss_start and __bss_stop

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    6 +++---
 arch/h8300/mm/init.c      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/h8300/kernel/setup.c~h8300-fix-use-of-extinct-_sbss-and-_ebss arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~h8300-fix-use-of-extinct-_sbss-and-_ebss
+++ a/arch/h8300/kernel/setup.c
@@ -54,7 +54,7 @@ unsigned long memory_end;
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
+extern int _stext, _etext, _sdata, _edata, __bss_start, __bss_stop, _end;
 extern int _ramstart, _ramend;
 extern char _target_name[];
 extern void h8300_gpio_init(void);
@@ -137,10 +137,10 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
 		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
 		(int) &_sdata, (int) &_edata,
-		(int) &_sbss, (int) &_ebss);
+		(int) &__bss_start, (int) &__bss_stop);
 	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
 		"STACK=0x%06x-0x%06x\n",
-	       (int) &_ebss, (int) memory_start,
+	       (int) &__bss_stop, (int) memory_start,
 		(int) memory_start, (int) memory_end,
 		(int) memory_end, (int) &_ramend);
 #endif
diff -puN arch/h8300/mm/init.c~h8300-fix-use-of-extinct-_sbss-and-_ebss arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~h8300-fix-use-of-extinct-_sbss-and-_ebss
+++ a/arch/h8300/mm/init.c
@@ -123,7 +123,7 @@ void __init mem_init(void)
 	int codek = 0, datak = 0, initk = 0;
 	/* DAVIDM look at setup memory map generically with reserved area */
 	unsigned long tmp;
-	extern char _etext, _stext, _sdata, _ebss, __init_begin, __init_end;
+	extern char _etext, _stext, _sdata, __bss_stop, __init_begin, __init_end;
 	extern unsigned long  _ramend, _ramstart;
 	unsigned long len = &_ramend - &_ramstart;
 	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
@@ -143,7 +143,7 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 
 	codek = (&_etext - &_stext) >> 10;
-	datak = (&_ebss - &_sdata) >> 10;
+	datak = (&__bss_stop - &_sdata) >> 10;
 	initk = (&__init_begin - &__init_end) >> 10;
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
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

