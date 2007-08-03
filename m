From: akpm@linux-foundation.org
Subject: + fuse-no-enoent-from-fuse-device-read.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:12 -0700
Message-ID: <200708032255.l73MtCAM031791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763527AbXHCWzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: no ENOENT from fuse device read
has been added to the -mm tree.  Its filename is
     fuse-no-enoent-from-fuse-device-read.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 5 insertions(+), 4 deletions(-)

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
