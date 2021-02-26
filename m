Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843CBC4332D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5417364F31
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBZBTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhBZBTJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C95864F2A;
        Fri, 26 Feb 2021 01:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302308;
        bh=zJm/az4E8zhKXSiZIGNS7tBOz++iUq2+/WgdUcRzM+8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j1ikO439BaIYCQhHy29Va7NilcEEd5Kg0kAylso9p4qOjgxtreU+4LdWQnp2yR8Ja
         D9HSTUl/UAkDSv7muuQlv1rkEZqnfCxdrxujfbc2cnPM2Og47y3lzHGvZnQDmoZiTF
         yY8s8HOuVB2d/N0K7PhouH6GLofq7E5PRPP9trOM=
Date:   Thu, 25 Feb 2021 17:18:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 049/118] mm/zsmalloc.c: convert to use
 kmem_cache_zalloc in cache_alloc_zspage()
Message-ID: <20210226011827.KJ4Kj9OOr%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: convert to use kmem_cache_zalloc in cache_alloc_zspage()

We always memset the zspage allocated via cache_alloc_zspage.  So it's
more convenient to use kmem_cache_zalloc in cache_alloc_zspage than caller
do it manually.

Link: https://lkml.kernel.org/r/20210114120032.25885-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage
+++ a/mm/zsmalloc.c
@@ -357,7 +357,7 @@ static void cache_free_handle(struct zs_
 
 static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
 {
-	return kmem_cache_alloc(pool->zspage_cachep,
+	return kmem_cache_zalloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 }
 
@@ -1064,7 +1064,6 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
-	memset(zspage, 0, sizeof(struct zspage));
 	zspage->magic = ZSPAGE_MAGIC;
 	migrate_lock_init(zspage);
 
_
