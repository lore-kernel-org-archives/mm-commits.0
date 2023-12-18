Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0531EB44
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hACE80vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E77C433C7;
	Mon, 18 Dec 2023 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925069;
	bh=nOYk6tQ5u/nqTdw5IEVKnXoniGbPvdE6myNXfEoGiDE=;
	h=Date:To:From:Subject:From;
	b=hACE80vPFSXum5Nt13f7toBO3Jo0kDrqBgKcxs+C53DqRRyiUTJ2X4lGJpMMAeQt3
	 CUFSK3C5ARVgXXP4ccV58n4bkBRw000hos0H0lG75JzBZ7dBDdiT8dn8z2SB9vmzAa
	 y0WFSORhB9Il6bLYZTWOR/yVlJz9vBBDQdQhkA8k=
Date: Mon, 18 Dec 2023 10:44:28 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-block_write_full_page-to-block_write_full_folio.patch added to mm-unstable branch
Message-Id: <20231218184429.29E77C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: convert block_write_full_page to block_write_full_folio
has been added to the -mm mm-unstable branch.  Its filename is
     fs-convert-block_write_full_page-to-block_write_full_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-block_write_full_page-to-block_write_full_folio.patch

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
Subject: fs: convert block_write_full_page to block_write_full_folio
Date: Fri, 15 Dec 2023 20:02:44 +0000

Convert the function to be compatible with writepage_t so that it can be
passed to write_cache_pages() by blkdev.  This removes a call to
compound_head().  We can also remove the function export as both callers
are built-in.

Link: https://lkml.kernel.org/r/20231215200245.748418-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/fops.c                |   21 ++++++++++++++++++---
 fs/buffer.c                 |   16 +++++++---------
 fs/ext4/page-io.c           |    2 +-
 fs/gfs2/aops.c              |    4 ++--
 fs/mpage.c                  |    2 +-
 fs/ntfs/aops.c              |    4 ++--
 fs/ocfs2/alloc.c            |    2 +-
 fs/ocfs2/file.c             |    2 +-
 include/linux/buffer_head.h |    4 ++--
 9 files changed, 35 insertions(+), 22 deletions(-)

--- a/block/fops.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/block/fops.c
@@ -410,9 +410,24 @@ static int blkdev_get_block(struct inode
 	return 0;
 }
 
-static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
+/*
+ * We cannot call mpage_writepages() as it does not take the buffer lock.
+ * We must use block_write_full_folio() directly which holds the buffer
+ * lock.  The buffer lock provides the synchronisation with writeback
+ * that filesystems rely on when they use the blockdev's mapping.
+ */
+static int blkdev_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	return block_write_full_page(page, blkdev_get_block, wbc);
+	struct blk_plug plug;
+	int err;
+
+	blk_start_plug(&plug);
+	err = write_cache_pages(mapping, wbc, block_write_full_folio,
+			blkdev_get_block);
+	blk_finish_plug(&plug);
+
+	return err;
 }
 
 static int blkdev_read_folio(struct file *file, struct folio *folio)
@@ -449,7 +464,7 @@ const struct address_space_operations de
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= blkdev_read_folio,
 	.readahead	= blkdev_readahead,
-	.writepage	= blkdev_writepage,
+	.writepages	= blkdev_writepages,
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
 	.migrate_folio	= buffer_migrate_folio_norefs,
--- a/fs/buffer.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/buffer.c
@@ -372,7 +372,7 @@ static void end_buffer_async_read_io(str
 }
 
 /*
- * Completion handler for block_write_full_page() - pages which are unlocked
+ * Completion handler for block_write_full_folio() - pages which are unlocked
  * during I/O, and which have PageWriteback cleared upon I/O completion.
  */
 void end_buffer_async_write(struct buffer_head *bh, int uptodate)
@@ -1771,18 +1771,18 @@ static struct buffer_head *folio_create_
  */
 
 /*
- * While block_write_full_page is writing back the dirty buffers under
+ * While block_write_full_folio is writing back the dirty buffers under
  * the page lock, whoever dirtied the buffers may decide to clean them
  * again at any time.  We handle that by only looking at the buffer
  * state inside lock_buffer().
  *
- * If block_write_full_page() is called for regular writeback
+ * If block_write_full_folio() is called for regular writeback
  * (wbc->sync_mode == WB_SYNC_NONE) then it will redirty a page which has a
  * locked buffer.   This only can happen if someone has written the buffer
  * directly, with submit_bh().  At the address_space level PageWriteback
  * prevents this contention from occurring.
  *
- * If block_write_full_page() is called with wbc->sync_mode ==
+ * If block_write_full_folio() is called with wbc->sync_mode ==
  * WB_SYNC_ALL, the writes are posted using REQ_SYNC; this
  * causes the writes to be flagged as synchronous writes.
  */
