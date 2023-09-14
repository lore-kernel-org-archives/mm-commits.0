Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCA4EEAA53
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241561AbjINQGu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241582AbjINQGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1F11FE3
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7EEC433D9;
        Thu, 14 Sep 2023 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707599;
        bh=5/ZO6TLovgD8JfwXbPkWR94bV9ihuXIzcu2W0l0pFfk=;
        h=Date:To:From:Subject:From;
        b=H0ZF4TBHgcPcjWJA0rKadEWdXmr9j0dKCDOLEqePX/LwAXQLkG5DtrOdeWzTNj7Vb
         SfNJzdnb+gwTUvwWrzx23h9W0Qahf8fVJzYyGasPr1nnBMVwKcfeCXZXiwq1TGlnwE
         PlxaqfF7rTVFXYrwY/sCViY+kDv+68seiqc/zkR0=
Date:   Thu, 14 Sep 2023 09:06:38 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch added to mm-unstable branch
Message-Id: <20230914160639.7A7EEC433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert getblk_unmovable() and __getblk() to use bdev_getblk()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch

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
@@ -337,6 +337,28 @@ sb_breadahead(struct super_block *sb, se
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
@@ -384,20 +406,6 @@ static inline void lock_buffer(struct bu
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch

