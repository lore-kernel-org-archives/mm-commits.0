Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F830C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjKIV5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjKIV5Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B546630D1
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5434FC433C9;
        Thu,  9 Nov 2023 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567043;
        bh=7RcqOrY3P1B85yLt5enhVbfkMq7jeNTHk7RuQzqBypc=;
        h=Date:To:From:Subject:From;
        b=hQVBks/bKqe7bMWawARpdKxXmwVYneixbN1vg52mqezVtvNybQBih0DlgYgPSDkj3
         qaGjGRBivvOaWICmcbd9zc8jtc5Wky8LlyASRV0+Kg5YzYqDYMeWsS0MXW+Z+lTHMF
         oht5Rwmrc/5Q+QBcmnCLrFHJVIsW9WDhequAF95c=
Date:   Thu, 09 Nov 2023 13:57:22 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-various-functions-for-block-size-page_size.patch added to mm-unstable branch
Message-Id: <20231109215723.5434FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: fix various functions for block size > PAGE_SIZE
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-various-functions-for-block-size-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-various-functions-for-block-size-page_size.patch

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
Subject: buffer: fix various functions for block size > PAGE_SIZE
Date: Thu, 9 Nov 2023 21:06:06 +0000

If i_blkbits is larger than PAGE_SHIFT, we shift by a negative number,
which is undefined.  It is safe to shift the block left as a block device
must be smaller than MAX_LFS_FILESIZE, which is guaranteed to fit in
loff_t.

Link: https://lkml.kernel.org/r/20231109210608.2252323-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/buffer.c~buffer-fix-various-functions-for-block-size-page_size
+++ a/fs/buffer.c
@@ -199,7 +199,7 @@ __find_get_block_slow(struct block_devic
 	int all_mapped = 1;
 	static DEFINE_RATELIMIT_STATE(last_warned, HZ, 1);
 
-	index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	index = ((loff_t)block << bd_inode->i_blkbits) / PAGE_SIZE;
 	folio = __filemap_get_folio(bd_mapping, index, FGP_ACCESSED, 0);
 	if (IS_ERR(folio))
 		goto out;
@@ -1693,13 +1693,13 @@ void clean_bdev_aliases(struct block_dev
 	struct inode *bd_inode = bdev->bd_inode;
 	struct address_space *bd_mapping = bd_inode->i_mapping;
 	struct folio_batch fbatch;
-	pgoff_t index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	pgoff_t index = ((loff_t)block << bd_inode->i_blkbits) / PAGE_SIZE;
 	pgoff_t end;
 	int i, count;
 	struct buffer_head *bh;
 	struct buffer_head *head;
 
-	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	end = ((loff_t)(block + len - 1) << bd_inode->i_blkbits) / PAGE_SIZE;
 	folio_batch_init(&fbatch);
 	while (filemap_get_folios(bd_mapping, &index, end, &fbatch)) {
 		count = folio_batch_count(&fbatch);
@@ -2660,8 +2660,8 @@ int block_truncate_page(struct address_s
 		return 0;
 
 	length = blocksize - length;
-	iblock = (sector_t)index << (PAGE_SHIFT - inode->i_blkbits);
-	
+	iblock = ((loff_t)index * PAGE_SIZE) >> inode->i_blkbits;
+
 	folio = filemap_grab_folio(mapping, index);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
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

