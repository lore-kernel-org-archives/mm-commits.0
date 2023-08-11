Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41FAC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbjHKXN7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbjHKXN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B111344B7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93709666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA55EC433C8;
        Fri, 11 Aug 2023 23:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794947;
        bh=az7AHjF+r977zwax2WuKO28ksbo8O1nQNCGxA2T1/MA=;
        h=Date:To:From:Subject:From;
        b=mjIIQzm8bOZK36Jnu5HhIObItO4RuA/PsTPYBuqLjtBghG/6SmkD0s5KG33EKUuzA
         hLKfbQIzEkjHtifzzlINcjQE98AM9MDAHpVOmPEkjeAfnYfylFUX7tlEjvie2APBUE
         /EUXJap7vlVMJTROSLYQl3l+1H6ZDEjx2A1ict4g=
Date:   Fri, 11 Aug 2023 16:02:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-remove-unneeded-setpageerror.patch removed from -mm tree
Message-Id: <20230811230226.EA55EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: remove unneeded SetPageError()
has been removed from the -mm tree.  Its filename was
     mm-page_io-remove-unneeded-setpageerror.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

