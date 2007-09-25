From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch added to -mm tree
Date: Tue, 25 Sep 2007 16:46:46 -0700
Message-ID: <200709252346.l8PNkkEu010365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379AbXIYXrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 19:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, haveblue@us.ibm.com


The patch titled
     fix sys_mknodat breakage from r/o bind mounts
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sys_mknodat breakage from r/o bind mounts
From: Miklos Szeredi <mszeredi@suse.cz>

mknod("foo", 0644) returns EINVAL, even though it should succeed.

The responsible patch is this:

r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix
+++ a/fs/namei.c
@@ -1982,7 +1982,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		goto out_dput;
 	}
 	if (!S_ISREG(mode)  && !S_ISCHR(mode)  && !S_ISBLK(mode) &&
-	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && mode != 0) {
+	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && (mode & S_IFMT) != 0) {
 		error = -EINVAL;
 		goto out_dput;
 	}
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
