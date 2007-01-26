From: akpm@osdl.org
Subject: + mm-implement-swap-prefetching-vs-zvc-stuff-2.patch added to -mm tree
Date: Fri, 26 Jan 2007 14:12:36 -0800
Message-ID: <200701262212.l0QMCarK027997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXAZWMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 17:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     ZVC writeback: Fix mm and other issues
has been added to the -mm tree.  Its filename is
     mm-implement-swap-prefetching-vs-zvc-stuff-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ZVC writeback: Fix mm and other issues
From: Christoph Lameter <clameter@sgi.com>

This deals with swap prefetch and various things changed in mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm_inline.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm_inline.h~mm-implement-swap-prefetching-vs-zvc-stuff-2 include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-implement-swap-prefetching-vs-zvc-stuff-2
+++ a/include/linux/mm_inline.h
@@ -16,7 +16,7 @@ static inline void
 add_page_to_inactive_list_tail(struct zone *zone, struct page *page)
 {
 	list_add_tail(&page->lru, &zone->inactive_list);
-	zone->nr_inactive++;
+	__inc_zone_state(zone, NR_INACTIVE);
 }
 
 static inline void
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
use-zvc-for-free_pages-fix.patch
use-zvc-for-free_pages-fix-2.patch
use-zvc-for-free_pages-fix-3.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch
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
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
