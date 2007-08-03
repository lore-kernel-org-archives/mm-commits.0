From: akpm@linux-foundation.org
Subject: + fuse-fix-page-invalidation.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:00 -0700
Message-ID: <200708032255.l73Mt0kT031764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763303AbXHCWzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix page invalidation
has been added to the -mm tree.  Its filename is
     fuse-fix-page-invalidation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
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
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
