Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938BEC07E9B
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A9AF60FDA
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhGTW6R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236562AbhGTWwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 18:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC89F60FDA;
        Tue, 20 Jul 2021 23:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626823959;
        bh=/z1ucn7wETVKqnzHBfBsOHIGAOyQOibmj35lTSRel+A=;
        h=Date:From:To:Subject:From;
        b=T3O6cxYnd/+EFDQfDbTo4Eo8SySSNDFigDPjGQfGRgOtZah37eA25jdnCYY9VWUSh
         xoJsXW7wMGHlKuw2HpZUojcITrKZg6wWIkpzHx2spklH4DKf0A21pRSw2McDwPw43X
         MO0qqWwcwgpay1mE6Lno63s+1g+dIcWSempkD1T8=
Date:   Tue, 20 Jul 2021 16:32:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shli@fb.com, minchan@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hillf.zj@alibaba-inc.com,
        hannes@cmpxchg.org, david@redhat.com, axboe@kernel.dk,
        apopple@nvidia.com, alexs@kernel.org, linmiaohe@huawei.com
Subject:  [to-be-updated]
 mm-vmscan-remove-misleading-setting-to-sc-priority.patch removed from -mm
 tree
Message-ID: <20210720233238.WI3Oa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove misleading setting to sc->priority
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-misleading-setting-to-sc-priority.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: remove misleading setting to sc->priority

The priority field of sc is used to control how many pages we should scan
at once while we always traverse the list to shrink the pages in these
functions.  So these settings are unneeded and misleading.

Link: https://lkml.kernel.org/r/20210710100329.49174-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-misleading-setting-to-sc-priority
+++ a/mm/vmscan.c
@@ -1702,7 +1702,6 @@ unsigned int reclaim_clean_pages_from_li
 {
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
 	struct reclaim_stat stat;
@@ -2327,7 +2326,6 @@ unsigned long reclaim_pages(struct list_
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.priority = DEF_PRIORITY,
 		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = 1,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

