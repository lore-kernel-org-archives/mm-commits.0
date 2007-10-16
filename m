From: akpm@linux-foundation.org
Subject: - implement-simple-fs-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:25 -0700
Message-ID: <200710162032.l9GKWPGb014599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965810AbXJPVj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     implement simple fs aops
has been removed from the -mm tree.  Its filename was
     implement-simple-fs-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: implement simple fs aops
From: Nick Piggin <npiggin@suse.de>

Implement new aops for some of the simpler filesystems.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/inode.c   |    4 ++--
 fs/hugetlbfs/inode.c  |   16 ++++++++++------
 fs/ramfs/file-mmu.c   |    4 ++--
 fs/ramfs/file-nommu.c |    4 ++--
 fs/sysfs/inode.c      |    4 ++--
 mm/shmem.c            |   34 +++++++++++++++++++++++++++-------
 6 files changed, 45 insertions(+), 21 deletions(-)

diff -puN fs/configfs/inode.c~implement-simple-fs-aops fs/configfs/inode.c
--- a/fs/configfs/inode.c~implement-simple-fs-aops
+++ a/fs/configfs/inode.c
@@ -41,8 +41,8 @@ extern struct super_block * configfs_sb;
 
 static const struct address_space_operations configfs_aops = {
 	.readpage	= simple_readpage,
-	.prepare_write	= simple_prepare_write,
-	.commit_write	= simple_commit_write
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
 };
 
 static struct backing_dev_info configfs_backing_dev_info = {
diff -puN fs/hugetlbfs/inode.c~implement-simple-fs-aops fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~implement-simple-fs-aops
+++ a/fs/hugetlbfs/inode.c
@@ -189,15 +189,19 @@ static int hugetlbfs_readpage(struct fil
 	return -EINVAL;
 }
 
-static int hugetlbfs_prepare_write(struct file *file,
-			struct page *page, unsigned offset, unsigned to)
+static int hugetlbfs_write_begin(struct file *file,
+			struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
 	return -EINVAL;
 }
 
-static int hugetlbfs_commit_write(struct file *file,
-			struct page *page, unsigned offset, unsigned to)
+static int hugetlbfs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
+	BUG();
 	return -EINVAL;
 }
 
@@ -569,8 +573,8 @@ static void hugetlbfs_destroy_inode(stru
 
 static const struct address_space_operations hugetlbfs_aops = {
 	.readpage	= hugetlbfs_readpage,
-	.prepare_write	= hugetlbfs_prepare_write,
-	.commit_write	= hugetlbfs_commit_write,
+	.write_begin	= hugetlbfs_write_begin,
+	.write_end	= hugetlbfs_write_end,
 	.set_page_dirty	= hugetlbfs_set_page_dirty,
 };
 
diff -puN fs/ramfs/file-mmu.c~implement-simple-fs-aops fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~implement-simple-fs-aops
+++ a/fs/ramfs/file-mmu.c
@@ -29,8 +29,8 @@
 
 const struct address_space_operations ramfs_aops = {
 	.readpage	= simple_readpage,
-	.prepare_write	= simple_prepare_write,
-	.commit_write	= simple_commit_write,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
 	.set_page_dirty = __set_page_dirty_no_writeback,
 };
 
diff -puN fs/ramfs/file-nommu.c~implement-simple-fs-aops fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~implement-simple-fs-aops
+++ a/fs/ramfs/file-nommu.c
@@ -29,8 +29,8 @@ static int ramfs_nommu_setattr(struct de
 
 const struct address_space_operations ramfs_aops = {
 	.readpage		= simple_readpage,
-	.prepare_write		= simple_prepare_write,
-	.commit_write		= simple_commit_write,
+	.write_begin		= simple_write_begin,
+	.write_end		= simple_write_end,
 	.set_page_dirty		= __set_page_dirty_no_writeback,
 };
 
diff -puN fs/sysfs/inode.c~implement-simple-fs-aops fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~implement-simple-fs-aops
+++ a/fs/sysfs/inode.c
@@ -24,8 +24,8 @@ extern struct super_block * sysfs_sb;
 
 static const struct address_space_operations sysfs_aops = {
 	.readpage	= simple_readpage,
-	.prepare_write	= simple_prepare_write,
-	.commit_write	= simple_commit_write
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
 };
 
 static struct backing_dev_info sysfs_backing_dev_info = {
diff -puN mm/shmem.c~implement-simple-fs-aops mm/shmem.c
--- a/mm/shmem.c~implement-simple-fs-aops
+++ a/mm/shmem.c
@@ -1108,7 +1108,7 @@ static int shmem_getpage(struct inode *i
 	 * Normally, filepage is NULL on entry, and either found
 	 * uptodate immediately, or allocated and zeroed, or read
 	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_readpage and shmem_prepare_write pass in a locked
+	 * But shmem_readpage and shmem_write_begin pass in a locked
 	 * filepage, which may be found not uptodate by other callers
 	 * too, and may need to be copied from the swappage read in.
 	 */
@@ -1445,7 +1445,7 @@ static const struct inode_operations shm
 static const struct inode_operations shmem_symlink_inline_operations;
 
 /*
- * Normally tmpfs avoids the use of shmem_readpage and shmem_prepare_write;
+ * Normally tmpfs avoids the use of shmem_readpage and shmem_write_begin;
  * but providing them allows a tmpfs file to be used for splice, sendfile, and
  * below the loop driver, in the generic fashion that many filesystems support.
  */
@@ -1458,10 +1458,30 @@ static int shmem_readpage(struct file *f
 }
 
 static int
-shmem_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+shmem_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	struct inode *inode = mapping->host;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	*pagep = NULL;
+	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
+}
+
+static int
+shmem_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	struct inode *inode = page->mapping->host;
-	return shmem_getpage(inode, page->index, &page, SGP_WRITE, NULL);
+	struct inode *inode = mapping->host;
+
+	set_page_dirty(page);
+	page_cache_release(page);
+
+	if (pos+copied > inode->i_size)
+		i_size_write(inode, pos+copied);
+
+	return copied;
 }
 
 static ssize_t
@@ -2337,8 +2357,8 @@ static const struct address_space_operat
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
 	.readpage	= shmem_readpage,
-	.prepare_write	= shmem_prepare_write,
-	.commit_write	= simple_commit_write,
+	.write_begin	= shmem_write_begin,
+	.write_end	= shmem_write_end,
 #endif
 	.migratepage	= migrate_page,
 };
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
