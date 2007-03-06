From: akpm@linux-foundation.org
Subject: - mm-implement-swap-prefetching-vs-zvc-stuff.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:20:58 -0800
Message-ID: <200703060121.l261Kxnq007516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933766AbXCFBVG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:21:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     ZVC writeback: Fix mm and other issues
has been removed from the -mm tree.  Its filename was
     mm-implement-swap-prefetching-vs-zvc-stuff.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: ZVC writeback: Fix mm and other issues
From: Christoph Lameter <clameter@sgi.com>

This deals with swap prefetch and various things changed in mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swap_prefetch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swap_prefetch.c~mm-implement-swap-prefetching-vs-zvc-stuff mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~mm-implement-swap-prefetching-vs-zvc-stuff
+++ a/mm/swap_prefetch.c
@@ -280,7 +280,7 @@ static void examine_free_limits(void)
 			z->lowmem_reserve[ZONE_HIGHMEM];
 		ns->highfree[idx] = ns->lowfree[idx] + z->pages_high;
 
-		if (z->free_pages > ns->highfree[idx]) {
+		if (zone_page_state(z, NR_FREE_PAGES) > ns->highfree[idx]) {
 			/*
 			 * We've gotten above the high watermark of free pages
 			 * so we can start prefetching till we get to the low
@@ -337,7 +337,7 @@ static int prefetch_suitable(void)
 		ns = &sp_stat.node[node];
 		idx = zone_idx(z);
 
-		free = z->free_pages;
+		free = zone_page_state(z, NR_FREE_PAGES);
 		if (free < *ns->pointfree[idx]) {
 			/*
 			 * Free pages have dropped below the low watermark so
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
