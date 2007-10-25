From: akpm@linux-foundation.org
Subject: + fuse-fix-reading-past-eof.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:22:23 -0700
Message-ID: <200710250322.l9P3MNAI029292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbXJYDXC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:23:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix reading past EOF
has been added to the -mm tree.  Its filename is
     fuse-fix-reading-past-eof.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix reading past EOF
From: Miklos Szeredi <mszeredi@suse.cz>

Currently reading a fuse file will stop at cached i_size and return
EOF, even though the file might have grown since the attributes were
last updated.

So detect if trying to read past EOF, and refresh the attributes
before continuing with the read.

Thanks to mpb for the report.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |   48 +++++++++++++++++++++++++++------------------
 fs/fuse/file.c   |   21 ++++++++++++++++++-
 fs/fuse/fuse_i.h |    3 ++
 3 files changed, 52 insertions(+), 20 deletions(-)

diff -puN fs/fuse/dir.c~fuse-fix-reading-past-eof fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-reading-past-eof
+++ a/fs/fuse/dir.c
@@ -775,6 +775,31 @@ static int fuse_do_getattr(struct inode 
 	return err;
 }
 
+int fuse_update_attributes(struct inode *inode, struct kstat *stat,
+			   struct file *file, bool *refreshed)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	int err;
+	bool r;
+
+	if (fi->i_time < get_jiffies_64()) {
+		r = true;
+		err = fuse_do_getattr(inode, stat, file);
+	} else {
+		r = false;
+		err = 0;
+		if (stat) {
+			generic_fillattr(inode, stat);
+			stat->mode = fi->orig_i_mode;
+		}
+	}
+
+	if (refreshed != NULL)
+		*refreshed = r;
+
+	return err;
+}
+
 /*
  * Calling into a user-controlled filesystem gives the filesystem
  * daemon ptrace-like capabilities over the requester process.  This
@@ -862,14 +887,9 @@ static int fuse_permission(struct inode 
 	 */
 	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
-		struct fuse_inode *fi = get_fuse_inode(inode);
-		if (fi->i_time < get_jiffies_64()) {
-			err = fuse_do_getattr(inode, NULL, NULL);
-			if (err)
-				return err;
-
-			refreshed = true;
-		}
+		err = fuse_update_attributes(inode, NULL, NULL, &refreshed);
+		if (err)
+			return err;
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
@@ -1173,22 +1193,12 @@ static int fuse_getattr(struct vfsmount 
 			struct kstat *stat)
 {
 	struct inode *inode = entry->d_inode;
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	int err;
 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	if (fi->i_time < get_jiffies_64())
-		err = fuse_do_getattr(inode, stat, NULL);
-	else {
-		err = 0;
-		generic_fillattr(inode, stat);
-		stat->mode = fi->orig_i_mode;
-	}
-
-	return err;
+	return fuse_update_attributes(inode, stat, NULL, NULL);
 }
 
 static int fuse_setxattr(struct dentry *entry, const char *name,
diff -puN fs/fuse/file.c~fuse-fix-reading-past-eof fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-reading-past-eof
+++ a/fs/fuse/file.c
@@ -453,6 +453,25 @@ out:
 	return err;
 }
 
+static ssize_t fuse_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
+				  unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+
+	if (pos + iov_length(iov, nr_segs) > i_size_read(inode)) {
+		int err;
+		/*
+		 * If trying to read past EOF, make sure the i_size
+		 * attribute is up-to-date.
+		 */
+		err = fuse_update_attributes(inode, NULL, iocb->ki_filp, NULL);
+		if (err)
+			return err;
+	}
+
+	return generic_file_aio_read(iocb, iov, nr_segs, pos);
+}
+
 static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
 			    struct inode *inode, loff_t pos, size_t count,
 			    int writepage)
@@ -887,7 +906,7 @@ static sector_t fuse_bmap(struct address
 static const struct file_operations fuse_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.aio_read	= fuse_file_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= fuse_file_mmap,
diff -puN fs/fuse/fuse_i.h~fuse-fix-reading-past-eof fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-reading-past-eof
+++ a/fs/fuse/fuse_i.h
@@ -593,3 +593,6 @@ int fuse_valid_type(int m);
 int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
 
 u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
+
+int fuse_update_attributes(struct inode *inode, struct kstat *stat,
+			   struct file *file, bool *refreshed);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-fuse_file_alloc-fix-null-dereferences.patch
fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
