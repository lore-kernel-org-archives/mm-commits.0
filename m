From: akpm@linux-foundation.org
Subject: + page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:07:52 -0700
Message-ID: <200904232307.n3NN7r3p009578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760790AbZDWXNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, neilb@suse.de, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: calculate the alloc_flags for allocation only once
has been added to the -mm tree.  Its filename is
     page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   94 ++++++++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 44 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-calculate-the-alloc_flags-for-allocation-only-once mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-calculate-the-alloc_flags-for-allocation-only-once
+++ a/mm/page_alloc.c
@@ -1577,15 +1577,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
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
@@ -1621,6 +1612,42 @@ void wake_all_kswapd(unsigned int order,
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
@@ -1651,56 +1678,35 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
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

linux-next.patch
lockdep-dont-print-lockdep-taint-message-for-lockdep.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
rb_tree-make-clear-distinction-between-two-different-cases-in-rb_erase.patch
rb_tree-remove-redundant-if-condition-in-rb_erase.patch
documentation-rbtreetxt-fix-errors-in-sample-code.patch

