Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F46AC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8D0206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196138;
	bh=38JKsmAoQaaVNQXg4CZy2bMRvi6lKls8nTAc8Q5nHS4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=esD8YzDkklSXyl1rx0oYqHpNp4PczMZG9frjc01QI/pvguNaLVa6+M/i5gxaHl5/W
	 xmBfe5fgOGtarOIYRXpZ4MDRHwxYwxBBezwdRhJbVv/UQ7RjJAuVt4SzT+nZqMbPX2
	 dsnkK2BS/U31mrZ3xLm2LExDPbdcoI4RpHikQ7NE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLBfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgHLBfh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE4D20658;
        Wed, 12 Aug 2020 01:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196137;
        bh=38JKsmAoQaaVNQXg4CZy2bMRvi6lKls8nTAc8Q5nHS4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zC0GUVKtr+/BVguolnmfjT3lv8swcsrfPpSXhf8re8sfPY6JwUraDTLyQmipWZEdG
         FDaDxO3ZIr/ykkZf0dloGOSQvTaRCp0ucBEgkeniIhb0Rqzei81+n48vvHfrIpljkY
         A3GATT4vA08EW9Yux7jCmLvp22TYDvEsiwj7q0Wo=
Date:   Tue, 11 Aug 2020 18:35:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anenbupt@gmail.com, ebiggers@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 102/165] fs/minix: fix block limit check for V1
 filesystems
Message-ID: <20200812013536.N8PGSCRct%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
