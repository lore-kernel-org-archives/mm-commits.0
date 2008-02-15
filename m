From: akpm@linux-foundation.org
Subject: + do-namei_flags-calculation-inside-open_namei.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:48:41 -0800
Message-ID: <200802152248.m1FMmghX028124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934156AbYBOWtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:49:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     do namei_flags calculation inside open_namei()
has been added to the -mm tree.  Its filename is
     do-namei_flags-calculation-inside-open_namei.patch

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
Subject: do namei_flags calculation inside open_namei()
From: Dave Hansen <haveblue@us.ibm.com>

My end goal here is to make sure all users of may_open() return filps.  This
will ensure that we properly release mount write counts which were taken for
the filp in may_open().

This patch moves the sys_open flags to namei flags calculation into
fs/namei.c.  We'll shortly be moving the nameidata_to_filp() calls into
namei.c, and this gets the sys_open flags to a place where we can get at them
when we need them.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   43 ++++++++++++++++++++++++++++++++++---------
 fs/open.c  |   22 ++--------------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff -puN fs/namei.c~do-namei_flags-calculation-inside-open_namei fs/namei.c
--- a/fs/namei.c~do-namei_flags-calculation-inside-open_namei
+++ a/fs/namei.c
@@ -1677,7 +1677,12 @@ int may_open(struct nameidata *nd, int a
 	return 0;
 }
 
-static int open_namei_create(struct nameidata *nd, struct path *path,
+/*
+ * Be careful about ever adding any more callers of this
+ * function.  Its flags must be in the namei format, not
+ * what get passed to sys_open().
+ */
+static int __open_namei_create(struct nameidata *nd, struct path *path,
 				int flag, int mode)
 {
 	int error;
@@ -1696,26 +1701,46 @@ static int open_namei_create(struct name
 }
 
 /*
+ * Note that while the flag value (low two bits) for sys_open means:
+ *	00 - read-only
+ *	01 - write-only
+ *	10 - read-write
+ *	11 - special
+ * it is changed into
+ *	00 - no permissions needed
+ *	01 - read-permission
+ *	10 - write-permission
+ *	11 - read-write
+ * for the internal routines (ie open_namei()/follow_link() etc)
+ * This is more logical, and also allows the 00 "no perm needed"
+ * to be used for symlinks (where the permissions are checked
+ * later).
+ *
+*/
+static inline int open_to_namei_flags(int flag)
+{
+	if ((flag+1) & O_ACCMODE)
+		flag++;
+	return flag;
+}
+
+/*
  *	open_namei()
  *
  * namei for open - this is in fact almost the whole open-routine.
  *
  * Note that the low bits of "flag" aren't the same as in the open
- * system call - they are 00 - no permissions needed
- *			  01 - read permission needed
- *			  10 - write permission needed
- *			  11 - read/write permissions needed
- * which is a lot more logical, and also allows the "no perm" needed
- * for symlinks (where the permissions are checked later).
+ * system call.  See open_to_namei_flags().
  * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int flag,
+int open_namei(int dfd, const char *pathname, int open_flag,
 		int mode, struct nameidata *nd)
 {
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
+	int flag = open_to_namei_flags(open_flag);
 
 	acc_mode = ACC_MODE(flag);
 
@@ -1776,7 +1801,7 @@ do_last:
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = open_namei_create(nd, &path, flag, mode);
+		error = __open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
 		return 0;
diff -puN fs/open.c~do-namei_flags-calculation-inside-open_namei fs/open.c
--- a/fs/open.c~do-namei_flags-calculation-inside-open_namei
+++ a/fs/open.c
@@ -796,31 +796,13 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-/*
- * Note that while the flag value (low two bits) for sys_open means:
- *	00 - read-only
- *	01 - write-only
- *	10 - read-write
- *	11 - special
- * it is changed into
- *	00 - no permissions needed
- *	01 - read-permission
- *	10 - write-permission
- *	11 - read-write
- * for the internal routines (ie open_namei()/follow_link() etc). 00 is
- * used by symlinks.
- */
 static struct file *do_filp_open(int dfd, const char *filename, int flags,
 				 int mode)
 {
-	int namei_flags, error;
+	int error;
 	struct nameidata nd;
 
-	namei_flags = flags;
-	if ((namei_flags+1) & O_ACCMODE)
-		namei_flags++;
-
-	error = open_namei(dfd, filename, namei_flags, mode, &nd);
+	error = open_namei(dfd, filename, flags, mode, &nd);
 	if (!error)
 		return nameidata_to_filp(&nd, flags);
 
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
