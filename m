From: akpm@linux-foundation.org
Subject: - mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:52:25 -0700
Message-ID: <200804280652.m3S6qPN5012620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbYD1Gxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@in.ibm.com, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, rientjes@google.com, xemul@open


The patch titled
     do_try_to_free_pages gfp_mask redundant
has been removed from the -mm tree.  Its filename was
     mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch

This patch was dropped because it was folded into mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_try_to_free_pages gfp_mask redundant
From: Hugh Dickins <hugh@veritas.com>

do_try_to_free_pages is taking both a gfp_mask and an sc->gfp_mask, sometimes
one used and sometimes the other; at present they're always identical, but
such duplication begs for trouble: remove gfp_mask arg.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant mm/vmscan.c
--- a/mm/vmscan.c~mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant
+++ a/mm/vmscan.c
@@ -1301,7 +1301,7 @@ static unsigned long shrink_zones(int pr
  * allocation attempt will fail.
  */
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
-					gfp_t gfp_mask, struct scan_control *sc)
+					struct scan_control *sc)
 {
 	int priority;
 	int ret = 0;
@@ -1311,7 +1311,7 @@ static unsigned long do_try_to_free_page
 	unsigned long lru_pages = 0;
 	struct zoneref *z;
 	struct zone *zone;
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 
 	if (scan_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
@@ -1339,7 +1339,7 @@ static unsigned long do_try_to_free_page
 		 * over limit cgroups
 		 */
 		if (scan_global_lru(sc)) {
-			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
+			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
 			if (reclaim_state) {
 				nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -1410,7 +1410,7 @@ unsigned long try_to_free_pages(struct z
 		.isolate_pages = isolate_pages_global,
 	};
 
-	return do_try_to_free_pages(zonelist, gfp_mask, &sc);
+	return do_try_to_free_pages(zonelist, &sc);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
@@ -1432,7 +1432,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
-	return do_try_to_free_pages(zonelist, sc.gfp_mask, &sc);
+	return do_try_to_free_pages(zonelist, &sc);
 }
 #endif
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-try-both-endianess-when-checking-for-endianess.patch
mempolicy-support-optional-mode-flags-fix.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch

