Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E4D1C6FF8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274660; cv=none; b=i67O5obUc6jMykj96rytmWy/KVcrqAMBUCQhhqISiNlkqYeKYi6PHwZ7zIwZb+VshmmuRK1LjQa7fIR0wQGuQcw/g0mcF7U2u+buxkOSY+QMEshlwrJPdbgDrRkHUZZGqDWre3W9qUmY/+7XDlBTTxKT5w2k4Q6KKZj/8ZVdqv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274660; c=relaxed/simple;
	bh=fovKPhYv0iqx6tuBCg/gqcHUbkGgyygrjghShY66KFc=;
	h=Date:To:From:Subject:Message-Id; b=YBRp5pwkfAPV7cCe4yIUErK/22MKIrVIrbIZWgd2SoFlKhkqye7FUwJb1x4ttSyjwdaMV06s4EzVsbFmU2m55CsTk2sMFoR63tcLubP2Vtb0FixkPSf710ho0pnghfi1vBrDwYLQ+UdR53+tXU7tuibevPhLcNKD0p1I9xr+VfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dt3OQo45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dt3OQo45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3D4C4CEDD;
	Tue, 18 Mar 2025 05:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274660;
	bh=fovKPhYv0iqx6tuBCg/gqcHUbkGgyygrjghShY66KFc=;
	h=Date:To:From:Subject:From;
	b=dt3OQo4553wLe9hxj9+oAMM5R7yKIs86SE4yUxfCWu/hoGiTSCt+31wLDtFidkcB4
	 YIK8PVuYVE4QBWxO0ztwhBnM5qznZguKmJ8gD8IqSx7GNfJdVUb4I7L6sVqFz/RtYC
	 WK9zTVyQaiGM1clTaXpNEO26cuN3zlfJaafKdvQg=
Date: Mon, 17 Mar 2025 22:10:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hughd@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-push-watermark-into-compaction_suitable-callers.patch removed from -mm tree
Message-Id: <20250318051100.5A3D4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: push watermark into compaction_suitable() callers
has been removed from the -mm tree.  Its filename was
     mm-compaction-push-watermark-into-compaction_suitable-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: push watermark into compaction_suitable() callers
Date: Thu, 13 Mar 2025 17:05:32 -0400

Patch series "mm: reliable huge page allocator".

This series makes changes to the allocator and reclaim/compaction code to
try harder to avoid fragmentation.  As a result, this makes huge page
allocations cheaper, more reliable and more sustainable.

It's a subset of the huge page allocator RFC initially proposed here:

  https://lore.kernel.org/lkml/20230418191313.268131-1-hannes@cmpxchg.org/

The following results are from a kernel build test, with additional
concurrent bursts of THP allocations on a memory-constrained system. 
Comparing before and after the changes over 15 runs:

                                                     before                   after
    Hugealloc Time mean               52739.45 (    +0.00%)   28904.00 (   -45.19%)
    Hugealloc Time stddev             56541.26 (    +0.00%)   33464.37 (   -40.81%)
    Kbuild Real time                    197.47 (    +0.00%)     196.59 (    -0.44%)
    Kbuild User time                   1240.49 (    +0.00%)    1231.67 (    -0.71%)
    Kbuild System time                   70.08 (    +0.00%)      59.10 (   -15.45%)
    THP fault alloc                   46727.07 (    +0.00%)   63223.67 (   +35.30%)
    THP fault fallback                21910.60 (    +0.00%)    5412.47 (   -75.29%)
    Direct compact fail                 195.80 (    +0.00%)      59.07 (   -69.48%)
    Direct compact success                7.93 (    +0.00%)       2.80 (   -57.46%)
    Direct compact success rate %         3.51 (    +0.00%)       3.99 (   +10.49%)
    Compact daemon scanned migrate  3369601.27 (    +0.00%) 2267500.33 (   -32.71%)
    Compact daemon scanned free     5075474.47 (    +0.00%) 2339773.00 (   -53.90%)
    Compact direct scanned migrate   161787.27 (    +0.00%)   47659.93 (   -70.54%)
    Compact direct scanned free      163467.53 (    +0.00%)   40729.67 (   -75.08%)
    Compact total migrate scanned   3531388.53 (    +0.00%) 2315160.27 (   -34.44%)
    Compact total free scanned      5238942.00 (    +0.00%) 2380502.67 (   -54.56%)
    Alloc stall                        2371.07 (    +0.00%)     638.87 (   -73.02%)
    Pages kswapd scanned            2160926.73 (    +0.00%) 4002186.33 (   +85.21%)
    Pages kswapd reclaimed           533191.07 (    +0.00%)  718577.80 (   +34.77%)
    Pages direct scanned             400450.33 (    +0.00%)  355172.73 (   -11.31%)
    Pages direct reclaimed            94441.73 (    +0.00%)   31162.80 (   -67.00%)
    Pages total scanned             2561377.07 (    +0.00%) 4357359.07 (   +70.12%)
    Pages total reclaimed            627632.80 (    +0.00%)  749740.60 (   +19.46%)
    Swap out                          47959.53 (    +0.00%)  110084.33 (  +129.53%)
    Swap in                            7276.00 (    +0.00%)   24457.00 (  +236.10%)
    File refaults                    138043.00 (    +0.00%)  188226.93 (   +36.35%)

