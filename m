From: akpm@linux-foundation.org
Subject: + page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:07:34 -0700
Message-ID: <200904232307.n3NN7Z1r009397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbZDWXNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: break up the allocator entry point into fast and slow paths
has been added to the -mm tree.  Its filename is
     page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch

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
Subject: page allocator: break up the allocator entry point into fast and slow paths
From: Mel Gorman <mel@csn.ul.ie>

The core of the page allocator is one giant function which allocates
memory on the stack and makes calculations that may not be needed for
every allocation.  This patch breaks up the allocator path into fast and
slow paths for clarity.  Note the slow paths are still inlined but the
entry is marked unlikely.  If they were not inlined, it actally increases
text size to generate the as there is only one call site.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  353 +++++++++++++++++++++++++++++-----------------
 1 file changed, 228 insertions(+), 125 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths
+++ a/mm/page_alloc.c
@@ -1461,47 +1461,171 @@ try_next_zone:
 	return page;
 }
 
-/*
- * This is the 'heart' of the zoned buddy allocator.
- */
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-			struct zonelist *zonelist, nodemask_t *nodemask)
+static inline int
+should_alloc_retry(gfp_t gfp_mask, unsigned int order,
+				unsigned long pages_reclaimed)
 {
-	const gfp_t wait = gfp_mask & __GFP_WAIT;
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	struct zoneref *z;
-	struct zone *zone;
-	struct page *page;
-	struct reclaim_state reclaim_state;
-	struct task_struct *p = current;
-	int do_retry;
-	int alloc_flags;
-	unsigned long did_some_progress;
-	unsigned long pages_reclaimed = 0;
+	/* Do not loop if specifically requested */
+	if (gfp_mask & __GFP_NORETRY)
+		return 0;
 
-	lockdep_trace_alloc(gfp_mask);
+	/*
+	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
+	 * means __GFP_NOFAIL, but that may not be true in other
+	 * implementations.
+	 */
+	if (order <= PAGE_ALLOC_COSTLY_ORDER)
+		return 1;
+
+	/*
+	 * For order > PAGE_ALLOC_COSTLY_ORDER, if __GFP_REPEAT is
+	 * specified, then we retry until we no longer reclaim any pages
+	 * (above), or we've reclaimed an order of pages at least as
+	 * large as the allocation's order. In both cases, if the
+	 * allocation still fails, we stop retrying.
+	 */
+	if (gfp_mask & __GFP_REPEAT && pages_reclaimed < (1 << order))
+		return 1;
 
-	might_sleep_if(wait);
+	/*
+	 * Don't let big-order allocations loop unless the caller
+	 * explicitly requests that.
+	 */
+	if (gfp_mask & __GFP_NOFAIL)
+		return 1;
 
-	if (should_fail_alloc_page(gfp_mask, order))
-		return NULL;
+	return 0;
+}
 
-	/* the list of zones suitable for gfp_mask */
-	z = zonelist->_zonerefs;
-	if (unlikely(!z->zone)) {
-		/*
-		 * Happens if we have an empty zonelist as a result of
-		 * GFP_THISNODE being used on a memoryless node
-		 */
+static inline struct page *
+__alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask)
+{
+	struct page *page;
+
+	/* Acquire the OOM killer lock for the zones in zonelist */
+	if (!try_set_zone_oom(zonelist, gfp_mask)) {
+		schedule_timeout_uninterruptible(1);
 		return NULL;
 	}
 
-restart:
-	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
+	/*
+	 * Go through the zonelist yet one more time, keep very high watermark
+	 * here, this is only to catch a parallel oom killing, we must fail if
+	 * we're still under heavy pressure.
+	 */
+	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
+		order, zonelist, high_zoneidx,
+		ALLOC_WMARK_HIGH|ALLOC_CPUSET);
 	if (page)
