From: akpm@linux-foundation.org
Subject: - make-reiserfs-stop-using-struct-file-for-internal.patch removed from -mm tree
Date: Wed, 17 Oct 2007 02:20:21 -0700
Message-ID: <200710170920.l9H9KL74013665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbXJQJVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 05:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, nickpiggin@yahoo.com.au, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     make reiserfs stop using 'struct file' for internal xattr operations
has been removed from the -mm tree.  Its filename was
     make-reiserfs-stop-using-struct-file-for-internal.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: make reiserfs stop using 'struct file' for internal xattr operations
From: Dave Hansen <haveblue@us.ibm.com>

needs changelog and s-o-b.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/reiserfs/inode.c~make-reiserfs-stop-using-struct-file-for-internal fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~make-reiserfs-stop-using-struct-file-for-internal
+++ a/fs/reiserfs/inode.c
@@ -19,10 +19,8 @@
 #include <linux/quotaops.h>
 #include <linux/swap.h>
 
-int reiserfs_commit_write(struct file *f, struct page *page,
-			  unsigned from, unsigned to);
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to);
+int reiserfs_commit_write(struct page *page,  unsigned from, unsigned to);
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
 
 void reiserfs_delete_inode(struct inode *inode)
 {
@@ -550,14 +548,14 @@ static int convert_tail_for_hole(struct 
 	 ** won't trigger a get_block in this case.
 	 */
 	fix_tail_page_for_writing(tail_page);
-	retval = reiserfs_prepare_write(NULL, tail_page, tail_start, tail_end);
+	retval = reiserfs_prepare_write(tail_page, tail_start, tail_end);
 	if (retval)
 		goto unlock;
 
 	/* tail conversion might change the data in the page */
 	flush_dcache_page(tail_page);
 
-	retval = reiserfs_commit_write(NULL, tail_page, tail_start, tail_end);
+	retval = reiserfs_commit_write(tail_page, tail_start, tail_end);
 
       unlock:
 	if (tail_page != hole_page) {
@@ -2621,8 +2619,7 @@ static int reiserfs_write_begin(struct f
 	return ret;
 }
 
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to)
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	int ret;
@@ -2769,7 +2766,7 @@ static int reiserfs_write_end(struct fil
 	goto out;
 }
 
-int reiserfs_commit_write(struct file *f, struct page *page,
+int reiserfs_commit_write(struct page *page,
 			  unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
diff -puN fs/reiserfs/ioctl.c~make-reiserfs-stop-using-struct-file-for-internal fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~make-reiserfs-stop-using-struct-file-for-internal
+++ a/fs/reiserfs/ioctl.c
@@ -143,10 +143,8 @@ long reiserfs_compat_ioctl(struct file *
 }
 #endif
 
-int reiserfs_commit_write(struct file *f, struct page *page,
-			  unsigned from, unsigned to);
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to);
+int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
 /*
 ** reiserfs_unpack
 ** Function try to convert tail from direct item into indirect.
@@ -194,13 +192,13 @@ static int reiserfs_unpack(struct inode 
 	if (!page) {
 		goto out;
 	}
-	retval = reiserfs_prepare_write(NULL, page, write_from, write_from);
+	retval = reiserfs_prepare_write(page, write_from, write_from);
 	if (retval)
 		goto out_unlock;
 
 	/* conversion can change page contents, must flush */
 	flush_dcache_page(page);
-	retval = reiserfs_commit_write(NULL, page, write_from, write_from);
+	retval = reiserfs_commit_write(page, write_from, write_from);
 	REISERFS_I(inode)->i_flags |= i_nopack_mask;
 
       out_unlock:
diff -puN fs/reiserfs/xattr.c~make-reiserfs-stop-using-struct-file-for-internal fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~make-reiserfs-stop-using-struct-file-for-internal
+++ a/fs/reiserfs/xattr.c
@@ -194,27 +194,6 @@ static struct dentry *get_xa_file_dentry
 	return xafile;
 }
 
-/* Opens a file pointer to the attribute associated with inode */
-static struct file *open_xa_file(const struct inode *inode, const char *name,
-				 int flags)
-{
-	struct dentry *xafile;
-	struct file *fp;
-
-	xafile = get_xa_file_dentry(inode, name, flags);
-	if (IS_ERR(xafile))
-		return ERR_PTR(PTR_ERR(xafile));
-	else if (!xafile->d_inode) {
-		dput(xafile);
-		return ERR_PTR(-ENODATA);
-	}
-
-	fp = dentry_open(xafile, NULL, O_RDWR);
-	/* dentry_open dputs the dentry if it fails */
-
-	return fp;
-}
-
 /*
  * this is very similar to fs/reiserfs/dir.c:reiserfs_readdir, but
  * we need to drop the path before calling the filldir struct.  That
@@ -426,10 +405,8 @@ static inline __u32 xattr_hash(const cha
 	return csum_partial(msg, len, 0);
 }
 
-int reiserfs_commit_write(struct file *f, struct page *page,
-			  unsigned from, unsigned to);
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to);
+int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
 
 
 /* Generic extended attribute operations that can be used by xa plugins */
@@ -442,7 +419,7 @@ reiserfs_xattr_set(struct inode *inode, 
 		   size_t buffer_size, int flags)
 {
 	int err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	struct page *page;
 	char *data;
 	struct address_space *mapping;
@@ -460,18 +437,18 @@ reiserfs_xattr_set(struct inode *inode, 
 		xahash = xattr_hash(buffer, buffer_size);
 
       open_file:
-	fp = open_xa_file(inode, name, flags);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, flags);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* we need to copy it off.. */
 	if (xinode->i_nlink > 1) {
-		fput(fp);
+		dput(dentry);
 		err = reiserfs_xattr_del(inode, name);
 		if (err < 0)
 			goto out;
@@ -485,7 +462,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 	mutex_lock(&xinode->i_mutex);
-	err = notify_change(fp->f_path.dentry, &newattrs);
+	err = notify_change(dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -518,13 +495,13 @@ reiserfs_xattr_set(struct inode *inode, 
 			rxh->h_hash = cpu_to_le32(xahash);
 		}
 
-		err = reiserfs_prepare_write(fp, page, page_offset,
+		err = reiserfs_prepare_write(page, page_offset,
 					    page_offset + chunk + skip);
 		if (!err) {
 			if (buffer)
 				memcpy(data + skip, buffer + buffer_pos, chunk);
 			err =
-			    reiserfs_commit_write(fp, page, page_offset,
+			    reiserfs_commit_write(page, page_offset,
 						  page_offset + chunk +
 						  skip);
 		}
@@ -548,7 +525,7 @@ reiserfs_xattr_set(struct inode *inode, 
 
       out_filp:
 	mutex_unlock(&xinode->i_mutex);
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
@@ -562,7 +539,7 @@ reiserfs_xattr_get(const struct inode *i
 		   size_t buffer_size)
 {
 	ssize_t err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	size_t isize;
 	size_t file_pos = 0;
 	size_t buffer_pos = 0;
@@ -578,13 +555,13 @@ reiserfs_xattr_get(const struct inode *i
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
-	fp = open_xa_file(inode, name, FL_READONLY);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, FL_READONLY);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	isize = xinode->i_size;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
@@ -652,7 +629,7 @@ reiserfs_xattr_get(const struct inode *i
 	}
 
       out_dput:
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

origin.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
r-o-bind-mounts-give-permission-a-local-mnt-variable.patch
r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch
make-reiserfs-stop-using-struct-file-for-internal.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
page-owner-tracking-leak-detector.patch
