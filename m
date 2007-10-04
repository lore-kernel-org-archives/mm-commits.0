From: akpm@linux-foundation.org
Subject: + fuse-improve-utimes-support.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:57:07 -0700
Message-ID: <200710042257.l94Mv7Si032736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760714AbXJDW5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: improve utimes support
has been added to the -mm tree.  Its filename is
     fuse-improve-utimes-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: improve utimes support
From: Miklos Szeredi <mszeredi@suse.cz>

Add two new flags for setattr: FATTR_ATIME_NOW and FATTR_MTIME_NOW.  These
mean, that atime or mtime should be changed to the current time.

Also it is now possible to update atime or mtime individually, not just
together.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-improve-utimes-support fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-improve-utimes-support
+++ a/fs/fuse/dir.c
@@ -1014,6 +1014,20 @@ static int fuse_dir_fsync(struct file *f
 	return file ? fuse_fsync_common(file, de, datasync, 1) : 0;
 }
 
+static bool update_mtime(unsigned ivalid)
+{
+	/* Always update if mtime is explicitly set  */
+	if (ivalid & ATTR_MTIME_SET)
+		return true;
+
+	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
+	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
+		return false;
+
+	/* In all other cases update */
+	return true;
+}
+
 static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg)
 {
 	unsigned ivalid = iattr->ia_valid;
@@ -1026,11 +1040,19 @@ static void iattr_to_fattr(struct iattr 
 		arg->valid |= FATTR_GID,    arg->gid = iattr->ia_gid;
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
-	/* You can only _set_ these together (they may change by themselves) */
-	if ((ivalid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME)) {
-		arg->valid |= FATTR_ATIME | FATTR_MTIME;
+	if (ivalid & ATTR_ATIME) {
+		arg->valid |= FATTR_ATIME;
 		arg->atime = iattr->ia_atime.tv_sec;
+		arg->atimensec = iattr->ia_atime.tv_nsec;
+		if (!(ivalid & ATTR_ATIME_SET))
+			arg->valid |= FATTR_ATIME_NOW;
+	}
+	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
+		arg->valid |= FATTR_MTIME;
 		arg->mtime = iattr->ia_mtime.tv_sec;
+		arg->mtimensec = iattr->ia_mtime.tv_nsec;
+		if (!(ivalid & ATTR_MTIME_SET))
+			arg->valid |= FATTR_MTIME_NOW;
 	}
 }
 
diff -puN include/linux/fuse.h~fuse-improve-utimes-support include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-improve-utimes-support
+++ a/include/linux/fuse.h
@@ -83,6 +83,8 @@ struct fuse_file_lock {
 #define FATTR_ATIME	(1 << 4)
 #define FATTR_MTIME	(1 << 5)
 #define FATTR_FH	(1 << 6)
+#define FATTR_ATIME_NOW	(1 << 7)
+#define FATTR_MTIME_NOW	(1 << 8)
 
 /**
  * Flags returned by the OPEN request
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
