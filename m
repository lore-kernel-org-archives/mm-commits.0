From: akpm@linux-foundation.org
Subject: [merged]
 reiserfs-clean-up-several-indentation-issues.patch removed from -mm tree
Date: Tue, 07 Apr 2020 19:02:09 -0700
Message-ID: <20200408020209.WJ4PmX8OZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCCL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: clean up several indentation issues
has been removed from the -mm tree.  Its filename was
     reiserfs-clean-up-several-indentation-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: reiserfs: clean up several indentation issues

There are several places where code is indented incorrectly. Fix these.

Link: http://lkml.kernel.org/r/20200325135018.113431-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c |    2 +-
 fs/reiserfs/ioctl.c    |   11 ++++++-----
 fs/reiserfs/namei.c    |   10 +++++-----
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/reiserfs/do_balan.c~reiserfs-clean-up-several-indentation-issues
+++ a/fs/reiserfs/do_balan.c
@@ -842,7 +842,7 @@ static void balance_leaf_paste_right_who
 	struct item_head *pasted;
 	struct buffer_info bi;
 
-							buffer_info_init_right(tb, &bi);
+	buffer_info_init_right(tb, &bi);
 	leaf_shift_right(tb, tb->rnum[0], tb->rbytes);
 
 	/* append item in R[0] */
--- a/fs/reiserfs/ioctl.c~reiserfs-clean-up-several-indentation-issues
+++ a/fs/reiserfs/ioctl.c
@@ -184,11 +184,12 @@ int reiserfs_unpack(struct inode *inode,
 	}
 
 	/* we need to make sure nobody is changing the file size beneath us */
-{
-	int depth = reiserfs_write_unlock_nested(inode->i_sb);
-	inode_lock(inode);
-	reiserfs_write_lock_nested(inode->i_sb, depth);
-}
+	{
+		int depth = reiserfs_write_unlock_nested(inode->i_sb);
+
+		inode_lock(inode);
+		reiserfs_write_lock_nested(inode->i_sb, depth);
+	}
 
 	reiserfs_write_lock(inode->i_sb);
 
--- a/fs/reiserfs/namei.c~reiserfs-clean-up-several-indentation-issues
+++ a/fs/reiserfs/namei.c
@@ -838,10 +838,10 @@ static int reiserfs_mkdir(struct inode *
 	 */
 	INC_DIR_INODE_NLINK(dir)
 
-	    retval = reiserfs_new_inode(&th, dir, mode, NULL /*symlink */ ,
-					old_format_only(dir->i_sb) ?
-					EMPTY_DIR_SIZE_V1 : EMPTY_DIR_SIZE,
-					dentry, inode, &security);
+	retval = reiserfs_new_inode(&th, dir, mode, NULL /*symlink */,
+				    old_format_only(dir->i_sb) ?
+				    EMPTY_DIR_SIZE_V1 : EMPTY_DIR_SIZE,
+				    dentry, inode, &security);
 	if (retval) {
 		DEC_DIR_INODE_NLINK(dir)
 		goto out_failed;
@@ -967,7 +967,7 @@ static int reiserfs_rmdir(struct inode *
 	reiserfs_update_sd(&th, inode);
 
 	DEC_DIR_INODE_NLINK(dir)
-	    dir->i_size -= (DEH_SIZE + de.de_entrylen);
+	dir->i_size -= (DEH_SIZE + de.de_entrylen);
 	reiserfs_update_sd(&th, dir);
 
 	/* prevent empty directory from getting lost */
_

Patches currently in -mm which might be from colin.king@canonical.com are
