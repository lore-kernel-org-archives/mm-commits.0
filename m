From: akpm@linux-foundation.org
Subject: - sparc64-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:40 -0700
Message-ID: <200807262117.m6QLHeV0020015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757925AbYGZVRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc64: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     sparc64-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free swap pages, printed by show_swap_cache_info()
	- pages in swapcache, printed by show_swap_cache_info()
	- dirty pages, writeback pages, mapped pages, slab pages,
	  pagetables pages, printed by show_free_areas()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/mm/init.c |   45 ---------------------------------------
 1 file changed, 45 deletions(-)

diff -puN arch/sparc64/mm/init.c~sparc64-use-generic-show_mem arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~sparc64-use-generic-show_mem
+++ a/arch/sparc64/mm/init.c
@@ -392,51 +392,6 @@ void __kprobes flush_icache_range(unsign
 	}
 }
 
-void show_mem(void)
-{
-	unsigned long total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-	       nr_swap_pages << (PAGE_SHIFT-10));
-	for_each_online_pgdat(pgdat) {
-		unsigned long i, flags;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
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
-
-	printk(KERN_INFO "%lu pages of RAM\n", total);
-	printk(KERN_INFO "%lu reserved pages\n", reserved);
-	printk(KERN_INFO "%lu pages shared\n", shared);
-	printk(KERN_INFO "%lu pages swap cached\n", cached);
-
-	printk(KERN_INFO "%lu pages dirty\n",
-	       global_page_state(NR_FILE_DIRTY));
-	printk(KERN_INFO "%lu pages writeback\n",
-	       global_page_state(NR_WRITEBACK));
-	printk(KERN_INFO "%lu pages mapped\n",
-	       global_page_state(NR_FILE_MAPPED));
-	printk(KERN_INFO "%lu pages slab\n",
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-		global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk(KERN_INFO "%lu pages pagetables\n",
-	       global_page_state(NR_PAGETABLE));
-}
