From: akpm@linux-foundation.org
Subject: [patch 097/101] mm, page_alloc: restructure direct compaction
 handling in slowpath
Date: Thu, 28 Jul 2016 15:49:19 -0700
Message-ID: <579a8bef.e/XMptWPFqKJCyEx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcG1WtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, mgorman@techsingularity.net, mhocko@suse.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: restructure direct compaction handling in slowpath

The retry loop in __alloc_pages_slowpath is supposed to keep trying
reclaim and compaction (and OOM), until either the allocation succeeds, or
returns with failure.  Success here is more probable when reclaim precedes
compaction, as certain watermarks have to be met for compaction to even
try, and more free pages increase the probability of compaction success. 
On the other hand, starting with light async compaction (if the watermarks
allow it), can be more efficient, especially for smaller orders, if
there's enough free memory which is just fragmented.

Thus, the current code starts with compaction before reclaim, and to make
sure that the last reclaim is always followed by a final compaction,
there's another direct compaction call at the end of the loop.  This makes
the code hard to follow and adds some duplicated handling of
migration_mode decisions.  It's also somewhat inefficient that even if
reclaim or compaction decides not to retry, the final compaction is still
attempted.  Some gfp flags combination also shortcut these retry decisions
by "goto noretry;", making it even harder to follow.

This patch attempts to restructure the code with only minimal functional
changes.  The call to the first compaction and THP-specific checks are now
placed above the retry loop, and the "noretry" direct compaction is
removed.

The initial compaction is additionally restricted only to costly orders,
as we can expect smaller orders to be held back by watermarks, and only
larger orders to suffer primarily from fragmentation.  This better matches
the checks in reclaim's shrink_zones().

There are two other smaller functional changes.  One is that the upgrade
from async migration to light sync migration will always occur after the
initial compaction.  This is how it has been until recent patch "mm, oom:
protect !costly allocations some more", which introduced upgrading the
mode based on COMPACT_COMPLETE result, but kept the final compaction
always upgraded, which made it even more special.  It's better to return
to the simpler handling for now, as migration modes will be further
modified later in the series.

The second change is that once both reclaim and compaction declare it's
not worth to retry the reclaim/compact loop, there is no final compaction
attempt.  As argued above, this is intentional.  If that final compaction
were to succeed, it would be due to a wrong retry decision, or simply a
race with somebody else freeing memory for us.

The main outcome of this patch should be simpler code.  Logically, the
initial compaction without reclaim is the exceptional case to the
reclaim/compaction scheme, but prior to the patch, it was the last loop
iteration that was exceptional.  Now the code matches the logic better. 
The change also enable the following patches.

Link: http://lkml.kernel.org/r/20160721073614.24395-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  109 ++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 52 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-restructure-direct-compaction-handling-in-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restructure-direct-compaction-handling-in-slowpath
+++ a/mm/page_alloc.c
@@ -3479,7 +3479,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
-	enum migrate_mode migration_mode = MIGRATE_ASYNC;
+	enum migrate_mode migration_mode = MIGRATE_SYNC_LIGHT;
 	enum compact_result compact_result;
 	int compaction_retries = 0;
 	int no_progress_loops = 0;
@@ -3521,6 +3521,52 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	if (page)
 		goto got_pg;
 
+	/*
+	 * For costly allocations, try direct compaction first, as it's likely
+	 * that we have enough base pages and don't need to reclaim. Don't try
+	 * that for allocations that are allowed to ignore watermarks, as the
+	 * ALLOC_NO_WATERMARKS attempt didn't yet happen.
+	 */
+	if (can_direct_reclaim && order > PAGE_ALLOC_COSTLY_ORDER &&
+		!gfp_pfmemalloc_allowed(gfp_mask)) {
+		page = __alloc_pages_direct_compact(gfp_mask, order,
+						alloc_flags, ac,
+						MIGRATE_ASYNC,
+						&compact_result);
+		if (page)
+			goto got_pg;
+
+		/* Checks for THP-specific high-order allocations */
+		if (is_thp_gfp_mask(gfp_mask)) {
+			/*
+			 * If compaction is deferred for high-order allocations,
+			 * it is because sync compaction recently failed. If
+			 * this is the case and the caller requested a THP
+			 * allocation, we do not want to heavily disrupt the
+			 * system, so we fail the allocation instead of entering
+			 * direct reclaim.
+			 */
+			if (compact_result == COMPACT_DEFERRED)
+				goto nopage;
+
+			/*
+			 * Compaction is contended so rather back off than cause
+			 * excessive stalls.
+			 */
+			if (compact_result == COMPACT_CONTENDED)
+				goto nopage;
+
+			/*
+			 * It can become very expensive to allocate transparent
+			 * hugepages at fault, so use asynchronous memory
+			 * compaction for THP unless it is khugepaged trying to
+			 * collapse. All other requests should tolerate at
+			 * least light sync migration.
+			 */
+			if (!(current->flags & PF_KTHREAD))
+				migration_mode = MIGRATE_ASYNC;
+		}
+	}
 
 retry:
 	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
@@ -3575,55 +3621,33 @@ retry:
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
-	/*
-	 * Try direct compaction. The first pass is asynchronous. Subsequent
-	 * attempts after direct reclaim are synchronous
-	 */
+
+	/* Try direct reclaim and then allocating */
+	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
+							&did_some_progress);
+	if (page)
+		goto got_pg;
+
+	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
 					migration_mode,
 					&compact_result);
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
-
 	if (order && compaction_made_progress(compact_result))
 		compaction_retries++;
 
-	/* Try direct reclaim and then allocating */
-	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
-							&did_some_progress);
-	if (page)
-		goto got_pg;
-
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
-		goto noretry;
+		goto nopage;
 
 	/*
 	 * Do not retry costly high order allocations unless they are
 	 * __GFP_REPEAT
 	 */
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
-		goto noretry;
+		goto nopage;
 
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
@@ -3662,25 +3686,6 @@ retry:
 		goto retry;
 	}
 
-noretry:
-	/*
-	 * High-order allocations do not necessarily loop after direct reclaim
-	 * and reclaim/compaction depends on compaction being called after
-	 * reclaim so call directly if necessary.
-	 * It can become very expensive to allocate transparent hugepages at
-	 * fault, so use asynchronous memory compaction for THP unless it is
-	 * khugepaged trying to collapse. All other requests should tolerate
-	 * at least light sync migration.
-	 */
-	if (is_thp_gfp_mask(gfp_mask) && !(current->flags & PF_KTHREAD))
-		migration_mode = MIGRATE_ASYNC;
-	else
-		migration_mode = MIGRATE_SYNC_LIGHT;
-	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags,
-					    ac, migration_mode,
-					    &compact_result);
-	if (page)
-		goto got_pg;
 nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
 got_pg:
_
