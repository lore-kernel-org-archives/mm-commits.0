From: akpm@linux-foundation.org
Subject: - merge-open_namei-and-do_filp_open.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:12 -0700
Message-ID: <200803261840.m2QIeCXI028640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757872AbYCZSlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     merge open_namei() and do_filp_open()
has been removed from the -mm tree.  Its filename was
     merge-open_namei-and-do_filp_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: merge open_namei() and do_filp_open()
From: Dave Hansen <haveblue@us.ibm.com>

open_namei() will, in the future, need to take mount write counts over its
creation and truncation (via may_open()) operations.  It needs to keep these
write counts until any potential filp that is created gets __fput()'d.

This gets complicated in the error handling and becomes very murky as to how
far open_namei() actually got, and whether or not that mount write count was
taken.  That makes it a bad interface.

All that the current do_filp_open() really does is allocate the nameidata on
the stack, then call open_namei().

So, this merges those two functions and moves filp_open() over to namei.c so
it can be close to its buddy: do_filp_open().  It also gets a kerneldoc
comment in the process.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |  100 ++++++++++++++++++++++++-------------------
 fs/open.c          |   19 --------
 include/linux/fs.h |    3 -
 3 files changed, 59 insertions(+), 63 deletions(-)

diff -puN fs/namei.c~merge-open_namei-and-do_filp_open fs/namei.c
--- a/fs/namei.c~merge-open_namei-and-do_filp_open
+++ a/fs/namei.c
@@ -1725,17 +1725,13 @@ static inline int open_to_namei_flags(in
 }
 
 /*
- *	open_namei()
- *
- * namei for open - this is in fact almost the whole open-routine.
- *
  * Note that the low bits of "flag" aren't the same as in the open
  * system call.  See open_to_namei_flags().
- * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int open_flag,
-		int mode, struct nameidata *nd)
+struct file *do_filp_open(int dfd, const char *pathname,
+		int open_flag, int mode)
 {
+	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
@@ -1758,18 +1754,19 @@ int open_namei(int dfd, const char *path
 	 */
 	if (!(flag & O_CREAT)) {
 		error = path_lookup_open(dfd, pathname, lookup_flags(flag),
-					 nd, flag);
+					 &nd, flag);
 		if (error)
-			return error;
+			return ERR_PTR(error);
 		goto ok;
 	}
 
 	/*
 	 * Create - we need to know the parent.
 	 */
-	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
+	error = path_lookup_create(dfd, pathname, LOOKUP_PARENT,
+				   &nd, flag, mode);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	/*
 	 * We have the parent and last component. First of all, check
@@ -1777,14 +1774,14 @@ int open_namei(int dfd, const char *path
 	 * will not do.
 	 */
 	error = -EISDIR;
-	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
+	if (nd.last_type != LAST_NORM || nd.last.name[nd.last.len])
 		goto exit;
 
-	dir = nd->path.dentry;
-	nd->flags &= ~LOOKUP_PARENT;
+	dir = nd.path.dentry;
+	nd.flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->path.mnt;
+	path.dentry = lookup_hash(&nd);
+	path.mnt = nd.path.mnt;
 
 do_last:
 	error = PTR_ERR(path.dentry);
@@ -1793,18 +1790,18 @@ do_last:
 		goto exit;
 	}
 
