From: akpm@osdl.org
Subject: + fix-writeback-calculation.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:16:47 -0800
Message-ID: <200701260616.l0Q6GlVR009168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030778AbXAZGQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Fix writeback calculation
has been added to the -mm tree.  Its filename is
     fix-writeback-calculation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix writeback calculation
From: Christoph Lameter <clameter@sgi.com>

We can use the global ZVC counters to establish the exact size of the LRU and
the free pages.  This allows a more accurate determination of the dirty ratio.

This patch will fix the broken ratio calculations if large amounts of memory
are allocated to huge pags or other consumers that do not put the pages on to
the LRU.

However, we are unable to use the accurate base in the case of HIGHMEM and an
allocation excluding HIGHMEM pages.  In that case just fall back to the old
scheme.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~fix-writeback-calculation mm/page-writeback.c
--- a/mm/page-writeback.c~fix-writeback-calculation
+++ a/mm/page-writeback.c
@@ -128,7 +128,9 @@ get_dirty_limits(long *pbackground, long
 	int unmapped_ratio;
 	long background;
 	long dirty;
-	unsigned long available_memory = vm_total_pages;
+	unsigned long available_memory = global_page_state(NR_FREE_PAGES) +
+			global_page_state(NR_INACTIVE) +
+			global_page_state(NR_ACTIVE);
 	struct task_struct *tsk;
 
 #ifdef CONFIG_HIGHMEM
@@ -137,7 +139,12 @@ get_dirty_limits(long *pbackground, long
 	 * we exclude high memory from our count.
 	 */
 	if (mapping && !(mapping_gfp_mask(mapping) & __GFP_HIGHMEM))
-		available_memory -= totalhigh_pages;
+		/*
+		 * This is not as accurate as the non highmem calculation
+		 * but it has worked for years. So let it be as it was.
+		 * People know how to deal with it it seems.
+		 */
+		available_memory = vm_total_pages - totalhigh_pages;
 #endif
 
 
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
