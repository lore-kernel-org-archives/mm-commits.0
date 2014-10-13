From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:29 -0700
Message-ID: <543c17b1.zX2UZWS267KjVDAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaJMSTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: defer each zone individually instead of preferred zone
has been removed from the -mm tree.  Its filename was
     mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: defer each zone individually instead of preferred zone

When direct sync compaction is often unsuccessful, it may become deferred
for some time to avoid further useless attempts, both sync and async. 
Successful high-order allocations un-defer compaction, while further
unsuccessful compaction attempts prolong the compaction deferred period.

Currently the checking and setting deferred status is performed only on
the preferred zone of the allocation that invoked direct compaction.  But
compaction itself is attempted on all eligible zones in the zonelist, so
the behavior is suboptimal and may lead both to scenarios where 1)
compaction is attempted uselessly, or 2) where it's not attempted despite
good chances of succeeding, as shown on the examples below:

1) A direct compaction with Normal preferred zone failed and set
   deferred compaction for the Normal zone.  Another unrelated direct
   compaction with DMA32 as preferred zone will attempt to compact DMA32
   zone even though the first compaction attempt also included DMA32 zone.

   In another scenario, compaction with Normal preferred zone failed to
   compact Normal zone, but succeeded in the DMA32 zone, so it will not
   defer compaction.  In the next attempt, it will try Normal zone which
   will fail again, instead of skipping Normal zone and trying DMA32
   directly.

2) Kswapd will balance DMA32 zone and reset defer status based on
   watermarks looking good.  A direct compaction with preferred Normal
   zone will skip compaction of all zones including DMA32 because Normal
   was still deferred.  The allocation might have succeeded in DMA32, but
   won't.

This patch makes compaction deferring work on individual zone basis
instead of preferred zone.  For each zone, it checks compaction_deferred()
to decide if the zone should be skipped.  If watermarks fail after
compacting the zone, defer_compaction() is called.  The zone where
watermarks passed can still be deferred when the allocation attempt is
unsuccessful.  When allocation is successful, compaction_defer_reset() is
called for the zone containing the allocated page.  This approach should
approximate calling defer_compaction() only on zones where compaction was
attempted and did not yield allocated page.  There might be corner cases
but that is inevitable as long as the decision to stop compacting dues not
guarantee that a page will be allocated.

Due to a new COMPACT_DEFERRED return value, some functions relying
implicitly on COMPACT_SKIPPED = 0 had to be updated, with comments made
more accurate.  The did_some_progress output parameter of
__alloc_pages_direct_compact() is removed completely, as the caller
actually does not use it after compaction sets it - it is only considered
when direct reclaim sets it.

During testing on a two-node machine with a single very small Normal zone
on node 1, this patch has improved success rates in stress-highalloc
mmtests benchmark.  The success here were previously made worse by commit
3a025760fc15 ("mm: page_alloc: spill to remote nodes before waking
kswapd") as kswapd was no longer resetting often enough the deferred
compaction for the Normal zone, and DMA32 zones on both nodes were thus
not considered for compaction.  On different machine, success rates were
improved with __GFP_NO_KSWAPD allocations.

[akpm@linux-foundation.org: fix CONFIG_COMPACTION=n build]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   16 ++++++---
 mm/compaction.c            |   32 +++++++++++++++----
 mm/page_alloc.c            |   57 +++++++++++++++++++----------------
 mm/vmscan.c                |   14 ++++++--
 4 files changed, 76 insertions(+), 43 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone
+++ a/include/linux/compaction.h
@@ -2,14 +2,16 @@
 #define _LINUX_COMPACTION_H
 
 /* Return values for compact_zone() and try_to_compact_pages() */
+/* compaction didn't start as it was deferred due to past failures */
+#define COMPACT_DEFERRED	0
 /* compaction didn't start as it was not possible or direct reclaim was more suitable */
-#define COMPACT_SKIPPED		0
+#define COMPACT_SKIPPED		1
 /* compaction should continue to another pageblock */
-#define COMPACT_CONTINUE	1
+#define COMPACT_CONTINUE	2
 /* direct compaction partially compacted a zone and there are suitable pages */
-#define COMPACT_PARTIAL		2
+#define COMPACT_PARTIAL		3
 /* The full zone was compacted */
-#define COMPACT_COMPLETE	3
+#define COMPACT_COMPLETE	4
 
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
@@ -22,7 +24,8 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
-			enum migrate_mode mode, bool *contended);
+			enum migrate_mode mode, bool *contended,
+			struct zone **candidate_zone);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
@@ -91,7 +94,8 @@ static inline bool compaction_restarting
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, bool *contended)
+			enum migrate_mode mode, bool *contended,
+			struct zone **candidate_zone)
 {
 	return COMPACT_CONTINUE;
 }