-	if (IS_ERR(nd->intent.open.file)) {
+	if (IS_ERR(nd.intent.open.file)) {
 		mutex_unlock(&dir->d_inode->i_mutex);
-		error = PTR_ERR(nd->intent.open.file);
+		error = PTR_ERR(nd.intent.open.file);
 		goto exit_dput;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = __open_namei_create(nd, &path, flag, mode);
+		error = __open_namei_create(&nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return 0;
+		return nameidata_to_filp(&nd, open_flag);
 	}
 
 	/*
@@ -1829,23 +1826,23 @@ do_last:
 	if (path.dentry->d_inode->i_op && path.dentry->d_inode->i_op->follow_link)
 		goto do_link;
 
-	path_to_nameidata(&path, nd);
+	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
-	error = may_open(nd, acc_mode, flag);
+	error = may_open(&nd, acc_mode, flag);
 	if (error)
 		goto exit;
-	return 0;
+	return nameidata_to_filp(&nd, open_flag);
 
 exit_dput:
-	path_put_conditional(&path, nd);
+	path_put_conditional(&path, &nd);
 exit:
-	if (!IS_ERR(nd->intent.open.file))
-		release_open_intent(nd);
-	path_put(&nd->path);
-	return error;
+	if (!IS_ERR(nd.intent.open.file))
+		release_open_intent(&nd);
+	path_put(&nd.path);
+	return ERR_PTR(error);
 
 do_link:
 	error = -ELOOP;
@@ -1861,43 +1858,60 @@ do_link:
 	 * stored in nd->last.name and we will have to putname() it when we
 	 * are done. Procfs-like symlinks just set LAST_BIND.
 	 */
-	nd->flags |= LOOKUP_PARENT;
-	error = security_inode_follow_link(path.dentry, nd);
+	nd.flags |= LOOKUP_PARENT;
+	error = security_inode_follow_link(path.dentry, &nd);
 	if (error)
 		goto exit_dput;
-	error = __do_follow_link(&path, nd);
+	error = __do_follow_link(&path, &nd);
 	if (error) {
 		/* Does someone understand code flow here? Or it is only
 		 * me so stupid? Anathema to whoever designed this non-sense
 		 * with "intent.open".
 		 */
-		release_open_intent(nd);
-		return error;
+		release_open_intent(&nd);
+		return ERR_PTR(error);
 	}
-	nd->flags &= ~LOOKUP_PARENT;
-	if (nd->last_type == LAST_BIND)
+	nd.flags &= ~LOOKUP_PARENT;
+	if (nd.last_type == LAST_BIND)
 		goto ok;
 	error = -EISDIR;
-	if (nd->last_type != LAST_NORM)
+	if (nd.last_type != LAST_NORM)
 		goto exit;
-	if (nd->last.name[nd->last.len]) {
-		__putname(nd->last.name);
+	if (nd.last.name[nd.last.len]) {
+		__putname(nd.last.name);
 		goto exit;
 	}
 	error = -ELOOP;
 	if (count++==32) {
-		__putname(nd->last.name);
+		__putname(nd.last.name);
 		goto exit;
 	}
-	dir = nd->path.dentry;
+	dir = nd.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->path.mnt;
-	__putname(nd->last.name);
+	path.dentry = lookup_hash(&nd);
+	path.mnt = nd.path.mnt;
+	__putname(nd.last.name);
 	goto do_last;
 }
 
 /**
+ * filp_open - open file and return file pointer
+ *
+ * @filename:	path to open
+ * @flags:	open flags as per the open(2) second argument
+ * @mode:	mode for the new file if O_CREAT is set, else ignored
+ *
+ * This is the helper to open a file from kernelspace if you really
+ * have to.  But in generally you should not do this, so please move
+ * along, nothing to see here..
+ */
+struct file *filp_open(const char *filename, int flags, int mode)
+{
+	return do_filp_open(AT_FDCWD, filename, flags, mode);
+}
+EXPORT_SYMBOL(filp_open);
+
+/**
  * lookup_create - lookup a dentry, creating it if it doesn't exist
  * @nd: nameidata info
  * @is_dir: directory flag
diff -puN fs/open.c~merge-open_namei-and-do_filp_open fs/open.c
--- a/fs/open.c~merge-open_namei-and-do_filp_open
+++ a/fs/open.c
@@ -796,25 +796,6 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-static struct file *do_filp_open(int dfd, const char *filename, int flags,
-				 int mode)
-{
-	int error;
-	struct nameidata nd;
-
-	error = open_namei(dfd, filename, flags, mode, &nd);
-	if (!error)
-		return nameidata_to_filp(&nd, flags);
-
-	return ERR_PTR(error);
-}
-
-struct file *filp_open(const char *filename, int flags, int mode)
-{
-	return do_filp_open(AT_FDCWD, filename, flags, mode);
-}
-EXPORT_SYMBOL(filp_open);
-
 /**
  * lookup_instantiate_filp - instantiates the open intent filp
  * @nd: pointer to nameidata
diff -puN include/linux/fs.h~merge-open_namei-and-do_filp_open include/linux/fs.h
--- a/include/linux/fs.h~merge-open_namei-and-do_filp_open
+++ a/include/linux/fs.h
@@ -1734,7 +1734,8 @@ extern struct file *create_read_pipe(str
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
 
-extern int open_namei(int dfd, const char *, int, int, struct nameidata *);
+extern struct file *do_filp_open(int dfd, const char *pathname,
+		int open_flag, int mode);
 extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

