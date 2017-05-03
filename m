From: akpm@linux-foundation.org
Subject: [patch 016/102] mm: remove unnecessary back-off function
 when retrying page reclaim
Date: Wed, 03 May 2017 14:52:16 -0700
Message-ID: <20170503215216.pLOon05Vm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47334 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVwS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove unnecessary back-off function when retrying page reclaim

The backoff mechanism is not needed.  If we have MAX_RECLAIM_RETRIES loops
without progress, we'll OOM anyway; backing off might cut one or two
iterations off that in the rare OOM case.  If we have intermittent success
reclaiming a few pages, the backoff function gets reset also, and so is of
little help in these scenarios.

We might want a backoff function for when there IS progress, but not
enough to be satisfactory.  But this isn't that.  Remove it.

Link: http://lkml.kernel.org/r/20170228214007.5621-10-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim
+++ a/mm/page_alloc.c
@@ -3515,11 +3515,10 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 /*
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
- * The reclaim feedback represented by did_some_progress (any progress during
- * the last reclaim round) and no_progress_loops (number of reclaim rounds without
- * any progress in a row) is considered as well as the reclaimable pages on the
- * applicable zone list (with a backoff mechanism which is a function of
- * no_progress_loops).
+ *
+ * We give up when we either have tried MAX_RECLAIM_RETRIES in a row
+ * without success, or when we couldn't even meet the watermark if we
+ * reclaimed all remaining pages on the LRU lists.
  *
  * Returns true if a retry is viable or false to enter the oom path.
  */
@@ -3564,13 +3563,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		bool wmark;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
-		available -= DIV_ROUND_UP((*no_progress_loops) * available,
-					  MAX_RECLAIM_RETRIES);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
 		/*
-		 * Would the allocation succeed if we reclaimed the whole
-		 * available?
+		 * Would the allocation succeed if we reclaimed all
+		 * reclaimable pages?
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac_classzone_idx(ac), alloc_flags, available);
_
