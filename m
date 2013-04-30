From: akpm@linux-foundation.org
Subject: [merged] mm-c6x-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:10 -0700
Message-ID: <20130430184510.7A9F631C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:36440 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab3D3SpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:11 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so84690qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, a-jacquiot@ti.com, jiang.liu@huawei.com, msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/c6x: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-c6x-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/c6x: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/mm/init.c |   30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff -puN arch/c6x/mm/init.c~mm-c6x-use-common-help-functions-to-free-reserved-pages arch/c6x/mm/init.c
--- a/arch/c6x/mm/init.c~mm-c6x-use-common-help-functions-to-free-reserved-pages
+++ a/arch/c6x/mm/init.c
@@ -77,37 +77,11 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	int pages = 0;
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-		pages++;
-	}
-	printk(KERN_INFO "Freeing initrd memory: %luk freed\n",
-	       (pages * PAGE_SIZE) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
 void __init free_initmem(void)
 {
-	unsigned long addr;
-
-	/*
-	 * The following code should be cool even if these sections
-	 * are not page aligned.
-	 */
-	addr = PAGE_ALIGN((unsigned long)(__init_begin));
