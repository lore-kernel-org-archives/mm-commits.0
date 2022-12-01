Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FB9C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiLAAA6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiLAAAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387A387CAC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A15DAB81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C3C433D7;
        Thu,  1 Dec 2022 00:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852830;
        bh=m9Jyl8E4U/PE2/ka5Ri3g8wZzJBwymv+w/KUx4F4jFQ=;
        h=Date:To:From:Subject:From;
        b=NjYWGU2kT+Kc5qHWI+/iSCWY/OtcF1H+pKqRvW5tEITd+exfNf1eUReicLuifeson
         Z28PaXE+YaZrpxicxJ3OOrP7eRBXs0lKMykRylHFYoOy8bRKBv0lAK+qXOi01t0U42
         yLgVaeNiXCBbL9snwblRfUf7QMxvUpQvoQClXJvM=
Date:   Wed, 30 Nov 2022 16:00:29 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-free_huge_page-to-folios.patch removed from -mm tree
Message-Id: <20221201000030.491C3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert free_huge_page to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-free_huge_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert free_huge_page to folios
Date: Tue, 1 Nov 2022 15:30:56 -0700

Use folios inside free_huge_page(), this is in preparation for converting
hugetlb_cgroup_uncharge_page() to take in a folio.

Link: https://lkml.kernel.org/r/20221101223059.460937-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-free_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -1704,21 +1704,22 @@ void free_huge_page(struct page *page)
 	 * Can't pass hstate in here because it is called from the
 	 * compound page destructor.
 	 */
-	struct hstate *h = page_hstate(page);
-	int nid = page_to_nid(page);
-	struct hugepage_subpool *spool = hugetlb_page_subpool(page);
+	struct folio *folio = page_folio(page);
+	struct hstate *h = folio_hstate(folio);
+	int nid = folio_nid(folio);
+	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
 	unsigned long flags;
 
-	VM_BUG_ON_PAGE(page_count(page), page);
-	VM_BUG_ON_PAGE(page_mapcount(page), page);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
-	hugetlb_set_page_subpool(page, NULL);
-	if (PageAnon(page))
-		__ClearPageAnonExclusive(page);
-	page->mapping = NULL;
-	restore_reserve = HPageRestoreReserve(page);
-	ClearHPageRestoreReserve(page);
+	hugetlb_set_folio_subpool(folio, NULL);
+	if (folio_test_anon(folio))
+		__ClearPageAnonExclusive(&folio->page);
+	folio->mapping = NULL;
+	restore_reserve = folio_test_hugetlb_restore_reserve(folio);
+	folio_clear_hugetlb_restore_reserve(folio);
 
 	/*
 	 * If HPageRestoreReserve was set on page, page allocation consumed a
@@ -1740,7 +1741,7 @@ void free_huge_page(struct page *page)
 	}
 
 	spin_lock_irqsave(&hugetlb_lock, flags);
-	ClearHPageMigratable(page);
+	folio_clear_hugetlb_migratable(folio);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
@@ -1748,7 +1749,7 @@ void free_huge_page(struct page *page)
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (HPageTemporary(page)) {
+	if (folio_test_hugetlb_temporary(folio)) {
 		remove_hugetlb_page(h, page, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page, true);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-add-folio-dtor-and-order-setter-functions.patch
mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch
mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch
mm-hugetlb-convert-update_and_free_page-to-folios.patch
mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch
mm-hugetlb-convert-enqueue_huge_page-to-folios.patch
mm-hugetlb-convert-free_gigantic_page-to-folios.patch
mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

