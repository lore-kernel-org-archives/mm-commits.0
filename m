From: akpm@linux-foundation.org
Subject: - exec-remove-unnecessary-check-for-mnt_noexec.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:06 -0700
Message-ID: <200710180656.l9I6u6ZZ030675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760017AbXJRH3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     exec: remove unnecessary check for MNT_NOEXEC
has been removed from the -mm tree.  Its filename was
     exec-remove-unnecessary-check-for-mnt_noexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: exec: remove unnecessary check for MNT_NOEXEC
From: Miklos Szeredi <mszeredi@suse.cz>

vfs_permission(MAY_EXEC) checks if the filesystem is mounted with "noexec", so
there's no need to repeat this check in sys_uselib() and open_exec().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/exec.c~exec-remove-unnecessary-check-for-mnt_noexec fs/exec.c
--- a/fs/exec.c~exec-remove-unnecessary-check-for-mnt_noexec
+++ a/fs/exec.c
@@ -112,9 +112,6 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto out;
 
-	error = -EACCES;
-	if (nd.mnt->mnt_flags & MNT_NOEXEC)
-		goto exit;
 	error = -EINVAL;
 	if (!S_ISREG(nd.dentry->d_inode->i_mode))
 		goto exit;
@@ -658,8 +655,7 @@ struct file *open_exec(const char *name)
 	if (!err) {
 		struct inode *inode = nd.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
-		if (!(nd.mnt->mnt_flags & MNT_NOEXEC) &&
-		    S_ISREG(inode->i_mode)) {
+		if (S_ISREG(inode->i_mode)) {
 			int err = vfs_permission(&nd, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {
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
