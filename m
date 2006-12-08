From: akpm@osdl.org
Subject: - autofs4-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:14 -0800
Message-ID: <200612082002.kB8K2E2x001957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426238AbWLHUCh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     autofs4: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     autofs4-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: autofs4: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the autofs4
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/autofs4/autofs_i.h |    3 ++-
 fs/autofs4/root.c     |   16 ++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-change-uses-of-f_dentry fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-change-uses-of-f_dentry
+++ a/fs/autofs4/autofs_i.h
@@ -150,7 +150,8 @@ static inline int autofs4_ispending(stru
 
 static inline void autofs4_copy_atime(struct file *src, struct file *dst)
 {
-	dst->f_dentry->d_inode->i_atime = src->f_dentry->d_inode->i_atime;
+	dst->f_path.dentry->d_inode->i_atime =
+		src->f_path.dentry->d_inode->i_atime;
 	return;
 }
 
diff -puN fs/autofs4/root.c~autofs4-change-uses-of-f_dentry fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-change-uses-of-f_dentry
+++ a/fs/autofs4/root.c
@@ -74,7 +74,7 @@ struct inode_operations autofs4_dir_inod
 static int autofs4_root_readdir(struct file *file, void *dirent,
 				filldir_t filldir)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(file->f_dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs4_sbi(file->f_path.dentry->d_sb);
 	int oz_mode = autofs4_oz_mode(sbi);
 
 	DPRINTK("called, filp->f_pos = %lld", file->f_pos);
@@ -95,8 +95,8 @@ static int autofs4_root_readdir(struct f
 
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
-	struct dentry *dentry = file->f_dentry;
-	struct vfsmount *mnt = file->f_vfsmnt;
+	struct dentry *dentry = file->f_path.dentry;
+	struct vfsmount *mnt = file->f_path.mnt;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct dentry *cursor;
 	int status;
@@ -172,7 +172,7 @@ out:
 
 static int autofs4_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct dentry *cursor = file->private_data;
 	int status = 0;
@@ -204,7 +204,7 @@ out:
 
 static int autofs4_dir_readdir(struct file *file, void *dirent, filldir_t filldir)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct dentry *cursor = file->private_data;
 	int status;
@@ -858,14 +858,14 @@ static int autofs4_root_ioctl(struct ino
 		return autofs4_ask_reghost(sbi, p);
 
 	case AUTOFS_IOC_ASKUMOUNT:
-		return autofs4_ask_umount(filp->f_vfsmnt, p);
+		return autofs4_ask_umount(filp->f_path.mnt, p);
 
 	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,filp->f_vfsmnt,sbi, p);
+		return autofs4_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
 	/* same as above, but can send multiple expires through pipe */
 	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,filp->f_vfsmnt,sbi, p);
+		return autofs4_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
 
 	default:
 		return -ENOSYS;
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

