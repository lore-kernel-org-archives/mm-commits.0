From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-write-counts-for-time-functions.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:01 -0800
Message-ID: <200802152249.m1FMn1OO028165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109AbYBOWtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: write counts for time functions
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-write-counts-for-time-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: write counts for time functions
From: Dave Hansen <haveblue@us.ibm.com>

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff -puN fs/inode.c~r-o-bind-mounts-write-counts-for-time-functions fs/inode.c
--- a/fs/inode.c~r-o-bind-mounts-write-counts-for-time-functions
+++ a/fs/inode.c
@@ -1199,42 +1199,37 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (inode->i_flags & S_NOATIME)
+	if (mnt_want_write(mnt))
 		return;
+	if (inode->i_flags & S_NOATIME)
+		goto out;
 	if (IS_NOATIME(inode))
-		return;
+		goto out;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		return;
+		goto out;
 
-	/*
-	 * We may have a NULL vfsmount when coming from NFSD
-	 */
-	if (mnt) {
-		if (mnt->mnt_flags & MNT_NOATIME)
-			return;
-		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-			return;
-
-		if (mnt->mnt_flags & MNT_RELATIME) {
-			/*
-			 * With relative atime, only update atime if the
-			 * previous atime is earlier than either the ctime or
-			 * mtime.
-			 */
-			if (timespec_compare(&inode->i_mtime,
-						&inode->i_atime) < 0 &&
-			    timespec_compare(&inode->i_ctime,
-						&inode->i_atime) < 0)
-				return;
-		}
+	if (mnt->mnt_flags & MNT_NOATIME)
+		goto out;
+	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
+		goto out;
+	if (mnt->mnt_flags & MNT_RELATIME) {
+		/*
+		 * With relative atime, only update atime if the previous
+		 * atime is earlier than either the ctime or mtime.
+		 */
+		if (timespec_compare(&inode->i_mtime, &inode->i_atime) < 0 &&
+		    timespec_compare(&inode->i_ctime, &inode->i_atime) < 0)
+			goto out;
 	}
 
 	now = current_fs_time(inode->i_sb);
 	if (timespec_equal(&inode->i_atime, &now))
-		return;
+		goto out;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
+out:
+	mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
 
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
