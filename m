From: akpm@linux-foundation.org
Subject: [merged] mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:07 -0700
Message-ID: <20130430184507.76D0B5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:61831 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab3D3SpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:09 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84649qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/blackfin: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/blackfin: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mm/init.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff -puN arch/blackfin/mm/init.c~mm-blackfin-use-common-help-functions-to-free-reserved-pages arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~mm-blackfin-use-common-help-functions-to-free-reserved-pages
+++ a/arch/blackfin/mm/init.c
@@ -103,7 +103,7 @@ void __init mem_init(void)
 	max_mapnr = num_physpages = MAP_NR(high_memory);
 	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", num_physpages);
 
-	/* This will put all memory onto the freelists. */
+	/* This will put all low memory onto the freelists. */
 	totalram_pages = free_all_bootmem();
 
 	reservedpages = 0;
@@ -129,24 +129,11 @@ void __init mem_init(void)
 		initk, codek, datak, DMA_UNCACHED_REGION >> 10, (reservedpages << (PAGE_SHIFT-10)));
 }
 
-static void __init free_init_pages(const char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr;
-	/* next to check that the page we free is not a partial page */
-	for (addr = begin; addr + PAGE_SIZE <= end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 #ifndef CONFIG_MPU
-	free_init_pages("initrd memory", start, end);
+	free_reserved_area(start, end, 0, "initrd");
 #endif
 }
 #endif
@@ -154,10 +141,7 @@ void __init free_initrd_mem(unsigned lon
 void __init_refok free_initmem(void)
 {
 #if defined CONFIG_RAMKERNEL && !defined CONFIG_MPU
-	free_init_pages("unused kernel memory",
-			(unsigned long)(&__init_begin),
-			(unsigned long)(&__init_end));
