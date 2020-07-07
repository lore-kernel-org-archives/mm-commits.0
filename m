From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-minix-fix-block-limit-check-for-v1-filesystems.patch
 added to -mm tree
Date: Tue, 07 Jul 2020 12:25:35 -0700
Message-ID: <20200707192535.DF2xkAnRU%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgGGTZg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:25:36 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anenbupt@gmail.com, ebiggers@google.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/minix: fix block limit check for V1 filesystems
has been added to the -mm tree.  Its filename is
     fs-minix-fix-block-limit-check-for-v1-filesystems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-minix-fix-block-limit-check-for-v1-filesystems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-minix-fix-block-limit-check-for-v1-filesystems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-minix-check-return-value-of-sb_getblk.patch
fs-minix-dont-allow-getting-deleted-inodes.patch
fs-minix-reject-too-large-maximum-file-size.patch
fs-minix-set-s_maxbytes-correctly.patch
fs-minix-fix-block-limit-check-for-v1-filesystems.patch
fs-minix-remove-expected-error-message-in-block_to_path.patch
