Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70031C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480092054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196142;
	bh=I/wcnFnwKAE3/ZWJhjXtXqGIC5A2UyJl44Wvpl2PVs8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iMxBvbMJImL40x0TEJNasnw1B/o9QYVYhAluDdtjVQZeQHLiZKP16IIF1Cq7C5FkK
	 JI/ZwllfNbcF2P2urhFZPKipi7yX3RXiwYaZHml7gZedDpmO+hhtIgzi2i7WBCuZMd
	 o/TYEiv8zfbNpV8/VSzpu1UIuAE46lqc/bnmGR8s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB5720678;
        Wed, 12 Aug 2020 01:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196141;
        bh=I/wcnFnwKAE3/ZWJhjXtXqGIC5A2UyJl44Wvpl2PVs8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BfOYnnXlJq5hG+ZEtq+HagUT5emrPCQ3S5lDEcVaCOcTKHt6M/IKceKMjknb2kvSq
         NEuauDaBT630NK8mue+Igoj5VRWrr2dAHn54MK/vdpSgC641/0RwnsG3zmBN6IVP1p
         2OLgpO7UAoRjR3joxL/NGubwpgY0v5dkkoLbRaOY=
Date:   Tue, 11 Aug 2020 18:35:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anenbupt@gmail.com, ebiggers@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 103/165] fs/minix: remove expected error message
 in block_to_path()
Message-ID: <20200812013539.1vNyK000i%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: remove expected error message in block_to_path()

When truncating a file to a size within the last allowed logical block,
block_to_path() is called with the *next* block.  This exceeds the limit,
causing the "block %ld too big" error message to be printed.

This case isn't actually an error; there are just no more blocks past that
point.  So, remove this error message.

Link: http://lkml.kernel.org/r/20200628060846.682158-7-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_v1.c |   12 ++++++------
 fs/minix/itree_v2.c |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/fs/minix/itree_v1.c~fs-minix-remove-expected-error-message-in-block_to_path
+++ a/fs/minix/itree_v1.c
@@ -29,12 +29,12 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if ((u64)block * BLOCK_SIZE >= inode->i_sb->s_maxbytes) {
-		if (printk_ratelimit())
-			printk("MINIX-fs: block_to_path: "
-			       "block %ld too big on dev %pg\n",
-				block, inode->i_sb->s_bdev);
-	} else if (block < 7) {
+		return 0;
+	}
+	if ((u64)block * BLOCK_SIZE >= inode->i_sb->s_maxbytes)
+		return 0;
+
+	if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
 		offsets[n++] = 7;
--- a/fs/minix/itree_v2.c~fs-minix-remove-expected-error-message-in-block_to_path
+++ a/fs/minix/itree_v2.c
@@ -32,12 +32,12 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, sb->s_bdev);
-	} else if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes) {
-		if (printk_ratelimit())
-			printk("MINIX-fs: block_to_path: "
-			       "block %ld too big on dev %pg\n",
-				block, sb->s_bdev);
-	} else if (block < DIRCOUNT) {
+		return 0;
+	}
+	if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes)
+		return 0;
+
+	if (block < DIRCOUNT) {
 		offsets[n++] = block;
 	} else if ((block -= DIRCOUNT) < INDIRCOUNT(sb)) {
 		offsets[n++] = DIRCOUNT;
_
