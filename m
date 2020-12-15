Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B847C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7371622DD6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgLPAAP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728246AbgLOX1P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:15 -0500
Date:   Tue, 15 Dec 2020 15:17:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074273;
        bh=nuHWU1m0+KuPS8Xj0HZjytbcVknR42bnhX1MPbEJi/s=;
        h=From:To:Subject:From;
        b=dIPTfDJz1xqzTUBTDWvAmdfzU+gYATywwocZbOY6jwyCNU/Z0gkZlALt6XCIotGPz
         R+64jmGwacLjcZMhoMvkX2WTUWwaM3gptP04PEVluSJWQ6TpvxbZBxv2Xo612CaI2a
         +Qe8MVBFi1VkK+TqheiCig5hEfj7SiZEMPfUB7lY=
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-swap-use-memset-to-fill-the-swap_map-with-swap_has_cache.patch removed
 from -mm tree
Message-ID: <20201215231753.FPRQMk4dw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use memset to fill the swap_map with SWAP_HAS_CACHE
has been removed from the -mm tree.  Its filename was
     mm-swap-use-memset-to-fill-the-swap_map-with-swap_has_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: use memset to fill the swap_map with SWAP_HAS_CACHE

We could use helper memset to fill the swap_map with SWAP_HAS_CACHE instead
of a direct loop here to simplify the code. Also we can remove the local
variable i and map this way.

Link: https://lkml.kernel.org/r/20200921122224.7139-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-memset-to-fill-the-swap_map-with-swap_has_cache
+++ a/mm/swapfile.c
@@ -975,8 +975,7 @@ static int swap_alloc_cluster(struct swa
 {
 	unsigned long idx;
 	struct swap_cluster_info *ci;
-	unsigned long offset, i;
-	unsigned char *map;
+	unsigned long offset;
 
 	/*
 	 * Should not even be attempting cluster allocations when huge
@@ -996,9 +995,7 @@ static int swap_alloc_cluster(struct swa
 	alloc_cluster(si, idx);
 	cluster_set_count_flag(ci, SWAPFILE_CLUSTER, CLUSTER_FLAG_HUGE);
 
-	map = si->swap_map + offset;
-	for (i = 0; i < SWAPFILE_CLUSTER; i++)
-		map[i] = SWAP_HAS_CACHE;
+	memset(si->swap_map + offset, SWAP_HAS_CACHE, SWAPFILE_CLUSTER);
 	unlock_cluster(ci);
 	swap_range_alloc(si, offset, SWAPFILE_CLUSTER);
 	*slot = swp_entry(si->type, offset);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


