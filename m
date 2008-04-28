From: akpm@linux-foundation.org
Subject: - fat-fat_notify_change-and-check_mode-cleanup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:30 -0700
Message-ID: <200804282201.m3SM1UqT018870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965776AbYD1WBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: fat_notify_change() and check_mode() cleanup
has been removed from the -mm tree.  Its filename was
     fat-fat_notify_change-and-check_mode-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: fat_notify_change() and check_mode() cleanup
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

- Rename fat_notify_change() to fat_setattr()
- check_mode() cleanup
- Change layout of code

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c            |  183 ++++++++++++++++---------------------
 fs/msdos/namei.c         |    2 
 fs/vfat/namei.c          |    2 
 include/linux/msdos_fs.h |    2 
 4 files changed, 87 insertions(+), 102 deletions(-)

diff -puN fs/fat/file.c~fat-fat_notify_change-and-check_mode-cleanup fs/fat/file.c
--- a/fs/fat/file.c~fat-fat_notify_change-and-check_mode-cleanup
+++ a/fs/fat/file.c
@@ -157,104 +157,6 @@ out:
 	return err;
 }
 
-static int check_mode(const struct msdos_sb_info *sbi, mode_t mode)
-{
-	mode_t req = mode & ~S_IFMT;
-
-	/*
-	 * Of the r and x bits, all (subject to umask) must be present. Of the
-	 * w bits, either all (subject to umask) or none must be present.
-	 */
-
-	if (S_ISREG(mode)) {
-		req &= ~sbi->options.fs_fmask;
-
-		if ((req & (S_IRUGO | S_IXUGO)) !=
-		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_fmask))
-			return -EPERM;
-
-		if ((req & S_IWUGO) != 0 &&
-		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_fmask))
-			return -EPERM;
-	} else if (S_ISDIR(mode)) {
-		req &= ~sbi->options.fs_dmask;
-
-		if ((req & (S_IRUGO | S_IXUGO)) !=
-		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_dmask))
-			return -EPERM;
-
-		if ((req & S_IWUGO) != 0 &&
-		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_dmask))
-			return -EPERM;
-	} else {
-		return -EPERM;
-	}
-
-	return 0;
-}
-
-int fat_notify_change(struct dentry *dentry, struct iattr *attr)
-{
-	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
-	struct inode *inode = dentry->d_inode;
-	int mask, error = 0;
-
-	lock_kernel();
-
-	/*
-	 * Expand the file. Since inode_setattr() updates ->i_size
-	 * before calling the ->truncate(), but FAT needs to fill the
-	 * hole before it.
-	 */
-	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size > inode->i_size) {
-			error = fat_cont_expand(inode, attr->ia_size);
-			if (error || attr->ia_valid == ATTR_SIZE)
-				goto out;
-			attr->ia_valid &= ~ATTR_SIZE;
-		}
-	}
-
-	error = inode_change_ok(inode, attr);
-	if (error) {
-		if (sbi->options.quiet)
-			error = 0;
-		goto out;
-	}
-	if (((attr->ia_valid & ATTR_UID) &&
-	     (attr->ia_uid != sbi->options.fs_uid)) ||
-	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)))
-		error = -EPERM;
-
-	if (error) {
-		if (sbi->options.quiet)
-			error = 0;
-		goto out;
-	}
-
-	if (attr->ia_valid & ATTR_MODE) {
-		error = check_mode(sbi, attr->ia_mode);
-		if (error != 0 && !sbi->options.quiet)
-			goto out;
-	}
-
-	error = inode_setattr(inode, attr);
-	if (error)
-		goto out;
-
-	if (S_ISDIR(inode->i_mode))
-		mask = sbi->options.fs_dmask;
-	else
-		mask = sbi->options.fs_fmask;
-	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
-out:
-	unlock_kernel();
-	return error;
-}
-
-EXPORT_SYMBOL_GPL(fat_notify_change);
-
 /* Free all clusters after the skip'th cluster. */
 static int fat_free(struct inode *inode, int skip)
 {
@@ -355,8 +257,91 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
+static int fat_check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+{
+	mode_t mask, req = mode & ~S_IFMT;
+
+	if (S_ISREG(mode))
+		mask = sbi->options.fs_fmask;
+	else
+		mask = sbi->options.fs_dmask;
+
+	/*
+	 * Of the r and x bits, all (subject to umask) must be present. Of the
+	 * w bits, either all (subject to umask) or none must be present.
+	 */
+	req &= ~mask;
+	if ((req & (S_IRUGO | S_IXUGO)) != ((S_IRUGO | S_IXUGO) & ~mask))
+		return -EPERM;
+	if ((req & S_IWUGO) && ((req & S_IWUGO) != (S_IWUGO & ~mask)))
+		return -EPERM;
+
+	return 0;
+}
+
+int fat_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
+	struct inode *inode = dentry->d_inode;
+	int mask, error = 0;
+
+	lock_kernel();
+
+	/*
+	 * Expand the file. Since inode_setattr() updates ->i_size
+	 * before calling the ->truncate(), but FAT needs to fill the
+	 * hole before it.
+	 */
+	if (attr->ia_valid & ATTR_SIZE) {
+		if (attr->ia_size > inode->i_size) {
+			error = fat_cont_expand(inode, attr->ia_size);
+			if (error || attr->ia_valid == ATTR_SIZE)
+				goto out;
+			attr->ia_valid &= ~ATTR_SIZE;
+		}
+	}
+
+	error = inode_change_ok(inode, attr);
+	if (error) {
+		if (sbi->options.quiet)
+			error = 0;
+		goto out;
+	}
+	if (((attr->ia_valid & ATTR_UID) &&
+	     (attr->ia_uid != sbi->options.fs_uid)) ||
+	    ((attr->ia_valid & ATTR_GID) &&
+	     (attr->ia_gid != sbi->options.fs_gid)))
+		error = -EPERM;
+
+	if (error) {
+		if (sbi->options.quiet)
+			error = 0;
+		goto out;
+	}
+
+	if (attr->ia_valid & ATTR_MODE) {
+		error = fat_check_mode(sbi, attr->ia_mode);
+		if (error != 0 && !sbi->options.quiet)
+			goto out;
+	}
+
+	error = inode_setattr(inode, attr);
+	if (error)
+		goto out;
+
+	if (S_ISDIR(inode->i_mode))
+		mask = sbi->options.fs_dmask;
+	else
+		mask = sbi->options.fs_fmask;
+	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
+out:
+	unlock_kernel();
+	return error;
+}
+EXPORT_SYMBOL_GPL(fat_setattr);
+
 const struct inode_operations fat_file_inode_operations = {
 	.truncate	= fat_truncate,
-	.setattr	= fat_notify_change,
+	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
diff -puN fs/msdos/namei.c~fat-fat_notify_change-and-check_mode-cleanup fs/msdos/namei.c
--- a/fs/msdos/namei.c~fat-fat_notify_change-and-check_mode-cleanup
+++ a/fs/msdos/namei.c
@@ -653,7 +653,7 @@ static const struct inode_operations msd
 	.mkdir		= msdos_mkdir,
 	.rmdir		= msdos_rmdir,
 	.rename		= msdos_rename,
-	.setattr	= fat_notify_change,
+	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
 
diff -puN fs/vfat/namei.c~fat-fat_notify_change-and-check_mode-cleanup fs/vfat/namei.c
--- a/fs/vfat/namei.c~fat-fat_notify_change-and-check_mode-cleanup
+++ a/fs/vfat/namei.c
@@ -1003,7 +1003,7 @@ static const struct inode_operations vfa
 	.mkdir		= vfat_mkdir,
 	.rmdir		= vfat_rmdir,
 	.rename		= vfat_rename,
-	.setattr	= fat_notify_change,
+	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
 
diff -puN include/linux/msdos_fs.h~fat-fat_notify_change-and-check_mode-cleanup include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat-fat_notify_change-and-check_mode-cleanup
+++ a/include/linux/msdos_fs.h
@@ -401,7 +401,7 @@ extern int fat_generic_ioctl(struct inod
 			     unsigned int cmd, unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
-extern int fat_notify_change(struct dentry * dentry, struct iattr * attr);
+extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
 extern void fat_truncate(struct inode *inode);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
vfs-fix-unconditional-write_super-call-in-file_fsync.patch
fat-use-get-put_unaligned_-helpers.patch

