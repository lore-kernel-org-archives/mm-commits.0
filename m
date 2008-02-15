From: akpm@linux-foundation.org
Subject: - d_path-make-d_path-use-a-struct-path.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:17:14 -0500
Message-ID: <200802150720.m1F7KaZ3025838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764815AbYBOHaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, bfields@fieldses.org, bryan.wu@analog.com, hch@infradead.org, mhalcrow@us.ibm.com, neilb@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     d_path: Make d_path() use a struct path
has been removed from the -mm tree.  Its filename was
     d_path-make-d_path-use-a-struct-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: d_path: Make d_path() use a struct path
From: Jan Blunck <jblunck@suse.de>

d_path() is used on a <dentry,vfsmount> pair.  Lets use a struct path to
reflect this.

[akpm@linux-foundation.org: fix build in mm/memory.c]
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
 fs/nfsd/export.c                  |    2 +-
 fs/proc/base.c                    |    2 +-
 fs/seq_file.c                     |    3 +--
 include/linux/dcache.h            |    5 +++--
 kernel/audit.c                    |    2 +-
 mm/memory.c                       |    2 +-
 12 files changed, 24 insertions(+), 36 deletions(-)

diff -puN arch/blackfin/kernel/traps.c~d_path-make-d_path-use-a-struct-path arch/blackfin/kernel/traps.c
--- a/arch/blackfin/kernel/traps.c~d_path-make-d_path-use-a-struct-path
+++ a/arch/blackfin/kernel/traps.c
@@ -126,15 +126,13 @@ static void decode_address(char *buf, un
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
@@ -3563,8 +3563,7 @@ static ssize_t show_file(struct device *
 
 	down_read(&fsg->filesem);
 	if (backing_file_is_open(curlun)) {	// Get the complete pathname
-		p = d_path(curlun->filp->f_path.dentry,
-				curlun->filp->f_path.mnt, buf, PAGE_SIZE - 1);
+		p = d_path(&curlun->filp->f_path, buf, PAGE_SIZE - 1);
 		if (IS_ERR(p))
 			rc = PTR_ERR(p);
 		else {
@@ -3981,9 +3980,8 @@ static int __init fsg_bind(struct usb_ga
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
@@ -2853,7 +2853,7 @@ static void compat_ioctl_error(struct fi
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
@@ -1845,8 +1845,7 @@ Elong:
 
 /**
  * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
+ * @path: path to report
  * @buf: buffer to return value in
  * @buflen: buffer length
  *
@@ -1857,8 +1856,7 @@ Elong:
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-	     char *buf, int buflen)
+char *d_path(struct path *path, char *buf, int buflen)
 {
 	char *res;
 	struct path root;
@@ -1870,15 +1868,15 @@ char *d_path(struct dentry *dentry, stru
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
@@ -1185,7 +1185,7 @@ static int do_proc_readlink(struct path 
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
@@ -1325,7 +1325,7 @@ void audit_log_d_path(struct audit_buffe
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(path->dentry, path->mnt, pathname, PATH_MAX+11);
+	p = d_path(path, pathname, PATH_MAX+11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
diff -puN mm/memory.c~d_path-make-d_path-use-a-struct-path mm/memory.c
--- a/mm/memory.c~d_path-make-d_path-use-a-struct-path
+++ a/mm/memory.c
@@ -2719,7 +2719,7 @@ void print_vma_addr(char *prefix, unsign
 		if (buf) {
 			char *p, *s;
 
-			p = d_path(f->f_dentry, f->f_vfsmnt, buf, PAGE_SIZE);
+			p = d_path(&f->f_path, buf, PAGE_SIZE);
 			if (IS_ERR(p))
 				p = "?";
 			s = strrchr(p, '/');
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
introduce-path_put-unionfs.patch
