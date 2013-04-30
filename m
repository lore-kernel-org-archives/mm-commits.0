From: akpm@linux-foundation.org
Subject: [merged] mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:45 -0700
Message-ID: <20130430184645.7CF835A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:60439 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab3D3Sqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:46 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84831qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jdike@addtoit.com, jiang.liu@huawei.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/um: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/um: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN arch/um/kernel/mem.c~mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/um/kernel/mem.c
@@ -42,17 +42,12 @@ static unsigned long brk_end;
 static void setup_highmem(unsigned long highmem_start,
 			  unsigned long highmem_len)
 {
-	struct page *page;
 	unsigned long highmem_pfn;
 	int i;
 
 	highmem_pfn = __pa(highmem_start) >> PAGE_SHIFT;
-	for (i = 0; i < highmem_len >> PAGE_SHIFT; i++) {
-		page = &mem_map[highmem_pfn + i];
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-	}
+	for (i = 0; i < highmem_len >> PAGE_SHIFT; i++)
+		free_highmem_page(&mem_map[highmem_pfn + i]);
 }
 #endif
 
@@ -73,18 +68,13 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 	max_low_pfn = totalram_pages;
 #ifdef CONFIG_HIGHMEM
-	totalhigh_pages = highmem >> PAGE_SHIFT;
-	totalram_pages += totalhigh_pages;
+	setup_highmem(end_iomem, highmem);
 #endif
 	num_physpages = totalram_pages;
 	max_pfn = totalram_pages;
 	printk(KERN_INFO "Memory: %luk available\n",
 	       nr_free_pages() << (PAGE_SHIFT-10));
 	kmalloc_ok = 1;
