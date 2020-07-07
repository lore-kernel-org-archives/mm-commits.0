From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-minix-set-s_maxbytes-correctly.patch added to -mm
 tree
Date: Tue, 07 Jul 2020 12:25:32 -0700
Message-ID: <20200707192532.BjqTiwsIB%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgGGTZd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:25:33 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anenbupt@gmail.com, ebiggers@google.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/minix: set s_maxbytes correctly
has been added to the -mm tree.  Its filename is
     fs-minix-set-s_maxbytes-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-minix-set-s_maxbytes-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-minix-set-s_maxbytes-correctly.patch

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
Subject: fs/minix: set s_maxbytes correctly

The minix filesystem leaves super_block::s_maxbytes at MAX_NON_LFS rather
than setting it to the actual filesystem-specific limit.  This is broken
because it means userspace doesn't see the standard behavior like getting
EFBIG and SIGXFSZ when exceeding the maximum file size.

Fix this by setting s_maxbytes correctly.

Link: http://lkml.kernel.org/r/20200628060846.682158-5-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c    |   12 +++++++-----
 fs/minix/itree_v1.c |    2 +-
 fs/minix/itree_v2.c |    3 +--
 fs/minix/minix.h    |    1 -
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/minix/inode.c~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/inode.c
@@ -150,8 +150,10 @@ static int minix_remount (struct super_b
 	return 0;
 }
 
-static bool minix_check_superblock(struct minix_sb_info *sbi)
+static bool minix_check_superblock(struct super_block *sb)
 {
+	struct minix_sb_info *sbi = minix_sb(sb);
+
 	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
 		return false;
 
@@ -161,7 +163,7 @@ static bool minix_check_superblock(struc
 	 * of indirect blocks which places the limit well above U32_MAX.
 	 */
 	if (sbi->s_version == MINIX_V1 &&
-	    sbi->s_max_size > (7 + 512 + 512*512) * BLOCK_SIZE)
+	    sb->s_maxbytes > (7 + 512 + 512*512) * BLOCK_SIZE)
 		return false;
 
 	return true;
@@ -202,7 +204,7 @@ static int minix_fill_super(struct super
 	sbi->s_zmap_blocks = ms->s_zmap_blocks;
 	sbi->s_firstdatazone = ms->s_firstdatazone;
 	sbi->s_log_zone_size = ms->s_log_zone_size;
-	sbi->s_max_size = ms->s_max_size;
+	s->s_maxbytes = ms->s_max_size;
 	s->s_magic = ms->s_magic;
 	if (s->s_magic == MINIX_SUPER_MAGIC) {
 		sbi->s_version = MINIX_V1;
@@ -233,7 +235,7 @@ static int minix_fill_super(struct super
 		sbi->s_zmap_blocks = m3s->s_zmap_blocks;
 		sbi->s_firstdatazone = m3s->s_firstdatazone;
 		sbi->s_log_zone_size = m3s->s_log_zone_size;
-		sbi->s_max_size = m3s->s_max_size;
+		s->s_maxbytes = m3s->s_max_size;
 		sbi->s_ninodes = m3s->s_ninodes;
 		sbi->s_nzones = m3s->s_zones;
 		sbi->s_dirsize = 64;
@@ -245,7 +247,7 @@ static int minix_fill_super(struct super
 	} else
 		goto out_no_fs;
 
-	if (!minix_check_superblock(sbi))
+	if (!minix_check_superblock(s))
 		goto out_illegal_sb;
 
 	/*
--- a/fs/minix/itree_v1.c~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/itree_v1.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
+	} else if (block >= inode->i_sb->s_maxbytes/BLOCK_SIZE) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
--- a/fs/minix/itree_v2.c~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/itree_v2.c
@@ -32,8 +32,7 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, sb->s_bdev);
-	} else if ((u64)block * (u64)sb->s_blocksize >=
-			minix_sb(sb)->s_max_size) {
+	} else if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
--- a/fs/minix/minix.h~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/minix.h
@@ -32,7 +32,6 @@ struct minix_sb_info {
 	unsigned long s_zmap_blocks;
 	unsigned long s_firstdatazone;
 	unsigned long s_log_zone_size;
-	unsigned long s_max_size;
 	int s_dirsize;
 	int s_namelen;
 	struct buffer_head ** s_imap;
_

Patches currently in -mm which might be from ebiggers@google.com are

fs-minix-check-return-value-of-sb_getblk.patch
fs-minix-dont-allow-getting-deleted-inodes.patch
fs-minix-reject-too-large-maximum-file-size.patch
fs-minix-set-s_maxbytes-correctly.patch
fs-minix-fix-block-limit-check-for-v1-filesystems.patch
fs-minix-remove-expected-error-message-in-block_to_path.patch
