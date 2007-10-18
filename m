From: akpm@linux-foundation.org
Subject: - vfs-check-nanoseconds-in-utimensat.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:02 -0700
Message-ID: <200710180656.l9I6u2EH030669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755334AbXJRHUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, drepper@redhat.com, mm-commits@vger.kernel.org


The patch titled
     VFS: check nanoseconds in utimensat
has been removed from the -mm tree.  Its filename was
     vfs-check-nanoseconds-in-utimensat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VFS: check nanoseconds in utimensat
From: Miklos Szeredi <mszeredi@suse.cz>

utimensat() (and possibly other callers of do_utimes()) didn't check if the
nanosecond value was within the allowed range.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/utimes.c~vfs-check-nanoseconds-in-utimensat fs/utimes.c
--- a/fs/utimes.c~vfs-check-nanoseconds-in-utimensat
+++ a/fs/utimes.c
@@ -38,6 +38,14 @@ asmlinkage long sys_utime(char __user *f
 
 #endif
 
+static bool nsec_valid(long nsec)
+{
+	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
+		return true;
+
+	return nsec >= 0 && nsec <= 999999999;
+}
+
 /* If times==NULL, set access and modification to current time,
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
@@ -52,6 +60,11 @@ long do_utimes(int dfd, char __user *fil
 	struct file *f = NULL;
 
 	error = -EINVAL;
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		goto out;
+	}
+
 	if (flags & ~AT_SYMLINK_NOFOLLOW)
 		goto out;
 
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
