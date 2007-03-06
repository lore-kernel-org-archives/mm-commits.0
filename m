From: akpm@linux-foundation.org
Subject: - reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:21:56 -0800
Message-ID: <200703060121.l261LvCs007543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45018 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775AbXCFBWC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     swap_prefetch: Remove incorrect use of ZONE_HIGHMEM
has been removed from the -mm tree.  Its filename was
     reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: swap_prefetch: Remove incorrect use of ZONE_HIGHMEM
From: Christoph Lameter <clameter@sgi.com>

swap_prefetch: Remove useless reference to HIGHMEM reserves.

HIGHMEM "reserves" are always zero. Remove the addition of the highmem
reserves.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swap_prefetch.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/swap_prefetch.c~reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem
+++ a/mm/swap_prefetch.c
@@ -278,8 +278,7 @@ static void examine_free_limits(void)
 
 		ns = &sp_stat.node[z->zone_pgdat->node_id];
 		idx = zone_idx(z);
-		ns->lowfree[idx] = z->pages_high * 3 +
-			z->lowmem_reserve[ZONE_HIGHMEM];
+		ns->lowfree[idx] = z->pages_high * 3;
 		ns->highfree[idx] = ns->lowfree[idx] + z->pages_high;
 
 		if (zone_page_state(z, NR_FREE_PAGES) > ns->highfree[idx]) {
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
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
