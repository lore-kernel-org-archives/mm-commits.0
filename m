Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE5BC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjFIXbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbjFIX3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F55422E
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 474B363EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B327C433D2;
        Fri,  9 Jun 2023 23:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353331;
        bh=Ti+7iMIEX3FirxSSA3aeoCsx/PG2bvBfgi0vz19zimU=;
        h=Date:To:From:Subject:From;
        b=etwcKrwG1R6NiwGIgePImiHx62BAxqRDYijxT1zCZ+ggEqgVwcLo3xXR6IjiVYEy5
         ItBuy6G1mWmtEB7+tvHdKW9Yo0wuU2kfFuI6RqIOyFAuqVs6yF2FFxFdjbfZRS9Jk9
         tIwtg6HWjwVWP//29r0ThEi6N8DDhmRx2Vsw9R7M=
Date:   Fri, 09 Jun 2023 16:28:51 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-refactor-__compaction_suitable.patch removed from -mm tree
Message-Id: <20230609232851.9B327C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: refactor __compaction_suitable()
has been removed from the -mm tree.  Its filename was
     mm-compaction-refactor-__compaction_suitable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: refactor __compaction_suitable()
Date: Fri, 19 May 2023 14:39:57 +0200

__compaction_suitable() is supposed to check for available migration
targets.  However, it also checks whether the operation was requested via
/proc/sys/vm/compact_memory, and whether the original allocation request
can already succeed.  These don't apply to all callsites.

Move the checks out to the callers, so that later patches can deal with
them one by one.  No functional change intended.

[hannes@cmpxchg.org: fix comment, per Vlastimil]
  Link: https://lkml.kernel.org/r/20230602144942.GC161817@cmpxchg.org
Link: https://lkml.kernel.org/r/20230519123959.77335-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 -
 mm/compaction.c            |   79 ++++++++++++++++++++++-------------
 mm/vmscan.c                |   35 +++++++++------
 3 files changed, 73 insertions(+), 45 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-refactor-__compaction_suitable
+++ a/include/linux/compaction.h
@@ -90,7 +90,7 @@ extern enum compact_result try_to_compac
 		struct page **page);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern enum compact_result compaction_suitable(struct zone *zone, int order,
-		unsigned int alloc_flags, int highest_zoneidx);
+					       int highest_zoneidx);
 
 extern void compaction_defer_reset(struct zone *zone, int order,
 				bool alloc_success);
@@ -108,7 +108,7 @@ static inline void reset_isolation_suita
 }
 
 static inline enum compact_result compaction_suitable(struct zone *zone, int order,
-					int alloc_flags, int highest_zoneidx)
+						      int highest_zoneidx)
 {
 	return COMPACT_SKIPPED;
 }
--- a/mm/compaction.c~mm-compaction-refactor-__compaction_suitable
+++ a/mm/compaction.c
@@ -2194,24 +2194,10 @@ static enum compact_result compact_finis
 }
 
 static enum compact_result __compaction_suitable(struct zone *zone, int order,
-					unsigned int alloc_flags,
 					int highest_zoneidx,
 					unsigned long wmark_target)
 {
 	unsigned long watermark;
-
-	if (is_via_compact_memory(order))
-		return COMPACT_CONTINUE;
-
-	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
-	/*
-	 * If watermarks for high-order allocation are already met, there
-	 * should be no need for compaction at all.
-	 */
-	if (zone_watermark_ok(zone, order, watermark, highest_zoneidx,
-								alloc_flags))
-		return COMPACT_SUCCESS;
-
 	/*
 	 * Watermarks for order-0 must be met for compaction to be able to
 	 * isolate free pages for migration targets. This means that the
@@ -2240,17 +2226,15 @@ static enum compact_result __compaction_
  * compaction_suitable: Is this suitable to run compaction on this zone now?
  * Returns
  *   COMPACT_SKIPPED  - If there are too few free pages for compaction
- *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
 enum compact_result compaction_suitable(struct zone *zone, int order,
-					unsigned int alloc_flags,
 					int highest_zoneidx)
 {
 	enum compact_result ret;
 	int fragindex;
 
-	ret = __compaction_suitable(zone, order, alloc_flags, highest_zoneidx,
+	ret = __compaction_suitable(zone, order, highest_zoneidx,
 				    zone_page_state(zone, NR_FREE_PAGES));
 	/*
 	 * fragmentation index determines if allocation failures are due to
@@ -2294,7 +2278,16 @@ bool compaction_zonelist_suitable(struct
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
-		enum compact_result compact_result;
+		unsigned long watermark;
+
+		if (is_via_compact_memory(order))
+			return true;
+
+		/* Allocation can already succeed, nothing to do */
+		watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
+		if (zone_watermark_ok(zone, order, watermark,
+				      ac->highest_zoneidx, alloc_flags))
+			continue;
 
 		/*
 		 * Do not consider all the reclaimable memory because we do not
@@ -2304,9 +2297,8 @@ bool compaction_zonelist_suitable(struct
 		 */
 		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
-		compact_result = __compaction_suitable(zone, order, alloc_flags,
-				ac->highest_zoneidx, available);
-		if (compact_result == COMPACT_CONTINUE)
+		if (__compaction_suitable(zone, order, ac->highest_zoneidx,
+					  available) == COMPACT_CONTINUE)
 			return true;
 	}
 
