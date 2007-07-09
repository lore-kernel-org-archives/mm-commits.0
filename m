From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-allow-unprivileged-fuse-mounts-fuse-fix-double-fs_flags-initializer.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:43:20 -0700
Message-ID: <200707092343.l69NhKEq020999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759486AbXGIXnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix double fs_flags initializer
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-allow-unprivileged-fuse-mounts-fuse-fix-double-fs_flags-initializer.patch

This patch was dropped because it was folded into unprivileged-mounts-allow-unprivileged-fuse-mounts.patch

------------------------------------------------------
Subject: fuse: fix double fs_flags initializer
From: Miklos Szeredi <mszeredi@suse.cz>

Thanks to Alexey Dobriyan for spotting the other one.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fuse/inode.c~unprivileged-mounts-allow-unprivileged-fuse-mounts-fuse-fix-double-fs_flags-initializer fs/fuse/inode.c
--- a/fs/fuse/inode.c~unprivileged-mounts-allow-unprivileged-fuse-mounts-fuse-fix-double-fs_flags-initializer
+++ a/fs/fuse/inode.c
@@ -659,10 +659,9 @@ static int fuse_get_sb(struct file_syste
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
-	.fs_flags	= FS_SAFE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_SAFE,
 };
 
 #ifdef CONFIG_BLOCK
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
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
unprivileged-mounts-allow-unprivileged-fuse-mounts-fuse-fix-double-fs_flags-initializer.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
