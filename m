From: akpm@linux-foundation.org
Subject: [merged] mm-score-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:52 -0700
Message-ID: <20130430184552.7ADE231C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40102 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:53 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so86216qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/score: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-score-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/score: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/mm/init.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff -puN arch/score/mm/init.c~mm-score-use-common-help-functions-to-free-reserved-pages arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-score-use-common-help-functions-to-free-reserved-pages
+++ a/arch/score/mm/init.c
@@ -43,7 +43,7 @@ EXPORT_SYMBOL_GPL(empty_zero_page);
 
 static struct kcore_list kcore_mem, kcore_vmalloc;
 
-static unsigned long setup_zero_page(void)
+static void setup_zero_page(void)
 {
 	struct page *page;
 
@@ -52,9 +52,7 @@ static unsigned long setup_zero_page(voi
 		panic("Oh boy, that early out of memory?");
 
 	page = virt_to_page((void *) empty_zero_page);
-	SetPageReserved(page);
-
-	return 1UL;
+	mark_page_reserved(page);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -84,7 +82,7 @@ void __init mem_init(void)
 
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_page();	/* Setup zeroed pages. */
+	setup_zero_page();	/* Setup zeroed pages. */
 	reservedpages = 0;
 
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
@@ -109,37 +107,16 @@ void __init mem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-static void free_init_pages(const char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long pfn;
-
-	for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
-		struct page *page = pfn_to_page(pfn);
-		void *addr = phys_to_virt(PFN_PHYS(pfn));
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		__free_page(page);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory",
-		virt_to_phys((void *) start),
-		virt_to_phys((void *) end));
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
 }
 #endif
 
 void __init_refok free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-	__pa(&__init_begin),
-	__pa(&__init_end));
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 unsigned long pgd_current;
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

