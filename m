From: akpm@linux-foundation.org
Subject: + d_path-make-get_dcookie-use-a-struct-path-argument.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:07:01 -0800
Message-ID: <200711052107.lA5L719T019773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbXKEVHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, hch@infradead.org, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     d_path: Make get_dcookie() use a struct path argument
has been added to the -mm tree.  Its filename is
     d_path-make-get_dcookie-use-a-struct-path-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: d_path: Make get_dcookie() use a struct path argument
From: Jan Blunck <jblunck@suse.de>

get_dcookie() is always called with a dentry and a vfsmount from a struct
path.  Make get_dcookie() take it directly as an argument.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/oprofile/cell/spu_task_sync.c |   15 +++------
 drivers/oprofile/buffer_sync.c             |   21 +++++-------
 fs/dcookies.c                              |   31 +++++++------------
 include/linux/dcookies.h                   |   15 ++++-----
 4 files changed, 35 insertions(+), 47 deletions(-)

diff -puN arch/powerpc/oprofile/cell/spu_task_sync.c~d_path-make-get_dcookie-use-a-struct-path-argument arch/powerpc/oprofile/cell/spu_task_sync.c
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c~d_path-make-get_dcookie-use-a-struct-path-argument
+++ a/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -198,14 +198,13 @@ out:
  * dcookie user still being registered (namely, the reader
  * of the event buffer).
  */
-static inline unsigned long fast_get_dcookie(struct dentry *dentry,
-					     struct vfsmount *vfsmnt)
+static inline unsigned long fast_get_dcookie(struct path *path)
 {
 	unsigned long cookie;
 
-	if (dentry->d_cookie)
-		return (unsigned long)dentry;
-	get_dcookie(dentry, vfsmnt, &cookie);
+	if (path->dentry->d_cookie)
+		return (unsigned long)path->dentry;
+	get_dcookie(path, &cookie);
 	return cookie;
 }
 
@@ -240,8 +239,7 @@ get_exec_dcookie_and_offset(struct spu *
 			continue;
 		if (!(vma->vm_flags & VM_EXECUTABLE))
 			continue;
-		app_cookie = fast_get_dcookie(vma->vm_file->f_dentry,
-					  vma->vm_file->f_vfsmnt);
+		app_cookie = fast_get_dcookie(&vma->vm_file->f_path);
 		pr_debug("got dcookie for %s\n",
 			 vma->vm_file->f_dentry->d_name.name);
 		app = vma->vm_file;
@@ -262,8 +260,7 @@ get_exec_dcookie_and_offset(struct spu *
 		break;
 	}
 
-	*spu_bin_dcookie = fast_get_dcookie(vma->vm_file->f_dentry,
-						 vma->vm_file->f_vfsmnt);
+	*spu_bin_dcookie = fast_get_dcookie(&vma->vm_file->f_path);
 	pr_debug("got dcookie for %s\n", vma->vm_file->f_dentry->d_name.name);
 
 	up_read(&mm->mmap_sem);
diff -puN drivers/oprofile/buffer_sync.c~d_path-make-get_dcookie-use-a-struct-path-argument drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~d_path-make-get_dcookie-use-a-struct-path-argument
+++ a/drivers/oprofile/buffer_sync.c
@@ -187,23 +187,22 @@ void sync_stop(void)
 	end_sync();
 }
 
- 
+
 /* Optimisation. We can manage without taking the dcookie sem
  * because we cannot reach this code without at least one
  * dcookie user still being registered (namely, the reader
  * of the event buffer). */
-static inline unsigned long fast_get_dcookie(struct dentry * dentry,
-	struct vfsmount * vfsmnt)
+static inline unsigned long fast_get_dcookie(struct path *path)
 {
 	unsigned long cookie;
- 
-	if (dentry->d_cookie)
-		return (unsigned long)dentry;
-	get_dcookie(dentry, vfsmnt, &cookie);
+
+	if (path->dentry->d_cookie)
+		return (unsigned long)path->dentry;
+	get_dcookie(path, &cookie);
 	return cookie;
 }
 
- 
+
 /* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
  * which corresponds loosely to "application name". This is
  * not strictly necessary but allows oprofile to associate
@@ -222,8 +221,7 @@ static unsigned long get_exec_dcookie(st
 			continue;
 		if (!(vma->vm_flags & VM_EXECUTABLE))
 			continue;
-		cookie = fast_get_dcookie(vma->vm_file->f_path.dentry,
-			vma->vm_file->f_path.mnt);
+		cookie = fast_get_dcookie(&vma->vm_file->f_path);
 		break;
 	}
 
@@ -248,8 +246,7 @@ static unsigned long lookup_dcookie(stru
 			continue;
 
 		if (vma->vm_file) {
-			cookie = fast_get_dcookie(vma->vm_file->f_path.dentry,
-				vma->vm_file->f_path.mnt);
+			cookie = fast_get_dcookie(&vma->vm_file->f_path);
 			*offset = (vma->vm_pgoff << PAGE_SHIFT) + addr -
 				vma->vm_start;
 		} else {
diff -puN fs/dcookies.c~d_path-make-get_dcookie-use-a-struct-path-argument fs/dcookies.c
--- a/fs/dcookies.c~d_path-make-get_dcookie-use-a-struct-path-argument
+++ a/fs/dcookies.c
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/dcookies.h>
 #include <linux/mutex.h>
+#include <linux/path.h>
 #include <asm/uaccess.h>
 
 /* The dcookies are allocated from a kmem_cache and
@@ -31,8 +32,7 @@
  * code here is particularly performance critical
  */
 struct dcookie_struct {
-	struct dentry * dentry;
-	struct vfsmount * vfsmnt;
+	struct path path;
 	struct list_head hash_list;
 };
 
