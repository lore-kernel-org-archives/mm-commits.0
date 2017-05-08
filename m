From: akpm@linux-foundation.org
Subject: [patch 008/114] mm, compaction: finish whole pageblock to
 reduce fragmentation
Date: Mon, 08 May 2017 15:54:52 -0700
Message-ID: <20170508225452.IAg5XSbk6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdEHWyy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: finish whole pageblock to reduce fragmentation

The main goal of direct compaction is to form a high-order page for
allocation, but it should also help against long-term fragmentation when
possible.  Most lower-than-pageblock-order compactions are for non-movable
allocations, which means that if we compact in a movable pageblock and
terminate as soon as we create the high-order page, it's unlikely that the
fallback heuristics will claim the whole block.  Instead there might be a
single unmovable page in a pageblock full of movable pages, and the next
unmovable allocation might pick another pageblock and increase long-term
fragmentation.

To help against such scenarios, this patch changes the termination
criteria for compaction so that the current pageblock is finished even
though the high-order page already exists.  Note that it might be possible
that the high-order page formed elsewhere in the zone due to parallel
activity, but this patch doesn't try to detect that.

This is only done with sync compaction, because async compaction is
limited to pageblock of the same migratetype, where it cannot result in a
migratetype fallback.  (Async compaction also eagerly skips order-aligned
blocks where isolation fails, which is against the goal of migrating away
as much of the pageblock as possible.)

As a result of this patch, long-term memory fragmentation should be
reduced.

In testing based on 4.9 kernel with stress-highalloc from mmtests
configured for order-4 GFP_KERNEL allocations, this patch has reduced the
number of unmovable allocations falling back to movable pageblocks by 20%.
The number

Link: http://lkml.kernel.org/r/20170307131545.28577-9-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   36 ++++++++++++++++++++++++++++++++++--
 mm/internal.h   |    1 +
 2 files changed, 35 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-finish-whole-pageblock-to-reduce-fragmentation mm/compaction.c
--- a/mm/compaction.c~mm-compaction-finish-whole-pageblock-to-reduce-fragmentation
+++ a/mm/compaction.c
@@ -1318,6 +1318,17 @@ static enum compact_result __compact_fin
 	if (is_via_compact_memory(cc->order))
 		return COMPACT_CONTINUE;
 
+	if (cc->finishing_block) {
+		/*
+		 * We have finished the pageblock, but better check again that
+		 * we really succeeded.
+		 */
+		if (IS_ALIGNED(cc->migrate_pfn, pageblock_nr_pages))
+			cc->finishing_block = false;
+		else
+			return COMPACT_CONTINUE;
+	}
+
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		struct free_area *area = &zone->free_area[order];
@@ -1338,8 +1349,29 @@ static enum compact_result __compact_fin
 		 * other migratetype buddy lists.
 		 */
 		if (find_suitable_fallback(area, order, migratetype,
-						true, &can_steal) != -1)
-			return COMPACT_SUCCESS;
+						true, &can_steal) != -1) {
+
+			/* movable pages are OK in any pageblock */
+			if (migratetype == MIGRATE_MOVABLE)
+				return COMPACT_SUCCESS;
+
+			/*
+			 * We are stealing for a non-movable allocation. Make
+			 * sure we finish compacting the current pageblock
+			 * first so it is as free as possible and we won't
+			 * have to steal another one soon. This only applies
+			 * to sync compaction, as async compaction operates
+			 * on pageblocks of the same migratetype.
+			 */
+			if (cc->mode == MIGRATE_ASYNC ||
+					IS_ALIGNED(cc->migrate_pfn,
+							pageblock_nr_pages)) {
+				return COMPACT_SUCCESS;
+			}
+
+			cc->finishing_block = true;
+			return COMPACT_CONTINUE;
+		}
 	}
 
 	return COMPACT_NO_SUITABLE_PAGE;
diff -puN mm/internal.h~mm-compaction-finish-whole-pageblock-to-reduce-fragmentation mm/internal.h
--- a/mm/internal.h~mm-compaction-finish-whole-pageblock-to-reduce-fragmentation
+++ a/mm/internal.h
@@ -202,6 +202,7 @@ struct compact_control {
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	bool whole_zone;		/* Whole zone should/has been scanned */
 	bool contended;			/* Signal lock or sched contention */
+	bool finishing_block;		/* Finishing current pageblock */
 };
 
 unsigned long
_
