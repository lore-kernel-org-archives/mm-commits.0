Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F748C7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjESVkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjESVkA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447CD1B0
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3EFE65B0A
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8EFC433D2;
        Fri, 19 May 2023 21:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532398;
        bh=7BjsMKW0cBm47i3H3GvbPNpgwZaAJGZq6MImMOM5+Rc=;
        h=Date:To:From:Subject:From;
        b=kWSRYmy28pSlLwkAAX6zlWvXuRGjQIQujelSWa0+BYsKJvbrIPxYZ+nGC9HBoHCGq
         kl80qF3E903co/W7aTkildaaQA6QoiC3MzEaawso0qiTFP/L6R92DTIhCH/v4wsioe
         WtDAm7eJhxJR1dwWZlQ+W9WOL0wWR3bRlullTzVw=
Date:   Fri, 19 May 2023 14:39:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-refactor-__compaction_suitable.patch added to mm-unstable branch
Message-Id: <20230519213958.2A8EFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: refactor __compaction_suitable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-refactor-__compaction_suitable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-refactor-__compaction_suitable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20230519123959.77335-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 -
 mm/compaction.c            |   78 ++++++++++++++++++++++-------------
 mm/vmscan.c                |   35 +++++++++------
 3 files changed, 73 insertions(+), 44 deletions(-)

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
@@ -2216,24 +2216,10 @@ static enum compact_result compact_finis
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
@@ -2266,13 +2252,12 @@ static enum compact_result __compaction_
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
@@ -2316,7 +2301,16 @@ bool compaction_zonelist_suitable(struct
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
@@ -2326,9 +2320,8 @@ bool compaction_zonelist_suitable(struct
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
 
@@ -2358,11 +2351,23 @@ compact_zone(struct compact_control *cc,
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
@@ -2866,7 +2871,16 @@ static bool kcompactd_node_suitable(pg_d
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
@@ -2904,10 +2918,18 @@ static void kcompactd_do_work(pg_data_t
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

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

