From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-set-alloc_flags-only-once-in-slowpath.patch removed from -mm
 tree
Date: Fri, 29 Jul 2016 11:57:29 -0700
Message-ID: <579ba719.y/llr69Bb/kHST+V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcG2S5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: set alloc_flags only once in slowpath
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-set-alloc_flags-only-once-in-slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: set alloc_flags only once in slowpath

In __alloc_pages_slowpath(), alloc_flags doesn't change after it's
initialized, so move the initialization above the retry: label.  Also make
the comment above the initialization more descriptive.

The only exception in the alloc_flags being constant is
ALLOC_NO_WATERMARKS, which may change due to TIF_MEMDIE being set on the
allocating thread.  We can fix this, and make the code simpler and a bit
more effective at the same time, by moving the part that determines
ALLOC_NO_WATERMARKS from gfp_to_alloc_flags() to gfp_pfmemalloc_allowed().
This means we don't have to mask out ALLOC_NO_WATERMARKS in numerous
places in __alloc_pages_slowpath() anymore.  The only two tests for the
flag can instead call gfp_pfmemalloc_allowed().

Link: http://lkml.kernel.org/r/20160721073614.24395-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   52 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-set-alloc_flags-only-once-in-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-set-alloc_flags-only-once-in-slowpath
+++ a/mm/page_alloc.c
@@ -3119,8 +3119,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	 */
 	count_vm_event(COMPACTSTALL);
 
-	page = get_page_from_freelist(gfp_mask, order,
-					alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
+	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
 
 	if (page) {
 		struct zone *zone = page_zone(page);
@@ -3288,8 +3287,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 		return NULL;
 
 retry:
-	page = get_page_from_freelist(gfp_mask, order,
-					alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
+	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -3351,16 +3349,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-		if (gfp_mask & __GFP_MEMALLOC)
-			alloc_flags |= ALLOC_NO_WATERMARKS;
-		else if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
-			alloc_flags |= ALLOC_NO_WATERMARKS;
-		else if (!in_interrupt() &&
-				((current->flags & PF_MEMALLOC) ||
-				 unlikely(test_thread_flag(TIF_MEMDIE))))
-			alloc_flags |= ALLOC_NO_WATERMARKS;
-	}
 #ifdef CONFIG_CMA
 	if (gfpflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
@@ -3370,7 +3358,19 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 
 bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 {
-	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
+	if (unlikely(gfp_mask & __GFP_NOMEMALLOC))
+		return false;
+
+	if (gfp_mask & __GFP_MEMALLOC)
+		return true;
+	if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
+		return true;
+	if (!in_interrupt() &&
+			((current->flags & PF_MEMALLOC) ||
+			 unlikely(test_thread_flag(TIF_MEMDIE))))
+		return true;
+
+	return false;
 }
 
 static inline bool is_thp_gfp_mask(gfp_t gfp_mask)
@@ -3503,36 +3503,36 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
 		gfp_mask &= ~__GFP_ATOMIC;
 
-retry:
-	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
-		wake_all_kswapds(order, ac);
-
 	/*
-	 * OK, we're below the kswapd watermark and have kicked background
-	 * reclaim. Now things get more complex, so set up alloc_flags according
-	 * to how we want to proceed.
+	 * The fast path uses conservative alloc_flags to succeed only until
+	 * kswapd needs to be woken up, and to avoid the cost of setting up
+	 * alloc_flags precisely. So we do that now.
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+retry:
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+		wake_all_kswapds(order, ac);
+
 	/*
 	 * Reset the zonelist iterators if memory policies can be ignored.
 	 * These allocations are high priority and system rather than user
 	 * orientated.
 	 */
-	if ((alloc_flags & ALLOC_NO_WATERMARKS) || !(alloc_flags & ALLOC_CPUSET)) {
+	if (!(alloc_flags & ALLOC_CPUSET) || gfp_pfmemalloc_allowed(gfp_mask)) {
 		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->high_zoneidx, ac->nodemask);
 	}
 
 	/* This is the last chance, in general, before the goto nopage. */
-	page = get_page_from_freelist(gfp_mask, order,
-				alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
+	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
 	if (page)
 		goto got_pg;
 
 	/* Allocate without watermarks if the context allows */
-	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+	if (gfp_pfmemalloc_allowed(gfp_mask)) {
+
 		page = get_page_from_freelist(gfp_mask, order,
 						ALLOC_NO_WATERMARKS, ac);
 		if (page)
_

Patches currently in -mm which might be from vbabka@suse.cz are


