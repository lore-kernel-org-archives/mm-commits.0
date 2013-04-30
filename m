From: akpm@linux-foundation.org
Subject: [merged] mm-arc-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:10 -0700
Message-ID: <20130430184610.7871C5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49716 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3SqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:11 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84700qen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/arc: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-arc-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/arc: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff -puN arch/arc/mm/init.c~mm-arc-use-common-help-functions-to-free-reserved-pages arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~mm-arc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/arc/mm/init.c
@@ -144,37 +144,18 @@ void __init mem_init(void)
 		PAGES_TO_KB(reserved_pages));
 }
 
-static void __init free_init_pages(const char *what, unsigned long begin,
-				   unsigned long end)
-{
-	unsigned long addr;
-
-	pr_info("Freeing %s: %ldk [%lx] to [%lx]\n",
-		what, TO_KB(end - begin), begin, end);
-
-	/* need to check that the page we free is not a partial page */
-	for (addr = begin; addr + PAGE_SIZE <= end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-}
-
 /*
  * free_initmem: Free all the __init memory.
  */
 void __init_refok free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-			(unsigned long)__init_begin,
-			(unsigned long)__init_end);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

