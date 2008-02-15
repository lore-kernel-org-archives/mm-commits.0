From: akpm@linux-foundation.org
Subject: - make-open_namei-return-a-filp.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:30:57 -0800
Message-ID: <200802150530.m1F5UvHk021709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbYBOFbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:31:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     make open_namei() return a filp
has been removed from the -mm tree.  Its filename was
     make-open_namei-return-a-filp.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make open_namei() return a filp
From: Dave Hansen <haveblue@us.ibm.com>

open_namei() will, in the future, need to take mount write counts over its
creation and truncation (via may_open()) operations.  It needs to keep these
write counts until any potential filp that is created gets __fput()'d.

This gets complicated in the error handling and becomes very murky as to how
far open_namei() actually got, and whether or not that mount write count was
taken.

Creating the filps inside of open_namei() lets us shift the write count to be
taken and released along with the filp.  We can hold a temporary write count
during those creation and truncation operations, then release them once the
write for the filp has been established.

Any caller who gets a 'struct file' back must consider that filp instantiated
and fput() it normally.  The callers no longer have to worry about ever
manually releasing a mnt write count.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   16 ++++++++--------
 fs/open.c          |    7 +------
 include/linux/fs.h |    2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff -puN fs/namei.c~make-open_namei-return-a-filp fs/namei.c
--- a/fs/namei.c~make-open_namei-return-a-filp
+++ a/fs/namei.c
@@ -1731,8 +1731,8 @@ static inline int sys_open_flags_to_name
  * system call.  See sys_open_flags_to_namei_flags().
  * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int sys_open_flag,
-		int mode, struct nameidata *nd)
+struct file *open_namei(int dfd, const char *pathname, int sys_open_flag,
+			int mode, struct nameidata *nd)
 {
 	int acc_mode, error;
 	struct path path;
@@ -1758,7 +1758,7 @@ int open_namei(int dfd, const char *path
 		error = path_lookup_open(dfd, pathname, lookup_flags(flag),
 					 nd, flag);
 		if (error)
-			return error;
+			return ERR_PTR(error);
 		goto ok;
 	}
 
@@ -1767,7 +1767,7 @@ int open_namei(int dfd, const char *path
 	 */
 	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	/*
 	 * We have the parent and last component. First of all, check
@@ -1802,7 +1802,7 @@ do_last:
 		error = __open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return 0;
+		return nameidata_to_filp(nd, sys_open_flag);
 	}
 
 	/*
@@ -1835,7 +1835,7 @@ ok:
 	error = may_open(nd, acc_mode, flag);
 	if (error)
 		goto exit;
-	return 0;
+	return nameidata_to_filp(nd, sys_open_flag);
 
 exit_dput:
 	dput_path(&path, nd);
@@ -1843,7 +1843,7 @@ exit:
 	if (!IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_release(nd);
-	return error;
+	return ERR_PTR(error);
 
 do_link:
 	error = -ELOOP;
@@ -1870,7 +1870,7 @@ do_link:
 		 * with "intent.open".
 		 */
 		release_open_intent(nd);
-		return error;
+		return ERR_PTR(error);
 	}
 	nd->flags &= ~LOOKUP_PARENT;
 	if (nd->last_type == LAST_BIND)
diff -puN fs/open.c~make-open_namei-return-a-filp fs/open.c
--- a/fs/open.c~make-open_namei-return-a-filp
+++ a/fs/open.c
@@ -803,14 +803,9 @@ cleanup_file:
 static struct file *do_filp_open(int dfd, const char *filename, int flags,
 				 int mode)
 {
-	int error;
 	struct nameidata nd;
 
-	error = open_namei(dfd, filename, flags, mode, &nd);
-	if (!error)
-		return nameidata_to_filp(&nd, flags);
-
-	return ERR_PTR(error);
+	return open_namei(dfd, filename, flags, mode, &nd);
 }
 
 struct file *filp_open(const char *filename, int flags, int mode)
diff -puN include/linux/fs.h~make-open_namei-return-a-filp include/linux/fs.h
--- a/include/linux/fs.h~make-open_namei-return-a-filp
+++ a/include/linux/fs.h
@@ -1734,7 +1734,7 @@ extern struct file *create_read_pipe(str
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
 
-extern int open_namei(int dfd, const char *, int, int, struct nameidata *);
+extern struct file *open_namei(int dfd, const char *, int, int, struct nameidata *);
 extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
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