@@ -1829,7 +1829,7 @@ int __block_write_full_folio(struct inod
 			 * truncate in progress.
 			 */
 			/*
-			 * The buffer was zeroed by block_write_full_page()
+			 * The buffer was zeroed by block_write_full_folio()
 			 */
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
@@ -2696,10 +2696,9 @@ EXPORT_SYMBOL(block_truncate_page);
 /*
  * The generic ->writepage function for buffer-backed address_spaces
  */
-int block_write_full_page(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc)
+int block_write_full_folio(struct folio *folio, struct writeback_control *wbc,
+		void *get_block)
 {
-	struct folio *folio = page_folio(page);
 	struct inode * const inode = folio->mapping->host;
 	loff_t i_size = i_size_read(inode);
 
@@ -2726,7 +2725,6 @@ int block_write_full_page(struct page *p
 	return __block_write_full_folio(inode, folio, get_block, wbc,
 			end_buffer_async_write);
 }
-EXPORT_SYMBOL(block_write_full_page);
 
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 			    get_block_t *get_block)
--- a/fs/ext4/page-io.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/ext4/page-io.c
@@ -444,7 +444,7 @@ int ext4_bio_write_folio(struct ext4_io_
 	folio_clear_error(folio);
 
 	/*
-	 * Comments copied from block_write_full_page:
+	 * Comments copied from block_write_full_folio:
 	 *
 	 * The folio straddles i_size.  It must be zeroed out on each and every
 	 * writepage invocation because it may be mmapped.  "A file is mapped
--- a/fs/gfs2/aops.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/gfs2/aops.c
@@ -82,11 +82,11 @@ static int gfs2_get_block_noalloc(struct
 }
 
 /**
- * gfs2_write_jdata_folio - gfs2 jdata-specific version of block_write_full_page
+ * gfs2_write_jdata_folio - gfs2 jdata-specific version of block_write_full_folio
  * @folio: The folio to write
  * @wbc: The writeback control
  *
- * This is the same as calling block_write_full_page, but it also
+ * This is the same as calling block_write_full_folio, but it also
  * writes pages outside of i_size
  */
 static int gfs2_write_jdata_folio(struct folio *folio,
--- a/fs/mpage.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/mpage.c
@@ -642,7 +642,7 @@ confused:
 	/*
 	 * The caller has a ref on the inode, so *mapping is stable
 	 */
-	ret = block_write_full_page(&folio->page, mpd->get_block, wbc);
+	ret = block_write_full_folio(folio, wbc, mpd->get_block);
 	mapping_set_error(mapping, ret);
 out:
 	mpd->bio = bio;
--- a/fs/ntfs/aops.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/ntfs/aops.c
@@ -1304,7 +1304,7 @@ done:
  * page cleaned.  The VM has already locked the page and marked it clean.
  *
  * For non-resident attributes, ntfs_writepage() writes the @page by calling
- * the ntfs version of the generic block_write_full_page() function,
+ * the ntfs version of the generic block_write_full_folio() function,
  * ntfs_write_block(), which in turn if necessary creates and writes the
  * buffers associated with the page asynchronously.
  *
@@ -1314,7 +1314,7 @@ done:
  * vfs inode dirty code path for the inode the mft record belongs to or via the
  * vm page dirty code path for the page the mft record is in.
  *
- * Based on ntfs_read_folio() and fs/buffer.c::block_write_full_page().
+ * Based on ntfs_read_folio() and fs/buffer.c::block_write_full_folio().
  *
  * Return 0 on success and -errno on error.
  */
--- a/fs/ocfs2/alloc.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/ocfs2/alloc.c
@@ -6934,7 +6934,7 @@ static int ocfs2_grab_eof_pages(struct i
  * nonzero data on subsequent file extends.
  *
  * We need to call this before i_size is updated on the inode because
- * otherwise block_write_full_page() will skip writeout of pages past
+ * otherwise block_write_full_folio() will skip writeout of pages past
  * i_size.
  */
 int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
--- a/fs/ocfs2/file.c~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/fs/ocfs2/file.c
@@ -818,7 +818,7 @@ static int ocfs2_write_zero_page(struct
 	/*
 	 * fs-writeback will release the dirty pages without page lock
 	 * whose offset are over inode size, the release happens at
-	 * block_write_full_page().
+	 * block_write_full_folio().
 	 */
 	i_size_write(inode, abs_to);
 	inode->i_blocks = ocfs2_inode_sector_count(inode);
--- a/include/linux/buffer_head.h~fs-convert-block_write_full_page-to-block_write_full_folio
+++ a/include/linux/buffer_head.h
@@ -252,8 +252,8 @@ void __bh_read_batch(int nr, struct buff
  * address_spaces.
  */
 void block_invalidate_folio(struct folio *folio, size_t offset, size_t length);
-int block_write_full_page(struct page *page, get_block_t *get_block,
-				struct writeback_control *wbc);
+int block_write_full_folio(struct folio *folio, struct writeback_control *wbc,
+		void *get_block);
 int __block_write_full_folio(struct inode *inode, struct folio *folio,
 			get_block_t *get_block, struct writeback_control *wbc,
 			bh_end_io_t *handler);
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

