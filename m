From: akpm@linux-foundation.org
Subject: - fuse-fix-reserved-request-wake-up.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:20 -0700
Message-ID: <200710180703.l9I73K3J031424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760154AbXJRHPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix reserved request wake up
has been removed from the -mm tree.  Its filename was
     fuse-fix-reserved-request-wake-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix reserved request wake up
From: Miklos Szeredi <mszeredi@suse.cz>

Use wake_up_all instead of wake_up in put_reserved_req(), otherwise it is
possible that the right task is not woken up.

Also create a separate reserved_req_waitq in addition to the blocked_waitq,
since they fulfill totally separate functions.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c    |    4 ++--
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/fuse/dev.c~fuse-fix-reserved-request-wake-up fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-fix-reserved-request-wake-up
+++ a/fs/fuse/dev.c
@@ -129,7 +129,7 @@ static struct fuse_req *get_reserved_req
 	struct fuse_file *ff = file->private_data;
 
 	do {
-		wait_event(fc->blocked_waitq, ff->reserved_req);
+		wait_event(fc->reserved_req_waitq, ff->reserved_req);
 		spin_lock(&fc->lock);
 		if (ff->reserved_req) {
 			req = ff->reserved_req;
@@ -155,7 +155,7 @@ static void put_reserved_req(struct fuse
 	fuse_request_init(req);
 	BUG_ON(ff->reserved_req);
 	ff->reserved_req = req;
-	wake_up(&fc->blocked_waitq);
+	wake_up_all(&fc->reserved_req_waitq);
 	spin_unlock(&fc->lock);
 	fput(file);
 }
diff -puN fs/fuse/fuse_i.h~fuse-fix-reserved-request-wake-up fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-reserved-request-wake-up
+++ a/fs/fuse/fuse_i.h
@@ -289,6 +289,9 @@ struct fuse_conn {
 	/** waitq for blocked connection */
 	wait_queue_head_t blocked_waitq;
 
+	/** waitq for reserved requests */
+	wait_queue_head_t reserved_req_waitq;
+
 	/** The next unique request id */
 	u64 reqctr;
 
diff -puN fs/fuse/inode.c~fuse-fix-reserved-request-wake-up fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-reserved-request-wake-up
+++ a/fs/fuse/inode.c
@@ -232,6 +232,7 @@ static void fuse_put_super(struct super_
 	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
 	wake_up_all(&fc->waitq);
 	wake_up_all(&fc->blocked_waitq);
+	wake_up_all(&fc->reserved_req_waitq);
 	mutex_lock(&fuse_mutex);
 	list_del(&fc->entry);
 	fuse_ctl_remove_conn(fc);
@@ -410,6 +411,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->count, 1);
 		init_waitqueue_head(&fc->waitq);
 		init_waitqueue_head(&fc->blocked_waitq);
+		init_waitqueue_head(&fc->reserved_req_waitq);
 		INIT_LIST_HEAD(&fc->pending);
 		INIT_LIST_HEAD(&fc->processing);
 		INIT_LIST_HEAD(&fc->io);
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
