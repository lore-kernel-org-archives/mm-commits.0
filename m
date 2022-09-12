Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5E5C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiILDer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiILDdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760AD27DE7
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D5C7B80C7B
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3BAC433D6;
        Mon, 12 Sep 2022 03:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953427;
        bh=BD1RINLGMFpvRUfJuu27zbMQmt1Kae43dfiH5SHjZlU=;
        h=Date:To:From:Subject:From;
        b=mwXyg9qrs/Qt2Zu9wMEFEFVKNGXKDXv5bTEA3nbJS9YKCVqYnfE1m467fuwQ0Z2tW
         bcXaw2delQidcIXdD3LUVPO9XRGKIl2rnlbq6e0FHWHuIrXzPFMfuiNSMtjoPcrY7t
         D7dE5Oj0sbEkACYUhkZnkWl1zyFAj02gNCagV+f4=
Date:   Sun, 11 Sep 2022 20:30:26 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033026.DB3BAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     fs-buffer-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: fs/buffer: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:54 +0800

ll_rw_block() is not safe for the sync IO path because it skip buffers
which has been locked by others, it could lead to false positive EIO
when submitting read IO. So stop using ll_rw_block(), switch to use new
helpers which could guarantee buffer locked and submit IO if needed.

Link: https://lkml.kernel.org/r/20220901133505.2510834-4-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~fs-buffer-replace-ll_rw_block
+++ a/fs/buffer.c
@@ -562,7 +562,7 @@ void write_boundary_block(struct block_d
 	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
-			ll_rw_block(REQ_OP_WRITE, 1, &bh);
+			write_dirty_buffer(bh, 0);
 		put_bh(bh);
 	}
 }
@@ -1342,7 +1342,7 @@ void __breadahead(struct block_device *b
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
-		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
+		bh_readahead(bh, REQ_RAHEAD);
 		brelse(bh);
 	}
 }
@@ -2022,7 +2022,7 @@ int __block_write_begin_int(struct folio
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
-			ll_rw_block(REQ_OP_READ, 1, &bh);
+			bh_read_nowait(bh, 0);
 			*wait_bh++=bh;
 		}
 	}
@@ -2582,11 +2582,9 @@ int block_truncate_page(struct address_s
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
-		err = -EIO;
-		ll_rw_block(REQ_OP_READ, 1, &bh);
-		wait_on_buffer(bh);
+		err = bh_read(bh, 0);
 		/* Uhhuh. Read error. Complain and punt. */
-		if (!buffer_uptodate(bh))
+		if (err < 0)
 			goto unlock;
 	}
 
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


