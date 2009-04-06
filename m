From: akpm@linux-foundation.org
Subject: [merged] fs-efs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:18 -0700
Message-ID: <200904061938.n36JcIbw013324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbZDFTsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/efs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-efs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/efs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make efs return f_fsid info for statfs(2), and do a little variable
renaming in efs_statfs().

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/super.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/efs/super.c~fs-efs-return-f_fsid-for-statfs2 fs/efs/super.c
--- a/fs/efs/super.c~fs-efs-return-f_fsid-for-statfs2
+++ a/fs/efs/super.c
@@ -329,18 +329,22 @@ out_no_fs:
 }
 
 static int efs_statfs(struct dentry *dentry, struct kstatfs *buf) {
-	struct efs_sb_info *sb = SUPER_INFO(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct efs_sb_info *sbi = SUPER_INFO(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type    = EFS_SUPER_MAGIC;	/* efs magic number */
 	buf->f_bsize   = EFS_BLOCKSIZE;		/* blocksize */
-	buf->f_blocks  = sb->total_groups *	/* total data blocks */
-			(sb->group_size - sb->inode_blocks);
-	buf->f_bfree   = sb->data_free;		/* free data blocks */
-	buf->f_bavail  = sb->data_free;		/* free blocks for non-root */
-	buf->f_files   = sb->total_groups *	/* total inodes */
-			sb->inode_blocks *
+	buf->f_blocks  = sbi->total_groups *	/* total data blocks */
+			(sbi->group_size - sbi->inode_blocks);
+	buf->f_bfree   = sbi->data_free;	/* free data blocks */
+	buf->f_bavail  = sbi->data_free;	/* free blocks for non-root */
+	buf->f_files   = sbi->total_groups *	/* total inodes */
+			sbi->inode_blocks *
 			(EFS_BLOCKSIZE / sizeof(struct efs_dinode));
-	buf->f_ffree   = sb->inode_free;	/* free inodes */
+	buf->f_ffree   = sbi->inode_free;	/* free inodes */
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = EFS_MAXNAMELEN;	/* max filename length */
 
 	return 0;
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

