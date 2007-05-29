From: akpm@linux-foundation.org
Subject: - fuse-fix-mknod-of-regular-file.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:31 -0700
Message-ID: <200705291850.l4TIoUMd008267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbXE2SvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fuse: fix mknod of regular file
has been removed from the -mm tree.  Its filename was
     fuse-fix-mknod-of-regular-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix mknod of regular file
From: Miklos Szeredi <mszeredi@suse.cz>

The wrong lookup flag was tested in ->create() causing havoc (error or
Oops) when a regular file was created with mknod() in a fuse filesystem.

Thanks to J. Cameijo Cerdeira for the report.

Kernels 2.6.18 onward are affected.  Please apply to -stable as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fuse/dir.c~fuse-fix-mknod-of-regular-file fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-mknod-of-regular-file
+++ a/fs/fuse/dir.c
@@ -485,7 +485,7 @@ static int fuse_mknod(struct inode *dir,
 static int fuse_create(struct inode *dir, struct dentry *entry, int mode,
 		       struct nameidata *nd)
 {
-	if (nd && (nd->flags & LOOKUP_CREATE)) {
+	if (nd && (nd->flags & LOOKUP_OPEN)) {
 		int err = fuse_create_open(dir, entry, mode, nd);
 		if (err != -ENOSYS)
 			return err;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
