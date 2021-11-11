Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0579AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E380761075
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhKKC4r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234621AbhKKC4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D296103C;
        Thu, 11 Nov 2021 02:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599238;
        bh=Nex4hrYuym2E5+z/r2ZM95t4E3L3AZrHS3xJ+KF26iI=;
        h=Date:From:To:Subject:From;
        b=YQzNXpcZLBM/0ynHC6dBxaeTHxRNiJ68x+RtDI45rd2ALVgvCy8GP+7RMcoHjHLQG
         VWvhtzXTCDTumFmbBhmf3pzlS35z+XA13WIJQiURXipugPwBU03cM7KK4Gcv1EdP2d
         +XhMvY6ihDSPyfT03ZdW+b0LnR/Ogjodl3b7nRUI=
Date:   Wed, 10 Nov 2021 18:53:58 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, paskripkin@gmail.com
Subject:  [merged]
 sysv-use-build_bug_on-instead-of-runtime-check.patch removed from -mm tree
Message-ID: <20211111025358.dPKVXbxMd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysv: use BUILD_BUG_ON instead of runtime check
has been removed from the -mm tree.  Its filename was
     sysv-use-build_bug_on-instead-of-runtime-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from paskripkin@gmail.com are


