From: akpm@linux-foundation.org
Subject: + h8300-fix-use-of-extinct-_sbss-and-_ebss.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:23:59 -0700
Message-ID: <20120611222400.19CB1A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50048 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2FKWYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:24:03 -0400
Received: by fat25 with SMTP id 25so252098fat.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:24:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300: fix use of extinct _sbss and _ebss
has been added to the -mm tree.  Its filename is
     h8300-fix-use-of-extinct-_sbss-and-_ebss.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: h8300: fix use of extinct _sbss and _ebss

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch
xtensa-use-test-e-instead-of-bashism-test-a.patch
xtensa-use-the-declarations-provided-by-asm-sectionsh.patch
h8300-fix-use-of-extinct-_sbss-and-_ebss.patch
h8300-use-the-declarations-provided-by-asm-sectionsh.patch

