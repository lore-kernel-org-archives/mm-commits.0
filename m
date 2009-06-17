From: akpm@linux-foundation.org
Subject: [merged] page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:47 -0700
Message-ID: <200906171833.n5HIXlTB032267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759505AbZFQSef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: calculate the preferred zone for allocation only once
has been removed from the -mm tree.  Its filename was
     page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: calculate the preferred zone for allocation only once
From: Mel Gorman <mel@csn.ul.ie>

get_page_from_freelist() can be called multiple times for an allocation. 
Part of this calculates the preferred_zone which is the first usable zone
in the zonelist but the zone depends on the GFP flags specified at the
beginning of the allocation call.  This patch calculates preferred_zone
once.  It's safe to do this because if preferred_zone is NULL at the start
of the call, no amount of direct reclaim or other actions will change the
fact the allocation will fail.

[akpm@linux-foundation.org: remove (void) casts]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   54 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-calculate-the-preferred-zone-for-allocation-only-once mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-calculate-the-preferred-zone-for-allocation-only-once
+++ a/mm/page_alloc.c
@@ -1388,26 +1388,21 @@ static void zlc_mark_zone_full(struct zo
  */
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
-		struct zonelist *zonelist, int high_zoneidx, int alloc_flags)
+		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
+		struct zone *preferred_zone)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
 	int classzone_idx;
-	struct zone *zone, *preferred_zone;
+	struct zone *zone;
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
-							&preferred_zone);
-	if (!preferred_zone)
-		return NULL;
-
-	classzone_idx = zone_idx(preferred_zone);
-
 	if (WARN_ON_ONCE(order >= MAX_ORDER))
 		return NULL;
 
+	classzone_idx = zone_idx(preferred_zone);
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -1500,7 +1495,7 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	struct page *page;
 
@@ -1517,7 +1512,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	 */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
-		ALLOC_WMARK_HIGH|ALLOC_CPUSET);
+		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
+		preferred_zone);
 	if (page)
 		goto out;
 
@@ -1537,7 +1533,8 @@ out:
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, unsigned long *did_some_progress)
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
@@ -1569,7 +1566,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
-					zonelist, high_zoneidx, alloc_flags);
+					zonelist, high_zoneidx,
+					alloc_flags, preferred_zone);
 	return page;
 }
 
@@ -1589,13 +1587,14 @@ is_allocation_high_priority(struct task_
 static inline struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	struct page *page;
 
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
+			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
+			preferred_zone);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			congestion_wait(WRITE, HZ/50);
@@ -1618,7 +1617,7 @@ void wake_all_kswapd(unsigned int order,
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -1668,7 +1667,8 @@ restart:
 	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 	 */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
-						high_zoneidx, alloc_flags);
+						high_zoneidx, alloc_flags,
+						preferred_zone);
 	if (page)
 		goto got_pg;
 
@@ -1678,7 +1678,7 @@ rebalance:
 		/* Do not dip into emergency reserves if specified */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			page = __alloc_pages_high_priority(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask);
+				zonelist, high_zoneidx, nodemask, preferred_zone);
 			if (page)
 				goto got_pg;
 		}
@@ -1695,7 +1695,8 @@ rebalance:
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask,
-					alloc_flags, &did_some_progress);
+					alloc_flags, preferred_zone,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -1707,7 +1708,7 @@ rebalance:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
-					nodemask);
+					nodemask, preferred_zone);
 			if (page)
 				goto got_pg;
 
@@ -1752,6 +1753,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	struct zone *preferred_zone;
 	struct page *page;
 
 	lockdep_trace_alloc(gfp_mask);
@@ -1769,11 +1771,19 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	/* The preferred zone is used for statistics later */
+	first_zones_zonelist(zonelist, high_zoneidx, nodemask, &preferred_zone);
+	if (!preferred_zone)
+		return NULL;
+
+	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
+			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
+			preferred_zone);
 	if (unlikely(!page))
 		page = __alloc_pages_slowpath(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask);
+				zonelist, high_zoneidx, nodemask,
+				preferred_zone);
 
 	return page;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

