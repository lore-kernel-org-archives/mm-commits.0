From: akpm@linux-foundation.org
Subject: + fuse-fix-allowing-operations.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:55:18 -0700
Message-ID: <200710042255.l94MtIlT032602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892AbXJDWzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix allowing operations
has been added to the -mm tree.  Its filename is
     fuse-fix-allowing-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix allowing operations
From: Miklos Szeredi <mszeredi@suse.cz>

The following operation didn't check if sending the request was allowed:

  setattr
  listxattr
  statfs

Some other operations don't explicitly do the check, but VFS calls
->permission() which checks this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-fix-allowing-operations fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-allowing-operations
+++ a/fs/fuse/dir.c
@@ -721,7 +721,7 @@ static int fuse_refresh_attributes(struc
  * for which the owner of the mount has ptrace privilege.  This
  * excludes processes started by other users, suid or sgid processes.
  */
-static int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
+int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 {
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
@@ -1005,6 +1005,9 @@ static int fuse_setattr(struct dentry *e
 	struct fuse_attr_out outarg;
 	int err;
 
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
 		if (err)
@@ -1172,6 +1175,9 @@ static ssize_t fuse_listxattr(struct den
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
 	if (fc->no_listxattr)
 		return -EOPNOTSUPP;
 
diff -puN fs/fuse/fuse_i.h~fuse-fix-allowing-operations fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-allowing-operations
+++ a/fs/fuse/fuse_i.h
@@ -565,3 +565,8 @@ void fuse_ctl_remove_conn(struct fuse_co
  * Is file type valid?
  */
 int fuse_valid_type(int m);
+
+/**
+ * Is task allowed to perform filesystem operation?
+ */
+int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
diff -puN fs/fuse/inode.c~fuse-fix-allowing-operations fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-allowing-operations
+++ a/fs/fuse/inode.c
@@ -287,6 +287,11 @@ static int fuse_statfs(struct dentry *de
 	struct fuse_statfs_out outarg;
 	int err;
 
+	if (!fuse_allow_task(fc, current)) {
+		buf->f_type = FUSE_SUPER_MAGIC;
+		return 0;
+	}
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
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
