Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD839C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjESVlq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjESVlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3086A1B3
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B97C364393
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21102C433D2;
        Fri, 19 May 2023 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532503;
        bh=QLb7eSWzs8p5HnvpsB/ePguaRe1zYgdzvp7UQaZyJWk=;
        h=Date:To:From:Subject:From;
        b=f/IO2EdWfynf73qRiv7kxS8r3D6Knql6i4QJAAs6QqNoEYH+7mWKnzBPfnhIL0psx
         JJCXnoGNokmZD63hX2B766FBzf/Y0T/khC3mR2JK0RynYdH88Q2aCx7rZf8Fv8NZr+
         xflZoCrMMqTBMEFNnn7yRIcM9Ao9U0sav8XWjpHY=
Date:   Fri, 19 May 2023 14:41:42 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-avoid-gfp_nofs-abba-deadlock.patch added to mm-unstable branch
Message-Id: <20230519214143.21102C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: avoid GFP_NOFS ABBA deadlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-avoid-gfp_nofs-abba-deadlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-avoid-gfp_nofs-abba-deadlock.patch

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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -829,7 +841,7 @@ isolate_migratepages_block(struct compac
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

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch
mm-page_isolation-write-proper-kerneldoc.patch
mm-compaction-avoid-gfp_nofs-abba-deadlock.patch

