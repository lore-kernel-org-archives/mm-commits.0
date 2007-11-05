From: akpm@linux-foundation.org
Subject: + do-namei_flags-calculation-inside-open_namei.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:40:38 -0800
Message-ID: <200711052340.lA5NedVd025674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153AbXKEXlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     do namei_flags calculation inside open_namei()
has been added to the -mm tree.  Its filename is
     do-namei_flags-calculation-inside-open_namei.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do namei_flags calculation inside open_namei()
From: Dave Hansen <haveblue@us.ibm.com>

Why do we need r/o bind mounts?

This feature allows a read-only view into a read-write filesystem.  In the
process of doing that, it also provides infrastructure for keeping track of
the number of writers to any given mount.

This has a number of uses.  It allows chroots to have parts of filesystems
writable.  It will be useful for containers in the future because users may
have root inside a container, but should not be allowed to write to
somefilesystems.  This also replaces patches that vserver has had out of the
tree for several years.

It allows security enhancement by making sure that parts of your filesystem
are read-only (such as when you don't trust your FTP server), when you don't
want to have entire new filesystems mounted, or when you want atime
selectively updated.  I've been using this script:

	http://sr71.net/~dave/linux/robind-test.sh

to test that the feature is working as desired.  It takes a directory and
makes a regular bind and a r/o bind mount of it.  It then performs some normal
filesystem operations on the three directories, including ones that are
expected to fail, like creating a file on the r/o mount.




This patch:

My end goal here is to make sure all users of may_open() return filps.  This
will ensure that we properly release mount write counts which were taken for
the filp in may_open().

This patch moves the sys_open flags to namei flags calculation into
fs/namei.c.  We'll shortly be moving the nameidata_to_filp() calls into
namei.c, and this gets the sys_open flags to a place where we can get at them
when we need them.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   43 ++++++++++++++++++++++++++++++++++---------
 fs/open.c  |   22 ++--------------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff -puN fs/namei.c~do-namei_flags-calculation-inside-open_namei fs/namei.c
--- a/fs/namei.c~do-namei_flags-calculation-inside-open_namei
+++ a/fs/namei.c
@@ -1675,7 +1675,12 @@ int may_open(struct nameidata *nd, int a
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
@@ -1694,26 +1699,46 @@ static int open_namei_create(struct name
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
+static inline int sys_open_flags_to_namei_flags(int flag)
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
+ * system call.  See sys_open_flags_to_namei_flags().
  * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int flag,
+int open_namei(int dfd, const char *pathname, int sys_open_flag,
 		int mode, struct nameidata *nd)
 {
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
+	int flag = sys_open_flags_to_namei_flags(sys_open_flag);
 
 	acc_mode = ACC_MODE(flag);
 
@@ -1774,7 +1799,7 @@ do_last:
 
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
@@ -800,31 +800,13 @@ cleanup_file:
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

markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
do-namei_flags-calculation-inside-open_namei.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname.patch
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
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
