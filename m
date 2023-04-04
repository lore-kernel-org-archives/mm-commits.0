Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2098C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbjDDTcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbjDDTcU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19C12111
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BF17630C3
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F1AC433EF;
        Tue,  4 Apr 2023 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680636738;
        bh=iL6Y6W6HW9KLKgtOM5q5U2QNNJj+JRvoLvjGgUmEtpo=;
        h=Date:To:From:Subject:From;
        b=xwMeBELbqlTm0SbA8gPYOiL4m4kP3f4tjO4jpfNEuI5yvqZP3HGYlZoOcoSNxPyKO
         5Eehi/+DT83FVtreK5B0NsLxYM77lRMimRKNGMZdRcC/Ehs2XB5BxZ+fo49DogddAz
         r4iK5gbPvZe3ybG8/z8TJtbt/gOqbC2q3hUHmvfY=
Date:   Tue, 04 Apr 2023 12:32:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch removed from -mm tree
Message-Id: <20230404193218.A9F1AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: always chain bio to the parent in read_from_bdev_async
has been removed from the -mm tree.  Its filename was
     zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: zram: always chain bio to the parent in read_from_bdev_async
Date: Mon, 3 Apr 2023 15:22:17 +0200

Patch series "remove page_endio()", v2.

It was decided to remove page_endio() as per the previous RFC
discussion[1] of this series and move that functionality into the caller
itself.  One of the side benefit of doing that is the callers have been
modified to directly work on folios as page_endio() already worked on
folios.

mpage changes were tested with a simple boot testing.  orangefs was tested
by Mike Marshall (No code changes since he tested).  Basic testing was
performed for the zram changes with fio and writeback to a backing device.


This patch (of 5):

zram_bvec_read() is called with the bio set to NULL only in
writeback_store() function.  When a writeback is triggered,
zram_bvec_read() is called only if ZRAM_WB flag is not set.  That will
result only calling zram_read_from_zspool() in __zram_bvec_read().

rw_page callback used to call read_from_bdev_async with a NULL parent bio
but that has been removed since commit 3222d8c2a7f8 ("block: remove
->rw_page").

We can now safely always call bio_chain() as read_from_bdev_async() will
be called with a parent bio set.  A WARN_ON_ONCE is added if this function
is called with parent set to NULL.

Link: https://lore.kernel.org/linux-mm/ZBHcl8Pz2ULb4RGD@infradead.org/ [1]
Link: https://lore.kernel.org/linux-mm/20230322135013.197076-1-p.raghav@samsung.com/ [2]
Link: https://lore.kernel.org/linux-mm/8adb0770-6124-e11f-2551-6582db27ed32@samsung.com/ [3]
Link: https://lkml.kernel.org/r/20230403132221.94921-2-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-always-chain-bio-to-the-parent-in-read_from_bdev_async
+++ a/drivers/block/zram/zram_drv.c
@@ -606,15 +606,6 @@ static void free_block_bdev(struct zram
 	atomic64_dec(&zram->stats.bd_count);
 }
 
-static void zram_page_end_io(struct bio *bio)
-{
-	struct page *page = bio_first_page_all(bio);
-
-	page_endio(page, op_is_write(bio_op(bio)),
-			blk_status_to_errno(bio->bi_status));
-	bio_put(bio);
-}
-
 /*
  * Returns 1 if the submission is successful.
  */
@@ -634,11 +625,10 @@ static int read_from_bdev_async(struct z
 		return -EIO;
 	}
 
-	if (!parent)
-		bio->bi_end_io = zram_page_end_io;
-	else
-		bio_chain(bio, parent);
+	if (WARN_ON_ONCE(!parent))
+		return -EINVAL;
 
+	bio_chain(bio, parent);
 	submit_bio(bio);
 	return 1;
 }
_

Patches currently in -mm which might be from p.raghav@samsung.com are

orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-bi_end_io-callback-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
filemap-remove-page_endio.patch

