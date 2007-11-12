From: akpm@linux-foundation.org
Subject: + create-file_drop_write_access-helper.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:45:20 -0800
Message-ID: <200711122145.lACLjKeX010416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbXKLVqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, bfields@fieldses.org, ezk@cs.sunysb.edu, trond.myklebust@fys.uio.no


The patch titled
     create file_drop_write_access() helper
has been added to the -mm tree.  Its filename is
     create-file_drop_write_access-helper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: create file_drop_write_access() helper
From: Dave Hansen <haveblue@us.ibm.com>

These should fix the bug that Erez Zadok <ezk@cs.sunysb.edu>
reported:

Stopping RPC idmapd:

kernel: __fput() of writeable file with no mnt_want_write()
kernel: WARNING: at fs/file_table.c:262 __fput()
kernel:  [<c010283e>] show_trace_log_lvl+0x12/0x25
kernel:  [<c0103042>] show_trace+0xd/0x10
...

The actual bug was a missed mnt_want_write() when a
filp was allocated with get_empty_filp() and then
made writable.  Using alloc_file(), instead, fixes
that.

--

If someone decides to demote a file from r/w to just
r/o, they can use this same code as __fput().

NFS does just that, and will use this in the next
patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c      |   46 +++++++++++++++++++++++++++--------------
 include/linux/file.h |    1 
 2 files changed, 32 insertions(+), 15 deletions(-)

diff -puN fs/file_table.c~create-file_drop_write_access-helper fs/file_table.c
--- a/fs/file_table.c~create-file_drop_write_access-helper
+++ a/fs/file_table.c
@@ -223,6 +223,34 @@ void fastcall fput(struct file *file)
 
 EXPORT_SYMBOL(fput);
 
+/**
+ * drop_file_write_access - give up ability to write to a file
+ * @file: the file to which we will stop writing
+ *
+ * This is a central place which will give up the ability
+ * to write to @file, along with access to write through
+ * its vfsmount.
+ */
+void drop_file_write_access(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct vfsmount *mnt = file->f_path.mnt;
+	struct inode *inode = dentry->d_inode;
+
+	put_write_access(inode);
+	if (!special_file(inode->i_mode)) {
+		if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
+			mnt_drop_write(mnt);
+			file->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+		} else {
+			printk(KERN_WARNING "dropping write access on "
+					"file with no mnt_want_write()\n");
+			WARN_ON(1);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(drop_file_write_access);
+
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
@@ -248,21 +276,9 @@ void fastcall __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE) {
-		put_write_access(inode);
-		if (!special_file(inode->i_mode)) {
-			if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
-				mnt_drop_write(mnt);
-				file->f_mnt_write_state |=
-					FILE_MNT_WRITE_RELEASED;
-			} else {
-				printk(KERN_WARNING "__fput() of writeable "
-						"file with no "
-						"mnt_want_write()\n");
-				WARN_ON(1);
-			}
-		}
-	}
+	if (file->f_mode & FMODE_WRITE)
+		drop_file_write_access(file);
+
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN include/linux/file.h~create-file_drop_write_access-helper include/linux/file.h
--- a/include/linux/file.h~create-file_drop_write_access-helper
+++ a/include/linux/file.h
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
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
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
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
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
