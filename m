Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5681C43381
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C64564F43
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCBXfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhCBXeQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:34:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E550B6186A;
        Tue,  2 Mar 2021 23:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728016;
        bh=iGHOxXfoTgfZh4pejgDy50yToXzLVoeVj8XN0a+boYA=;
        h=Date:From:To:Subject:From;
        b=QRPTLdqXa6/3JFVHVOmQcYdHE8E4LAo9N1tHS2o3HSYeu4yPLtE9kKcGWI+9Q6tq0
         9CmiikuP0bGUYEJgtVDbkYXNJOo9ItG6R4hG46wuiPEtMwZJXLhBCLVMWwtJyFRElp
         Tg6ivo/wgkwFDKX/lYKNweawq6Xq8vwatVCqMX9g=
Date:   Tue, 02 Mar 2021 15:33:35 -0800
From:   akpm@linux-foundation.org
To:     dingsenjie@yulong.com, hirofumi@mail.parknet.co.jp,
        mm-commits@vger.kernel.org
Subject:  + fs-fat-fix-spelling-typo-of-values.patch added to -mm
 tree
Message-ID: <20210302233335.Rzto6xmrB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fat: fix spelling typo of values
has been added to the -mm tree.  Its filename is
     fs-fat-fix-spelling-typo-of-values.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-fat-fix-spelling-typo-of-values.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-fix-spelling-typo-of-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: dingsenjie <dingsenjie@yulong.com>
Subject: fs: fat: fix spelling typo of values

vaules -> values

Link: https://lkml.kernel.org/r/20210302034817.30384-1-dingsenjie@163.com
Signed-off-by: dingsenjie <dingsenjie@yulong.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/fatent.c~fs-fat-fix-spelling-typo-of-values
+++ a/fs/fat/fatent.c
@@ -771,7 +771,7 @@ int fat_trim_fs(struct inode *inode, str
 	/*
 	 * FAT data is organized as clusters, trim at the granulary of cluster.
 	 *
-	 * fstrim_range is in byte, convert vaules to cluster index.
+	 * fstrim_range is in byte, convert values to cluster index.
 	 * Treat sectors before data region as all used, not to trim them.
 	 */
 	ent_start = max_t(u64, range->start>>sbi->cluster_bits, FAT_START_ENT);
_

Patches currently in -mm which might be from dingsenjie@yulong.com are

fs-fat-fix-spelling-typo-of-values.patch

