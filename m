From: akpm@osdl.org
Subject: + get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch added to -mm tree
Date: Thu, 25 Jan 2007 23:55:04 -0800
Message-ID: <200701260755.l0Q7t4gJ010869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030836AbXAZHzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     get_dirty_limits: Accurately calculate the available memory that can be dirtied
has been added to the -mm tree.  Its filename is
     get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get_dirty_limits: Accurately calculate the available memory that can be dirtied
From: Christoph Lameter <clameter@sgi.com>

We can use the global ZVC counters to establish the exact size of the LRU
and the free pages.  This allows a more accurate determination of the dirty
ratio.

This patch will fix the broken ratio calculations if large amounts of
memory are allocated to huge pags or other consumers that do not put the
pages on to the LRU.

However, we are unable to use the accurate base in the case of HIGHMEM and
an allocation excluding HIGHMEM pages.  In that case just fall back to the
old scheme.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page-writeback.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff -puN mm/page-writeback.c~get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied mm/page-writeback.c
--- a/mm/page-writeback.c~get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied
+++ a/mm/page-writeback.c
@@ -119,6 +119,35 @@ static void background_writeout(unsigned
  * We make sure that the background writeout level is below the adjusted
  * clamping level.
  */
+
+static unsigned long determine_available_memory(struct address_space *mapping)
+{
+	unsigned long x = global_page_state(NR_FREE_PAGES)
+		+ global_page_state(NR_INACTIVE)
+		+ global_page_state(NR_ACTIVE);
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * If this mapping can only allocate from low memory,
+	 * we exclude high memory from our count.
+	 */
+	if (mapping && !(mapping_gfp_mask(mapping) & __GFP_HIGHMEM)) {
+		int node;
+
+		for_each_online_node(node) {
+			struct zone *z =
+				&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+
+			x -= zone_page_state(z, NR_FREE_PAGES)
+				+ zone_page_state(z, NR_INACTIVE)
+				+ zone_page_state(z, NR_INACTIVE);
+		}
+	}
+
+
+#endif
+	return x;
+}
+
 static void
 get_dirty_limits(long *pbackground, long *pdirty,
 					struct address_space *mapping)
@@ -128,19 +157,9 @@ get_dirty_limits(long *pbackground, long
 	int unmapped_ratio;
 	long background;
 	long dirty;
-	unsigned long available_memory = vm_total_pages;
+	unsigned long available_memory = determine_available_memory(mapping);
 	struct task_struct *tsk;
 
-#ifdef CONFIG_HIGHMEM
-	/*
-	 * If this mapping can only allocate from low memory,
-	 * we exclude high memory from our count.
-	 */
-	if (mapping && !(mapping_gfp_mask(mapping) & __GFP_HIGHMEM))
-		available_memory -= totalhigh_pages;
-#endif
-
-
 	unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
 				global_page_state(NR_ANON_PAGES)) * 100) /
 					vm_total_pages;
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
use-zvc-for-free_pages-fix.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch
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
