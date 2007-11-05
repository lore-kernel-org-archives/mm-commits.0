From: akpm@linux-foundation.org
Subject: + kill-do_filp_open.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:36:43 -0800
Message-ID: <200711052336.lA5Nahuc025479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbXKEXmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     kill do_filp_open()
has been added to the -mm tree.  Its filename is
     kill-do_filp_open.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill do_filp_open()
From: Dave Hansen <haveblue@us.ibm.com>

This kills off the almost empty do_filp_open().  The indenting change in
do_sys_open() is because we would have gone over our 80 characters otherwise.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff -puN fs/open.c~kill-do_filp_open fs/open.c
--- a/fs/open.c~kill-do_filp_open
+++ a/fs/open.c
@@ -800,17 +800,10 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-static struct file *do_filp_open(int dfd, const char *filename, int flags,
-				 int mode)
-{
-	struct nameidata nd;
-
-	return open_namei(dfd, filename, flags, mode, &nd);
-}
-
 struct file *filp_open(const char *filename, int flags, int mode)
 {
-	return do_filp_open(AT_FDCWD, filename, flags, mode);
+	struct nameidata nd;
+	return open_namei(AT_FDCWD, filename, flags, mode, &nd);
 }
 EXPORT_SYMBOL(filp_open);
 
@@ -1009,20 +1002,24 @@ long do_sys_open(int dfd, const char __u
 	char *tmp = getname(filename);
 	int fd = PTR_ERR(tmp);
 
-	if (!IS_ERR(tmp)) {
-		fd = get_unused_fd_flags(flags);
-		if (fd >= 0) {
-			struct file *f = do_filp_open(dfd, tmp, flags, mode);
-			if (IS_ERR(f)) {
-				put_unused_fd(fd);
-				fd = PTR_ERR(f);
-			} else {
-				fsnotify_open(f->f_path.dentry);
-				fd_install(fd, f);
-			}
+	if (IS_ERR(tmp))
+		goto out;
+
+	fd = get_unused_fd_flags(flags);
+	if (fd >= 0) {
+		struct nameidata nd;
+		struct file *f = open_namei(dfd, tmp, flags, mode, &nd);
+
+		if (IS_ERR(f)) {
+			put_unused_fd(fd);
+			fd = PTR_ERR(f);
+		} else {
+			fsnotify_open(f->f_path.dentry);
+			fd_install(fd, f);
 		}
-		putname(tmp);
 	}
+	putname(tmp);
+out:
 	return fd;
 }
 
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
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
