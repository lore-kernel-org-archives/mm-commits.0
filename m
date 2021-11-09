Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A93CC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2348961406
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhKICiL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237743AbhKICiK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E5F3613B3;
        Tue,  9 Nov 2021 02:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425325;
        bh=zAvUZDHqDZu2YjDQJxNNXTrvx08br2IQ9kCYUIG1im4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=frggdGhRnxfR2596CJtwWorCNvKDID69VG6HAIdTSzmk2GZlAf47sGx+f1clpFhPq
         lZlwrVMhgBZr61So4Ziyu/eJoFlLrhYGzTnxVeq8Ya9/SMAlWf15NSmbb4k/fM4HVT
         +/yR51igCkE4PG76i7P5ax5TbA/zVtNEHUO4/1ds=
Date:   Mon, 08 Nov 2021 18:35:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, paskripkin@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 75/87] sysv: use BUILD_BUG_ON instead of runtime
 check
Message-ID: <20211109023525.rzIFUModX%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>
Subject: sysv: use BUILD_BUG_ON instead of runtime check

There were runtime checks about sizes of struct v7_super_block and struct
sysv_inode.  If one of these checks fail the kernel will panic.  Since
these values are known at compile time let's use BUILD_BUG_ON(), because
it's a standard mechanism for validation checking at build time

Link: https://lkml.kernel.org/r/20210813123020.22971-1-paskripkin@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/sysv/super.c~sysv-use-build_bug_on-instead-of-runtime-check
+++ a/fs/sysv/super.c
@@ -474,10 +474,8 @@ static int v7_fill_super(struct super_bl
 	struct sysv_sb_info *sbi;
 	struct buffer_head *bh;
 
-	if (440 != sizeof (struct v7_super_block))
-		panic("V7 FS: bad super-block size");
-	if (64 != sizeof (struct sysv_inode))
-		panic("sysv fs: bad i-node size");
+	BUILD_BUG_ON(sizeof(struct v7_super_block) != 440);
+	BUILD_BUG_ON(sizeof(struct sysv_inode) != 64);
 
 	sbi = kzalloc(sizeof(struct sysv_sb_info), GFP_KERNEL);
 	if (!sbi)
_
