From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-for-do_utimes.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:03 -0800
Message-ID: <200802152249.m1FMn35f028168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934167AbYBOWti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, Valdis.Kletnieks@vt.edu, balbir@in.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: elevate write count for do_utimes()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-for-do_utimes.patch

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
Subject: r/o bind mounts: elevate write count for do_utimes()
From: Dave Hansen <haveblue@us.ibm.com>

Now includes fix for oops seen by akpm.

"never let a libc developer write your kernel code" - hch

"nor, apparently, a kernel developer" - akpm

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
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
 
 		dentry = nd.path.dentry;
+		mnt = nd.path.mnt;
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
