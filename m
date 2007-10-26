From: akpm@linux-foundation.org
Subject: - use-struct-path-argument-in-proc_get_link.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:58:54 -0700
Message-ID: <200710261858.l9QIws8A009557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbXJZS7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.vnet.ibm.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Use struct path argument in proc_get_link()
has been removed from the -mm tree.  Its filename was
     use-struct-path-argument-in-proc_get_link.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Use struct path argument in proc_get_link()
From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Replace the (vfsmnt, dentry) arguments in proc_inode operation proc_get_link()
by struct path.

Also, this should eventually allow do_proc_readlink() to call d_path() with
a struct path argument.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   60 +++++++++++++++++---------------------
 fs/proc/internal.h      |    2 -
 fs/proc/task_mmu.c      |    6 +--
 fs/proc/task_nommu.c    |    6 +--
 include/linux/proc_fs.h |    2 -
 5 files changed, 35 insertions(+), 41 deletions(-)

diff -puN fs/proc/base.c~use-struct-path-argument-in-proc_get_link fs/proc/base.c
--- a/fs/proc/base.c~use-struct-path-argument-in-proc_get_link
+++ a/fs/proc/base.c
@@ -153,7 +153,7 @@ static int get_nr_threads(struct task_st
 	return count;
 }
 
-static int proc_cwd_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static int proc_cwd_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct fs_struct *fs = NULL;
@@ -165,8 +165,8 @@ static int proc_cwd_link(struct inode *i
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->pwd.mnt);
-		*dentry = dget(fs->pwd.dentry);
+		*path = fs->pwd;
+		path_get(path);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -174,7 +174,7 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
-static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static int proc_root_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct fs_struct *fs = NULL;
@@ -186,8 +186,8 @@ static int proc_root_link(struct inode *
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->root.mnt);
-		*dentry = dget(fs->root.dentry);
+		*path = fs->root;
+		path_get(path);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -1075,34 +1075,32 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path.dentry,
-						&nd->path.mnt);
+	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
 	nd->last_type = LAST_BIND;
 out:
 	return ERR_PTR(error);
 }
 
-static int do_proc_readlink(struct dentry *dentry, struct vfsmount *mnt,
-			    char __user *buffer, int buflen)
+static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
 	struct inode * inode;
 	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
-	char *path;
+	char *pathname;
 	int len;
 
 	if (!tmp)
 		return -ENOMEM;
 
-	inode = dentry->d_inode;
-	path = d_path(dentry, mnt, tmp, PAGE_SIZE);
-	len = PTR_ERR(path);
-	if (IS_ERR(path))
+	inode = path->dentry->d_inode;
+	pathname = d_path(path->dentry, path->mnt, tmp, PAGE_SIZE);
+	len = PTR_ERR(pathname);
+	if (IS_ERR(pathname))
 		goto out;
-	len = tmp + PAGE_SIZE - 1 - path;
+	len = tmp + PAGE_SIZE - 1 - pathname;
 
 	if (len > buflen)
 		len = buflen;
-	if (copy_to_user(buffer, path, len))
+	if (copy_to_user(buffer, pathname, len))
 		len = -EFAULT;
  out:
 	free_page((unsigned long)tmp);
@@ -1113,20 +1111,18 @@ static int proc_pid_readlink(struct dent
 {
 	int error = -EACCES;
 	struct inode *inode = dentry->d_inode;
-	struct dentry *de;
-	struct vfsmount *mnt = NULL;
+	struct path path;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &de, &mnt);
+	error = PROC_I(inode)->op.proc_get_link(inode, &path);
 	if (error)
 		goto out;
 
-	error = do_proc_readlink(de, mnt, buffer, buflen);
-	dput(de);
-	mntput(mnt);
+	error = do_proc_readlink(&path, buffer, buflen);
+	path_put(&path);
 out:
 	return error;
 }
@@ -1353,8 +1349,7 @@ out:
 
 #define PROC_FDINFO_MAX 64
 