THP latencies are cut in half, and failure rates are cut by 75%.  These
metrics also hold up over time, while the vanilla kernel sees a steady
downward trend in success rates with each subsequent run, owed to the
cumulative effects of fragmentation.

A more detailed discussion of results is in the patch changelogs.

The patches first introduce a vm.defrag_mode sysctl, which enforces the
existing ALLOC_NOFRAGMENT alloc flag until after reclaim and compaction
have run.  They then change kswapd and kcompactd to target pageblocks,
which boosts success in the ALLOC_NOFRAGMENT hotpaths.

Patches #1 and #2 are somewhat unrelated cleanups, but touch the same code
and so are included here to avoid conflicts from re-ordering.


This patch (of 5):

compaction_suitable() hardcodes the min watermark, with a boost to the low
watermark for costly orders.  However, compaction_ready() requires order-0
at the high watermark.  It currently checks the marks twice.

Make the watermark a parameter to compaction_suitable() and have the
callers pass in what they require:

- compaction_zonelist_suitable() is used by the direct reclaim path,
  so use the min watermark.

- compact_suit_allocation_order() has a watermark in context derived
  from cc->alloc_flags.

  The only quirk is that kcompactd doesn't initialize cc->alloc_flags
  explicitly. There is a direct check in kcompactd_do_work() that
  passes ALLOC_WMARK_MIN, but there is another check downstack in
  compact_zone() that ends up passing the unset alloc_flags. Since
  they default to 0, and that coincides with ALLOC_WMARK_MIN, it is
  correct. But it's subtle. Set cc->alloc_flags explicitly.

- should_continue_reclaim() is direct reclaim, use the min watermark.

- Finally, consolidate the two checks in compaction_ready() to a
  single compaction_suitable() call passing the high watermark.

  There is a tiny change in behavior: before, compaction_suitable()
  would check order-0 against min or low, depending on costly
  order. Then there'd be another high watermark check.

  Now, the high watermark is passed to compaction_suitable(), and the
  costly order-boost (low - min) is added on top. This means
  compaction_ready() sets a marginally higher target for free pages.

  In a kernelbuild + THP pressure test, though, this didn't show any
  measurable negative effects on memory pressure or reclaim rates. As
  the comment above the check says, reclaim is usually stopped short
  on should_continue_reclaim(), and this just defines the worst-case
  reclaim cutoff in case compaction is not making any headway.

[hughd@google.com: stop oops on out-of-range highest_zoneidx]
  Link: https://lkml.kernel.org/r/005ace8b-07fa-01d4-b54b-394a3e029c07@google.com
