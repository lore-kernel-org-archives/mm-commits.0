From: akpm@linux-foundation.org
Subject: + mm-m32r-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:34 -0700
Message-ID: <20130312212234.C64E55A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42442 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:36 -0400
Received: by mail-vc0-f201.google.com with SMTP id n11so38307vch.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jiang.liu@huawei.com, takata@linux-m32r.org


The patch titled
     Subject: mm/m32r: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-m32r-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/m32r: use common help functions to free reserved pages

Use common help functions to free reserved pages.
Also include <asm/sections.h> to avoid local declarations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/init.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff -puN arch/m32r/mm/init.c~mm-m32r-use-common-help-functions-to-free-reserved-pages arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-m32r-use-common-help-functions-to-free-reserved-pages
+++ a/arch/m32r/mm/init.c
@@ -28,10 +28,7 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/tlb.h>
-
-/* References to section boundaries */
-extern char _text, _etext, _edata;
-extern char __init_begin, __init_end;
+#include <asm/sections.h>
 
 pgd_t swapper_pg_dir[1024];
 
@@ -184,17 +181,7 @@ void __init mem_init(void)
  *======================================================================*/
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
-	printk (KERN_INFO "Freeing unused kernel memory: %dk freed\n", \
-	  (int)(&__init_end - &__init_begin) >> 10);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -204,13 +191,6 @@ void free_initmem(void)
  *======================================================================*/
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	unsigned long p;
-	for (p = start; p < end; p += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(p));
-		init_page_count(virt_to_page(p));
-		free_page(p);
-		totalram_pages++;
-	}
-	printk (KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
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

