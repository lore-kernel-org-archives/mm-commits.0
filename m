From: akpm@linux-foundation.org
Subject: - fuse-fix-page-invalidation.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:26 -0700
Message-ID: <200710180703.l9I73Ql2031438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762643AbXJRHPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix page invalidation
has been removed from the -mm tree.  Its filename was
     fuse-fix-page-invalidation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix page invalidation
From: Miklos Szeredi <mszeredi@suse.cz>

Other than truncate, there are two cases, when fuse tries to get rid
of cached pages:

 a) in open, if KEEP_CACHE flag is not set
 b) in getattr, if file size changed spontaneously

Until now invalidate_mapping_pages() were used, which didn't get rid
of mapped pages.  This is wrong, and becomes more wrong as dirty pages
are introduced.  So instead properly invalidate all pages with
invalidate_inode_pages2().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c  |    2 +-
 fs/fuse/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse-fix-page-invalidation fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-page-invalidation
+++ a/fs/fuse/file.c
@@ -87,7 +87,7 @@ void fuse_finish_open(struct inode *inod
 	if (outarg->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		invalidate_inode_pages2(inode->i_mapping);
 	ff->fh = outarg->fh;
 	file->private_data = fuse_file_get(ff);
 }
diff -puN fs/fuse/inode.c~fuse-fix-page-invalidation fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-page-invalidation
+++ a/fs/fuse/inode.c
@@ -143,7 +143,7 @@ void fuse_change_attributes(struct inode
 	if (S_ISREG(inode->i_mode) && oldsize != attr->size) {
 		if (attr->size < oldsize)
 			fuse_truncate(inode->i_mapping, attr->size);
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		invalidate_inode_pages2(inode->i_mapping);
 	}
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
