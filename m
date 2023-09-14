Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977BDEEAA52
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241828AbjINQHC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241654AbjINQGu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738C71FF3
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E264C433CA;
        Thu, 14 Sep 2023 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707605;
        bh=T1YtBv5/GIRgA3g2ZCeaY1v1fb2W9qixUHgAXP1poUs=;
        h=Date:To:From:Subject:From;
        b=C0vJ82KCqe275WHd8TnK3G6OlPgyYjPpDZzipL/2Bg1zwYA5o3WvGwpfgDMqv8vzm
         TCG5rbakkcvOMq5ulm6ZgTm4HYOXq7IC7GOkPxJFK3dldSrMwLUffh0jhnD4eF/60I
         lImfRIZl+HQlSHyaXc0SmvAU0NfgOdhVpLDAIFn0=
Date:   Thu, 14 Sep 2023 09:06:44 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-remove-__getblk_gfp.patch added to mm-unstable branch
Message-Id: <20230914160645.0E264C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: remove __getblk_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-remove-__getblk_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-remove-__getblk_gfp.patch

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
@@ -1420,9 +1420,6 @@ EXPORT_SYMBOL(__find_get_block);
  * @size: The size of buffer_heads for this @bdev.
  * @gfp: The memory allocation flags to use.
  *
- * In contrast to __getblk_gfp(), the @gfp flags must be all of the flags;
- * they are not augmented with the mapping's GFP flags.
- *
  * Return: The buffer head, or NULL if memory could not be allocated.
  */
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
@@ -1439,27 +1436,6 @@ struct buffer_head *bdev_getblk(struct b
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
@@ -1490,7 +1466,17 @@ struct buffer_head *
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
@@ -226,8 +226,6 @@ struct buffer_head *__find_get_block(str
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch

