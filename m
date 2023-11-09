Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A864FC4167D
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjKIV5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjKIV51 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35153ABF
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFD0C433C7;
        Thu,  9 Nov 2023 21:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567044;
        bh=syJQyp5RBjO4KWibibA75JnQ85USGYX4yUaIlhXLq3E=;
        h=Date:To:From:Subject:From;
        b=VGmhtO/ohQ60TiAT7bysJlRxPPvvoX3gId478u8p4OOmUpm0P4E5Sj+NIGW7FWp4P
         uaK6S5PnGuDqlmczcfXhu6xZtrKL/dE9SMis2x6gDyy7LMwZPbAg05yMxAs5adZOQa
         ZlhERPEzrJXbeqgQdnz+seug1xykjFDTS1x9yyOk=
Date:   Thu, 09 Nov 2023 13:57:23 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-handle-large-folios-in-__block_write_begin_int.patch added to mm-unstable branch
Message-Id: <20231109215724.6FFD0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: handle large folios in __block_write_begin_int()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-handle-large-folios-in-__block_write_begin_int.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-handle-large-folios-in-__block_write_begin_int.patch

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
Subject: buffer: handle large folios in __block_write_begin_int()
Date: Thu, 9 Nov 2023 21:06:07 +0000

When __block_write_begin_int() was converted to support folios, we did not
expect large folios to be passed to it.  With the current work to support
large block size storage devices, this will no longer be true so change
the checks on 'from' and 'to' to be related to the size of the folio
instead of PAGE_SIZE.  Also remove an assumption that the block size is
smaller than PAGE_SIZE.

Link: https://lkml.kernel.org/r/20231109210608.2252323-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/fs/buffer.c~buffer-handle-large-folios-in-__block_write_begin_int
+++ a/fs/buffer.c
@@ -2075,27 +2075,24 @@ iomap_to_bh(struct inode *inode, sector_
 int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block, const struct iomap *iomap)
 {
-	unsigned from = pos & (PAGE_SIZE - 1);
-	unsigned to = from + len;
+	size_t from = offset_in_folio(folio, pos);
+	size_t to = from + len;
 	struct inode *inode = folio->mapping->host;
-	unsigned block_start, block_end;
+	size_t block_start, block_end;
 	sector_t block;
 	int err = 0;
-	unsigned blocksize, bbits;
+	size_t blocksize;
 	struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
 
 	BUG_ON(!folio_test_locked(folio));
-	BUG_ON(from > PAGE_SIZE);
-	BUG_ON(to > PAGE_SIZE);
+	BUG_ON(to > folio_size(folio));
 	BUG_ON(from > to);
 
 	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
-	bbits = block_size_bits(blocksize);
+	block = div_u64(folio_pos(folio), blocksize);
 
-	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
-
-	for(bh = head, block_start = 0; bh != head || !block_start;
+	for (bh = head, block_start = 0; bh != head || !block_start;
 	    block++, block_start=block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
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