diff -puN mm/compaction.c~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone mm/compaction.c
--- a/mm/compaction.c~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone
+++ a/mm/compaction.c
@@ -1125,27 +1125,26 @@ int sysctl_extfrag_threshold = 500;
  * @nodemask: The allowed nodes to allocate from
  * @mode: The migration mode for async, sync light, or sync migration
  * @contended: Return value that is true if compaction was aborted due to lock contention
- * @page: Optionally capture a free page of the requested order during compaction
+ * @candidate_zone: Return the zone where we think allocation should succeed
  *
  * This is the main entry point for direct page compaction.
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, bool *contended)
+			enum migrate_mode mode, bool *contended,
+			struct zone **candidate_zone)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
 	struct zone *zone;
-	int rc = COMPACT_SKIPPED;
+	int rc = COMPACT_DEFERRED;
 	int alloc_flags = 0;
 
 	/* Check if the GFP flags allow compaction */
 	if (!order || !may_enter_fs || !may_perform_io)
-		return rc;
-
-	count_compact_event(COMPACTSTALL);
+		return COMPACT_SKIPPED;
 
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
@@ -1156,14 +1155,33 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
+		if (compaction_deferred(zone, order))
+			continue;
+
 		status = compact_zone_order(zone, order, gfp_mask, mode,
 						contended);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
-				      alloc_flags))
+				      alloc_flags)) {
+			*candidate_zone = zone;
+			/*
+			 * We think the allocation will succeed in this zone,
+			 * but it is not certain, hence the false. The caller
+			 * will repeat this with true if allocation indeed
+			 * succeeds in this zone.
+			 */
+			compaction_defer_reset(zone, order, false);
 			break;
+		} else if (mode != MIGRATE_ASYNC) {
+			/*
+			 * We think that allocation won't succeed in this zone
+			 * so we defer compaction there. If it ends up
+			 * succeeding after all, it will be reset.
+			 */
+			defer_compaction(zone, order);
+		}
 	}
 
 	return rc;
diff -puN mm/page_alloc.c~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone
+++ a/mm/page_alloc.c
@@ -2297,24 +2297,28 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
 	int classzone_idx, int migratetype, enum migrate_mode mode,
-	bool *contended_compaction, bool *deferred_compaction,
-	unsigned long *did_some_progress)
+	bool *contended_compaction, bool *deferred_compaction)
 {
-	if (!order)
-		return NULL;
+	struct zone *last_compact_zone = NULL;
+	unsigned long compact_result;
 
-	if (compaction_deferred(preferred_zone, order)) {
-		*deferred_compaction = true;
+
+	if (!order)
 		return NULL;
-	}
 
 	current->flags |= PF_MEMALLOC;
-	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
+	compact_result = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, mode,
-						contended_compaction);
+						contended_compaction,
+						&last_compact_zone);
 	current->flags &= ~PF_MEMALLOC;
 
