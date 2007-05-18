From: akpm@linux-foundation.org
Subject: + fuse-delete-inode-on-drop.patch added to -mm tree
Date: Fri, 18 May 2007 10:44:29 -0700
Message-ID: <200705181744.l4IHiTi7019963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:53752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbXERRq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: delete inode on drop
has been added to the -mm tree.  Its filename is
     fuse-delete-inode-on-drop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -453,6 +453,7 @@ static const struct super_operations fus
 	.destroy_inode  = fuse_destroy_inode,
 	.read_inode	= fuse_read_inode,
 	.clear_inode	= fuse_clear_inode,
+	.drop_inode	= generic_delete_inode,
 	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-generic_write_checks-for-direct_io.patch
fuse-delete-inode-on-drop.patch
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
