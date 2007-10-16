From: akpm@linux-foundation.org
Subject: - sysv-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:22 -0700
Message-ID: <200710162033.l9GKXMpp014781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966099AbXJPVsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     sysv: convert to new aops
has been removed from the -mm tree.  Its filename was
     sysv-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysv: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/dir.c   |   50 +++++++++++++++++++++++++++-------------------
 fs/sysv/itree.c |   23 +++++++++++++++++----
 fs/sysv/sysv.h  |    3 ++
 3 files changed, 52 insertions(+), 24 deletions(-)

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
@@ -37,12 +38,17 @@ static inline unsigned long dir_pages(st
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
@@ -186,7 +192,7 @@ int sysv_add_link(struct dentry *dentry,
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	unsigned from, to;
+	loff_t pos;
 	int err;
 
 	/* We take care of directory expansion in the same loop */
@@ -212,16 +218,17 @@ int sysv_add_link(struct dentry *dentry,
 	return -EINVAL;
 
 got_it:
-	from = (char*)de - (char*)page_address(page);
-	to = from + SYSV_DIRSIZE;
+	pos = page_offset(page) +
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
@@ -238,15 +245,15 @@ int sysv_delete_entry(struct sysv_dir_en
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = (char*)page_address(page);
-	unsigned from = (char*)de - kaddr;
-	unsigned to = from + SYSV_DIRSIZE;
+	loff_t pos = page_offset(page) + (char *)de - kaddr;
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
@@ -263,12 +270,13 @@ int sysv_make_empty(struct inode *inode,
 
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
@@ -280,9 +288,9 @@ int sysv_make_empty(struct inode *inode,
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), dir->i_ino);
 	strcpy(de->name,"..");
 
+	kunmap(page);
 	err = dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
 fail:
-	kunmap(page);
 	page_cache_release(page);
 	return err;
 }
@@ -336,16 +344,18 @@ not_empty:
 void sysv_set_link(struct sysv_dir_entry *de, struct page *page,
 	struct inode *inode)
 {
-	struct inode *dir = (struct inode*)page->mapping->host;
-	unsigned from = (char *)de-(char*)page_address(page);
-	unsigned to = from + SYSV_DIRSIZE;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
+	loff_t pos = page_offset(page) +
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
diff -puN fs/sysv/sysv.h~sysv-convert-to-new-aops fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~sysv-convert-to-new-aops
+++ a/fs/sysv/sysv.h
@@ -136,6 +136,9 @@ extern unsigned long sysv_count_free_blo
 
 /* itree.c */
 extern void sysv_truncate(struct inode *);
+extern int __sysv_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata);
 
 /* inode.c */
 extern int sysv_write_inode(struct inode *, int);
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
