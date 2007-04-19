From: akpm@linux-foundation.org
Subject: - ufs-proper-handling-of-zero-link-case.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:01:59 -0700
Message-ID: <200704192001.l3JK1xp0029336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766985AbXDSUCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, jim@jtan.com, mm-commits@vger.kernel.org


The patch titled
     ufs proper handling of zero link case
has been removed from the -mm tree.  Its filename was
     ufs-proper-handling-of-zero-link-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs proper handling of zero link case
From: Evgeniy Dushistov <dushistov@mail.ru>

This patch should fix or partly fix this bug:
http://bugzilla.kernel.org/show_bug.cgi?id=8276

The problem is:

- if we see "zero link case" during reading inode operation, we call
  ufs_error(which remount fs readonly), but not "mark" inode as bad (1)

- in readonly case we do not fill some data structures, which are used in
  read and write case (2)

- VFS call ufs_delete_inode if link count is zero (3)

so (1)->(3)->(2) cause oops, this patch should fix such scenario

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jim Paris <jim@jtan.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff -puN fs/ufs/inode.c~ufs-proper-handling-of-zero-link-case fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-proper-handling-of-zero-link-case
+++ a/fs/ufs/inode.c
@@ -601,7 +601,7 @@ static void ufs_set_inode_ops(struct ino
 				   ufs_get_inode_dev(inode->i_sb, UFS_I(inode)));
 }
 
-static void ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
+static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 {
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -613,8 +613,10 @@ static void ufs1_read_inode(struct inode
 	 */
 	inode->i_mode = mode = fs16_to_cpu(sb, ufs_inode->ui_mode);
 	inode->i_nlink = fs16_to_cpu(sb, ufs_inode->ui_nlink);
-	if (inode->i_nlink == 0)
+	if (inode->i_nlink == 0) {
 		ufs_error (sb, "ufs_read_inode", "inode %lu has zero nlink\n", inode->i_ino);
+		return -1;
+	}
 	
 	/*
 	 * Linux now has 32-bit uid and gid, so we can support EFT.
@@ -643,9 +645,10 @@ static void ufs1_read_inode(struct inode
 		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
 			ufsi->i_u1.i_symlink[i] = ufs_inode->ui_u2.ui_symlink[i];
 	}
+	return 0;
 }
 
-static void ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
+static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 {
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -658,8 +661,10 @@ static void ufs2_read_inode(struct inode
 	 */
 	inode->i_mode = mode = fs16_to_cpu(sb, ufs2_inode->ui_mode);
 	inode->i_nlink = fs16_to_cpu(sb, ufs2_inode->ui_nlink);
-	if (inode->i_nlink == 0)
+	if (inode->i_nlink == 0) {
 		ufs_error (sb, "ufs_read_inode", "inode %lu has zero nlink\n", inode->i_ino);
+		return -1;
+	}
 
         /*
          * Linux now has 32-bit uid and gid, so we can support EFT.
@@ -690,6 +695,7 @@ static void ufs2_read_inode(struct inode
 		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
 			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
 	}
+	return 0;
 }
 
 void ufs_read_inode(struct inode * inode)
@@ -698,6 +704,7 @@ void ufs_read_inode(struct inode * inode
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct buffer_head * bh;
+	int err;
 
 	UFSD("ENTER, ino %lu\n", inode->i_ino);
 
@@ -720,14 +727,17 @@ void ufs_read_inode(struct inode * inode
 	if ((UFS_SB(sb)->s_flags & UFS_TYPE_MASK) == UFS_TYPE_UFS2) {
 		struct ufs2_inode *ufs2_inode = (struct ufs2_inode *)bh->b_data;
 
-		ufs2_read_inode(inode,
-				ufs2_inode + ufs_inotofsbo(inode->i_ino));
+		err = ufs2_read_inode(inode,
+				      ufs2_inode + ufs_inotofsbo(inode->i_ino));
 	} else {
 		struct ufs_inode *ufs_inode = (struct ufs_inode *)bh->b_data;
 
-		ufs1_read_inode(inode, ufs_inode + ufs_inotofsbo(inode->i_ino));
+		err = ufs1_read_inode(inode,
+				      ufs_inode + ufs_inotofsbo(inode->i_ino));
 	}
 
+	if (err)
+		goto bad_inode;
 	inode->i_version++;
 	ufsi->i_lastfrag =
 		(inode->i_size + uspi->s_fsize - 1) >> uspi->s_fshift;
@@ -888,6 +898,8 @@ void ufs_delete_inode (struct inode * in
 	loff_t old_i_size;
 
 	truncate_inode_pages(&inode->i_data, 0);
+	if (is_bad_inode(inode))
+		goto no_delete;
 	/*UFS_I(inode)->i_dtime = CURRENT_TIME;*/
 	lock_kernel();
 	mark_inode_dirty(inode);
@@ -898,4 +910,7 @@ void ufs_delete_inode (struct inode * in
 		ufs_warning(inode->i_sb, __FUNCTION__, "ufs_truncate failed\n");
 	ufs_free_inode (inode);
 	unlock_kernel();
+	return;
+no_delete:
+	clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
