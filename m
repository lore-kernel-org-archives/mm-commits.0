Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4959E7C4FA
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbjJDUW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjJDUW3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFC9173C
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875D9C433C7;
        Wed,  4 Oct 2023 20:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450905;
        bh=18y1Zq14hTiRQ2gaIdy0lH0DygZ9rTchO8y8HzTy+3g=;
        h=Date:To:From:Subject:From;
        b=ud/IvrI9xpwLJxmxLRQ+ujl/Sa3G2PE4nZU6TcH/BIJ55wgnOWHLw4/cL9GL/Sp70
         jAiYSOCSnq0jicKOMPpzDKJLW9Pt8979DDQn+Zbz7HPqq5Z4bGtgGdKgf/OcqMj5HD
         mDf1fhG6MSYQmmu9zDNhdCHQPQHEYQ2qqutxfEUE=
Date:   Wed, 04 Oct 2023 13:21:43 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch removed from -mm tree
Message-Id: <20231004202145.875D9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert getblk_unmovable() and __getblk() to use bdev_getblk()
has been removed from the -mm tree.  Its filename was
     buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert getblk_unmovable() and __getblk() to use bdev_getblk()
Date: Thu, 14 Sep 2023 16:00:08 +0100

Move these two functions up in the file for the benefit of the next patch,
and pass in all of the GFP flags to use instead of the partial GFP flags
used by __getblk_gfp().

Link: https://lkml.kernel.org/r/20230914150011.843330-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |   36 ++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/include/linux/buffer_head.h~buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk
+++ a/include/linux/buffer_head.h
@@ -340,6 +340,28 @@ sb_breadahead(struct super_block *sb, se
 	__breadahead(sb->s_bdev, block, sb->s_blocksize);
 }
 
+static inline struct buffer_head *getblk_unmovable(struct block_device *bdev,
+		sector_t block, unsigned size)
+{
+	gfp_t gfp;
+
+	gfp = mapping_gfp_constraint(bdev->bd_inode->i_mapping, ~__GFP_FS);
+	gfp |= __GFP_NOFAIL;
+
+	return bdev_getblk(bdev, block, size, gfp);
+}
+
+static inline struct buffer_head *__getblk(struct block_device *bdev,
+		sector_t block, unsigned size)
+{
+	gfp_t gfp;
+
+	gfp = mapping_gfp_constraint(bdev->bd_inode->i_mapping, ~__GFP_FS);
+	gfp |= __GFP_MOVABLE | __GFP_NOFAIL;
+
+	return bdev_getblk(bdev, block, size, gfp);
+}
+
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
 {
@@ -387,20 +409,6 @@ static inline void lock_buffer(struct bu
 		__lock_buffer(bh);
 }
 
-static inline struct buffer_head *getblk_unmovable(struct block_device *bdev,
-						   sector_t block,
-						   unsigned size)
-{
-	return __getblk_gfp(bdev, block, size, 0);
-}
-
-static inline struct buffer_head *__getblk(struct block_device *bdev,
-					   sector_t block,
-					   unsigned size)
-{
-	return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
-}
-
 static inline void bh_readahead(struct buffer_head *bh, blk_opf_t op_flags)
 {
 	if (!buffer_uptodate(bh) && trylock_buffer(bh)) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

