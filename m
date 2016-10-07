From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-more-reliably-increase-direct-compaction-priority-fix.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:39:27 -0700
Message-ID: <57f8322f.Nprp7hXLHrC1Vg7j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753920AbcJGXj3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: more reliably increase direct compaction priority-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-more-reliably-increase-direct-compaction-priority-fix.patch

This patch was dropped because it was folded into mm-compaction-more-reliably-increase-direct-compaction-priority.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: more reliably increase direct compaction priority-fix

When increasing the compaction priority, also reset retries.  Otherwise we
can consume all retries on the lower priorities.  Also pull the retries
increment into should_compact_retry() so it counts only the rounds where
we actually rely on it.

Suggested-by: Michal Hocko <mhocko@suse.com>
Link: http://lkml.kernel.org/r/20160926162025.21555-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-more-reliably-increase-direct-compaction-priority-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-more-reliably-increase-direct-compaction-priority-fix
+++ a/mm/page_alloc.c
@@ -3160,13 +3160,16 @@ static inline bool
 should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
-		     int compaction_retries)
+		     int *compaction_retries)
 {
 	int max_retries = MAX_COMPACT_RETRIES;
 
 	if (!order)
 		return false;
 
+	if (compaction_made_progress(compact_result))
+		(*compaction_retries)++;
+
 	/*
 	 * compaction considers all the zone as desperately out of memory
 	 * so it doesn't really make much sense to retry except when the
@@ -3194,16 +3197,17 @@ should_compact_retry(struct alloc_contex
 	 */
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
 		max_retries /= 4;
-	if (compaction_retries <= max_retries)
+	if (*compaction_retries <= max_retries)
 		return true;
 
 	/*
-	 * Make sure there is at least one attempt at the highest priority
-	 * if we exhausted all retries at the lower priorities
+	 * Make sure there are attempts at the highest priority if we exhausted
+	 * all retries or failed at the lower priorities.
 	 */
 check_priority:
 	if (*compact_priority > MIN_COMPACT_PRIORITY) {
 		(*compact_priority)--;
+		*compaction_retries = 0;
 		return true;
 	}
 	return false;
@@ -3222,7 +3226,7 @@ static inline bool
 should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
-		     int compaction_retries)
+		     int *compaction_retries)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -3624,9 +3628,6 @@ retry:
 	if (page)
 		goto got_pg;
 
-	if (order && compaction_made_progress(compact_result))
-		compaction_retries++;
-
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
 		goto nopage;
@@ -3661,7 +3662,7 @@ retry:
 	if (did_some_progress > 0 &&
 			should_compact_retry(ac, order, alloc_flags,
 				compact_result, &compact_priority,
-				compaction_retries))
+				&compaction_retries))
 		goto retry;
 
 	/* Reclaim has failed us, start killing things */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch
mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch
mm-compaction-restrict-fragindex-to-costly-orders.patch

