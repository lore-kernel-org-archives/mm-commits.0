From: akpm@linux-foundation.org
Subject: - fuse-cleanup-in-release.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:35 -0700
Message-ID: <200710180703.l9I73ZMW031450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761028AbXJRHPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: cleanup in release
has been removed from the -mm tree.  Its filename was
     fuse-cleanup-in-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: cleanup in release
From: Miklos Szeredi <mszeredi@suse.cz>

Move dput/mntput pair from request_end() to fuse_release_end(), because
there's no other place they are used.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c  |    2 --
 fs/fuse/file.c |    8 ++++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/fuse/dev.c~fuse-cleanup-in-release fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-cleanup-in-release
+++ a/fs/fuse/dev.c
@@ -231,8 +231,6 @@ static void request_end(struct fuse_conn
 		fc->num_background--;
 	}
 	spin_unlock(&fc->lock);
-	dput(req->dentry);
-	mntput(req->vfsmount);
 	wake_up(&req->waitq);
 	if (end)
 		end(fc, req);
diff -puN fs/fuse/file.c~fuse-cleanup-in-release fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-cleanup-in-release
+++ a/fs/fuse/file.c
@@ -71,11 +71,19 @@ static struct fuse_file *fuse_file_get(s
 	return ff;
 }
 
+static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	dput(req->dentry);
+	mntput(req->vfsmount);
+	fuse_put_request(fc, req);
+}
+
 static void fuse_file_put(struct fuse_file *ff)
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
 		struct fuse_conn *fc = get_fuse_conn(req->dentry->d_inode);
+		req->end = fuse_release_end;
 		request_send_background(fc, req);
 		kfree(ff);
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
