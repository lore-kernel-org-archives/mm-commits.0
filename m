Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E9FC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbjHKXGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjHKXEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B9F468A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4FCD666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7AAC433C7;
        Fri, 11 Aug 2023 23:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794954;
        bh=FsObrkG1hnxjvOlV7/gQ8O6R3EEPdsvGuSQCJ3OLQ3c=;
        h=Date:To:From:Subject:From;
        b=N+HexPpfq+qM5ul5S0T34sn/hg4AVPOvbkt1qW74xTUUpIkuXjXrF7Wr25SWy55eP
         k4QFDBBX34zbEeb4/z8FOcEDrhGcdYLVqhWcJ8EED3EUKDKREjdgZ3qRhfn9E6DlXb
         NbA4mcWAzoRGM9NyaCx0MiFNkHE3k0VCrGEcmA0g=
Date:   Fri, 11 Aug 2023 16:02:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch removed from -mm tree
Message-Id: <20230811230234.1B7AAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: convert count_swpout_vm_event() to take in a folio
has been removed from the -mm tree.  Its filename was
     mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: convert count_swpout_vm_event() to take in a folio
Date: Fri, 21 Jul 2023 11:44:50 +0800

Convert count_swpout_vm_event() to take in a folio. We can remove five
implicit calls to compound_head() by taking in a folio.

Link: https://lkml.kernel.org/r/20230721034451.16412-10-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_io.c~mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio
+++ a/mm/page_io.c
@@ -205,13 +205,13 @@ int swap_writepage(struct page *page, st
 	return 0;
 }
 
-static inline void count_swpout_vm_event(struct page *page)
+static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(PageTransHuge(page)))
+	if (unlikely(folio_test_pmd_mappable(folio)))
 		count_vm_event(THP_SWPOUT);
 #endif
-	count_vm_events(PSWPOUT, thp_nr_pages(page));
+	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
@@ -280,7 +280,7 @@ static void sio_write_complete(struct ki
 		}
 	} else {
 		for (p = 0; p < sio->pages; p++)
-			count_swpout_vm_event(sio->bvec[p].bv_page);
+			count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	}
 
 	for (p = 0; p < sio->pages; p++)
@@ -339,7 +339,7 @@ static void swap_writepage_bdev_sync(str
 	__bio_add_page(&bio, page, thp_size(page), 0);
 
 	bio_associate_blkg_from_page(&bio, page);
-	count_swpout_vm_event(page);
+	count_swpout_vm_event(folio);
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
@@ -362,7 +362,7 @@ static void swap_writepage_bdev_async(st
 	__bio_add_page(bio, page, thp_size(page), 0);
 
 	bio_associate_blkg_from_page(bio, page);
-	count_swpout_vm_event(page);
+	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	submit_bio(bio);
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

