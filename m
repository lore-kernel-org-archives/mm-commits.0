Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBE5C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjDRXgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjDRXfL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF44BB84
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB1262F29
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340B5C433D2;
        Tue, 18 Apr 2023 23:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860888;
        bh=6uqvw6tdHBPJYfKR/gOTpVbYqFwpbXjGE8JEPDkW5fE=;
        h=Date:To:From:Subject:From;
        b=VrN6BgE9TaIz57FBwt7bvWzbNmQw5fdQXlFkE83DEaUWlryek1vy/Q+NVNudcgjJy
         EDwp6dRv5s9ofa3jInhCyK7WaGbD3XAdrSetjtzL5vt6VhPFkyTyNawpt9Ahyb0dsd
         Sj1KDr88l2QEZf229ignxL3v/WLBFnFvZvC+nRQA=
Date:   Tue, 18 Apr 2023 16:34:47 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-rename-__zram_bvec_read-to-zram_read_page.patch removed from -mm tree
Message-Id: <20230418233448.340B5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: rename __zram_bvec_read to zram_read_page
has been removed from the -mm tree.  Its filename was
     zram-rename-__zram_bvec_read-to-zram_read_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: rename __zram_bvec_read to zram_read_page
Date: Tue, 11 Apr 2023 19:14:51 +0200

__zram_bvec_read doesn't get passed a bvec, but always read a whole page. 
Rename it to make the usage more clear.

Link: https://lkml.kernel.org/r/20230411171459.567614-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rename-__zram_bvec_read-to-zram_read_page
+++ a/drivers/block/zram/zram_drv.c
@@ -1397,8 +1397,8 @@ static int zram_read_from_zspool(struct
 	return ret;
 }
 
-static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index,
-			    struct bio *bio, bool partial_io)
+static int zram_read_page(struct zram *zram, struct page *page, u32 index,
+			  struct bio *bio, bool partial_io)
 {
 	int ret;
 
@@ -1436,7 +1436,7 @@ static int zram_bvec_read(struct zram *z
 			return -ENOMEM;
 	}
 
-	ret = __zram_bvec_read(zram, page, index, bio, is_partial_io(bvec));
+	ret = zram_read_page(zram, page, index, bio, is_partial_io(bvec));
 	if (unlikely(ret))
 		goto out;
 
@@ -1593,7 +1593,7 @@ static int zram_bvec_write(struct zram *
 		if (!page)
 			return -ENOMEM;
 
-		ret = __zram_bvec_read(zram, page, index, bio, true);
+		ret = zram_read_page(zram, page, index, bio, true);
 		if (ret)
 			goto out;
 
_

Patches currently in -mm which might be from hch@lst.de are

zram-directly-call-zram_read_page-in-writeback_store.patch
zram-refactor-zram_bdev_read.patch
zram-dont-pass-a-bvec-to-__zram_bvec_write.patch
zram-refactor-zram_bdev_write.patch
zram-pass-a-page-to-read_from_bdev.patch
zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

