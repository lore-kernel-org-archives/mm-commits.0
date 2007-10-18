From: akpm@linux-foundation.org
Subject: - fuse-set-i_nlink-to-sane-value-after-mount.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:28 -0700
Message-ID: <200710180703.l9I73STF031441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761887AbXJRHPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: set i_nlink to sane value after mount
has been removed from the -mm tree.  Its filename was
     fuse-set-i_nlink-to-sane-value-after-mount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: set i_nlink to sane value after mount
From: Miklos Szeredi <mszeredi@suse.cz>

Aufs seems to depend on a positive i_nlink value.  So fill in a dummy but sane
value for the root inode at mount time.

The inode attributes are refreshed with the correct values at the first
opportunity.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fuse/inode.c~fuse-set-i_nlink-to-sane-value-after-mount fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-set-i_nlink-to-sane-value-after-mount
+++ a/fs/fuse/inode.c
@@ -472,6 +472,7 @@ static struct inode *get_root_inode(stru
 
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
+	attr.nlink = 1;
 	return fuse_iget(sb, 1, 0, &attr);
 }
 
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
