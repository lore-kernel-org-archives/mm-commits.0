From: akpm@linux-foundation.org
Subject: - revoke-core-code-mapping-revocation.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:57 -0700
Message-ID: <200705090955.l499tv15020539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587AbXEIJ4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: mapping revocation
has been removed from the -mm tree.  Its filename was
     revoke-core-code-mapping-revocation.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: mapping revocation
From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Andrew Morton, if some process is partway through a big
page_cache_readahead() operation, a concurrent invalidate_inode_pages2() is
not enough to revoke inode pages.  This patch changes the revoke code to
modify ->f_mapping to point to a revoked mapping that will cause any future
operations on the mapping to fail with EIO.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c        |   29 ++++++++++++++++++++---------
 fs/revoked_inode.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    4 ++--
 include/linux/mm.h |    1 +
 mm/mmap.c          |   11 +++++++++++
 5 files changed, 73 insertions(+), 11 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-mapping-revocation fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-mapping-revocation
+++ a/fs/revoke.c
@@ -201,6 +201,10 @@ static int __revoke_break_cow(struct tas
 			err = ret;
 			break;
 		}
+
+		unlink_file_vma(vma);
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
 	}
 	up_read(&mm->mmap_sem);
 	return err;
@@ -290,6 +294,10 @@ static int revoke_mm(struct mm_struct *m
 		err = revoke_vma(vma, &details);
 		if (err)
 			break;
+
+		__unlink_file_vma(vma);
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
 	}
 	up_write(&mm->mmap_sem);
   out:
@@ -317,12 +325,10 @@ static void revoke_mapping_tree(struct a
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
-		if (err == -EAGAIN) {
+		if (err == -EAGAIN)
 			try_again = 1;
-			continue;
-		}
-		if (err == -EINTR)
-			goto restart;
+
+		goto restart;
 	}
 	if (try_again) {
 		cond_resched();
@@ -418,9 +424,11 @@ static int revoke_files(struct revoke_ta
 	for (i = 0; i < table->end; i++) {
 		struct revokefs_inode_info *info;
 		struct file *this, *filp;
+		struct inode *inode;
 
 		this = table->files[i];
-		info = revokefs_i(this->f_dentry->d_inode);
+		inode = this->f_dentry->d_inode;
+		info = revokefs_i(inode);
 
 		/*
 		 * Increase count before attempting to close file as
@@ -428,7 +436,7 @@ static int revoke_files(struct revoke_ta
 		 */
 		table->restore_start++;
 		filp = info->file;
-		err = filp->f_op->revoke(filp);
+		err = filp->f_op->revoke(filp, inode->i_mapping);
 		put_task_struct(info->owner);
 		info->owner = NULL;	/* To avoid restoring closed file. */
 		if (err)
@@ -633,8 +641,9 @@ asmlinkage long sys_frevoke(unsigned int
 	return err;
 }
 
-int generic_file_revoke(struct file *file)
+int generic_file_revoke(struct file *file, struct address_space *new_mapping)
 {
+	struct address_space *mapping = file->f_mapping;
 	int err;
 
 	/*
@@ -644,10 +653,12 @@ int generic_file_revoke(struct file *fil
 	if (err)
 		goto out;
 
+	file->f_mapping = new_mapping;
+
 	/*
 	 * Make pending reads fail.
 	 */
-	err = invalidate_inode_pages2(file->f_mapping);
+	err = invalidate_inode_pages2(mapping);
 
   out:
 	return err;
diff -puN fs/revoked_inode.c~revoke-core-code-mapping-revocation fs/revoked_inode.c
--- a/fs/revoked_inode.c~revoke-core-code-mapping-revocation
+++ a/fs/revoked_inode.c
@@ -362,6 +362,43 @@ static struct inode_operations revoked_i
 	/* truncate_range returns void */
 };
 
+static int revoked_readpage(struct file *file, struct page *page)
+{
+	return -EIO;
+}
+
+static int revoked_writepage(struct page *page, struct writeback_control *wbc)
+{
+	return -EIO;
+}
+
+static int revoked_prepare_write(struct file *file, struct page *page,
+				 unsigned from, unsigned to)
+{
+	return -EIO;
+}
+
+static int revoked_commit_write(struct file *file, struct page *page,
+				unsigned from, unsigned to)
+{
+	return -EIO;
+}
+
+static ssize_t revoked_direct_IO(int rw, struct kiocb *iocb,
+				 const struct iovec *iov, loff_t offset,
+				 unsigned long nr_segs)
+{
+	return -EIO;
+}
+
+static const struct address_space_operations revoked_aops = {
+        .readpage       = revoked_readpage,
+        .writepage      = revoked_writepage,
+        .prepare_write  = revoked_prepare_write,
+        .commit_write   = revoked_commit_write,
+        .direct_IO      = revoked_direct_IO,
+};
+
 void make_revoked_inode(struct inode *inode, int mode)
 {
 	remove_inode_hash(inode);
@@ -375,4 +412,6 @@ void make_revoked_inode(struct inode *in
 		inode->i_fop = &revoked_special_file_ops;
 	else
 		inode->i_fop = &revoked_file_ops;
+
+	inode->i_mapping->a_ops = &revoked_aops;
 }
diff -puN include/linux/fs.h~revoke-core-code-mapping-revocation include/linux/fs.h
--- a/include/linux/fs.h~revoke-core-code-mapping-revocation
+++ a/include/linux/fs.h
@@ -1113,7 +1113,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
-	int (*revoke)(struct file *);
+	int (*revoke)(struct file *, struct address_space *);
 };
 
 struct inode_operations {
@@ -1757,7 +1757,7 @@ extern long do_splice_direct(struct file
 
 /* fs/revoke.c */
 #ifdef CONFIG_MMU
-extern int generic_file_revoke(struct file *);
+extern int generic_file_revoke(struct file *, struct address_space *);
 #else
 #define generic_file_revoke NULL
 #endif
diff -puN include/linux/mm.h~revoke-core-code-mapping-revocation include/linux/mm.h
--- a/include/linux/mm.h~revoke-core-code-mapping-revocation
+++ a/include/linux/mm.h
@@ -1096,6 +1096,7 @@ extern int split_vma(struct mm_struct *,
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void __vma_link_rb(struct mm_struct *, struct vm_area_struct *,
 	struct rb_node **, struct rb_node *);
+extern void __unlink_file_vma(struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
diff -puN mm/mmap.c~revoke-core-code-mapping-revocation mm/mmap.c
--- a/mm/mmap.c~revoke-core-code-mapping-revocation
+++ a/mm/mmap.c
@@ -202,6 +202,17 @@ static void __remove_shared_vm_struct(st
 }
 
 /*
+ * Requires inode->i_mapping->i_mmap_lock
+ */
+void __unlink_file_vma(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+
+	__remove_shared_vm_struct(vma, file, mapping);
+}
+
+/*
  * Unlink a file-based vm structure from its prio_tree, to hide
  * vma from rmap and vmtruncate before freeing its page tables.
  */
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
