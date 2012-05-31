From: akpm@linux-foundation.org
Subject: [merged] mm-fs-remove-truncate_range.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:42 -0700
Message-ID: <20120531191542.66F59A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33169 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab2EaTPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:43 -0400
Received: by ghbz15 with SMTP id z15so134565ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, amwang@redhat.com, hch@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fs: remove truncate_range
has been removed from the -mm tree.  Its filename was
     mm-fs-remove-truncate_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/fs: remove truncate_range

Remove vmtruncate_range(), and remove the truncate_range method from
struct inode_operations: only tmpfs ever supported it, and tmpfs has now
converted over to using the fallocate method of file_operations.

Update Documentation accordingly, adding (setlease and) fallocate lines. 
And while we're in mm.h, remove duplicate declarations of shmem_lock() and
shmem_file_setup(): everyone is now using the ones in shmem_fs.h.

Based-on-patch-by: Cong Wang <amwang@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 --
 Documentation/filesystems/vfs.txt |   13 ++++++++-----
 fs/bad_inode.c                    |    1 -
 include/linux/fs.h                |    1 -
 include/linux/mm.h                |    4 ----
 mm/shmem.c                        |    1 -
 mm/truncate.c                     |   25 -------------------------
 7 files changed, 8 insertions(+), 39 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-fs-remove-truncate_range Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-fs-remove-truncate_range
+++ a/Documentation/filesystems/Locking
@@ -60,7 +60,6 @@ ata *);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
-	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
 
 locking rules:
@@ -87,7 +86,6 @@ setxattr:	yes
 getxattr:	no
 listxattr:	no
 removexattr:	yes
-truncate_range:	yes
 fiemap:		no
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
diff -puN Documentation/filesystems/vfs.txt~mm-fs-remove-truncate_range Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~mm-fs-remove-truncate_range
+++ a/Documentation/filesystems/vfs.txt
@@ -363,7 +363,6 @@ struct inode_operations {
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
-	void (*truncate_range)(struct inode *, loff_t, loff_t);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -472,9 +471,6 @@ otherwise noted.
   removexattr: called by the VFS to remove an extended attribute from
   	a file. This method is called by removexattr(2) system call.
 
-  truncate_range: a method provided by the underlying filesystem to truncate a
-  	range of blocks , i.e. punch a hole somewhere in a file.
-
 
 The Address Space Object
 ========================
@@ -760,7 +756,7 @@ struct file_operations
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-2.6.22, the following members are defined:
+3.5, the following members are defined:
 
 struct file_operations {
 	struct module *owner;
@@ -790,6 +786,8 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
+	int (*setlease)(struct file *, long arg, struct file_lock **);
+	long (*fallocate)(struct file *, int mode, loff_t offset, loff_t len);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -858,6 +856,11 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  setlease: called by the VFS to set or release a file lock lease.
+	    setlease has the file_lock_lock held and must not sleep.
+
+  fallocate: called by the VFS to preallocate blocks or punch a hole.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
diff -puN fs/bad_inode.c~mm-fs-remove-truncate_range fs/bad_inode.c
--- a/fs/bad_inode.c~mm-fs-remove-truncate_range
+++ a/fs/bad_inode.c
@@ -292,7 +292,6 @@ static const struct inode_operations bad
 	.getxattr	= bad_inode_getxattr,
 	.listxattr	= bad_inode_listxattr,
 	.removexattr	= bad_inode_removexattr,
-	/* truncate_range returns void */
 };
 
 
diff -puN include/linux/fs.h~mm-fs-remove-truncate_range include/linux/fs.h
--- a/include/linux/fs.h~mm-fs-remove-truncate_range
+++ a/include/linux/fs.h
@@ -1681,7 +1681,6 @@ struct inode_operations {
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
-	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
 } ____cacheline_aligned;
diff -puN include/linux/mm.h~mm-fs-remove-truncate_range include/linux/mm.h
--- a/include/linux/mm.h~mm-fs-remove-truncate_range
+++ a/include/linux/mm.h
@@ -871,8 +871,6 @@ extern void pagefault_out_of_memory(void
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
 
-int shmem_lock(struct file *file, int lock, struct user_struct *user);
-struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
 int shmem_zero_setup(struct vm_area_struct *);
 
 extern int can_do_mlock(void);
@@ -951,11 +949,9 @@ static inline void unmap_shared_mapping_
 extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 extern int vmtruncate(struct inode *inode, loff_t offset);
-extern int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
-
 int invalidate_inode_page(struct page *page);
 
 #ifdef CONFIG_MMU
diff -puN mm/shmem.c~mm-fs-remove-truncate_range mm/shmem.c
--- a/mm/shmem.c~mm-fs-remove-truncate_range
+++ a/mm/shmem.c
@@ -2541,7 +2541,6 @@ static const struct file_operations shme
 
 static const struct inode_operations shmem_inode_operations = {
 	.setattr	= shmem_setattr,
-	.truncate_range	= shmem_truncate_range,
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,
 	.getxattr	= shmem_getxattr,
diff -puN mm/truncate.c~mm-fs-remove-truncate_range mm/truncate.c
--- a/mm/truncate.c~mm-fs-remove-truncate_range
+++ a/mm/truncate.c
@@ -602,31 +602,6 @@ int vmtruncate(struct inode *inode, loff
 }
 EXPORT_SYMBOL(vmtruncate);
 
-int vmtruncate_range(struct inode *inode, loff_t lstart, loff_t lend)
-{
-	struct address_space *mapping = inode->i_mapping;
-	loff_t holebegin = round_up(lstart, PAGE_SIZE);
-	loff_t holelen = 1 + lend - holebegin;
-
-	/*
-	 * If the underlying filesystem is not going to provide
-	 * a way to truncate a range of blocks (punch a hole) -
-	 * we should return failure right now.
-	 */
-	if (!inode->i_op->truncate_range)
-		return -ENOSYS;
-
-	mutex_lock(&inode->i_mutex);
-	inode_dio_wait(inode);
-	unmap_mapping_range(mapping, holebegin, holelen, 1);
-	inode->i_op->truncate_range(inode, lstart, lend);
-	/* unmap again to remove racily COWed private pages */
-	unmap_mapping_range(mapping, holebegin, holelen, 1);
-	mutex_unlock(&inode->i_mutex);
-
-	return 0;
-}
