From: akpm@linux-foundation.org
Subject: + mm-use-compaction-feedback-for-thp-backoff-conditions.patch
 added to -mm tree
Date: Thu, 21 Apr 2016 15:50:14 -0700
Message-ID: <57195926.patclE4oy+Inezla%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbcDUWuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use compaction feedback for thp backoff conditions
has been added to the -mm tree.  Its filename is
     mm-use-compaction-feedback-for-thp-backoff-conditions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-compaction-feedback-for-thp-backoff-conditions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-compaction-feedback-for-thp-backoff-conditions.patch

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
Subject: mm: use compaction feedback for thp backoff conditions

THP requests skip the direct reclaim if the compaction is either deferred
or contended to reduce stalls which wouldn't help the allocation success
anyway.  These checks are ignoring other potential feedback modes which we
have available now.

It clearly doesn't make much sense to go and reclaim few pages if the
previous compaction has failed.

We can also simplify the check by using compaction_withdrawn which checks
for both COMPACT_CONTENDED and COMPACT_DEFERRED.  This check is however
covering more reasons why the compaction was withdrawn.  None of them
should be a problem for the THP case though.

It is safe to back of if we see COMPACT_SKIPPED because that means that
compaction_suitable failed and a single round of the reclaim is unlikely
to make any difference here.  We would have to be close to the low
watermark to reclaim enough and even then there is no guarantee that the
compaction would make any progress while the direct reclaim would have
caused the stall.

COMPACT_PARTIAL_SKIPPED is slightly different because that means that we
have only seen a part of the zone so a retry would make some sense.  But
it would be a compaction retry not a reclaim retry to perform.  We are not
doing that and that might indeed lead to situations where THP fails but
this should happen only rarely and it would be really hard to measure.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff -puN mm/page_alloc.c~mm-use-compaction-feedback-for-thp-backoff-conditions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-compaction-feedback-for-thp-backoff-conditions
+++ a/mm/page_alloc.c
@@ -3527,25 +3527,14 @@ retry:
 	if (page)
 		goto got_pg;
 
-	/* Checks for THP-specific high-order allocations */
-	if (is_thp_gfp_mask(gfp_mask)) {
-		/*
-		 * If compaction is deferred for high-order allocations, it is
-		 * because sync compaction recently failed. If this is the case
-		 * and the caller requested a THP allocation, we do not want
-		 * to heavily disrupt the system, so we fail the allocation
-		 * instead of entering direct reclaim.
-		 */
-		if (compact_result == COMPACT_DEFERRED)
-			goto nopage;
-
-		/*
-		 * Compaction is contended so rather back off than cause
-		 * excessive stalls.
-		 */
-		if(compact_result == COMPACT_CONTENDED)
-			goto nopage;
-	}
+	/*
+	 * Checks for THP-specific high-order allocations and back off
+	 * if the the compaction backed off or failed
+	 */
+	if (is_thp_gfp_mask(gfp_mask) &&
+			(compaction_withdrawn(compact_result) ||
+			 compaction_failed(compact_result)))
+		goto nopage;
 
 	/*
 	 * It can become very expensive to allocate transparent hugepages at
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch

