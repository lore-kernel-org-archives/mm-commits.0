From: akpm@linux-foundation.org
Subject: - fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch removed from -mm tree
Date: Wed, 09 May 2007 02:15:21 -0700
Message-ID: <200705090915.l499FLrT018904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539AbXEIJP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs-convert-core-functions-to-zero_user_page-pass-kmap-type
has been removed from the -mm tree.  Its filename was
     fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch

This patch was dropped because it was folded into fs-convert-core-functions-to-zero_user_page.patch

------------------------------------------------------
Subject: fs-convert-core-functions-to-zero_user_page-pass-kmap-type
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c    |    2 +-
 fs/buffer.c             |   21 ++++++++++++---------
 fs/direct-io.c          |    2 +-
 fs/mpage.c              |    6 ++++--
 include/linux/highmem.h |   29 +++++++++++++++++------------
 mm/filemap_xip.c        |    2 +-
 6 files changed, 36 insertions(+), 26 deletions(-)

diff -puN drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type drivers/block/loop.c
--- a/drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/drivers/block/loop.c
@@ -250,7 +250,7 @@ static int do_lo_send_aops(struct loop_d
 			 */
 			printk(KERN_ERR "loop: transfer error block %llu\n",
 			       (unsigned long long)index);
-			zero_user_page(page, offset, size);
+			zero_user_page(page, offset, size, KM_USER0);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -puN fs/buffer.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/buffer.c
--- a/fs/buffer.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/buffer.c
@@ -1848,7 +1848,7 @@ static int __block_prepare_write(struct 
 			break;
 		if (buffer_new(bh)) {
 			clear_buffer_new(bh);
-			zero_user_page(page, block_start, bh->b_size);
+			zero_user_page(page, block_start, bh->b_size, KM_USER0);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1936,7 +1936,8 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user_page(page, i * blocksize, blocksize);
+				zero_user_page(page, i * blocksize, blocksize,
+						KM_USER0);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2100,7 +2101,8 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE-zerofrom);
+		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
+				KM_USER0);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2127,7 +2129,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		zero_user_page(page, zerofrom, offset-zerofrom);
+		zero_user_page(page, zerofrom, offset - zerofrom, KM_USER0);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2326,7 +2328,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2395,7 +2397,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2429,7 +2431,8 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2508,7 +2511,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length);
+	zero_user_page(page, offset, length, KM_USER0);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2554,7 +2557,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -puN fs/direct-io.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/direct-io.c
--- a/fs/direct-io.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/direct-io.c
@@ -888,7 +888,7 @@ do_holes:
 					goto out;
 				}
 				zero_user_page(page, block_in_page << blkbits,
-						1 << blkbits);
+						1 << blkbits, KM_USER0);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -puN fs/mpage.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/mpage.c
--- a/fs/mpage.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/mpage.c
@@ -285,7 +285,8 @@ do_mpage_readpage(struct bio *bio, struc
 
 	if (first_hole != blocks_per_page) {
 		zero_user_page(page, first_hole << blkbits,
-				PAGE_CACHE_SIZE - (first_hole << blkbits));
+				PAGE_CACHE_SIZE - (first_hole << blkbits),
+				KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -584,7 +585,8 @@ page_is_mapped:
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 	}
 
 	/*
diff -puN include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page-pass-kmap-type include/linux/highmem.h
--- a/include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/include/linux/highmem.h
@@ -136,22 +136,27 @@ static inline void clear_highpage(struct
 
 /*
  * Same but also flushes aliased cache contents to RAM.
+ *
+ * This must be a macro because KM_USER0 and friends aren't defined if
+ * !CONFIG_HIGHMEM
  */
-static inline void zero_user_page(struct page *page, unsigned int offset, unsigned int size)
-{
-	void *kaddr;
-
-	BUG_ON(offset + size > PAGE_SIZE);
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
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset((char *)kaddr + offset, 0, size);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-}
 
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+static inline void memclear_highpage_flush(struct page *page,
+			unsigned int offset, unsigned int size)
 {
-	return zero_user_page(page, offset, size);
+	zero_user_page(page, offset, size, KM_USER0);
 }
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
diff -puN mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type mm/filemap_xip.c
--- a/mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/mm/filemap_xip.c
@@ -463,7 +463,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	zero_user_page(page, offset, length);
+	zero_user_page(page, offset, length, KM_USER0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
rename-thread_info-to-stack.patch
