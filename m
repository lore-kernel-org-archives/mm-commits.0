From: akpm@linux-foundation.org
Subject: - numa-add-zone_to_nid-function-swap_prefetch.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:22:17 -0800
Message-ID: <200703060122.l261MJ7P007554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933776AbXCFBW0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:22:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     NUMA: Add zone_to_nid function
has been removed from the -mm tree.  Its filename was
     numa-add-zone_to_nid-function-swap_prefetch.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: NUMA: Add zone_to_nid function
From: Christoph Lameter <clameter@sgi.com>

There are many places where we need to determine the node of a zone. 
Currently we use a difficult to read sequence of pointer dereferencing. 
Put that into an inline function and use throughout VM.  Maybe we can find
a way to optimize the lookup in the future.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swap_prefetch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/swap_prefetch.c~numa-add-zone_to_nid-function-swap_prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~numa-add-zone_to_nid-function-swap_prefetch
+++ a/mm/swap_prefetch.c
@@ -276,7 +276,7 @@ static void examine_free_limits(void)
 		if (!populated_zone(z))
 			continue;
 
-		ns = &sp_stat.node[z->zone_pgdat->node_id];
+		ns = &sp_stat.node[zone_to_nid(z)];
 		idx = zone_idx(z);
 		ns->lowfree[idx] = z->pages_high * 3;
 		ns->highfree[idx] = ns->lowfree[idx] + z->pages_high;
@@ -334,7 +334,7 @@ static int prefetch_suitable(void)
 		if (!populated_zone(z))
 			continue;
 
-		node = z->zone_pgdat->node_id;
+		node = zone_to_nid(z);
 		ns = &sp_stat.node[node];
 		idx = zone_idx(z);
 
@@ -558,7 +558,7 @@ void __init prepare_swap_prefetch(void)
 		if (!present)
 			continue;
 
-		ns = &sp_stat.node[zone->zone_pgdat->node_id];
+		ns = &sp_stat.node[zone_to_nid(zone)];
 		ns->prefetch_watermark += present / 3 * 2;
 		idx = zone_idx(zone);
 		ns->pointfree[idx] = &ns->highfree[idx];
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
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
