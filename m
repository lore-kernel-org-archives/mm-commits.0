From: akpm@linux-foundation.org
Subject: + use-struct-path-in-fs_struct.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:02:18 -0800
Message-ID: <200711052102.lA5L2Ix4019561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbXKEVCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de


The patch titled
     Use struct path in fs_struct
has been added to the -mm tree.  Its filename is
     use-struct-path-in-fs_struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use struct path in fs_struct
From: Jan Blunck <jblunck@suse.de>

* Use struct path in fs_struct.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c               |   34 +++++++++------------
 fs/namei.c                |   53 ++++++++++++++-------------------
 fs/namespace.c            |   57 +++++++++++++++---------------------
 fs/proc/base.c            |    8 ++---
 include/linux/fs_struct.h |    6 +--
 init/do_mounts.c          |    6 +--
 kernel/auditsc.c          |    4 +-
 kernel/exit.c             |   12 ++-----
 kernel/fork.c             |   18 +++++------
 9 files changed, 87 insertions(+), 111 deletions(-)

diff -puN fs/dcache.c~use-struct-path-in-fs_struct fs/dcache.c
--- a/fs/dcache.c~use-struct-path-in-fs_struct
+++ a/fs/dcache.c
@@ -1852,8 +1852,7 @@ char * d_path(struct dentry *dentry, str
 				char *buf, int buflen)
 {
 	char *res;
-	struct vfsmount *rootmnt;
-	struct dentry *root;
+	struct path root;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -1866,14 +1865,13 @@ char * d_path(struct dentry *dentry, str
 		return dentry->d_op->d_dname(dentry, buf, buflen);
 
 	read_lock(&current->fs->lock);
-	rootmnt = mntget(current->fs->rootmnt);
-	root = dget(current->fs->root);
+	root = current->fs->root;
+	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen);
+	res = __d_path(dentry, vfsmnt, root.dentry, root.mnt, buf, buflen);
 	spin_unlock(&dcache_lock);
-	dput(root);
-	mntput(rootmnt);
+	path_put(&root);
 	return res;
 }
 
