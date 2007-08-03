From: akpm@linux-foundation.org
Subject: + fuse-update-backing_dev_info-congestion-state.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:54:52 -0700
Message-ID: <200708032254.l73MsqtC031749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671AbXHCWzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: update backing_dev_info congestion state
has been added to the -mm tree.  Its filename is
     fuse-update-backing_dev_info-congestion-state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
