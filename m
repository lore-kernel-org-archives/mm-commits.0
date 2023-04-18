Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A1EC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjDRXgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjDRXfL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E512FB764
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 812B2601C3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5FCC433D2;
        Tue, 18 Apr 2023 23:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860885;
        bh=VXB6VyHLp5juv1yQIQ5V5850K4+50B7kcq6UW842DSc=;
        h=Date:To:From:Subject:From;
        b=hnjOjzgmgMbRaFljCEAbSSWmqCMHP6Va25MCLxB5Isw1/zILcdyaP38ZShPVdBGxE
         llvXIxUv17w/0cbsMNz2+Lz9WMw+csd0kHYklURQCtRugOHTD5NxRgyeZBrWjSAYwD
         C6kb9/JoSTe8qzEP8d7milhMrIlNVtS1S9yEtT0o=
Date:   Tue, 18 Apr 2023 16:34:44 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-return-early-on-error-in-zram_bvec_rw.patch removed from -mm tree
Message-Id: <20230418233444.DB5FCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: return early on error in zram_bvec_rw
has been removed from the -mm tree.  Its filename was
     zram-return-early-on-error-in-zram_bvec_rw.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: return early on error in zram_bvec_rw
Date: Tue, 11 Apr 2023 19:14:48 +0200

When the low-level access fails, don't clear the idle flag or clear the
caches, and just return.

Link: https://lkml.kernel.org/r/20230411171459.567614-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-return-early-on-error-in-zram_bvec_rw
+++ a/drivers/block/zram/zram_drv.c
@@ -1933,23 +1933,23 @@ static int zram_bvec_rw(struct zram *zra
 
 	if (!op_is_write(op)) {
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
+		if (unlikely(ret < 0)) {
+			atomic64_inc(&zram->stats.failed_reads);
+			return ret;
+		}
 		flush_dcache_page(bvec->bv_page);
 	} else {
 		ret = zram_bvec_write(zram, bvec, index, offset, bio);
+		if (unlikely(ret < 0)) {
+			atomic64_inc(&zram->stats.failed_writes);
+			return ret;
+		}
 	}
 
 	zram_slot_lock(zram, index);
 	zram_accessed(zram, index);
 	zram_slot_unlock(zram, index);
-
-	if (unlikely(ret < 0)) {
-		if (!op_is_write(op))
-			atomic64_inc(&zram->stats.failed_reads);
-		else
-			atomic64_inc(&zram->stats.failed_writes);
-	}
-
-	return ret;
+	return 0;
 }
 
 static void __zram_make_request(struct zram *zram, struct bio *bio)
_

Patches currently in -mm which might be from hch@lst.de are

zram-refactor-highlevel-read-and-write-handling.patch
zram-dont-use-highmem-for-the-bounce-buffer-in-zram_bvec_readwrite.patch
zram-rename-__zram_bvec_read-to-zram_read_page.patch
zram-directly-call-zram_read_page-in-writeback_store.patch
zram-refactor-zram_bdev_read.patch
zram-dont-pass-a-bvec-to-__zram_bvec_write.patch
zram-refactor-zram_bdev_write.patch
zram-pass-a-page-to-read_from_bdev.patch
zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

