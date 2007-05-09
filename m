From: akpm@linux-foundation.org
Subject: - fs-convert-core-functions-to-zero_user_page.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:46 -0700
Message-ID: <200705092153.l49Lrkhw003110@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943AbXEIWJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: convert core functions to zero_user_page
has been removed from the -mm tree.  Its filename was
     fs-convert-core-functions-to-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: convert core functions to zero_user_page
From: Nate Diller <nate.diller@gmail.com>

It's very common for file systems to need to zero part or all of a page,
the simplist way is just to use kmap_atomic() and memset().  There's
actually a library function in include/linux/highmem.h that does exactly
that, but it's confusingly named memclear_highpage_flush(), which is
descriptive of *how* it does the work rather than what the *purpose* is. 
So this patchset renames the function to zero_user_page(), and calls it
from the various places that currently open code it.

This first patch introduces the new function call, and converts all the
core kernel callsites, both the open-coded ones and the old
memclear_highpage_flush() ones.  Following this patch is a series of
conversions for each file system individually, per AKPM, and finally a
patch deprecating the old call.  The diffstat below shows the entire
patchset.

[akpm@linux-foundation.org: fix a few things]
Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c    |    6 ----
 fs/buffer.c             |   56 ++++++++------------------------------
 fs/direct-io.c          |    8 +----
 fs/mpage.c              |   15 +++-------
 include/linux/highmem.h |   26 ++++++++++++-----
 mm/filemap_xip.c        |    7 ----
 mm/truncate.c           |    3 +-
 7 files changed, 41 insertions(+), 80 deletions(-)

diff -puN drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page drivers/block/loop.c
--- a/drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page
+++ a/drivers/block/loop.c
@@ -244,17 +244,13 @@ static int do_lo_send_aops(struct loop_d
 		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
 				bvec->bv_page, bv_offs, size, IV);
 		if (unlikely(transfer_result)) {
-			char *kaddr;
-
 			/*
 			 * The transfer failed, but we still write the data to
 			 * keep prepare/commit calls balanced.
 			 */
 			printk(KERN_ERR "loop: transfer error block %llu\n",
 			       (unsigned long long)index);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + offset, 0, size);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_page(page, offset, size, KM_USER0);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -puN fs/buffer.c~fs-convert-core-functions-to-zero_user_page fs/buffer.c
--- a/fs/buffer.c~fs-convert-core-functions-to-zero_user_page
+++ a/fs/buffer.c
@@ -1846,13 +1846,8 @@ static int __block_prepare_write(struct 
 		if (block_start >= to)
 			break;
 		if (buffer_new(bh)) {
-			void *kaddr;
-
 			clear_buffer_new(bh);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr+block_start, 0, bh->b_size);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_page(page, block_start, bh->b_size, KM_USER0);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1940,10 +1935,8 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				void *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + i * blocksize, 0, blocksize);