@@ -51,7 +51,7 @@ static inline int is_live(void)
 /* The dentry is locked, its address will do for the cookie */
 static inline unsigned long dcookie_value(struct dcookie_struct * dcs)
 {
-	return (unsigned long)dcs->dentry;
+	return (unsigned long)dcs->path.dentry;
 }
 
 
@@ -89,19 +89,16 @@ static void hash_dcookie(struct dcookie_
 }
 
 
-static struct dcookie_struct * alloc_dcookie(struct dentry * dentry,
-	struct vfsmount * vfsmnt)
+static struct dcookie_struct * alloc_dcookie(struct path *path)
 {
 	struct dcookie_struct * dcs = kmem_cache_alloc(dcookie_cache, GFP_KERNEL);
 	if (!dcs)
 		return NULL;
 
-	dentry->d_cookie = dcs;
-
-	dcs->dentry = dget(dentry);
-	dcs->vfsmnt = mntget(vfsmnt);
+	path->dentry->d_cookie = dcs;
+	dcs->path = *path;
+	path_get(path);
 	hash_dcookie(dcs);
-
 	return dcs;
 }
 
@@ -109,8 +106,7 @@ static struct dcookie_struct * alloc_dco
 /* This is the main kernel-side routine that retrieves the cookie
  * value for a dentry/vfsmnt pair.
  */
-int get_dcookie(struct dentry * dentry, struct vfsmount * vfsmnt,
-	unsigned long * cookie)
+int get_dcookie(struct path *path, unsigned long * cookie)
 {
 	int err = 0;
 	struct dcookie_struct * dcs;
@@ -122,10 +118,10 @@ int get_dcookie(struct dentry * dentry, 
 		goto out;
 	}
 
-	dcs = dentry->d_cookie;
+	dcs = path->dentry->d_cookie;
 
 	if (!dcs)
-		dcs = alloc_dcookie(dentry, vfsmnt);
+		dcs = alloc_dcookie(path);
 
 	if (!dcs) {
 		err = -ENOMEM;
@@ -174,7 +170,7 @@ asmlinkage long sys_lookup_dcookie(u64 c
 		goto out;
 
 	/* FIXME: (deleted) ? */
-	path = d_path(dcs->dentry, dcs->vfsmnt, kbuf, PAGE_SIZE);
+	path = d_path(dcs->path.dentry, dcs->path.mnt, kbuf, PAGE_SIZE);
 
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
@@ -254,9 +250,8 @@ out_kmem:
 
 static void free_dcookie(struct dcookie_struct * dcs)
 {
-	dcs->dentry->d_cookie = NULL;
-	dput(dcs->dentry);
-	mntput(dcs->vfsmnt);
+	dcs->path.dentry->d_cookie = NULL;
+	path_put(&dcs->path);
 	kmem_cache_free(dcookie_cache, dcs);
 }
 
diff -puN include/linux/dcookies.h~d_path-make-get_dcookie-use-a-struct-path-argument include/linux/dcookies.h
--- a/include/linux/dcookies.h~d_path-make-get_dcookie-use-a-struct-path-argument
+++ a/include/linux/dcookies.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PROFILING
  
 #include <linux/dcache.h>
+#include <linux/path.h>
 #include <linux/types.h>
  
 struct dcookie_user;
@@ -43,8 +44,7 @@ void dcookie_unregister(struct dcookie_u
  *
  * Returns 0 on success, with *cookie filled in
  */
-int get_dcookie(struct dentry * dentry, struct vfsmount * vfsmnt,
-	unsigned long * cookie);
+int get_dcookie(struct path *path, unsigned long *cookie);
 
 #else
 
@@ -57,13 +57,12 @@ static inline void dcookie_unregister(st
 {
 	return;
 }
- 
-static inline int get_dcookie(struct dentry * dentry,
-	struct vfsmount * vfsmnt, unsigned long * cookie)
+
+static inline int get_dcookie(struct path *path, unsigned long *cookie)
 {
 	return -ENOSYS;
-} 
- 
+}
+
 #endif /* CONFIG_PROFILING */
- 
+
 #endif /* DCOOKIES_H */
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
