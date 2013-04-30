From: akpm@linux-foundation.org
Subject: [merged] mm-mips-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:34 -0700
Message-ID: <20130430184534.75EAF31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:43987 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:35 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so84749yen.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/MIPS: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-mips-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/MIPS: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c              |   31 ++++++++---------------------
 arch/mips/sgi-ip27/ip27-memory.c |    4 +--
 2 files changed, 11 insertions(+), 24 deletions(-)

diff -puN arch/mips/mm/init.c~mm-mips-use-common-help-functions-to-free-reserved-pages arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-mips-use-common-help-functions-to-free-reserved-pages
+++ a/arch/mips/mm/init.c
@@ -77,10 +77,9 @@ EXPORT_SYMBOL_GPL(empty_zero_page);
 /*
  * Not static inline because used by IP27 special magic initialization code
  */
-unsigned long setup_zero_pages(void)
+void setup_zero_pages(void)
 {
-	unsigned int order;
-	unsigned long size;
+	unsigned int order, i;
 	struct page *page;
 
 	if (cpu_has_vce)
@@ -94,15 +93,10 @@ unsigned long setup_zero_pages(void)
 
 	page = virt_to_page((void *)empty_zero_page);
 	split_page(page, order);
-	while (page < virt_to_page((void *)(empty_zero_page + (PAGE_SIZE << order)))) {
-		SetPageReserved(page);
-		page++;
-	}
-
-	size = PAGE_SIZE << order;
-	zero_page_mask = (size - 1) & PAGE_MASK;
+	for (i = 0; i < (1 << order); i++, page++)
+		mark_page_reserved(page);
 
-	return 1UL << order;
+	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
 
 #ifdef CONFIG_MIPS_MT_SMTC
@@ -380,7 +374,7 @@ void __init mem_init(void)
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_pages();	/* Setup zeroed pages.	*/
+	setup_zero_pages();	/* Setup zeroed pages.  */
 
 	reservedpages = ram = 0;
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
@@ -440,11 +434,8 @@ void free_init_pages(const char *what, u
 		struct page *page = pfn_to_page(pfn);
 		void *addr = phys_to_virt(PFN_PHYS(pfn));
 
-		ClearPageReserved(page);
-		init_page_count(page);
 		memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		__free_page(page);
-		totalram_pages++;
+		free_reserved_page(page);
 	}
 	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
 }
@@ -452,18 +443,14 @@ void free_init_pages(const char *what, u
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory",
-			virt_to_phys((void *)start),
-			virt_to_phys((void *)end));
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
 }
 #endif
 
 void __init_refok free_initmem(void)
 {
 	prom_free_prom_memory();
-	free_init_pages("unused kernel memory",
-			__pa_symbol(&__init_begin),
-			__pa_symbol(&__init_end));
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifndef CONFIG_MIPS_PGD_C0_CONTEXT
diff -puN arch/mips/sgi-ip27/ip27-memory.c~mm-mips-use-common-help-functions-to-free-reserved-pages arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-mips-use-common-help-functions-to-free-reserved-pages
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -457,7 +457,7 @@ void __init prom_free_prom_memory(void)
 	/* We got nothing to free here ...  */
 }
 
-extern unsigned long setup_zero_pages(void);
+extern void setup_zero_pages(void);
 
 void __init paging_init(void)
 {
@@ -492,7 +492,7 @@ void __init mem_init(void)
 		totalram_pages += free_all_bootmem_node(NODE_DATA(node));
 	}
 
-	totalram_pages -= setup_zero_pages();	/* This comes from node 0 */
+	setup_zero_pages();	/* This comes from node 0 */
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

