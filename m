From: akpm@linux-foundation.org
Subject: +
 mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch added to -mm tree
Date: Thu, 21 Aug 2014 15:22:02 -0700
Message-ID: <53f6710a.j6v5LoujP4aPgi3/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36306 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaHUWWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:22:04 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1184712vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:22:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: khugepaged should not give up due to need_resched()
has been added to the -mm tree.  Its filename is
     mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch

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
Subject: mm, compaction: khugepaged should not give up due to need_resched()

Async compaction aborts when it detects zone lock contention or
need_resched() is true.  David Rientjes has reported that in practice,
most direct async compactions for THP allocation abort due to
need_resched().  This means that a second direct compaction is never
attempted, which might be OK for a page fault, but khugepaged is intended
to attempt a sync compaction in such case and in these cases it won't.

This patch replaces "bool contended" in compact_control with an int that
distinguishes between aborting due to need_resched() and aborting due to
lock contention.  This allows propagating the abort through all compaction
functions as before, but passing the abort reason up to
__alloc_pages_slowpath() which decides when to continue with direct
reclaim and another compaction attempt.

Another problem is that try_to_compact_pages() did not act upon the
reported contention (both need_resched() or lock contention) immediately
and would proceed with another zone from the zonelist.  When
need_resched() is true, that means initializing another zone compaction,
only to check again need_resched() in isolate_migratepages() and aborting.
 For zone lock contention, the unintended consequence is that the lock
contended status reported back to the allocator is detrmined from the last
zone where compaction was attempted, which is rather arbitrary.

This patch fixes the problem in the following way:
- async compaction of a zone aborting due to need_resched() or fatal signal
  pending means that further zones should not be tried. We report
  COMPACT_CONTENDED_SCHED to the allocator.
- aborting zone compaction due to lock contention means we can still try
  another zone, since it has different set of locks. We report back
  COMPACT_CONTENDED_LOCK only if *all* zones where compaction was attempted,
  it was aborted due to lock contention.

As a result of these fixes, khugepaged will proceed with second sync
compaction as intended, when the preceding async compaction aborted due to
need_resched().  Page fault compactions aborting due to need_resched()
will spare some cycles previously wasted by initializing another zone
compaction only to abort again.  Lock contention will be reported only
when compaction in all zones aborted due to lock contention, and therefore
it's not a good idea to try again after reclaim.

In stress-highalloc from mmtests configured to use __GFP_NO_KSWAPD, this
has improved number of THP collapse allocations by 10%, which shows
positive effect on khugepaged.  The benchmark's success rates are
unchanged as it is not recognized as khugepaged.  Numbers of compact_stall
and compact_fail events have however decreased by 20%, with
compact_success still a bit improved, which is good.  With benchmark
configured not to use __GFP_NO_KSWAPD, there is 6% improvement in THP
collapse allocations, and only slight improvement in stalls and failures.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   12 ++++
 mm/compaction.c            |   87 ++++++++++++++++++++++++++++++-----
 mm/internal.h              |    4 -
 mm/page_alloc.c            |   43 ++++++++++++-----
 4 files changed, 120 insertions(+), 26 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched
+++ a/include/linux/compaction.h
@@ -13,6 +13,14 @@
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	4
 
+/* Used to signal whether compaction detected need_sched() or lock contention */
+/* No contention detected */
+#define COMPACT_CONTENDED_NONE	0
+/* Either need_sched() was true or fatal signal pending */
+#define COMPACT_CONTENDED_SCHED	1
+/* Zone lock or lru_lock was contended in async compaction */
+#define COMPACT_CONTENDED_LOCK	2
+
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
@@ -24,7 +32,7 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
-			enum migrate_mode mode, bool *contended,
+			enum migrate_mode mode, int *contended,
 			struct zone **candidate_zone);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
@@ -94,7 +102,7 @@ static inline bool compaction_restarting
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, bool *contended,
+			enum migrate_mode mode, int *contended,
 			struct zone **candidate_zone)
 {
 	return COMPACT_CONTINUE;
diff -puN mm/compaction.c~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched mm/compaction.c
--- a/mm/compaction.c~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched
+++ a/mm/compaction.c
@@ -223,9 +223,21 @@ static void update_pageblock_skip(struct
 }
 #endif /* CONFIG_COMPACTION */
 
-static inline bool should_release_lock(spinlock_t *lock)
+static int should_release_lock(spinlock_t *lock)
 {
-	return need_resched() || spin_is_contended(lock);
+	/*
+	 * Sched contention has higher priority here as we may potentially
+	 * have to abort whole compaction ASAP. Returning with lock contention
+	 * means we will try another zone, and further decisions are
+	 * influenced only when all zones are lock contended. That means
+	 * potentially missing a lock contention is less critical.
+	 */
+	if (need_resched())
+		return COMPACT_CONTENDED_SCHED;
+	else if (spin_is_contended(lock))
+		return COMPACT_CONTENDED_LOCK;
+
+	return COMPACT_CONTENDED_NONE;
 }
 
 /*
@@ -240,7 +252,9 @@ static inline bool should_release_lock(s
 static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
 				      bool locked, struct compact_control *cc)
 {
-	if (should_release_lock(lock)) {
+	int contended = should_release_lock(lock);
+
+	if (contended) {
 		if (locked) {
 			spin_unlock_irqrestore(lock, *flags);
 			locked = false;
@@ -248,7 +262,7 @@ static bool compact_checklock_irqsave(sp
 
 		/* async aborts if taking too long or contended */
 		if (cc->mode == MIGRATE_ASYNC) {
-			cc->contended = true;
+			cc->contended = contended;
 			return false;
 		}
 
@@ -274,7 +288,7 @@ static inline bool compact_should_abort(
 	/* async compaction aborts if contended */
 	if (need_resched()) {
 		if (cc->mode == MIGRATE_ASYNC) {
-			cc->contended = true;
+			cc->contended = COMPACT_CONTENDED_SCHED;
 			return true;
 		}
 
@@ -1143,7 +1157,7 @@ out:
 }
 
 static unsigned long compact_zone_order(struct zone *zone, int order,
-		gfp_t gfp_mask, enum migrate_mode mode, bool *contended)
+		gfp_t gfp_mask, enum migrate_mode mode, int *contended)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1175,14 +1189,15 @@ int sysctl_extfrag_threshold = 500;
  * @gfp_mask: The GFP mask of the current allocation
  * @nodemask: The allowed nodes to allocate from
  * @mode: The migration mode for async, sync light, or sync migration
- * @contended: Return value that is true if compaction was aborted due to lock contention
+ * @contended: Return value that determines if compaction was aborted due to
+ *	       need_resched() or lock contention
  * @candidate_zone: Return the zone where we think allocation should succeed
  *
  * This is the main entry point for direct page compaction.
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, bool *contended,
+			enum migrate_mode mode, int *contended,
 			struct zone **candidate_zone)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
@@ -1192,6 +1207,9 @@ unsigned long try_to_compact_pages(struc
 	struct zone *zone;
 	int rc = COMPACT_DEFERRED;
 	int alloc_flags = 0;
+	int all_zones_contended = COMPACT_CONTENDED_LOCK; /* init for &= op */
+
+	*contended = COMPACT_CONTENDED_NONE;
 
 	/* Check if the GFP flags allow compaction */
 	if (!order || !may_enter_fs || !may_perform_io)
@@ -1205,13 +1223,19 @@ unsigned long try_to_compact_pages(struc
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
 								nodemask) {
 		int status;
+		int zone_contended;
 
 		if (compaction_deferred(zone, order))
 			continue;
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
-						contended);
+							&zone_contended);
 		rc = max(status, rc);
+		/*
+		 * It takes at least one zone that wasn't lock contended
+		 * to clear all_zones_contended.
+		 */
+		all_zones_contended &= zone_contended;
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
@@ -1224,8 +1248,21 @@ unsigned long try_to_compact_pages(struc
 			 * succeeds in this zone.
 			 */
 			compaction_defer_reset(zone, order, false);
-			break;
-		} else if (mode != MIGRATE_ASYNC) {
+			/*
+			 * It is possible that async compaction aborted due to
+			 * need_resched() and the watermarks were ok thanks to
+			 * somebody else freeing memory. The allocation can
+			 * however still fail so we better signal the
+			 * need_resched() contention anyway (this will not
+			 * prevent the allocation attempt).
+			 */
+			if (zone_contended == COMPACT_CONTENDED_SCHED)
+				*contended = COMPACT_CONTENDED_SCHED;
+
+			goto break_loop;
+		}
+
+		if (mode != MIGRATE_ASYNC) {
 			/*
 			 * We think that allocation won't succeed in this zone
 			 * so we defer compaction there. If it ends up
@@ -1233,8 +1270,36 @@ unsigned long try_to_compact_pages(struc
 			 */
 			defer_compaction(zone, order);
 		}
+
+		/*
+		 * We might have stopped compacting due to need_resched() in
+		 * async compaction, or due to a fatal signal detected. In that
+		 * case do not try further zones and signal need_resched()
+		 * contention.
+		 */
+		if ((zone_contended == COMPACT_CONTENDED_SCHED)
+					|| fatal_signal_pending(current)) {
+			*contended = COMPACT_CONTENDED_SCHED;
+			goto break_loop;
+		}
+
+		continue;
+break_loop:
+		/*
+		 * We might not have tried all the zones, so  be conservative
+		 * and assume they are not all lock contended.
+		 */
+		all_zones_contended = 0;
+		break;
 	}
 
+	/*
+	 * If at least one zone wasn't deferred or skipped, we report if all
+	 * zones that were tried were lock contended.
+	 */
+	if (rc > COMPACT_SKIPPED && all_zones_contended)
+		*contended = COMPACT_CONTENDED_LOCK;
+
 	return rc;
 }
 
diff -puN mm/internal.h~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched mm/internal.h
--- a/mm/internal.h~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched
+++ a/mm/internal.h
@@ -144,8 +144,8 @@ struct compact_control {
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
-	bool contended;			/* True if a lock was contended, or
-					 * need_resched() true during async
+	int contended;			/* Signal need_sched() or lock
+					 * contention detected during
 					 * compaction
 					 */
 };
diff -puN mm/page_alloc.c~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched
+++ a/mm/page_alloc.c
@@ -2296,7 +2296,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
 	int classzone_idx, int migratetype, enum migrate_mode mode,
-	bool *contended_compaction, bool *deferred_compaction)
+	int *contended_compaction, bool *deferred_compaction)
 {
 	struct zone *last_compact_zone = NULL;
 	unsigned long compact_result;
@@ -2547,7 +2547,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
-	bool contended_compaction = false;
+	int contended_compaction = COMPACT_CONTENDED_NONE;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2651,15 +2651,36 @@ rebalance:
 	if (page)
 		goto got_pg;
 
-	/*
-	 * If compaction is deferred for high-order allocations, it is because
-	 * sync compaction recently failed. In this is the case and the caller
-	 * requested a movable allocation that does not heavily disrupt the
-	 * system then fail the allocation instead of entering direct reclaim.
-	 */
-	if ((deferred_compaction || contended_compaction) &&
-						(gfp_mask & __GFP_NO_KSWAPD))
-		goto nopage;
+	/* Checks for THP-specific high-order allocations */
+	if ((gfp_mask & GFP_TRANSHUGE) == GFP_TRANSHUGE) {
+		/*
+		 * If compaction is deferred for high-order allocations, it is
+		 * because sync compaction recently failed. If this is the case
+		 * and the caller requested a THP allocation, we do not want
+		 * to heavily disrupt the system, so we fail the allocation
+		 * instead of entering direct reclaim.
+		 */
+		if (deferred_compaction)
+			goto nopage;
+
+		/*
+		 * In all zones where compaction was attempted (and not
+		 * deferred or skipped), lock contention has been detected.
+		 * For THP allocation we do not want to disrupt the others
+		 * so we fallback to base pages instead.
+		 */
+		if (contended_compaction == COMPACT_CONTENDED_LOCK)
+			goto nopage;
+
+		/*
+		 * If compaction was aborted due to need_resched(), we do not
+		 * want to further increase allocation latency, unless it is
+		 * khugepaged trying to collapse.
+		 */
+		if (contended_compaction == COMPACT_CONTENDED_SCHED
+			&& !(current->flags & PF_KTHREAD))
+			goto nopage;
+	}
 
 	/*
 	 * It can become very expensive to allocate transparent hugepages at
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch

