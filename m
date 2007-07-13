From: akpm@linux-foundation.org
Subject: + coda-avoid-lockdep-warning-in-coda_readdir.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:39 -0700
Message-ID: <200707130529.l6D5Tduv030811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933182AbXGMFhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: avoid lockdep warning in coda_readdir
has been added to the -mm tree.  Its filename is
     coda-avoid-lockdep-warning-in-coda_readdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: avoid lockdep warning in coda_readdir
From: Jan Harkes <jaharkes@cs.cmu.edu>

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |   98 ++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 44 deletions(-)

diff -puN fs/coda/dir.c~coda-avoid-lockdep-warning-in-coda_readdir fs/coda/dir.c
--- a/fs/coda/dir.c~coda-avoid-lockdep-warning-in-coda_readdir
+++ a/fs/coda/dir.c
@@ -43,15 +43,15 @@ static int coda_rename(struct inode *old
                        struct inode *new_inode, struct dentry *new_dentry);
 
 /* dir file-ops */
-static int coda_readdir(struct file *file, void *dirent, filldir_t filldir);
+static int coda_readdir(struct file *file, void *buf, filldir_t filldir);
 
 /* dentry ops */
 static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd);
 static int coda_dentry_delete(struct dentry *);
 
 /* support routines */
-static int coda_venus_readdir(struct file *filp, filldir_t filldir,
-			      void *dirent, struct dentry *dir);
+static int coda_venus_readdir(struct file *coda_file, void *buf,
+			      filldir_t filldir);
 
 /* same as fs/bad_inode.c */
 static int coda_return_EIO(void)
@@ -448,12 +448,10 @@ static int coda_rename(struct inode *old
 
 
 /* file operations for directories */
-int coda_readdir(struct file *coda_file, void *dirent, filldir_t filldir)
+int coda_readdir(struct file *coda_file, void *buf, filldir_t filldir)
 {
-	struct dentry *coda_dentry = coda_file->f_path.dentry;
 	struct coda_file_info *cfi;
 	struct file *host_file;
-	struct inode *host_inode;
 	int ret;
 
 	cfi = CODA_FTOC(coda_file);
@@ -462,30 +460,31 @@ int coda_readdir(struct file *coda_file,
 
 	coda_vfs_stat.readdir++;
 
-	host_inode = host_file->f_path.dentry->d_inode;
-	mutex_lock(&host_inode->i_mutex);
-	host_file->f_pos = coda_file->f_pos;
-
-	if (!host_file->f_op->readdir) {
-		/* Venus: we must read Venus dirents from the file */
-		ret = coda_venus_readdir(host_file, filldir, dirent, coda_dentry);
-	} else {
-		/* potemkin case: we were handed a directory inode. */
-		/* Yuk, we can't call vfs_readdir because we are already
-		 * holding the inode semaphore. */
-		ret = -ENOTDIR;
-		if (!host_file->f_op || !host_file->f_op->readdir)
-			goto out;
+	if (!host_file->f_op)
+		return -ENOTDIR;
+
+	if (host_file->f_op->readdir)
+	{
+		/* potemkin case: we were handed a directory inode.
+		 * We can't use vfs_readdir because we have to keep the file
+		 * position in sync between the coda_file and the host_file.
+		 * and as such we need grab the inode mutex. */
+		struct inode *host_inode = host_file->f_path.dentry->d_inode;
+
+		mutex_lock(&host_inode->i_mutex);
+		host_file->f_pos = coda_file->f_pos;
 
 		ret = -ENOENT;
 		if (!IS_DEADDIR(host_inode)) {
-			ret = host_file->f_op->readdir(host_file, filldir, dirent);
+			ret = host_file->f_op->readdir(host_file, buf, filldir);
 			file_accessed(host_file);
 		}
+
+		coda_file->f_pos = host_file->f_pos;
+		mutex_unlock(&host_inode->i_mutex);
 	}
-out:
-	coda_file->f_pos = host_file->f_pos;
-	mutex_unlock(&host_inode->i_mutex);
+	else /* Venus: we must read Venus dirents from a file */
+		ret = coda_venus_readdir(coda_file, buf, filldir);
 
 	return ret;
 }
@@ -510,57 +509,68 @@ static inline unsigned int CDT2DT(unsign
 }
 
 /* support routines */
-static int coda_venus_readdir(struct file *filp, filldir_t filldir,
-			      void *dirent, struct dentry *dir)
+static int coda_venus_readdir(struct file *coda_file, void *buf,
+			      filldir_t filldir)
 {
 	int result = 0; /* # of entries returned */
+	struct coda_file_info *cfi;
+	struct coda_inode_info *cii;
+	struct file *host_file;
+	struct dentry *de;
 	struct venus_dirent *vdir;
 	unsigned long vdir_size =
 	    (unsigned long)(&((struct venus_dirent *)0)->d_name);
 	unsigned int type;
 	struct qstr name;
 	ino_t ino;
-	int ret, i;
+	int ret;
+
+	cfi = CODA_FTOC(coda_file);
+	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
+	host_file = cfi->cfi_container;
+
+	de = coda_file->f_path.dentry;
+	cii = ITOC(de->d_inode);
 
 	vdir = kmalloc(sizeof(*vdir), GFP_KERNEL);
 	if (!vdir) return -ENOMEM;
 
-	i = filp->f_pos;
-	switch(i) {
+	switch (coda_file->f_pos) {
 	case 0:
-		ret = filldir(dirent, ".", 1, 0, dir->d_inode->i_ino, DT_DIR);
+		ret = filldir(buf, ".", 1, 0, de->d_inode->i_ino, DT_DIR);
 		if (ret < 0) break;
 		result++;
-		filp->f_pos++;
+		coda_file->f_pos++;
 		/* fallthrough */
 	case 1:
-		ret = filldir(dirent, "..", 2, 1, dir->d_parent->d_inode->i_ino, DT_DIR);
+		ret = filldir(buf, "..", 2, 1, de->d_parent->d_inode->i_ino, DT_DIR);
 		if (ret < 0) break;
 		result++;
-		filp->f_pos++;
+		coda_file->f_pos++;
 		/* fallthrough */
 	default:
 	while (1) {
 		/* read entries from the directory file */
-		ret = kernel_read(filp, filp->f_pos - 2, (char *)vdir,
+		ret = kernel_read(host_file, coda_file->f_pos - 2, (char *)vdir,
 				  sizeof(*vdir));
 		if (ret < 0) {
-			printk("coda_venus_readdir: read dir failed %d\n", ret);
+			printk(KERN_ERR "coda readdir: read dir %s failed %d\n",
+			       coda_f2s(&cii->c_fid), ret);
 			break;
 		}
 		if (ret == 0) break; /* end of directory file reached */
 
 		/* catch truncated reads */
 		if (ret < vdir_size || ret < vdir_size + vdir->d_namlen) {
-			printk("coda_venus_readdir: short read: %ld\n",
-			       filp->f_path.dentry->d_inode->i_ino);
+			printk(KERN_ERR "coda readdir: short read on %s\n",
+			       coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
 		}
 		/* validate whether the directory file actually makes sense */
 		if (vdir->d_reclen < vdir_size + vdir->d_namlen) {
-			printk("coda_venus_readdir: Invalid dir: %ld\n",
-			       filp->f_path.dentry->d_inode->i_ino);
+			printk(KERN_ERR "coda readdir: invalid dir %s\n",
+			       coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
 		}
@@ -579,21 +589,21 @@ static int coda_venus_readdir(struct fil
 			 * userspace doesn't have to worry about breaking
 			 * getcwd by having mismatched inode numbers for
 			 * internal volume mountpoints. */
-			ino = find_inode_number(dir, &name);
+			ino = find_inode_number(de, &name);
 			if (!ino) ino = vdir->d_fileno;
 
 			type = CDT2DT(vdir->d_type);
-			ret = filldir(dirent, name.name, name.len, filp->f_pos,
-				      ino, type); 
+			ret = filldir(buf, name.name, name.len,
+				      coda_file->f_pos, ino, type);
 			/* failure means no space for filling in this round */
 			if (ret < 0) break;
 			result++;
 		}
 		/* we'll always have progress because d_reclen is unsigned and
 		 * we've already established it is non-zero. */
-		filp->f_pos += vdir->d_reclen;
+		coda_file->f_pos += vdir->d_reclen;
+	}
 	}
-	} 
 	kfree(vdir);
 	return result ? result : ret;
 }
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
