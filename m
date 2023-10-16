Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C78C41513
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbjJPWLk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbjJPWLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:11:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92154F0
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:11:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D01FC433C7;
        Mon, 16 Oct 2023 22:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494284;
        bh=6Gdh45xtGa0ZYLBM2jSa8n+sYFE6Z53/xMrLiV69HiY=;
        h=Date:To:From:Subject:From;
        b=uzaX8wKPHgCB7P6IQ/477A1o0UlmeqoWqe1vcTBVcX/WyB060SWuDmz4ODbYManVJ
         yrQjeZEQPgqEaUUawH4+vQeZSP4rRGCz/A0jZC+59d0SaOi8F3WAvyu3MZnL9MS16P
         REdLqtUsFGNSa8awG32ve1P3cTX1MLXWh+Vw78rA=
Date:   Mon, 16 Oct 2023 15:11:23 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + reiserfs-convert-writepage-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20231016221124.2D01FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: convert writepage to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     reiserfs-convert-writepage-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reiserfs-convert-writepage-to-use-a-folio.patch

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
Subject: reiserfs: convert writepage to use a folio
Date: Mon, 16 Oct 2023 21:11:09 +0100

Convert the incoming page to a folio and then use it throughout the
writeback path.  This definitely isn't enough to support large folios, but
I don't expect reiserfs to gain support for those before it is removed.

Link: https://lkml.kernel.org/r/20231016201114.1928083-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |   80 +++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

--- a/fs/reiserfs/inode.c~reiserfs-convert-writepage-to-use-a-folio
+++ a/fs/reiserfs/inode.c
@@ -2507,10 +2507,10 @@ out:
  * start/recovery path as __block_write_full_folio, along with special
  * code to handle reiserfs tails.
  */