-		goto got_pg;
+		goto out;
+
+	/* The OOM killer will not help higher order allocs */
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		goto out;
+
+	/* Exhausted what can be done so it's blamo time */
+	out_of_memory(zonelist, gfp_mask, order);
+
+out:
+	clear_zonelist_oom(zonelist, gfp_mask);
+	return page;
+}
+
+/* The really slow allocator path where we enter direct reclaim */
+static inline struct page *
+__alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask, int alloc_flags, unsigned long *did_some_progress)
+{
+	struct page *page = NULL;
+	struct reclaim_state reclaim_state;
+	struct task_struct *p = current;
+
+	cond_resched();
+
+	/* We now go into synchronous reclaim */
+	cpuset_memory_pressure_bump();
+
+	/*
+	 * The task's cpuset might have expanded its set of allowable nodes
+	 */
+	p->flags |= PF_MEMALLOC;
+	lockdep_set_current_reclaim_state(gfp_mask);
+	reclaim_state.reclaimed_slab = 0;
+	p->reclaim_state = &reclaim_state;
+
+	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
+
+	p->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
+	p->flags &= ~PF_MEMALLOC;
+
+	cond_resched();
+
+	if (order != 0)
+		drain_all_pages();
+
+	if (likely(*did_some_progress))
+		page = get_page_from_freelist(gfp_mask, nodemask, order,
+					zonelist, high_zoneidx, alloc_flags);
+	return page;
+}
+
+static inline int
+is_allocation_high_priority(struct task_struct *p, gfp_t gfp_mask)
+{
+	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
+			&& !in_interrupt())
+		return 1;
+	return 0;
+}
+
+/*
+ * This is called in the allocator slow-path if the allocation request is of
+ * sufficient urgency to ignore watermarks and take other desperate measures
+ */
+static inline struct page *
+__alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask)
+{
+	struct page *page;
+
+	do {
+		page = get_page_from_freelist(gfp_mask, nodemask, order,
+			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
+
+		if (!page && gfp_mask & __GFP_NOFAIL)
+			congestion_wait(WRITE, HZ/50);
+	} while (!page && (gfp_mask & __GFP_NOFAIL));
+
+	return page;
+}
+
+static inline
+void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
+						enum zone_type high_zoneidx)
+{
+	struct zoneref *z;
+	struct zone *zone;
+
+	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
+		wakeup_kswapd(zone, order);
+}
+
+static inline struct page *
+__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask)
+{
+	const gfp_t wait = gfp_mask & __GFP_WAIT;
+	struct page *page = NULL;
+	int alloc_flags;
+	unsigned long pages_reclaimed = 0;
+	unsigned long did_some_progress;
+	struct task_struct *p = current;
 
 	/*
 	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
@@ -1514,8 +1638,7 @@ restart:
 	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-		wakeup_kswapd(zone, order);
+	wake_all_kswapd(order, zonelist, high_zoneidx);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -1535,6 +1658,7 @@ restart:
 	if (wait)
 		alloc_flags |= ALLOC_CPUSET;
 
+restart:
 	/*
 	 * Go through the zonelist again. Let __GFP_HIGH and allocations
 	 * coming from realtime tasks go deeper into reserves.
@@ -1548,23 +1672,18 @@ restart:
 	if (page)
 		goto got_pg;
 
-	/* This allocation should allow future memory freeing. */
-
 rebalance:
-	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-			&& !in_interrupt()) {
+	/* Allocate without watermarks if the context allows */
+	if (is_allocation_high_priority(p, gfp_mask)) {
+		/* Do not dip into emergency reserves if specified */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-nofail_alloc:
-			/* go through the zonelist yet again, ignoring mins */
-			page = get_page_from_freelist(gfp_mask, nodemask, order,
-				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
+			page = __alloc_pages_high_priority(gfp_mask, order,
+				zonelist, high_zoneidx, nodemask);
 			if (page)
 				goto got_pg;
-			if (gfp_mask & __GFP_NOFAIL) {
-				congestion_wait(WRITE, HZ/50);
-				goto nofail_alloc;
-			}
 		}
+
+		/* Ensure no recursion into the allocator */
 		goto nopage;
 	}
 
@@ -1572,93 +1691,42 @@ nofail_alloc:
 	if (!wait)
 		goto nopage;
 
-	cond_resched();
-
-	/* We now go into synchronous reclaim */
-	cpuset_memory_pressure_bump();
-
-	p->flags |= PF_MEMALLOC;
-
-	lockdep_set_current_reclaim_state(gfp_mask);
-	reclaim_state.reclaimed_slab = 0;
-	p->reclaim_state = &reclaim_state;
-
-	did_some_progress = try_to_free_pages(zonelist, order,
-						gfp_mask, nodemask);
-
-	p->reclaim_state = NULL;
-	lockdep_clear_current_reclaim_state();
-	p->flags &= ~PF_MEMALLOC;
+	/* Try direct reclaim and then allocating */
+	page = __alloc_pages_direct_reclaim(gfp_mask, order,
+					zonelist, high_zoneidx,
+					nodemask,
+					alloc_flags, &did_some_progress);
+	if (page)
+		goto got_pg;
 
-	cond_resched();
+	/*
+	 * If we failed to make any progress reclaiming, then we are
+	 * running out of options and have to consider going OOM
+	 */
+	if (!did_some_progress) {
+		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+			page = __alloc_pages_may_oom(gfp_mask, order,
+					zonelist, high_zoneidx,
+					nodemask);
+			if (page)
+				goto got_pg;
 
-	if (order != 0)
-		drain_all_pages();
+			/*
+			 * The OOM killer does not trigger for high-order allocations
+			 * but if no progress is being made, there are no other
+			 * options and retrying is unlikely to help
+			 */
+			if (order > PAGE_ALLOC_COSTLY_ORDER)
+				goto nopage;
 
-	if (likely(did_some_progress)) {
-		page = get_page_from_freelist(gfp_mask, nodemask, order,
-					zonelist, high_zoneidx, alloc_flags);
-		if (page)
-			goto got_pg;
-	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
-		if (!try_set_zone_oom(zonelist, gfp_mask)) {
-			schedule_timeout_uninterruptible(1);
 			goto restart;
 		}
-
-		/*
-		 * Go through the zonelist yet one more time, keep
-		 * very high watermark here, this is only to catch
-		 * a parallel oom killing, we must fail if we're still
-		 * under heavy pressure.
-		 */
-		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
-			order, zonelist, high_zoneidx,
-			ALLOC_WMARK_HIGH|ALLOC_CPUSET);
-		if (page) {
-			clear_zonelist_oom(zonelist, gfp_mask);
-			goto got_pg;
-		}
-
-		/* The OOM killer will not help higher order allocs so fail */
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			clear_zonelist_oom(zonelist, gfp_mask);
-			goto nopage;
-		}
-
-		out_of_memory(zonelist, gfp_mask, order);
-		clear_zonelist_oom(zonelist, gfp_mask);
-		goto restart;
 	}
 
