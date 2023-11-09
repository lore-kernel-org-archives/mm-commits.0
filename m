Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B9CC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjKIV50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjKIV5X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A5E3AA8
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF0C433C8;
        Thu,  9 Nov 2023 21:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567041;
        bh=xR9Nak3IIUBHCzsVwSfQnFkt+Eh9M7vnykNj1/LCv+s=;
        h=Date:To:From:Subject:From;
        b=g68DvvcEMFUwT4BP93gGPCech/Xq/ecQXQuTgIdyLr3iwx6cm3xQThlvATNWrzIZJ
         a7fSOgW8rotVTapV9rdd7AJPYz4kLl4ucS2mzcymCA6C2izpy1GUMbtogm6kKno8hZ
         qzINBRIh7Pmyy3P3tCpsJrS+CgqfHkYUUKT6wSsc=
Date:   Thu, 09 Nov 2023 13:57:20 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-grow_buffers-for-block-size-page_size.patch added to mm-unstable branch
Message-Id: <20231109215720.E9AF0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: fix grow_buffers() for block size > PAGE_SIZE
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-grow_buffers-for-block-size-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-grow_buffers-for-block-size-page_size.patch

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
Subject: buffer: fix grow_buffers() for block size > PAGE_SIZE
Date: Thu, 9 Nov 2023 21:06:04 +0000

We must not shift by a negative number so work in terms of a byte offset
to avoid the awkward shift left-or-right-depending-on-sign option.  This
means we need to use check_mul_overflow() to ensure that a large block
number does not result in a wrap.

Link: https://lkml.kernel.org/r/20231109210608.2252323-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/fs/buffer.c~buffer-fix-grow_buffers-for-block-size-page_size
+++ a/fs/buffer.c
@@ -1085,26 +1085,21 @@ unlock:
 static bool grow_buffers(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp)
 {
-	pgoff_t index;
-	int sizebits;
-
-	sizebits = PAGE_SHIFT - __ffs(size);
-	index = block >> sizebits;
+	loff_t pos;
 
 	/*
-	 * Check for a block which wants to lie outside our maximum possible
-	 * pagecache index.  (this comparison is done using sector_t types).
+	 * Check for a block which lies outside our maximum possible
+	 * pagecache index.
 	 */
-	if (unlikely(index != block >> sizebits)) {
-		printk(KERN_ERR "%s: requested out-of-range block %llu for "
-			"device %pg\n",
+	if (check_mul_overflow(block, size, &pos) || pos > MAX_LFS_FILESIZE) {
+		printk(KERN_ERR "%s: requested out-of-range block %llu for device %pg\n",
 			__func__, (unsigned long long)block,
 			bdev);
 		return false;
 	}
 
 	/* Create a folio with the proper size buffers */
-	return grow_dev_folio(bdev, block, index, size, gfp);
+	return grow_dev_folio(bdev, block, pos / PAGE_SIZE, size, gfp);
 }
 
 static struct buffer_head *
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

