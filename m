Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6102C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54F764F2A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhBYTdl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234693AbhBYTad (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABE4C64FA5;
        Thu, 25 Feb 2021 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280656;
        bh=vr1XLHbUWy1RTMsVD9wDHHsolMceVJjhZKMcDoAt1/g=;
        h=Date:From:To:Subject:From;
        b=JYDJBevTK+ubYpr/jdd/7tO8JQ7ZWzmJXA/GNd8PxgRxMdDz9rifUMHLNnZj7clRR
         I6ZzsDSRCwUSl2F+kBD88p/33I8saWhUieZviX05TjPZWSAwjt9dxYG0sConU4GHYF
         xBFu0vjPsbMI7WLboZQ7oQNsdpoeiPZlJgfmpq4w=
Date:   Thu, 25 Feb 2021 11:17:36 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-workingsetc-avoid-unnecessary-max=5Fnodes-estimation-in-?=
 =?US-ASCII?Q?count=5Fshadow=5Fnodes.patch?= removed from -mm tree
Message-ID: <20210225191736.wX9ElGHgC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset.c: avoid unnecessary max_nodes estimation in count_shadow_nodes()
has been removed from the -mm tree.  Its filename was
     mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/workingset.c: avoid unnecessary max_nodes estimation in count_shadow_nodes()

If list_lru_shrink_count is 0, we always return SHRINK_EMPTY regardless of
the value of max_nodes.  So we can return early if nodes == 0 to save some
cpu cycles of approximating a reasonable limit for the nodes.

Link: https://lkml.kernel.org/r/20210123073825.46709-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/workingset.c~mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes
+++ a/mm/workingset.c
@@ -461,6 +461,8 @@ static unsigned long count_shadow_nodes(
 	unsigned long pages;
 
 	nodes = list_lru_shrink_count(&shadow_nodes, sc);
+	if (!nodes)
+		return SHRINK_EMPTY;
 
 	/*
 	 * Approximate a reasonable limit for the nodes
@@ -503,9 +505,6 @@ static unsigned long count_shadow_nodes(
 
 	max_nodes = pages >> (XA_CHUNK_SHIFT - 3);
 
-	if (!nodes)
-		return SHRINK_EMPTY;
-
 	if (nodes <= max_nodes)
 		return 0;
 	return nodes - max_nodes;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

