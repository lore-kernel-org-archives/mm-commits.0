From: akpm@linux-foundation.org
Subject: + exec-remove-unnecessary-check-for-mnt_noexec.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:32:51 -0700
Message-ID: <200708092132.l79LWpv0020589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbXHIVdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     exec: remove unnecessary check for MNT_NOEXEC
has been added to the -mm tree.  Its filename is
     exec-remove-unnecessary-check-for-mnt_noexec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/exec.c~exec-remove-unnecessary-check-for-mnt_noexec fs/exec.c
--- a/fs/exec.c~exec-remove-unnecessary-check-for-mnt_noexec
+++ a/fs/exec.c
@@ -113,9 +113,6 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto out;
 
-	error = -EACCES;
-	if (nd.mnt->mnt_flags & MNT_NOEXEC)
-		goto exit;
 	error = -EINVAL;
 	if (!S_ISREG(nd.dentry->d_inode->i_mode))
 		goto exit;
@@ -659,8 +656,7 @@ struct file *open_exec(const char *name)
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

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
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
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-fix-setting-i_mode-bits.patch
fuse-clean-up-execute-permission-checking.patch
clean-out-unused-code-in-dentry-pruning.patch
uml-remove-unnecessary-hostfs_getattr.patch
fix-warnings-in-revoked_inodec.patch
