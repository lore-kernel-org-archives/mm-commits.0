Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5EDC48BD1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55531613C1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhFKANo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhFKANo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 20:13:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF53613CF;
        Fri, 11 Jun 2021 00:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623370290;
        bh=9hHlbFj5On1zsfk+TRDFiQzgVYWi01NcggAZqhwxGPo=;
        h=Date:From:To:Subject:From;
        b=ZOCicc+6wetwGib+S3NYBwXNEocTsEEDUivq3D8pUq5HIMzqoH7asA1rOwBwaCgLU
         WYSJT25LxqnMAzXdHsVzE83Hq47bFdWWOcbWfgfYiDfsoqUHYooqSsyD/fYz4T2sSy
         hu8Fo0UuS/gFmS9E6Xo/EVi/Denzv0IKyFAAtTJ0=
Date:   Thu, 10 Jun 2021 17:11:30 -0700
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, zhaoyang.huang@unisoc.com
Subject:  +
 mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch added to -mm tree
Message-ID: <20210611001130.yCa_bxYG0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
has been added to the -mm tree.  Its filename is
     mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch

