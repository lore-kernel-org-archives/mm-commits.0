From: akpm@linux-foundation.org
Subject: + xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:16:11 -0700
Message-ID: <20120611221612.5C3A6A026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54690 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2FKWQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:16:14 -0400
Received: by bkty5 with SMTP id y5so251770bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:16:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, chris@zankel.net, rostedt@goodmis.org


The patch titled
     Subject: xtensa: replace xtensa-specific _f{data,text} by _s{data,text}
has been added to the -mm tree.  Its filename is
     xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch

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
Subject: Subject: xtensa: replace xtensa-specific _f{data,text} by _s{data,text}

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch
xtensa-use-test-e-instead-of-bashism-test-a.patch
xtensa-use-the-declarations-provided-by-asm-sectionsh.patch

