From: akpm@linux-foundation.org
Subject: + uml-remove-unnecessary-hostfs_getattr.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:35:35 -0700
Message-ID: <200708092135.l79LZZdh020738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbXHIVfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jdike@addtoit.com


The patch titled
     UML: remove unnecessary hostfs_getattr()
has been added to the -mm tree.  Its filename is
     uml-remove-unnecessary-hostfs_getattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UML: remove unnecessary hostfs_getattr()
From: Miklos Szeredi <mszeredi@suse.cz>

Currently hostfs_getattr() just defines the default behavior.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    9 ---------
 1 files changed, 9 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-remove-unnecessary-hostfs_getattr fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-remove-unnecessary-hostfs_getattr
+++ a/fs/hostfs/hostfs_kern.c
@@ -874,13 +874,6 @@ int hostfs_setattr(struct dentry *dentry
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
@@ -892,7 +885,6 @@ static const struct inode_operations hos
 	.rename		= hostfs_rename,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
-	.getattr	= hostfs_getattr,
 };
 
 static const struct inode_operations hostfs_dir_iops = {
@@ -907,7 +899,6 @@ static const struct inode_operations hos
 	.rename		= hostfs_rename,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
-	.getattr	= hostfs_getattr,
 };
 
 int hostfs_link_readpage(struct file *file, struct page *page)
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
fix-warnings-in-revoked_inodec.patch
