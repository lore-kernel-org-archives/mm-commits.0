Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7685BC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6287A61468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbhGABz3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC51161241;
        Thu,  1 Jul 2021 01:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104379;
        bh=3mmcgWfzdxHM+eG6w1Er59n7ndos17yQennCj2C0N1s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zyZStW2v4TgpiRsaqRlyCmfeuxnVtbMLGjMDMNj9w3aljI3q97jEc82/fXWb0eN9D
         85MPGqp0Mh9VpOTVvGAImoZi8hPduDA/Adce95vfui7LQ9gfXkUsP4XjwzFNJPRCae
         iMHlMhK9siJaA4hMbG+74/HU88N+KI1qUvqg9dFo=
Date:   Wed, 30 Jun 2021 18:52:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        torvalds@linux-foundation.org, zhaoyang.huang@unisoc.com
Subject:  [patch 108/192] mm: zram: amend SLAB_RECLAIM_ACCOUNT on
 zspage_cachep
Message-ID: <20210701015258.BrxjIzdE1%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep

Zspage_cachep is found be merged with other kmem cache during test, which
is not good for debug things (zs_pool->zspage_cachep present to be another
kmem cache in memory dumpfile).  It is also neccessary to do so as
shrinker has been registered for zspage.

Amending this flag can help kernel to calculate SLAB_RECLAIMBLE correctly.

Link: https://lkml.kernel.org/r/1623137297-29685-1-git-send-email-huangzhaoyang@gmail.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zram-amend-slab_reclaim_account-on-zspage_cachep
+++ a/mm/zsmalloc.c
@@ -328,7 +328,7 @@ static int create_cache(struct zs_pool *
 		return 1;
 
 	pool->zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
-					0, 0, NULL);
+					0, SLAB_RECLAIM_ACCOUNT, NULL);
 	if (!pool->zspage_cachep) {
 		kmem_cache_destroy(pool->handle_cachep);
 		pool->handle_cachep = NULL;
_
