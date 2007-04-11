From: akpm@linux-foundation.org
Subject: + fs-convert-core-functions-to-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 22:40:34 -0700
Message-ID: <200704110540.l3B5eYvB029480@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60315 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXDKFkk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 01:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     fs: convert core functions to zero_user_page
has been added to the -mm tree.  Its filename is
     fs-convert-core-functions-to-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c    |    6 ----
 fs/buffer.c             |   53 ++++++--------------------------------
 fs/direct-io.c          |    8 +----
 fs/mpage.c              |   11 +------
 include/linux/highmem.h |    7 ++++-
 mm/filemap_xip.c        |    7 -----
 mm/truncate.c           |    2 -
 7 files changed, 22 insertions(+), 72 deletions(-)

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
+			zero_user_page(page, offset, size);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -puN fs/buffer.c~fs-convert-core-functions-to-zero_user_page fs/buffer.c
--- a/fs/buffer.c~fs-convert-core-functions-to-zero_user_page
+++ a/fs/buffer.c
@@ -1854,13 +1854,8 @@ static int __block_prepare_write(struct 
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
+			zero_user_page(page, block_start, bh->b_size);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1948,10 +1943,7 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				void *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + i * blocksize, 0, blocksize);
-				flush_dcache_page(page);
-				kunmap_atomic(kaddr, KM_USER0);
+				zero_user_page(page, i * blocksize, blocksize);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2094,7 +2086,6 @@ int cont_prepare_write(struct page *page
 	long status;
 	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
-	void *kaddr;
 
 	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
 		status = -ENOMEM;
@@ -2116,10 +2107,7 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		kaddr = kmap_atomic(new_page, KM_USER0);
-		memset(kaddr+zerofrom, 0, PAGE_CACHE_SIZE-zerofrom);
-		flush_dcache_page(new_page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE-zerofrom);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2146,10 +2134,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr+zerofrom, 0, offset-zerofrom);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, zerofrom, offset-zerofrom);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2348,10 +2333,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2390,7 +2372,6 @@ int nobh_writepage(struct page *page, ge
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 	int ret;
 
 	/* Is the page fully inside i_size? */
@@ -2421,10 +2402,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2445,7 +2423,6 @@ int nobh_truncate_page(struct address_sp
 	unsigned to;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
-	char *kaddr;
 	int ret = 0;
 
 	if ((offset & (blocksize - 1)) == 0)
@@ -2459,10 +2436,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2488,7 +2462,6 @@ int block_truncate_page(struct address_s
 	struct inode *inode = mapping->host;
 	struct page *page;
 	struct buffer_head *bh;
-	void *kaddr;
 	int err;
 
 	blocksize = 1 << inode->i_blkbits;
@@ -2542,11 +2515,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_user_page(page, offset, length);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2567,7 +2536,6 @@ int block_write_full_page(struct page *p
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
@@ -2593,10 +2561,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
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
+						1 << blkbits);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -puN fs/mpage.c~fs-convert-core-functions-to-zero_user_page fs/mpage.c
--- a/fs/mpage.c~fs-convert-core-functions-to-zero_user_page
+++ a/fs/mpage.c
@@ -284,11 +284,8 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + (first_hole << blkbits), 0,
+		zero_user_page(page, first_hole << blkbits,
 				PAGE_CACHE_SIZE - (first_hole << blkbits));
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -584,14 +581,10 @@ page_is_mapped:
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
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 	}
 
 	/*
diff -puN include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page include/linux/highmem.h
--- a/include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page
+++ a/include/linux/highmem.h
@@ -137,7 +137,7 @@ static inline void clear_highpage(struct
 /*
  * Same but also flushes aliased cache contents to RAM.
  */
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+static inline void zero_user_page(struct page *page, unsigned int offset, unsigned int size)
 {
 	void *kaddr;
 
@@ -149,6 +149,11 @@ static inline void memclear_highpage_flu
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
+static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+{
+	return zero_user_page(page, offset, size);
+}
+
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 static inline void copy_user_highpage(struct page *to, struct page *from,
diff -puN mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page mm/filemap_xip.c
--- a/mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page
+++ a/mm/filemap_xip.c
@@ -440,7 +440,6 @@ xip_truncate_page(struct address_space *
 	unsigned blocksize;
 	unsigned length;
 	struct page *page;
-	void *kaddr;
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
 
@@ -464,11 +463,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	kunmap_atomic(kaddr, KM_USER0);
-
-	flush_dcache_page(page);
+	zero_user_page(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
diff -puN mm/truncate.c~fs-convert-core-functions-to-zero_user_page mm/truncate.c
--- a/mm/truncate.c~fs-convert-core-functions-to-zero_user_page
+++ a/mm/truncate.c
@@ -46,7 +46,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	memclear_highpage_flush(page, partial, PAGE_CACHE_SIZE-partial);
+	zero_user_page(page, partial, PAGE_CACHE_SIZE-partial);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
fs-convert-core-functions-to-zero_user_page.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
