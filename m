From: akpm@linux-foundation.org
Subject: - use-zvc-for-free_pages-fix-3.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:05:15 -0800
Message-ID: <200702100805.l1A85FaG006856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXBJIFW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:05:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     ZVC writeback: Fix mm and other issues
has been removed from the -mm tree.  Its filename was
     use-zvc-for-free_pages-fix-3.patch

This patch was dropped because it was folded into use-zvc-for-free_pages.patch

------------------------------------------------------
Subject: ZVC writeback: Fix mm and other issues
From: Christoph Lameter <clameter@sgi.com>

This deals with swap prefetch and various things changed in mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~use-zvc-for-free_pages-fix-3 mm/page_alloc.c
--- a/mm/page_alloc.c~use-zvc-for-free_pages-fix-3
+++ a/mm/page_alloc.c
@@ -1521,7 +1521,8 @@ void si_meminfo_node(struct sysinfo *val
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
-	val->freehigh = pgdat->node_zones[ZONE_HIGHMEM].free_pages;
+	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
+			NR_FREE_PAGES);
 #else
 	val->totalhigh = 0;
 	val->freehigh = 0;
_

Patches currently in -mm which might be from clameter@sgi.com are

use-parameter-passed-to-cache_reap-to-determine-pointer-to.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
use-zvc-for-free_pages-fix-3.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
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
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
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
