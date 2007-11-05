From: akpm@linux-foundation.org
Subject: + keep-track-of-mnt_writer-state-of-struct-file.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:39:44 -0800
Message-ID: <200711052339.lA5Ndi63025647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808AbXKEXyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:54:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     keep track of mnt_writer state of struct file
has been added to the -mm tree.  Its filename is
     keep-track-of-mnt_writer-state-of-struct-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: keep track of mnt_writer state of struct file
From: Dave Hansen <haveblue@us.ibm.com>

There have been a few oopses caused by 'struct file's with NULL f_vfsmnts. 
There was also a set of potentially missed mnt_want_write()s from
dentry_open() calls.

This patch provides a very simple debugging framework to catch these kinds of
bugs.  It will WARN_ON() them, but should stop us from having any oopses or
mnt_writer count imbalances.

I'm quite convinced that this is a good thing because it found bugs in the
stuff I was working on as soon as I wrote it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   21 +++++++++++++++++++--
 fs/open.c          |   14 +++++++++++++-
 include/linux/fs.h |    4 ++++
 3 files changed, 36 insertions(+), 3 deletions(-)

diff -puN fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file fs/file_table.c
--- a/fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file
+++ a/fs/file_table.c
@@ -42,6 +42,12 @@ static inline void file_free_rcu(struct 
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
+	/*
+	 * At this point, either both or neither of these bits
+	 * should be set.
+	 */
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_RELEASED);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -201,6 +207,7 @@ int init_file(struct file *file, struct 
 	 * that we can do debugging checks at __fput()e
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
 	}
@@ -243,8 +250,18 @@ void fastcall __fput(struct file *file)
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
-			mnt_drop_write(mnt);
+		if (!special_file(inode->i_mode)) {
+			if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
+				mnt_drop_write(mnt);
+				file->f_mnt_write_state |=
+					FILE_MNT_WRITE_RELEASED;
+			} else {
+				printk(KERN_WARNING "__fput() of writeable "
+						"file with no "
+						"mnt_want_write()\n");
+				WARN_ON(1);
+			}
+		}
 	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
diff -puN fs/open.c~keep-track-of-mnt_writer-state-of-struct-file fs/open.c
--- a/fs/open.c~keep-track-of-mnt_writer-state-of-struct-file
+++ a/fs/open.c
@@ -810,6 +810,10 @@ static struct file *__dentry_open(struct
 		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
+		if (!special_file(inode->i_mode)) {
+			WARN_ON(f->f_mnt_write_state != 0);
+			f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
+		}
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -851,8 +855,16 @@ cleanup_all:
 	fops_put(f->f_op);
 	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
+		if (!special_file(inode->i_mode)) {
+			/*
+			 * We don't consider this a real
+			 * mnt_want/drop_write() pair
+			 * because it all happenend right
+			 * here, so just reset the state.
+			 */
+			f->f_mnt_write_state = 0;
 			mnt_drop_write(mnt);
+		}
 	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
diff -puN include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file include/linux/fs.h
--- a/include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file
+++ a/include/linux/fs.h
@@ -780,6 +780,9 @@ static inline int ra_has_index(struct fi
 		index <  ra->start + ra->size);
 }
 
+#define FILE_MNT_WRITE_TAKEN	1
+#define FILE_MNT_WRITE_RELEASED	2
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -814,6 +817,7 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	unsigned long f_mnt_write_state;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
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
