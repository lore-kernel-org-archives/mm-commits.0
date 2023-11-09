Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ABFC4167D
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjKIV5X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIV5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C3B30D1
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:20 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88C4C433C9;
        Thu,  9 Nov 2023 21:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567039;
        bh=shK/ZIwMCmoMfU1+a/E3xwmdtws67zK73ouwzauKeLQ=;
        h=Date:To:From:Subject:From;
        b=B8v2Ve4YjufO6XEKeQtElCBI6TZ6MSGvV7S0OTwxEI8ygsUdiRs6EgpLVg8EQO13w
         MYaojVO7y++TqweOoFhYIcmvk2KLJk5SsDFGfvt38dvoVZTaX0jmsX+qaVMvTvbFEz
         6grMyR0lAcYZcU/tH9+hiDDHSzZVaZblXl0fjwIY=
Date:   Thu, 09 Nov 2023 13:57:19 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-calculate-block-number-inside-folio_init_buffers.patch added to mm-unstable branch
Message-Id: <20231109215719.D88C4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: calculate block number inside folio_init_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-calculate-block-number-inside-folio_init_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-calculate-block-number-inside-folio_init_buffers.patch

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
Subject: buffer: calculate block number inside folio_init_buffers()
Date: Thu, 9 Nov 2023 21:06:03 +0000

The calculation of block from index doesn't work for devices with a block
size larger than PAGE_SIZE as we end up shifting by a negative number. 
Instead, calculate the number of the first block from the folio's position
in the block device.  We no longer need to pass sizebits to
grow_dev_folio().

Link: https://lkml.kernel.org/r/20231109210608.2252323-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~buffer-calculate-block-number-inside-folio_init_buffers
+++ a/fs/buffer.c
@@ -995,11 +995,12 @@ static sector_t blkdev_max_block(struct
  * Initialise the state of a blockdev folio's buffers.
  */ 
 static sector_t folio_init_buffers(struct folio *folio,
-		struct block_device *bdev, sector_t block, int size)
+		struct block_device *bdev, unsigned size)
 {
 	struct buffer_head *head = folio_buffers(folio);
 	struct buffer_head *bh = head;
 	bool uptodate = folio_test_uptodate(folio);
+	sector_t block = div_u64(folio_pos(folio), size);
 	sector_t end_block = blkdev_max_block(bdev, size);
 
 	do {
@@ -1032,7 +1033,7 @@ static sector_t folio_init_buffers(struc
  * we succeeded, or the caller should retry.
  */
 static bool grow_dev_folio(struct block_device *bdev, sector_t block,
-		pgoff_t index, unsigned size, int sizebits, gfp_t gfp)
+		pgoff_t index, unsigned size, gfp_t gfp)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct folio *folio;
@@ -1047,8 +1048,7 @@ static bool grow_dev_folio(struct block_
 	bh = folio_buffers(folio);
 	if (bh) {
 		if (bh->b_size == size) {
-			end_block = folio_init_buffers(folio, bdev,
-					(sector_t)index << sizebits, size);
+			end_block = folio_init_buffers(folio, bdev, size);
 			goto unlock;
 		}
 
@@ -1069,8 +1069,7 @@ static bool grow_dev_folio(struct block_
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(folio, bh);
-	end_block = folio_init_buffers(folio, bdev,
-			(sector_t)index << sizebits, size);
+	end_block = folio_init_buffers(folio, bdev, size);
 	spin_unlock(&inode->i_mapping->private_lock);
 unlock:
 	folio_unlock(folio);
@@ -1105,7 +1104,7 @@ static bool grow_buffers(struct block_de
 	}
 
 	/* Create a folio with the proper size buffers */
-	return grow_dev_folio(bdev, block, index, size, sizebits, gfp);
+	return grow_dev_folio(bdev, block, index, size, gfp);
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

