From: akpm@linux-foundation.org
Subject: - fix-up-new-filp-allocators.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:42 -0800
Message-ID: <200802150531.m1F5VgAX021816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066AbYBOFi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, bfields@fieldses.org, ezk@cs.sunysb.edu, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     fix up new filp allocators
has been removed from the -mm tree.  Its filename was
     fix-up-new-filp-allocators.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix up new filp allocators
From: Dave Hansen <haveblue@us.ibm.com>

Some new uses of get_empty_filp() have crept in, and are
not properly taking mnt_want_write()s.  This fixes them
up.

We really need to kill get_empty_filp().

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c    |   16 ++++++----------
 fs/file_table.c     |    6 ++++++
 fs/nfsd/nfs4state.c |    3 ++-
 fs/pipe.c           |   17 +++++++----------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/anon_inodes.c~fix-up-new-filp-allocators fs/anon_inodes.c
--- a/fs/anon_inodes.c~fix-up-new-filp-allocators
+++ a/fs/anon_inodes.c
@@ -81,13 +81,10 @@ int anon_inode_getfd(int *pfd, struct in
 
 	if (IS_ERR(anon_inode_inode))
 		return -ENODEV;
-	file = get_empty_filp();
-	if (!file)
-		return -ENFILE;
 
 	error = get_unused_fd();
 	if (error < 0)
-		goto err_put_filp;
+		return error;
 	fd = error;
 
 	/*
@@ -114,14 +111,15 @@ int anon_inode_getfd(int *pfd, struct in
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, anon_inode_inode);
 
-	file->f_path.mnt = mntget(anon_inode_mnt);
-	file->f_path.dentry = dentry;
+	error = -ENFILE;
+	file = alloc_file(anon_inode_mnt, dentry,
+			  FMODE_READ | FMODE_WRITE, fops);
+	if (!file)
+		goto err_put_unused_fd;
 	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
 	file->f_flags = O_RDWR;
-	file->f_op = fops;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
 	file->f_version = 0;
 	file->private_data = priv;
 
@@ -134,8 +132,6 @@ int anon_inode_getfd(int *pfd, struct in
 
 err_put_unused_fd:
 	put_unused_fd(fd);
-err_put_filp:
-	put_filp(file);
 	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
diff -puN fs/file_table.c~fix-up-new-filp-allocators fs/file_table.c
--- a/fs/file_table.c~fix-up-new-filp-allocators
+++ a/fs/file_table.c
@@ -89,6 +89,12 @@ int proc_nr_files(ctl_table *table, int 
 /* Find an unused file structure and return a pointer to it.
  * Returns NULL, if there are no more free file structures or
  * we run out of memory.
+ *
+ * Be very careful using this.  You are responsible for
+ * getting write access to any mount that you might assign
+ * to this filp, if it is opened for write.  If this is not
+ * done, you will imbalance int the mount's writer count
+ * and a warning at __fput() time.
  */
 struct file *get_empty_filp(void)
 {
diff -puN fs/nfsd/nfs4state.c~fix-up-new-filp-allocators fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~fix-up-new-filp-allocators
+++ a/fs/nfsd/nfs4state.c
@@ -41,6 +41,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
+#include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/workqueue.h>
 #include <linux/smp_lock.h>
@@ -1239,7 +1240,7 @@ static inline void
 nfs4_file_downgrade(struct file *filp, unsigned int share_access)
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
-		put_write_access(filp->f_path.dentry->d_inode);
+		drop_file_write_access(filp);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
 	}
 }
diff -puN fs/pipe.c~fix-up-new-filp-allocators fs/pipe.c
--- a/fs/pipe.c~fix-up-new-filp-allocators
+++ a/fs/pipe.c
@@ -957,13 +957,10 @@ struct file *create_write_pipe(void)
 	struct dentry *dentry;
 	struct qstr name = { .name = "" };
 
-	f = get_empty_filp();
-	if (!f)
-		return ERR_PTR(-ENFILE);
 	err = -ENFILE;
 	inode = get_pipe_inode();
 	if (!inode)
-		goto err_file;
+		goto err;
 
 	err = -ENOMEM;
 	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
@@ -978,13 +975,14 @@ struct file *create_write_pipe(void)
 	 */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
-	f->f_path.mnt = mntget(pipe_mnt);
-	f->f_path.dentry = dentry;
+
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	err = -ENFILE;
+	if (!f)
+		goto err_inode;
 	f->f_mapping = inode->i_mapping;
 
 	f->f_flags = O_WRONLY;
-	f->f_op = &write_pipe_fops;
-	f->f_mode = FMODE_WRITE;
 	f->f_version = 0;
 
 	return f;
@@ -992,8 +990,7 @@ struct file *create_write_pipe(void)
  err_inode:
 	free_pipe_info(inode);
 	iput(inode);
- err_file:
-	put_filp(f);
+ err:
 	return ERR_PTR(err);
 }
 
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
