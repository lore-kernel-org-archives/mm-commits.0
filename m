From: akpm@linux-foundation.org
Subject: - drop-nr_free_pages_pgdat.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:24 -0800
Message-ID: <200702112246.l1BMkODI015488@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbXBKWq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Drop nr_free_pages_pgdat()
has been removed from the -mm tree.  Its filename was
     drop-nr_free_pages_pgdat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Drop nr_free_pages_pgdat()
From: Christoph Lameter <clameter@sgi.com>

Function is unnecessary now.  We can use the summing features of the ZVCs to
get the values we need.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c  |    2 +-
 include/linux/swap.h |    1 -
 mm/page_alloc.c      |    7 -------
 3 files changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/ia64/mm/init.c~drop-nr_free_pages_pgdat arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~drop-nr_free_pages_pgdat
+++ a/arch/ia64/mm/init.c
@@ -68,7 +68,7 @@ max_pgt_pages(void)
 #ifndef	CONFIG_NUMA
 	node_free_pages = nr_free_pages();
 #else
-	node_free_pages = nr_free_pages_pgdat(NODE_DATA(numa_node_id()));
+	node_free_pages = node_page_state(numa_node_id(), NR_FREE_PAGES);
 #endif
 	max_pgt_pages = node_free_pages / PGT_FRACTION_OF_NODE_MEM;
 	max_pgt_pages = max(max_pgt_pages, MIN_PGT_PAGES);
diff -puN include/linux/swap.h~drop-nr_free_pages_pgdat include/linux/swap.h
--- a/include/linux/swap.h~drop-nr_free_pages_pgdat
+++ a/include/linux/swap.h
@@ -170,7 +170,6 @@ extern void swapin_readahead(swp_entry_t
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
 extern long nr_swap_pages;
-extern unsigned int nr_free_pages_pgdat(pg_data_t *pgdat);
 extern unsigned int nr_free_buffer_pages(void);
 extern unsigned int nr_free_pagecache_pages(void);
 
diff -puN mm/page_alloc.c~drop-nr_free_pages_pgdat mm/page_alloc.c
--- a/mm/page_alloc.c~drop-nr_free_pages_pgdat
+++ a/mm/page_alloc.c
@@ -1440,13 +1440,6 @@ fastcall void free_pages(unsigned long a
 
 EXPORT_SYMBOL(free_pages);
 
-#ifdef CONFIG_NUMA
-unsigned int nr_free_pages_pgdat(pg_data_t *pgdat)
-{
-	return node_page_state(pgdat->node_id, NR_FREE_PAGES);
-}
-#endif
-
 static unsigned int nr_free_zone_pages(int offset)
 {
 	/* Just pick one node, since fallback list is circular */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
