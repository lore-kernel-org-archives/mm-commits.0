From: akpm@linux-foundation.org
Subject: + mm-metag-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:23:08 -0700
Message-ID: <20130312212308.C4BFB31C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:52530 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:23:09 -0400
Received: by mail-ye0-f202.google.com with SMTP id q5so38475yen.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:23:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, james.hogan@imgtec.com, jiang.liu@huawei.com


The patch titled
     Subject: mm/metag: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-metag-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/metag: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/mm/init.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff -puN arch/metag/mm/init.c~mm-metag-use-common-help-functions-to-free-reserved-pages arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-metag-use-common-help-functions-to-free-reserved-pages
+++ a/arch/metag/mm/init.c
@@ -412,32 +412,15 @@ void __init mem_init(void)
 	return;
 }
 
-static void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr;
-
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-	pr_info("Freeing %s: %luk freed\n", what, (end - begin) >> 10);
-}
-
 void free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-			(unsigned long)(&__init_begin),
-			(unsigned long)(&__init_end));
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	end = end & PAGE_MASK;
-	free_init_pages("initrd memory", start, end);
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
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

