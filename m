Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69315C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B292067C
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732060AbhAYWKA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732589AbhAYWIs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 17:08:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3252216FD;
        Mon, 25 Jan 2021 22:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611612487;
        bh=Thm1qyBc2pmLqhXjiIhrG4CdwMt5DsmX+B+Efsydq+w=;
        h=Date:From:To:Subject:From;
        b=dZ5awrPTn3U0y+LHSfQ6EstZx059CN7GxrYM3cwF411fVeoJo798NCqxxINvytZsJ
         zE06mMNF0xah7jS6KtDzvHpCAnjqERkOARKzJA9zR8BkQWGGhw6NaL2FXLjby/mqf2
         842CecpXseAS9qdjhAg0J0+Hrs3A9b5VvV50JoCQ=
Date:   Mon, 25 Jan 2021 14:08:06 -0800
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, khalid.aziz@oracle.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, ngupta@nitingupta.dev, vbabka@suse.cz,
        vinmenon@codeaurora.org
Subject:  [obsolete]
 mm-compaction-return-proper-state-in-should_proactive_compact_node.patch
 removed from -mm tree
Message-ID: <20210125220806.lZA-6_iL5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: return proper state in should_proactive_compact_node
has been removed from the -mm tree.  Its filename was
     mm-compaction-return-proper-state-in-should_proactive_compact_node.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm/compaction: return proper state in should_proactive_compact_node

should_proactive_compact_node() returns true when sum of the fragmentation
score of all the zones in the node is greater than the wmark_high of
compaction which then triggers the proactive compaction that operates on
the individual zones of the node.  But proactive compaction runs on the
zone only when the fragmentation score of the zone is greater than
wmark_low(=wmark_high - 10).

This means that the sum of the fragmentation scores of all the zones can
exceed the wmark_high but individual zone scores can still be less than
the wmark_low which makes the unnecessary trigger of the proactive
compaction only to return doing nothing.

Another issue with the return of proactive compaction with out even trying
is its deferral.  It is simply deferred for 1 << COMPACT_MAX_DEFER_SHIFT
if the scores across the proactive compaction is same, thinking that
compaction didn't make any progress but in reality it didn't even try. 
With the delay between successive retries for proactive compaction is
500msec, it can result into the deferral for ~30sec with out even trying
the proactive compaction.

Test scenario is that: compaction_proactiveness=50 thus the wmark_low = 50
and wmark_high = 60.  System have 2 zones(Normal and Movable) with sizes
5GB and 6GB respectively.  After opening some apps on the android, the
fragmentation scores of these zones are 47 and 49 respectively.  Since the
sum of these fragmentation scores are above the wmark_high which triggers
the proactive compaction and there since the individual zone scores are
below wmark_low, it returns without trying the compaction.  As a result
the fragmentation scores of the zones are still 47 and 49 which makes the
existing logic to defer the compaction thinking that noprogress is made
across the compaction.

So, run the proactive compaction on the node zones only when atleast one
of the zones fragmentation score is greater than wmark_low.  This avoids
the unnecessary deferral and retries of the compaction.

[akpm@linux-foundation.org: s/max_t/max/]
Link: https://lkml.kernel.org/r/1610546586-18998-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Nitin Gupta <ngupta@nitingupta.dev>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-return-proper-state-in-should_proactive_compact_node
+++ a/mm/compaction.c
@@ -1961,6 +1961,26 @@ static unsigned int fragmentation_score_
 	return score;
 }
 
+/*
+ * Returns the maximum of fragmentation scores of zones in a node. This is
+ * used in taking the decission of whether to trigger the proactive compaction
+ * on the zones of this node.
+ */
+static unsigned int fragmentation_score_node_zones_max(pg_data_t *pgdat)
+{
+	int zoneid;
+	unsigned int max = 0;
+
+	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		struct zone *zone;
+
+		zone = &pgdat->node_zones[zoneid];
+		max = max(fragmentation_score_zone(zone), max);
+	}
+
+	return max;
+}
+
 static unsigned int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
 {
 	unsigned int wmark_low;
@@ -1976,13 +1996,16 @@ static unsigned int fragmentation_score_
 
 static bool should_proactive_compact_node(pg_data_t *pgdat)
 {
-	int wmark_high;
+	int wmark_low, wmark_high;
 
 	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
 		return false;
 
 	wmark_high = fragmentation_score_wmark(pgdat, false);
-	return fragmentation_score_node(pgdat) > wmark_high;
+	wmark_low = fragmentation_score_wmark(pgdat, true);
+
+	return fragmentation_score_node(pgdat) > wmark_high &&
+		fragmentation_score_node_zones_max(pgdat) > wmark_low;
 }
 
 static enum compact_result __compact_finished(struct compact_control *cc)
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-compaction-correct-deferral-logic-for-proactive-compaction.patch

