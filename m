Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7A7E7C4F8
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjJDUWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244889AbjJDUW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0321723
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D25CC433C8;
        Wed,  4 Oct 2023 20:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450886;
        bh=wXqtXn/SzWU4fxAP4lPfORSDWUKRUEAsNb2YBqmmU6E=;
        h=Date:To:From:Subject:From;
        b=oBJXTNG29qdhtrYm2qRwiyhD3aKr9bEOvLL7wIh7mxbwO5EiDZGEV6VMr66o0LBDH
         NjU4mMro0nEW8dd8K59DW0RG0ViDN3RfCc88VLIJl+RTVzUkaTV7MTgGSVEBAYe4up
         9nEoETUW65g96Gr5/7HVRUM7nGIUD4pm1egqK00M=
Date:   Wed, 04 Oct 2023 13:21:24 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        dan.carpenter@linaro.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch removed from -mm tree
Message-Id: <20231004202126.3D25CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: hoist GFP flags from grow_dev_page() to __getblk_gfp()
has been removed from the -mm tree.  Its filename was
     buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: hoist GFP flags from grow_dev_page() to __getblk_gfp()
Date: Thu, 14 Sep 2023 16:00:05 +0100

grow_dev_page() is only called by grow_buffers().  grow_buffers() is only
called by __getblk_slow() and __getblk_slow() is only called from
__getblk_gfp(), so it is safe to move the GFP flags setting all the way
up.  With that done, add a new bdev_getblk() entry point that leaves the
GFP flags the way the caller specified them.

[willy@infradead.org: fix grow_dev_page() error handling]
  Link: https://lkml.kernel.org/r/ZRREEIwqiy5DijKB@casper.infradead.org
Link: https://lkml.kernel.org/r/20230914150011.843330-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   61 ++++++++++++++++++++++------------
 include/linux/buffer_head.h |    2 +
 2 files changed, 42 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp
+++ a/fs/buffer.c
@@ -1043,20 +1043,11 @@ grow_dev_page(struct block_device *bdev,
 	struct buffer_head *bh;
 	sector_t end_block;
 	int ret = 0;
-	gfp_t gfp_mask;
-
-	gfp_mask = mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS) | gfp;
-
-	/*
-	 * XXX: __getblk_slow() can not really deal with failure and
-	 * will endlessly loop on improvised global reclaim.  Prefer
-	 * looping in the allocator rather than here, at least that
-	 * code knows what it's doing.
-	 */
-	gfp_mask |= __GFP_NOFAIL;
 
 	folio = __filemap_get_folio(inode->i_mapping, index,
-			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp_mask);
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
 	bh = folio_buffers(folio);
 	if (bh) {
@@ -1069,7 +1060,10 @@ grow_dev_page(struct block_device *bdev,
 			goto failed;
 	}
 
-	bh = folio_alloc_buffers(folio, size, gfp_mask | __GFP_ACCOUNT);
+	ret = -ENOMEM;
+	bh = folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
+	if (!bh)
+		goto failed;
 
 	/*
 	 * Link the folio to the buffers and initialise them.  Take the
@@ -1420,24 +1414,49 @@ __find_get_block(struct block_device *bd
 }
 EXPORT_SYMBOL(__find_get_block);
 
+/**
+ * bdev_getblk - Get a buffer_head in a block device's buffer cache.
+ * @bdev: The block device.
+ * @block: The block number.
+ * @size: The size of buffer_heads for this @bdev.
+ * @gfp: The memory allocation flags to use.
+ *
+ * In contrast to __getblk_gfp(), the @gfp flags must be all of the flags;
+ * they are not augmented with the mapping's GFP flags.
+ *
+ * Return: The buffer head, or NULL if memory could not be allocated.
+ */
+struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
+		unsigned size, gfp_t gfp)
+{
+	struct buffer_head *bh = __find_get_block(bdev, block, size);
+
+	might_alloc(gfp);
+	if (bh)
+		return bh;
+
+	return __getblk_slow(bdev, block, size, gfp);
+}
+EXPORT_SYMBOL(bdev_getblk);
+
 /*
  * __getblk_gfp() will locate (and, if necessary, create) the buffer_head
  * which corresponds to the passed block_device, block and size. The
  * returned buffer has its reference count incremented.
- *
- * __getblk_gfp() will lock up the machine if grow_dev_page's
- * try_to_free_buffers() attempt is failing.  FIXME, perhaps?
  */
 struct buffer_head *
 __getblk_gfp(struct block_device *bdev, sector_t block,
 	     unsigned size, gfp_t gfp)
 {
-	struct buffer_head *bh = __find_get_block(bdev, block, size);
+	gfp |= mapping_gfp_constraint(bdev->bd_inode->i_mapping, ~__GFP_FS);
 
-	might_sleep();
-	if (bh == NULL)
-		bh = __getblk_slow(bdev, block, size, gfp);
-	return bh;
+	/*
+	 * Prefer looping in the allocator rather than here, at least that
+	 * code knows what it's doing.
+	 */
+	gfp |= __GFP_NOFAIL;
+
+	return bdev_getblk(bdev, block, size, gfp);
 }
 EXPORT_SYMBOL(__getblk_gfp);
 
--- a/include/linux/buffer_head.h~buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp
+++ a/include/linux/buffer_head.h
@@ -227,6 +227,8 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
 			unsigned size);
+struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
+		unsigned size, gfp_t gfp);
 struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
 				  unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

