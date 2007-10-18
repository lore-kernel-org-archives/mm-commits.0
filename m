From: akpm@linux-foundation.org
Subject: - fuse-no-abort-on-interrupt.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:37 -0700
Message-ID: <200710180703.l9I73buc031453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761722AbXJRHPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: no abort on interrupt
has been removed from the -mm tree.  Its filename was
     fuse-no-abort-on-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: no abort on interrupt
From: Miklos Szeredi <mszeredi@suse.cz>

Don't set 'aborted' flag on a request if it's interrupted.  We have to wait
for the answer anyway, and this would only a very little time while copying
the reply.

This means, that write() on the fuse device will not return -ENOENT during
normal operation, only if the filesystem is aborted by a forced umount or
through the fusectl interface.

This could simplify userspace code somewhat when backward compatibility with
earlier kernel versions is not required.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff -puN fs/fuse/dev.c~fuse-no-abort-on-interrupt fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-no-abort-on-interrupt
+++ a/fs/fuse/dev.c
@@ -273,28 +273,41 @@ static void request_wait_answer(struct f
 			queue_interrupt(fc, req);
 	}
 
-	if (req->force) {
-		spin_unlock(&fc->lock);
-		wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
-		spin_lock(&fc->lock);
-	} else {
+	if (!req->force) {
 		sigset_t oldset;
 
 		/* Only fatal signals may interrupt this */
 		block_sigs(&oldset);
 		wait_answer_interruptible(fc, req);
 		restore_sigs(&oldset);
+
+		if (req->aborted)
+			goto aborted;
+		if (req->state == FUSE_REQ_FINISHED)
+			return;
+
+		/* Request is not yet in userspace, bail out */
+		if (req->state == FUSE_REQ_PENDING) {
+			list_del(&req->list);
+			__fuse_put_request(req);
+			req->out.h.error = -EINTR;
+			return;
+		}
 	}
 
-	if (req->aborted)
-		goto aborted;
-	if (req->state == FUSE_REQ_FINISHED)
- 		return;
+	/*
+	 * Either request is already in userspace, or it was forced.
+	 * Wait it out.
+	 */
+	spin_unlock(&fc->lock);
+	wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
+	spin_lock(&fc->lock);
 
-	req->out.h.error = -EINTR;
-	req->aborted = 1;
+	if (!req->aborted)
+		return;
 
  aborted:
+	BUG_ON(req->state != FUSE_REQ_FINISHED);
 	if (req->locked) {
 		/* This is uninterruptible sleep, because data is
 		   being copied to/from the buffers of req.  During
@@ -305,14 +318,6 @@ static void request_wait_answer(struct f
 		wait_event(req->waitq, !req->locked);
 		spin_lock(&fc->lock);
 	}
-	if (req->state == FUSE_REQ_PENDING) {
-		list_del(&req->list);
-		__fuse_put_request(req);
-	} else if (req->state == FUSE_REQ_SENT) {
-		spin_unlock(&fc->lock);
-		wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
-		spin_lock(&fc->lock);
-	}
 }
 
 static unsigned len_args(unsigned numargs, struct fuse_arg *args)
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
