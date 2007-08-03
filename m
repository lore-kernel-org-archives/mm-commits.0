From: akpm@linux-foundation.org
Subject: + fuse-cleanup-in-release.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:08 -0700
Message-ID: <200708032255.l73Mt8vd031785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763449AbXHCWzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: cleanup in release
has been added to the -mm tree.  Its filename is
     fuse-cleanup-in-release.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
