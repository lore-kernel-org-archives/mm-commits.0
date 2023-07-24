Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D80C04A6A
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjGXRnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjGXRnr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91B1713
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88F1961323
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96AEC433C7;
        Mon, 24 Jul 2023 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220623;
        bh=knDEedU32EdkFhcae3iu7kuiivv4MgLzm/r/AS8MBSY=;
        h=Date:To:From:Subject:From;
        b=m46ypRgee33douOuyijvu6vM2+uWFNtyEnDIUPSzBDNr3A796r1nLomOe8cVfoXdf
         5IYICgbOdKW2HgtcliUsJQVaenS12Y3PQKpk5l0gdLIrq5eqtfj4Ux9lw8urD8y6aP
         ZqachT47QylFhIVRCdyTFv5wipe7nyKtSNYvdiwo=
Date:   Mon, 24 Jul 2023 10:43:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-use-a-folio-in-__end_swap_bio_write.patch added to mm-unstable branch
Message-Id: <20230724174343.B96AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: use a folio in __end_swap_bio_write()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-use-a-folio-in-__end_swap_bio_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-use-a-folio-in-__end_swap_bio_write.patch

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
Subject: mm/page_io: use a folio in __end_swap_bio_write()
Date: Fri, 21 Jul 2023 11:44:45 +0800

Saves two implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230721034451.16412-5-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-a-folio-in-__end_swap_bio_write
+++ a/mm/page_io.c
@@ -29,7 +29,7 @@
 
 static void __end_swap_bio_write(struct bio *bio)
 {
-	struct page *page = bio_first_page_all(bio);
+	struct folio *folio = bio_first_folio_all(bio);
 
 	if (bio->bi_status) {
 		/*
@@ -40,13 +40,13 @@ static void __end_swap_bio_write(struct
 		 *
 		 * Also clear PG_reclaim to avoid folio_rotate_reclaimable()
 		 */
-		set_page_dirty(page);
+		folio_mark_dirty(folio);
 		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
 				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
 				     (unsigned long long)bio->bi_iter.bi_sector);
-		ClearPageReclaim(page);
+		folio_clear_reclaim(folio);
 	}
-	end_page_writeback(page);
+	folio_end_writeback(folio);
 }
 
 static void end_swap_bio_write(struct bio *bio)
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

