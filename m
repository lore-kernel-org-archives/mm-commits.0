Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E968CEEAA54
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbjINQGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241553AbjINQGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFA31BDD
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C94C433C7;
        Thu, 14 Sep 2023 16:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707593;
        bh=TWwedEf9utloAXGu1CH4nhRE+Y6sMUXPNTZNhiHxP/A=;
        h=Date:To:From:Subject:From;
        b=pEC9L+Xdtl6zJkPcx9I/gt/YoiCENvl/9uigAUMbB3dkGMrxOT7QSHhsNFh6evgZg
         4HwiRnqRKZXAYGGLveMJOSd/p1BwHESDAznw2V6biQBKtw+uaqp7TToyA27WnKAdIN
         cmx+KfHjBxozuaemScBdqfZgPLsQ6dTJGUJUjIUs=
Date:   Thu, 14 Sep 2023 09:06:33 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch added to mm-unstable branch
Message-Id: <20230914160633.A1C94C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: hoist GFP flags from grow_dev_page() to __getblk_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch

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
Subject: buffer: hoist GFP flags from grow_dev_page() to __getblk_gfp()
Date: Thu, 14 Sep 2023 16:00:05 +0100

grow_dev_page() is only called by grow_buffers().  grow_buffers() is only
called by __getblk_slow() and __getblk_slow() is only called from
__getblk_gfp(), so it is safe to move the GFP flags setting all the way
up.  With that done, add a new bdev_getblk() entry point that leaves the
GFP flags the way the caller specified them.

Link: https://lkml.kernel.org/r/20230914150011.843330-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   60 ++++++++++++++++++++++------------
 include/linux/buffer_head.h |    2 +
 2 files changed, 41 insertions(+), 21 deletions(-)

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
@@ -1069,7 +1060,9 @@ grow_dev_page(struct block_device *bdev,
 			goto failed;
 	}
 
-	bh = folio_alloc_buffers(folio, size, gfp_mask | __GFP_ACCOUNT);
+	bh = folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
+	if (!bh)
+		goto failed;
 
 	/*
 	 * Link the folio to the buffers and initialise them.  Take the
@@ -1420,24 +1413,49 @@ __find_get_block(struct block_device *bd
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
@@ -224,6 +224,8 @@ void __wait_on_buffer(struct buffer_head
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch

