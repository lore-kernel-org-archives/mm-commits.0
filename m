From: akpm@linux-foundation.org
Subject: + fuse-no-abort-on-interrupt.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:10 -0700
Message-ID: <200708032255.l73MtAHm031788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763546AbXHCWzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: no abort on interrupt
has been added to the -mm tree.  Its filename is
     fuse-no-abort-on-interrupt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 24 insertions(+), 19 deletions(-)

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
