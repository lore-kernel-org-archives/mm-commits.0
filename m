From: akpm@linux-foundation.org
Subject: [merged] mm-s390-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:49 -0700
Message-ID: <20130430184549.811D231C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49279 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:50 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84670qen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, heiko.carstens@de.ibm.com, jiang.liu@huawei.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/s390: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-s390-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/s390: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |   35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff -puN arch/s390/mm/init.c~mm-s390-use-common-help-functions-to-free-reserved-pages arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-s390-use-common-help-functions-to-free-reserved-pages
+++ a/arch/s390/mm/init.c
@@ -42,11 +42,10 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD] __att
 unsigned long empty_zero_page, zero_page_mask;
 EXPORT_SYMBOL(empty_zero_page);
 
-static unsigned long __init setup_zero_pages(void)
+static void __init setup_zero_pages(void)
 {
 	struct cpuid cpu_id;
 	unsigned int order;
-	unsigned long size;
 	struct page *page;
 	int i;
 
@@ -83,14 +82,11 @@ static unsigned long __init setup_zero_p
 	page = virt_to_page((void *) empty_zero_page);
 	split_page(page, order);
 	for (i = 1 << order; i > 0; i--) {
-		SetPageReserved(page);
+		mark_page_reserved(page);
 		page++;
 	}
 
-	size = PAGE_SIZE << order;
-	zero_page_mask = (size - 1) & PAGE_MASK;
-
-	return 1UL << order;
+	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
 
 /*
@@ -147,7 +143,7 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_pages();	/* Setup zeroed pages. */
+	setup_zero_pages();	/* Setup zeroed pages. */
 
 	reservedpages = 0;
 
@@ -166,34 +162,15 @@ void __init mem_init(void)
 	       PFN_ALIGN((unsigned long)&_eshared) - 1);
 }
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr = begin;
-
-	if (begin >= end)
-		return;
-	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *)(addr & PAGE_MASK), POISON_FREE_INITMEM,
-		       PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
-}