-static int proc_fd_info(struct inode *inode, struct dentry **dentry,
-			struct vfsmount **mnt, char *info)
+static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
@@ -1373,10 +1368,10 @@ static int proc_fd_info(struct inode *in
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			if (mnt)
-				*mnt = mntget(file->f_path.mnt);
-			if (dentry)
-				*dentry = dget(file->f_path.dentry);
+			if (path) {
+				*path = file->f_path;
+				path_get(path);
+			}
 			if (info)
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
@@ -1393,10 +1388,9 @@ static int proc_fd_info(struct inode *in
 	return -ENOENT;
 }
 
-static int proc_fd_link(struct inode *inode, struct dentry **dentry,
-			struct vfsmount **mnt)
+static int proc_fd_link(struct inode *inode, struct path *path)
 {
-	return proc_fd_info(inode, dentry, mnt, NULL);
+	return proc_fd_info(inode, path, NULL);
 }
 
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
@@ -1590,7 +1584,7 @@ static ssize_t proc_fdinfo_read(struct f
 				      size_t len, loff_t *ppos)
 {
 	char tmp[PROC_FDINFO_MAX];
-	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, NULL, tmp);
+	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
 	if (!err)
 		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
 	return err;
diff -puN fs/proc/internal.h~use-struct-path-argument-in-proc_get_link fs/proc/internal.h
--- a/fs/proc/internal.h~use-struct-path-argument-in-proc_get_link
+++ a/fs/proc/internal.h
@@ -45,7 +45,7 @@ extern int nommu_vma_show(struct seq_fil
 extern int maps_protect;
 
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
-extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
+extern int proc_exe_link(struct inode *, struct path *);
 extern int proc_tid_stat(struct task_struct *,  char *);
 extern int proc_tgid_stat(struct task_struct *, char *);
 extern int proc_pid_status(struct task_struct *, char *);
diff -puN fs/proc/task_mmu.c~use-struct-path-argument-in-proc_get_link fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~use-struct-path-argument-in-proc_get_link
+++ a/fs/proc/task_mmu.c
@@ -72,7 +72,7 @@ int task_statm(struct mm_struct *mm, int
 	return mm->total_vm;
 }
 
-int proc_exe_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+int proc_exe_link(struct inode *inode, struct path *path)
 {
 	struct vm_area_struct * vma;
 	int result = -ENOENT;
@@ -95,8 +95,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_path.mnt);
-		*dentry = dget(vma->vm_file->f_path.dentry);
+		*path = vma->vm_file->f_path;
+		path_get(path);
 		result = 0;
 	}
 
diff -puN fs/proc/task_nommu.c~use-struct-path-argument-in-proc_get_link fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~use-struct-path-argument-in-proc_get_link
+++ a/fs/proc/task_nommu.c
@@ -104,7 +104,7 @@ int task_statm(struct mm_struct *mm, int
 	return size;
 }
 
-int proc_exe_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+int proc_exe_link(struct inode *inode, struct path *path)
 {
 	struct vm_list_struct *vml;
 	struct vm_area_struct *vma;
@@ -127,8 +127,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_path.mnt);
-		*dentry = dget(vma->vm_file->f_path.dentry);
+		*path = vma->vm_file->f_path;
+		path_get(path);
 		result = 0;
 	}
 
diff -puN include/linux/proc_fs.h~use-struct-path-argument-in-proc_get_link include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~use-struct-path-argument-in-proc_get_link
+++ a/include/linux/proc_fs.h
@@ -258,7 +258,7 @@ extern void kclist_add(struct kcore_list
 #endif
 
 union proc_op {
-	int (*proc_get_link)(struct inode *, struct dentry **, struct vfsmount **);
+	int (*proc_get_link)(struct inode *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
 };
 
_

Patches currently in -mm which might be from bharata@linux.vnet.ibm.com are

use-struct-path-argument-in-proc_get_link.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
