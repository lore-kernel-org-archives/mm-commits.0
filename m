From: akpm@linux-foundation.org
Subject: +
 mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch added to -mm tree
Date: Tue, 07 Mar 2017 15:27:39 -0800
Message-ID: <58bf41eb.lIpHNTuKy9tRMD+f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756527AbdCGX2q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 18:28:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: restrict async compaction to pageblocks of same migratetype
has been added to the -mm tree.  Its filename is
     mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: restrict async compaction to pageblocks of same migratetype

The migrate scanner in async compaction is currently limited to
MIGRATE_MOVABLE pageblocks.  This is a heuristic intended to reduce
latency, based on the assumption that non-MOVABLE pageblocks are unlikely
to contain movable pages.

However, with the exception of THP's, most high-order allocations are not
movable.  Should the async compaction succeed, this increases the chance
that the non-MOVABLE allocations will fallback to a MOVABLE pageblock,
making the long-term fragmentation worse.

This patch attempts to help the situation by changing async direct
compaction so that the migrate scanner only scans the pageblocks of the
requested migratetype.  If it's a non-MOVABLE type and there are such
pageblocks that do contain movable pages, chances are that the allocation
can succeed within one of such pageblocks, removing the need for a
fallback.  If that fails, the subsequent sync attempt will ignore this
restriction.

In testing based on 4.9 kernel with stress-highalloc from mmtests
configured for order-4 GFP_KERNEL allocations, this patch has reduced the
number of unmovable allocations falling back to movable pageblocks by 30%.
The number of movable allocations falling back is reduced by 12%.

Link: http://lkml.kernel.org/r/20170307131545.28577-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++++--
 mm/page_alloc.c |   22 ++++++++++++++--------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff -puN mm/compaction.c~mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype mm/compaction.c
--- a/mm/compaction.c~mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype
+++ a/mm/compaction.c
@@ -986,10 +986,17 @@ isolate_migratepages_range(struct compac
 static bool suitable_migration_source(struct compact_control *cc,
 							struct page *page)
 {
-	if (cc->mode != MIGRATE_ASYNC)
+	int block_mt;
+
+	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
 		return true;
 
-	return is_migrate_movable(get_pageblock_migratetype(page));
+	block_mt = get_pageblock_migratetype(page);
+
+	if (cc->migratetype == MIGRATE_MOVABLE)
+		return is_migrate_movable(block_mt);
+	else
+		return block_mt == cc->migratetype;
 }
 
 /* Returns true if the page is within a block suitable for migration to */
diff -puN mm/page_alloc.c~mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype
+++ a/mm/page_alloc.c
@@ -3672,6 +3672,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 						struct alloc_context *ac)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -3739,12 +3740,17 @@ retry_cpuset:
 
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
-	 * that we have enough base pages and don't need to reclaim. Don't try
-	 * that for allocations that are allowed to ignore watermarks, as the
-	 * ALLOC_NO_WATERMARKS attempt didn't yet happen.
-	 */
-	if (can_direct_reclaim && order > PAGE_ALLOC_COSTLY_ORDER &&
-		!gfp_pfmemalloc_allowed(gfp_mask)) {
+	 * that we have enough base pages and don't need to reclaim. For non-
+	 * movable high-order allocations, do that as well, as compaction will
+	 * try prevent permanent fragmentation by migrating from blocks of the
+	 * same migratetype.
+	 * Don't try this for allocations that are allowed to ignore
+	 * watermarks, as the ALLOC_NO_WATERMARKS attempt didn't yet happen.
+	 */
+	if (can_direct_reclaim &&
+			(costly_order ||
+			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
+			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
 		page = __alloc_pages_direct_compact(gfp_mask, order,
 						alloc_flags, ac,
 						INIT_COMPACT_PRIORITY,
@@ -3756,7 +3762,7 @@ retry_cpuset:
 		 * Checks for costly allocations with __GFP_NORETRY, which
 		 * includes THP page fault allocations
 		 */
-		if (gfp_mask & __GFP_NORETRY) {
+		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
 			/*
 			 * If compaction is deferred for high-order allocations,
 			 * it is because sync compaction recently failed. If
@@ -3837,7 +3843,7 @@ retry:
 	 * Do not retry costly high order allocations unless they are
 	 * __GFP_REPEAT
 	 */
-	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
+	if (costly_order && !(gfp_mask & __GFP_REPEAT))
 		goto nopage;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch

