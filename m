From: akpm@linux-foundation.org
Subject: + page-allocator-calculate-the-migratetype-for-allocation-only-once.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:07:49 -0700
Message-ID: <200904232307.n3NN7nKD009499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523AbZDWXNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: calculate the migratetype for allocation only once
has been added to the -mm tree.  Its filename is
     page-allocator-calculate-the-migratetype-for-allocation-only-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-calculate-the-migratetype-for-allocation-only-once mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-calculate-the-migratetype-for-allocation-only-once
+++ a/mm/page_alloc.c
@@ -1065,13 +1065,13 @@ void split_page(struct page *page, unsig
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
@@ -1393,7 +1393,7 @@ static void zlc_mark_zone_full(struct zo
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone)
+		struct zone *preferred_zone, int migratetype)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
@@ -1436,7 +1436,8 @@ zonelist_scan:
 			}
 		}
 
-		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
+		page = buffered_rmqueue(preferred_zone, zone, order,
+						gfp_mask, migratetype);
 		if (page)
 			break;
 this_zone_full:
@@ -1498,7 +1499,8 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	struct page *page;
 
@@ -1516,7 +1518,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone);
+		preferred_zone, migratetype);
 	if (page)
 		goto out;
 
@@ -1537,7 +1539,7 @@ static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
@@ -1570,7 +1572,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-					alloc_flags, preferred_zone);
+					alloc_flags, preferred_zone,
+					migratetype);
 	return page;
 }
 
@@ -1590,14 +1593,15 @@ is_allocation_high_priority(struct task_
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
@@ -1620,7 +1624,8 @@ void wake_all_kswapd(unsigned int order,
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -1671,7 +1676,8 @@ restart:
 	 */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 						high_zoneidx, alloc_flags,
-						preferred_zone);
+						preferred_zone,
+						migratetype);
 	if (page)
 		goto got_pg;
 
@@ -1681,7 +1687,8 @@ rebalance:
 		/* Do not dip into emergency reserves if specified */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			page = __alloc_pages_high_priority(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask, preferred_zone);
+				zonelist, high_zoneidx, nodemask, preferred_zone,
+				migratetype);
 			if (page)
 				goto got_pg;
 		}
@@ -1699,7 +1706,7 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					&did_some_progress);
+					migratetype, &did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -1711,7 +1718,8 @@ rebalance:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
-					nodemask, preferred_zone);
+					nodemask, preferred_zone,
+					migratetype);
 			if (page)
 				goto got_pg;
 
@@ -1758,6 +1766,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
 	struct page *page;
+	int migratetype = allocflags_to_migratetype(gfp_mask);
 
 	lockdep_trace_alloc(gfp_mask);
 
@@ -1782,11 +1791,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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

vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
add-debugging-aid-for-memory-initialisation-problems.patch

