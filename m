From: akpm@linux-foundation.org
Subject: + fuse-add-file-handle-to-getattr-operation.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:56:18 -0700
Message-ID: <200710042256.l94MuI2Z032715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760376AbXJDW4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: add file handle to getattr operation
has been added to the -mm tree.  Its filename is
     fuse-add-file-handle-to-getattr-operation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: add file handle to getattr operation
From: Miklos Szeredi <mszeredi@suse.cz>

Add necessary protocol changes for supplying a file handle with the getattr
operation.  Step the API version to 7.9.

This patch doesn't actually supply the file handle, because that needs some
kind of VFS support, which we haven't yet been able to agree upon.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-add-file-handle-to-getattr-operation fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-file-handle-to-getattr-operation
+++ a/fs/fuse/dir.c
@@ -705,10 +705,12 @@ static void fuse_fillattr(struct inode *
 	stat->blksize = (1 << inode->i_blkbits);
 }
 
-static int fuse_do_getattr(struct inode *inode, struct kstat *stat)
+static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
+			   struct file *file)
 {
 	int err;
-	struct fuse_attr_out arg;
+	struct fuse_getattr_in inarg;
+	struct fuse_attr_out outarg;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 	u64 attr_version;
@@ -721,24 +723,35 @@ static int fuse_do_getattr(struct inode 
 	attr_version = fc->attr_version;
 	spin_unlock(&fc->lock);
 
+	memset(&inarg, 0, sizeof(inarg));
+	/* Directories have separate file-handle space */
+	if (file && S_ISREG(inode->i_mode)) {
+		struct fuse_file *ff = file->private_data;
+
+		inarg.getattr_flags |= FUSE_GETATTR_FH;
+		inarg.fh = ff->fh;
+	}
 	req->in.h.opcode = FUSE_GETATTR;
 	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(arg);
-	req->out.args[0].value = &arg;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
-		if ((inode->i_mode ^ arg.attr.mode) & S_IFMT) {
+		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 			make_bad_inode(inode);
 			err = -EIO;
 		} else {
-			fuse_change_attributes(inode, &arg.attr,
-					       attr_timeout(&arg),
+			fuse_change_attributes(inode, &outarg.attr,
+					       attr_timeout(&outarg),
 					       attr_version);
 			if (stat)
-				fuse_fillattr(inode, &arg.attr, stat);
+				fuse_fillattr(inode, &outarg.attr, stat);
 		}
 	}
 	return err;
@@ -833,7 +846,7 @@ static int fuse_permission(struct inode 
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 		if (fi->i_time < get_jiffies_64()) {
-			err = fuse_do_getattr(inode, NULL);
+			err = fuse_do_getattr(inode, NULL, NULL);
 			if (err)
 				return err;
 
@@ -848,7 +861,7 @@ static int fuse_permission(struct inode 
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
 		if (err == -EACCES && !refreshed) {
-			err = fuse_do_getattr(inode, NULL);
+		 	err = fuse_do_getattr(inode, NULL, NULL);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
 		}
@@ -864,7 +877,7 @@ static int fuse_permission(struct inode 
 			if (refreshed)
 				return -EACCES;
 
-			err = fuse_do_getattr(inode, NULL);
+			err = fuse_do_getattr(inode, NULL, NULL);
 			if (!err && !(inode->i_mode & S_IXUGO))
 				return -EACCES;
 		}
@@ -1107,7 +1120,7 @@ static int fuse_getattr(struct vfsmount 
 		return -EACCES;
 
 	if (fi->i_time < get_jiffies_64())
-		err = fuse_do_getattr(inode, stat);
+		err = fuse_do_getattr(inode, stat, NULL);
 	else {
 		err = 0;
 		generic_fillattr(inode, stat);
diff -puN fs/fuse/inode.c~fuse-add-file-handle-to-getattr-operation fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-file-handle-to-getattr-operation
+++ a/fs/fuse/inode.c
@@ -570,7 +570,7 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff -puN include/linux/fuse.h~fuse-add-file-handle-to-getattr-operation include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-file-handle-to-getattr-operation
+++ a/include/linux/fuse.h
@@ -6,7 +6,14 @@
     See the file COPYING.
 */
 
-/* This file defines the kernel interface of FUSE */
+/*
+ * This file defines the kernel interface of FUSE
+ *
+ * Protocol changelog:
+ *
+ * 7.9:
+ *  - new fuse_getattr_in input argument of GETATTR
+ */
 
 #include <asm/types.h>
 #include <linux/major.h>
@@ -15,7 +22,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 8
+#define FUSE_KERNEL_MINOR_VERSION 9
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -91,12 +98,18 @@ struct fuse_file_lock {
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
+#define FUSE_FILE_OPS		(1 << 2)
 
 /**
  * Release flags
  */
 #define FUSE_RELEASE_FLUSH	(1 << 0)
 
+/**
+ * Getattr flags
+ */
+#define FUSE_GETATTR_FH		(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -154,6 +167,12 @@ struct fuse_forget_in {
 	__u64	nlookup;
 };
 
+struct fuse_getattr_in {
+	__u32	getattr_flags;
+	__u32	dummy;
+	__u64	fh;
+};
+
 struct fuse_attr_out {
 	__u64	attr_valid;	/* Cache timeout for the attributes */
 	__u32	attr_valid_nsec;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
uml-remove-unnecessary-hostfs_getattr.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
clean-out-unused-code-in-dentry-pruning.patch
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
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch
