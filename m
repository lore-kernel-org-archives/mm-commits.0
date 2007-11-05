From: akpm@linux-foundation.org
Subject: + rename-open_namei-to-open_pathname.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:37:51 -0800
Message-ID: <200711052337.lA5Nbpre025533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbXKEXi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     rename open_namei() to open_pathname()
has been added to the -mm tree.  Its filename is
     rename-open_namei-to-open_pathname.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rename open_namei() to open_pathname()
From: Dave Hansen <haveblue@us.ibm.com>

open_namei() no longer touches namei's.  rename it to something more
appropriate: open_pathname().

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/file_storage.c |    4 ++--
 fs/exec.c                         |    2 +-
 fs/namei.c                        |    8 ++++----
 fs/open.c                         |    6 ------
 fs/reiserfs/journal.c             |    2 +-
 kernel/acct.c                     |    2 +-
 mm/swapfile.c                     |    4 ++--
 sound/sound_firmware.c            |    2 +-
 8 files changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/usb/gadget/file_storage.c~rename-open_namei-to-open_pathname drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~rename-open_namei-to-open_pathname
+++ a/drivers/usb/gadget/file_storage.c
@@ -3473,12 +3473,12 @@ static int open_backing_file(struct lun 
 	/* R/W if we can, R/O if we must */
 	ro = curlun->ro;
 	if (!ro) {
-		filp = open_namei(AT_FDCWD, filename, O_RDWR | mode, 0);
+		filp = open_pathname(AT_FDCWD, filename, O_RDWR | mode, 0);
 		if (-EROFS == PTR_ERR(filp))
 			ro = 1;
 	}
 	if (ro)
-		filp = open_namei(AT_FDCWD, filename, O_RDONLY | mode, 0);
+		filp = open_pathname(AT_FDCWD, filename, O_RDONLY | mode, 0);
 	if (IS_ERR(filp)) {
 		LINFO(curlun, "unable to open backing file: %s\n", filename);
 		return PTR_ERR(filp);
diff -puN fs/exec.c~rename-open_namei-to-open_pathname fs/exec.c
--- a/fs/exec.c~rename-open_namei-to-open_pathname
+++ a/fs/exec.c
@@ -1763,7 +1763,7 @@ int do_coredump(long signr, int exit_cod
  			goto fail_unlock;
  		}
  	} else
-		file = open_namei(AT_FDCWD, corename,
+		file = open_pathname(AT_FDCWD, corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
diff -puN fs/namei.c~rename-open_namei-to-open_pathname fs/namei.c
--- a/fs/namei.c~rename-open_namei-to-open_pathname
+++ a/fs/namei.c
@@ -81,7 +81,7 @@
  */
 
 /* [16-Dec-97 Kevin Buhr] For security reasons, we change some symlink
- * semantics.  See the comments in "open_namei" and "do_link" below.
+ * semantics.  See the comments in "open_pathname" and "do_link" below.
  *
  * [10-Sep-98 Alan Modra] Another symlink change.
  */
@@ -572,7 +572,7 @@ out:
 	if (nd->depth || res || nd->last_type!=LAST_NORM)
 		return res;
 	/*
-	 * If it is an iterative symlinks resolution in open_namei() we
+	 * If it is an iterative symlinks resolution in open_pathname() we
 	 * have to copy the last component. And all that crap because of
 	 * bloody create() on broken symlinks. Furrfu...
 	 */
@@ -1709,7 +1709,7 @@ static int __open_namei_create(struct na
  *	01 - read-permission
  *	10 - write-permission
  *	11 - read-write
- * for the internal routines (ie open_namei()/follow_link() etc)
+ * for the internal routines (ie open_pathname()/follow_link() etc)
  * This is more logical, and also allows the 00 "no perm needed"
  * to be used for symlinks (where the permissions are checked
  * later).
@@ -1723,7 +1723,7 @@ static inline int sys_open_flags_to_name
 }
 
 /*
- *	open_namei()
+ *	open_pathname()
  *
  * namei for open - this is in fact almost the whole open-routine.
  *
diff -puN fs/open.c~rename-open_namei-to-open_pathname fs/open.c
--- a/fs/open.c~rename-open_namei-to-open_pathname
+++ a/fs/open.c
@@ -800,12 +800,6 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-struct file *filp_open(const char *filename, int flags, int mode)
-{
-	return open_namei(AT_FDCWD, filename, flags, mode);
-}
-EXPORT_SYMBOL(filp_open);
-
 /**
  * lookup_instantiate_filp - instantiates the open intent filp
  * @nd: pointer to nameidata
diff -puN fs/reiserfs/journal.c~rename-open_namei-to-open_pathname fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~rename-open_namei-to-open_pathname
+++ a/fs/reiserfs/journal.c
@@ -2625,7 +2625,7 @@ static int journal_init_dev(struct super
 		return 0;
 	}
 
-	journal->j_dev_file = open_namei(AT_FDCWD, jdev_name, 0, 0);
+	journal->j_dev_file = open_pathname(AT_FDCWD, jdev_name, 0, 0);
 	if (!IS_ERR(journal->j_dev_file)) {
 		struct inode *jdev_inode = journal->j_dev_file->f_mapping->host;
 		if (!S_ISBLK(jdev_inode->i_mode)) {
diff -puN kernel/acct.c~rename-open_namei-to-open_pathname kernel/acct.c
--- a/kernel/acct.c~rename-open_namei-to-open_pathname
+++ a/kernel/acct.c
@@ -208,7 +208,7 @@ static int acct_on(char *name)
 	int error;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = open_namei(AT_FDCWD, name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = open_pathname(AT_FDCWD, name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff -puN mm/swapfile.c~rename-open_namei-to-open_pathname mm/swapfile.c
--- a/mm/swapfile.c~rename-open_namei-to-open_pathname
+++ a/mm/swapfile.c
@@ -1192,7 +1192,7 @@ asmlinkage long sys_swapoff(const char _
 	if (IS_ERR(pathname))
 		goto out;
 
-	victim = open_namei(AT_FDCWD, pathname, O_RDWR|O_LARGEFILE, 0);
+	victim = open_pathname(AT_FDCWD, pathname, O_RDWR|O_LARGEFILE, 0);
 	putname(pathname);
 	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
@@ -1471,7 +1471,7 @@ asmlinkage long sys_swapon(const char __
 		name = NULL;
 		goto bad_swap_2;
 	}
-	swap_file = open_namei(AT_FDCWD, name, O_RDWR|O_LARGEFILE, 0);
+	swap_file = open_pathname(AT_FDCWD, name, O_RDWR|O_LARGEFILE, 0);
 	error = PTR_ERR(swap_file);
 	if (IS_ERR(swap_file)) {
 		swap_file = NULL;
diff -puN sound/sound_firmware.c~rename-open_namei-to-open_pathname sound/sound_firmware.c
--- a/sound/sound_firmware.c~rename-open_namei-to-open_pathname
+++ a/sound/sound_firmware.c
@@ -14,7 +14,7 @@ static int do_mod_firmware_load(const ch
 	char *dp;
 	loff_t pos;
 
-	filp = open_namei(AT_FDCWD, fn, 0, 0);
+	filp = open_pathname(AT_FDCWD, fn, 0, 0);
 	if (IS_ERR(filp))
 	{
 		printk(KERN_INFO "Unable to load '%s'.\n", fn);
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
