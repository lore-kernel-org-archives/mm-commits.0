From: akpm@linux-foundation.org
Subject: + ufs-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:44 -0700
Message-ID: <200705292120.l4TLKi8E011823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbXE2VVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, dushistov@mail.ru


The patch titled
     ufs: convert to new aops
has been added to the -mm tree.  Its filename is
     ufs-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c   |   56 +++++++++++++++++++++++++++++++----------------
 fs/ufs/inode.c |   23 +++++++++++++++----
 2 files changed, 56 insertions(+), 23 deletions(-)

diff -puN fs/ufs/dir.c~ufs-convert-to-new-aops fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-convert-to-new-aops
+++ a/fs/ufs/dir.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
+#include <linux/swap.h>
 
 #include "swab.h"
 #include "util.h"
@@ -38,16 +39,23 @@ static inline int ufs_match(struct super
 	return !memcmp(name, de->d_name, len);
 }
 
-static int ufs_commit_chunk(struct page *page, unsigned from, unsigned to)
+static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
-	struct inode *dir = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
 	int err = 0;
+
 	dir->i_version++;
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
 
@@ -81,16 +89,20 @@ ino_t ufs_inode_by_name(struct inode *di
 void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
 		  struct page *page, struct inode *inode)
 {
-	unsigned from = (char *) de - (char *) page_address(page);
-	unsigned to = from + fs16_to_cpu(dir->i_sb, de->d_reclen);
+	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+			(char *) de - (char *) page_address(page);
+	unsigned len = fs16_to_cpu(dir->i_sb, de->d_reclen);
 	int err;
 
 	lock_page(page);
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __ufs_write_begin(NULL, page->mapping, pos, len,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	BUG_ON(err);
+
 	de->d_ino = cpu_to_fs32(dir->i_sb, inode->i_ino);
 	ufs_set_de_type(dir->i_sb, de, inode->i_mode);
-	err = ufs_commit_chunk(page, from, to);
+
+	err = ufs_commit_chunk(page, pos, len);
 	ufs_put_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
@@ -312,7 +324,7 @@ int ufs_add_link(struct dentry *dentry, 
 	unsigned long npages = ufs_dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	unsigned from, to;
+	loff_t pos;
 	int err;
 
 	UFSD("ENTER, name %s, namelen %u\n", name, namelen);
@@ -367,9 +379,10 @@ int ufs_add_link(struct dentry *dentry, 
 	return -EINVAL;
 
 got_it:
-	from = (char*)de - (char*)page_address(page);
-	to = from + rec_len;
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	pos = (page->index << PAGE_CACHE_SHIFT) +
+			(char*)de - (char*)page_address(page);
+	err = __ufs_write_begin(NULL, page->mapping, pos, rec_len,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
 	if (de->d_ino) {
@@ -386,7 +399,7 @@ got_it:
 	de->d_ino = cpu_to_fs32(sb, inode->i_ino);
 	ufs_set_de_type(sb, de, inode->i_mode);
 
-	err = ufs_commit_chunk(page, from, to);
+	err = ufs_commit_chunk(page, pos, rec_len);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 
 	mark_inode_dirty(dir);
@@ -509,6 +522,7 @@ int ufs_delete_entry(struct inode *inode
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	unsigned to = ((char*)dir - kaddr) + fs16_to_cpu(sb, dir->d_reclen);
+	loff_t pos;
 	struct ufs_dir_entry *pde = NULL;
 	struct ufs_dir_entry *de = (struct ufs_dir_entry *) (kaddr + from);
 	int err;
@@ -532,13 +546,16 @@ int ufs_delete_entry(struct inode *inode
 	}
 	if (pde)
 		from = (char*)pde - (char*)page_address(page);
+
+	pos = (page->index << PAGE_CACHE_SHIFT) + from;
 	lock_page(page);
-	err = mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __ufs_write_begin(NULL, mapping, pos, to - from,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	BUG_ON(err);
 	if (pde)
-		pde->d_reclen = cpu_to_fs16(sb, to-from);
+		pde->d_reclen = cpu_to_fs16(sb, to - from);
 	dir->d_ino = 0;
-	err = ufs_commit_chunk(page, from, to);
+	err = ufs_commit_chunk(page, pos, to - from);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 out:
@@ -559,14 +576,15 @@ int ufs_make_empty(struct inode * inode,
 
 	if (!page)
 		return -ENOMEM;
-	kmap(page);
-	err = mapping->a_ops->prepare_write(NULL, page, 0, chunk_size);
+
+	err = __ufs_write_begin(NULL, mapping, 0, chunk_size,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err) {
 		unlock_page(page);
 		goto fail;
 	}
 
-
+	kmap(page);
 	base = (char*)page_address(page);
 	memset(base, 0, PAGE_CACHE_SIZE);
 
@@ -584,10 +602,10 @@ int ufs_make_empty(struct inode * inode,
 	de->d_reclen = cpu_to_fs16(sb, chunk_size - UFS_DIR_REC_LEN(1));
 	ufs_set_de_namlen(sb, de, 2);
 	strcpy (de->d_name, "..");
+	kunmap(page);
 
 	err = ufs_commit_chunk(page, 0, chunk_size);
 fail:
-	kunmap(page);
 	page_cache_release(page);
 	return err;
 }
diff -puN fs/ufs/inode.c~ufs-convert-to-new-aops fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-convert-to-new-aops
+++ a/fs/ufs/inode.c
@@ -558,24 +558,39 @@ static int ufs_writepage(struct page *pa
 {
 	return block_write_full_page(page,ufs_getfrag_block,wbc);
 }
+
 static int ufs_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page,ufs_getfrag_block);
 }
-static int ufs_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+
+int __ufs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page,from,to,ufs_getfrag_block);
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				ufs_getfrag_block);
 }
+
+static int ufs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return __ufs_write_begin(file, mapping, pos, len, flags, pagep, fsdata);
+}
+
 static sector_t ufs_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,ufs_getfrag_block);
 }
+
 const struct address_space_operations ufs_aops = {
 	.readpage = ufs_readpage,
 	.writepage = ufs_writepage,
 	.sync_page = block_sync_page,
-	.prepare_write = ufs_prepare_write,
-	.commit_write = generic_commit_write,
+	.write_begin = ufs_write_begin,
+	.write_end = generic_write_end,
 	.bmap = ufs_bmap
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
