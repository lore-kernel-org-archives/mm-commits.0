Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB695C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjKIV5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIV5V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329893AA8
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB049C433C8;
        Thu,  9 Nov 2023 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567038;
        bh=br4DZZXr9DlHreKB+Bn9u4foCOQ3bdZYIe/WX3KzaWM=;
        h=Date:To:From:Subject:From;
        b=tua5cqqXYATIkF424SlgDtuJP+YqIh+Xc9odphbzKt2O/+vgs4fKAA3damIWyzZna
         OQPd47jUjZxB6FSRNY0kxa6DFA/ZPE/mATNYkBZZaS1r4kn0Sub6JxaZ79DY+tk6fA
         O/lYG76l/iuGPhiC7F/YokRslVa+W5G1qfVk8PWY=
Date:   Thu, 09 Nov 2023 13:57:18 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-return-bool-from-grow_dev_folio.patch added to mm-unstable branch
Message-Id: <20231109215718.BB049C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: return bool from grow_dev_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-return-bool-from-grow_dev_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-return-bool-from-grow_dev_folio.patch

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
Subject: buffer: return bool from grow_dev_folio()
Date: Thu, 9 Nov 2023 21:06:02 +0000

Patch series "More buffer_head cleanups", v2.

The first patch is a left-over from last cycle.  The rest fix "obvious"
block size > PAGE_SIZE problems.  I haven't tested with a large block size
setup (but I have done an ext4 xfstests run).


This patch (of 7):

Rename grow_dev_page() to grow_dev_folio() and make it return a bool. 
Document what that bool means; it's more subtle than it first appears. 
Also rename the 'failed' label to 'unlock' beacuse it's not exactly
'failed'.  It just hasn't succeeded.

Link: https://lkml.kernel.org/r/20231109210608.2252323-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/fs/buffer.c~buffer-return-bool-from-grow_dev_folio
+++ a/fs/buffer.c
@@ -1024,40 +1024,43 @@ static sector_t folio_init_buffers(struc
 }
 
 /*
- * Create the page-cache page that contains the requested block.
+ * Create the page-cache folio that contains the requested block.
  *
  * This is used purely for blockdev mappings.
+ *
+ * Returns false if we have a 'permanent' failure.  Returns true if
+ * we succeeded, or the caller should retry.
  */
-static int
-grow_dev_page(struct block_device *bdev, sector_t block,
-	      pgoff_t index, int size, int sizebits, gfp_t gfp)
+static bool grow_dev_folio(struct block_device *bdev, sector_t block,
+		pgoff_t index, unsigned size, int sizebits, gfp_t gfp)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct folio *folio;
 	struct buffer_head *bh;
-	sector_t end_block;
-	int ret = 0;
+	sector_t end_block = 0;
 
 	folio = __filemap_get_folio(inode->i_mapping, index,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
 	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+		return false;
 
 	bh = folio_buffers(folio);
 	if (bh) {
 		if (bh->b_size == size) {
 			end_block = folio_init_buffers(folio, bdev,
 					(sector_t)index << sizebits, size);
-			goto done;
+			goto unlock;
 		}
+
+		/* Caller should retry if this call fails */
+		end_block = ~0ULL;
 		if (!try_to_free_buffers(folio))
-			goto failed;
+			goto unlock;
 	}
 
-	ret = -ENOMEM;
 	bh = folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
 	if (!bh)
-		goto failed;
+		goto unlock;
 
 	/*
 	 * Link the folio to the buffers and initialise them.  Take the
@@ -1069,20 +1072,19 @@ grow_dev_page(struct block_device *bdev,
 	end_block = folio_init_buffers(folio, bdev,
 			(sector_t)index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
-done:
-	ret = (block < end_block) ? 1 : -ENXIO;
-failed:
+unlock:
 	folio_unlock(folio);
 	folio_put(folio);
-	return ret;
+	return block < end_block;
 }
 
 /*
- * Create buffers for the specified block device block's page.  If
- * that page was dirty, the buffers are set dirty also.
+ * Create buffers for the specified block device block's folio.  If
+ * that folio was dirty, the buffers are set dirty also.  Returns false
+ * if we've hit a permanent error.
  */
-static int
-grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t gfp)
+static bool grow_buffers(struct block_device *bdev, sector_t block,
+		unsigned size, gfp_t gfp)
 {
 	pgoff_t index;
 	int sizebits;
@@ -1099,11 +1101,11 @@ grow_buffers(struct block_device *bdev,
 			"device %pg\n",
 			__func__, (unsigned long long)block,
 			bdev);
-		return -EIO;
+		return false;
 	}
 
-	/* Create a page with the proper size buffers.. */
-	return grow_dev_page(bdev, block, index, size, sizebits, gfp);
+	/* Create a folio with the proper size buffers */
+	return grow_dev_folio(bdev, block, index, size, sizebits, gfp);
 }
 
 static struct buffer_head *
@@ -1124,14 +1126,12 @@ __getblk_slow(struct block_device *bdev,
 
 	for (;;) {
 		struct buffer_head *bh;
-		int ret;
 
 		bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
 
-		ret = grow_buffers(bdev, block, size, gfp);
-		if (ret < 0)
+		if (!grow_buffers(bdev, block, size, gfp))
 			return NULL;
 	}
 }
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

