Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1661C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E242603E9
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbhIBWAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347662AbhIBWAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ECEC60E8B;
        Thu,  2 Sep 2021 21:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619987;
        bh=ibNXG4X3cPjZ8K64MYawoaUhT3hELgoMNKGQWa5Vbcc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p8EPn7Cqi+eG1oueJHcaHIm+IIyLTmuNKGZP9U6vm+tTaPFdGT8/obDYVrnjhs6Y2
         L8+aD6nPhDftpARnjfowQvmfvkTLL9+l1WHl0WVyyWphk64Ubf0OJnS/QuNxwvFH10
         0GMy1XKPxaAryp+Fe/AUwXLR2v6Y1nflyAhF1WJI=
Date:   Thu, 02 Sep 2021 14:59:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, apopple@nvidia.com,
        axboe@kernel.dk, david@redhat.com, hannes@cmpxchg.org,
        hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com,
        jhubbard@nvidia.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 185/212] mm/vmscan: remove unneeded return value
 of kswapd_run()
Message-ID: <20210902215946.UBDHSxkVT%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
