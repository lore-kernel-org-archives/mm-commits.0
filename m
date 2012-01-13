From: akpm@linux-foundation.org
Subject: [merged] mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:21 -0800
Message-ID: <20120113203521.D22971E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55057 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab2AMUfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:22 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so207300ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page allocator: do not call direct reclaim for THP allocations while compaction is deferred
has been removed from the -mm tree.  Its filename was
     mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page allocator: do not call direct reclaim for THP allocations while compaction is deferred

If compaction is deferred, direct reclaim is used to try to free enough
pages for the allocation to succeed.  For small high-orders, this has a
reasonable chance of success.  However, if the caller has specified
__GFP_NO_KSWAPD to limit the disruption to the system, it makes more sense
to fail the allocation rather than stall the caller in direct reclaim. 
This patch skips direct reclaim if compaction is deferred and the caller
specifies __GFP_NO_KSWAPD.

Async compaction only considers a subset of pages so it is possible for
compaction to be deferred prematurely and not enter direct reclaim even in
cases where it should.  To compensate for this, this patch also defers
compaction only if sync compaction failed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred
+++ a/mm/page_alloc.c
@@ -1981,14 +1981,20 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress,
-	bool sync_migration)
+	int migratetype, bool sync_migration,
+	bool *deferred_compaction,
+	unsigned long *did_some_progress)
 {
 	struct page *page;
 
-	if (!order || compaction_deferred(preferred_zone))
+	if (!order)
 		return NULL;
 
+	if (compaction_deferred(preferred_zone)) {
+		*deferred_compaction = true;
+		return NULL;
+	}
+
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration);
@@ -2016,7 +2022,13 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		 * but not enough to satisfy watermarks.
 		 */
 		count_vm_event(COMPACTFAIL);
-		defer_compaction(preferred_zone);
+
+		/*
+		 * As async compaction considers a subset of pageblocks, only
+		 * defer if the failure was a sync compaction failure.
+		 */
+		if (sync_migration)
+			defer_compaction(preferred_zone);
 
 		cond_resched();
 	}
@@ -2028,8 +2040,9 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress,
-	bool sync_migration)
+	int migratetype, bool sync_migration,
+	bool *deferred_compaction,
+	unsigned long *did_some_progress)
 {
 	return NULL;
 }
@@ -2179,6 +2192,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	bool sync_migration = false;
+	bool deferred_compaction = false;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2259,12 +2273,22 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress,
-					sync_migration);
+					migratetype, sync_migration,
+					&deferred_compaction,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 	sync_migration = true;
 
+	/*
+	 * If compaction is deferred for high-order allocations, it is because
+	 * sync compaction recently failed. In this is the case and the caller
+	 * has requested the system not be heavily disrupted, fail the
+	 * allocation now instead of entering direct reclaim
+	 */
+	if (deferred_compaction && (gfp_mask & __GFP_NO_KSWAPD))
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
@@ -2328,8 +2352,9 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress,
-					sync_migration);
+					migratetype, sync_migration,
+					&deferred_compaction,
+					&did_some_progress);
 		if (page)
 			goto got_pg;
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch

