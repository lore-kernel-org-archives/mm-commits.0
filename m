Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7A2C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjKIV5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjKIV52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E194206
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7678FC433CA;
        Thu,  9 Nov 2023 21:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567045;
        bh=P4oTN3aYxRuYCggbBIB34187McJ4rmh6UfUzIDxEx5s=;
        h=Date:To:From:Subject:From;
        b=xnnW0j2geUBqgO/Z9Apg2949C+aOlkZXV/lhuQhnKYQK/uYwrELfjikg/wqZzqIQr
         2TIwcf+HQtBQw8KhnCcSWCv+Tnl4BbHBpgg6KW2Uk27lnlwb4Y0JlA3Vfmcujdv/ql
         ZfT/VNAqZKKUaHYd7Aunb6tlMRQXifavF4nK3B+Q=
Date:   Thu, 09 Nov 2023 13:57:24 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-more-functions-for-block-size-page_size.patch added to mm-unstable branch
Message-Id: <20231109215725.7678FC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: fix more functions for block size > PAGE_SIZE
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-more-functions-for-block-size-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-more-functions-for-block-size-page_size.patch

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
Subject: buffer: fix more functions for block size > PAGE_SIZE
Date: Thu, 9 Nov 2023 21:06:08 +0000

Both __block_write_full_folio() and block_read_full_folio() assumed that
block size <= PAGE_SIZE.  Replace the shift with a divide, which is
probably cheaper than first calculating the shift.  That lets us remove
block_size_bits() as these were the last callers.

Link: https://lkml.kernel.org/r/20231109210608.2252323-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-fix-more-functions-for-block-size-page_size
+++ a/fs/buffer.c
@@ -1742,19 +1742,6 @@ unlock_page:
 }
 EXPORT_SYMBOL(clean_bdev_aliases);
 
-/*
- * Size is a power-of-two in the range 512..PAGE_SIZE,
- * and the case we care about most is PAGE_SIZE.
- *
- * So this *could* possibly be written with those
- * constraints in mind (relevant mostly if some
- * architecture has a slow bit-scan instruction)
- */
-static inline int block_size_bits(unsigned int blocksize)
-{
-	return ilog2(blocksize);
-}
-
 static struct buffer_head *folio_create_buffers(struct folio *folio,
 						struct inode *inode,
 						unsigned int b_state)
@@ -1807,7 +1794,7 @@ int __block_write_full_folio(struct inod
 	sector_t block;
 	sector_t last_block;
 	struct buffer_head *bh, *head;
-	unsigned int blocksize, bbits;
+	size_t blocksize;
 	int nr_underway = 0;
 	blk_opf_t write_flags = wbc_to_write_flags(wbc);
 
@@ -1826,10 +1813,9 @@ int __block_write_full_folio(struct inod
 
 	bh = head;
 	blocksize = bh->b_size;
-	bbits = block_size_bits(blocksize);
 
-	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
-	last_block = (i_size_read(inode) - 1) >> bbits;
+	block = div_u64(folio_pos(folio), blocksize);
+	last_block = div_u64(i_size_read(inode) - 1, blocksize);
 
 	/*
 	 * Get all the dirty buffers mapped to disk addresses and
@@ -2355,7 +2341,7 @@ int block_read_full_folio(struct folio *
 	struct inode *inode = folio->mapping->host;
 	sector_t iblock, lblock;
 	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
-	unsigned int blocksize, bbits;
+	size_t blocksize;
 	int nr, i;
 	int fully_mapped = 1;
 	bool page_error = false;
@@ -2369,10 +2355,9 @@ int block_read_full_folio(struct folio *
 
 	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
-	bbits = block_size_bits(blocksize);
 
-	iblock = (sector_t)folio->index << (PAGE_SHIFT - bbits);
-	lblock = (limit+blocksize-1) >> bbits;
+	iblock = div_u64(folio_pos(folio), blocksize);
+	lblock = div_u64(limit + blocksize - 1, blocksize);
 	bh = head;
 	nr = 0;
 	i = 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

