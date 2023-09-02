Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F327BC71153
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjIBWip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjIBWin (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:38:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFF7CED
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AA9A60EE9
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C292FC433C7;
        Sat,  2 Sep 2023 22:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693694319;
        bh=K7PLWpdr8Ni33xJMm/p68Y0RJZItt0VwQiBTr26h/aQ=;
        h=Date:To:From:Subject:From;
        b=NUUBFF2eZongXwagXrHRC6Bwsi35Mb9WEmGtPFhCmXDFaN1EhgzdbPQthd4pVd6dx
         0QH3pobrip02dYtK1/qbAsFlkP1DWDuvUzLEGUHfSrC+xnyNbAmoXWkvx1CedlGms+
         kF+sjxSsF5ZqvPYNV3uqzc3tQh1hc1i8TuhuPuTQ=
Date:   Sat, 02 Sep 2023 15:38:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch added to mm-unstable branch
Message-Id: <20230902223839.C292FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: factor out code to test if we should run compaction for target order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

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

mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

