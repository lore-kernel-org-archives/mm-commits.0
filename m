Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D5AC77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDKU5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjDKU5q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F8940E3
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70314625C3
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3417C433EF;
        Tue, 11 Apr 2023 20:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246657;
        bh=kb3WHuZ5Jhf87R7wNNCB0BcoAGNN358gtDpULR6KUC8=;
        h=Date:To:From:Subject:From;
        b=DSwP4h2FTjLGGdR0fun37pzdw4oGBf0xUCRshXDIq4H1OEVyJFI/lToRKFfnz6L9Z
         WezJxYDtqoqF5s4OeXCQlYvdbunqQoAat8WJa0Xm4594PNWcQo1686115/lFQIAo7/
         DDHaQzfW/kEiTbYwMJwUG9PBMHcv/vaiKqoH5aGU=
Date:   Tue, 11 Apr 2023 13:57:37 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rename-__zram_bvec_read-to-zram_read_page.patch added to mm-unstable branch
Message-Id: <20230411205737.C3417C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rename __zram_bvec_read to zram_read_page
has been added to the -mm mm-unstable branch.  Its filename is
     zram-rename-__zram_bvec_read-to-zram_read_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rename-__zram_bvec_read-to-zram_read_page.patch

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

