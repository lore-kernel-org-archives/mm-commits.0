From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-do_utimes.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:16 -0800
Message-ID: <200802150531.m1F5VGCf021762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbYBOFcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:32:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org, balbir@in.ibm.com, hch@infradead.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts: elevate write count for do_utimes
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-do_utimes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r-o-bind-mounts: elevate write count for do_utimes
From: Dave Hansen <haveblue@us.ibm.com>

Now includes fix for oops seen by akpm.

"never let a libc developer write your kernel code" - hch

"nor, apparently, a kernel developer" - akpm

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN fs/utimes.c~r-o-bind-mounts-elevate-write-count-for-do_utimes fs/utimes.c
--- a/fs/utimes.c~r-o-bind-mounts-elevate-write-count-for-do_utimes
+++ a/fs/utimes.c
@@ -2,6 +2,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
@@ -59,6 +60,7 @@ long do_utimes(int dfd, char __user *fil
 	struct inode *inode;
 	struct iattr newattrs;
 	struct file *f = NULL;
+	struct vfsmount *mnt;
 
 	error = -EINVAL;
 	if (times && (!nsec_valid(times[0].tv_nsec) ||
@@ -79,18 +81,20 @@ long do_utimes(int dfd, char __user *fil
 		if (!f)
 			goto out;
 		dentry = f->f_path.dentry;
+		mnt = f->f_path.mnt;
 	} else {
 		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
 		if (error)
 			goto out;
 
 		dentry = nd.dentry;
+		mnt = nd.mnt;
 	}
 
 	inode = dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(mnt);
+	if (error)
 		goto dput_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
@@ -98,7 +102,7 @@ long do_utimes(int dfd, char __user *fil
 	if (times) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
@@ -118,22 +122,24 @@ long do_utimes(int dfd, char __user *fil
 	} else {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (!is_owner_or_cap(inode)) {
 			if (f) {
 				if (!(f->f_mode & FMODE_WRITE))
-					goto dput_and_out;
+					goto mnt_drop_write_and_out;
 			} else {
 				error = vfs_permission(&nd, MAY_WRITE);
 				if (error)
-					goto dput_and_out;
+					goto mnt_drop_write_and_out;
 			}
 		}
 	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
+mnt_drop_write_and_out:
+	mnt_drop_write(mnt);
 dput_and_out:
 	if (f)
 		fput(f);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
