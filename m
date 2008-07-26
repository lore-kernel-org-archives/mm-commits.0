From: akpm@linux-foundation.org
Subject: - sh-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:42 -0700
Message-ID: <200807262117.m6QLHgHF020018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757962AbYGZVRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     sh-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slab, printed by show_free_areas()
	- free swap pages, printed by show_swap_cache_info()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |   41 -----------------------------------------
 1 file changed, 41 deletions(-)

diff -puN arch/sh/mm/init.c~sh-use-generic-show_mem arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~sh-use-generic-show_mem
+++ a/arch/sh/mm/init.c
@@ -25,47 +25,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 unsigned long cached_to_uncached = 0;
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, free = 0;
-	int shared = 0, cached = 0, slab = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags, i;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	printk("%d pages of RAM\n", total);
-	printk("%d free pages\n", free);
-	printk("%d reserved pages\n", reserved);
-	printk("%d slab pages\n", slab);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-}
