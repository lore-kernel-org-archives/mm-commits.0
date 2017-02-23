From: akpm@linux-foundation.org
Subject: [merged]
 mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:17:14 -0800
Message-ID: <58af515a.TSDI0+w0sYWojYoi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdBWVRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consolidate GFP_NOFAIL checks in the allocator slowpath
has been removed from the -mm tree.  Its filename was
     mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix alloc_flags may-be-used-uninitalized]
Link: http://lkml.kernel.org/r/20161220134904.21023-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   91 ++++++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 39 deletions(-)

diff -puN mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath
+++ a/mm/page_alloc.c
@@ -3577,6 +3577,14 @@ retry_cpuset:
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+
+	/*
+	 * The fast path uses conservative alloc_flags to succeed only until
+	 * kswapd needs to be woken up, and to avoid the cost of setting up
+	 * alloc_flags precisely. So we do that now.
+	 */
+	alloc_flags = gfp_to_alloc_flags(gfp_mask);
+
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
 	 * because we might have used different nodemask in the fast path, or
@@ -3588,14 +3596,6 @@ retry_cpuset:
 	if (!ac->preferred_zoneref->zone)
 		goto nopage;
 
-
-	/*
-	 * The fast path uses conservative alloc_flags to succeed only until
-	 * kswapd needs to be woken up, and to avoid the cost of setting up
-	 * alloc_flags precisely. So we do that now.
-	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask);
-
 	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
 		wake_all_kswapds(order, ac);
 
@@ -3672,35 +3672,21 @@ retry:
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
@@ -3724,14 +3710,6 @@ retry:
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
@@ -3760,6 +3738,10 @@ retry:
 	if (page)
 		goto got_pg;
 
+	/* Avoid allocations with no watermarks from looping endlessly */
+	if (test_thread_flag(TIF_MEMDIE))
+		goto nopage;
+
 	/* Retry as long as the OOM killer is making progress */
 	if (did_some_progress) {
 		no_progress_loops = 0;
@@ -3777,6 +3759,37 @@ nopage:
 	if (read_mems_allowed_retry(cpuset_mems_cookie))
 		goto retry_cpuset;
 
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

mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

