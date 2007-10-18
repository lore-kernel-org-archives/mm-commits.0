From: akpm@linux-foundation.org
Subject: - fuse-update-backing_dev_info-congestion-state.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:18 -0700
Message-ID: <200710180703.l9I73IGJ031421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762881AbXJRHPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: update backing_dev_info congestion state
has been removed from the -mm tree.  Its filename was
     fuse-update-backing_dev_info-congestion-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: update backing_dev_info congestion state
From: Miklos Szeredi <mszeredi@suse.cz>

Set the read and write congestion state if the request queue is close to
blocking, and clear it when it's not.

This prevents unnecessary blocking in readahead and (when writable mmaps are
allowed) writeback.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c    |    8 ++++++++
 fs/fuse/fuse_i.h |    5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/fuse/dev.c~fuse-update-backing_dev_info-congestion-state fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-update-backing_dev_info-congestion-state
+++ a/fs/fuse/dev.c
@@ -224,6 +224,10 @@ static void request_end(struct fuse_conn
 			fc->blocked = 0;
 			wake_up_all(&fc->blocked_waitq);
 		}
+		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+			clear_bdi_congested(&fc->bdi, READ);
+			clear_bdi_congested(&fc->bdi, WRITE);
+		}
 		fc->num_background--;
 	}
 	spin_unlock(&fc->lock);
@@ -378,6 +382,10 @@ static void request_send_nowait(struct f
 		fc->num_background++;
 		if (fc->num_background == FUSE_MAX_BACKGROUND)
 			fc->blocked = 1;
+		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+			set_bdi_congested(&fc->bdi, READ);
+			set_bdi_congested(&fc->bdi, WRITE);
+		}
 
 		queue_request(fc, req);
 		spin_unlock(&fc->lock);
diff -puN fs/fuse/fuse_i.h~fuse-update-backing_dev_info-congestion-state fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-update-backing_dev_info-congestion-state
+++ a/fs/fuse/fuse_i.h
@@ -20,7 +20,10 @@
 #define FUSE_MAX_PAGES_PER_REQ 32
 
 /** Maximum number of outstanding background requests */
-#define FUSE_MAX_BACKGROUND 10
+#define FUSE_MAX_BACKGROUND 12
+
+/** Congestion starts at 75% of maximum */
+#define FUSE_CONGESTION_THRESHOLD (FUSE_MAX_BACKGROUND * 75 / 100)
 
 /** It could be as large as PATH_MAX, but would that have any uses? */
 #define FUSE_NAME_MAX 1024
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
