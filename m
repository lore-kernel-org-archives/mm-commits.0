Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC07EC41513
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjGXRoC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjGXRnv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:43:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A81E8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF2366132A
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18873C433C8;
        Mon, 24 Jul 2023 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220629;
        bh=vIZTpuXzsWhY7taL7xUA7PRhgsCxsopIfOSQ/rxsF0I=;
        h=Date:To:From:Subject:From;
        b=N7S7MVcMJ3H0S9+DsVt/7q8Z6NjtKXVribWMGOH0KJ+XpciX01MaGCDucJhagDII4
         cavFs+utHHFysn4ILiDMk1XLF/4mHsns51npSOkMed4DszfzZ8mF8LSVEwy+NyKoj/
         JzQggC22dfjlkDLFOOujbVgrfGGdAD8Q6NcTwb+k=
Date:   Mon, 24 Jul 2023 10:43:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch added to mm-unstable branch
Message-Id: <20230724174349.18873C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: use a folio in swap_writepage_bdev_sync()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch

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
Subject: mm/page_io: use a folio in swap_writepage_bdev_sync()
Date: Fri, 21 Jul 2023 11:44:48 +0800

Saves one implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230721034451.16412-8-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-a-folio-in-swap_writepage_bdev_sync
+++ a/mm/page_io.c
@@ -331,6 +331,7 @@ static void swap_writepage_bdev_sync(str
 {
 	struct bio_vec bv;
 	struct bio bio;
+	struct folio *folio = page_folio(page);
 
 	bio_init(&bio, sis->bdev, &bv, 1,
 		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
@@ -340,8 +341,8 @@ static void swap_writepage_bdev_sync(str
 	bio_associate_blkg_from_page(&bio, page);
 	count_swpout_vm_event(page);
 
-	set_page_writeback(page);
-	unlock_page(page);
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 
 	submit_bio_wait(&bio);
 	__end_swap_bio_write(&bio);
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

