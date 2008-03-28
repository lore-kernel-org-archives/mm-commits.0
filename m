From: akpm@linux-foundation.org
Subject: - vfs-mountinfo-add-seq_file_root.patch removed from -mm tree
Date: Fri, 28 Mar 2008 12:06:30 -0700
Message-ID: <200803281906.m2SJ6UPf005392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbYC1TR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 15:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: mountinfo: add seq_file_root()
has been removed from the -mm tree.  Its filename was
     vfs-mountinfo-add-seq_file_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo: add seq_file_root()
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new function:

  seq_file_root()

This is similar to seq_path(), but calculates the path relative to the
given root, instead of current->fs->root.  If the path was unreachable
from root, then modify the root parameter to reflect this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c              |   24 ++++++++++++++++--------
 fs/seq_file.c            |   30 ++++++++++++++++++++++++++++++
 include/linux/dcache.h   |    1 +
 include/linux/seq_file.h |    2 ++
 4 files changed, 49 insertions(+), 8 deletions(-)

diff -puN fs/dcache.c~vfs-mountinfo-add-seq_file_root fs/dcache.c
--- a/fs/dcache.c~vfs-mountinfo-add-seq_file_root
+++ a/fs/dcache.c
@@ -1759,10 +1759,8 @@ static int prepend(char **buffer, int *b
 
 /**
  * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
- * @root: root dentry
- * @rootmnt: vfsmnt to which the root dentry belongs
+ * @path: the dentry/vfsmount to report
+ * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: buffer to return value in
  * @buflen: buffer length
  *
@@ -1772,10 +1770,15 @@ static int prepend(char **buffer, int *b
  * Returns the buffer or an error code if the path was too long.
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
+ *
+ * If path is not reachable from the supplied root, then the value of
+ * root is changed (without modifying refcounts).
  */
-static char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-		       struct path *root, char *buffer, int buflen)
+char *__d_path(const struct path *path, struct path *root,
+	       char *buffer, int buflen)
 {
+	struct dentry *dentry = path->dentry;
+	struct vfsmount *vfsmnt = path->mnt;
 	char * end = buffer+buflen;
 	char * retval;
 
@@ -1824,6 +1827,8 @@ global_root:
 	if (prepend(&retval, &buflen, dentry->d_name.name,
 		    dentry->d_name.len) != 0)
 		goto Elong;
+	root->mnt = vfsmnt;
+	root->dentry = dentry;
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1846,6 +1851,7 @@ char *d_path(struct path *path, char *bu
 {
 	char *res;
 	struct path root;
+	struct path tmp;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -1862,7 +1868,8 @@ char *d_path(struct path *path, char *bu
 	path_get(&root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
+	tmp = root;
+	res = __d_path(path, &tmp, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1970,9 +1977,10 @@ asmlinkage long sys_getcwd(char __user *
 	spin_lock(&dcache_lock);
 	if (pwd.dentry->d_parent == pwd.dentry || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
+		struct path tmp = root;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
+		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
diff -puN fs/seq_file.c~vfs-mountinfo-add-seq_file_root fs/seq_file.c
--- a/fs/seq_file.c~vfs-mountinfo-add-seq_file_root
+++ a/fs/seq_file.c
@@ -385,6 +385,36 @@ int seq_path(struct seq_file *m, struct 
 EXPORT_SYMBOL(seq_path);
 
 /*
+ * Same as seq_path, but relative to supplied root.
+ *
+ * root may be changed, see __d_path().
+ */
+int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
+		  char *esc)
+{
+	int err = -ENAMETOOLONG;
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		char *p;
+
+		spin_lock(&dcache_lock);
+		p = __d_path(path, root, s, m->size - m->count);
+		spin_unlock(&dcache_lock);
+		err = PTR_ERR(p);
+		if (!IS_ERR(p)) {
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return 0;
+			}
+		}
+	}
+	m->count = m->size;
+	return err;
+}
+
+/*
  * returns the path of the 'dentry' from the root of its filesystem.
  */
 int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
diff -puN include/linux/dcache.h~vfs-mountinfo-add-seq_file_root include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-mountinfo-add-seq_file_root
+++ a/include/linux/dcache.h
@@ -301,6 +301,7 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
+extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
diff -puN include/linux/seq_file.h~vfs-mountinfo-add-seq_file_root include/linux/seq_file.h
--- a/include/linux/seq_file.h~vfs-mountinfo-add-seq_file_root
+++ a/include/linux/seq_file.h
@@ -45,6 +45,8 @@ int seq_printf(struct seq_file *, const 
 
 int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
+int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
+		  char *esc);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-vfs.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