-static int reiserfs_write_full_page(struct page *page,
+static int reiserfs_write_full_folio(struct folio *folio,
 				    struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	unsigned long end_index = inode->i_size >> PAGE_SHIFT;
 	int error = 0;
 	unsigned long block;
@@ -2518,7 +2518,7 @@ static int reiserfs_write_full_page(stru
 	struct buffer_head *head, *bh;
 	int partial = 0;
 	int nr = 0;
-	int checked = PageChecked(page);
+	int checked = folio_test_checked(folio);
 	struct reiserfs_transaction_handle th;
 	struct super_block *s = inode->i_sb;
 	int bh_per_page = PAGE_SIZE / s->s_blocksize;
@@ -2526,47 +2526,46 @@ static int reiserfs_write_full_page(stru
 
 	/* no logging allowed when nonblocking or from PF_MEMALLOC */
 	if (checked && (current->flags & PF_MEMALLOC)) {
-		redirty_page_for_writepage(wbc, page);
-		unlock_page(page);
+		folio_redirty_for_writepage(wbc, folio);
+		folio_unlock(folio);
 		return 0;
 	}
 
 	/*
-	 * The page dirty bit is cleared before writepage is called, which
+	 * The folio dirty bit is cleared before writepage is called, which
 	 * means we have to tell create_empty_buffers to make dirty buffers
-	 * The page really should be up to date at this point, so tossing
+	 * The folio really should be up to date at this point, so tossing
 	 * in the BH_Uptodate is just a sanity check.
 	 */
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, s->s_blocksize,
+	head = folio_buffers(folio);
+	if (!head)
+		head = folio_create_empty_buffers(folio, s->s_blocksize,
 				     (1 << BH_Dirty) | (1 << BH_Uptodate));
-	}
-	head = page_buffers(page);
 
 	/*
-	 * last page in the file, zero out any contents past the
+	 * last folio in the file, zero out any contents past the
 	 * last byte in the file
 	 */
-	if (page->index >= end_index) {
+	if (folio->index >= end_index) {
 		unsigned last_offset;
 
 		last_offset = inode->i_size & (PAGE_SIZE - 1);
-		/* no file contents in this page */
-		if (page->index >= end_index + 1 || !last_offset) {
-			unlock_page(page);
+		/* no file contents in this folio */
+		if (folio->index >= end_index + 1 || !last_offset) {
+			folio_unlock(folio);
 			return 0;
 		}
-		zero_user_segment(page, last_offset, PAGE_SIZE);
+		folio_zero_segment(folio, last_offset, folio_size(folio));
 	}
 	bh = head;
-	block = page->index << (PAGE_SHIFT - s->s_blocksize_bits);
+	block = folio->index << (PAGE_SHIFT - s->s_blocksize_bits);
 	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
 	/* first map all the buffers, logging any direct items we find */
 	do {
 		if (block > last_block) {
 			/*
 			 * This can happen when the block size is less than
-			 * the page size.  The corresponding bytes in the page
+			 * the folio size.  The corresponding bytes in the folio
 			 * were zero filled above
 			 */
 			clear_buffer_dirty(bh);
@@ -2593,7 +2592,7 @@ static int reiserfs_write_full_page(stru
 	 * blocks we're going to log
 	 */
 	if (checked) {
-		ClearPageChecked(page);
+		folio_clear_checked(folio);
 		reiserfs_write_lock(s);
 		error = journal_begin(&th, s, bh_per_page + 1);
 		if (error) {
@@ -2602,7 +2601,7 @@ static int reiserfs_write_full_page(stru
 		}
 		reiserfs_update_inode_transaction(inode);
 	}
-	/* now go through and lock any dirty buffers on the page */
+	/* now go through and lock any dirty buffers on the folio */
 	do {
 		get_bh(bh);
 		if (!buffer_mapped(bh))
@@ -2623,7 +2622,7 @@ static int reiserfs_write_full_page(stru
 			lock_buffer(bh);
 		} else {
 			if (!trylock_buffer(bh)) {
-				redirty_page_for_writepage(wbc, page);
+				folio_redirty_for_writepage(wbc, folio);
 				continue;
 			}
 		}
@@ -2640,13 +2639,13 @@ static int reiserfs_write_full_page(stru
 		if (error)
 			goto fail;
 	}
-	BUG_ON(PageWriteback(page));
-	set_page_writeback(page);
-	unlock_page(page);
+	BUG_ON(folio_test_writeback(folio));
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 
 	/*
-	 * since any buffer might be the only dirty buffer on the page,
-	 * the first submit_bh can bring the page out of writeback.
+	 * since any buffer might be the only dirty buffer on the folio,
+	 * the first submit_bh can bring the folio out of writeback.
 	 * be careful with the buffers.
 	 */
 	do {
@@ -2663,10 +2662,10 @@ static int reiserfs_write_full_page(stru
 done:
 	if (nr == 0) {
 		/*
-		 * if this page only had a direct item, it is very possible for
+		 * if this folio only had a direct item, it is very possible for
 		 * no io to be required without there being an error.  Or,
 		 * someone else could have locked them and sent them down the
-		 * pipe without locking the page
+		 * pipe without locking the folio
 		 */
 		bh = head;
 		do {
@@ -2677,18 +2676,18 @@ done:
 			bh = bh->b_this_page;
 		} while (bh != head);
 		if (!partial)
-			SetPageUptodate(page);
-		end_page_writeback(page);
+			folio_mark_uptodate(folio);
+		folio_end_writeback(folio);
 	}
 	return error;
 
 fail:
 	/*
 	 * catches various errors, we need to make sure any valid dirty blocks
-	 * get to the media.  The page is currently locked and not marked for
+	 * get to the media.  The folio is currently locked and not marked for
 	 * writeback
 	 */
-	ClearPageUptodate(page);
+	folio_clear_uptodate(folio);
 	bh = head;
 	do {
 		get_bh(bh);
@@ -2698,16 +2697,16 @@ fail:
 		} else {
 			/*
 			 * clear any dirty bits that might have come from
-			 * getting attached to a dirty page
+			 * getting attached to a dirty folio
 			 */
 			clear_buffer_dirty(bh);
 		}
 		bh = bh->b_this_page;
 	} while (bh != head);
-	SetPageError(page);
-	BUG_ON(PageWriteback(page));
-	set_page_writeback(page);
-	unlock_page(page);
+	folio_set_error(folio);
+	BUG_ON(folio_test_writeback(folio));
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
@@ -2728,9 +2727,10 @@ static int reiserfs_read_folio(struct fi
 
 static int reiserfs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct folio *folio = page_folio(page);
+	struct inode *inode = folio->mapping->host;
 	reiserfs_wait_on_write_block(inode->i_sb);
-	return reiserfs_write_full_page(page, wbc);
+	return reiserfs_write_full_folio(folio, wbc);
 }
 
 static void reiserfs_truncate_failed_write(struct inode *inode)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch
filemap-remove-use-of-wait-bookmarks.patch
sched-remove-wait-bookmarks.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

