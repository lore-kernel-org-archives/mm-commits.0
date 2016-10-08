From: akpm@linux-foundation.org
Subject: [patch 076/127] mm, page_alloc: pull no_progress_loops update to
 should_reclaim_retry()
Date: Fri, 07 Oct 2016 17:00:40 -0700
Message-ID: <57f83728.fQmIRkFztSsfU7c1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39344 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932714AbcJHAAl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: pull no_progress_loops update to should_reclaim_retry()

The should_reclaim_retry() makes decisions based on no_progress_loops, so
it makes sense to also update the counter there.  It will be also
consistent with should_compact_retry() and compaction_retries.  No
functional change.

[hillf.zj@alibaba-inc.com: fix missing pointer dereferences]
Link: http://lkml.kernel.org/r/20160926162025.21555-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry
+++ a/mm/page_alloc.c
@@ -3402,16 +3402,26 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, int no_progress_loops)
+		     bool did_some_progress, int *no_progress_loops)
 {
 	struct zone *zone;
 	struct zoneref *z;
 
 	/*
+	 * Costly allocations might have made a progress but this doesn't mean
+	 * their order will become available due to high fragmentation so
+	 * always increment the no progress counter for them
+	 */
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+		*no_progress_loops = 0;
+	else
+		(*no_progress_loops)++;
+
+	/*
 	 * Make sure we converge to OOM if we cannot make any progress
 	 * several times in the row.
 	 */
-	if (no_progress_loops > MAX_RECLAIM_RETRIES)
+	if (*no_progress_loops > MAX_RECLAIM_RETRIES)
 		return false;
 
 	/*
@@ -3426,7 +3436,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		unsigned long reclaimable;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
-		available -= DIV_ROUND_UP(no_progress_loops * available,
+		available -= DIV_ROUND_UP((*no_progress_loops) * available,
 					  MAX_RECLAIM_RETRIES);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
@@ -3642,18 +3652,8 @@ retry:
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
 		goto nopage;
 
-	/*
-	 * Costly allocations might have made a progress but this doesn't mean
-	 * their order will become available due to high fragmentation so
-	 * always increment the no progress counter for them
-	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
-		no_progress_loops = 0;
-	else
-		no_progress_loops++;
