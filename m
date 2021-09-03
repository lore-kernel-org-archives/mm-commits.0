Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DADC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691576113C
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhICVB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350495AbhICVBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1FD96112E;
        Fri,  3 Sep 2021 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702855;
        bh=IHkozLM/KB2hMu0GRaEboWWi6I9n0ajF4LpBgziwREM=;
        h=Date:From:To:Subject:From;
        b=D/XK6RfL/iHc5WwrEXUueMPwTVkrVJz4p3qtU4dcM5A0gqWuQS8zEYJhsnuZ6r6Rz
         wzhCKfh86BbavuGT4fu7vaDGmDumWUQeunXnY7MEyOC/LLTudbhPAphTuTuMAruG9d
         yY8DAWryfMOOc15VH5QhNEv1eePpsydz2YcGeuEo=
Date:   Fri, 03 Sep 2021 14:00:54 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com,
        iamjoonsoo.kim@lge.com, jhubbard@nvidia.com, linmiaohe@huawei.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Subject:  [merged]
 mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch removed from -mm
 tree
Message-ID: <20210903210054.ZCxY9zBaG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove unneeded return value of kswapd_run()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: remove unneeded return value of kswapd_run()

The return value of kswapd_run() is unused now.  Clean it up.

Link: https://lkml.kernel.org/r/20210717065911.61497-4-linmiaohe@huawei.com
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
@@ -4434,23 +4434,20 @@ unsigned long shrink_all_memory(unsigned
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

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

