Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EB813FF3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g80KwcPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96E8C433C9;
	Fri, 29 Dec 2023 20:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880032;
	bh=dgziEq4zS12V2KcSKxgxe1yElLAveXQYGhsus9km8xI=;
	h=Date:To:From:Subject:From;
	b=g80KwcPRhwDyWOlQrY6jNjko4yuyccDI5DBfgaumpiWSC+Bo8PhXqUsXE9cIBLm9y
	 1DWUyFpBup3/7gfYaqbqO8aNyceKA/mE6DkIderVc55GEgZVSJs0O29P+mPkbjmnkW
	 ZEFlJOO2JRF1L0BgLifrN2STjXIcn6C43KoFL1q4=
Date: Fri, 29 Dec 2023 12:00:32 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch removed from -mm tree
Message-Id: <20231229200032.D96E8C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove the bh_end_io argument from __block_write_full_folio
has been removed from the -mm tree.  Its filename was
     fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove the bh_end_io argument from __block_write_full_folio
Date: Fri, 15 Dec 2023 20:02:45 +0000

All callers are passing end_buffer_async_write as this argument, so we can
hardcode references to it within __block_write_full_folio().  That lets us
make end_buffer_async_write() static.

Link: https://lkml.kernel.org/r/20231215200245.748418-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   22 ++++++++++------------
 fs/gfs2/aops.c              |    2 +-
 include/linux/buffer_head.h |    4 +---
 3 files changed, 12 insertions(+), 16 deletions(-)

--- a/fs/buffer.c~fs-remove-the-bh_end_io-argument-from-__block_write_full_folio
+++ a/fs/buffer.c
@@ -372,10 +372,10 @@ static void end_buffer_async_read_io(str
 }
 
 /*
- * Completion handler for block_write_full_folio() - pages which are unlocked
- * during I/O, and which have PageWriteback cleared upon I/O completion.
+ * Completion handler for block_write_full_folio() - folios which are unlocked
+ * during I/O, and which have the writeback flag cleared upon I/O completion.
  */
-void end_buffer_async_write(struct buffer_head *bh, int uptodate)
+static void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 {
 	unsigned long flags;
 	struct buffer_head *first;
@@ -415,7 +415,6 @@ still_busy:
 	spin_unlock_irqrestore(&first->b_uptodate_lock, flags);
 	return;
 }
-EXPORT_SYMBOL(end_buffer_async_write);
 
 /*
  * If a page's buffers are under async readin (end_buffer_async_read
@@ -1787,8 +1786,7 @@ static struct buffer_head *folio_create_
  * causes the writes to be flagged as synchronous writes.
  */
 int __block_write_full_folio(struct inode *inode, struct folio *folio,
-			get_block_t *get_block, struct writeback_control *wbc,
-			bh_end_io_t *handler)
+			get_block_t *get_block, struct writeback_control *wbc)
 {
 	int err;
 	sector_t block;
@@ -1867,7 +1865,8 @@ int __block_write_full_folio(struct inod
 			continue;
 		}
 		if (test_clear_buffer_dirty(bh)) {
-			mark_buffer_async_write_endio(bh, handler);
+			mark_buffer_async_write_endio(bh,
+				end_buffer_async_write);
 		} else {
 			unlock_buffer(bh);
 		}
@@ -1920,7 +1919,8 @@ recover:
 		if (buffer_mapped(bh) && buffer_dirty(bh) &&
 		    !buffer_delay(bh)) {
 			lock_buffer(bh);
-			mark_buffer_async_write_endio(bh, handler);
+			mark_buffer_async_write_endio(bh,
+				end_buffer_async_write);
 		} else {
 			/*
 			 * The buffer may have been set dirty during
@@ -2704,8 +2704,7 @@ int block_write_full_folio(struct folio
 
 	/* Is the folio fully inside i_size? */
 	if (folio_pos(folio) + folio_size(folio) <= i_size)
-		return __block_write_full_folio(inode, folio, get_block, wbc,
-					       end_buffer_async_write);
+		return __block_write_full_folio(inode, folio, get_block, wbc);
 
 	/* Is the folio fully outside i_size? (truncate in progress) */
 	if (folio_pos(folio) >= i_size) {
@@ -2722,8 +2721,7 @@ int block_write_full_folio(struct folio
 	 */
 	folio_zero_segment(folio, offset_in_folio(folio, i_size),
 			folio_size(folio));
-	return __block_write_full_folio(inode, folio, get_block, wbc,
-			end_buffer_async_write);
+	return __block_write_full_folio(inode, folio, get_block, wbc);
 }
 
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
--- a/fs/gfs2/aops.c~fs-remove-the-bh_end_io-argument-from-__block_write_full_folio
+++ a/fs/gfs2/aops.c
@@ -108,7 +108,7 @@ static int gfs2_write_jdata_folio(struct
 				folio_size(folio));
 
 	return __block_write_full_folio(inode, folio, gfs2_get_block_noalloc,
-			wbc, end_buffer_async_write);
+			wbc);
 }
 
 /**
--- a/include/linux/buffer_head.h~fs-remove-the-bh_end_io-argument-from-__block_write_full_folio
+++ a/include/linux/buffer_head.h
@@ -205,7 +205,6 @@ struct buffer_head *create_empty_buffers
 		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
-void end_buffer_async_write(struct buffer_head *bh, int uptodate);
 
 /* Things to do with buffers at mapping->private_list */
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
@@ -255,8 +254,7 @@ void block_invalidate_folio(struct folio
 int block_write_full_folio(struct folio *folio, struct writeback_control *wbc,
 		void *get_block);
 int __block_write_full_folio(struct inode *inode, struct folio *folio,
-			get_block_t *get_block, struct writeback_control *wbc,
-			bh_end_io_t *handler);
+		get_block_t *get_block, struct writeback_control *wbc);
 int block_read_full_folio(struct folio *, get_block_t *);
 bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

