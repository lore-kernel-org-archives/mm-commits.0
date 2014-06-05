From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-remove-block_write_full_page_endio.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:28 -0700
Message-ID: <5390ca04.p5oFZmAP4/PY73YL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFETu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] fs-bufferc-remove-block_write_full_page_endio.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:28 -0700


The patch titled
     Subject: fs/buffer.c: remove block_write_full_page_endio()
has been removed from the -mm tree.  Its filename was
     fs-bufferc-remove-block_write_full_page_endio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: fs/buffer.c: remove block_write_full_page_endio()

The last in-tree caller of block_write_full_page_endio() was removed in
January 2013.  It's time to remove the EXPORT_SYMBOL, which leaves
block_write_full_page() as the only caller of
block_write_full_page_endio(), so inline block_write_full_page_endio()
into block_write_full_page().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   21 +++++----------------
 fs/ext4/page-io.c           |    2 +-
 fs/ocfs2/file.c             |    2 +-
 include/linux/buffer_head.h |    2 --
 4 files changed, 7 insertions(+), 20 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-remove-block_write_full_page_endio fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-remove-block_write_full_page_endio
+++ a/fs/buffer.c
@@ -2879,10 +2879,9 @@ EXPORT_SYMBOL(block_truncate_page);
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
- * this form passes in the end_io handler used to finish the IO.
  */
-int block_write_full_page_endio(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc, bh_end_io_t *handler)
+int block_write_full_page(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc)
 {
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
@@ -2892,7 +2891,7 @@ int block_write_full_page_endio(struct p
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
 		return __block_write_full_page(inode, page, get_block, wbc,
-					       handler);
+					       end_buffer_async_write);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_CACHE_SIZE-1);
@@ -2915,18 +2914,8 @@ int block_write_full_page_endio(struct p
 	 * writes to that region are not written out to the file."
 	 */
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
-	return __block_write_full_page(inode, page, get_block, wbc, handler);
-}
-EXPORT_SYMBOL(block_write_full_page_endio);
-
-/*
- * The generic ->writepage function for buffer-backed address_spaces
- */
-int block_write_full_page(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc)
-{
-	return block_write_full_page_endio(page, get_block, wbc,
-					   end_buffer_async_write);
+	return __block_write_full_page(inode, page, get_block, wbc,
+							end_buffer_async_write);
 }
 EXPORT_SYMBOL(block_write_full_page);
 
diff -puN fs/ext4/page-io.c~fs-bufferc-remove-block_write_full_page_endio fs/ext4/page-io.c
--- a/fs/ext4/page-io.c~fs-bufferc-remove-block_write_full_page_endio
+++ a/fs/ext4/page-io.c
@@ -429,7 +429,7 @@ int ext4_bio_write_page(struct ext4_io_s
 		block_start = bh_offset(bh);
 		if (block_start >= len) {
 			/*
-			 * Comments copied from block_write_full_page_endio:
+			 * Comments copied from block_write_full_page:
 			 *
 			 * The page straddles i_size.  It must be zeroed out on
 			 * each and every writepage invocation because it may
diff -puN fs/ocfs2/file.c~fs-bufferc-remove-block_write_full_page_endio fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~fs-bufferc-remove-block_write_full_page_endio
+++ a/fs/ocfs2/file.c
@@ -828,7 +828,7 @@ static int ocfs2_write_zero_page(struct
 		/*
 		 * fs-writeback will release the dirty pages without page lock
 		 * whose offset are over inode size, the release happens at
-		 * block_write_full_page_endio().
+		 * block_write_full_page().
 		 */
 		i_size_write(inode, abs_to);
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
diff -puN include/linux/buffer_head.h~fs-bufferc-remove-block_write_full_page_endio include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-bufferc-remove-block_write_full_page_endio
+++ a/include/linux/buffer_head.h
@@ -207,8 +207,6 @@ void block_invalidatepage(struct page *p
 			  unsigned int length);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
-int block_write_full_page_endio(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc, bh_end_io_t *handler);
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, unsigned long from,
 				unsigned long count);
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

