From: akpm@linux-foundation.org
Subject: + implement-simple-fs-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:59 -0700
Message-ID: <200705292119.l4TLJxQS011732@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbXE2VUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     implement simple fs aops
has been added to the -mm tree.  Its filename is
     implement-simple-fs-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 mm/shmem.c            |   35 ++++++++++++++++++++++++++++-------
 6 files changed, 46 insertions(+), 21 deletions(-)

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
@@ -166,15 +166,19 @@ static int hugetlbfs_readpage(struct fil
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
 
@@ -546,8 +550,8 @@ static void hugetlbfs_destroy_inode(stru
 
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
@@ -21,8 +21,8 @@ extern struct super_block * sysfs_sb;
 
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
@@ -1103,7 +1103,7 @@ static int shmem_getpage(struct inode *i
 	 * Normally, filepage is NULL on entry, and either found
 	 * uptodate immediately, or allocated and zeroed, or read
 	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_prepare_write passes in a locked filepage,
+	 * But shmem_write_begin passes in a locked filepage,
 	 * which may be found not uptodate by other callers too,
 	 * and may need to be copied from the swappage read in.
 	 */
@@ -1448,14 +1448,35 @@ static const struct inode_operations shm
 static const struct inode_operations shmem_symlink_inline_operations;
 
 /*
- * Normally tmpfs makes no use of shmem_prepare_write, but it
+ * Normally tmpfs makes no use of shmem_write_begin, but it
  * lets a tmpfs file be used read-write below the loop driver.
  */
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
+	mark_page_accessed(page);
+	page_cache_release(page);
+
+	if (pos+copied > inode->i_size)
+		i_size_write(inode, pos+copied);
+
+	return copied;
 }
 
 static ssize_t
@@ -2349,8 +2370,8 @@ static const struct address_space_operat
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
-	.prepare_write	= shmem_prepare_write,
-	.commit_write	= simple_commit_write,
+	.write_begin	= shmem_write_begin,
+	.write_end	= shmem_write_end,
 #endif
 	.migratepage	= migrate_page,
 };
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
