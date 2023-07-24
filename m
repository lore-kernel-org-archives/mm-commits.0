Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7450AC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjGXRns (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjGXRnm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637F410F9
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB59F61316
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA79FC433C7;
        Mon, 24 Jul 2023 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220619;
        bh=AFGUFIJXA3e5foCrHtvUS4yK7dLgh8DPSh2O2Le/ptk=;
        h=Date:To:From:Subject:From;
        b=ne8eQif8nxOf/dKCTmqVBhp2PixTwfxxHVeDJ0Tx52qESt1QlWOexehtjC37F+qDy
         sAQiIwMBfeoYx5K7OyKdIc7PcafiIYY17Xzw1db4VFV+wq+Hrd0OdYD5VM8nwkbHBk
         tSTyPzdyJLL4l6LYf+CQbvv5lh07xyQm+dlwVmq8=
Date:   Mon, 24 Jul 2023 10:43:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-remove-unneeded-setpageerror.patch added to mm-unstable branch
Message-Id: <20230724174339.DA79FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: remove unneeded SetPageError()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-remove-unneeded-setpageerror.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-remove-unneeded-setpageerror.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: remove unneeded SetPageError()
Date: Fri, 21 Jul 2023 11:44:43 +0800

Nobody checks the PageError()/folio_test_error() for the page/folio in
__end_swap_bio_read/write() and sio_write_complete(). Therefore, we
don't need to set the error flag. Just drop it.

Link: https://lkml.kernel.org/r/20230721034451.16412-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/page_io.c~mm-page_io-remove-unneeded-setpageerror
+++ a/mm/page_io.c
@@ -32,7 +32,6 @@ static void __end_swap_bio_write(struct
 	struct page *page = bio_first_page_all(bio);
 
 	if (bio->bi_status) {
-		SetPageError(page);
 		/*
 		 * We failed to write the page out to swap-space.
 		 * Re-dirty the page in order to avoid it being reclaimed.
@@ -61,7 +60,6 @@ static void __end_swap_bio_read(struct b
 	struct page *page = bio_first_page_all(bio);
 
 	if (bio->bi_status) {
-		SetPageError(page);
 		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
 				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
 				     (unsigned long long)bio->bi_iter.bi_sector);
@@ -415,7 +413,6 @@ static void sio_read_complete(struct kio
 		for (p = 0; p < sio->pages; p++) {
 			struct page *page = sio->bvec[p].bv_page;
 
-			SetPageError(page);
 			unlock_page(page);
 		}
 		pr_alert_ratelimited("Read-error on swap-device\n");
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch

