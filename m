Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D23C76196
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjDCUms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjDCUms (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:42:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FA3139
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F0A62AE4
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B976C433D2;
        Mon,  3 Apr 2023 20:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680554565;
        bh=+OcTxaaQ1pKeXrVnkYWx2bG9LmrxWgOeAG9u2XctnaA=;
        h=Date:To:From:Subject:From;
        b=DEdzvWfbyHRl51QB+u8Rmqa7wcqyJXxfIVfe0uc2dkPyY+a2UFB09Ptosm30SWweA
         8cJ7lg1gqJRV7AndFwJXMaoR5x/dS0B6BxXvMzKBABnlCkvBBbAzivOztAB9Xg+frq
         hKHWxeS+RNMQsEcnGlUlOXBcDCyD4Y1k0DGV3ozI=
Date:   Mon, 03 Apr 2023 13:42:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch added to mm-unstable branch
Message-Id: <20230403204245.2B976C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: always chain bio to the parent in read_from_bdev_async
has been added to the -mm mm-unstable branch.  Its filename is
     zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch

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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Minchan Kim <minchan@kernel.org>
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

zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch
orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-bi_end_io-callback-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
filemap-remove-page_endio.patch

