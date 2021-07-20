Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6039C636C9
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 951866113A
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhGTW62 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236465AbhGTWwK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 18:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA47461178;
        Tue, 20 Jul 2021 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626823967;
        bh=MI8n3OK3QmKTFanBOZXOT2xjGG8ABKRALoMIS1s4j7Y=;
        h=Date:From:To:Subject:From;
        b=cMKjmjIvneBweo7S0DB2B5PmWHTWmaoTi4IRmpvZR8F7rEQBNdzD6EES8i06nuWAi
         dn8sXPxOqBb/I3inJ+mxV8I5W3ITQN2C3aLPzi/lFIbn2UcAb5XJJdP3qLCd3sVBLJ
         Sj2VudWwHOB0JmOkWIMM2FN1hUHjJp4MOuEmYQkM=
Date:   Tue, 20 Jul 2021 16:32:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shli@fb.com, minchan@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hillf.zj@alibaba-inc.com,
        hannes@cmpxchg.org, david@redhat.com, axboe@kernel.dk,
        apopple@nvidia.com, alexs@kernel.org, linmiaohe@huawei.com
Subject:  [to-be-updated]
 mm-vmscan-add-else-to-remove-check_pending-label.patch removed from -mm tree
Message-ID: <20210720233246.EEDsS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: add 'else' to remove check_pending label
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-else-to-remove-check_pending-label.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: add 'else' to remove check_pending label

We could add 'else' to remove the somewhat odd check_pending label to
make code core succinct.

Link: https://lkml.kernel.org/r/20210710100329.49174-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-else-to-remove-check_pending-label
+++ a/mm/vmscan.c
@@ -3434,18 +3434,14 @@ static bool throttle_direct_reclaim(gfp_
 	 * blocked waiting on the same lock. Instead, throttle for up to a
 	 * second before continuing.
 	 */
-	if (!(gfp_mask & __GFP_FS)) {
+	if (!(gfp_mask & __GFP_FS))
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
 			allow_direct_reclaim(pgdat), HZ);
+	else
+		/* Throttle until kswapd wakes the process */
+		wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
+			allow_direct_reclaim(pgdat));
 
-		goto check_pending;
-	}
-
-	/* Throttle until kswapd wakes the process */
-	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
-		allow_direct_reclaim(pgdat));
-
-check_pending:
 	if (fatal_signal_pending(current))
 		return true;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

