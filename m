From: akpm@linux-foundation.org
Subject: [merged] mm-sh-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:55 -0700
Message-ID: <20130430184555.79BC85A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49146 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3Sp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:56 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84451yha.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/SH: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-sh-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/SH: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff -puN arch/sh/mm/init.c~mm-sh-use-common-help-functions-to-free-reserved-pages arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-sh-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sh/mm/init.c
@@ -417,15 +417,13 @@ void __init mem_init(void)
 
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		unsigned long node_pages = 0;
 		void *node_high_memory;
 
 		num_physpages += pgdat->node_present_pages;
 
 		if (pgdat->node_spanned_pages)
-			node_pages = free_all_bootmem_node(pgdat);
+			totalram_pages += free_all_bootmem_node(pgdat);
 
-		totalram_pages += node_pages;
 
 		node_high_memory = (void *)__va((pgdat->node_start_pfn +
 						 pgdat->node_spanned_pages) <<
@@ -501,31 +499,13 @@ void __init mem_init(void)
 
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
-	printk("Freeing unused kernel memory: %ldk freed\n",
-	       ((unsigned long)&__init_end -
-	        (unsigned long)&__init_begin) >> 10);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	unsigned long p;
-	for (p = start; p < end; p += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(p));
-		init_page_count(virt_to_page(p));
-		free_page(p);
-		totalram_pages++;
-	}
-	printk("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

