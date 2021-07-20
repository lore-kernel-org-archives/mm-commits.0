Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB91C636C8
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 888B8610F7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhGTW6V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236110AbhGTWwH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 18:52:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E846113B;
        Tue, 20 Jul 2021 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626823963;
        bh=g4Nk5jmt++j+WNauU7284Gq7RD99UCGhaip2jWzjHeA=;
        h=Date:From:To:Subject:From;
        b=L2FnhYwuAaXeIj07Y7LdBFlfCxeJodZ/ixn1xnfR0FgMVh7KRwqEVeFy/fcQs82M/
         g537T5mgRwUTis+v+HxouQxwm5dAJml52bzasyE5KIefh0Gr+fTEO2/3BgWCApKycw
         eFY4xZwQoTgNoiORx1zz5lPpovZpn+eNuUksWj+M=
Date:   Tue, 20 Jul 2021 16:32:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shli@fb.com, minchan@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hillf.zj@alibaba-inc.com,
        hannes@cmpxchg.org, david@redhat.com, axboe@kernel.dk,
        apopple@nvidia.com, alexs@kernel.org, linmiaohe@huawei.com
Subject:  [to-be-updated]
 mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch removed from -mm
 tree
Message-ID: <20210720233242.JNYTM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove unneeded return value of kswapd_run()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: remove unneeded return value of kswapd_run()

The return value of kswapd_run() is unused now. Clean it up.

Link: https://lkml.kernel.org/r/20210710100329.49174-4-linmiaohe@huawei.com
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

 include/linux/swap.h |    2 +-
 mm/vmscan.c          |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-remove-unneeded-return-value-of-kswapd_run
+++ a/include/linux/swap.h
@@ -408,7 +408,7 @@ static inline bool node_reclaim_enabled(
 
 extern void check_move_unevictable_pages(struct pagevec *pvec);
 
-extern int kswapd_run(int nid);
+extern void kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
--- a/mm/vmscan.c~mm-vmscan-remove-unneeded-return-value-of-kswapd_run
+++ a/mm/vmscan.c
@@ -4290,23 +4290,20 @@ unsigned long shrink_all_memory(unsigned
  * This kswapd start function will be called by init and node-hot-add.
  * On node-hot-add, kswapd will moved to proper cpus if cpus are hot-added.
  */
-int kswapd_run(int nid)
+void kswapd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	int ret = 0;
 
 	if (pgdat->kswapd)
-		return 0;
+		return;
 
 	pgdat->kswapd = kthread_run(kswapd, pgdat, "kswapd%d", nid);
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state < SYSTEM_RUNNING);
 		pr_err("Failed to start kswapd on node %d\n", nid);
-		ret = PTR_ERR(pgdat->kswapd);
 		pgdat->kswapd = NULL;
 	}
-	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