-				flush_dcache_page(page);
-				kunmap_atomic(kaddr, KM_USER0);
+				zero_user_page(page, i * blocksize, blocksize,
+						KM_USER0);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2086,7 +2079,6 @@ int cont_prepare_write(struct page *page
 	long status;
 	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
-	void *kaddr;
 
 	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
 		status = -ENOMEM;
@@ -2108,10 +2100,8 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		kaddr = kmap_atomic(new_page, KM_USER0);
-		memset(kaddr+zerofrom, 0, PAGE_CACHE_SIZE-zerofrom);
-		flush_dcache_page(new_page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
+				KM_USER0);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2138,10 +2128,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr+zerofrom, 0, offset-zerofrom);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, zerofrom, offset - zerofrom, KM_USER0);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2340,10 +2327,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2382,7 +2366,6 @@ int nobh_writepage(struct page *page, ge
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 	int ret;
 
 	/* Is the page fully inside i_size? */
@@ -2413,10 +2396,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2437,7 +2417,6 @@ int nobh_truncate_page(struct address_sp
 	unsigned to;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
-	char *kaddr;
 	int ret = 0;
 
 	if ((offset & (blocksize - 1)) == 0)
@@ -2451,10 +2430,8 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2480,7 +2457,6 @@ int block_truncate_page(struct address_s
 	struct inode *inode = mapping->host;
 	struct page *page;
 	struct buffer_head *bh;
-	void *kaddr;
 	int err;
 
 	blocksize = 1 << inode->i_blkbits;
@@ -2534,11 +2510,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_user_page(page, offset, length, KM_USER0);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2559,7 +2531,6 @@ int block_write_full_page(struct page *p
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
@@ -2585,10 +2556,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -puN fs/direct-io.c~fs-convert-core-functions-to-zero_user_page fs/direct-io.c
--- a/fs/direct-io.c~fs-convert-core-functions-to-zero_user_page
+++ a/fs/direct-io.c
@@ -867,7 +867,6 @@ static int do_direct_IO(struct dio *dio)
 do_holes:
 			/* Handle holes */
 			if (!buffer_mapped(map_bh)) {
-				char *kaddr;
 				loff_t i_size_aligned;
 
 				/* AKPM: eargh, -ENOTBLK is a hack */
@@ -888,11 +887,8 @@ do_holes:
 					page_cache_release(page);
 					goto out;
 				}
-				kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + (block_in_page << blkbits),
-						0, 1 << blkbits);
-				flush_dcache_page(page);
-				kunmap_atomic(kaddr, KM_USER0);
+				zero_user_page(page, block_in_page << blkbits,
+						1 << blkbits, KM_USER0);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -puN fs/mpage.c~fs-convert-core-functions-to-zero_user_page fs/mpage.c
--- a/fs/mpage.c~fs-convert-core-functions-to-zero_user_page
+++ a/fs/mpage.c
@@ -284,11 +284,9 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + (first_hole << blkbits), 0,
-				PAGE_CACHE_SIZE - (first_hole << blkbits));
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, first_hole << blkbits,
+				PAGE_CACHE_SIZE - (first_hole << blkbits),
+				KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -576,14 +574,11 @@ page_is_mapped:
 		 * written out to the file."
 		 */
 		unsigned offset = i_size & (PAGE_CACHE_SIZE - 1);
-		char *kaddr;
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 	}
 
 	/*
diff -puN include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page include/linux/highmem.h
--- a/include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page
+++ a/include/linux/highmem.h
@@ -94,17 +94,27 @@ static inline void clear_highpage(struct
 
 /*
  * Same but also flushes aliased cache contents to RAM.
+ *
+ * This must be a macro because KM_USER0 and friends aren't defined if
+ * !CONFIG_HIGHMEM
  */
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
-{
-	void *kaddr;
+#define zero_user_page(page, offset, size, km_type)		\
+	do {							\
+		void *kaddr;					\
+								\
+		BUG_ON((offset) + (size) > PAGE_SIZE);		\
+								\
+		kaddr = kmap_atomic(page, km_type);		\
+		memset((char *)kaddr + (offset), 0, (size));	\
+		flush_dcache_page(page);			\
+		kunmap_atomic(kaddr, (km_type));		\
+	} while (0)
 
-	BUG_ON(offset + size > PAGE_SIZE);
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset((char *)kaddr + offset, 0, size);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+static inline void memclear_highpage_flush(struct page *page,
+			unsigned int offset, unsigned int size)
+{
+	zero_user_page(page, offset, size, KM_USER0);
 }
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
diff -puN mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page mm/filemap_xip.c
--- a/mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page
+++ a/mm/filemap_xip.c
@@ -434,7 +434,6 @@ xip_truncate_page(struct address_space *
 	unsigned blocksize;
 	unsigned length;
 	struct page *page;
-	void *kaddr;
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
 
@@ -458,11 +457,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	kunmap_atomic(kaddr, KM_USER0);
-
-	flush_dcache_page(page);
+	zero_user_page(page, offset, length, KM_USER0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
diff -puN mm/truncate.c~fs-convert-core-functions-to-zero_user_page mm/truncate.c
--- a/mm/truncate.c~fs-convert-core-functions-to-zero_user_page
+++ a/mm/truncate.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/pagevec.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
@@ -46,7 +47,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	memclear_highpage_flush(page, partial, PAGE_CACHE_SIZE-partial);
+	zero_user_page(page, partial, PAGE_CACHE_SIZE - partial, KM_USER0);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
_

Patches currently in -mm which might be from nate.diller@gmail.com are

origin.patch
cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ecryptfs-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
xfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch
