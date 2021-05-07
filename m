Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48A4C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B70613C5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhEGBHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhEGBHi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6436C610CE;
        Fri,  7 May 2021 01:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349599;
        bh=TRCVN5ALzKpHRxsbUFWLL0dB5HGljLito2P50CIES5Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EAk/e+RTeb/YsBEHbypS7xSc7LilQqDDPa9O9WX2t+epECjPYmn/rLm1J+Zm4rWQG
         VjaZcJ1Gvl5A+rOfjgDsjcJd3pgejUZz6KSwnNBR8vsQG/MD2UA5G/KplRAcfFga/Q
         DvPllOGb66v4LB7X2S7JzPJ1T5UArjBbwDw1zu4o=
Date:   Thu, 06 May 2021 18:06:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dingsenjie@yulong.com,
        hirofumi@mail.parknet.co.jp, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 87/91] fs: fat: fix spelling typo of values
Message-ID: <20210507010639.bGJPvpUYq%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
