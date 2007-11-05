From: akpm@linux-foundation.org
Subject: + make-set_fs_rootpwd-take-a-struct-path.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:02:21 -0800
Message-ID: <200711052102.lA5L2L2L019564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbXKEVCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de


The patch titled
     Make set_fs_{root,pwd} take a struct path
has been added to the -mm tree.  Its filename is
     make-set_fs_rootpwd-take-a-struct-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make set_fs_{root,pwd} take a struct path
From: Jan Blunck <jblunck@suse.de>

In nearly all cases the set_fs_{root,pwd}() calls work on a struct
path. Change the function to reflect this and use path_get() here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c            |   28 ++++++++++++++--------------
 fs/open.c                 |   12 ++++--------
 include/linux/fs_struct.h |    4 ++--
 3 files changed, 20 insertions(+), 24 deletions(-)

diff -puN fs/namespace.c~make-set_fs_rootpwd-take-a-struct-path fs/namespace.c
--- a/fs/namespace.c~make-set_fs_rootpwd-take-a-struct-path
+++ a/fs/namespace.c
@@ -2042,15 +2042,14 @@ out1:
  * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
  */
-void set_fs_root(struct fs_struct *fs, struct vfsmount *mnt,
-		 struct dentry *dentry)
+void set_fs_root(struct fs_struct *fs, struct path *path)
 {
 	struct path old_root;
 
 	write_lock(&fs->lock);
 	old_root = fs->root;
-	fs->root.mnt = mntget(mnt);
-	fs->root.dentry = dget(dentry);
+	fs->root = *path;
+	path_get(path);
 	write_unlock(&fs->lock);
 	if (old_root.dentry)
 		path_put(&old_root);
@@ -2060,15 +2059,14 @@ void set_fs_root(struct fs_struct *fs, s
  * Replace the fs->{pwdmnt,pwd} with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
  */
-void set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
-		struct dentry *dentry)
+void set_fs_pwd(struct fs_struct *fs, struct path *path)
 {
 	struct path old_pwd;
 
 	write_lock(&fs->lock);
 	old_pwd = fs->pwd;
-	fs->pwd.mnt = mntget(mnt);
-	fs->pwd.dentry = dget(dentry);
+	fs->pwd = *path;
+	path_get(path);
 	write_unlock(&fs->lock);
 
 	if (old_pwd.dentry)
@@ -2089,12 +2087,10 @@ static void chroot_fs_refs(struct nameid
 			task_unlock(p);
 			if (fs->root.dentry == old_nd->path.dentry
 			    && fs->root.mnt == old_nd->path.mnt)
-				set_fs_root(fs, new_nd->path.mnt,
-					    new_nd->path.dentry);
+				set_fs_root(fs, &new_nd->path);
 			if (fs->pwd.dentry == old_nd->path.dentry
 			    && fs->pwd.mnt == old_nd->path.mnt)
-				set_fs_pwd(fs, new_nd->path.mnt,
-					   new_nd->path.dentry);
+				set_fs_pwd(fs, &new_nd->path);
 			put_fs_struct(fs);
 		} else
 			task_unlock(p);
@@ -2237,6 +2233,7 @@ static void __init init_mount_tree(void)
 {
 	struct vfsmount *mnt;
 	struct mnt_namespace *ns;
+	struct path root;
 
 	mnt = do_kern_mount("rootfs", 0, "rootfs", NULL);
 	if (IS_ERR(mnt))
@@ -2255,8 +2252,11 @@ static void __init init_mount_tree(void)
 	init_task.nsproxy->mnt_ns = ns;
 	get_mnt_ns(ns);
 
-	set_fs_pwd(current->fs, ns->root, ns->root->mnt_root);
-	set_fs_root(current->fs, ns->root, ns->root->mnt_root);
+	root.mnt = ns->root;
+	root.dentry = ns->root->mnt_root;
+
+	set_fs_pwd(current->fs, &root);
+	set_fs_root(current->fs, &root);
 }
 
 void __init mnt_init(void)
diff -puN fs/open.c~make-set_fs_rootpwd-take-a-struct-path fs/open.c
--- a/fs/open.c~make-set_fs_rootpwd-take-a-struct-path
+++ a/fs/open.c
@@ -501,7 +501,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
+	set_fs_pwd(current->fs, &nd.path);
 
 dput_and_out:
 	path_put(&nd.path);
@@ -512,9 +512,7 @@ out:
 asmlinkage long sys_fchdir(unsigned int fd)
 {
 	struct file *file;
-	struct dentry *dentry;
 	struct inode *inode;
-	struct vfsmount *mnt;
 	int error;
 
 	error = -EBADF;
@@ -522,9 +520,7 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!file)
 		goto out;
 
-	dentry = file->f_path.dentry;
-	mnt = file->f_path.mnt;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	error = -ENOTDIR;
 	if (!S_ISDIR(inode->i_mode))
@@ -532,7 +528,7 @@ asmlinkage long sys_fchdir(unsigned int 
 
 	error = file_permission(file, MAY_EXEC);
 	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
 	fput(file);
 out:
@@ -556,7 +552,7 @@ asmlinkage long sys_chroot(const char __
 	if (!capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 
-	set_fs_root(current->fs, nd.path.mnt, nd.path.dentry);
+	set_fs_root(current->fs, &nd.path);
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
diff -puN include/linux/fs_struct.h~make-set_fs_rootpwd-take-a-struct-path include/linux/fs_struct.h
--- a/include/linux/fs_struct.h~make-set_fs_rootpwd-take-a-struct-path
+++ a/include/linux/fs_struct.h
@@ -20,8 +20,8 @@ extern struct kmem_cache *fs_cachep;
 
 extern void exit_fs(struct task_struct *);
 extern void set_fs_altroot(void);
-extern void set_fs_root(struct fs_struct *, struct vfsmount *, struct dentry *);
-extern void set_fs_pwd(struct fs_struct *, struct vfsmount *, struct dentry *);
+extern void set_fs_root(struct fs_struct *, struct path *);
+extern void set_fs_pwd(struct fs_struct *, struct path *);
 extern struct fs_struct *copy_fs_struct(struct fs_struct *);
 extern void put_fs_struct(struct fs_struct *);
 
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
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
