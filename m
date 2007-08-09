From: akpm@linux-foundation.org
Subject: + vfs-check-nanoseconds-in-utimensat.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:31:31 -0700
Message-ID: <200708092131.l79LVVOg020566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbXHIVcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, drepper@redhat.com


The patch titled
     VFS: check nanoseconds in utimensat
has been added to the -mm tree.  Its filename is
     vfs-check-nanoseconds-in-utimensat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 13 insertions(+)

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

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
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
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
fuse-fix-setting-i_mode-bits.patch
fuse-clean-up-execute-permission-checking.patch
clean-out-unused-code-in-dentry-pruning.patch
uml-remove-unnecessary-hostfs_getattr.patch
fix-warnings-in-revoked_inodec.patch
