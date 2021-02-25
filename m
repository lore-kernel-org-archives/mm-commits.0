Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FB1C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C99664F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhBYTgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234827AbhBYTfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEABD64FBE;
        Thu, 25 Feb 2021 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280725;
        bh=aEXocNJYQRTxTiB4+zEhfKEJ2L7NcWXvWpTAQCFX6gw=;
        h=Date:From:To:Subject:From;
        b=C7xc2NkflMN+0u7YPr20vpsmMOHlgqIljvleFXj/we2/4moFWM5lFSpW/hsrtA8TP
         nTy44ZevYFLPvQIaOm/VsOqDn/eB2GbrqkqLkyeWSOjwHJJnT144sydENwqP54Mtdj
         AcO0JfldZ7r4a8vzQ4FKfQSnRw+UMPQBcJ/aJejc=
Date:   Thu, 25 Feb 2021 11:18:44 -0800
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, khalid.aziz@oracle.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, ngupta@nitingupta.dev,
        rientjes@google.com, vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  [merged]
 mm-compaction-correct-deferral-logic-for-proactive-compaction.patch removed
 from -mm tree
Message-ID: <20210225191844.54V8TfBnm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: correct deferral logic for proactive compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-deferral-logic-for-proactive-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm/compaction: correct deferral logic for proactive compaction

should_proactive_compact_node() returns true when sum of the weighted
fragmentation score of all the zones in the node is greater than the
wmark_high of compaction, which then triggers the proactive compaction
that operates on the individual zones of the node.  But proactive
compaction runs on the zone only when its weighted fragmentation score is
greater than wmark_low(=wmark_high - 10).

This means that the sum of the weighted fragmentation scores of all the
zones can exceed the wmark_high but individual weighted fragmentation zone
scores can still be less than wmark_low which makes the unnecessary
trigger of the proactive compaction only to return doing nothing.

Issue with the return of proactive compaction with out even trying is its
deferral.  It is simply deferred for 1 << COMPACT_MAX_DEFER_SHIFT if the
scores across the proactive compaction is same, thinking that compaction
didn't make any progress but in reality it didn't even try.  With the
delay between successive retries for proactive compaction is 500msec, it
can result into the deferral for ~30sec with out even trying the proactive
compaction.

Test scenario is that: compaction_proactiveness=50 thus the wmark_low = 50
and wmark_high = 60.  System have 2 zones(Normal and Movable) with sizes
5GB and 6GB respectively.  After opening some apps on the android, the
weighted fragmentation scores of these zones are 47 and 49 respectively. 
Since the sum of these fragmentation scores are above the wmark_high which
triggers the proactive compaction and there since the individual zones
weighted fragmentation scores are below wmark_low, it returns without
trying the proactive compaction.  As a result the weighted fragmentation
scores of the zones are still 47 and 49 which makes the existing logic to
defer the compaction thinking that noprogress is made across the
compaction.

Fix this by checking just zone fragmentation score, not the weighted, in
__compact_finished() and use the zones weighted fragmentation score in
fragmentation_score_node().  In the test case above, If the weighted
average of is above wmark_high, then individual score (not adjusted) of
atleast one zone has to be above wmark_high.  Thus it avoids the
unnecessary trigger and deferrals of the proactive compaction.

Link: https://lkml.kernel.org/r/1610989938-31374-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nitin Gupta <ngupta@nitingupta.dev>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/compaction.c~mm-compaction-correct-deferral-logic-for-proactive-compaction
+++ a/mm/compaction.c
@@ -1922,20 +1922,28 @@ static bool kswapd_is_running(pg_data_t
 
 /*
  * A zone's fragmentation score is the external fragmentation wrt to the
- * COMPACTION_HPAGE_ORDER scaled by the zone's size. It returns a value
- * in the range [0, 100].
+ * COMPACTION_HPAGE_ORDER. It returns a value in the range [0, 100].
+ */
+static unsigned int fragmentation_score_zone(struct zone *zone)
+{
+	return extfrag_for_order(zone, COMPACTION_HPAGE_ORDER);
+}
+
+/*
+ * A weighted zone's fragmentation score is the external fragmentation
+ * wrt to the COMPACTION_HPAGE_ORDER scaled by the zone's size. It
+ * returns a value in the range [0, 100].
  *
  * The scaling factor ensures that proactive compaction focuses on larger
  * zones like ZONE_NORMAL, rather than smaller, specialized zones like
  * ZONE_DMA32. For smaller zones, the score value remains close to zero,
  * and thus never exceeds the high threshold for proactive compaction.
  */
-static unsigned int fragmentation_score_zone(struct zone *zone)
+static unsigned int fragmentation_score_zone_weighted(struct zone *zone)
 {
 	unsigned long score;
 
-	score = zone->present_pages *
-			extfrag_for_order(zone, COMPACTION_HPAGE_ORDER);
+	score = zone->present_pages * fragmentation_score_zone(zone);
 	return div64_ul(score, zone->zone_pgdat->node_present_pages + 1);
 }
 
@@ -1955,7 +1963,7 @@ static unsigned int fragmentation_score_
 		struct zone *zone;
 
 		zone = &pgdat->node_zones[zoneid];
-		score += fragmentation_score_zone(zone);
+		score += fragmentation_score_zone_weighted(zone);
 	}
 
 	return score;
_

Patches currently in -mm which might be from charante@codeaurora.org are