Link: https://lkml.kernel.org/r/20250313210647.1314586-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20250313210647.1314586-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    5 ++-
 mm/compaction.c            |   52 ++++++++++++++++++-----------------
 mm/vmscan.c                |   26 +++++++++--------
 3 files changed, 45 insertions(+), 38 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-push-watermark-into-compaction_suitable-callers
+++ a/include/linux/compaction.h
@@ -95,7 +95,7 @@ extern enum compact_result try_to_compac
 		struct page **page);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern bool compaction_suitable(struct zone *zone, int order,
-					       int highest_zoneidx);
+				unsigned long watermark, int highest_zoneidx);
 
 extern void compaction_defer_reset(struct zone *zone, int order,
 				bool alloc_success);
@@ -113,7 +113,8 @@ static inline void reset_isolation_suita
 }
 
 static inline bool compaction_suitable(struct zone *zone, int order,
-						      int highest_zoneidx)
+				       unsigned long watermark,
+				       int highest_zoneidx)
 {
 	return false;
 }
--- a/mm/compaction.c~mm-compaction-push-watermark-into-compaction_suitable-callers
+++ a/mm/compaction.c
@@ -2381,40 +2381,42 @@ static enum compact_result compact_finis
 }
 
 static bool __compaction_suitable(struct zone *zone, int order,
-				  int highest_zoneidx,
-				  unsigned long wmark_target)
+				  unsigned long watermark, int highest_zoneidx,
+				  unsigned long free_pages)
 {
-	unsigned long watermark;
 	/*
 	 * Watermarks for order-0 must be met for compaction to be able to
 	 * isolate free pages for migration targets. This means that the
-	 * watermark and alloc_flags have to match, or be more pessimistic than
-	 * the check in __isolate_free_page(). We don't use the direct
-	 * compactor's alloc_flags, as they are not relevant for freepage
-	 * isolation. We however do use the direct compactor's highest_zoneidx
-	 * to skip over zones where lowmem reserves would prevent allocation
-	 * even if compaction succeeds.
-	 * For costly orders, we require low watermark instead of min for
-	 * compaction to proceed to increase its chances.
+	 * watermark have to match, or be more pessimistic than the check in
+	 * __isolate_free_page().
+	 *
+	 * For costly orders, we require a higher watermark for compaction to
+	 * proceed to increase its chances.
+	 *
+	 * We use the direct compactor's highest_zoneidx to skip over zones
+	 * where lowmem reserves would prevent allocation even if compaction
+	 * succeeds.
+	 *
 	 * ALLOC_CMA is used, as pages in CMA pageblocks are considered
-	 * suitable migration targets
+	 * suitable migration targets.
 	 */
-	watermark = (order > PAGE_ALLOC_COSTLY_ORDER) ?
-				low_wmark_pages(zone) : min_wmark_pages(zone);
 	watermark += compact_gap(order);
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		watermark += low_wmark_pages(zone) - min_wmark_pages(zone);
 	return __zone_watermark_ok(zone, 0, watermark, highest_zoneidx,
-				   ALLOC_CMA, wmark_target);
+				   ALLOC_CMA, free_pages);
 }
 
 /*
  * compaction_suitable: Is this suitable to run compaction on this zone now?
  */
