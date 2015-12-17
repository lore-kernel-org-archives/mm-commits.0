From: akpm@linux-foundation.org
Subject: +
 mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch added
 to -mm tree
Date: Wed, 16 Dec 2015 16:00:10 -0800
Message-ID: <5671fb0a.B4fdHdbyUDav7KwO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbbLQAAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2015 19:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use watermark checks for __GFP_REPEAT high order allocations
has been added to the -mm tree.  Its filename is
     mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: use watermark checks for __GFP_REPEAT high order allocations

__alloc_pages_slowpath retries costly allocations until at least order
worth of pages were reclaimed or the watermark check for at least one zone
would succeed after all reclaiming all pages if the reclaim hasn't made
any progress.

The first condition was added by a41f24ea9fd6 ("page allocator: smarter
retry of costly-order allocations) and it assumed that lumpy reclaim could
have created a page of the sufficient order.  Lumpy reclaim, has been
removed quite some time ago so the assumption doesn't hold anymore.  It
would be more appropriate to check the compaction progress instead but
this patch simply removes the check and relies solely on the watermark
check.

To prevent from too many retries the no_progress_loops is not reseted
after a reclaim which made progress because we cannot assume it helped
high order situation.  Only costly allocation requests depended on
pages_reclaimed so we can drop it.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN mm/page_alloc.c~mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations
+++ a/mm/page_alloc.c
@@ -2959,17 +2959,17 @@ static inline bool is_thp_gfp_mask(gfp_t
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
  * The reclaim feedback represented by did_some_progress (any progress during
- * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
- * pages) and no_progress_loops (number of reclaim rounds without any progress
- * in a row) is considered as well as the reclaimable pages on the applicable
- * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ * the last reclaim round) and no_progress_loops (number of reclaim rounds without
+ * any progress in a row) is considered as well as the reclaimable pages on the
+ * applicable zone list (with a backoff mechanism which is a function of
+ * no_progress_loops).
  *
  * Returns true if a retry is viable or false to enter the oom path.
  */
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, unsigned long pages_reclaimed,
+		     bool did_some_progress,
 		     int no_progress_loops)
 {
 	struct zone *zone;
@@ -2983,13 +2983,8 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		return false;
 
 	/* Do not retry high order allocations unless they are __GFP_REPEAT */
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		if (!(gfp_mask & __GFP_REPEAT) || pages_reclaimed >= (1<<order))
-			return false;
-
-		if (did_some_progress)
-			return true;
-	}
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
+		return false;
 
 	/*
 	 * Keep reclaiming pages while there is a chance this will lead somewhere.
@@ -3055,7 +3050,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	struct page *page = NULL;
 	int alloc_flags;
-	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
@@ -3220,16 +3214,18 @@ retry:
 	if (gfp_mask & __GFP_NORETRY)
 		goto noretry;
 
-	if (did_some_progress) {
+	/*
+	 * Costly allocations might have made a progress but this doesn't mean
+	 * their order will become available due to high fragmentation so do
+	 * not reset the no progress counter for them
+	 */
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
 		no_progress_loops = 0;
-		pages_reclaimed += did_some_progress;
-	} else {
+	else
 		no_progress_loops++;
-	}
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, pages_reclaimed,
-				 no_progress_loops))
+				 did_some_progress > 0, no_progress_loops))
 		goto retry;
 
 	/* Reclaim has failed us, start killing things */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch

