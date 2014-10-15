From: akpm@linux-foundation.org
Subject: +
 mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch added to -mm tree
Date: Wed, 15 Oct 2014 13:50:04 -0700
Message-ID: <543eddfc.43Dn2EvwtmbdkwTL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJOUuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: pass classzone_idx and alloc_flags to watermark checking
has been added to the -mm tree.  Its filename is
     mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch

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
Subject: mm, compaction: pass classzone_idx and alloc_flags to watermark checking

Compaction relies on zone watermark checks for decisions such as if it's
worth to start compacting in compaction_suitable() or whether compaction
should stop in compact_finished().  The watermark checks take
classzone_idx and alloc_flags parameters, which are related to the memory
allocation request.  But from the context of compaction they are currently
passed as 0, including the direct compaction which is invoked to satisfy
the allocation request, and could therefore know the proper values.

The lack of proper values can lead to mismatch between decisions taken
during compaction and decisions related to the allocation request.  Lack
of proper classzone_idx value means that lowmem_reserve is not taken into
account.  This has manifested (during recent changes to deferred
compaction) when DMA zone was used as fallback for preferred Normal zone. 
compaction_suitable() without proper classzone_idx would think that the
watermarks are already satisfied, but watermark check in
get_page_from_freelist() would fail.  Because of this problem, deferring
compaction has extra complexity that can be removed in the following
patch.

The issue (not confirmed in practice) with missing alloc_flags is opposite
in nature.  For allocations that include ALLOC_HIGH, ALLOC_HIGHER or
ALLOC_CMA in alloc_flags (the last includes all MOVABLE allocations on
CMA-enabled systems) the watermark checking in compaction with 0 passed
will be stricter than in get_page_from_freelist().  In these cases
compaction might be running for a longer time than is really needed.

This patch fixes these problems by adding alloc_flags and classzone_idx to
struct compact_control and related functions involved in direct compaction
and watermark checking.  Where possible, all other callers of
compaction_suitable() pass proper values where those are known.  This is
currently limited to classzone_idx, which is sometimes known in kswapd
context.  However, the direct reclaim callers should_continue_reclaim()
and compaction_ready() do not currently know the proper values, so the
coordination between reclaim and compaction may still not be as accurate
as it could.  This can be fixed later, if it's shown to be an issue.

The effect of this patch should be slightly better high-order allocation
success rates and/or less compaction overhead, depending on the type of
allocations and presence of CMA.  It allows simplifying deferred
compaction code in a followup patch.

When testing with stress-highalloc, there was some slight improvement
(which might be just due to variance) in success rates of non-THP-like
allocations.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    8 ++++++--
 mm/compaction.c            |   29 +++++++++++++++--------------
 mm/internal.h              |    2 ++
 mm/page_alloc.c            |    1 +
 mm/vmscan.c                |   12 ++++++------
 5 files changed, 30 insertions(+), 22 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking
+++ a/include/linux/compaction.h
@@ -33,10 +33,12 @@ extern int fragmentation_index(struct zo
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			enum migrate_mode mode, int *contended,
+			int alloc_flags, int classzone_idx,
 			struct zone **candidate_zone);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
-extern unsigned long compaction_suitable(struct zone *zone, int order);
+extern unsigned long compaction_suitable(struct zone *zone, int order,
+					int alloc_flags, int classzone_idx);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -103,6 +105,7 @@ static inline bool compaction_restarting
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
 			enum migrate_mode mode, int *contended,
