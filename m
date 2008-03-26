From: akpm@linux-foundation.org
Subject: - fix-up-new-filp-allocators.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:07 -0700
Message-ID: <200803261840.m2QIe7iI028634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759403AbYCZSqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, bfields@fieldses.org, ezk@cs.sunysb.edu, hch@lst.de, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix up new filp allocators
has been removed from the -mm tree.  Its filename was
     fix-up-new-filp-allocators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix up new filp allocators
From: Dave Hansen <haveblue@us.ibm.com>

Some new uses of get_empty_filp() have crept in, and are not properly taking
mnt_want_write()s.  This fixes them up.

We really need to kill get_empty_filp().

Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   16 ++++++----------
 fs/file_table.c  |    6 ++++++
 fs/pipe.c        |   19 +++++++++----------
 3 files changed, 21 insertions(+), 20 deletions(-)

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
@@ -83,6 +83,12 @@ int proc_nr_files(ctl_table *table, int 
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
@@ -978,22 +975,24 @@ struct file *create_write_pipe(void)
 	 */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
-	f->f_path.mnt = mntget(pipe_mnt);
-	f->f_path.dentry = dentry;
+
+	err = -ENFILE;
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	if (!f)
+		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
 
 	f->f_flags = O_WRONLY;
-	f->f_op = &write_pipe_fops;
-	f->f_mode = FMODE_WRITE;
 	f->f_version = 0;
 
 	return f;
 
+ err_dentry:
+	dput(dentry);
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

