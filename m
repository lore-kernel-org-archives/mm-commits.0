Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C8BC76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbjDFWSe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237725AbjDFWSb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B568B7
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB49B60FD2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162DDC433EF;
        Thu,  6 Apr 2023 22:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819508;
        bh=ZYH2GeFUGo4NNeHdIQv4dAyNVsAjMXiC45oFs2fUwvE=;
        h=Date:To:From:Subject:From;
        b=0X8wvf/i8B0X19sJvGcZRVCPVi9V8vDUEokt1VdP5d83PufVeL7AkogWVF7ZJ76So
         bwhX87oKcrksfvss+blq1eIXNK3bmyVYvwlxSgID3MOl6CC5Rq9Me7lY3Gtrxb3Ji4
         vrx6X26z5Iy1yw5hu+Tjc3ivc8/9rxAt4gd0h+nk=
Date:   Thu, 06 Apr 2023 15:18:27 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-valid_io_request.patch added to mm-unstable branch
Message-Id: <20230406221828.162DDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove valid_io_request
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-valid_io_request.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-valid_io_request.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: zram: remove valid_io_request
Date: Thu, 6 Apr 2023 16:40:47 +0200

Patch series "zram I/O path cleanups and fixups", v2.

This series cleans up the zram I/O path, and fixes the handling of
synchronous I/O to the underlying device in the writeback_store function
or for > 4K PAGE_SIZE systems.

The fixes are at the end, as I could not fully reason about them being
safe before untangling the callchain.


This patch (of 16):

All bios hande to drivers from the block layer are checked against the
device size and for logical block alignment already (and have been since
long before zram was merged), so don't duplicate those checks.

Link: https://lkml.kernel.org/r/20230406144102.149231-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230406144102.149231-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   34 --------------------------------
 drivers/block/zram/zram_drv.h |    1 
 2 files changed, 1 insertion(+), 34 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-valid_io_request
+++ a/drivers/block/zram/zram_drv.c
@@ -174,30 +174,6 @@ static inline u32 zram_get_priority(stru
 	return prio & ZRAM_COMP_PRIORITY_MASK;
 }
 
-/*
- * Check if request is within bounds and aligned on zram logical blocks.
- */
-static inline bool valid_io_request(struct zram *zram,
-		sector_t start, unsigned int size)
-{
-	u64 end, bound;
-
-	/* unaligned request */
-	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
-		return false;
-	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
-		return false;
-
-	end = start + (size >> SECTOR_SHIFT);
-	bound = zram->disksize >> SECTOR_SHIFT;
-	/* out of range */
-	if (unlikely(start >= bound || end > bound || start > end))
-		return false;
-
-	/* I/O request is valid */
-	return true;
-}
-
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
 {
 	*index  += (*offset + bvec->bv_len) / PAGE_SIZE;
@@ -1190,10 +1166,9 @@ static ssize_t io_stat_show(struct devic
 
 	down_read(&zram->init_lock);
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8llu\n",
+			"%8llu %8llu 0 %8llu\n",
 			(u64)atomic64_read(&zram->stats.failed_reads),
 			(u64)atomic64_read(&zram->stats.failed_writes),
-			(u64)atomic64_read(&zram->stats.invalid_io),
 			(u64)atomic64_read(&zram->stats.notify_free));
 	up_read(&zram->init_lock);
 
@@ -2043,13 +2018,6 @@ static void zram_submit_bio(struct bio *
 {
 	struct zram *zram = bio->bi_bdev->bd_disk->private_data;
 
-	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
-					bio->bi_iter.bi_size)) {
-		atomic64_inc(&zram->stats.invalid_io);
-		bio_io_error(bio);
-		return;
-	}
-
 	__zram_make_request(zram, bio);
 }
 
--- a/drivers/block/zram/zram_drv.h~zram-remove-valid_io_request
+++ a/drivers/block/zram/zram_drv.h
@@ -78,7 +78,6 @@ struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
-	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic64_t same_pages;		/* no. of same element filled pages */
 	atomic64_t huge_pages;		/* no. of huge pages */
_

Patches currently in -mm which might be from hch@lst.de are

zram-remove-valid_io_request.patch
zram-make-zram_bio_discard-more-self-contained.patch
zram-simplify-bvec-iteration-in-__zram_make_request.patch
zram-move-discard-handling-to-zram_submit_bio.patch
zram-return-early-on-error-in-zram_bvec_rw.patch
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

