Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73D7C7EE24
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 18:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbjFBS00 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 14:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbjFBS0Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 14:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403FA123
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 11:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBA7260C05
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 18:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15603C4339B;
        Fri,  2 Jun 2023 18:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685730383;
        bh=3vPe9zRJhL9LER6bYeIxpg/eLUNZwlBoGCE3TP13GD8=;
        h=Date:To:From:Subject:From;
        b=a+y/ZLYc7Syfj8eijf3BC7LZhxqqGvJ/m94Hys2fBdR1Cvr8oelMBvIqq+S7NjykG
         1QV4r7NCH5JY4woYysE6uhm9ihPyx1WioC6VVyassTznQcCjJcH0TaenPBEK2VoCoe
         E0Ap3s3l4yU833BpqZhn4PXXbxdN+qac4Gghm01o=
Date:   Fri, 02 Jun 2023 11:26:22 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-have-compaction_suitable-return-bool.patch added to mm-unstable branch
Message-Id: <20230602182623.15603C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: have compaction_suitable() return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-have-compaction_suitable-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-have-compaction_suitable-return-bool.patch

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
Subject: mm: compaction: have compaction_suitable() return bool
Date: Fri, 2 Jun 2023 11:12:04 -0400

Since it only returns COMPACT_CONTINUE or COMPACT_SKIPPED now, a bool
return value simplifies the callsites.

Link: https://lkml.kernel.org/r/20230602151204.GD161817@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    6 +--
 mm/compaction.c            |   62 ++++++++++++++++-------------------
 mm/vmscan.c                |    6 +--
 3 files changed, 35 insertions(+), 39 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-have-compaction_suitable-return-bool
+++ a/include/linux/compaction.h
@@ -89,7 +89,7 @@ extern enum compact_result try_to_compac
 		const struct alloc_context *ac, enum compact_priority prio,
 		struct page **page);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
