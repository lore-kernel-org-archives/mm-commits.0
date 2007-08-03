From: akpm@linux-foundation.org
Subject: + fuse-truncate-on-spontaneous-size-change.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:54:58 -0700
Message-ID: <200708032254.l73MswBB031761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763028AbXHCWzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: truncate on spontaneous size change
has been added to the -mm tree.  Its filename is
     fuse-truncate-on-spontaneous-size-change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: truncate on spontaneous size change
From: Miklos Szeredi <mszeredi@suse.cz>

Memory mappings were only truncated on an explicit truncate, but not when the
file size was changed externally.

Fix this by moving the truncation code from fuse_setattr to
fuse_change_attributes.

Yes, there are races between write and and external truncation, but we can't
really do anything about them.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c   |   46 +++++++++++++---------------------------------
 fs/fuse/inode.c |   25 ++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 38 deletions(-)

diff -puN fs/fuse/dir.c~fuse-truncate-on-spontaneous-size-change fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-truncate-on-spontaneous-size-change
+++ a/fs/fuse/dir.c
@@ -980,23 +980,6 @@ static void iattr_to_fattr(struct iattr 
 	}
 }
 
-static void fuse_vmtruncate(struct inode *inode, loff_t offset)
-{
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	int need_trunc;
-
-	spin_lock(&fc->lock);
-	need_trunc = inode->i_size > offset;
-	i_size_write(inode, offset);
-	spin_unlock(&fc->lock);
-
-	if (need_trunc) {
-		struct address_space *mapping = inode->i_mapping;
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-		truncate_inode_pages(mapping, offset);
-	}
-}
-
 /*
  * Set attributes, and at the same time refresh them.
  *
@@ -1014,7 +997,6 @@ static int fuse_setattr(struct dentry *e
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
 	int err;
-	int is_truncate = 0;
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
@@ -1024,7 +1006,6 @@ static int fuse_setattr(struct dentry *e
 
 	if (attr->ia_valid & ATTR_SIZE) {
 		unsigned long limit;
-		is_truncate = 1;
 		if (IS_SWAPFILE(inode))
 			return -ETXTBSY;
 		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
@@ -1051,21 +1032,20 @@ static int fuse_setattr(struct dentry *e
 	request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err) {
-		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
-			err = -EIO;
-		} else {
-			if (is_truncate)
-				fuse_vmtruncate(inode, outarg.attr.size);
-			fuse_change_attributes(inode, &outarg.attr);
-			fi->i_time = time_to_jiffies(outarg.attr_valid,
-						     outarg.attr_valid_nsec);
-		}
-	} else if (err == -EINTR)
-		fuse_invalidate_attr(inode);
+	if (err) {
+		if (err == -EINTR)
+			fuse_invalidate_attr(inode);
+		return err;
+	}
 
-	return err;
+	if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		make_bad_inode(inode);
+		return -EIO;
+	}
+
+	fuse_change_attributes(inode, &outarg.attr);
+	fi->i_time = time_to_jiffies(outarg.attr_valid, outarg.attr_valid_nsec);
+	return 0;
 }
 
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
diff -puN fs/fuse/inode.c~fuse-truncate-on-spontaneous-size-change fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-truncate-on-spontaneous-size-change
+++ a/fs/fuse/inode.c
@@ -109,20 +109,24 @@ static int fuse_remount_fs(struct super_
 	return 0;
 }
 
+static void fuse_truncate(struct address_space *mapping, loff_t offset)
+{
+	/* See vmtruncate() */
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(mapping, offset);
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+}
+
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	if (S_ISREG(inode->i_mode) && i_size_read(inode) != attr->size)
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
 	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
-	spin_lock(&fc->lock);
-	i_size_write(inode, attr->size);
-	spin_unlock(&fc->lock);
 	inode->i_blocks  = attr->blocks;
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
@@ -130,6 +134,17 @@ void fuse_change_attributes(struct inode
 	inode->i_mtime.tv_nsec  = attr->mtimensec;
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
+
+	spin_lock(&fc->lock);
+	oldsize = inode->i_size;
+	i_size_write(inode, attr->size);
+	spin_unlock(&fc->lock);
+
+	if (S_ISREG(inode->i_mode) && oldsize != attr->size) {
+		if (attr->size < oldsize)
+			fuse_truncate(inode->i_mapping, attr->size);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	}
 }
 
 static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
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
