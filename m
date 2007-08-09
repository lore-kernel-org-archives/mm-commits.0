From: akpm@linux-foundation.org
Subject: + fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:33:49 -0700
Message-ID: <200708092133.l79LXn4p020695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbXHIVe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix setting i_mode bits
has been added to the -mm tree.  Its filename is
     fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix setting i_mode bits
From: Miklos Szeredi <mszeredi@suse.cz>

The patch titled "fuse: fix permission checking on sticky directories" removed
all but the S_IFMT bits from i_mode.

However some of these are unfortunately used by the VFS, such as the execute,
suid and sgid bits.

So only remove the sticky bit, which is used for checking deletion from a
directory.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits
+++ a/fs/fuse/inode.c
@@ -124,14 +124,7 @@ void fuse_change_attributes(struct inode
 	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
-	fi->orig_i_mode  = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
-	/*
-	 * Don't set the mode bits in i_mode, unless we want the VFS
-	 * to check permissions.  This prevents failures due to the
-	 * sticky bit check in may_delete().
-	 */
-	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
-		inode->i_mode = fi->orig_i_mode;
+	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
@@ -143,6 +136,15 @@ void fuse_change_attributes(struct inode
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
+	/*
+	 * Don't set the sticky bit in i_mode, unless we want the VFS
+	 * to check permissions.  This prevents failures due to the
+	 * check in may_delete().
+	 */
+	fi->orig_i_mode = inode->i_mode;
+	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
+		inode->i_mode &= ~S_ISVTX;
+
 	spin_lock(&fc->lock);
 	oldsize = inode->i_size;
 	i_size_write(inode, attr->size);
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
fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-clean-up-execute-permission-checking.patch
clean-out-unused-code-in-dentry-pruning.patch
uml-remove-unnecessary-hostfs_getattr.patch
fix-warnings-in-revoked_inodec.patch
