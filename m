From: akpm@linux-foundation.org
Subject: + d_path-make-d_path-use-a-struct-path.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:12:04 -0800
Message-ID: <200711052112.lA5LC49C019979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968AbXKEVOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, bryan.wu@analog.com, hch@infradead.org, mhalcrow@us.ibm.com, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     d_path: Make d_path() use a struct path
has been added to the -mm tree.  Its filename is
     d_path-make-d_path-use-a-struct-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: d_path: Make d_path() use a struct path
From: Jan Blunck <jblunck@suse.de>

d_path() is used on a <dentry,vfsmount> pair.  Lets use a struct path to
reflect this.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/traps.c      |   12 +++++-------
 drivers/md/bitmap.c               |    8 +-------
 drivers/usb/gadget/file_storage.c |    8 +++-----
 fs/compat_ioctl.c                 |    2 +-
 fs/dcache.c                       |   12 +++++-------
 fs/dcookies.c                     |    2 +-
 fs/ecryptfs/super.c               |    5 ++---
 fs/nfsd/export.c                  |    2 +-
 fs/proc/base.c                    |    2 +-
 fs/seq_file.c                     |    3 +--
 fs/sysfs/file.c                   |    5 ++---
 fs/unionfs/super.c                |    3 +--
 include/linux/dcache.h            |    5 +++--
 kernel/audit.c                    |    2 +-
 14 files changed, 28 insertions(+), 43 deletions(-)

