From: akpm@linux-foundation.org
Subject: + fuse-fix-reserved-request-wake-up.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:54:54 -0700
Message-ID: <200708032254.l73Mss2p031752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761583AbXHCWzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix reserved request wake up
has been added to the -mm tree.  Its filename is
     fuse-fix-reserved-request-wake-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -426,6 +427,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->count, 1);
 		init_waitqueue_head(&fc->waitq);
 		init_waitqueue_head(&fc->blocked_waitq);
+		init_waitqueue_head(&fc->reserved_req_waitq);
 		INIT_LIST_HEAD(&fc->pending);
 		INIT_LIST_HEAD(&fc->processing);
 		INIT_LIST_HEAD(&fc->io);
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
