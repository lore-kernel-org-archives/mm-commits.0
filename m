From: akpm@linux-foundation.org
Subject: + sysv-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:48 -0700
Message-ID: <200705292120.l4TLKmuH011833@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbXE2VVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hch@lst.de


The patch titled
     sysv: convert to new aops
has been added to the -mm tree.  Its filename is
     sysv-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysv: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/dir.c   |   51 +++++++++++++++++++++++++++-------------------
 fs/sysv/itree.c |   23 +++++++++++++++++---
 2 files changed, 50 insertions(+), 24 deletions(-)

diff -puN fs/sysv/dir.c~sysv-convert-to-new-aops fs/sysv/dir.c
--- a/fs/sysv/dir.c~sysv-convert-to-new-aops
+++ a/fs/sysv/dir.c
@@ -16,6 +16,7 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/smp_lock.h>
+#include <linux/swap.h>
 #include "sysv.h"
 
 static int sysv_readdir(struct file *, void *, filldir_t);
@@ -37,16 +38,22 @@ static inline unsigned long dir_pages(st
 	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
 }
 
-static int dir_commit_chunk(struct page *page, unsigned from, unsigned to)
+static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
-	struct inode *dir = (struct inode *)page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
 	int err = 0;
 
-	page->mapping->a_ops->commit_write(NULL, page, from, to);
+	block_write_end(NULL, mapping, pos, len, len, page, NULL);
+	if (pos+len > dir->i_size) {
+		i_size_write(dir, pos+len);
+		mark_inode_dirty(dir);
+	}
 	if (IS_DIRSYNC(dir))
 		err = write_one_page(page, 1);
 	else
 		unlock_page(page);
+	mark_page_accessed(page);
 	return err;
 }
 
@@ -186,7 +193,7 @@ int sysv_add_link(struct dentry *dentry,
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	unsigned from, to;
+	loff_t pos;
 	int err;
 
 	/* We take care of directory expansion in the same loop */
@@ -212,16 +219,17 @@ int sysv_add_link(struct dentry *dentry,
 	return -EINVAL;
 
 got_it:
-	from = (char*)de - (char*)page_address(page);
-	to = from + SYSV_DIRSIZE;
+	pos = (page->index << PAGE_CACHE_SHIFT) +
+			(char*)de - (char*)page_address(page);
 	lock_page(page);
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __sysv_write_begin(NULL, page->mapping, pos, SYSV_DIRSIZE,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
 	memcpy (de->name, name, namelen);
 	memset (de->name + namelen, 0, SYSV_DIRSIZE - namelen - 2);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
-	err = dir_commit_chunk(page, from, to);
+	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
 out_page:
@@ -238,15 +246,15 @@ int sysv_delete_entry(struct sysv_dir_en
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = (char*)page_address(page);
-	unsigned from = (char*)de - kaddr;
-	unsigned to = from + SYSV_DIRSIZE;
+	loff_t pos = (page->index << PAGE_CACHE_SHIFT) + (char *)de - kaddr;
 	int err;
 
 	lock_page(page);
-	err = mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __sysv_write_begin(NULL, mapping, pos, SYSV_DIRSIZE,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	BUG_ON(err);
 	de->inode = 0;
-	err = dir_commit_chunk(page, from, to);
+	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
@@ -263,12 +271,13 @@ int sysv_make_empty(struct inode *inode,
 
 	if (!page)
 		return -ENOMEM;
-	kmap(page);
-	err = mapping->a_ops->prepare_write(NULL, page, 0, 2 * SYSV_DIRSIZE);
+	err = __sysv_write_begin(NULL, mapping, 0, 2 * SYSV_DIRSIZE,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err) {
 		unlock_page(page);
 		goto fail;
 	}
+	kmap(page);
 
 	base = (char*)page_address(page);
 	memset(base, 0, PAGE_CACHE_SIZE);
@@ -280,9 +289,9 @@ int sysv_make_empty(struct inode *inode,
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), dir->i_ino);
 	strcpy(de->name,"..");
 
+	kunmap(page);
 	err = dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
 fail:
-	kunmap(page);
 	page_cache_release(page);
 	return err;
 }
@@ -336,16 +345,18 @@ not_empty:
 void sysv_set_link(struct sysv_dir_entry *de, struct page *page,
 	struct inode *inode)
 {
-	struct inode *dir = (struct inode*)page->mapping->host;
-	unsigned from = (char *)de-(char*)page_address(page);
-	unsigned to = from + SYSV_DIRSIZE;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
+	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+			(char *)de-(char*)page_address(page);
 	int err;
 
 	lock_page(page);
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __sysv_write_begin(NULL, mapping, pos, SYSV_DIRSIZE,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	BUG_ON(err);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
-	err = dir_commit_chunk(page, from, to);
+	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
diff -puN fs/sysv/itree.c~sysv-convert-to-new-aops fs/sysv/itree.c
--- a/fs/sysv/itree.c~sysv-convert-to-new-aops
+++ a/fs/sysv/itree.c
@@ -453,23 +453,38 @@ static int sysv_writepage(struct page *p
 {
 	return block_write_full_page(page,get_block,wbc);
 }
+
 static int sysv_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page,get_block);
 }
-static int sysv_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+
+int __sysv_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page,from,to,get_block);
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				get_block);
 }
+
+static int sysv_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return __sysv_write_begin(file, mapping, pos, len, flags, pagep, fsdata);
+}
+
 static sector_t sysv_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,get_block);
 }
+
 const struct address_space_operations sysv_aops = {
 	.readpage = sysv_readpage,
 	.writepage = sysv_writepage,
 	.sync_page = block_sync_page,
-	.prepare_write = sysv_prepare_write,
-	.commit_write = generic_commit_write,
+	.write_begin = sysv_write_begin,
+	.write_end = generic_write_end,
 	.bmap = sysv_bmap
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
