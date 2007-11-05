From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-opened-files.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:38:55 -0800
Message-ID: <200711052338.lA5Nct8j025587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbXKEXjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:39:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     r-o-bind-mounts: elevate write count opened files
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-opened-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r-o-bind-mounts: elevate write count opened files
From: Dave Hansen <haveblue@us.ibm.com>

This is the first really tricky patch in the series.  It elevates the writer
count on a mount each time a non-special file is opened for write.

We used to do this in may_open(), but Miklos pointed out that __dentry_open()
is used as well to create filps.  This will cover even those cases, while a
call in may_open() would not have.

There is also an elevated count around the vfs_create() call in open_namei(). 
See the comments for more details, but we need this to fix a 'create, remount,
fail r/w open()' race.

Some filesystems forego the use of normal vfs calls to create
struct files.   Make sure that these users elevate the mnt
writer count because they will get __fput(), and we need
to make sure they're balanced.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |   16 +++++++++
 fs/namei.c      |   74 +++++++++++++++++++++++++++++++++++++++-------
 fs/open.c       |   36 +++++++++++++++++++++-
 ipc/mqueue.c    |    3 +
 4 files changed, 116 insertions(+), 13 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-opened-files fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-elevate-write-count-opened-files
+++ a/fs/file_table.c
@@ -193,6 +193,17 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+
+	/*
+	 * These mounts don't really matter in practice
+	 * for r/o bind mounts.  They aren't userspace-
+	 * visible.  We do this for consistency, and so
+	 * that we can do debugging checks at __fput()e
+	 */
+	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 EXPORT_SYMBOL(init_file);
@@ -230,8 +241,11 @@ void fastcall __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE)
+	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if (!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-opened-files fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-opened-files
+++ a/fs/namei.c
@@ -1621,12 +1621,12 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
-		return -EROFS;
+	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
 		return error;
+
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
@@ -1722,18 +1722,31 @@ static inline int sys_open_flags_to_name
 	return flag;
 }
 
+static inline int open_will_write_to_fs(int flag, struct inode *inode)
+{
+	/*
+	 * We'll never write to the fs underlying
+	 * a device file.
+	 */
+	if (special_file(inode->i_mode))
+		return 0;
+	return (flag & O_TRUNC);
+}
+
 /*
  *	open_pathname()
  *
  * namei for open - this is in fact almost the whole open-routine.
  *
- * Note that the low bits of "flag" aren't the same as in the open
- * system call.  See sys_open_flags_to_namei_flags().
+ * Note that the low bits of the passed in "sys_open_flag"
+ * are not the same as in the local variable "flag". See
+ * sys_open_flags_to_namei_flags() for more details.
  * SMP-safe
  */
 struct file *open_pathname(int dfd, const char *pathname,
 			   int sys_open_flag, int mode)
 {
+	struct file *filp;
 	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
@@ -1794,17 +1807,30 @@ do_last:
 	}
 
 	if (IS_ERR(nd.intent.open.file)) {
-		mutex_unlock(&dir->d_inode->i_mutex);
 		error = PTR_ERR(nd.intent.open.file);
-		goto exit_dput;
+		goto exit_mutex_unlock;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = __open_namei_create(&nd, &path, flag, mode);
+		/*
+		 * This write is needed to ensure that a
+		 * ro->rw transition does not occur between
+		 * the time when the file is created and when
+		 * a permanent write count is taken through
+		 * the 'struct file' in nameidata_to_filp().
+		 */
+		error = mnt_want_write(nd.mnt);
 		if (error)
+			goto exit_mutex_unlock;
+		error = __open_namei_create(&nd, &path, flag, mode);
+		if (error) {
+			mnt_drop_write(nd.mnt);
 			goto exit;
-		return nameidata_to_filp(&nd, sys_open_flag);
+		}
+		filp = nameidata_to_filp(&nd, sys_open_flag);
+		mnt_drop_write(nd.mnt);
+		return filp;
 	}
 
 	/*
@@ -1834,11 +1860,39 @@ do_last:
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
+	/*
+	 * Consider:
+	 * 1. may_open() truncates a file
+	 * 2. a rw->ro mount transition occurs
+	 * 3. nameidata_to_filp() fails due to
+	 *    the ro mount.
+	 * That would be inconsistent, and should
+	 * be avoided. Taking this mnt write here
+	 * ensures that (2) can not occur.
+	 */
+	if (open_will_write_to_fs(flag, nd.dentry->d_inode)) {
+		error = mnt_want_write(nd.mnt);
+		if (error)
+			goto exit;
+	}
 	error = may_open(&nd, acc_mode, flag);
-	if (error)
+	if (error) {
+		if (open_will_write_to_fs(flag, nd.dentry->d_inode))
+			mnt_drop_write(nd.mnt);
 		goto exit;
-	return nameidata_to_filp(&nd, sys_open_flag);
+	}
+	filp = nameidata_to_filp(&nd, sys_open_flag);
+	/*
+	 * It is now safe to drop the mnt write
+	 * because the filp has had a write taken
+	 * on its behalf.
+	 */
+	if (open_will_write_to_fs(flag, nd.dentry->d_inode))
+		mnt_drop_write(nd.mnt);
+	return filp;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	dput_path(&path, &nd);
 exit:
diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-opened-files fs/open.c
--- a/fs/open.c~r-o-bind-mounts-elevate-write-count-opened-files
+++ a/fs/open.c
@@ -734,6 +734,35 @@ out:
 	return error;
 }
 
+/*
+ * You have to be very careful that these write
+ * counts get cleaned up in error cases and
+ * upon __fput().  This should probably never
+ * be called outside of __dentry_open().
+ */
+static inline int __get_file_write_access(struct inode *inode,
+					  struct vfsmount *mnt)
+{
+	int error;
+	error = get_write_access(inode);
+	if (error)
+		return error;
+	/*
+	 * Do not take mount writer counts on
+	 * special files since no writes to
+	 * the mount itself will occur.
+	 */
+	if (!special_file(inode->i_mode)) {
+		/*
+		 * Balanced in __fput()
+		 */
+		error = mnt_want_write(mnt);
+		if (error)
+			put_write_access(inode);
+	}
+	return error;
+}
+
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					int flags, struct file *f,
 					int (*open)(struct inode *, struct file *))
@@ -746,7 +775,7 @@ static struct file *__dentry_open(struct
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
+		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
 	}
@@ -788,8 +817,11 @@ static struct file *__dentry_open(struct
 
 cleanup_all:
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITE)
+	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if (!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opened-files ipc/mqueue.c
--- a/ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opened-files
+++ a/ipc/mqueue.c
@@ -682,6 +682,9 @@ asmlinkage long sys_mq_open(const char _
 				goto out;
 			filp = do_open(dentry, oflag);
 		} else {
+			error = mnt_want_write(mqueue_mnt);
+			if (error)
+				goto out;
 			filp = do_create(mqueue_mnt->mnt_root, dentry,
 						oflag, mode, u_attr);
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
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
