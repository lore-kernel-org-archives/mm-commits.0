Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FC3C43461
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7454C6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHW4O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHW4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DA161402;
        Sat,  8 May 2021 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514511;
        bh=5CSbrLtVK1W4YggL6Bn8XUvMbJtSjgwD5aPxHyXM1So=;
        h=Date:From:To:Subject:From;
        b=HTKMAAvtdak7zT/f4/9Qt8kppQG91hERpduxEYuO2ph9vURKWaAtUH2sjKPJWRbCo
         XLwasRWOMIZpBgvyO+HiGzXJYEUq4BkHOaAg2Cgi3QBFW+xcok36rgcOD0clBeXCKo
         WVytVR01143xK9HsdwboXXgNqlGmbYFonOyJmLxE=
Date:   Sat, 08 May 2021 15:55:11 -0700
From:   akpm@linux-foundation.org
To:     dingsenjie@yulong.com, hirofumi@mail.parknet.co.jp,
        mm-commits@vger.kernel.org
Subject:  [merged] fs-fat-fix-spelling-typo-of-values.patch removed
 from -mm tree
Message-ID: <20210508225511.MgHLmNTQT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fat: fix spelling typo of values
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-spelling-typo-of-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