diff -puN arch/blackfin/kernel/traps.c~d_path-make-d_path-use-a-struct-path arch/blackfin/kernel/traps.c
--- a/arch/blackfin/kernel/traps.c~d_path-make-d_path-use-a-struct-path
+++ a/arch/blackfin/kernel/traps.c
@@ -124,15 +124,13 @@ static void decode_address(char *buf, un
 			struct vm_area_struct *vma = vml->vma;
 
 			if (address >= vma->vm_start && address < vma->vm_end) {
+				char _tmpbuf[256];
 				char *name = p->comm;
 				struct file *file = vma->vm_file;
-				if (file) {
-					char _tmpbuf[256];
-					name = d_path(file->f_dentry,
-					              file->f_vfsmnt,
-					              _tmpbuf,
-					              sizeof(_tmpbuf));
-				}
+
+				if (file)
+					name = d_path(&file->f_path, _tmpbuf,
+						      sizeof(_tmpbuf));
 
 				/* FLAT does not have its text aligned to the start of
 				 * the map while FDPIC ELF does ...
diff -puN drivers/md/bitmap.c~d_path-make-d_path-use-a-struct-path drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~d_path-make-d_path-use-a-struct-path
+++ a/drivers/md/bitmap.c
@@ -206,16 +206,10 @@ static void bitmap_checkfree(struct bitm
 /* copy the pathname of a file to a buffer */
 char *file_path(struct file *file, char *buf, int count)
 {
-	struct dentry *d;
-	struct vfsmount *v;
-
 	if (!buf)
 		return NULL;
 
-	d = file->f_path.dentry;
-	v = file->f_path.mnt;
-
-	buf = d_path(d, v, buf, count);
+	buf = d_path(&file->f_path, buf, count);
 
 	return IS_ERR(buf) ? NULL : buf;
 }
diff -puN drivers/usb/gadget/file_storage.c~d_path-make-d_path-use-a-struct-path drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~d_path-make-d_path-use-a-struct-path
+++ a/drivers/usb/gadget/file_storage.c
@@ -3567,8 +3567,7 @@ static ssize_t show_file(struct device *
 
 	down_read(&fsg->filesem);
 	if (backing_file_is_open(curlun)) {	// Get the complete pathname
-		p = d_path(curlun->filp->f_path.dentry,
-				curlun->filp->f_path.mnt, buf, PAGE_SIZE - 1);
+		p = d_path(&curlun->filp->f_path, buf, PAGE_SIZE - 1);
 		if (IS_ERR(p))
 			rc = PTR_ERR(p);
 		else {
@@ -3985,9 +3984,8 @@ static int __init fsg_bind(struct usb_ga
 		if (backing_file_is_open(curlun)) {
 			p = NULL;
 			if (pathbuf) {
-				p = d_path(curlun->filp->f_path.dentry,
-					curlun->filp->f_path.mnt,
-					pathbuf, PATH_MAX);
+				p = d_path(&curlun->filp->f_path,
+					   pathbuf, PATH_MAX);
 				if (IS_ERR(p))
 					p = NULL;
 			}
diff -puN fs/compat_ioctl.c~d_path-make-d_path-use-a-struct-path fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/compat_ioctl.c
@@ -2839,7 +2839,7 @@ static void compat_ioctl_error(struct fi
 	/* find the name of the device. */
 	path = (char *)__get_free_page(GFP_KERNEL);
 	if (path) {
-		fn = d_path(filp->f_path.dentry, filp->f_path.mnt, path, PAGE_SIZE);
+		fn = d_path(&filp->f_path, path, PAGE_SIZE);
 		if (IS_ERR(fn))
 			fn = "?";
 	}
diff -puN fs/dcache.c~d_path-make-d_path-use-a-struct-path fs/dcache.c
--- a/fs/dcache.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/dcache.c
@@ -1848,8 +1848,7 @@ Elong:
 
 /**
  * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
+ * @path: path to report
  * @buf: buffer to return value in
  * @buflen: buffer length
  *
@@ -1860,8 +1859,7 @@ Elong:
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-	     char *buf, int buflen)
+char *d_path(struct path *path, char *buf, int buflen)
 {
 	char *res;
 	struct path root;
@@ -1873,15 +1871,15 @@ char *d_path(struct dentry *dentry, stru
 	 * user wants to identify the object in /proc/pid/fd/.  The little hack
 	 * below allows us to generate a name for these objects on demand:
 	 */
-	if (dentry->d_op && dentry->d_op->d_dname)
-		return dentry->d_op->d_dname(dentry, buf, buflen);
+	if (path->dentry->d_op && path->dentry->d_op->d_dname)
+		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	read_lock(&current->fs->lock);
 	root = current->fs->root;
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, &root, buf, buflen);
+	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
diff -puN fs/dcookies.c~d_path-make-d_path-use-a-struct-path fs/dcookies.c
--- a/fs/dcookies.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/dcookies.c
@@ -171,7 +171,7 @@ asmlinkage long sys_lookup_dcookie(u64 c
 		goto out;
 
 	/* FIXME: (deleted) ? */
-	path = d_path(dcs->path.dentry, dcs->path.mnt, kbuf, PAGE_SIZE);
+	path = d_path(&dcs->path, kbuf, PAGE_SIZE);
 
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
diff -puN fs/ecryptfs/super.c~d_path-make-d_path-use-a-struct-path fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/ecryptfs/super.c
@@ -163,8 +163,7 @@ static void ecryptfs_clear_inode(struct 
 static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
-	struct dentry *lower_root_dentry = ecryptfs_dentry_to_lower(sb->s_root);
-	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(sb->s_root);
+	struct path *lower_root = &ecryptfs_dentry_to_private(sb->s_root)->lower_path;
 	char *tmp_page;
 	char *path;
 	int rc = 0;
@@ -174,7 +173,7 @@ static int ecryptfs_show_options(struct 
 		rc = -ENOMEM;
 		goto out;
 	}
-	path = d_path(lower_root_dentry, lower_mnt, tmp_page, PAGE_SIZE);
+	path = d_path(lower_root, tmp_page, PAGE_SIZE);
 	if (IS_ERR(path)) {
 		rc = PTR_ERR(path);
 		goto out;
diff -puN fs/nfsd/export.c~d_path-make-d_path-use-a-struct-path fs/nfsd/export.c
--- a/fs/nfsd/export.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/nfsd/export.c
@@ -345,7 +345,7 @@ static void svc_export_request(struct ca
 	char *pth;
 
 	qword_add(bpp, blen, exp->ex_client->name);
-	pth = d_path(exp->ex_path.dentry, exp->ex_path.mnt, *bpp, *blen);
+	pth = d_path(&exp->ex_path, *bpp, *blen);
 	if (IS_ERR(pth)) {
 		/* is this correct? */
 		(*bpp)[0] = '\n';
diff -puN fs/proc/base.c~d_path-make-d_path-use-a-struct-path fs/proc/base.c
--- a/fs/proc/base.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/proc/base.c
@@ -1050,7 +1050,7 @@ static int do_proc_readlink(struct path 
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path(path->dentry, path->mnt, tmp, PAGE_SIZE);
+	pathname = d_path(path, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
diff -puN fs/seq_file.c~d_path-make-d_path-use-a-struct-path fs/seq_file.c
--- a/fs/seq_file.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/seq_file.c
@@ -346,8 +346,7 @@ int seq_path(struct seq_file *m, struct 
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
-		char *p = d_path(path->dentry, path->mnt, s,
-				 m->size - m->count);
+		char *p = d_path(path, s, m->size - m->count);
 		if (!IS_ERR(p)) {
 			while (s <= p) {
 				char c = *p++;
diff -puN fs/sysfs/file.c~d_path-make-d_path-use-a-struct-path fs/sysfs/file.c
--- a/fs/sysfs/file.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/sysfs/file.c
@@ -363,9 +363,8 @@ static int sysfs_open_file(struct inode 
 	int error;
 	char *p;
 
-	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
-		   sizeof(last_sysfs_file));
-	if (p)
+	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
+	if (!IS_ERR(p))
 		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
diff -puN fs/unionfs/super.c~d_path-make-d_path-use-a-struct-path fs/unionfs/super.c
--- a/fs/unionfs/super.c~d_path-make-d_path-use-a-struct-path
+++ a/fs/unionfs/super.c
@@ -974,8 +974,7 @@ static int unionfs_show_options(struct s
 
 	seq_printf(m, ",dirs=");
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		path = d_path(unionfs_lower_dentry_idx(sb->s_root, bindex),
-			      unionfs_lower_mnt_idx(sb->s_root, bindex),
+		path = d_path(&UNIONFS_D(sb->s_root)->lower_paths[bindex],
 			      tmp_page, PAGE_SIZE);
 		if (IS_ERR(path)) {
 			ret = PTR_ERR(path);
diff -puN include/linux/dcache.h~d_path-make-d_path-use-a-struct-path include/linux/dcache.h
--- a/include/linux/dcache.h~d_path-make-d_path-use-a-struct-path
+++ a/include/linux/dcache.h
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 
 struct nameidata;
+struct path;
 struct vfsmount;
 
 /*
@@ -300,8 +301,8 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char * d_path(struct dentry *, struct vfsmount *, char *, int);
-  
+extern char *d_path(struct path *, char *, int);
+
 /* Allocation counts.. */
 
 /**
diff -puN kernel/audit.c~d_path-make-d_path-use-a-struct-path kernel/audit.c
--- a/kernel/audit.c~d_path-make-d_path-use-a-struct-path
+++ a/kernel/audit.c
@@ -1402,7 +1402,7 @@ void audit_log_d_path(struct audit_buffe
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(path->dentry, path->mnt, pathname, PATH_MAX+11);
+	p = d_path(path, pathname, PATH_MAX+11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
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
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