@@ -2336,11 +2328,23 @@ compact_zone(struct compact_control *cc,
 	INIT_LIST_HEAD(&cc->migratepages);
 
 	cc->migratetype = gfp_migratetype(cc->gfp_mask);
-	ret = compaction_suitable(cc->zone, cc->order, cc->alloc_flags,
-							cc->highest_zoneidx);
-	/* Compaction is likely to fail */
-	if (ret == COMPACT_SUCCESS || ret == COMPACT_SKIPPED)
-		return ret;
+
+	if (!is_via_compact_memory(cc->order)) {
+		unsigned long watermark;
+
+		/* Allocation can already succeed, nothing to do */
+		watermark = wmark_pages(cc->zone,
+					cc->alloc_flags & ALLOC_WMARK_MASK);
+		if (zone_watermark_ok(cc->zone, cc->order, watermark,
+				      cc->highest_zoneidx, cc->alloc_flags))
+			return COMPACT_SUCCESS;
+
+		ret = compaction_suitable(cc->zone, cc->order,
+					  cc->highest_zoneidx);
+		/* Compaction is likely to fail */
+		if (ret == COMPACT_SKIPPED)
+			return ret;
+	}
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
@@ -2844,7 +2848,16 @@ static bool kcompactd_node_suitable(pg_d
 		if (!populated_zone(zone))
 			continue;
 
-		if (compaction_suitable(zone, pgdat->kcompactd_max_order, 0,
+		if (is_via_compact_memory(pgdat->kcompactd_max_order))
+			return true;
+
+		/* Allocation can already succeed, check other zones */
+		if (zone_watermark_ok(zone, pgdat->kcompactd_max_order,
+				      min_wmark_pages(zone),
+				      highest_zoneidx, 0))
+			continue;
+
+		if (compaction_suitable(zone, pgdat->kcompactd_max_order,
 					highest_zoneidx) == COMPACT_CONTINUE)
 			return true;
 	}
@@ -2882,10 +2895,18 @@ static void kcompactd_do_work(pg_data_t
 		if (compaction_deferred(zone, cc.order))
 			continue;
 
-		if (compaction_suitable(zone, cc.order, 0, zoneid) !=
-							COMPACT_CONTINUE)
+		if (is_via_compact_memory(cc.order))
+			goto compact;
+
+		/* Allocation can already succeed, nothing to do */
+		if (zone_watermark_ok(zone, cc.order,
+				      min_wmark_pages(zone), zoneid, 0))
 			continue;
 
+		if (compaction_suitable(zone, cc.order,
+					zoneid) != COMPACT_CONTINUE)
+			continue;
+compact:
 		if (kthread_should_stop())
 			return;
 
--- a/mm/vmscan.c~mm-compaction-refactor-__compaction_suitable
+++ a/mm/vmscan.c
@@ -6399,14 +6399,17 @@ static inline bool should_continue_recla
 		if (!managed_zone(zone))
 			continue;
 
-		switch (compaction_suitable(zone, sc->order, 0, sc->reclaim_idx)) {
-		case COMPACT_SUCCESS:
-		case COMPACT_CONTINUE:
+		if (sc->order == -1) /* is_via_compact_memory() */
+			return false;
+
+		/* Allocation can already succeed, nothing to do */
+		if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
+				      sc->reclaim_idx, 0))
+			return false;
+
+		if (compaction_suitable(zone, sc->order,
+					sc->reclaim_idx) == COMPACT_CONTINUE)
 			return false;
-		default:
-			/* check next zone */
-			;
-		}
 	}
 
 	/*
@@ -6594,16 +6597,20 @@ again:
 static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long watermark;
-	enum compact_result suitable;
 
-	suitable = compaction_suitable(zone, sc->order, 0, sc->reclaim_idx);
-	if (suitable == COMPACT_SUCCESS)
-		/* Allocation should succeed already. Don't reclaim. */
+	if (sc->order == -1) /* is_via_compact_memory() */
+		goto suitable;
+
+	/* Allocation can already succeed, nothing to do */
+	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
+			      sc->reclaim_idx, 0))
 		return true;
-	if (suitable == COMPACT_SKIPPED)
-		/* Compaction cannot yet proceed. Do reclaim. */
-		return false;
 
+	/* Compaction cannot yet proceed. Do reclaim. */
+	if (compaction_suitable(zone, sc->order,
+				sc->reclaim_idx) == COMPACT_SKIPPED)
+		return false;
+suitable:
 	/*
 	 * Compaction is already possible, but it takes time to run and there
 	 * are potentially other callers using the pages just freed. So proceed
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_isolation-write-proper-kerneldoc.patch