-	if (*did_some_progress != COMPACT_SKIPPED) {
+	if (compact_result > COMPACT_DEFERRED)
+		count_vm_event(COMPACTSTALL);
+	else
+		*deferred_compaction = true;
+
+	if (compact_result > COMPACT_SKIPPED) {
 		struct page *page;
 
 		/* Page migration frees to the PCP lists but we want merging */
@@ -2325,27 +2329,31 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				order, zonelist, high_zoneidx,
 				alloc_flags & ~ALLOC_NO_WATERMARKS,
 				preferred_zone, classzone_idx, migratetype);
+
 		if (page) {
-			preferred_zone->compact_blockskip_flush = false;
-			compaction_defer_reset(preferred_zone, order, true);
+			struct zone *zone = page_zone(page);
+
+			zone->compact_blockskip_flush = false;
+			compaction_defer_reset(zone, order, true);
 			count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
 
 		/*
+		 * last_compact_zone is where try_to_compact_pages thought
+		 * allocation should succeed, so it did not defer compaction.
+		 * But now we know that it didn't succeed, so we do the defer.
+		 */
+		if (last_compact_zone && mode != MIGRATE_ASYNC)
+			defer_compaction(last_compact_zone, order);
+
+		/*
 		 * It's bad if compaction run occurs and fails.
 		 * The most likely reason is that pages exist,
 		 * but not enough to satisfy watermarks.
 		 */
 		count_vm_event(COMPACTFAIL);
 
-		/*
-		 * As async compaction considers a subset of pageblocks, only
-		 * defer if the failure was a sync compaction failure.
-		 */
-		if (mode != MIGRATE_ASYNC)
-			defer_compaction(preferred_zone, order);
-
 		cond_resched();
 	}
 
@@ -2356,9 +2364,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int classzone_idx, int migratetype,
-	enum migrate_mode mode, bool *contended_compaction,
-	bool *deferred_compaction, unsigned long *did_some_progress)
+	int classzone_idx, int migratetype, enum migrate_mode mode,
+	bool *contended_compaction, bool *deferred_compaction)
 {
 	return NULL;
 }
@@ -2634,8 +2641,7 @@ rebalance:
 					preferred_zone,
 					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
-					&deferred_compaction,
-					&did_some_progress);
+					&deferred_compaction);
 	if (page)
 		goto got_pg;
 
@@ -2727,8 +2733,7 @@ rebalance:
 					preferred_zone,
 					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
-					&deferred_compaction,
-					&did_some_progress);
+					&deferred_compaction);
 		if (page)
 			goto got_pg;
 	}
diff -puN mm/vmscan.c~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-defer-each-zone-individually-instead-of-preferred-zone
+++ a/mm/vmscan.c
@@ -2315,7 +2315,10 @@ static bool shrink_zone(struct zone *zon
 	return reclaimable;
 }
 
-/* Returns true if compaction should go ahead for a high-order request */
+/*
+ * Returns true if compaction should go ahead for a high-order request, or
+ * the high-order allocation would succeed without compaction.
+ */
 static inline bool compaction_ready(struct zone *zone, int order)
 {
 	unsigned long balance_gap, watermark;
@@ -2339,8 +2342,11 @@ static inline bool compaction_ready(stru
 	if (compaction_deferred(zone, order))
 		return watermark_ok;
 
-	/* If compaction is not ready to start, keep reclaiming */
-	if (!compaction_suitable(zone, order))
+	/*
+	 * If compaction is not ready to start and allocation is not likely
+	 * to succeed without it, then keep reclaiming.
+	 */
+	if (compaction_suitable(zone, order) == COMPACT_SKIPPED)
 		return false;
 
 	return watermark_ok;
@@ -2818,7 +2824,7 @@ static bool zone_balanced(struct zone *z
 		return false;
 
 	if (IS_ENABLED(CONFIG_COMPACTION) && order &&
-	    !compaction_suitable(zone, order))
+	    compaction_suitable(zone, order) == COMPACT_SKIPPED)
 		return false;
 
 	return true;
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch

