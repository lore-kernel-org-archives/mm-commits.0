Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C62C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjGXRnl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjGXRnk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:43:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A601E8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC4326129D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8E1C433C7;
        Mon, 24 Jul 2023 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220618;
        bh=cZP/E9cFMjB5hYNJ5OisHuKFsr1a8pjARupLsXdj/34=;
        h=Date:To:From:Subject:From;
        b=h9RS436Lvz1tjalpocW7llKwah5+X4cmMbmNY+bhfbYRv7xLK021il8J2Vs/+p1kc
         moqzGZgKp8B4+HjRFWNZ/4O0sVB0b9fFAMrMgLgJ0rTQisEZ8ENOcSQJuHou0bzioG
         IU8Q3d381eIevfsl8APzIkUtjmoNJ5OwRUMdfrhU=
Date:   Mon, 24 Jul 2023 10:43:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-remove-unneeded-clearpageuptodate.patch added to mm-unstable branch
Message-Id: <20230724174338.0F8E1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: remove unneeded ClearPageUptodate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-remove-unneeded-clearpageuptodate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-remove-unneeded-clearpageuptodate.patch

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
Subject: mm/page_io: remove unneeded ClearPageUptodate()
Date: Fri, 21 Jul 2023 11:44:42 +0800

Patch series "Convert several functions in page_io.c to use a folio", v4.

Convert several functions in page_io.c to use a folio, which can remove
several implicit calls to compound_head().


This patch (of 10):

The VM_BUG_ON_FOLIO in swap_readpage() ensures that the page is already
!uptodate in __end_swap_bio_read() and sio_read_complete().  Just remove
unneeded ClearPageUptodate().

Link: https://lkml.kernel.org/r/20230721034451.16412-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230721034451.16412-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-remove-unneeded-clearpageuptodate
+++ a/mm/page_io.c
@@ -62,7 +62,6 @@ static void __end_swap_bio_read(struct b
 
 	if (bio->bi_status) {
 		SetPageError(page);
-		ClearPageUptodate(page);
 		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
 				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
 				     (unsigned long long)bio->bi_iter.bi_sector);
@@ -417,7 +416,6 @@ static void sio_read_complete(struct kio
 			struct page *page = sio->bvec[p].bv_page;
 
 			SetPageError(page);
-			ClearPageUptodate(page);
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

