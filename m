Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9FCE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjJDURi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjJDURh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1BC0
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54839C433C7;
        Wed,  4 Oct 2023 20:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450652;
        bh=qwQ/SPc/I4+i5yzyRsz9Tq+8nHr9X4tn4g/rHmhM/G4=;
        h=Date:To:From:Subject:From;
        b=Vt8S/U9PA2EMp2NuZuDl2sq8gv//3yutqEOeV3ROgXvM4qAYnf8ORdVO/PXaFS3FK
         VaUhAAxwXA+dIZD2RIu05Io80oJer3Zd5kI5RoRPcmHb3CYS8X7tXVtw3EMSwHcVT7
         irFHBiBu8APN1n7Fiw0CS+0gTI87tz2TAxS4PhnU=
Date:   Wed, 04 Oct 2023 13:17:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch removed from -mm tree
Message-Id: <20231004201732.54839C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: factor out code to test if we should run compaction for target order
has been removed from the -mm tree.  Its filename was
     mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: factor out code to test if we should run compaction for target order
Date: Fri, 1 Sep 2023 23:51:41 +0800

We always do zone_watermark_ok check and compaction_suitable check
together to test if compaction for target order should be ran.  Factor
these code out to remove repeat code.

Link: https://lkml.kernel.org/r/20230901155141.249860-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   66 +++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

--- a/mm/compaction.c~mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order
+++ a/mm/compaction.c
@@ -2378,6 +2378,30 @@ bool compaction_zonelist_suitable(struct
 	return false;
 }
 
+/*
+ * Should we do compaction for target allocation order.
+ * Return COMPACT_SUCCESS if allocation for target order can be already
+ * satisfied
+ * Return COMPACT_SKIPPED if compaction for target order is likely to fail
+ * Return COMPACT_CONTINUE if compaction for target order should be ran
+ */
+static enum compact_result
+compaction_suit_allocation_order(struct zone *zone, unsigned int order,
+				 int highest_zoneidx, unsigned int alloc_flags)
+{
+	unsigned long watermark;
+
+	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
+	if (zone_watermark_ok(zone, order, watermark, highest_zoneidx,
+			      alloc_flags))
+		return COMPACT_SUCCESS;
+
+	if (!compaction_suitable(zone, order, highest_zoneidx))
+		return COMPACT_SKIPPED;
+
+	return COMPACT_CONTINUE;
+}
+
 static enum compact_result
 compact_zone(struct compact_control *cc, struct capture_control *capc)
 {
@@ -2403,19 +2427,11 @@ compact_zone(struct compact_control *cc,
 	cc->migratetype = gfp_migratetype(cc->gfp_mask);
 
 	if (!is_via_compact_memory(cc->order)) {
-		unsigned long watermark;
-
-		/* Allocation can already succeed, nothing to do */
-		watermark = wmark_pages(cc->zone,
-					cc->alloc_flags & ALLOC_WMARK_MASK);
-		if (zone_watermark_ok(cc->zone, cc->order, watermark,
-				      cc->highest_zoneidx, cc->alloc_flags))
-			return COMPACT_SUCCESS;
-
-		/* Compaction is likely to fail */
-		if (!compaction_suitable(cc->zone, cc->order,
-					 cc->highest_zoneidx))
-			return COMPACT_SKIPPED;
+		ret = compaction_suit_allocation_order(cc->zone, cc->order,
+						       cc->highest_zoneidx,
+						       cc->alloc_flags);
+		if (ret != COMPACT_CONTINUE)
+			return ret;
 	}
 
 	/*
@@ -2914,6 +2930,7 @@ static bool kcompactd_node_suitable(pg_d
 	int zoneid;
 	struct zone *zone;
 	enum zone_type highest_zoneidx = pgdat->kcompactd_highest_zoneidx;
+	enum compact_result ret;
 
 	for (zoneid = 0; zoneid <= highest_zoneidx; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
@@ -2921,14 +2938,10 @@ static bool kcompactd_node_suitable(pg_d
 		if (!populated_zone(zone))
 			continue;
 
-		/* Allocation can already succeed, check other zones */
-		if (zone_watermark_ok(zone, pgdat->kcompactd_max_order,
-				      min_wmark_pages(zone),
-				      highest_zoneidx, 0))
-			continue;
-
-		if (compaction_suitable(zone, pgdat->kcompactd_max_order,
-					highest_zoneidx))
+		ret = compaction_suit_allocation_order(zone,
+				pgdat->kcompactd_max_order,
+				highest_zoneidx, ALLOC_WMARK_MIN);
+		if (ret == COMPACT_CONTINUE)
 			return true;
 	}
 
@@ -2951,6 +2964,8 @@ static void kcompactd_do_work(pg_data_t
 		.ignore_skip_hint = false,
 		.gfp_mask = GFP_KERNEL,
 	};
+	enum compact_result ret;
+
 	trace_mm_compaction_kcompactd_wake(pgdat->node_id, cc.order,
 							cc.highest_zoneidx);
 	count_compact_event(KCOMPACTD_WAKE);
@@ -2965,12 +2980,9 @@ static void kcompactd_do_work(pg_data_t
 		if (compaction_deferred(zone, cc.order))
 			continue;
 
-		/* Allocation can already succeed, nothing to do */
-		if (zone_watermark_ok(zone, cc.order,
-				      min_wmark_pages(zone), zoneid, 0))
-			continue;
-
-		if (!compaction_suitable(zone, cc.order, zoneid))
+		ret = compaction_suit_allocation_order(zone,
+				cc.order, zoneid, ALLOC_WMARK_MIN);
+		if (ret != COMPACT_CONTINUE)
 			continue;
 
 		if (kthread_should_stop())
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