-bool compaction_suitable(struct zone *zone, int order, int highest_zoneidx)
+bool compaction_suitable(struct zone *zone, int order, unsigned long watermark,
+			 int highest_zoneidx)
 {
 	enum compact_result compact_result;
 	bool suitable;
 
-	suitable = __compaction_suitable(zone, order, highest_zoneidx,
+	suitable = __compaction_suitable(zone, order, watermark, highest_zoneidx,
 					 zone_page_state(zone, NR_FREE_PAGES));
 	/*
 	 * fragmentation index determines if allocation failures are due to
@@ -2452,6 +2454,7 @@ bool compaction_suitable(struct zone *zo
 	return suitable;
 }
 
+/* Used by direct reclaimers */
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 		int alloc_flags)
 {
@@ -2474,8 +2477,8 @@ bool compaction_zonelist_suitable(struct
 		 */
 		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
-		if (__compaction_suitable(zone, order, ac->highest_zoneidx,
-					  available))
+		if (__compaction_suitable(zone, order, min_wmark_pages(zone),
+					  ac->highest_zoneidx, available))
 			return true;
 	}
 
@@ -2512,13 +2515,13 @@ compaction_suit_allocation_order(struct
 	 */
 	if (order > PAGE_ALLOC_COSTLY_ORDER && async &&
 	    !(alloc_flags & ALLOC_CMA)) {
-		watermark = low_wmark_pages(zone) + compact_gap(order);
-		if (!__zone_watermark_ok(zone, 0, watermark, highest_zoneidx,
-					   0, zone_page_state(zone, NR_FREE_PAGES)))
+		if (!__zone_watermark_ok(zone, 0, watermark + compact_gap(order),
+					 highest_zoneidx, 0,
+					 zone_page_state(zone, NR_FREE_PAGES)))
 			return COMPACT_SKIPPED;
 	}
 
-	if (!compaction_suitable(zone, order, highest_zoneidx))
+	if (!compaction_suitable(zone, order, watermark, highest_zoneidx))
 		return COMPACT_SKIPPED;
 
 	return COMPACT_CONTINUE;
@@ -3081,6 +3084,7 @@ static void kcompactd_do_work(pg_data_t
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = false,
 		.gfp_mask = GFP_KERNEL,
+		.alloc_flags = ALLOC_WMARK_MIN,
 	};
 	enum compact_result ret;
 
@@ -3099,7 +3103,7 @@ static void kcompactd_do_work(pg_data_t
 			continue;
 
 		ret = compaction_suit_allocation_order(zone,
-				cc.order, zoneid, ALLOC_WMARK_MIN,
+				cc.order, zoneid, cc.alloc_flags,
 				false);
 		if (ret != COMPACT_CONTINUE)
 			continue;
--- a/mm/vmscan.c~mm-compaction-push-watermark-into-compaction_suitable-callers
+++ a/mm/vmscan.c
@@ -5890,12 +5890,15 @@ static inline bool should_continue_recla
 
 	/* If compaction would go ahead or the allocation would succeed, stop */
 	for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
+		unsigned long watermark = min_wmark_pages(zone);
+
 		/* Allocation can already succeed, nothing to do */
-		if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
+		if (zone_watermark_ok(zone, sc->order, watermark,
 				      sc->reclaim_idx, 0))
 			return false;
 
-		if (compaction_suitable(zone, sc->order, sc->reclaim_idx))
+		if (compaction_suitable(zone, sc->order, watermark,
+					sc->reclaim_idx))
 			return false;
 	}
 
@@ -6122,22 +6125,21 @@ static inline bool compaction_ready(stru
 			      sc->reclaim_idx, 0))
 		return true;
 
-	/* Compaction cannot yet proceed. Do reclaim. */
-	if (!compaction_suitable(zone, sc->order, sc->reclaim_idx))
-		return false;
-
 	/*
-	 * Compaction is already possible, but it takes time to run and there
-	 * are potentially other callers using the pages just freed. So proceed
-	 * with reclaim to make a buffer of free pages available to give
-	 * compaction a reasonable chance of completing and allocating the page.
+	 * Direct reclaim usually targets the min watermark, but compaction
+	 * takes time to run and there are potentially other callers using the
+	 * pages just freed. So target a higher buffer to give compaction a
+	 * reasonable chance of completing and allocating the pages.
+	 *
 	 * Note that we won't actually reclaim the whole buffer in one attempt
 	 * as the target watermark in should_continue_reclaim() is lower. But if
 	 * we are already above the high+gap watermark, don't reclaim at all.
 	 */
-	watermark = high_wmark_pages(zone) + compact_gap(sc->order);
+	watermark = high_wmark_pages(zone);
+	if (compaction_suitable(zone, sc->order, watermark, sc->reclaim_idx))
+		return true;
 
-	return zone_watermark_ok_safe(zone, 0, watermark, sc->reclaim_idx);
+	return false;
 }
 
 static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


