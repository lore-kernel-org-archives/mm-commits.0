From: akpm@linux-foundation.org
Subject: - zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:21:46 -0800
Message-ID: <200703060121.l261LmcQ007540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45010 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933774AbXCFBVy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:21:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     ZVC: Support NR_SLAB_RECLAIMABLE / NR_SLAB_UNRECLAIMABLE
has been removed from the -mm tree.  Its filename was
     zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: ZVC: Support NR_SLAB_RECLAIMABLE / NR_SLAB_UNRECLAIMABLE
From: Christoph Lameter <clameter@sgi.com>

Remove the atomic counter for slab_reclaim_pages and replace the counter
and NR_SLAB with two ZVC counter that account for unreclaimable and
reclaimable slab pages: NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE.

Change the check in vmscan.c to refer to to NR_SLAB_RECLAIMABLE.  The
intend seems to be to check for slab pages that could be freed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swap_prefetch.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/swap_prefetch.c~zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch
+++ a/mm/swap_prefetch.c
@@ -394,7 +394,8 @@ static int prefetch_suitable(void)
 		 * would be expensive to fix and not of great significance.
 		 */
 		limit = node_page_state(node, NR_FILE_PAGES);
-		limit += node_page_state(node, NR_SLAB);
+		limit += node_page_state(node, NR_SLAB_UNRECLAIMABLE);
+		limit += node_page_state(node, NR_SLAB_RECLAIMABLE);
 		limit += node_page_state(node, NR_FILE_DIRTY);
 		limit += node_page_state(node, NR_UNSTABLE_NFS);
 		limit += total_swapcache_pages;
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
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
