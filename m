From: akpm@linux-foundation.org
Subject: - mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:54 -0700
Message-ID: <200804282150.m3SLosQL017530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934621AbYD1Vvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: use zonelists instead of zones when direct reclaiming pages
has been removed from the -mm tree.  Its filename was
     mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use zonelists instead of zones when direct reclaiming pages
From: Mel Gorman <mel@csn.ul.ie>

The following patches replace multiple zonelists per node with two zonelists
that are filtered based on the GFP flags.  The patches as a set fix a bug with
regard to the use of MPOL_BIND and ZONE_MOVABLE.  With this patchset, the
MPOL_BIND will apply to the two highest zones when the highest zone is
ZONE_MOVABLE.  This should be considered as an alternative fix for the
MPOL_BIND+ZONE_MOVABLE in 2.6.23 to the previously discussed hack that filters
only custom zonelists.

The first patch cleans up an inconsistency where direct reclaim uses
zonelist->zones where other places use zonelist.

The second patch introduces a helper function node_zonelist() for looking up
the appropriate zonelist for a GFP mask which simplifies patches later in the
set.

The third patch defines/remembers the "preferred zone" for numa statistics, as
it is no longer always the first zone in a zonelist.

The forth patch replaces multiple zonelists with two zonelists that are
filtered.  The two zonelists are due to the fact that the memoryless patchset
introduces a second set of zonelists for __GFP_THISNODE.

The fifth patch introduces helper macros for retrieving the zone and node
indices of entries in a zonelist.

The final patch introduces filtering of the zonelists based on a nodemask. 
Two zonelists exist per node, one for normal allocations and one for
__GFP_THISNODE.

Performance results varied depending on the machine configuration.  In real
workloads the gain/loss will depend on how much the userspace portion of the
benchmark benefits from having more cache available due to reduced referencing
of zonelists.

These are the range of performance losses/gains when running against
2.6.24-rc4-mm1.  The set and these machines are a mix of i386, x86_64 and
ppc64 both NUMA and non-NUMA.
			     loss   to  gain
Total CPU time on Kernbench: -0.86% to  1.13%
Elapsed   time on Kernbench: -0.79% to  0.76%
page_test from aim9:         -4.37% to  0.79%
brk_test  from aim9:         -0.71% to  4.07%
fork_test from aim9:         -1.84% to  4.60%
exec_test from aim9:         -0.71% to  1.08%


This patch:

The allocator deals with zonelists which indicate the order in which zones
should be targeted for an allocation.  Similarly, direct reclaim of pages
iterates over an array of zones.  For consistency, this patch converts direct
reclaim to use a zonelist.  No functionality is changed by this patch.  This
simplifies zonelist iterators in the next patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c          |    8 ++++----
 include/linux/swap.h |    2 +-
 mm/page_alloc.c      |    2 +-
 mm/vmscan.c          |   21 ++++++++++++---------
 4 files changed, 18 insertions(+), 15 deletions(-)

diff -puN fs/buffer.c~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages fs/buffer.c
--- a/fs/buffer.c~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages
+++ a/fs/buffer.c
@@ -360,16 +360,16 @@ void invalidate_bdev(struct block_device
  */
 static void free_more_memory(void)
 {
-	struct zone **zones;
+	struct zonelist *zonelist;
 	pg_data_t *pgdat;
 
 	wakeup_pdflush(1024);
 	yield();
 
 	for_each_online_pgdat(pgdat) {
-		zones = pgdat->node_zonelists[gfp_zone(GFP_NOFS)].zones;
-		if (*zones)
-			try_to_free_pages(zones, 0, GFP_NOFS);
+		zonelist = &pgdat->node_zonelists[gfp_zone(GFP_NOFS)];
+		if (zonelist->zones[0])
+			try_to_free_pages(zonelist, 0, GFP_NOFS);
 	}
 }
 
diff -puN include/linux/swap.h~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages include/linux/swap.h
--- a/include/linux/swap.h~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages
+++ a/include/linux/swap.h
@@ -181,7 +181,7 @@ extern int rotate_reclaimable_page(struc
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
-extern unsigned long try_to_free_pages(struct zone **zones, int order,
+extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 							gfp_t gfp_mask);
diff -puN mm/page_alloc.c~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages
+++ a/mm/page_alloc.c
@@ -1569,7 +1569,7 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	did_some_progress = try_to_free_pages(zonelist->zones, order, gfp_mask);
+	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
 
 	p->reclaim_state = NULL;
 	p->flags &= ~PF_MEMALLOC;
diff -puN mm/vmscan.c~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages
+++ a/mm/vmscan.c
@@ -1246,10 +1246,11 @@ static unsigned long shrink_zone(int pri
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static unsigned long shrink_zones(int priority, struct zone **zones,
+static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	unsigned long nr_reclaimed = 0;
+	struct zone **zones = zonelist->zones;
 	int i;
 
 
@@ -1301,8 +1302,8 @@ static unsigned long shrink_zones(int pr
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-static unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
-					  struct scan_control *sc)
+static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
+					gfp_t gfp_mask, struct scan_control *sc)
 {
 	int priority;
 	int ret = 0;
@@ -1310,6 +1311,7 @@ static unsigned long do_try_to_free_page
 	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long lru_pages = 0;
+	struct zone **zones = zonelist->zones;
 	int i;
 
 	if (scan_global_lru(sc))
@@ -1333,7 +1335,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		nr_reclaimed += shrink_zones(priority, zones, sc);
+		nr_reclaimed += shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -1397,7 +1399,8 @@ out:
 	return ret;
 }
 
-unsigned long try_to_free_pages(struct zone **zones, int order, gfp_t gfp_mask)
+unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
+								gfp_t gfp_mask)
 {
 	struct scan_control sc = {
 		.gfp_mask = gfp_mask,
@@ -1410,7 +1413,7 @@ unsigned long try_to_free_pages(struct z
 		.isolate_pages = isolate_pages_global,
 	};
 
-	return do_try_to_free_pages(zones, gfp_mask, &sc);
+	return do_try_to_free_pages(zonelist, gfp_mask, &sc);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
@@ -1428,11 +1431,11 @@ unsigned long try_to_free_mem_cgroup_pag
 		.mem_cgroup = mem_cont,
 		.isolate_pages = mem_cgroup_isolate_pages,
 	};
-	struct zone **zones;
+	struct zonelist *zonelist;
 	int target_zone = gfp_zone(GFP_HIGHUSER_MOVABLE);
 
-	zones = NODE_DATA(numa_node_id())->node_zonelists[target_zone].zones;
-	if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
+	zonelist = &NODE_DATA(numa_node_id())->node_zonelists[target_zone];
+	if (do_try_to_free_pages(zonelist, sc.gfp_mask, &sc))
 		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-fix-usemap-initialization.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

