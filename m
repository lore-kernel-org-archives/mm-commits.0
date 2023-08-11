Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B717C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbjHKXGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjHKXEN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27D83A9C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94D4165772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC60C433C7;
        Fri, 11 Aug 2023 23:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794946;
        bh=Sko9kwzOkhVw5Ex34UIW1N3JOL7FsCRGWhXzcpxaosQ=;
        h=Date:To:From:Subject:From;
        b=dsYXGGylwFVk4uurcBJU/RNcQ0suDnXKSLkwJyjY7sscRelqFA3aOo2FP6IXQHE5U
         GrEm2iF0f55WBefIOOgVd7PpRvs/6WywjReytLPv9pkCtA6kfXP1XKqsoddmhVPVuS
         1lckSO97wWRTGMnYMkA2KnOV8fNbVzfabaGXKCEk=
Date:   Fri, 11 Aug 2023 16:02:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-remove-unneeded-clearpageuptodate.patch removed from -mm tree
Message-Id: <20230811230225.EBC60C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: remove unneeded ClearPageUptodate()
has been removed from the -mm tree.  Its filename was
     mm-page_io-remove-unneeded-clearpageuptodate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

