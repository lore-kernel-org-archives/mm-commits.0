From: akpm@linux-foundation.org
Subject: + fuse-refresh-stale-attributes-in-fuse_permission.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:04 -0700
Message-ID: <200708032255.l73Mt47p031776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763458AbXHCWzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: refresh stale attributes in fuse_permission()
has been added to the -mm tree.  Its filename is
     fuse-refresh-stale-attributes-in-fuse_permission.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
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
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
