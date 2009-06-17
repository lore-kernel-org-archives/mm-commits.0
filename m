From: akpm@linux-foundation.org
Subject: [merged] page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:53 -0700
Message-ID: <200906171833.n5HIXr0n032422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760031AbZFQSeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, neilb@suse.de, nickpiggin@yahoo.com.a


The patch titled
     page allocator: calculate the alloc_flags for allocation only once
has been removed from the -mm tree.  Its filename was
     page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: calculate the alloc_flags for allocation only once
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Factor out the mapping between GFP and alloc_flags only once.  Once
factored out, it only needs to be calculated once but some care must be
taken.

[neilb@suse.de says]
As the test:

-       if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-                       && !in_interrupt()) {
-               if (!(gfp_mask & __GFP_NOMEMALLOC)) {

has been replaced with a slightly weaker one:

+       if (alloc_flags & ALLOC_NO_WATERMARKS) {

Without care, this would allow recursion into the allocator via direct
reclaim.  This patch ensures we do not recurse when PF_MEMALLOC is set but
TF_MEMDIE callers are now allowed to directly reclaim where they would
have been prevented in the past.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Neil Brown <neilb@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   94 ++++++++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 44 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-calculate-the-alloc_flags-for-allocation-only-once mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-calculate-the-alloc_flags-for-allocation-only-once
+++ a/mm/page_alloc.c
@@ -1574,15 +1574,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	return page;
 }
 
-static inline int
-is_allocation_high_priority(struct task_struct *p, gfp_t gfp_mask)
-{
-	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-			&& !in_interrupt())
-		return 1;
-	return 0;
-}
-
 /*
  * This is called in the allocator slow-path if the allocation request is of
  * sufficient urgency to ignore watermarks and take other desperate measures
@@ -1618,6 +1609,42 @@ void wake_all_kswapd(unsigned int order,
 		wakeup_kswapd(zone, order);
 }
 
+static inline int
+gfp_to_alloc_flags(gfp_t gfp_mask)
+{
+	struct task_struct *p = current;
+	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
+	const gfp_t wait = gfp_mask & __GFP_WAIT;
+
+	/*
+	 * The caller may dip into page reserves a bit more if the caller
+	 * cannot run direct reclaim, or if the caller has realtime scheduling
+	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
+	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
+	 */
+	if (gfp_mask & __GFP_HIGH)
+		alloc_flags |= ALLOC_HIGH;
+
+	if (!wait) {
+		alloc_flags |= ALLOC_HARDER;
+		/*
+		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
+		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
+		 */
+		alloc_flags &= ~ALLOC_CPUSET;
+	} else if (unlikely(rt_task(p)))
+		alloc_flags |= ALLOC_HARDER;
+
+	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
+		if (!in_interrupt() &&
+		    ((p->flags & PF_MEMALLOC) ||
+		     unlikely(test_thread_flag(TIF_MEMDIE))))
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+	}
+
+	return alloc_flags;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -1648,56 +1675,35 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
 	 * to how we want to proceed.
-	 *
-	 * The caller may dip into page reserves a bit more if the caller
-	 * cannot run direct reclaim, or if the caller has realtime scheduling
-	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	alloc_flags = ALLOC_WMARK_MIN;
-	if ((unlikely(rt_task(p)) && !in_interrupt()) || !wait)
-		alloc_flags |= ALLOC_HARDER;
-	if (gfp_mask & __GFP_HIGH)
-		alloc_flags |= ALLOC_HIGH;
-	if (wait)
-		alloc_flags |= ALLOC_CPUSET;
+	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
 restart:
-	/*
-	 * Go through the zonelist again. Let __GFP_HIGH and allocations
-	 * coming from realtime tasks go deeper into reserves.
-	 *
-	 * This is the last chance, in general, before the goto nopage.
-	 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
-	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
-	 */
+	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
-						high_zoneidx, alloc_flags,
-						preferred_zone,
-						migratetype);
+			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
+			preferred_zone, migratetype);
 	if (page)
 		goto got_pg;
 
 rebalance:
 	/* Allocate without watermarks if the context allows */
-	if (is_allocation_high_priority(p, gfp_mask)) {
-		/* Do not dip into emergency reserves if specified */
-		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			page = __alloc_pages_high_priority(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask, preferred_zone,
-				migratetype);
-			if (page)
-				goto got_pg;
-		}
-
-		/* Ensure no recursion into the allocator */
-		goto nopage;
+	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+		page = __alloc_pages_high_priority(gfp_mask, order,
+				zonelist, high_zoneidx, nodemask,
+				preferred_zone, migratetype);
+		if (page)
+			goto got_pg;
 	}
 
 	/* Atomic allocations - we can't balance anything */
 	if (!wait)
 		goto nopage;
 
+	/* Avoid recursion of direct reclaim */
+	if (p->flags & PF_MEMALLOC)
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
x86-fix-cpufreq-tsc-scaling.patch
procfs-provide-stack-information-for-threads-v08.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
wait_task_zombie-do-not-use-thread_group_cputime.patch

