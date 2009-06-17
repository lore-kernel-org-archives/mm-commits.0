From: akpm@linux-foundation.org
Subject: [merged] vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:40 -0700
Message-ID: <200906171836.n5HIae4w002793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbZFQSsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmscan: do not unconditionally treat zones that fail zone_reclaim() as full
has been removed from the -mm tree.  Its filename was
     vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: do not unconditionally treat zones that fail zone_reclaim() as full
From: Mel Gorman <mel@csn.ul.ie>

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim.  On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that
clean unmapped pages will be reclaimed if the zone watermarks are not
being met.  The problem is that zone_reclaim() failing at all means the
zone gets marked full.

This can cause situations where a zone is usable, but is being skipped
because it has been considered full.  Take a situation where a large tmpfs
mount is occuping a large percentage of memory overall.  The pages do not
get cleaned or reclaimed by zone_reclaim(), but the zone gets marked full
and the zonelist cache considers them not worth trying in the future.

This patch makes zone_reclaim() return more fine-grained information about
what occured when zone_reclaim() failued.  The zone only gets marked full
if it really is unreclaimable.  If it's a case that the scan did not occur
or if enough pages were not reclaimed with the limited reclaim_mode, then
the zone is simply skipped.

There is a side-effect to this patch.  Currently, if zone_reclaim()
successfully reclaimed SWAP_CLUSTER_MAX, an allocation attempt would go
ahead.  With this patch applied, zone watermarks are rechecked after
zone_reclaim() does some work.

This bug was introduced by commit 9276b1bc96a132f4068fdee00983c532f43d3a26
("memory page_alloc zonelist caching speedup") way back in 2.6.19 when the
zonelist_cache was introduced.  It was not intended that zone_reclaim()
aggressively consider the zone to be full when it failed as full direct
reclaim can still be an option.  Due to the age of the bug, it should be
considered a -stable candidate.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++++
 mm/page_alloc.c |   26 ++++++++++++++++++++++----
 mm/vmscan.c     |   11 ++++++-----
 3 files changed, 32 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full mm/internal.h
--- a/mm/internal.h~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full
+++ a/mm/internal.h
@@ -259,4 +259,8 @@ int __get_user_pages(struct task_struct 
 		     unsigned long start, int len, int flags,
 		     struct page **pages, struct vm_area_struct **vmas);
 
+#define ZONE_RECLAIM_NOSCAN	-2
+#define ZONE_RECLAIM_FULL	-1
+#define ZONE_RECLAIM_SOME	0
+#define ZONE_RECLAIM_SUCCESS	1
 #endif
diff -puN mm/page_alloc.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full
+++ a/mm/page_alloc.c
@@ -1462,15 +1462,33 @@ zonelist_scan:
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
+			int ret;
+
 			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-			if (!zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags)) {
-				if (!zone_reclaim_mode ||
-				    !zone_reclaim(zone, gfp_mask, order))
+			if (zone_watermark_ok(zone, order, mark,
+				    classzone_idx, alloc_flags))
+				goto try_this_zone;
+
+			if (zone_reclaim_mode == 0)
+				goto this_zone_full;
+
+			ret = zone_reclaim(zone, gfp_mask, order);
+			switch (ret) {
+			case ZONE_RECLAIM_NOSCAN:
+				/* did not scan */
+				goto try_next_zone;
+			case ZONE_RECLAIM_FULL:
+				/* scanned but unreclaimable */
+				goto this_zone_full;
+			default:
+				/* did we reclaim enough */
+				if (!zone_watermark_ok(zone, order, mark,
+						classzone_idx, alloc_flags))
 					goto this_zone_full;
 			}
 		}
 
+try_this_zone:
 		page = buffered_rmqueue(preferred_zone, zone, order,
 						gfp_mask, migratetype);
 		if (page)
diff -puN mm/vmscan.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full
+++ a/mm/vmscan.c
@@ -2492,16 +2492,16 @@ int zone_reclaim(struct zone *zone, gfp_
 	 */
 	if (zone_pagecache_reclaimable(zone) <= zone->min_unmapped_pages &&
 	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
-		return 0;
+		return ZONE_RECLAIM_FULL;
 
 	if (zone_is_all_unreclaimable(zone))
-		return 0;
+		return ZONE_RECLAIM_FULL;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!(gfp_mask & __GFP_WAIT) || (current->flags & PF_MEMALLOC))
-			return 0;
+		return ZONE_RECLAIM_NOSCAN;
 
 	/*
 	 * Only run zone reclaim on the local zone or on zones that do not
@@ -2511,10 +2511,11 @@ int zone_reclaim(struct zone *zone, gfp_
 	 */
 	node_id = zone_to_nid(zone);
 	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
-		return 0;
+		return ZONE_RECLAIM_NOSCAN;
 
 	if (zone_test_and_set_flag(zone, ZONE_RECLAIM_LOCKED))
-		return 0;
+		return ZONE_RECLAIM_NOSCAN;
+
 	ret = __zone_reclaim(zone, gfp_mask, order);
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