-	/*
-	 * Don't let big-order allocations loop unless the caller explicitly
-	 * requests that.  Wait for some write requests to complete then retry.
-	 *
-	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
-	 * means __GFP_NOFAIL, but that may not be true in other
-	 * implementations.
-	 *
-	 * For order > PAGE_ALLOC_COSTLY_ORDER, if __GFP_REPEAT is
-	 * specified, then we retry until we no longer reclaim any pages
-	 * (above), or we've reclaimed an order of pages at least as
-	 * large as the allocation's order. In both cases, if the
-	 * allocation still fails, we stop retrying.
-	 */
+	/* Check if we should retry the allocation */
 	pages_reclaimed += did_some_progress;
-	do_retry = 0;
-	if (!(gfp_mask & __GFP_NORETRY)) {
-		if (order <= PAGE_ALLOC_COSTLY_ORDER) {
-			do_retry = 1;
-		} else {
-			if (gfp_mask & __GFP_REPEAT &&
-				pages_reclaimed < (1 << order))
-					do_retry = 1;
-		}
-		if (gfp_mask & __GFP_NOFAIL)
-			do_retry = 1;
-	}
-	if (do_retry) {
+	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
+		/* Wait for some write requests to complete then retry */
 		congestion_wait(WRITE, HZ/50);
 		goto rebalance;
 	}
@@ -1673,6 +1741,41 @@ nopage:
 	}
 got_pg:
 	return page;
+
+}
+
+/*
+ * This is the 'heart' of the zoned buddy allocator.
+ */
+struct page *
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
+			struct zonelist *zonelist, nodemask_t *nodemask)
+{
+	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	struct page *page;
+
+	lockdep_trace_alloc(gfp_mask);
+
+	might_sleep_if(gfp_mask & __GFP_WAIT);
+
+	if (should_fail_alloc_page(gfp_mask, order))
+		return NULL;
+
+	/*
+	 * Check the zones suitable for the gfp_mask contain at least one
+	 * valid zone. It's possible to have an empty zonelist as a result
+	 * of GFP_THISNODE and a memoryless node
+	 */
+	if (unlikely(!zonelist->_zonerefs->zone))
+		return NULL;
+
+	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
+			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
+	if (unlikely(!page))
+		page = __alloc_pages_slowpath(gfp_mask, order,
+				zonelist, high_zoneidx, nodemask);
+
+	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
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
add-debugging-aid-for-memory-initialisation-problems.patch