+			int alloc_flags, int classzone_idx,
 			struct zone **candidate_zone)
 {
 	return COMPACT_CONTINUE;
@@ -116,7 +119,8 @@ static inline void reset_isolation_suita
 {
 }
 
-static inline unsigned long compaction_suitable(struct zone *zone, int order)
+static inline unsigned long compaction_suitable(struct zone *zone, int order,
+					int alloc_flags, int classzone_idx)
 {
 	return COMPACT_SKIPPED;
 }
diff -puN mm/compaction.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking mm/compaction.c
--- a/mm/compaction.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking
+++ a/mm/compaction.c
@@ -1072,9 +1072,9 @@ static int compact_finished(struct zone
 
 	/* Compaction run is not finished if the watermark is not met */
 	watermark = low_wmark_pages(zone);
-	watermark += (1 << cc->order);
 
-	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
+	if (!zone_watermark_ok(zone, cc->order, watermark, cc->classzone_idx,
+							cc->alloc_flags))
 		return COMPACT_CONTINUE;
 
 	/* Direct compactor: Is a suitable page free? */
@@ -1100,7 +1100,8 @@ static int compact_finished(struct zone
  *   COMPACT_PARTIAL  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
-unsigned long compaction_suitable(struct zone *zone, int order)
+unsigned long compaction_suitable(struct zone *zone, int order,
+					int alloc_flags, int classzone_idx)
 {
 	int fragindex;
 	unsigned long watermark;
@@ -1137,7 +1138,7 @@ unsigned long compaction_suitable(struct
 		return COMPACT_SKIPPED;
 
 	if (fragindex == -1000 && zone_watermark_ok(zone, order, watermark,
-	    0, 0))
+	    classzone_idx, alloc_flags))
 		return COMPACT_PARTIAL;
 
 	return COMPACT_CONTINUE;
@@ -1151,7 +1152,8 @@ static int compact_zone(struct zone *zon
 	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 
-	ret = compaction_suitable(zone, cc->order);
+	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
+							cc->classzone_idx);
 	switch (ret) {
 	case COMPACT_PARTIAL:
 	case COMPACT_SKIPPED:
@@ -1240,7 +1242,8 @@ out:
 }
 
 static unsigned long compact_zone_order(struct zone *zone, int order,
-		gfp_t gfp_mask, enum migrate_mode mode, int *contended)
+		gfp_t gfp_mask, enum migrate_mode mode, int *contended,
+		int alloc_flags, int classzone_idx)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1250,6 +1253,8 @@ static unsigned long compact_zone_order(
 		.gfp_mask = gfp_mask,
 		.zone = zone,
 		.mode = mode,
+		.alloc_flags = alloc_flags,
+		.classzone_idx = classzone_idx,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1281,6 +1286,7 @@ int sysctl_extfrag_threshold = 500;
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
 			enum migrate_mode mode, int *contended,
+			int alloc_flags, int classzone_idx,
 			struct zone **candidate_zone)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
@@ -1289,7 +1295,6 @@ unsigned long try_to_compact_pages(struc
 	struct zoneref *z;
 	struct zone *zone;
 	int rc = COMPACT_DEFERRED;
-	int alloc_flags = 0;
 	int all_zones_contended = COMPACT_CONTENDED_LOCK; /* init for &= op */
 
 	*contended = COMPACT_CONTENDED_NONE;
@@ -1298,10 +1303,6 @@ unsigned long try_to_compact_pages(struc
 	if (!order || !may_enter_fs || !may_perform_io)
 		return COMPACT_SKIPPED;
 
-#ifdef CONFIG_CMA
-	if (gfpflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
 								nodemask) {
@@ -1312,7 +1313,7 @@ unsigned long try_to_compact_pages(struc
 			continue;
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
-							&zone_contended);
+				&zone_contended, alloc_flags, classzone_idx);
 		rc = max(status, rc);
 		/*
 		 * It takes at least one zone that wasn't lock contended
@@ -1321,8 +1322,8 @@ unsigned long try_to_compact_pages(struc
 		all_zones_contended &= zone_contended;
 
 		/* If a normal allocation would succeed, stop compacting */
-		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
-				      alloc_flags)) {
+		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
+					classzone_idx, alloc_flags)) {
 			*candidate_zone = zone;
 			/*
 			 * We think the allocation will succeed in this zone,
diff -puN mm/internal.h~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking mm/internal.h
--- a/mm/internal.h~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking
+++ a/mm/internal.h
@@ -143,6 +143,8 @@ struct compact_control {
 
 	int order;			/* order a direct compactor needs */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
+	const int alloc_flags;		/* alloc flags of a direct compactor */
+	const int classzone_idx;	/* zone index of a direct compactor */
 	struct zone *zone;
 	int contended;			/* Signal need_sched() or lock
 					 * contention detected during
diff -puN mm/page_alloc.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking
+++ a/mm/page_alloc.c
@@ -2342,6 +2342,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	compact_result = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, mode,
 						contended_compaction,
+						alloc_flags, classzone_idx,
 						&last_compact_zone);
 	current->flags &= ~PF_MEMALLOC;
 
diff -puN mm/vmscan.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking
+++ a/mm/vmscan.c
@@ -2249,7 +2249,7 @@ static inline bool should_continue_recla
 		return true;
 
 	/* If compaction would go ahead or the allocation would succeed, stop */
-	switch (compaction_suitable(zone, sc->order)) {
+	switch (compaction_suitable(zone, sc->order, 0, 0)) {
 	case COMPACT_PARTIAL:
 	case COMPACT_CONTINUE:
 		return false;
@@ -2346,7 +2346,7 @@ static inline bool compaction_ready(stru
 	 * If compaction is not ready to start and allocation is not likely
 	 * to succeed without it, then keep reclaiming.
 	 */
-	if (compaction_suitable(zone, order) == COMPACT_SKIPPED)
+	if (compaction_suitable(zone, order, 0, 0) == COMPACT_SKIPPED)
 		return false;
 
 	return watermark_ok;
@@ -2824,8 +2824,8 @@ static bool zone_balanced(struct zone *z
 				    balance_gap, classzone_idx, 0))
 		return false;
 
-	if (IS_ENABLED(CONFIG_COMPACTION) && order &&
-	    compaction_suitable(zone, order) == COMPACT_SKIPPED)
+	if (IS_ENABLED(CONFIG_COMPACTION) && order && compaction_suitable(zone,
+				order, 0, classzone_idx) == COMPACT_SKIPPED)
 		return false;
 
 	return true;
@@ -2952,8 +2952,8 @@ static bool kswapd_shrink_zone(struct zo
 	 * from memory. Do not reclaim more than needed for compaction.
 	 */
 	if (IS_ENABLED(CONFIG_COMPACTION) && sc->order &&
-			compaction_suitable(zone, sc->order) !=
-				COMPACT_SKIPPED)
+			compaction_suitable(zone, sc->order, 0, classzone_idx)
+							!= COMPACT_SKIPPED)
 		testorder = 0;
 
 	/*
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch

