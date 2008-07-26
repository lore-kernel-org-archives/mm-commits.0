From: akpm@linux-foundation.org
Subject: - s390-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:44 -0700
Message-ID: <200807262117.m6QLHiqU020021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758062AbYGZVTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     s390-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff -puN arch/s390/mm/init.c~s390-use-generic-show_mem arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~s390-use-generic-show_mem
+++ a/arch/s390/mm/init.c
@@ -42,38 +42,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 char  empty_zero_page[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
-void show_mem(void)
-{
-	unsigned long i, total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	unsigned long flags;
-	struct page *page;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-			page = pfn_to_page(pgdat->node_start_pfn + i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk("%ld pages of RAM\n", total);
-	printk("%ld reserved pages\n", reserved);
-	printk("%ld pages shared\n", shared);
-	printk("%ld pages swap cached\n", cached);
-}
