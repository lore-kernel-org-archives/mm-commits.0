From: akpm@linux-foundation.org
Subject: - ufs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:16 -0700
Message-ID: <200710162033.l9GKXG9l014771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966099AbXJPVsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: convert to new aops
has been removed from the -mm tree.  Its filename was
     ufs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c   |   55 ++++++++++++++++++++++++++++++-----------------
 fs/ufs/inode.c |   23 ++++++++++++++++---
 fs/ufs/util.h  |    3 ++
 3 files changed, 58 insertions(+), 23 deletions(-)

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
@@ -38,12 +39,18 @@ static inline int ufs_match(struct super
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
@@ -81,16 +88,20 @@ ino_t ufs_inode_by_name(struct inode *di
 void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
 		  struct page *page, struct inode *inode)
 {
-	unsigned from = (char *) de - (char *) page_address(page);
-	unsigned to = from + fs16_to_cpu(dir->i_sb, de->d_reclen);
+	loff_t pos = page_offset(page) +
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
@@ -312,7 +323,7 @@ int ufs_add_link(struct dentry *dentry, 
 	unsigned long npages = ufs_dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	unsigned from, to;
+	loff_t pos;
 	int err;
 
 	UFSD("ENTER, name %s, namelen %u\n", name, namelen);
@@ -367,9 +378,10 @@ int ufs_add_link(struct dentry *dentry, 
 	return -EINVAL;
 
 got_it:
-	from = (char*)de - (char*)page_address(page);
-	to = from + rec_len;
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	pos = page_offset(page) +
+			(char*)de - (char*)page_address(page);
+	err = __ufs_write_begin(NULL, page->mapping, pos, rec_len,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
 	if (de->d_ino) {
@@ -386,7 +398,7 @@ got_it:
 	de->d_ino = cpu_to_fs32(sb, inode->i_ino);
 	ufs_set_de_type(sb, de, inode->i_mode);
 
-	err = ufs_commit_chunk(page, from, to);
+	err = ufs_commit_chunk(page, pos, rec_len);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 
 	mark_inode_dirty(dir);
@@ -509,6 +521,7 @@ int ufs_delete_entry(struct inode *inode
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	unsigned to = ((char*)dir - kaddr) + fs16_to_cpu(sb, dir->d_reclen);
+	loff_t pos;
 	struct ufs_dir_entry *pde = NULL;
 	struct ufs_dir_entry *de = (struct ufs_dir_entry *) (kaddr + from);
 	int err;
@@ -532,13 +545,16 @@ int ufs_delete_entry(struct inode *inode
 	}
 	if (pde)
 		from = (char*)pde - (char*)page_address(page);
+
+	pos = page_offset(page) + from;
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
@@ -559,14 +575,15 @@ int ufs_make_empty(struct inode * inode,
 
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
 
@@ -584,10 +601,10 @@ int ufs_make_empty(struct inode * inode,
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
 
diff -puN fs/ufs/util.h~ufs-convert-to-new-aops fs/ufs/util.h
--- a/fs/ufs/util.h~ufs-convert-to-new-aops
+++ a/fs/ufs/util.h
@@ -231,6 +231,9 @@ ufs_set_inode_gid(struct super_block *sb
 
 extern dev_t ufs_get_inode_dev(struct super_block *, struct ufs_inode_info *);
 extern void ufs_set_inode_dev(struct super_block *, struct ufs_inode_info *, dev_t);
+extern int __ufs_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata);
 
 /*
  * These functions manipulate ufs buffers
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
