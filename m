From: akpm@linux-foundation.org
Subject: +
 mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 15:53:39 -0800
Message-ID: <58b60d83.McRdBkt9G3HkziY4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdCAELY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 23:11:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary back-off function when retrying page reclaim
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim
+++ a/mm/page_alloc.c
@@ -3511,11 +3511,10 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
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
@@ -3560,13 +3559,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

