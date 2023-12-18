Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C5C2208E
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TnA9PNtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE87C433C7;
	Mon, 18 Dec 2023 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925073;
	bh=jF8iXnmH97/1dDpidzN6fhQNtkkYwiBR9w+VniV3iBY=;
	h=Date:To:From:Subject:From;
	b=TnA9PNtQ4b+natTVLOCCkxtZ+blZDAvL+WCsZQ6yyd9DXA73vAto9+tL0EDjNfInt
	 SjvDbjp8vfQaMuG8o0R+Ep8PYP5FyLdkRRi8CdwoKfBqL7p8fJZdKA0Pi1nUvFIawU
	 TuKiZOp7D/cRKV7VPjMGTnas6hWEduoozGeDWcGQ=
Date: Mon, 18 Dec 2023 10:44:32 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch added to mm-unstable branch
Message-Id: <20231218184433.1EE87C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: remove the bh_end_io argument from __block_write_full_folio
has been added to the -mm mm-unstable branch.  Its filename is
     fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Christoph Hellwig <hch@lst.de>
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

mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch
mm-memory-failure-check-the-mapcount-of-the-precise-page.patch
mm-memory-failure-cast-index-to-loff_t-before-shifting-it.patch
mailmap-add-an-old-address-for-naoya-horiguchi.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch
fs-remove-clean_page_buffers.patch
fs-convert-clean_buffers-to-take-a-folio.patch
fs-reduce-stack-usage-in-__mpage_writepage.patch
fs-reduce-stack-usage-in-do_mpage_readpage.patch
adfs-remove-writepage-implementation.patch
bfs-remove-writepage-implementation.patch
hfs-really-remove-hfs_writepage.patch
hfsplus-really-remove-hfsplus_writepage.patch
minix-remove-writepage-implementation.patch
ocfs2-remove-writepage-implementation.patch
sysv-remove-writepage-implementation.patch
ufs-remove-writepage-implementation.patch
fs-convert-block_write_full_page-to-block_write_full_folio.patch
fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

