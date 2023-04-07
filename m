Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21F8C6FD1D
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 22:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDGWR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Apr 2023 18:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjDGWR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2023 18:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F9F93C8
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 15:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 935FE612B3
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 22:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8045C433D2;
        Fri,  7 Apr 2023 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680905875;
        bh=1U9NcimeywXwWrJHJRvp7kLZzqBM2Mso74N9lDSfnfg=;
        h=Date:To:From:Subject:From;
        b=B+ves9g0u136D3NOEp2AQ1EjupiESEe+0qvCA1+ECucMFfqBZNeeszxNSMRMk+NKV
         MC5vEBAkKEvwlTfatcwpxmYPt0qhJXAnkacHaLP43/nv2eFU6uLcVw5xXRMkVcyjkE
         EGGEgDr2M9gmMRLQRgu6anlO7+R1kMpU95crClDY=
Date:   Fri, 07 Apr 2023 15:17:54 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-synchronous-reads-fix.patch added to mm-unstable branch
Message-Id: <20230407221754.E8045C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-fix-synchronous-reads-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fix-synchronous-reads-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-synchronous-reads-fix.patch

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
Subject: zram-fix-synchronous-reads-fix
Date: Fri, 7 Apr 2023 09:22:24 +0200

turns out this doesn't even compile for PAGE_SIZE > 4096.

Below is the fix, which also removes the #if and instead relies
on compiler dead code elimination.  I wonder if zram should (maybe
optionally) also offer a 512 byte block size, so that we could
also test the smaller than page size I/O path even on x86.

Link: https://lkml.kernel.org/r/20230407072224.GA8982@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-synchronous-reads-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -764,7 +764,6 @@ release_init_lock:
 	return ret;
 }
 
-#if PAGE_SIZE != 4096
 struct zram_work {
 	struct work_struct work;
 	struct zram *zram;
@@ -775,7 +774,7 @@ struct zram_work {
 static void zram_sync_read(struct work_struct *work)
 {
 	struct zram_work *zw = container_of(work, struct zram_work, work);
-	struct bio_bvec bv;
+	struct bio_vec bv;
 	struct bio bio;
 
 	bio_init(&bio, zw->zram->bdev, &bv, 1, REQ_OP_READ);
@@ -794,6 +793,9 @@ static int read_from_bdev_sync(struct zr
 {
 	struct zram_work work;
 
+	if (WARN_ON_ONCE(PAGE_SIZE != 4096))
+		return -EIO;
+
 	work.page = page;
 	work.zram = zram;
 	work.entry = entry;
@@ -805,14 +807,6 @@ static int read_from_bdev_sync(struct zr
 
 	return 1;
 }
-#else
-static int read_from_bdev_sync(struct zram *zram, struct page *page,
-				unsigned long entry)
-{
-	WARN_ON(1);
-	return -EIO;
-}
-#endif
 
 static int read_from_bdev(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent)
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
zram-fix-synchronous-reads-fix.patch
zram-return-errors-from-read_from_bdev_sync.patch

