From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:28 -0800
Message-ID: <200711052307.lA5N7SnC024361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbXKEXJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix sys_mknodat breakage from r/o bind mounts
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch

This patch was dropped because an updated version will be merged

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
@@ -1984,7 +1984,7 @@ asmlinkage long sys_mknodat(int dfd, con
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

fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
