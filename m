From: akpm@linux-foundation.org
Subject: [merged] xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:19 -0700
Message-ID: <20120621192519.6D047A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38655 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2FUTZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:20 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so50048yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, chris@zankel.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: replace xtensa-specific _f{data,text} by _s{data,text}
has been removed from the -mm tree.  Its filename was
     xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: xtensa: replace xtensa-specific _f{data,text} by _s{data,text}

commit a2d063ac216c161 ("extable, core_kernel_data(): Make sure all archs
define _sdata") missed xtensa.  Xtensa does have a start of data marker,
but calls it _fdata, causing

    kernel/built-in.o:(.text+0x964): undefined reference to `_sdata'

_stext was already defined, but it was duplicated by _fdata.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/vmlinux.lds.S |    3 +--
 arch/xtensa/mm/init.c            |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/xtensa/kernel/vmlinux.lds.S~xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -83,7 +83,6 @@ SECTIONS
 
   _text = .;
   _stext = .;
-  _ftext = .;
 
   .text :
   {
@@ -112,7 +111,7 @@ SECTIONS
   EXCEPTION_TABLE(16)
   /* Data section */
 
-  _fdata = .;
+  _sdata = .;
   RW_DATA_SECTION(XCHAL_ICACHE_LINESIZE, PAGE_SIZE, THREAD_SIZE)
   _edata = .;
 
diff -puN arch/xtensa/mm/init.c~xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext
+++ a/arch/xtensa/mm/init.c
@@ -29,7 +29,7 @@
 
 /* References to section boundaries */
 
-extern char _ftext, _etext, _fdata, _edata, _rodata_end;
+extern char _stext, _etext, _sdata, _edata, _rodata_end;
 extern char __init_begin, __init_end;
 
 /*
@@ -197,8 +197,8 @@ void __init mem_init(void)
 			reservedpages++;
 	}
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_ftext;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_fdata;
+	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
+	datasize =  (unsigned long) &_edata - (unsigned long) &_sdata;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
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

