Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25910C7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDKU50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDKU50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E809218E
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 828F562658
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF63C433EF;
        Tue, 11 Apr 2023 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246643;
        bh=u4kBB+YX6RY4X9vIqPCz8yOX5CWbL885srcKSPtzB6M=;
        h=Date:To:From:Subject:From;
        b=GcCPPqolJOYmO9dhFCQO1fH40XYEZKVA0K1+CQ/9cbtwkDDNcb+PTyKINCtyFpMuE
         nOx5Mx7U6OTvkxkT+eTCyaC4g4FXS/hj7fxgMgxDAu8XK29IAKOW5nTpgu/pb4l3Sf
         YQfH4s63nUJKukTXa0y1jvfXcTR/H5bV2YDEKKu4=
Date:   Tue, 11 Apr 2023 13:57:23 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-always-compile-read_from_bdev_sync.patch added to mm-unstable branch
Message-Id: <20230411205723.CCF63C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: always compile read_from_bdev_sync
has been added to the -mm mm-unstable branch.  Its filename is
     zram-always-compile-read_from_bdev_sync.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-always-compile-read_from_bdev_sync.patch

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
Subject: zram: always compile read_from_bdev_sync
Date: Tue, 11 Apr 2023 19:14:43 +0200

Patch series "zram I/O path cleanups and fixups", v3.

This series cleans up the zram I/O path, and fixes the handling of
synchronous I/O to the underlying device in the writeback_store function
or for > 4K PAGE_SIZE systems.

The fixes are at the end, as I could not fully reason about them being
safe before untangling the callchain.


This patch (of 17):

read_from_bdev_sync is currently only compiled for non-4k PAGE_SIZE, which
means it won't be built with the most common configurations.

Replace the ifdef with a check for the PAGE_SIZE in an if instead.  The
check uses an extra symbol and IS_ENABLED to allow the compiler to
eliminate the dead code, leading to the same generated code size:

   text	   data	    bss	    dec	    hex	filename
  16709	   1428	     12	  18149	   46e5	drivers/block/zram/zram_drv.o.old
  16709	   1428	     12	  18149	   46e5	drivers/block/zram/zram_drv.o.new

Link: https://lkml.kernel.org/r/20230411171459.567614-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230411171459.567614-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-always-compile-read_from_bdev_sync
+++ a/drivers/block/zram/zram_drv.c
@@ -148,6 +148,7 @@ static inline bool is_partial_io(struct
 {
 	return bvec->bv_len != PAGE_SIZE;
 }
+#define ZRAM_PARTIAL_IO		1
 #else
 static inline bool is_partial_io(struct bio_vec *bvec)
 {
@@ -833,7 +834,6 @@ struct zram_work {
 	struct bio_vec bvec;
 };
 
-#if PAGE_SIZE != 4096
 static void zram_sync_read(struct work_struct *work)
 {
 	struct zram_work *zw = container_of(work, struct zram_work, work);
@@ -866,23 +866,17 @@ static int read_from_bdev_sync(struct zr
 
 	return 1;
 }
-#else
-static int read_from_bdev_sync(struct zram *zram, struct bio_vec *bvec,
-				unsigned long entry, struct bio *bio)
-{
-	WARN_ON(1);
-	return -EIO;
-}
-#endif
 
 static int read_from_bdev(struct zram *zram, struct bio_vec *bvec,
 			unsigned long entry, struct bio *parent, bool sync)
 {
 	atomic64_inc(&zram->stats.bd_reads);
-	if (sync)
+	if (sync) {
+		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
+			return -EIO;
 		return read_from_bdev_sync(zram, bvec, entry, parent);
-	else
-		return read_from_bdev_async(zram, bvec, entry, parent);
+	}
+	return read_from_bdev_async(zram, bvec, entry, parent);
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
_

Patches currently in -mm which might be from hch@lst.de are

zram-always-compile-read_from_bdev_sync.patch
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

