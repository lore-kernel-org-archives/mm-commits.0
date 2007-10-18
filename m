From: akpm@linux-foundation.org
Subject: - fuse-refresh-stale-attributes-in-fuse_permission.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:30 -0700
Message-ID: <200710180703.l9I73UGF031444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763150AbXJRHPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: refresh stale attributes in fuse_permission()
has been removed from the -mm tree.  Its filename was
     fuse-refresh-stale-attributes-in-fuse_permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: refresh stale attributes in fuse_permission()
From: Miklos Szeredi <mszeredi@suse.cz>

fuse_permission() didn't refresh inode attributes before using them, even if
the validity has already expired.

Thanks to Junjiro Okajima for spotting this.

Also remove some old code to unconditionally refresh the attributes on the
root inode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |   61 ++++++++++++++++++++++-----------------------
 fs/fuse/file.c   |    8 -----
 fs/fuse/fuse_i.h |    5 ---
 3 files changed, 31 insertions(+), 43 deletions(-)

diff -puN fs/fuse/dir.c~fuse-refresh-stale-attributes-in-fuse_permission fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-refresh-stale-attributes-in-fuse_permission
+++ a/fs/fuse/dir.c
@@ -663,7 +663,7 @@ static int fuse_link(struct dentry *entr
 	return err;
 }
 
-int fuse_do_getattr(struct inode *inode)
+static int fuse_do_getattr(struct inode *inode)
 {
 	int err;
 	struct fuse_attr_out arg;
@@ -723,30 +723,6 @@ static int fuse_allow_task(struct fuse_c
 	return 0;
 }
 
-/*
- * Check whether the inode attributes are still valid
- *
- * If the attribute validity timeout has expired, then fetch the fresh
- * attributes with a 'getattr' request
- *
- * I'm not sure why cached attributes are never returned for the root
- * inode, this is probably being too cautious.
- */
-static int fuse_revalidate(struct dentry *entry)
-{
-	struct inode *inode = entry->d_inode;
-	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct fuse_conn *fc = get_fuse_conn(inode);
-
-	if (!fuse_allow_task(fc, current))
-		return -EACCES;
-	if (get_node_id(inode) != FUSE_ROOT_ID &&
-	    fi->i_time >= get_jiffies_64())
-		return 0;
-
-	return fuse_do_getattr(inode);
-}
-
 static int fuse_access(struct inode *inode, int mask)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -794,16 +770,33 @@ static int fuse_access(struct inode *ino
 static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	bool refreshed = false;
+	int err = 0;
 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
-	else if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
+
+	/*
+	 * If attributes are needed, but are stale, refresh them
+	 * before proceeding
+	 */
+	if (((fc->flags & FUSE_DEFAULT_PERMISSIONS) || (mask & MAY_EXEC)) &&
+	    fi->i_time < get_jiffies_64()) {
+		err = fuse_do_getattr(inode);
+		if (err)
+			return err;
+
+		refreshed = true;
+	}
+
+	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		int err = generic_permission(inode, mask, NULL);
 
 		/* If permission is denied, try to refresh file
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
-		if (err == -EACCES) {
+		if (err == -EACCES && !refreshed) {
 		 	err = fuse_do_getattr(inode);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
@@ -814,7 +807,6 @@ static int fuse_permission(struct inode 
 		   noticed immediately, only after the attribute
 		   timeout has expired */
 
-		return err;
 	} else {
 		int mode = inode->i_mode;
 		if ((mask & MAY_EXEC) && !S_ISDIR(mode) && !(mode & S_IXUGO))
@@ -822,8 +814,8 @@ static int fuse_permission(struct inode 
 
 		if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
 			return fuse_access(inode, mask);
-		return 0;
 	}
+	return err;
 }
 
 static int parse_dirfile(char *buf, size_t nbytes, struct file *file,
@@ -1052,7 +1044,16 @@ static int fuse_getattr(struct vfsmount 
 			struct kstat *stat)
 {
 	struct inode *inode = entry->d_inode;
-	int err = fuse_revalidate(entry);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	int err = 0;
+
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
+	if (fi->i_time < get_jiffies_64())
+		err = fuse_do_getattr(inode);
+
 	if (!err)
 		generic_fillattr(inode, stat);
 
diff -puN fs/fuse/file.c~fuse-refresh-stale-attributes-in-fuse_permission fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-refresh-stale-attributes-in-fuse_permission
+++ a/fs/fuse/file.c
@@ -106,14 +106,6 @@ int fuse_open_common(struct inode *inode
 	if (err)
 		return err;
 
-	/* If opening the root node, no lookup has been performed on
-	   it, so the attributes must be refreshed */
-	if (get_node_id(inode) == FUSE_ROOT_ID) {
-		err = fuse_do_getattr(inode);
-		if (err)
-		 	return err;
-	}
-
 	ff = fuse_file_alloc();
 	if (!ff)
 		return -ENOMEM;
diff -puN fs/fuse/fuse_i.h~fuse-refresh-stale-attributes-in-fuse_permission fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-refresh-stale-attributes-in-fuse_permission
+++ a/fs/fuse/fuse_i.h
@@ -533,11 +533,6 @@ void request_send_background(struct fuse
 void fuse_abort_conn(struct fuse_conn *fc);
 
 /**
- * Get the attributes of a file
- */
-int fuse_do_getattr(struct inode *inode);
-
-/**
  * Invalidate inode attributes
  */
 void fuse_invalidate_attr(struct inode *inode);
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
