From: akpm@linux-foundation.org
Subject: [merged] mm-sparc-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:19 -0700
Message-ID: <20130508183420.12EEE31C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:60834 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3EHSeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:21 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so207820ggl.4
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, davem@davemloft.net, jiang.liu@huawei.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/SPARC: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/SPARC: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/leon_smp.c |   15 ++-----------
 arch/sparc/mm/init_32.c      |   37 ++-------------------------------
 arch/sparc/mm/init_64.c      |   28 +++++-------------------
 3 files changed, 12 insertions(+), 68 deletions(-)

diff -puN arch/sparc/kernel/leon_smp.c~mm-sparc-use-common-help-functions-to-free-reserved-pages arch/sparc/kernel/leon_smp.c
--- a/arch/sparc/kernel/leon_smp.c~mm-sparc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sparc/kernel/leon_smp.c
@@ -253,24 +253,15 @@ void __init leon_smp_done(void)
 
 	/* Free unneeded trap tables */
 	if (!cpu_present(1)) {
-		ClearPageReserved(virt_to_page(&trapbase_cpu1));
-		init_page_count(virt_to_page(&trapbase_cpu1));
-		free_page((unsigned long)&trapbase_cpu1);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(&trapbase_cpu1));
 		num_physpages++;
 	}
 	if (!cpu_present(2)) {
-		ClearPageReserved(virt_to_page(&trapbase_cpu2));
-		init_page_count(virt_to_page(&trapbase_cpu2));
-		free_page((unsigned long)&trapbase_cpu2);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(&trapbase_cpu2));
 		num_physpages++;
 	}
 	if (!cpu_present(3)) {
-		ClearPageReserved(virt_to_page(&trapbase_cpu3));
-		init_page_count(virt_to_page(&trapbase_cpu3));
-		free_page((unsigned long)&trapbase_cpu3);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(&trapbase_cpu3));
 		num_physpages++;
 	}
 	/* Ok, they are spinning and ready to go. */
diff -puN arch/sparc/mm/init_32.c~mm-sparc-use-common-help-functions-to-free-reserved-pages arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-sparc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sparc/mm/init_32.c
@@ -366,45 +366,14 @@ void __init mem_init(void)
 
 void free_initmem (void)
 {
-	unsigned long addr;
-	unsigned long freed;
-
-	addr = (unsigned long)(&__init_begin);
-	freed = (unsigned long)(&__init_end) - addr;
-	for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
-		struct page *p;
-
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		p = virt_to_page(addr);
-
-		ClearPageReserved(p);
-		init_page_count(p);
-		__free_page(p);
-		totalram_pages++;
-		num_physpages++;
-	}
-	printk(KERN_INFO "Freeing unused kernel memory: %ldk freed\n",
-		freed >> 10);
+	num_physpages += free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start < end)
-		printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
-			(end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		struct page *p;
-
-		memset((void *)start, POISON_FREE_INITMEM, PAGE_SIZE);
-		p = virt_to_page(start);
-
-		ClearPageReserved(p);
-		init_page_count(p);
-		__free_page(p);
-		totalram_pages++;
-		num_physpages++;
-	}
+	num_physpages += free_reserved_area(start, end, POISON_FREE_INITMEM,
+					    "initrd");
 }
 #endif
 
diff -puN arch/sparc/mm/init_64.c~mm-sparc-use-common-help-functions-to-free-reserved-pages arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-sparc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sparc/mm/init_64.c
@@ -2059,8 +2059,7 @@ void __init mem_init(void)
 	/* We subtract one to account for the mem_map_zero page
 	 * allocated below.
 	 */
-	totalram_pages -= 1;
-	num_physpages = totalram_pages;
+	num_physpages = totalram_pages - 1;
 
 	/*
 	 * Set up the zero page, mark it reserved, so that page count
@@ -2071,7 +2070,7 @@ void __init mem_init(void)
 		prom_printf("paging_init: Cannot alloc zero page.\n");
 		prom_halt();
 	}
-	SetPageReserved(mem_map_zero);
+	mark_page_reserved(mem_map_zero);
 
 	codepages = (((unsigned long) _etext) - ((unsigned long) _start));
 	codepages = PAGE_ALIGN(codepages) >> PAGE_SHIFT;
@@ -2111,37 +2110,22 @@ void free_initmem(void)
 	initend = (unsigned long)(__init_end) & PAGE_MASK;
 	for (; addr < initend; addr += PAGE_SIZE) {
 		unsigned long page;
-		struct page *p;
 
 		page = (addr +
 			((unsigned long) __va(kern_base)) -
 			((unsigned long) KERNBASE));
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
 
-		if (do_free) {
-			p = virt_to_page(page);
-
-			ClearPageReserved(p);
-			init_page_count(p);
-			__free_page(p);
-			totalram_pages++;
-		}
+		if (do_free)
+			free_reserved_page(virt_to_page(page));
 	}
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start < end)
-		printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		struct page *p = virt_to_page(start);
