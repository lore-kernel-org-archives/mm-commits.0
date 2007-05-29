From: akpm@linux-foundation.org
Subject: - fuse-delete-inode-on-drop.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:46 -0700
Message-ID: <200705291851.l4TIpj7v008358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508AbXE2SwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: delete inode on drop
has been removed from the -mm tree.  Its filename was
     fuse-delete-inode-on-drop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: delete inode on drop
From: Miklos Szeredi <mszeredi@suse.cz>

When inode is dropped (no more references) delete it from cache.

There's not much point in keeping it cached, when a new lookup will refresh
the attributes anyway.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/fuse/inode.c~fuse-delete-inode-on-drop fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-delete-inode-on-drop
+++ a/fs/fuse/inode.c
@@ -454,6 +454,7 @@ static const struct super_operations fus
 	.destroy_inode  = fuse_destroy_inode,
 	.read_inode	= fuse_read_inode,
 	.clear_inode	= fuse_clear_inode,
+	.drop_inode	= generic_delete_inode,
 	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,
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
