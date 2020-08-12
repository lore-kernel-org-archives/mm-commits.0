Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5467C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A2B320774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266284;
	bh=A/CouTuOseYC7K1khAOEAa9R/Sz/MynbjT3/yskf9j4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tPnslKLddHrtGWYGuDIg7VGQc8bUO5gQoT0Clmq2z8yDRgCCvP4AGb6+EcXumMsAa
	 a17ReKcdttP/mbBxP7J6QeQzf63ZqHLBl7sdgIIW6h/121kyzwfTeM7mSMOaqEt/lE
	 DAf21d43u4eq68gnM6vF2oj7RGMHumFhAoCPUPsk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLVEo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLVEo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9337A2078B;
        Wed, 12 Aug 2020 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266283;
        bh=A/CouTuOseYC7K1khAOEAa9R/Sz/MynbjT3/yskf9j4=;
        h=Date:From:To:Subject:From;
        b=Z2VyG2weXqF7YonlNPdi7zXwuee4Qq8+9xVfGutO2ZqW8yRhgFP5jvabMeDcvmzd9
         CwtE+G/CYkquZeBTPya3zspNnc/j4Bz4IEFmhx4ZAhbYrnjfTsZvzkFPkjuGmI1VRF
         IXFIREp4Pzej229TbSbRkIulxdRPUbOlja93aSso=
Date:   Wed, 12 Aug 2020 14:04:43 -0700
From:   akpm@linux-foundation.org
To:     anenbupt@gmail.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-minix-fix-block-limit-check-for-v1-filesystems.patch removed from -mm
 tree
Message-ID: <20200812210443.RMuC_8fqi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/minix: fix block limit check for V1 filesystems
has been removed from the -mm tree.  Its filename was
     fs-minix-fix-block-limit-check-for-v1-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: fix block limit check for V1 filesystems

The minix filesystem reads its maximum file size from its on-disk
superblock.  This value isn't necessarily a multiple of the block size. 
When it's not, the V1 block mapping code doesn't allow mapping the last
possible block.  Commit 6ed6a722f9ab ("minixfs: fix block limit check")
fixed this in the V2 mapping code.  Fix it in the V1 mapping code too.

Link: http://lkml.kernel.org/r/20200628060846.682158-6-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_v1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/minix/itree_v1.c~fs-minix-fix-block-limit-check-for-v1-filesystems
+++ a/fs/minix/itree_v1.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if (block >= inode->i_sb->s_maxbytes/BLOCK_SIZE) {
+	} else if ((u64)block * BLOCK_SIZE >= inode->i_sb->s_maxbytes) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
_

Patches currently in -mm which might be from ebiggers@google.com are


