Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D31C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A52B9223E4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgLODGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgLODGY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:24 -0500
Date:   Mon, 14 Dec 2020 19:06:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001568;
        bh=F0IK7jgO1zH/6GgnmtBJIQXkmoAuXswLFDJwEQOcH/M=;
        h=From:To:Subject:In-Reply-To:From;
        b=QUpqiJYjemfFMCLrMew74PwroSXIO1V0D9jjcR14mz2ariuDqAoRz5zrXvLp+5wAh
         gkqeDoMy6Y1Zv00Z0uiAX7KfpeB4SlehupSzK8PBmeNJvmLpsPm0HwfWSvRR85Hm1L
         D0LYCBss366zMYHkNRXi9QHenOlzYU2CTBFN6R9I=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 051/200] mm/swapfile.c: use memset to fill the
 swap_map with SWAP_HAS_CACHE
Message-ID: <20201215030607.0S-Q7Gh_e%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
