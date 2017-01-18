From: akpm@linux-foundation.org
Subject: +
 mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch added to
 -mm tree
Date: Wed, 18 Jan 2017 13:52:04 -0800
Message-ID: <587fe384.G1UFrEEOLBy+ZLxs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753235AbdARVwL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consolidate GFP_NOFAIL checks in the allocator slowpath
has been added to the -mm tree.  Its filename is
     mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch

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
Subject: mm: consolidate GFP_NOFAIL checks in the allocator slowpath

Tetsuo Handa has pointed out that 0a0337e0d1d1 ("mm, oom: rework oom
detection") has subtly changed semantic for costly high order requests
with __GFP_NOFAIL and withtout __GFP_REPEAT and those can fail right now. 
My code inspection didn't reveal any such users in the tree but it is true
that this might lead to unexpected allocation failures and subsequent
OOPs.

__alloc_pages_slowpath wrt.  GFP_NOFAIL is hard to follow currently. 
There are few special cases but we are lacking a catch all place to be
sure we will not miss any case where the non failing allocation might
fail.  This patch reorganizes the code a bit and puts all those special
cases under nopage label which is the generic go-to-fail path.  Non
failing allocations are retried or those that cannot retry like
non-sleeping allocation go to the failure point directly.  This should
make the code flow much easier to follow and make it less error prone for
future changes.

While we are there we have to move the stall check up to catch
potentially looping non-failing allocations.

Link: http://lkml.kernel.org/r/20161220134904.21023-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   75 ++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff -puN mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath
+++ a/mm/page_alloc.c
@@ -3657,35 +3657,21 @@ retry:
 		goto got_pg;
 
 	/* Caller is not willing to reclaim, we can't balance anything */
-	if (!can_direct_reclaim) {
-		/*
-		 * All existing users of the __GFP_NOFAIL are blockable, so warn
-		 * of any new users that actually allow this type of allocation
-		 * to fail.
-		 */
-		WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL);
+	if (!can_direct_reclaim)
 		goto nopage;
-	}
 
-	/* Avoid recursion of direct reclaim */
-	if (current->flags & PF_MEMALLOC) {
-		/*
-		 * __GFP_NOFAIL request from this context is rather bizarre
-		 * because we cannot reclaim anything and only can loop waiting
-		 * for somebody to do a work for us.
-		 */
-		if (WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
-			cond_resched();
-			goto retry;
-		}
-		goto nopage;
+	/* Make sure we know about allocations which stall for too long */
+	if (time_after(jiffies, alloc_start + stall_timeout)) {
+		warn_alloc(gfp_mask, ac->nodemask,
+			"page allocation stalls for %ums, order:%u",
+			jiffies_to_msecs(jiffies-alloc_start), order);
+		stall_timeout += 10 * HZ;
 	}
 
-	/* Avoid allocations with no watermarks from looping endlessly */
-	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
+	/* Avoid recursion of direct reclaim */
+	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
-
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
 							&did_some_progress);
@@ -3709,14 +3695,6 @@ retry:
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
 		goto nopage;
 
-	/* Make sure we know about allocations which stall for too long */
-	if (time_after(jiffies, alloc_start + stall_timeout)) {
-		warn_alloc(gfp_mask, ac->nodemask,
-			"page allocation stalls for %ums, order:%u",
-			jiffies_to_msecs(jiffies-alloc_start), order);
-		stall_timeout += 10 * HZ;
-	}
-
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
 				 did_some_progress > 0, &no_progress_loops))
 		goto retry;
@@ -3738,6 +3716,10 @@ retry:
 	if (page)
 		goto got_pg;
 
+	/* Avoid allocations with no watermarks from looping endlessly */
+	if (test_thread_flag(TIF_MEMDIE))
+		goto nopage;
+
 	/* Retry as long as the OOM killer is making progress */
 	if (did_some_progress) {
 		no_progress_loops = 0;
@@ -3745,6 +3727,37 @@ retry:
 	}
 
 nopage:
+	/*
+	 * Make sure that __GFP_NOFAIL request doesn't leak out and make sure
+	 * we always retry
+	 */
+	if (gfp_mask & __GFP_NOFAIL) {
+		/*
+		 * All existing users of the __GFP_NOFAIL are blockable, so warn
+		 * of any new users that actually require GFP_NOWAIT
+		 */
+		if (WARN_ON_ONCE(!can_direct_reclaim))
+			goto fail;
+
+		/*
+		 * PF_MEMALLOC request from this context is rather bizarre
+		 * because we cannot reclaim anything and only can loop waiting
+		 * for somebody to do a work for us
+		 */
+		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
+
+		/*
+		 * non failing costly orders are a hard requirement which we
+		 * are not prepared for much so let's warn about these users
+		 * so that we can identify them and convert them to something
+		 * else.
+		 */
+		WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER);
+
+		cond_resched();
+		goto retry;
+	}
+fail:
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch

