Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339A7E7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjJDUWu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244908AbjJDUW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D802F172B
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331A8C433C7;
        Wed,  4 Oct 2023 20:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450890;
        bh=zbDSZ7TadnexR2e+baMUDTg21l6h4BTs7v/X7EdtRr4=;
        h=Date:To:From:Subject:From;
        b=RozPrUI1e1+C6N31lVLUg2alIso9NcA23zW86LClEEgrls46tMmIwqedxO9nN7HnS
         QCFWyX3bKyTt3byM12O68GZw3FNW/hF3B+7yQBiPSJggVuUndbdFlk/V05cvRo72Qd
         Odya6NYhhnGBNDO4W3KcpLQrsnhfyN3C9UfZ7+4U=
Date:   Wed, 04 Oct 2023 13:21:28 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch removed from -mm tree
Message-Id: <20231004202130.331A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: use bdev_getblk() to avoid memory reclaim in readahead path
has been removed from the -mm tree.  Its filename was
     buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: use bdev_getblk() to avoid memory reclaim in readahead path
Date: Thu, 14 Sep 2023 16:00:07 +0100

__getblk() adds __GFP_NOFAIL, which is unnecessary for readahead; we're
quite comfortable with the possibility that we may not get a bh back. 
Switch to bdev_getblk() which does not include __GFP_NOFAIL.

Link: https://lkml.kernel.org/r/20230914150011.843330-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path
+++ a/fs/buffer.c
@@ -1465,7 +1465,9 @@ EXPORT_SYMBOL(__getblk_gfp);
  */
 void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
-	struct buffer_head *bh = __getblk(bdev, block, size);
+	struct buffer_head *bh = bdev_getblk(bdev, block, size,
+			GFP_NOWAIT | __GFP_MOVABLE);
+
 	if (likely(bh)) {
 		bh_readahead(bh, REQ_RAHEAD);
 		brelse(bh);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

