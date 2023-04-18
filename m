Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015D2C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjDRXhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjDRXfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92BC8A55
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AACAB63A0B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F4BC433EF;
        Tue, 18 Apr 2023 23:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860908;
        bh=a1ICUkw6p+C4TSF2sXj9AwX9rC/ho5Yz3paa7mLBhZE=;
        h=Date:To:From:Subject:From;
        b=0Oby6gX03fXRYuiNzewM+NRSI/lRpLZc2dofDzg44zO2LgtzO2NrBmYF615sUNBTX
         9aaAOckhwXkrdg6NUGtgOhk7js/5Sp5zlowNFvpMSmAy/z3gkKsnE5t5IsbyYs1usd
         clEL7Wu/3lJMp4jP+U5lSLxPvIr8j6eDrIDVOkeg=
Date:   Tue, 18 Apr 2023 16:35:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-simplify-shrink_node.patch removed from -mm tree
Message-Id: <20230418233508.09F4BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: simplify shrink_node()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-simplify-shrink_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/vmscan: simplify shrink_node()
Date: Tue, 11 Apr 2023 06:17:57 +0000

The difference between sc->nr_reclaimed and nr_reclaimed is computed three
times.  Introduce a new variable to record the value, so it only needs to
be computed once.

Link: https://lkml.kernel.org/r/20230411061757.12041-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-shrink_node
+++ a/mm/vmscan.c
@@ -6463,7 +6463,7 @@ static void shrink_node_memcgs(pg_data_t
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
-	unsigned long nr_reclaimed, nr_scanned;
+	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
@@ -6489,13 +6489,14 @@ again:
 		reclaim_state->reclaimed_slab = 0;
 	}
 
+	nr_node_reclaimed = sc->nr_reclaimed - nr_reclaimed;
+
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
-			   sc->nr_scanned - nr_scanned,
-			   sc->nr_reclaimed - nr_reclaimed);
+			   sc->nr_scanned - nr_scanned, nr_node_reclaimed);
 
-	if (sc->nr_reclaimed - nr_reclaimed)
+	if (nr_node_reclaimed)
 		reclaimable = true;
 
 	if (current_is_kswapd()) {
@@ -6557,8 +6558,7 @@ again:
 	    test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_CONGESTED);
 
-	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
-				    sc))
+	if (should_continue_reclaim(pgdat, nr_node_reclaimed, sc))
 		goto again;
 
 	/*
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

cpuset-clean-up-cpuset_node_allowed.patch

