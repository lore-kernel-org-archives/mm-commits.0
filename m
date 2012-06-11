From: akpm@linux-foundation.org
Subject: + xtensa-use-the-declarations-provided-by-asm-sectionsh.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:16:16 -0700
Message-ID: <20120611221617.10D5DA026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54690 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2FKWQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:16:18 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so251770bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:16:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, chris@zankel.net


The patch titled
     Subject: xtensa: use the declarations provided by <asm/sections.h>
has been added to the -mm tree.  Its filename is
     xtensa-use-the-declarations-provided-by-asm-sectionsh.patch

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
Subject: Subject: xtensa: use the declarations provided by <asm/sections.h>

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch
xtensa-use-test-e-instead-of-bashism-test-a.patch
xtensa-use-the-declarations-provided-by-asm-sectionsh.patch

