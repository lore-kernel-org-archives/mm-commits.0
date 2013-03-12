From: akpm@linux-foundation.org
Subject: + mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:44 -0700
Message-ID: <20130312212244.C702131C23C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36549 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:45 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so38670yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jiang.liu@huawei.com, jonas@southpole.se


The patch titled
     Subject: mm/openrisc: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/openrisc: use common help functions to free reserved pages

Use common help functions to free reserved pages.
Also include <asm/sections.h> to avoid local declarations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/mm/init.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff -puN arch/openrisc/mm/init.c~mm-openrisc-use-common-help-functions-to-free-reserved-pages arch/openrisc/mm/init.c
--- a/arch/openrisc/mm/init.c~mm-openrisc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/openrisc/mm/init.c
@@ -43,6 +43,7 @@
 #include <asm/kmap_types.h>
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
+#include <asm/sections.h>
 
 int mem_init_done;
 
@@ -201,9 +202,6 @@ void __init paging_init(void)
 
 /* References to section boundaries */
 
-extern char _stext, _etext, _edata, __bss_start, _end;
-extern char __init_begin, __init_end;
-
 static int __init free_pages_init(void)
 {
 	int reservedpages, pfn;
@@ -263,30 +261,11 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
-	       (end - start) >> 10);
-
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	unsigned long addr;
-
-	addr = (unsigned long)(&__init_begin);
-	for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing unused kernel memory: %luk freed\n",
-	       ((unsigned long)&__init_end -
-		(unsigned long)&__init_begin) >> 10);
+	free_initmem_default(0);
 }
_

Patches currently in -mm which might be from liuj97@gmail.com are

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch

