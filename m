From: akpm@linux-foundation.org
Subject: - vfs-mountinfo-add-dentry_path.patch removed from -mm tree
Date: Fri, 28 Mar 2008 12:06:27 -0700
Message-ID: <200803281906.m2SJ6RT2005389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbYC1TGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 15:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linuxram@us.ibm.com, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: mountinfo: add dentry_path()
has been removed from the -mm tree.  Its filename was
     vfs-mountinfo-add-dentry_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo: add dentry_path()
From: Ram Pai <linuxram@us.ibm.com>

Add the following functions:

  dentry_path()
  seq_dentry()

These are similar to d_path() and seq_path().  But instead of calculating the
path within a mount namespace, they calculate the path from the root of the
filesystem to a given dentry, ignoring mounts completely.

[mszeredi@suse.cz: split big patch into managable chunks]
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c              |   88 +++++++++++++++++++++++++++----------
 fs/seq_file.c            |   65 ++++++++++++++++++++-------
 include/linux/dcache.h   |    1 
 include/linux/seq_file.h |    2 
 4 files changed, 117 insertions(+), 39 deletions(-)

diff -puN fs/dcache.c~vfs-mountinfo-add-dentry_path fs/dcache.c
--- a/fs/dcache.c~vfs-mountinfo-add-dentry_path
+++ a/fs/dcache.c
@@ -1746,6 +1746,17 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
+static int prepend(char **buffer, int *buflen, const char *str,
+			  int namelen)
+{
+	*buflen -= namelen;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
 /**
  * d_path - return the path of a dentry
  * @dentry: dentry to report
@@ -1767,17 +1778,11 @@ static char *__d_path(struct dentry *den
 {
 	char * end = buffer+buflen;
 	char * retval;
-	int namelen;
 
-	*--end = '\0';
-	buflen--;
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		buflen -= 10;
-		end -= 10;
-		if (buflen < 0)
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
-	}
 
 	if (buflen < 1)
 		goto Elong;
@@ -1804,13 +1809,10 @@ static char *__d_path(struct dentry *den
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
 		retval = end;
 		dentry = parent;
 	}
@@ -1818,12 +1820,10 @@ static char *__d_path(struct dentry *den
 	return retval;
 
 global_root:
-	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
+	retval += 1;	/* hit the slash */
+	if (prepend(&retval, &buflen, dentry->d_name.name,
+		    dentry->d_name.len) != 0)
 		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1859,7 +1859,7 @@ char *d_path(struct path *path, char *bu
 
 	read_lock(&current->fs->lock);
 	root = current->fs->root;
-	path_get(&current->fs->root);
+	path_get(&root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
 	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
@@ -1890,6 +1890,48 @@ char *dynamic_dname(struct dentry *dentr
 }
 
 /*
+ * Write full pathname from the root of the filesystem into the buffer.
+ */
+char *dentry_path(struct dentry *dentry, char *buf, int buflen)
+{
+	char *end = buf + buflen;
+	char *retval;
+
+	spin_lock(&dcache_lock);
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, "//deleted", 9) != 0))
+			goto Elong;
+	if (buflen < 1)
+		goto Elong;
+	/* Get '/' right */
+	retval = end-1;
+	*retval = '/';
+
+	for (;;) {
+		struct dentry *parent;
+		if (IS_ROOT(dentry))
+			break;
+
+		parent = dentry->d_parent;
+		prefetch(parent);
+
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
+			goto Elong;
+
+		retval = end;
+		dentry = parent;
+	}
+	spin_unlock(&dcache_lock);
+	return retval;
+Elong:
+	spin_unlock(&dcache_lock);
+	return ERR_PTR(-ENAMETOOLONG);
+}
+
+/*
  * NOTE! The user-level library version returns a
  * character pointer. The kernel system call just
  * returns the length of the buffer filled (which
@@ -1918,9 +1960,9 @@ asmlinkage long sys_getcwd(char __user *
 
 	read_lock(&current->fs->lock);
 	pwd = current->fs->pwd;
-	path_get(&current->fs->pwd);
+	path_get(&pwd);
 	root = current->fs->root;
-	path_get(&current->fs->root);
+	path_get(&root);
 	read_unlock(&current->fs->lock);
 
 	error = -ENOENT;
diff -puN fs/seq_file.c~vfs-mountinfo-add-dentry_path fs/seq_file.c
--- a/fs/seq_file.c~vfs-mountinfo-add-dentry_path
+++ a/fs/seq_file.c
@@ -342,28 +342,40 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
+static char *mangle_path(char *s, char *p, char *esc)
+{
+	while (s <= p) {
+		char c = *p++;
+		if (!c) {
+			return s;
+		} else if (!strchr(esc, c)) {
+			*s++ = c;
+		} else if (s + 4 > p) {
+			break;
+		} else {
+			*s++ = '\\';
+			*s++ = '0' + ((c & 0300) >> 6);
+			*s++ = '0' + ((c & 070) >> 3);
+			*s++ = '0' + (c & 07);
+		}
+	}
+	return NULL;
+}
+
+/*
+ * return the absolute path of 'dentry' residing in mount 'mnt'.
+ */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
 		char *p = d_path(path, s, m->size - m->count);
 		if (!IS_ERR(p)) {
-			while (s <= p) {
-				char c = *p++;
-				if (!c) {
-					p = m->buf + m->count;
-					m->count = s - m->buf;
-					return s - p;
-				} else if (!strchr(esc, c)) {
-					*s++ = c;
-				} else if (s + 4 > p) {
-					break;
-				} else {
-					*s++ = '\\';
-					*s++ = '0' + ((c & 0300) >> 6);
-					*s++ = '0' + ((c & 070) >> 3);
-					*s++ = '0' + (c & 07);
-				}
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return s - p;
 			}
 		}
 	}
@@ -372,6 +384,27 @@ int seq_path(struct seq_file *m, struct 
 }
 EXPORT_SYMBOL(seq_path);
 
+/*
+ * returns the path of the 'dentry' from the root of its filesystem.
+ */
+int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
+{
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		char *p = dentry_path(dentry, s, m->size - m->count);
+		if (!IS_ERR(p)) {
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return s - p;
+			}
+		}
+	}
+	m->count = m->size;
+	return -1;
+}
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
diff -puN include/linux/dcache.h~vfs-mountinfo-add-dentry_path include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-mountinfo-add-dentry_path
+++ a/include/linux/dcache.h
@@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
 
diff -puN include/linux/seq_file.h~vfs-mountinfo-add-dentry_path include/linux/seq_file.h
--- a/include/linux/seq_file.h~vfs-mountinfo-add-dentry_path
+++ a/include/linux/seq_file.h
@@ -11,6 +11,7 @@ struct seq_operations;
 struct file;
 struct path;
 struct inode;
+struct dentry;
 
 struct seq_file {
 	char *buf;
@@ -43,6 +44,7 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));
 
 int seq_path(struct seq_file *, struct path *, char *);
+int seq_dentry(struct seq_file *, struct dentry *, char *);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
_

Patches currently in -mm which might be from linuxram@us.ibm.com are

git-vfs.patch

