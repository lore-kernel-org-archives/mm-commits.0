Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F50C04A94
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjGXRnw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjGXRns (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:43:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC18C171C
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B3961320
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8438CC433CD;
        Mon, 24 Jul 2023 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220625;
        bh=kLx71Vb+lX4VrGaQH+QWkEOWbG7FPFcBqWLRhtzxsWA=;
        h=Date:To:From:Subject:From;
        b=pmbh/NcNaeMBrXVNOgTK2p88r67mmUmj3h3JSUM5dDrjejt13XHdUKXxrzLB8w7lO
         99vagWPgZ+s55ppA+SOOhkylM+z5nuLT1InMeNi6WzJ76WCpVS735OAoXGhXA/qzr1
         f+ZHKj0g52AsmEQF9YajzTEBMugzemHa4qM5Beqw=
Date:   Mon, 24 Jul 2023 10:43:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-use-a-folio-in-__end_swap_bio_read.patch added to mm-unstable branch
Message-Id: <20230724174345.8438CC433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: use a folio in __end_swap_bio_read()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-use-a-folio-in-__end_swap_bio_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-use-a-folio-in-__end_swap_bio_read.patch

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
Subject: mm/page_io: use a folio in __end_swap_bio_read()
Date: Fri, 21 Jul 2023 11:44:46 +0800

Saves one implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230721034451.16412-6-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-a-folio-in-__end_swap_bio_read
+++ a/mm/page_io.c
@@ -57,16 +57,16 @@ static void end_swap_bio_write(struct bi
 
 static void __end_swap_bio_read(struct bio *bio)
 {
-	struct page *page = bio_first_page_all(bio);
+	struct folio *folio = bio_first_folio_all(bio);
 
 	if (bio->bi_status) {
 		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
 				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
 				     (unsigned long long)bio->bi_iter.bi_sector);
 	} else {
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 	}
-	unlock_page(page);
+	folio_unlock(folio);
 }
 
 static void end_swap_bio_read(struct bio *bio)
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

