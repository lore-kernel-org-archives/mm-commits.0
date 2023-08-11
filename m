Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B55C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjHKXGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbjHKXEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3768C4689
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2E13679F8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2126EC433C7;
        Fri, 11 Aug 2023 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794953;
        bh=Lwl4zfjmn0zBe9Cfi4qGaYGYfWmCRg6rdVbectR4As8=;
        h=Date:To:From:Subject:From;
        b=mUZu0YYen5xTEwy/BXvniQm2dOmfnjOvkF3tSacdCAJNUtMqOJk84Mipm10yzSReI
         4SgoyaJ7tUWsx0ZaPSaAuxmXr0DiwkoarWvt3P+BUpHKf1luk7I2b73Flh9+fDpqkA
         ju/mZNUmQIfl6eOIqNcVJlBss2T2fggwyTXFRAHQ=
Date:   Fri, 11 Aug 2023 16:02:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch removed from -mm tree
Message-Id: <20230811230233.2126EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: use a folio in swap_writepage_bdev_async()
has been removed from the -mm tree.  Its filename was
     mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: use a folio in swap_writepage_bdev_async()
Date: Fri, 21 Jul 2023 11:44:49 +0800

Saves one implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230721034451.16412-9-zhangpeng362@huawei.com
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

--- a/mm/page_io.c~mm-page_io-use-a-folio-in-swap_writepage_bdev_async
+++ a/mm/page_io.c
@@ -352,6 +352,7 @@ static void swap_writepage_bdev_async(st
 		struct writeback_control *wbc, struct swap_info_struct *sis)
 {
 	struct bio *bio;
+	struct folio *folio = page_folio(page);
 
 	bio = bio_alloc(sis->bdev, 1,
 			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
@@ -362,8 +363,8 @@ static void swap_writepage_bdev_async(st
 
 	bio_associate_blkg_from_page(bio, page);
 	count_swpout_vm_event(page);
-	set_page_writeback(page);
-	unlock_page(page);
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 	submit_bio(bio);
 }
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

