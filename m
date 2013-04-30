From: akpm@linux-foundation.org
Subject: [merged] mm-metag-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:13 -0700
Message-ID: <20130430184613.76BC95A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:60452 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab3D3SqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:15 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so84938vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, james.hogan@imgtec.com, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/metag: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-metag-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
