From: akpm@linux-foundation.org
Subject: - fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch removed from -mm tree
Date: Tue, 16 Oct 2007 16:04:57 -0700
Message-ID: <200710162304.l9GN4wU9022407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895AbXJPXFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 19:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix setting i_mode bits
has been removed from the -mm tree.  Its filename was
     fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch

This patch was dropped because it was folded into fuse-fix-permission-checking-on-sticky-directories.patch

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

origin.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
clean-out-unused-code-in-dentry-pruning.patch
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
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
