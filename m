From: akpm@linux-foundation.org
Subject: + vfs-allow-filesystems-to-implement-atomic-opentruncate.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:57:03 -0700
Message-ID: <200710042257.l94Mv3uN032733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760791AbXJDW5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, adilger@clusterfs.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     VFS: allow filesystems to implement atomic open+truncate
has been added to the -mm tree.  Its filename is
     vfs-allow-filesystems-to-implement-atomic-opentruncate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: allow filesystems to implement atomic open+truncate
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
initiated by open() due to the O_TRUNC flag".

This way filesystems wanting to implement truncation within their ->open()
method can ignore such truncate requests.

This is a quick & dirty hack, but it comes for free.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/namei.c~vfs-allow-filesystems-to-implement-atomic-opentruncate fs/namei.c
--- a/fs/namei.c~vfs-allow-filesystems-to-implement-atomic-opentruncate
+++ a/fs/namei.c
@@ -1667,8 +1667,10 @@ int may_open(struct nameidata *nd, int a
 		error = locks_verify_locked(inode);
 		if (!error) {
 			DQUOT_INIT(inode);
-			
-			error = do_truncate(dentry, 0, ATTR_MTIME|ATTR_CTIME, NULL);
+
+			error = do_truncate(dentry, 0,
+					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+					    NULL);
 		}
 		put_write_access(inode);
 		if (error)
diff -puN include/linux/fs.h~vfs-allow-filesystems-to-implement-atomic-opentruncate include/linux/fs.h
--- a/include/linux/fs.h~vfs-allow-filesystems-to-implement-atomic-opentruncate
+++ a/include/linux/fs.h
@@ -337,6 +337,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
+#define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
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