-extern enum compact_result compaction_suitable(struct zone *zone, int order,
+extern bool compaction_suitable(struct zone *zone, int order,
 					       int highest_zoneidx);
 
 extern void compaction_defer_reset(struct zone *zone, int order,
@@ -107,10 +107,10 @@ static inline void reset_isolation_suita
 {
 }
 
-static inline enum compact_result compaction_suitable(struct zone *zone, int order,
+static inline bool compaction_suitable(struct zone *zone, int order,
 						      int highest_zoneidx)
 {
-	return COMPACT_SKIPPED;
+	return false;
 }
 
 static inline void kcompactd_run(int nid)
--- a/mm/compaction.c~mm-compaction-have-compaction_suitable-return-bool
+++ a/mm/compaction.c
@@ -2238,9 +2238,9 @@ static enum compact_result compact_finis
 	return ret;
 }
 
-static enum compact_result __compaction_suitable(struct zone *zone, int order,
-					int highest_zoneidx,
-					unsigned long wmark_target)
+static bool __compaction_suitable(struct zone *zone, int order,
+				  int highest_zoneidx,
+				  unsigned long wmark_target)
 {
 	unsigned long watermark;
 	/*
@@ -2260,28 +2260,21 @@ static enum compact_result __compaction_
 	watermark = (order > PAGE_ALLOC_COSTLY_ORDER) ?
 				low_wmark_pages(zone) : min_wmark_pages(zone);
 	watermark += compact_gap(order);
-	if (!__zone_watermark_ok(zone, 0, watermark, highest_zoneidx,
-						ALLOC_CMA, wmark_target))
-		return COMPACT_SKIPPED;
-
-	return COMPACT_CONTINUE;
+	return __zone_watermark_ok(zone, 0, watermark, highest_zoneidx,
+				   ALLOC_CMA, wmark_target);
 }
 
 /*
  * compaction_suitable: Is this suitable to run compaction on this zone now?
- * Returns
- *   COMPACT_SKIPPED  - If there are too few free pages for compaction
- *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
- *   COMPACT_CONTINUE - If compaction should run now
  */
 enum compact_result compaction_suitable(struct zone *zone, int order,
 					int highest_zoneidx)
 {
-	enum compact_result ret;
-	int fragindex;
+	enum compact_result compact_result;
+	bool suitable;
 
-	ret = __compaction_suitable(zone, order, highest_zoneidx,
-				    zone_page_state(zone, NR_FREE_PAGES));
+	suitable = __compaction_suitable(zone, order, highest_zoneidx,
+					 zone_page_state(zone, NR_FREE_PAGES));
 	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
@@ -2298,17 +2291,24 @@ enum compact_result compaction_suitable(
 	 * excessive compaction for costly orders, but it should not be at the
 	 * expense of system stability.
 	 */
-	if (ret == COMPACT_CONTINUE && (order > PAGE_ALLOC_COSTLY_ORDER)) {
-		fragindex = fragmentation_index(zone, order);
-		if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
-			ret = COMPACT_NOT_SUITABLE_ZONE;
+	if (suitable) {
+		compact_result = COMPACT_CONTINUE;
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			int fragindex = fragmentation_index(zone, order);
+
+			if (fragindex >= 0 &&
+			    fragindex <= sysctl_extfrag_threshold) {
+				suitable = false;
+				compact_result = COMPACT_NOT_SUITABLE_ZONE;
+			}
+		}
+	} else {
+		compact_result = COMPACT_SKIPPED;
 	}
 
-	trace_mm_compaction_suitable(zone, order, ret);
-	if (ret == COMPACT_NOT_SUITABLE_ZONE)
-		ret = COMPACT_SKIPPED;
+	trace_mm_compaction_suitable(zone, order, compact_result);
 
-	return ret;
+	return suitable;
 }
 
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
@@ -2334,7 +2334,7 @@ bool compaction_zonelist_suitable(struct
 		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 		if (__compaction_suitable(zone, order, ac->highest_zoneidx,
-					  available) == COMPACT_CONTINUE)
+					  available))
 			return true;
 	}
 
@@ -2375,11 +2375,10 @@ compact_zone(struct compact_control *cc,
 				      cc->highest_zoneidx, cc->alloc_flags))
 			return COMPACT_SUCCESS;
 
-		ret = compaction_suitable(cc->zone, cc->order,
-					  cc->highest_zoneidx);
 		/* Compaction is likely to fail */
-		if (ret == COMPACT_SKIPPED)
-			return ret;
+		if (!compaction_suitable(cc->zone, cc->order,
+					 cc->highest_zoneidx))
+			return COMPACT_SKIPPED;
 	}
 
 	/*
@@ -2891,7 +2890,7 @@ static bool kcompactd_node_suitable(pg_d
 			continue;
 
 		if (compaction_suitable(zone, pgdat->kcompactd_max_order,
-					highest_zoneidx) == COMPACT_CONTINUE)
+					highest_zoneidx))
 			return true;
 	}
 
@@ -2933,8 +2932,7 @@ static void kcompactd_do_work(pg_data_t
 				      min_wmark_pages(zone), zoneid, 0))
 			continue;
 
-		if (compaction_suitable(zone, cc.order,
-					zoneid) != COMPACT_CONTINUE)
+		if (!compaction_suitable(zone, cc.order, zoneid))
 			continue;
 
 		if (kthread_should_stop())
--- a/mm/vmscan.c~mm-compaction-have-compaction_suitable-return-bool
+++ a/mm/vmscan.c
@@ -6416,8 +6416,7 @@ static inline bool should_continue_recla
 				      sc->reclaim_idx, 0))
 			return false;
 
-		if (compaction_suitable(zone, sc->order,
-					sc->reclaim_idx) == COMPACT_CONTINUE)
+		if (compaction_suitable(zone, sc->order, sc->reclaim_idx))
 			return false;
 	}
 
@@ -6613,8 +6612,7 @@ static inline bool compaction_ready(stru
 		return true;
 
 	/* Compaction cannot yet proceed. Do reclaim. */
-	if (compaction_suitable(zone, sc->order,
-				sc->reclaim_idx) == COMPACT_SKIPPED)
+	if (!compaction_suitable(zone, sc->order, sc->reclaim_idx))
 		return false;
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch
mm-page_isolation-write-proper-kerneldoc.patch
mm-compaction-avoid-gfp_nofs-abba-deadlock.patch
mm-compaction-have-compaction_suitable-return-bool.patch

