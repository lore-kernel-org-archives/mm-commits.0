From: akpm@linux-foundation.org
Subject: [merged] page-allocator-calculate-the-migratetype-for-allocation-only-once.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:50 -0700
Message-ID: <200906171833.n5HIXoDD032358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760024AbZFQSef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: calculate the migratetype for allocation only once
has been removed from the -mm tree.  Its filename was
     page-allocator-calculate-the-migratetype-for-allocation-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: calculate the migratetype for allocation only once
From: Mel Gorman <mel@csn.ul.ie>

GFP mask is converted into a migratetype when deciding which pagelist to
take a page from.  However, it is happening multiple times per allocation,
at least once per zone traversed.  Calculate it once.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-calculate-the-migratetype-for-allocation-only-once mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-calculate-the-migratetype-for-allocation-only-once
+++ a/mm/page_alloc.c
@@ -1061,13 +1061,13 @@ void split_page(struct page *page, unsig
  * or two.
  */
 static struct page *buffered_rmqueue(struct zone *preferred_zone,
-			struct zone *zone, int order, gfp_t gfp_flags)
+			struct zone *zone, int order, gfp_t gfp_flags,
+			int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
 	int cpu;
-	int migratetype = allocflags_to_migratetype(gfp_flags);
 
 again:
 	cpu  = get_cpu();
@@ -1389,7 +1389,7 @@ static void zlc_mark_zone_full(struct zo
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone)
+		struct zone *preferred_zone, int migratetype)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
@@ -1433,7 +1433,8 @@ zonelist_scan:
 			}
 		}
 
-		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
+		page = buffered_rmqueue(preferred_zone, zone, order,
+						gfp_mask, migratetype);
 		if (page)
 			break;
 this_zone_full:
@@ -1495,7 +1496,8 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	struct page *page;
 
@@ -1513,7 +1515,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone);
+		preferred_zone, migratetype);
 	if (page)
 		goto out;
 
@@ -1534,7 +1536,7 @@ static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
@@ -1567,7 +1569,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-					alloc_flags, preferred_zone);
+					alloc_flags, preferred_zone,
+					migratetype);
 	return page;
 }
 
@@ -1587,14 +1590,15 @@ is_allocation_high_priority(struct task_
 static inline struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	struct page *page;
 
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone);
+			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			congestion_wait(WRITE, HZ/50);
@@ -1617,7 +1621,8 @@ void wake_all_kswapd(unsigned int order,
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -1668,7 +1673,8 @@ restart:
 	 */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 						high_zoneidx, alloc_flags,
-						preferred_zone);
+						preferred_zone,
+						migratetype);
 	if (page)
 		goto got_pg;
 
@@ -1678,7 +1684,8 @@ rebalance:
 		/* Do not dip into emergency reserves if specified */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			page = __alloc_pages_high_priority(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask, preferred_zone);
+				zonelist, high_zoneidx, nodemask, preferred_zone,
+				migratetype);
 			if (page)
 				goto got_pg;
 		}
@@ -1696,7 +1703,7 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					&did_some_progress);
+					migratetype, &did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -1708,7 +1715,8 @@ rebalance:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
-					nodemask, preferred_zone);
+					nodemask, preferred_zone,
+					migratetype);
 			if (page)
 				goto got_pg;
 
@@ -1755,6 +1763,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
 	struct page *page;
+	int migratetype = allocflags_to_migratetype(gfp_mask);
 
 	lockdep_trace_alloc(gfp_mask);
 
@@ -1779,11 +1788,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
-			preferred_zone);
+			preferred_zone, migratetype);
 	if (unlikely(!page))
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone);
+				preferred_zone, migratetype);
 
 	return page;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

