From: akpm@linux-foundation.org
Subject: - fatfs-remove-deadlocking-lock_super-calls.patch removed from -mm tree
Date: Fri, 30 May 2008 15:38:32 -0700
Message-ID: <200805302238.m4UMcWR6014832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbYE3WjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, hirofumi@mail.parknet.co.jp, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     fatfs: remove deadlocking lock_super() calls
has been removed from the -mm tree.  Its filename was
     fatfs-remove-deadlocking-lock_super-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fatfs: remove deadlocking lock_super() calls
From: corbet@lwn.net (Jonathan Corbet)

Linus sez:

	So the end result of that is all the "lock_kernel()" calls in
	fs/fat/file.c should actually just go away - not be replaced by
	lock_super() at alL!

This patch causes that to be.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN fs/fat/file.c~fatfs-remove-deadlocking-lock_super-calls fs/fat/file.c
--- a/fs/fat/file.c~fatfs-remove-deadlocking-lock_super-calls
+++ a/fs/fat/file.c
@@ -11,7 +11,6 @@
 #include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
@@ -229,8 +228,7 @@ static int fat_free(struct inode *inode,
 
 void fat_truncate(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	const unsigned int cluster_size = sbi->cluster_size;
 	int nr_clusters;
 
@@ -243,9 +241,7 @@ void fat_truncate(struct inode *inode)
 
 	nr_clusters = (inode->i_size + (cluster_size - 1)) >> sbi->cluster_bits;
 
-	lock_super(sb);
 	fat_free(inode, nr_clusters);
-	unlock_super(sb);
 	fat_flush_inodes(inode->i_sb, inode, NULL);
 }
 
@@ -298,14 +294,11 @@ static int fat_allow_set_time(struct msd
 
 int fat_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	struct super_block *sb = dentry->d_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
 	int mask, error = 0;
 	unsigned int ia_valid;
 
-	lock_super(sb);
