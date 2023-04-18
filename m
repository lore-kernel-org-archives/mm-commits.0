Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D534C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjDRXg4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjDRXf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD718A27B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F6F7615F4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E76C433D2;
        Tue, 18 Apr 2023 23:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860897;
        bh=ugfQrScPnexHPRXkVt/w9YASosSOF6BB0fYFqLndbBI=;
        h=Date:To:From:Subject:From;
        b=perleylglfLO3rMZLqTmqkKIsBQKndAqrAr3vK7c3I3JW2AdUHhRWqZuO5kgPcC2P
         YZYAGQTDmBNam68pdye1Yt48mRSTiMiFj0Uqwc+T/8Cy5JDyibYUU/xTgZtsjZQ9qt
         3+P7mPZMYXwwV6WxbmRUq2UNO8SkyidG2+z/UCkA=
Date:   Tue, 18 Apr 2023 16:34:56 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-return-errors-from-read_from_bdev_sync.patch removed from -mm tree
Message-Id: <20230418233456.E8E76C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: return errors from read_from_bdev_sync
has been removed from the -mm tree.  Its filename was
     zram-return-errors-from-read_from_bdev_sync.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: return errors from read_from_bdev_sync
Date: Tue, 11 Apr 2023 19:14:59 +0200

Propagate read errors to the caller instead of dropping them on the floor,
and stop returning the somewhat dangerous 1 on success from
read_from_bdev*.

Link: https://lkml.kernel.org/r/20230411171459.567614-18-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-return-errors-from-read_from_bdev_sync
+++ a/drivers/block/zram/zram_drv.c
@@ -770,6 +770,7 @@ struct zram_work {
 	struct zram *zram;
 	unsigned long entry;
 	struct page *page;
+	int error;
 };
 
 static void zram_sync_read(struct work_struct *work)
@@ -781,7 +782,7 @@ static void zram_sync_read(struct work_s
 	bio_init(&bio, zw->zram->bdev, &bv, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = zw->entry * (PAGE_SIZE >> 9);
 	__bio_add_page(&bio, zw->page, PAGE_SIZE, 0);
-	submit_bio_wait(&bio);
+	zw->error = submit_bio_wait(&bio);
 }
 
 /*
@@ -803,7 +804,7 @@ static int read_from_bdev_sync(struct zr
 	flush_work(&work.work);
 	destroy_work_on_stack(&work.work);
 
-	return 1;
+	return work.error;
 }
 
 static int read_from_bdev(struct zram *zram, struct page *page,
@@ -816,7 +817,7 @@ static int read_from_bdev(struct zram *z
 		return read_from_bdev_sync(zram, page, entry);
 	}
 	read_from_bdev_async(zram, page, entry, parent);
-	return 1;
+	return 0;
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
_

Patches currently in -mm which might be from hch@lst.de are


