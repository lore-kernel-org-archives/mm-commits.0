From: akpm@linux-foundation.org
Subject: - avr32-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:30 -0700
Message-ID: <200807262117.m6QLHUsh019931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757893AbYGZVRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     avr32-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: avr32: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slabs, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/init.c |   39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff -puN arch/avr32/mm/init.c~avr32-use-generic-show_mem arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~avr32-use-generic-show_mem
+++ a/arch/avr32/mm/init.c
@@ -38,45 +38,6 @@ EXPORT_SYMBOL(empty_zero_page);
  */
 unsigned long mmu_context_cache = NO_CONTEXT;
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, cached = 0;
-	int slab = 0, free = 0, shared = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		struct page *page, *end;
-
-		page = pgdat->node_mem_map;
-		end = page + pgdat->node_spanned_pages;
-
-		do {
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
-			page++;
-		} while (page < end);
-	}
-
-	printk ("%d pages of RAM\n", total);
-	printk ("%d free pages\n", free);
-	printk ("%d reserved pages\n", reserved);
-	printk ("%d slab pages\n", slab);
-	printk ("%d pages shared\n", shared);
-	printk ("%d pages swap cached\n", cached);
-}
