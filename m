Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD89FC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856BE64F29
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhBXUIv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhBXUIW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A84C464EC4;
        Wed, 24 Feb 2021 20:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197287;
        bh=aJq1EZ5tqLwxvE0hEHMV5cwVHEialTcL9lxlP2KRRHI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PoYoC1NOeuFitEuMNQmDHwLZeY4Ux6mEW3maY5AfAUk9kVdwrHpBXAZl/o6IPBfhG
         nM1ekyD+/yf4QkhG2XEGEhGPz6hd0b76+q2iFpJT6dxImWUX6URRBjBEfz5YYAse9+
         OM/mAXzrIomKFgPTOaI1ZJmKnSOpP4OZJ/kR3df0=
Date:   Wed, 24 Feb 2021 12:08:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 134/173] mm/workingset.c: avoid unnecessary
 max_nodes estimation in count_shadow_nodes()
Message-ID: <20210224200806.DDlsnNZ0R%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
