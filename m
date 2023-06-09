Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5F8C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjFIXbg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbjFIXaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:30:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA6D3ABE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A8BB60D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616BFC433EF;
        Fri,  9 Jun 2023 23:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353336;
        bh=INYS0+f8nSeD87G0gz9Dpvticz7w4s39OeIhVrt7BxA=;
        h=Date:To:From:Subject:From;
        b=Vb2bXPt7jSz33QQ3FIdcj/Yj1JGBWNqeRfud70MGGCYqM3eBGaEDGS2tUDuKwP8j7
         241VJvN9r1hRqhCmjpUCdIQ9Mu1OxGzdGYW0aEu6mTZp5RqJ2NEQaBbaInd7tUAk8j
         kFTALTk45Ui37JVlF4268mmWkh2hblD5Cw8961rM=
Date:   Fri, 09 Jun 2023 16:28:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-avoid-gfp_nofs-abba-deadlock.patch removed from -mm tree
Message-Id: <20230609232856.616BFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: avoid GFP_NOFS ABBA deadlock
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-gfp_nofs-abba-deadlock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: avoid GFP_NOFS ABBA deadlock
Date: Fri, 19 May 2023 13:13:59 +0200

During stress testing with higher-order allocations, a deadlock scenario
was observed in compaction: One GFP_NOFS allocation was sleeping on
mm/compaction.c::too_many_isolated(), while all CPUs in the system were
busy with compactors spinning on buffer locks held by the sleeping
GFP_NOFS allocation.

Reclaim is susceptible to this same deadlock; we fixed it by granting
GFP_NOFS allocations additional LRU isolation headroom, to ensure it makes
forward progress while holding fs locks that other reclaimers might
acquire.  Do the same here.

This code has been like this since compaction was initially merged, and I
only managed to trigger this with out-of-tree patches that dramatically
increase the contexts that do GFP_NOFS compaction.  While the issue is
real, it seems theoretical in nature given existing allocation sites. 
Worth fixing now, but no Fixes tag or stable CC.

Link: https://lkml.kernel.org/r/20230519111359.40475-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-avoid-gfp_nofs-abba-deadlock
+++ a/mm/compaction.c
@@ -740,8 +740,9 @@ isolate_freepages_range(struct compact_c
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */
-static bool too_many_isolated(pg_data_t *pgdat)
+static bool too_many_isolated(struct compact_control *cc)
 {
+	pg_data_t *pgdat = cc->zone->zone_pgdat;
 	bool too_many;
 
 	unsigned long active, inactive, isolated;
@@ -753,6 +754,17 @@ static bool too_many_isolated(pg_data_t
 	isolated = node_page_state(pgdat, NR_ISOLATED_FILE) +
 			node_page_state(pgdat, NR_ISOLATED_ANON);
 
+	/*
+	 * Allow GFP_NOFS to isolate past the limit set for regular
+	 * compaction runs. This prevents an ABBA deadlock when other
+	 * compactors have already isolated to the limit, but are
+	 * blocked on filesystem locks held by the GFP_NOFS thread.
+	 */
+	if (cc->gfp_mask & __GFP_FS) {
+		inactive >>= 3;
+		active >>= 3;
+	}
+
 	too_many = isolated > (inactive + active) / 2;
 	if (!too_many)
 		wake_throttle_isolated(pgdat);
@@ -801,7 +813,7 @@ isolate_migratepages_block(struct compac
 	 * list by either parallel reclaimers or compaction. If there are,
 	 * delay for some time until fewer pages are isolated
 	 */
-	while (unlikely(too_many_isolated(pgdat))) {
+	while (unlikely(too_many_isolated(cc))) {
 		/* stop isolation if there are still pages not migrated */
 		if (cc->nr_migratepages)
 			return -EAGAIN;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_isolation-write-proper-kerneldoc.patch

