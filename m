From: akpm@linux-foundation.org
Subject: [merged] xtensa-use-the-declarations-provided-by-asm-sectionsh.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:23 -0700
Message-ID: <20120621192523.543FFA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63056 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab2FUTZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:25 -0400
Received: by wgbdt11 with SMTP id dt11so63590wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: use the declarations provided by <asm/sections.h>
has been removed from the -mm tree.  Its filename was
     xtensa-use-the-declarations-provided-by-asm-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: xtensa: use the declarations provided by <asm/sections.h>

  - Include <asm/sections.h>,
  - Remove the (different) extern declarations,
  - Remove the no longer needed address-of ('&') operators,
  - Use %p to format pointer differences.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN arch/xtensa/mm/init.c~xtensa-use-the-declarations-provided-by-asm-sectionsh arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-use-the-declarations-provided-by-asm-sectionsh
+++ a/arch/xtensa/mm/init.c
@@ -26,11 +26,7 @@
 
 #include <asm/bootparam.h>
 #include <asm/page.h>
-
-/* References to section boundaries */
-
-extern char _stext, _etext, _sdata, _edata, _rodata_end;
-extern char __init_begin, __init_end;
+#include <asm/sections.h>
 
 /*
  * mem_reserve(start, end, must_exist)
@@ -197,9 +193,9 @@ void __init mem_init(void)
 			reservedpages++;
 	}
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_sdata;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
+	codesize =  (unsigned long) _etext - (unsigned long) _stext;
+	datasize =  (unsigned long) _edata - (unsigned long) _sdata;
+	initsize =  (unsigned long) __init_end - (unsigned long) __init_begin;
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
 	       "%ldk data, %ldk init %ldk highmem)\n",
@@ -237,7 +233,7 @@ void free_initrd_mem(unsigned long start
 
 void free_initmem(void)
 {
-	free_reserved_mem(&__init_begin, &__init_end);
-	printk("Freeing unused kernel memory: %dk freed\n",
-	       (&__init_end - &__init_begin) >> 10);
+	free_reserved_mem(__init_begin, __init_end);
+	printk("Freeing unused kernel memory: %zuk freed\n",
+	       (__init_end - __init_begin) >> 10);
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

