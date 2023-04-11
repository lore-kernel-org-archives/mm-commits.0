Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D73DC7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjDKU5j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjDKU5f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5B940E3
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B40E624B0
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8B2C433EF;
        Tue, 11 Apr 2023 20:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246652;
        bh=ymKiuyO2pCnoeTdhiNi/sy4XqS7h6o0DZk+TXlQLcfU=;
        h=Date:To:From:Subject:From;
        b=biPIviCDCq0br1GbbbraWchkiYYvZpw9/hFyXbPN/MqxI4PhpDnajazQCt+5BrqG/
         nHoFmUNpahcAJMzIcBVfrQKZjI7q6NSDAjMpFjfVqdMcT+Wko83772tn3nDE9VbO+J
         Mqe8Vd+bLXTYKFCqj4ljY5vFjwllOY/Qy3pseiDo=
Date:   Tue, 11 Apr 2023 13:57:32 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-return-early-on-error-in-zram_bvec_rw.patch added to mm-unstable branch
Message-Id: <20230411205732.9E8B2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: return early on error in zram_bvec_rw
has been added to the -mm mm-unstable branch.  Its filename is
     zram-return-early-on-error-in-zram_bvec_rw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-return-early-on-error-in-zram_bvec_rw.patch

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
Subject: zram: return early on error in zram_bvec_rw
Date: Tue, 11 Apr 2023 19:14:48 +0200

When the low-level access fails, don't clear the idle flag or clear the
caches, and just return.

Link: https://lkml.kernel.org/r/20230411171459.567614-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

