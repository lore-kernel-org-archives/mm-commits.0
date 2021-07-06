Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36536C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 18:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C0BF61C30
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 18:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhGFTBr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhGFTBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E53361C24;
        Tue,  6 Jul 2021 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625597947;
        bh=hhosdkwe3d/XVUb2cU3npRktnAOMEakUy6i8Wl2hxto=;
        h=Date:From:To:Subject:From;
        b=eMT2vN0xWUGq0VrfunCvt2uNYSgjkX8mk1EoFbYYv4Sc/fAC9oWceRfb+LEhah+k7
         E2fDlnUkCMs6ml+tMX/TRxE8sK9hA3YkcCDK0yAzSpjJxbA8VAjgncT8lb7tP6nXul
         RGeRnhBEGiXM4wsT3oqqvvMbiPj1NO6Jn8SA/6aw=
Date:   Tue, 06 Jul 2021 11:59:06 -0700
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, zhaoyang.huang@unisoc.com
Subject:  [to-be-updated]
 mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch removed from -mm
 tree
Message-ID: <20210706185906.7udJfCbGu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
has been removed from the -mm tree.  Its filename was
     mm-zram-amend-slab_reclaim_account-on-zspage_cachep.patch

This patch was dropped because an updated version will be merged

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


