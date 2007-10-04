From: akpm@linux-foundation.org
Subject: + fuse-clean-up-open-file-passing-in-setattr.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:57:00 -0700
Message-ID: <200710042257.l94Mv0WP032724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760705AbXJDW5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: clean up open file passing in setattr
has been added to the -mm tree.  Its filename is
     fuse-clean-up-open-file-passing-in-setattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: clean up open file passing in setattr
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up supplying open file to the setattr operation.  In addition to being a
cleanup it prepares for the changes in the way the open file is passed to the
setattr method.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-clean-up-open-file-passing-in-setattr fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-clean-up-open-file-passing-in-setattr
+++ a/fs/fuse/dir.c
@@ -1032,11 +1032,6 @@ static void iattr_to_fattr(struct iattr 
 		arg->atime = iattr->ia_atime.tv_sec;
 		arg->mtime = iattr->ia_mtime.tv_sec;
 	}
-	if (ivalid & ATTR_FILE) {
-		struct fuse_file *ff = iattr->ia_file->private_data;
-		arg->valid |= FATTR_FH;
-		arg->fh = ff->fh;
-	}
 }
 
 /*
@@ -1047,7 +1042,8 @@ static void iattr_to_fattr(struct iattr 
  * vmtruncate() doesn't allow for this case, so do the rlimit checking
  * and the actual truncation by hand.
  */
-static int fuse_setattr(struct dentry *entry, struct iattr *attr)
+static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+			   struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1082,6 +1078,11 @@ static int fuse_setattr(struct dentry *e
 
 	memset(&inarg, 0, sizeof(inarg));
 	iattr_to_fattr(attr, &inarg);
+	if (file) {
+		struct fuse_file *ff = file->private_data;
+		inarg.valid |= FATTR_FH;
+		inarg.fh = ff->fh;
+	}
 	req->in.h.opcode = FUSE_SETATTR;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -1108,6 +1109,14 @@ static int fuse_setattr(struct dentry *e
 	return 0;
 }
 
+static int fuse_setattr(struct dentry *entry, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_FILE)
+		return fuse_do_setattr(entry, attr, attr->ia_file);
+	else
+		return fuse_do_setattr(entry, attr, NULL);
+}
+
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
 			struct kstat *stat)
 {
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
