From: akpm@linux-foundation.org
Subject: + fuse-fix-mknod-of-regular-file.patch added to -mm tree
Date: Mon, 21 May 2007 13:51:10 -0700
Message-ID: <200705212051.l4LKpAUB019742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXEUUyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, stable@kernel.org


The patch titled
     fuse: fix mknod of regular file
has been added to the -mm tree.  Its filename is
     fuse-fix-mknod-of-regular-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fuse-fix-mknod-of-regular-file.patch
fuse-generic_write_checks-for-direct_io.patch
fuse-delete-inode-on-drop.patch
fix-unused-setup_nr_node_ids.patch
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
