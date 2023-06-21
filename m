Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01959EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 22:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjFUWBq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 18:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjFUWBp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 18:01:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A46ADE
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 15:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912B2616E4
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 22:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91DAC433C8;
        Wed, 21 Jun 2023 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687384903;
        bh=c+3YNZi5/mgH1EldTGVoC/oh2wI0hPDNtOwFDGA89A4=;
        h=Date:To:From:Subject:From;
        b=A2QEB4GN1R5dxFnKzxMViTVZ1jpE0CGuecqnsjRtIwFv/5Q91luIeDsrL17ug0500
         BdQkODsWwDnjFXspgl9UuW/XmKPtI7acMPb0OywpkOc94nJZRhX4sdbgqEB0MfYQpE
         CzivUwdsnOxvhI+NeKAUvh3qRzVYg2cHvSt5Q0ys=
Date:   Wed, 21 Jun 2023 15:01:42 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.patch added to mm-unstable branch
Message-Id: <20230621220142.E91DAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix root proactive reclaim unthrottling unbalanced node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm/vmscan: fix root proactive reclaim unthrottling unbalanced node
Date: Wed, 21 Jun 2023 02:31:01 +0000

When memory.reclaim was introduced, it became the first case where
cgroup_reclaim() is true for the root cgroup.  Johannes concluded [1] that
for most cases this is okay, except for one case.  Historically, kswapd
would throttle reclaim on a node if a lot of pages marked for reclaim are
under writeback (aka the node is congested).  This occurred by setting
LRUVEC_CONGESTED bit in lruvec->flags.  The bit would be cleared when the
node is balanced.

Similarly, cgroup reclaim would set the same bit when an lruvec is
congested, and clear it on the way out of reclaim (to throttle local
reclaimers).

Before the introduction of memory.reclaim, the root memcg was the only
target of kswapd reclaim, and non-root memcgs were the only targets of
cgroup reclaim, so they would never interfere.  Using the same bit for
both was fine.  After memory.reclaim, it is possible for cgroup reclaim on
the root cgroup to clear the bit set by kswapd.  This would result in
reclaim on the node to be unthrottled before the node is balanced.

Fix this by introducing separate bits for cgroup-level and node-level
congestion.  kswapd can unthrottle an lruvec that is marked as congested
by cgroup reclaim (as the entire node should no longer be congested), but
not vice versa (to prevent premature unthrottling before the entire node
is balanced).

[1]https://lore.kernel.org/lkml/20230405200150.GA35884@cmpxchg.org/

Link: https://lkml.kernel.org/r/20230621023101.432780-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Closes: https://lore.kernel.org/lkml/20230405200150.GA35884@cmpxchg.org/
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   18 +++++++++++++++---
 mm/vmscan.c            |   19 ++++++++++++-------
 2 files changed, 27 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node
+++ a/include/linux/mmzone.h
@@ -293,9 +293,21 @@ static inline bool is_active_lru(enum lr
 #define ANON_AND_FILE 2
 
 enum lruvec_flags {
-	LRUVEC_CONGESTED,		/* lruvec has many dirty pages
-					 * backed by a congested BDI
-					 */
+	/*
+	 * An lruvec has many dirty pages backed by a congested BDI:
+	 * 1. LRUVEC_CGROUP_CONGESTED is set by cgroup-level reclaim.
+	 *    It can be cleared by cgroup reclaim or kswapd.
+	 * 2. LRUVEC_NODE_CONGESTED is set by kswapd node-level reclaim.
+	 *    It can only be cleared by kswapd.
+	 *
+	 * Essentially, kswapd can unthrottle an lruvec throttled by cgroup
+	 * reclaim, but not vice versa. This only applies to the root cgroup.
+	 * The goal is to prevent cgroup reclaim on the root cgroup (e.g.
+	 * memory.reclaim) to unthrottle an unbalanced node (that was throttled
+	 * by kswapd).
+	 */
+	LRUVEC_CGROUP_CONGESTED,
+	LRUVEC_NODE_CONGESTED,
 };
 
 #endif /* !__GENERATING_BOUNDS_H */
--- a/mm/vmscan.c~mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node
+++ a/mm/vmscan.c
@@ -6578,10 +6578,13 @@ again:
 	 * Legacy memcg will stall in page writeback so avoid forcibly
 	 * stalling in reclaim_throttle().
 	 */
-	if ((current_is_kswapd() ||
-	     (cgroup_reclaim(sc) && writeback_throttling_sane(sc))) &&
-	    sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
-		set_bit(LRUVEC_CONGESTED, &target_lruvec->flags);
+	if (sc->nr.dirty && sc->nr.dirty == sc->nr.congested) {
+		if (cgroup_reclaim(sc) && writeback_throttling_sane(sc))
+			set_bit(LRUVEC_CGROUP_CONGESTED, &target_lruvec->flags);
+
+		if (current_is_kswapd())
+			set_bit(LRUVEC_NODE_CONGESTED, &target_lruvec->flags);
+	}
 
 	/*
 	 * Stall direct reclaim for IO completions if the lruvec is
@@ -6591,7 +6594,8 @@ again:
 	 */
 	if (!current_is_kswapd() && current_may_throttle() &&
 	    !sc->hibernation_mode &&
-	    test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
+	    (test_bit(LRUVEC_CGROUP_CONGESTED, &target_lruvec->flags) ||
+	     test_bit(LRUVEC_NODE_CONGESTED, &target_lruvec->flags)))
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_CONGESTED);
 
 	if (should_continue_reclaim(pgdat, nr_node_reclaimed, sc))
@@ -6848,7 +6852,7 @@ retry:
 
 			lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup,
 						   zone->zone_pgdat);
-			clear_bit(LRUVEC_CONGESTED, &lruvec->flags);
+			clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
 		}
 	}
 
@@ -7237,7 +7241,8 @@ static void clear_pgdat_congested(pg_dat
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(NULL, pgdat);
 
-	clear_bit(LRUVEC_CONGESTED, &lruvec->flags);
+	clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
+	clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
 	clear_bit(PGDAT_DIRTY, &pgdat->flags);
 	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
 }
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-fix-double-invalidate-with-exclusive-loads.patch
mm-memcg-rename-and-document-global_reclaim.patch
mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.patch

