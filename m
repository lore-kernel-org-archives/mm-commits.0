Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ECEC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8860E207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266287;
	bh=ocHCd2JYmPC/WaEsfjmn3pF/V9C0LyMZ5eLJjQuldHA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dXYg2tRo/RZqUCsolEuz4NDv6juXl0TnNuksIKNhKHpbgoNmB3NGGPPyLSz2Ph8Zo
	 Etnn6R1Z6jmygN9gYnK4uChkRFkdlorrLsRCkCCeiplX8+usQA+CN9yziUSuFY02IT
	 AvgQqdp0FbmCt9u51Cb0uO3nuo6MIqen2pBQHR1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLVEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgHLVEr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BDC720774;
        Wed, 12 Aug 2020 21:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266286;
        bh=ocHCd2JYmPC/WaEsfjmn3pF/V9C0LyMZ5eLJjQuldHA=;
        h=Date:From:To:Subject:From;
        b=IIWJFSAumtjhjsZE8L2qZi1QYu1iJ7PIl5Q/5bLom4gL8iAtm1a8L5KpEVz1B8krL
         uXnxZ0RIZuT6XK2WyJxeCt5aKUXnYb9E5P+YAoZ6wq2EGFkCFxFogXmO3v8MDWHsmb
         FR1Cm2aog4eIPUGTYzI2JjxPv7ArnrL6p8wATRkY=
Date:   Wed, 12 Aug 2020 14:04:46 -0700
From:   akpm@linux-foundation.org
To:     anenbupt@gmail.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-minix-remove-expected-error-message-in-block_to_path.patch removed from
 -mm tree
Message-ID: <20200812210446._7NDcLEz1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/minix: remove expected error message in block_to_path()
has been removed from the -mm tree.  Its filename was
     fs-minix-remove-expected-error-message-in-block_to_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ebiggers@google.com are