@@ -1919,28 +1917,28 @@ char *dynamic_dname(struct dentry *dentr
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size)
 {
 	int error;
-	struct vfsmount *pwdmnt, *rootmnt;
-	struct dentry *pwd, *root;
+	struct path pwd, root;
 	char *page = (char *) __get_free_page(GFP_USER);
 
 	if (!page)
 		return -ENOMEM;
 
 	read_lock(&current->fs->lock);
-	pwdmnt = mntget(current->fs->pwdmnt);
-	pwd = dget(current->fs->pwd);
-	rootmnt = mntget(current->fs->rootmnt);
-	root = dget(current->fs->root);
+	pwd = current->fs->pwd;
+	path_get(&current->fs->pwd);
+	root = current->fs->root;
+	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
-	if (pwd->d_parent == pwd || !d_unhashed(pwd)) {
+	if (pwd.dentry->d_parent == pwd.dentry || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE);
+		cwd = __d_path(pwd.dentry, pwd.mnt, root.dentry, root.mnt,
+			       page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
@@ -1958,10 +1956,8 @@ asmlinkage long sys_getcwd(char __user *
 		spin_unlock(&dcache_lock);
 
 out:
-	dput(pwd);
-	mntput(pwdmnt);
-	dput(root);
-	mntput(rootmnt);
+	path_put(&pwd);
+	path_put(&root);
 	free_page((unsigned long) page);
 	return error;
 }
diff -puN fs/namei.c~use-struct-path-in-fs_struct fs/namei.c
--- a/fs/namei.c~use-struct-path-in-fs_struct
+++ a/fs/namei.c
@@ -550,16 +550,16 @@ walk_init_root(const char *name, struct 
 	struct fs_struct *fs = current->fs;
 
 	read_lock(&fs->lock);
-	if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
-		nd->path.mnt = mntget(fs->altrootmnt);
-		nd->path.dentry = dget(fs->altroot);
+	if (fs->altroot.dentry && !(nd->flags & LOOKUP_NOALT)) {
+		nd->path = fs->altroot;
+		path_get(&fs->altroot);
 		read_unlock(&fs->lock);
 		if (__emul_lookup_dentry(name,nd))
 			return 0;
 		read_lock(&fs->lock);
 	}
-	nd->path.mnt = mntget(fs->rootmnt);
-	nd->path.dentry = dget(fs->root);
+	nd->path = fs->root;
+	path_get(&fs->root);
 	read_unlock(&fs->lock);
 	return 1;
 }
@@ -756,8 +756,8 @@ static __always_inline void follow_dotdo
 		struct dentry *old = nd->path.dentry;
 
                 read_lock(&fs->lock);
-		if (nd->path.dentry == fs->root &&
-		    nd->path.mnt == fs->rootmnt) {
+		if (nd->path.dentry == fs->root.dentry &&
+		    nd->path.mnt == fs->root.mnt) {
                         read_unlock(&fs->lock);
 			break;
 		}
@@ -1079,8 +1079,8 @@ static int __emul_lookup_dentry(const ch
 		 */
 		nd->last_type = LAST_ROOT;
 		read_lock(&fs->lock);
-		nd->path.mnt = mntget(fs->rootmnt);
-		nd->path.dentry = dget(fs->root);
+		nd->path = fs->root;
+		path_get(&fs->root);
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
 			if (nd->path.dentry->d_inode) {
@@ -1100,29 +1100,22 @@ void set_fs_altroot(void)
 {
 	char *emul = __emul_prefix();
 	struct nameidata nd;
-	struct vfsmount *mnt = NULL, *oldmnt;
-	struct dentry *dentry = NULL, *olddentry;
+	struct path path = {}, old_path;
 	int err;
 	struct fs_struct *fs = current->fs;
 
 	if (!emul)
 		goto set_it;
 	err = path_lookup(emul, LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOALT, &nd);
-	if (!err) {
-		mnt = nd.path.mnt;
-		dentry = nd.path.dentry;
-	}
+	if (!err)
+		path = nd.path;
 set_it:
 	write_lock(&fs->lock);
-	oldmnt = fs->altrootmnt;
-	olddentry = fs->altroot;
-	fs->altrootmnt = mnt;
-	fs->altroot = dentry;
+	old_path = fs->altroot;
+	fs->altroot = path;
 	write_unlock(&fs->lock);
-	if (olddentry) {
-		dput(olddentry);
-		mntput(oldmnt);
-	}
+	if (old_path.dentry)
+		path_put(&old_path);
 }
 
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
@@ -1140,21 +1133,21 @@ static int fastcall do_path_lookup(int d
 
 	if (*name=='/') {
 		read_lock(&fs->lock);
-		if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
-			nd->path.mnt = mntget(fs->altrootmnt);
-			nd->path.dentry = dget(fs->altroot);
+		if (fs->altroot.dentry && !(nd->flags & LOOKUP_NOALT)) {
+			nd->path = fs->altroot;
+			path_get(&fs->altroot);
 			read_unlock(&fs->lock);
 			if (__emul_lookup_dentry(name,nd))
 				goto out; /* found in altroot */
 			read_lock(&fs->lock);
 		}
-		nd->path.mnt = mntget(fs->rootmnt);
-		nd->path.dentry = dget(fs->root);
+		nd->path = fs->root;
+		path_get(&fs->root);
 		read_unlock(&fs->lock);
 	} else if (dfd == AT_FDCWD) {
 		read_lock(&fs->lock);
-		nd->path.mnt = mntget(fs->pwdmnt);
-		nd->path.dentry = dget(fs->pwd);
+		nd->path = fs->pwd;
+		path_get(&fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
 		struct dentry *dentry;
diff -puN fs/namespace.c~use-struct-path-in-fs_struct fs/namespace.c
--- a/fs/namespace.c~use-struct-path-in-fs_struct
+++ a/fs/namespace.c
@@ -871,7 +871,7 @@ static int do_umount(struct vfsmount *mn
 	 *  (2) the usage count == 1 [parent vfsmount] + 1 [sys_umount]
 	 */
 	if (flags & MNT_EXPIRE) {
-		if (mnt == current->fs->rootmnt ||
+		if (mnt == current->fs->root.mnt ||
 		    flags & (MNT_FORCE | MNT_DETACH))
 			return -EINVAL;
 
@@ -906,7 +906,7 @@ static int do_umount(struct vfsmount *mn
 	 * /reboot - static binary that would close all descriptors and
 	 * call reboot(9). Then init(8) could umount root and exec /reboot.
 	 */
-	if (mnt == current->fs->rootmnt && !(flags & MNT_DETACH)) {
+	if (mnt == current->fs->root.mnt && !(flags & MNT_DETACH)) {
 		/*
 		 * Special case for "unmounting" root ...
 		 * we just try to remount it readonly.
@@ -1951,17 +1951,17 @@ static struct mnt_namespace *dup_mnt_ns(
 	while (p) {
 		q->mnt_ns = new_ns;
 		if (fs) {
-			if (p == fs->rootmnt) {
+			if (p == fs->root.mnt) {
 				rootmnt = p;
-				fs->rootmnt = mntget(q);
+				fs->root.mnt = mntget(q);
 			}
-			if (p == fs->pwdmnt) {
+			if (p == fs->pwd.mnt) {
 				pwdmnt = p;
-				fs->pwdmnt = mntget(q);
+				fs->pwd.mnt = mntget(q);
 			}
-			if (p == fs->altrootmnt) {
+			if (p == fs->altroot.mnt) {
 				altrootmnt = p;
-				fs->altrootmnt = mntget(q);
+				fs->altroot.mnt = mntget(q);
 			}
 		}
 		p = next_mnt(p, mnt_ns->root);
@@ -2045,18 +2045,15 @@ out1:
 void set_fs_root(struct fs_struct *fs, struct vfsmount *mnt,
 		 struct dentry *dentry)
 {
-	struct dentry *old_root;
-	struct vfsmount *old_rootmnt;
+	struct path old_root;
+
 	write_lock(&fs->lock);
 	old_root = fs->root;
-	old_rootmnt = fs->rootmnt;
-	fs->rootmnt = mntget(mnt);
-	fs->root = dget(dentry);
+	fs->root.mnt = mntget(mnt);
+	fs->root.dentry = dget(dentry);
 	write_unlock(&fs->lock);
-	if (old_root) {
-		dput(old_root);
-		mntput(old_rootmnt);
-	}
+	if (old_root.dentry)
+		path_put(&old_root);
 }
 
 /*
@@ -2066,20 +2063,16 @@ void set_fs_root(struct fs_struct *fs, s
 void set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct dentry *old_pwd;
-	struct vfsmount *old_pwdmnt;
+	struct path old_pwd;
 
 	write_lock(&fs->lock);
 	old_pwd = fs->pwd;
-	old_pwdmnt = fs->pwdmnt;
-	fs->pwdmnt = mntget(mnt);
-	fs->pwd = dget(dentry);
+	fs->pwd.mnt = mntget(mnt);
+	fs->pwd.dentry = dget(dentry);
 	write_unlock(&fs->lock);
 
-	if (old_pwd) {
-		dput(old_pwd);
-		mntput(old_pwdmnt);
-	}
+	if (old_pwd.dentry)
+		path_put(&old_pwd);
 }
 
 static void chroot_fs_refs(struct nameidata *old_nd, struct nameidata *new_nd)
@@ -2094,12 +2087,12 @@ static void chroot_fs_refs(struct nameid
 		if (fs) {
 			atomic_inc(&fs->count);
 			task_unlock(p);
-			if (fs->root == old_nd->path.dentry
-			    && fs->rootmnt == old_nd->path.mnt)
+			if (fs->root.dentry == old_nd->path.dentry
+			    && fs->root.mnt == old_nd->path.mnt)
 				set_fs_root(fs, new_nd->path.mnt,
 					    new_nd->path.dentry);
-			if (fs->pwd == old_nd->path.dentry
-			    && fs->pwdmnt == old_nd->path.mnt)
+			if (fs->pwd.dentry == old_nd->path.dentry
+			    && fs->pwd.mnt == old_nd->path.mnt)
 				set_fs_pwd(fs, new_nd->path.mnt,
 					   new_nd->path.dentry);
 			put_fs_struct(fs);
@@ -2165,8 +2158,8 @@ asmlinkage long sys_pivot_root(const cha
 	}
 
 	read_lock(&current->fs->lock);
-	user_nd.path.mnt = mntget(current->fs->rootmnt);
-	user_nd.path.dentry = dget(current->fs->root);
+	user_nd.path = current->fs->root;
+	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	down_write(&namespace_sem);
 	mutex_lock(&old_nd.path.dentry->d_inode->i_mutex);
diff -puN fs/proc/base.c~use-struct-path-in-fs_struct fs/proc/base.c
--- a/fs/proc/base.c~use-struct-path-in-fs_struct
+++ a/fs/proc/base.c
@@ -161,8 +161,8 @@ static int proc_cwd_link(struct inode *i
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->pwdmnt);
-		*dentry = dget(fs->pwd);
+		*mnt = mntget(fs->pwd.mnt);
+		*dentry = dget(fs->pwd.dentry);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -182,8 +182,8 @@ static int proc_root_link(struct inode *
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->rootmnt);
-		*dentry = dget(fs->root);
+		*mnt = mntget(fs->root.mnt);
+		*dentry = dget(fs->root.dentry);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
diff -puN include/linux/fs_struct.h~use-struct-path-in-fs_struct include/linux/fs_struct.h
--- a/include/linux/fs_struct.h~use-struct-path-in-fs_struct
+++ a/include/linux/fs_struct.h
@@ -1,15 +1,13 @@
 #ifndef _LINUX_FS_STRUCT_H
 #define _LINUX_FS_STRUCT_H
 
-struct dentry;
-struct vfsmount;
+#include <linux/path.h>
 
 struct fs_struct {
 	atomic_t count;
 	rwlock_t lock;
 	int umask;
-	struct dentry * root, * pwd, * altroot;
-	struct vfsmount * rootmnt, * pwdmnt, * altrootmnt;
+	struct path root, pwd, altroot;
 };
 
 #define INIT_FS {				\
diff -puN init/do_mounts.c~use-struct-path-in-fs_struct init/do_mounts.c
--- a/init/do_mounts.c~use-struct-path-in-fs_struct
+++ a/init/do_mounts.c
@@ -286,10 +286,10 @@ static int __init do_mount_root(char *na
 		return err;
 
 	sys_chdir("/root");
-	ROOT_DEV = current->fs->pwdmnt->mnt_sb->s_dev;
+	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s.\n",
-	       current->fs->pwdmnt->mnt_sb->s_type->name,
-	       current->fs->pwdmnt->mnt_sb->s_flags & MS_RDONLY ? 
+	       current->fs->pwd.mnt->mnt_sb->s_type->name,
+	       current->fs->pwd.mnt->mnt_sb->s_flags & MS_RDONLY ?
 	       " readonly" : "");
 	return 0;
 }
diff -puN kernel/auditsc.c~use-struct-path-in-fs_struct kernel/auditsc.c
--- a/kernel/auditsc.c~use-struct-path-in-fs_struct
+++ a/kernel/auditsc.c
@@ -1528,8 +1528,8 @@ void __audit_getname(const char *name)
 	++context->name_count;
 	if (!context->pwd) {
 		read_lock(&current->fs->lock);
-		context->pwd = dget(current->fs->pwd);
-		context->pwdmnt = mntget(current->fs->pwdmnt);
+		context->pwd = dget(current->fs->pwd.dentry);
+		context->pwdmnt = mntget(current->fs->pwd.mnt);
 		read_unlock(&current->fs->lock);
 	}
 
diff -puN kernel/exit.c~use-struct-path-in-fs_struct kernel/exit.c
--- a/kernel/exit.c~use-struct-path-in-fs_struct
+++ a/kernel/exit.c
@@ -514,14 +514,10 @@ static void __put_fs_struct(struct fs_st
 {
 	/* No need to hold fs->lock if we are killing it */
 	if (atomic_dec_and_test(&fs->count)) {
-		dput(fs->root);
-		mntput(fs->rootmnt);
-		dput(fs->pwd);
-		mntput(fs->pwdmnt);
-		if (fs->altroot) {
-			dput(fs->altroot);
-			mntput(fs->altrootmnt);
-		}
+		path_put(&fs->root);
+		path_put(&fs->pwd);
+		if (fs->altroot.dentry)
+			path_put(&fs->altroot);
 		kmem_cache_free(fs_cachep, fs);
 	}
 }
diff -puN kernel/fork.c~use-struct-path-in-fs_struct kernel/fork.c
--- a/kernel/fork.c~use-struct-path-in-fs_struct
+++ a/kernel/fork.c
@@ -598,16 +598,16 @@ static struct fs_struct *__copy_fs_struc
 		rwlock_init(&fs->lock);
 		fs->umask = old->umask;
 		read_lock(&old->lock);
-		fs->rootmnt = mntget(old->rootmnt);
-		fs->root = dget(old->root);
-		fs->pwdmnt = mntget(old->pwdmnt);
-		fs->pwd = dget(old->pwd);
-		if (old->altroot) {
-			fs->altrootmnt = mntget(old->altrootmnt);
-			fs->altroot = dget(old->altroot);
+		fs->root = old->root;
+		path_get(&old->root);
+		fs->pwd = old->pwd;
+		path_get(&old->pwd);
+		if (old->altroot.dentry) {
+			fs->altroot = old->altroot;
+			path_get(&old->altroot);
 		} else {
-			fs->altrootmnt = NULL;
-			fs->altroot = NULL;
+			fs->altroot.mnt = NULL;
+			fs->altroot.dentry = NULL;
 		}
 		read_unlock(&old->lock);
 	}
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
