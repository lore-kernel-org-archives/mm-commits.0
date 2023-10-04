Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB90EE7C4F6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbjJDUWy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244932AbjJDUW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A411738
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDB9C433C7;
        Wed,  4 Oct 2023 20:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450899;
        bh=T0LkLdBDhjnuHuSF+R/UOW44Tl0ka03FW9+GZJqhx7I=;
        h=Date:To:From:Subject:From;
        b=u9G2njgKktU/tbRF+T5wnoCb6x9c4RZfM7OtfXhcMbvcCGGCi5w2e6yBf2OIhodRG
         xgKM2zg64LAuPwBtgijtDeWKHvgvCdkShfNLTrME4nzKQqcaLoWW+q7kZz2DEGXnsM
         I2991tKT05rtHG9Lvs3HzyNsxDpYKtWxJbxokXgY=
Date:   Wed, 04 Oct 2023 13:21:37 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-remove-__getblk_gfp.patch removed from -mm tree
Message-Id: <20231004202138.CDDB9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: remove __getblk_gfp()
has been removed from the -mm tree.  Its filename was
     buffer-remove-__getblk_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: remove __getblk_gfp()
Date: Thu, 14 Sep 2023 16:00:11 +0100

Inline it into __bread_gfp().

Link: https://lkml.kernel.org/r/20230914150011.843330-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   36 ++++++++++------------------------
 include/linux/buffer_head.h |    2 -
 2 files changed, 11 insertions(+), 27 deletions(-)

--- a/fs/buffer.c~buffer-remove-__getblk_gfp
+++ a/fs/buffer.c
@@ -1421,9 +1421,6 @@ EXPORT_SYMBOL(__find_get_block);
  * @size: The size of buffer_heads for this @bdev.
  * @gfp: The memory allocation flags to use.
  *
- * In contrast to __getblk_gfp(), the @gfp flags must be all of the flags;
- * they are not augmented with the mapping's GFP flags.
- *
  * Return: The buffer head, or NULL if memory could not be allocated.
  */
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
@@ -1440,27 +1437,6 @@ struct buffer_head *bdev_getblk(struct b
 EXPORT_SYMBOL(bdev_getblk);
 
 /*
- * __getblk_gfp() will locate (and, if necessary, create) the buffer_head
- * which corresponds to the passed block_device, block and size. The
- * returned buffer has its reference count incremented.
- */
-struct buffer_head *
-__getblk_gfp(struct block_device *bdev, sector_t block,
-	     unsigned size, gfp_t gfp)
-{
-	gfp |= mapping_gfp_constraint(bdev->bd_inode->i_mapping, ~__GFP_FS);
-
-	/*
-	 * Prefer looping in the allocator rather than here, at least that
-	 * code knows what it's doing.
-	 */
-	gfp |= __GFP_NOFAIL;
-
-	return bdev_getblk(bdev, block, size, gfp);
-}
-EXPORT_SYMBOL(__getblk_gfp);
-
-/*
  * Do async read-ahead on a buffer..
  */
 void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
@@ -1491,7 +1467,17 @@ struct buffer_head *
 __bread_gfp(struct block_device *bdev, sector_t block,
 		   unsigned size, gfp_t gfp)
 {
-	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
+	struct buffer_head *bh;
+
+	gfp |= mapping_gfp_constraint(bdev->bd_inode->i_mapping, ~__GFP_FS);
+
+	/*
+	 * Prefer looping in the allocator rather than here, at least that
+	 * code knows what it's doing.
+	 */
+	gfp |= __GFP_NOFAIL;
+
+	bh = bdev_getblk(bdev, block, size, gfp);
 
 	if (likely(bh) && !buffer_uptodate(bh))
 		bh = __bread_slow(bh);
--- a/include/linux/buffer_head.h~buffer-remove-__getblk_gfp
+++ a/include/linux/buffer_head.h
@@ -229,8 +229,6 @@ struct buffer_head *__find_get_block(str
 			unsigned size);
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp);
-struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
-				  unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

