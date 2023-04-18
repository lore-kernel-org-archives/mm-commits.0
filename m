Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CFBC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDRXg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXf2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1753A26F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F13363A0A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D70C433EF;
        Tue, 18 Apr 2023 23:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860894;
        bh=dz6+wjX2evWhSKcnZaUKR/LlgwWRiO6rO9kzf0IYtJE=;
        h=Date:To:From:Subject:From;
        b=bQAeQtUioymrMk8sz00GZaQfKArmBiEQnwZqsN4slpP+89RPUzdtMEkZjKtmaAcoJ
         qryiA+9aQ1JRp09J/w+h7zTu7XfMBmVnNcOEnGhA2huRRzpRR5kpgJZ9S86O/0dE/3
         ZB6xYI0ELneldW1eJLBuIzMft2DGhcIO9zwjkFy4=
Date:   Tue, 18 Apr 2023 16:34:54 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-dont-return-errors-from-read_from_bdev_async.patch removed from -mm tree
Message-Id: <20230418233454.B6D70C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: don't return errors from read_from_bdev_async
has been removed from the -mm tree.  Its filename was
     zram-dont-return-errors-from-read_from_bdev_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: don't return errors from read_from_bdev_async
Date: Tue, 11 Apr 2023 19:14:57 +0200

bio_alloc will never return a NULL bio when it is allowed to sleep, and
adding a single page to bio with a single vector also can't fail, so
switch to the asserting __bio_add_page variant and drop the error returns.

Link: https://lkml.kernel.org/r/20230411171459.567614-16-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-return-errors-from-read_from_bdev_async
+++ a/drivers/block/zram/zram_drv.c
@@ -585,24 +585,16 @@ static void zram_page_end_io(struct bio
 	bio_put(bio);
 }
 
-/*
- * Returns 1 if the submission is successful.
- */
-static int read_from_bdev_async(struct zram *zram, struct page *page,
+static void read_from_bdev_async(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent)
 {
 	struct bio *bio;
 
 	bio = bio_alloc(zram->bdev, 1, parent ? parent->bi_opf : REQ_OP_READ,
 			GFP_NOIO);
-	if (!bio)
-		return -ENOMEM;
 
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
-	if (!bio_add_page(bio, page, PAGE_SIZE, 0)) {
-		bio_put(bio);
-		return -EIO;
-	}
+	__bio_add_page(bio, page, PAGE_SIZE, 0);
 
 	if (!parent)
 		bio->bi_end_io = zram_page_end_io;
@@ -610,7 +602,6 @@ static int read_from_bdev_async(struct z
 		bio_chain(bio, parent);
 
 	submit_bio(bio);
-	return 1;
 }
 
 #define PAGE_WB_SIG "page_index="
@@ -840,7 +831,8 @@ static int read_from_bdev(struct zram *z
 			return -EIO;
 		return read_from_bdev_sync(zram, page, entry, parent);
 	}
-	return read_from_bdev_async(zram, page, entry, parent);
+	read_from_bdev_async(zram, page, entry, parent);
+	return 1;
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
_

Patches currently in -mm which might be from hch@lst.de are

zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

