From: akpm@linux-foundation.org
Subject: + d_path-make-proc_get_link-use-a-struct-path-argument.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:06:57 -0800
Message-ID: <200711052106.lA5L6vdY019769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbXKEVHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, ebiederm@xmission.com, hch@infradead.org, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     d_path: Make proc_get_link() use a struct path argument
has been added to the -mm tree.  Its filename is
     d_path-make-proc_get_link-use-a-struct-path-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: d_path: Make proc_get_link() use a struct path argument
From: Jan Blunck <jblunck@suse.de>

proc_get_link() is always called with a dentry and a vfsmount from a struct
path.  Make proc_get_link() take it directly as an argument.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   60 ++++++++++++++++----------------------
 fs/proc/internal.h      |    2 -
 fs/proc/task_mmu.c      |    6 +--
 fs/proc/task_nommu.c    |    6 +--
 include/linux/proc_fs.h |    2 -
 5 files changed, 34 insertions(+), 42 deletions(-)

diff -puN fs/proc/base.c~d_path-make-proc_get_link-use-a-struct-path-argument fs/proc/base.c
--- a/fs/proc/base.c~d_path-make-proc_get_link-use-a-struct-path-argument
+++ a/fs/proc/base.c
@@ -149,7 +149,7 @@ static int get_nr_threads(struct task_st
 	return count;
 }
 
-static int proc_cwd_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static int proc_cwd_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct fs_struct *fs = NULL;
@@ -161,8 +161,8 @@ static int proc_cwd_link(struct inode *i
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->pwd.mnt);
-		*dentry = dget(fs->pwd.dentry);
+		*path = fs->pwd;
+		path_get(&fs->pwd);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -170,7 +170,7 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
-static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static int proc_root_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct fs_struct *fs = NULL;
@@ -182,8 +182,8 @@ static int proc_root_link(struct inode *
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->root.mnt);
-		*dentry = dget(fs->root.dentry);
+		*path = fs->root;
+		path_get(&fs->root);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -1035,34 +1035,30 @@ static void *proc_pid_follow_link(struct
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
-	struct inode * inode;
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
@@ -1073,20 +1069,18 @@ static int proc_pid_readlink(struct dent
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
@@ -1313,8 +1307,7 @@ out:
 
 #define PROC_FDINFO_MAX 64
 
-static int proc_fd_info(struct inode *inode, struct dentry **dentry,
-			struct vfsmount **mnt, char *info)
+static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
@@ -1333,10 +1326,10 @@ static int proc_fd_info(struct inode *in
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			if (mnt)
-				*mnt = mntget(file->f_path.mnt);
-			if (dentry)
-				*dentry = dget(file->f_path.dentry);
+			if (path) {
+				*path = file->f_path;
+				path_get(&file->f_path);
+			}
 			if (info)
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
@@ -1353,10 +1346,9 @@ static int proc_fd_info(struct inode *in
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
@@ -1550,7 +1542,7 @@ static ssize_t proc_fdinfo_read(struct f
 				      size_t len, loff_t *ppos)
 {
 	char tmp[PROC_FDINFO_MAX];
-	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, NULL, tmp);
+	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
 	if (!err)
 		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
 	return err;
diff -puN fs/proc/internal.h~d_path-make-proc_get_link-use-a-struct-path-argument fs/proc/internal.h
--- a/fs/proc/internal.h~d_path-make-proc_get_link-use-a-struct-path-argument
+++ a/fs/proc/internal.h
@@ -45,7 +45,7 @@ extern int nommu_vma_show(struct seq_fil
 extern int maps_protect;
 
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
-extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
+extern int proc_exe_link(struct inode *, struct path *);
 extern int proc_tid_stat(struct task_struct *,  char *);
 extern int proc_tgid_stat(struct task_struct *, char *);
 extern int proc_pid_status(struct task_struct *, char *);
diff -puN fs/proc/task_mmu.c~d_path-make-proc_get_link-use-a-struct-path-argument fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~d_path-make-proc_get_link-use-a-struct-path-argument
+++ a/fs/proc/task_mmu.c
@@ -75,7 +75,7 @@ int task_statm(struct mm_struct *mm, int
 	return mm->total_vm;
 }
 
-int proc_exe_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+int proc_exe_link(struct inode *inode, struct path *path)
 {
 	struct vm_area_struct * vma;
 	int result = -ENOENT;
@@ -98,8 +98,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_path.mnt);
-		*dentry = dget(vma->vm_file->f_path.dentry);
+		*path = vma->vm_file->f_path;
+		path_get(&vma->vm_file->f_path);
 		result = 0;
 	}
 
diff -puN fs/proc/task_nommu.c~d_path-make-proc_get_link-use-a-struct-path-argument fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~d_path-make-proc_get_link-use-a-struct-path-argument
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
+		path_get(&vma->vm_file->f_path);
 		result = 0;
 	}
 
diff -puN include/linux/proc_fs.h~d_path-make-proc_get_link-use-a-struct-path-argument include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~d_path-make-proc_get_link-use-a-struct-path-argument
+++ a/include/linux/proc_fs.h
@@ -259,7 +259,7 @@ extern void kclist_add(struct kcore_list
 #endif
 
 union proc_op {
-	int (*proc_get_link)(struct inode *, struct dentry **, struct vfsmount **);
+	int (*proc_get_link)(struct inode *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
 };
 
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
