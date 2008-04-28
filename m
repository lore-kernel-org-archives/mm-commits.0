From: akpm@linux-foundation.org
Subject: - mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:59 -0700
Message-ID: <200804282150.m3SLoxEe017537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbYD1Vvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: remember what the preferred zone is for zone_statistics
has been removed from the -mm tree.  Its filename was
     mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remember what the preferred zone is for zone_statistics
From: Mel Gorman <mel@csn.ul.ie>

On NUMA, zone_statistics() is used to record events like numa hit, miss and
foreign.  It assumes that the first zone in a zonelist is the preferred zone. 
When multiple zonelists are replaced by one that is filtered, this is no
longer the case.

This patch records what the preferred zone is rather than assuming the first
zone in the zonelist is it.  This simplifies the reading of later patches in
this set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 mm/page_alloc.c        |    9 +++++----
 mm/vmstat.c            |    6 +++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/vmstat.h~mm-remember-what-the-preferred-zone-is-for-zone_statistics include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-remember-what-the-preferred-zone-is-for-zone_statistics
+++ a/include/linux/vmstat.h
@@ -174,7 +174,7 @@ static inline unsigned long node_page_st
 		zone_page_state(&zones[ZONE_MOVABLE], item);
 }
 
-extern void zone_statistics(struct zonelist *, struct zone *);
+extern void zone_statistics(struct zone *, struct zone *);
 
 #else
 
diff -puN mm/page_alloc.c~mm-remember-what-the-preferred-zone-is-for-zone_statistics mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remember-what-the-preferred-zone-is-for-zone_statistics
+++ a/mm/page_alloc.c
@@ -1050,7 +1050,7 @@ void split_page(struct page *page, unsig
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
  * or two.
  */
-static struct page *buffered_rmqueue(struct zonelist *zonelist,
+static struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, int order, gfp_t gfp_flags)
 {
 	unsigned long flags;
@@ -1102,7 +1102,7 @@ again:
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
-	zone_statistics(zonelist, zone);
+	zone_statistics(preferred_zone, zone);
 	local_irq_restore(flags);
 	put_cpu();
 
@@ -1383,7 +1383,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	struct zone **z;
 	struct page *page = NULL;
 	int classzone_idx = zone_idx(zonelist->zones[0]);
-	struct zone *zone;
+	struct zone *zone, *preferred_zone;
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
@@ -1395,6 +1395,7 @@ zonelist_scan:
 	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 	 */
 	z = zonelist->zones;
+	preferred_zone = *z;
 
 	do {
 		/*
@@ -1433,7 +1434,7 @@ zonelist_scan:
 			}
 		}
 
-		page = buffered_rmqueue(zonelist, zone, order, gfp_mask);
+		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
 		if (page)
 			break;
 this_zone_full:
diff -puN mm/vmstat.c~mm-remember-what-the-preferred-zone-is-for-zone_statistics mm/vmstat.c
--- a/mm/vmstat.c~mm-remember-what-the-preferred-zone-is-for-zone_statistics
+++ a/mm/vmstat.c
@@ -364,13 +364,13 @@ void refresh_cpu_vm_stats(int cpu)
  *
  * Must be called with interrupts disabled.
  */
-void zone_statistics(struct zonelist *zonelist, struct zone *z)
+void zone_statistics(struct zone *preferred_zone, struct zone *z)
 {
-	if (z->zone_pgdat == zonelist->zones[0]->zone_pgdat) {
+	if (z->zone_pgdat == preferred_zone->zone_pgdat) {
 		__inc_zone_state(z, NUMA_HIT);
 	} else {
 		__inc_zone_state(z, NUMA_MISS);
-		__inc_zone_state(zonelist->zones[0], NUMA_FOREIGN);
+		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
 	if (z->node == numa_node_id())
 		__inc_zone_state(z, NUMA_LOCAL);
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

