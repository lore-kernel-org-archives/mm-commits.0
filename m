From: akpm@linux-foundation.org
Subject: - fuse-clean-up-execute-permission-checking.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:41 -0700
Message-ID: <200710180703.l9I73fJ2031459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763051AbXJRHPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: clean up execute permission checking
has been removed from the -mm tree.  Its filename was
     fuse-clean-up-execute-permission-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 31 insertions(+), 18 deletions(-)

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

origin.patch
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
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch
