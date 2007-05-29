From: akpm@linux-foundation.org
Subject: + minix-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:50 -0700
Message-ID: <200705292120.l4TLKoiX011836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbXE2VVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, Andries.Brouwer@cwi.nl


The patch titled
     minixfs: convert to new aops
has been added to the -mm tree.  Its filename is
     minix-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: minixfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c   |   50 ++++++++++++++++++++++++++++-----------------
 fs/minix/inode.c |   23 +++++++++++++++++---
 2 files changed, 51 insertions(+), 22 deletions(-)

diff -puN fs/minix/dir.c~minix-convert-to-new-aops fs/minix/dir.c
--- a/fs/minix/dir.c~minix-convert-to-new-aops
+++ a/fs/minix/dir.c
@@ -9,8 +9,10 @@
  */
 
 #include "minix.h"
+#include <linux/buffer_head.h>
 #include <linux/highmem.h>
 #include <linux/smp_lock.h>
+#include <linux/swap.h>
 
 typedef struct minix_dir_entry minix_dirent;
 typedef struct minix3_dir_entry minix3_dirent;
@@ -48,15 +50,22 @@ static inline unsigned long dir_pages(st
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
+
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
 
@@ -220,7 +229,7 @@ int minix_add_link(struct dentry *dentry
 	char *kaddr, *p;
 	minix_dirent *de;
 	minix3_dirent *de3;
-	unsigned from, to;
+	loff_t pos;
 	int err;
 	char *namx = NULL;
 	__u32 inumber;
@@ -272,9 +281,9 @@ int minix_add_link(struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	from = p - (char*)page_address(page);
-	to = from + sbi->s_dirsize;
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
+	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
+					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
 	memcpy (namx, name, namelen);
@@ -285,7 +294,7 @@ got_it:
 		memset (namx + namelen, 0, sbi->s_dirsize - namelen - 2);
 		de->inode = inode->i_ino;
 	}
-	err = dir_commit_chunk(page, from, to);
+	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
 out_put:
@@ -302,15 +311,16 @@ int minix_delete_entry(struct minix_dir_
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = page_address(page);
-	unsigned from = (char*)de - kaddr;
-	unsigned to = from + minix_sb(inode->i_sb)->s_dirsize;
+	loff_t pos = (page->index << PAGE_CACHE_SHIFT) + (char*)de - kaddr;
+	unsigned len = minix_sb(inode->i_sb)->s_dirsize;
 	int err;
 
 	lock_page(page);
-	err = mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __minix_write_begin(NULL, mapping, pos, len,
+					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err == 0) {
 		de->inode = 0;
-		err = dir_commit_chunk(page, from, to);
+		err = dir_commit_chunk(page, pos, len);
 	} else {
 		unlock_page(page);
 	}
@@ -330,7 +340,8 @@ int minix_make_empty(struct inode *inode
 
 	if (!page)
 		return -ENOMEM;
-	err = mapping->a_ops->prepare_write(NULL, page, 0, 2 * sbi->s_dirsize);
+	err = __minix_write_begin(NULL, mapping, 0, 2 * sbi->s_dirsize,
+					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err) {
 		unlock_page(page);
 		goto fail;
@@ -421,17 +432,20 @@ not_empty:
 void minix_set_link(struct minix_dir_entry *de, struct page *page,
 	struct inode *inode)
 {
-	struct inode *dir = (struct inode*)page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
 	struct minix_sb_info *sbi = minix_sb(dir->i_sb);
-	unsigned from = (char *)de-(char*)page_address(page);
-	unsigned to = from + sbi->s_dirsize;
+	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+			(char *)de-(char*)page_address(page);
 	int err;
 
 	lock_page(page);
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+
+	err = __minix_write_begin(NULL, mapping, pos, sbi->s_dirsize,
+					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err == 0) {
 		de->inode = inode->i_ino;
-		err = dir_commit_chunk(page, from, to);
+		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
 	} else {
 		unlock_page(page);
 	}
diff -puN fs/minix/inode.c~minix-convert-to-new-aops fs/minix/inode.c
--- a/fs/minix/inode.c~minix-convert-to-new-aops
+++ a/fs/minix/inode.c
@@ -346,24 +346,39 @@ static int minix_writepage(struct page *
 {
 	return block_write_full_page(page, minix_get_block, wbc);
 }
+
 static int minix_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page,minix_get_block);
 }
-static int minix_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+
+int __minix_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page,from,to,minix_get_block);
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				minix_get_block);
 }
+
+static int minix_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return __minix_write_begin(file, mapping, pos, len, flags, pagep, fsdata);
+}
+
 static sector_t minix_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,minix_get_block);
 }
+
 static const struct address_space_operations minix_aops = {
 	.readpage = minix_readpage,
 	.writepage = minix_writepage,
 	.sync_page = block_sync_page,
-	.prepare_write = minix_prepare_write,
-	.commit_write = generic_commit_write,
+	.write_begin = minix_write_begin,
+	.write_end = generic_write_end,
 	.bmap = minix_bmap
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
