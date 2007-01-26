From: akpm@osdl.org
Subject: + drop-nr_free_pages_pgdat.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:16:44 -0800
Message-ID: <200701260616.l0Q6GiSF009159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47737 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030781AbXAZGQq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:16:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Drop nr_free_pages_pgdat()
has been added to the -mm tree.  Its filename is
     drop-nr_free_pages_pgdat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Drop nr_free_pages_pgdat()
From: Christoph Lameter <clameter@sgi.com>

Function is unnecessary now.  We can use the summing features of the ZVCs to
get the values we need.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
@@ -1441,13 +1441,6 @@ fastcall void free_pages(unsigned long a
 
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

mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
fix-writeback-calculation.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
