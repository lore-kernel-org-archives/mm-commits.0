From: akpm@linux-foundation.org
Subject: [merged]
 devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:16 -0700
Message-ID: <559adb44.WG3dz/GY/0A2E918%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbbGFTrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, fengguang.wu@intel.com, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: devpts: if initialization failed, don't crash when opening /dev/ptmx
has been removed from the -mm tree.  Its filename was
     devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: devpts: if initialization failed, don't crash when opening /dev/ptmx

If devpts failed to initialize, it would store an ERR_PTR in the global
devpts_mnt.  A subsequent open of /dev/ptmx would call devpts_new_index,
which would dereference devpts_mnt and crash.

Avoid storing invalid values in devpts_mnt; leave it NULL instead.  Make
both devpts_new_index and devpts_pty_new fail gracefully with ENODEV in
that case, which then becomes the return value to the userspace open call
on /dev/ptmx.

[akpm@linux-foundation.org: remove unneeded static]
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff -puN fs/devpts/inode.c~devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx
+++ a/fs/devpts/inode.c
@@ -142,6 +142,8 @@ static inline struct super_block *pts_sb
 	if (inode->i_sb->s_magic == DEVPTS_SUPER_MAGIC)
 		return inode->i_sb;
 #endif
+	if (!devpts_mnt)
+		return NULL;
 	return devpts_mnt->mnt_sb;
 }
 
@@ -525,10 +527,14 @@ static struct file_system_type devpts_fs
 int devpts_new_index(struct inode *ptmx_inode)
 {
 	struct super_block *sb = pts_sb_from_inode(ptmx_inode);
-	struct pts_fs_info *fsi = DEVPTS_SB(sb);
+	struct pts_fs_info *fsi;
 	int index;
 	int ida_ret;
 
+	if (!sb)
+		return -ENODEV;
+
+	fsi = DEVPTS_SB(sb);
 retry:
 	if (!ida_pre_get(&fsi->allocated_ptys, GFP_KERNEL))
 		return -ENOMEM;
@@ -584,11 +590,18 @@ struct inode *devpts_pty_new(struct inod
 	struct dentry *dentry;
 	struct super_block *sb = pts_sb_from_inode(ptmx_inode);
 	struct inode *inode;
-	struct dentry *root = sb->s_root;
-	struct pts_fs_info *fsi = DEVPTS_SB(sb);
-	struct pts_mount_opts *opts = &fsi->mount_opts;
+	struct dentry *root;
+	struct pts_fs_info *fsi;
+	struct pts_mount_opts *opts;
 	char s[12];
 
+	if (!sb)
+		return ERR_PTR(-ENODEV);
+
+	root = sb->s_root;
+	fsi = DEVPTS_SB(sb);
+	opts = &fsi->mount_opts;
+
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -676,12 +689,16 @@ static int __init init_devpts_fs(void)
 	struct ctl_table_header *table;
 
 	if (!err) {
+		struct vfsmount *mnt;
+
 		table = register_sysctl_table(pty_root_table);
-		devpts_mnt = kern_mount(&devpts_fs_type);
-		if (IS_ERR(devpts_mnt)) {
-			err = PTR_ERR(devpts_mnt);
+		mnt = kern_mount(&devpts_fs_type);
+		if (IS_ERR(mnt)) {
+			err = PTR_ERR(mnt);
 			unregister_filesystem(&devpts_fs_type);
 			unregister_sysctl_table(table);
+		} else {
+			devpts_mnt = mnt;
 		}
 	}
 	return err;
_

Patches currently in -mm which might be from josh@joshtriplett.org are


