From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 fs-minix-remove-expected-error-message-in-block_to_path.patch added to -mm
 tree
Date: Tue, 07 Jul 2020 12:25:37 -0700
Message-ID: <20200707192537.gesri5-Kx%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgGGTZi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:25:38 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anenbupt@gmail.com, ebiggers@google.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/minix: remove expected error message in block_to_path()
has been added to the -mm tree.  Its filename is
     fs-minix-remove-expected-error-message-in-block_to_path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-minix-remove-expected-error-message-in-block_to_path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-minix-remove-expected-error-message-in-block_to_path.patch

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

fs-minix-check-return-value-of-sb_getblk.patch
fs-minix-dont-allow-getting-deleted-inodes.patch
fs-minix-reject-too-large-maximum-file-size.patch
fs-minix-set-s_maxbytes-correctly.patch
fs-minix-fix-block-limit-check-for-v1-filesystems.patch
fs-minix-remove-expected-error-message-in-block_to_path.patch
