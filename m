From: akpm@linux-foundation.org
Subject: - uml-remove-unnecessary-hostfs_getattr.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:14 -0700
Message-ID: <200710162037.l9GKbEJQ015272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935012AbXJPVJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     UML: remove unnecessary hostfs_getattr()
has been removed from the -mm tree.  Its filename was
     uml-remove-unnecessary-hostfs_getattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UML: remove unnecessary hostfs_getattr()
From: Miklos Szeredi <mszeredi@suse.cz>

Currently hostfs_getattr() just defines the default behavior.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-remove-unnecessary-hostfs_getattr fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-remove-unnecessary-hostfs_getattr
+++ a/fs/hostfs/hostfs_kern.c
@@ -872,13 +872,6 @@ int hostfs_setattr(struct dentry *dentry
 	return inode_setattr(dentry->d_inode, attr);
 }
 
-int hostfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-	   struct kstat *stat)
-{
-	generic_fillattr(dentry->d_inode, stat);
-	return 0;
-}
-
 static const struct inode_operations hostfs_iops = {
 	.create		= hostfs_create,
 	.link		= hostfs_link,
@@ -890,7 +883,6 @@ static const struct inode_operations hos
 	.rename		= hostfs_rename,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
-	.getattr	= hostfs_getattr,
 };
 
 static const struct inode_operations hostfs_dir_iops = {
@@ -905,7 +897,6 @@ static const struct inode_operations hos
 	.rename		= hostfs_rename,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
-	.getattr	= hostfs_getattr,
 };
 
 int hostfs_link_readpage(struct file *file, struct page *page)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
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
