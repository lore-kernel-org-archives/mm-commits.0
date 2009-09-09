From: akpm@linux-foundation.org
Subject: + vfs-seq_file-add-helpers-for-data-filling.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:15:09 -0700
Message-ID: <200909092115.n89LF9eq016300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbZIIVPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de, hugh.dickins@tiscali.co.uk, matthew@wil.cx, viro@zeniv.linux.org.uk


The patch titled
     vfs: seq_file: add helpers for data filling
has been added to the -mm tree.  Its filename is
     vfs-seq_file-add-helpers-for-data-filling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: seq_file: add helpers for data filling
From: Miklos Szeredi <mszeredi@suse.cz>

Add two helpers that allow access to the seq_file's own buffer, but
hides the internal details of seq_files.

This allows easier implementation of special purpose filling
functions.  It also cleans up some existing functions which duplicated
the seq_file logic.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |  113 +++++++++++++++++++++++++------------
 include/linux/seq_file.h |    3 
 2 files changed, 80 insertions(+), 36 deletions(-)

diff -puN fs/seq_file.c~vfs-seq_file-add-helpers-for-data-filling fs/seq_file.c
--- a/fs/seq_file.c~vfs-seq_file-add-helpers-for-data-filling
+++ a/fs/seq_file.c
@@ -419,6 +419,44 @@ char *mangle_path(char *s, char *p, char
 EXPORT_SYMBOL(mangle_path);
 
 /**
+ * seq_get_buf - get buffer to write arbitrary data to
+ * @m: the seq_file handle
+ * @bufp: the beginning of the buffer is stored here
+ *
+ * Return the number of bytes available in the buffer, or zero if
+ * there's no space.
+ */
+size_t seq_get_buf(struct seq_file *m, char **bufp)
+{
+	BUG_ON(m->count > m->size);
+	if (m->count < m->size)
+		*bufp = m->buf + m->count;
+	else
+		*bufp = NULL;
+
+	return m->size - m->count;
+}
+
+/**
+ * seq_commit - commit data to the buffer
+ * @m: the seq_file handle
+ * @num: the number of bytes to commit
+ *
+ * Commit @num bytes of data written to a buffer previously acquired
+ * by seq_buf_get.  To signal an error condition, or that the data
+ * didn't fit in the available space, pass a negative @num value.
+ */
+void seq_commit(struct seq_file *m, int num)
+{
+	if (num < 0) {
+		m->count = m->size;
+	} else {
+		BUG_ON(m->count + num > m->size);
+		m->count += num;
+	}
+}
+
+/**
  * seq_path - seq_file interface to print a pathname
  * @m: the seq_file handle
  * @path: the struct path to print
@@ -429,20 +467,21 @@ EXPORT_SYMBOL(mangle_path);
  */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
-	if (m->count < m->size) {
-		char *s = m->buf + m->count;
-		char *p = d_path(path, s, m->size - m->count);
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = d_path(path, buf, size);
 		if (!IS_ERR(p)) {
-			s = mangle_path(s, p, esc);
-			if (s) {
-				p = m->buf + m->count;
-				m->count = s - m->buf;
-				return s - p;
-			}
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
 		}
 	}
-	m->count = m->size;
-	return -1;
+	seq_commit(m, res);
+
+	return res;
 }
 EXPORT_SYMBOL(seq_path);
 
@@ -454,27 +493,28 @@ EXPORT_SYMBOL(seq_path);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc)
 {
-	int err = -ENAMETOOLONG;
-	if (m->count < m->size) {
-		char *s = m->buf + m->count;
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -ENAMETOOLONG;
+
+	if (size) {
 		char *p;
 
 		spin_lock(&dcache_lock);
-		p = __d_path(path, root, s, m->size - m->count);
+		p = __d_path(path, root, buf, size);
 		spin_unlock(&dcache_lock);
-		err = PTR_ERR(p);
+		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
-			s = mangle_path(s, p, esc);
-			if (s) {
-				p = m->buf + m->count;
-				m->count = s - m->buf;
-				return 0;
-			}
-			err = -ENAMETOOLONG;
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+			else
+				res = -ENAMETOOLONG;
 		}
 	}
-	m->count = m->size;
-	return err;
+	seq_commit(m, res);
+
+	return res < 0 ? res : 0;
 }
 
 /*
@@ -482,20 +522,21 @@ int seq_path_root(struct seq_file *m, st
  */
 int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
 {
-	if (m->count < m->size) {
-		char *s = m->buf + m->count;
-		char *p = dentry_path(dentry, s, m->size - m->count);
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = dentry_path(dentry, buf, size);
 		if (!IS_ERR(p)) {
-			s = mangle_path(s, p, esc);
-			if (s) {
-				p = m->buf + m->count;
-				m->count = s - m->buf;
-				return s - p;
-			}
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
 		}
 	}
-	m->count = m->size;
-	return -1;
+	seq_commit(m, res);
+
+	return res;
 }
 
 int seq_bitmap(struct seq_file *m, const unsigned long *bits,
diff -puN include/linux/seq_file.h~vfs-seq_file-add-helpers-for-data-filling include/linux/seq_file.h
--- a/include/linux/seq_file.h~vfs-seq_file-add-helpers-for-data-filling
+++ a/include/linux/seq_file.h
@@ -48,6 +48,9 @@ int seq_write(struct seq_file *seq, cons
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
 
+size_t seq_get_buf(struct seq_file *m, char **bufp);
+void seq_commit(struct seq_file *m, int num);
+
 int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch

