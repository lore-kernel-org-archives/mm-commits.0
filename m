From: akpm@linux-foundation.org
Subject: - fat-dont-call-notify_change.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:34 -0700
Message-ID: <200805310742.m4V7gYwR000919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbYEaHnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fat: dont call notify_change
has been removed from the -mm tree.  Its filename was
     fat-dont-call-notify_change.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: dont call notify_change
From: Miklos Szeredi <mszeredi@suse.cz>

The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
the file mode before changing the inode attributes.  Replace with
explicit calls to security_inode_setattr(), fat_setattr() and
fsnotify_change().

This is equivalent to the original.  The reason it is needed, is that
later in the series we move the immutable check into notify_change().
That would break the FAT_IOCTL_SET_ATTRIBUTES ioctl, as it needs to
perform the mode change regardless of the immutability of the file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c       |   15 ++++++++++++++-
 security/security.c |    1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/fat/file.c~fat-dont-call-notify_change fs/fat/file.c
--- a/fs/fat/file.c~fat-dont-call-notify_change
+++ a/fs/fat/file.c
@@ -15,6 +15,8 @@
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
+#include <linux/fsnotify.h>
+#include <linux/security.h>
 
 int fat_generic_ioctl(struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg)
@@ -64,6 +66,7 @@ int fat_generic_ioctl(struct inode *inod
 
 		/* Equivalent to a chmod() */
 		ia.ia_valid = ATTR_MODE | ATTR_CTIME;
+		ia.ia_ctime = current_fs_time(inode->i_sb);
 		if (is_dir) {
 			ia.ia_mode = MSDOS_MKMODE(attr,
 				S_IRWXUGO & ~sbi->options.fs_dmask)
@@ -90,11 +93,21 @@ int fat_generic_ioctl(struct inode *inod
 			}
 		}
 
+		/*
+		 * The security check is questionable...  We single
+		 * out the RO attribute for checking by the security
+		 * module, just because it maps to a file mode.
+		 */
+		err = security_inode_setattr(filp->f_path.dentry, &ia);
+		if (err)
+			goto up;
+
 		/* This MUST be done before doing anything irreversible... */
-		err = notify_change(filp->f_path.dentry, &ia);
+		err = fat_setattr(filp->f_path.dentry, &ia);
 		if (err)
 			goto up;
 
+		fsnotify_change(filp->f_path.dentry, ia.ia_valid);
 		if (sbi->options.sys_immutable) {
 			if (attr & ATTR_SYS)
 				inode->i_flags |= S_IMMUTABLE;
diff -puN security/security.c~fat-dont-call-notify_change security/security.c
--- a/security/security.c~fat-dont-call-notify_change
+++ a/security/security.c
@@ -477,6 +477,7 @@ int security_inode_setattr(struct dentry
 		return 0;
 	return security_ops->inode_setattr(dentry, attr);
 }
+EXPORT_SYMBOL_GPL(security_inode_setattr);
 
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
fat-dont-call-notify_change.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

