From: akpm@linux-foundation.org
Subject: + fuse-clean-up-execute-permission-checking.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:34:10 -0700
Message-ID: <200708092134.l79LYAhV020724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbXHIVev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: clean up execute permission checking
has been added to the -mm tree.  Its filename is
     fuse-clean-up-execute-permission-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: clean up execute permission checking
From: Miklos Szeredi <mszeredi@suse.cz>

Define a new function fuse_refresh_attributes() that conditionally refreshes
the attributes based on the validity timeout.

In fuse_permission() only refresh the attributes for checking the execute bits
if necessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |   49 ++++++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff -puN fs/fuse/dir.c~fuse-clean-up-execute-permission-checking fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-clean-up-execute-permission-checking
+++ a/fs/fuse/dir.c
@@ -695,6 +695,20 @@ static int fuse_do_getattr(struct inode 
 }
 
 /*
+ * Check if attributes are still valid, and if not send a GETATTR
+ * request to refresh them.
+ */
+static int fuse_refresh_attributes(struct inode *inode)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	if (fi->i_time < get_jiffies_64())
+		return fuse_do_getattr(inode);
+	else
+		return 0;
+}
+
+/*
  * Calling into a user-controlled filesystem gives the filesystem
  * daemon ptrace-like capabilities over the requester process.  This
  * means, that the filesystem daemon is able to record the exact
@@ -770,7 +784,6 @@ static int fuse_access(struct inode *ino
 static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	bool refreshed = false;
 	int err = 0;
 
@@ -778,12 +791,11 @@ static int fuse_permission(struct inode 
 		return -EACCES;
 
 	/*
-	 * If attributes are needed, but are stale, refresh them
-	 * before proceeding
+	 * If attributes are needed, refresh them before proceeding
 	 */
-	if (((fc->flags & FUSE_DEFAULT_PERMISSIONS) || (mask & MAY_EXEC)) &&
-	    fi->i_time < get_jiffies_64()) {
-		err = fuse_do_getattr(inode);
+	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
+	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
+		err = fuse_refresh_attributes(inode);
 		if (err)
 			return err;
 
@@ -806,14 +818,17 @@ static int fuse_permission(struct inode 
 		   exist.  So if permissions are revoked this won't be
 		   noticed immediately, only after the attribute
 		   timeout has expired */
-
-	} else {
-		int mode = inode->i_mode;
-		if ((mask & MAY_EXEC) && !S_ISDIR(mode) && !(mode & S_IXUGO))
-			return -EACCES;
-
-		if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
-			return fuse_access(inode, mask);
+	} else if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR))) {
+		err = fuse_access(inode, mask);
+	} else if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		if (!(inode->i_mode & S_IXUGO)) {
+			if (refreshed)
+				return -EACCES;
+
+			err = fuse_do_getattr(inode);
+			if (!err && !(inode->i_mode & S_IXUGO))
+				return -EACCES;
+		}
 	}
 	return err;
 }
@@ -1046,14 +1061,12 @@ static int fuse_getattr(struct vfsmount 
 	struct inode *inode = entry->d_inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	int err = 0;
+	int err;
 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	if (fi->i_time < get_jiffies_64())
-		err = fuse_do_getattr(inode);
-
+	err = fuse_refresh_attributes(inode);
 	if (!err) {
 		generic_fillattr(inode, stat);
 		stat->mode = fi->orig_i_mode;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-clean-up-execute-permission-checking.patch
clean-out-unused-code-in-dentry-pruning.patch
uml-remove-unnecessary-hostfs_getattr.patch
fix-warnings-in-revoked_inodec.patch
