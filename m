Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5039C43219
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CAC76113C
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbhICVB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350515AbhICVB5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2EB9610FB;
        Fri,  3 Sep 2021 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702857;
        bh=SFtZZV/NzM6nhmr15ESi+5ii/5cLDSmhKnQ/Ce+019E=;
        h=Date:From:To:Subject:From;
        b=AEnUxCSTCN7FgPELr/wc5KYL/hrOUKahr/n5Ufyq0BhNQLIkkZNEMLPwosD+KuJmZ
         hA0OeXdAjursGmtjjYjfwNHusy6Q8d2V3rZMf0Sw4XKVR6sS7OtviEEWc92lw6ToHw
         6Lq5IWcV6abtnhOnedivJ3d/7brans/AfIr7L4Y8=
Date:   Fri, 03 Sep 2021 14:00:56 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com,
        iamjoonsoo.kim@lge.com, jhubbard@nvidia.com, linmiaohe@huawei.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Subject:  [merged]
 mm-vmscan-add-else-to-remove-check_pending-label.patch removed from -mm
 tree
Message-ID: <20210903210056.MnpJ7RqeU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: add 'else' to remove check_pending label
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-else-to-remove-check_pending-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: add 'else' to remove check_pending label

We could add 'else' to remove the somewhat odd check_pending label to make
code core succinct.

Link: https://lkml.kernel.org/r/20210717065911.61497-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-else-to-remove-check_pending-label
+++ a/mm/vmscan.c
@@ -3578,18 +3578,14 @@ static bool throttle_direct_reclaim(gfp_
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

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

