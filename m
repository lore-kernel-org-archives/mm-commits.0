From: akpm@linux-foundation.org
Subject: - fuse-no-enoent-from-fuse-device-read.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:39 -0700
Message-ID: <200710180703.l9I73dqG031456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762220AbXJRHPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: no ENOENT from fuse device read
has been removed from the -mm tree.  Its filename was
     fuse-no-enoent-from-fuse-device-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: no ENOENT from fuse device read
From: Miklos Szeredi <mszeredi@suse.cz>

Don't return -ENOENT for a read() on the fuse device when the request was
aborted.  Instead return -ENODEV, meaning the filesystem has been
force-umounted or aborted.

Previously ENOENT meant that the request was interrupted, but now the
'aborted' flag is not set in case of interrupts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/fuse/dev.c~fuse-no-enoent-from-fuse-device-read fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-no-enoent-from-fuse-device-read
+++ a/fs/fuse/dev.c
@@ -747,11 +747,12 @@ static ssize_t fuse_dev_read(struct kioc
 	fuse_copy_finish(&cs);
 	spin_lock(&fc->lock);
 	req->locked = 0;
-	if (!err && req->aborted)
-		err = -ENOENT;
+	if (req->aborted) {
+		request_end(fc, req);
+		return -ENODEV;
+	}
 	if (err) {
-		if (!req->aborted)
-			req->out.h.error = -EIO;
+		req->out.h.error = -EIO;
 		request_end(fc, req);
 		return err;
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
