From: akpm@linux-foundation.org
Subject: - fuse-improve-utimes-support.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:53 -0700
Message-ID: <200710190345.l9J3jrXn013257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763520AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: improve utimes support
has been removed from the -mm tree.  Its filename was
     fuse-improve-utimes-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: improve utimes support
From: Miklos Szeredi <mszeredi@suse.cz>

Add two new flags for setattr: FATTR_ATIME_NOW and FATTR_MTIME_NOW.  These
mean, that atime or mtime should be changed to the current time.

Also it is now possible to update atime or mtime individually, not just
together.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c        |   28 +++++++++++++++++++++++++---
 include/linux/fuse.h |    2 ++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff -puN fs/fuse/dir.c~fuse-improve-utimes-support fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-improve-utimes-support
+++ a/fs/fuse/dir.c
@@ -1014,6 +1014,20 @@ static int fuse_dir_fsync(struct file *f
 	return file ? fuse_fsync_common(file, de, datasync, 1) : 0;
 }
 
+static bool update_mtime(unsigned ivalid)
+{
+	/* Always update if mtime is explicitly set  */
+	if (ivalid & ATTR_MTIME_SET)
+		return true;
+
+	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
+	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
+		return false;
+
+	/* In all other cases update */
+	return true;
+}
+
 static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg)
 {
 	unsigned ivalid = iattr->ia_valid;
@@ -1026,11 +1040,19 @@ static void iattr_to_fattr(struct iattr 
 		arg->valid |= FATTR_GID,    arg->gid = iattr->ia_gid;
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
-	/* You can only _set_ these together (they may change by themselves) */
-	if ((ivalid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME)) {
-		arg->valid |= FATTR_ATIME | FATTR_MTIME;
+	if (ivalid & ATTR_ATIME) {
+		arg->valid |= FATTR_ATIME;
 		arg->atime = iattr->ia_atime.tv_sec;
+		arg->atimensec = iattr->ia_atime.tv_nsec;
+		if (!(ivalid & ATTR_ATIME_SET))
+			arg->valid |= FATTR_ATIME_NOW;
+	}
+	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
+		arg->valid |= FATTR_MTIME;
 		arg->mtime = iattr->ia_mtime.tv_sec;
+		arg->mtimensec = iattr->ia_mtime.tv_nsec;
+		if (!(ivalid & ATTR_MTIME_SET))
+			arg->valid |= FATTR_MTIME_NOW;
 	}
 }
 
diff -puN include/linux/fuse.h~fuse-improve-utimes-support include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-improve-utimes-support
+++ a/include/linux/fuse.h
@@ -83,6 +83,8 @@ struct fuse_file_lock {
 #define FATTR_ATIME	(1 << 4)
 #define FATTR_MTIME	(1 << 5)
 #define FATTR_FH	(1 << 6)
+#define FATTR_ATIME_NOW	(1 << 7)
+#define FATTR_MTIME_NOW	(1 << 8)
 
 /**
  * Flags returned by the OPEN request
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
