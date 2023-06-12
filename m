Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348A3C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbjFLVuh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjFLVu3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F0E18C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64EA962F61
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9224C433EF;
        Mon, 12 Jun 2023 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606626;
        bh=s8MaQbH472LHRe6pg4jTy30ZZc8s75vSiF7JQuZqB6o=;
        h=Date:To:From:Subject:From;
        b=L4gvhUCJNtHJnpbi+O2HanMKiGwfMIPqgjYmSaDHxjq4vGiMiR9mDARVFilRHk6br
         ZIOrge+7ceC21Egyh5aQ4k5tXXzeH5jkWwI7hfmOiZX45r/Jma+kFHba7QnHDALRZA
         5Jo1LUD9K0HtsH7pKflCbGShFmgVxCDeOuyDxTSw=
Date:   Mon, 12 Jun 2023 14:50:26 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch added to mm-unstable branch
Message-Id: <20230612215026.B9224C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert __block_write_full_page() to __block_write_full_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch

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
Subject: buffer: convert __block_write_full_page() to __block_write_full_folio()
Date: Mon, 12 Jun 2023 22:01:31 +0100

Remove nine hidden calls to compound_head() by using a folio instead of a
page.

Link: https://lkml.kernel.org/r/20230612210141.730128-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   53 +++++++++++++++++-----------------
 fs/gfs2/aops.c              |    5 +--
 fs/ntfs/aops.c              |    2 -
 fs/reiserfs/inode.c         |    2 -
 include/linux/buffer_head.h |    2 -
 5 files changed, 32 insertions(+), 32 deletions(-)

--- a/fs/buffer.c~buffer-convert-__block_write_full_page-to-__block_write_full_folio
+++ a/fs/buffer.c
@@ -1764,7 +1764,7 @@ static struct buffer_head *folio_create_
  * WB_SYNC_ALL, the writes are posted using REQ_SYNC; this
  * causes the writes to be flagged as synchronous writes.
  */
-int __block_write_full_page(struct inode *inode, struct page *page,
+int __block_write_full_folio(struct inode *inode, struct folio *folio,
 			get_block_t *get_block, struct writeback_control *wbc,
 			bh_end_io_t *handler)
 {
@@ -1776,14 +1776,14 @@ int __block_write_full_page(struct inode
 	int nr_underway = 0;
 	blk_opf_t write_flags = wbc_to_write_flags(wbc);
 
-	head = folio_create_buffers(page_folio(page), inode,
+	head = folio_create_buffers(folio, inode,
 				    (1 << BH_Dirty) | (1 << BH_Uptodate));
 
 	/*
 	 * Be very careful.  We have no exclusion from block_dirty_folio
 	 * here, and the (potentially unmapped) buffers may become dirty at
 	 * any time.  If a buffer becomes dirty here after we've inspected it
-	 * then we just miss that fact, and the page stays dirty.
+	 * then we just miss that fact, and the folio stays dirty.
 	 *
 	 * Buffers outside i_size may be dirtied by block_dirty_folio;
 	 * handle that here by just cleaning them.
@@ -1793,7 +1793,7 @@ int __block_write_full_page(struct inode
 	blocksize = bh->b_size;
 	bbits = block_size_bits(blocksize);
 
-	block = (sector_t)page->index << (PAGE_SHIFT - bbits);
+	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
 	last_block = (i_size_read(inode) - 1) >> bbits;
 
 	/*
@@ -1804,7 +1804,7 @@ int __block_write_full_page(struct inode
 		if (block > last_block) {
 			/*
 			 * mapped buffers outside i_size will occur, because
-			 * this page can be outside i_size when there is a
+			 * this folio can be outside i_size when there is a
 			 * truncate in progress.
 			 */
 			/*
@@ -1834,7 +1834,7 @@ int __block_write_full_page(struct inode
 			continue;
 		/*
 		 * If it's a fully non-blocking write attempt and we cannot
-		 * lock the buffer then redirty the page.  Note that this can
+		 * lock the buffer then redirty the folio.  Note that this can
 		 * potentially cause a busy-wait loop from writeback threads
 		 * and kswapd activity, but those code paths have their own
 		 * higher-level throttling.
@@ -1842,7 +1842,7 @@ int __block_write_full_page(struct inode
 		if (wbc->sync_mode != WB_SYNC_NONE) {
 			lock_buffer(bh);
 		} else if (!trylock_buffer(bh)) {
-			redirty_page_for_writepage(wbc, page);
+			folio_redirty_for_writepage(wbc, folio);
 			continue;
 		}
 		if (test_clear_buffer_dirty(bh)) {
@@ -1853,11 +1853,11 @@ int __block_write_full_page(struct inode
 	} while ((bh = bh->b_this_page) != head);
 
 	/*
-	 * The page and its buffers are protected by PageWriteback(), so we can
-	 * drop the bh refcounts early.
+	 * The folio and its buffers are protected by the writeback flag,
+	 * so we can drop the bh refcounts early.
 	 */
-	BUG_ON(PageWriteback(page));
-	set_page_writeback(page);
+	BUG_ON(folio_test_writeback(folio));
+	folio_start_writeback(folio);
 
 	do {
 		struct buffer_head *next = bh->b_this_page;
@@ -1867,20 +1867,20 @@ int __block_write_full_page(struct inode
 		}
 		bh = next;
 	} while (bh != head);
-	unlock_page(page);
+	folio_unlock(folio);
 
 	err = 0;
 done:
 	if (nr_underway == 0) {
 		/*
-		 * The page was marked dirty, but the buffers were
+		 * The folio was marked dirty, but the buffers were
 		 * clean.  Someone wrote them back by hand with
 		 * write_dirty_buffer/submit_bh.  A rare case.
 		 */
-		end_page_writeback(page);
+		folio_end_writeback(folio);
 
 		/*
-		 * The page and buffer_heads can be released at any time from
+		 * The folio and buffer_heads can be released at any time from
 		 * here on.
 		 */
 	}
@@ -1891,7 +1891,7 @@ recover:
 	 * ENOSPC, or some other error.  We may already have added some
 	 * blocks to the file, so we need to write these out to avoid
 	 * exposing stale data.
-	 * The page is currently locked and not marked for writeback
+	 * The folio is currently locked and not marked for writeback
 	 */
 	bh = head;
 	/* Recovery: lock and submit the mapped buffers */
@@ -1903,15 +1903,15 @@ recover:
 		} else {
 			/*
 			 * The buffer may have been set dirty during
-			 * attachment to a dirty page.
+			 * attachment to a dirty folio.
 			 */
 			clear_buffer_dirty(bh);
 		}
 	} while ((bh = bh->b_this_page) != head);
-	SetPageError(page);
-	BUG_ON(PageWriteback(page));
-	mapping_set_error(page->mapping, err);
-	set_page_writeback(page);
+	folio_set_error(folio);
+	BUG_ON(folio_test_writeback(folio));
+	mapping_set_error(folio->mapping, err);
+	folio_start_writeback(folio);
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
@@ -1921,10 +1921,10 @@ recover:
 		}
 		bh = next;
 	} while (bh != head);
-	unlock_page(page);
+	folio_unlock(folio);
 	goto done;
 }
-EXPORT_SYMBOL(__block_write_full_page);
+EXPORT_SYMBOL(__block_write_full_folio);
 
 /*
  * If a page has any new buffers, zero them out here, and mark them uptodate
@@ -2677,6 +2677,7 @@ EXPORT_SYMBOL(block_truncate_page);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 			struct writeback_control *wbc)
 {
+	struct folio *folio = page_folio(page);
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_SHIFT;
@@ -2684,13 +2685,13 @@ int block_write_full_page(struct page *p
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
-		return __block_write_full_page(inode, page, get_block, wbc,
+		return __block_write_full_folio(inode, folio, get_block, wbc,
 					       end_buffer_async_write);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_SIZE-1);
 	if (page->index >= end_index+1 || !offset) {
-		unlock_page(page);
+		folio_unlock(folio);
 		return 0; /* don't care */
 	}
 
@@ -2702,7 +2703,7 @@ int block_write_full_page(struct page *p
 	 * writes to that region are not written out to the file."
 	 */
 	zero_user_segment(page, offset, PAGE_SIZE);
-	return __block_write_full_page(inode, page, get_block, wbc,
+	return __block_write_full_folio(inode, folio, get_block, wbc,
 							end_buffer_async_write);
 }
 EXPORT_SYMBOL(block_write_full_page);
--- a/fs/gfs2/aops.c~buffer-convert-__block_write_full_page-to-__block_write_full_folio
+++ a/fs/gfs2/aops.c
@@ -107,9 +107,8 @@ static int gfs2_write_jdata_folio(struct
 		folio_zero_segment(folio, offset_in_folio(folio, i_size),
 				folio_size(folio));
 
-	return __block_write_full_page(inode, &folio->page,
-				       gfs2_get_block_noalloc, wbc,
-				       end_buffer_async_write);
+	return __block_write_full_folio(inode, folio, gfs2_get_block_noalloc,
+			wbc, end_buffer_async_write);
 }
 
 /**
--- a/fs/ntfs/aops.c~buffer-convert-__block_write_full_page-to-__block_write_full_folio
+++ a/fs/ntfs/aops.c
@@ -526,7 +526,7 @@ err_out:
  *
  * Return 0 on success and -errno on error.
  *
- * Based on ntfs_read_block() and __block_write_full_page().
+ * Based on ntfs_read_block() and __block_write_full_folio().
  */
 static int ntfs_write_block(struct page *page, struct writeback_control *wbc)
 {
--- a/fs/reiserfs/inode.c~buffer-convert-__block_write_full_page-to-__block_write_full_folio
+++ a/fs/reiserfs/inode.c
@@ -2506,7 +2506,7 @@ out:
 
 /*
  * mason@suse.com: updated in 2.5.54 to follow the same general io
- * start/recovery path as __block_write_full_page, along with special
+ * start/recovery path as __block_write_full_folio, along with special
  * code to handle reiserfs tails.
  */
 static int reiserfs_write_full_page(struct page *page,
--- a/include/linux/buffer_head.h~buffer-convert-__block_write_full_page-to-__block_write_full_folio
+++ a/include/linux/buffer_head.h
@@ -263,7 +263,7 @@ extern int buffer_heads_over_limit;
 void block_invalidate_folio(struct folio *folio, size_t offset, size_t length);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
-int __block_write_full_page(struct inode *inode, struct page *page,
+int __block_write_full_folio(struct inode *inode, struct folio *folio,
 			get_block_t *get_block, struct writeback_control *wbc,
 			bh_end_io_t *handler);
 int block_read_full_folio(struct folio *, get_block_t *);
_

Patches currently in -mm which might be from willy@infradead.org are

gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch
gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch
gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch
buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch
gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch
buffer-make-block_write_full_page-handle-large-folios-correctly.patch
buffer-convert-block_page_mkwrite-to-use-a-folio.patch
buffer-convert-__block_commit_write-to-take-a-folio.patch
buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch
buffer-convert-grow_dev_page-to-use-a-folio.patch
buffer-convert-init_page_buffers-to-folio_init_buffers.patch
buffer-convert-link_dev_buffers-to-take-a-folio.patch
buffer-use-a-folio-in-__find_get_block_slow.patch
buffer-convert-block_truncate_page-to-use-a-folio.patch

