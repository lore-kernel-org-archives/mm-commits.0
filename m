Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90530C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiLAAAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiLAAA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F4487CA0
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DEA0B81D83
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E438BC433D6;
        Thu,  1 Dec 2022 00:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852825;
        bh=mgaraosODtbvlfLMFtAz+lsT2zLkNVrGdeapM2XEPd8=;
        h=Date:To:From:Subject:From;
        b=Rv48FJ+79uKC8zJ97tbnf5pAW4WVGkrjy2DeHqrn73q0VLZfXUvr0GXlQupe4+yXd
         Mam/usWyMMug27AfO6rMNKezF6ZxoM2K/yizbqBMh0yVOOpQT7jZgOzf6KheruGqzq
         fC6hFJmNEtm8t+fZRTe4GwQe9UE/4p0chTd3GXX4=
Date:   Wed, 30 Nov 2022 16:00:24 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch removed from -mm tree
Message-Id: <20221201000024.E438BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_from_page() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_from_page() to folios
Date: Tue, 1 Nov 2022 15:30:52 -0700

Introduce folios in __remove_hugetlb_page() by converting
hugetlb_cgroup_from_page() to use folios.

Also gets rid of unsed hugetlb_cgroup_from_page_resv() function.

Link: https://lkml.kernel.org/r/20221101223059.460937-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   39 +++++++++++++++----------------
 mm/hugetlb.c                   |    5 ++-
 mm/hugetlb_cgroup.c            |   13 ++++++----
 3 files changed, 31 insertions(+), 26 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios
+++ a/include/linux/hugetlb_cgroup.h
@@ -67,27 +67,34 @@ struct hugetlb_cgroup {
 };
 
 static inline struct hugetlb_cgroup *
-__hugetlb_cgroup_from_page(struct page *page, bool rsvd)
+__hugetlb_cgroup_from_folio(struct folio *folio, bool rsvd)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	struct page *tail;
 
-	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	if (folio_order(folio) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
-	if (rsvd)
-		return (void *)page_private(page + SUBPAGE_INDEX_CGROUP_RSVD);
-	else
-		return (void *)page_private(page + SUBPAGE_INDEX_CGROUP);
+
+	if (rsvd) {
+		tail = folio_page(folio, SUBPAGE_INDEX_CGROUP_RSVD);
+		return (void *)page_private(tail);
+	}
+
+	else {
+		tail = folio_page(folio, SUBPAGE_INDEX_CGROUP);
+		return (void *)page_private(tail);
+	}
 }
 
-static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_folio(struct folio *folio)
 {
-	return __hugetlb_cgroup_from_page(page, false);
+	return __hugetlb_cgroup_from_folio(folio, false);
 }
 
 static inline struct hugetlb_cgroup *
-hugetlb_cgroup_from_page_rsvd(struct page *page)
+hugetlb_cgroup_from_folio_rsvd(struct folio *folio)
 {
-	return __hugetlb_cgroup_from_page(page, true);
+	return __hugetlb_cgroup_from_folio(folio, true);
 }
 
 static inline void __set_hugetlb_cgroup(struct folio *folio,
@@ -181,19 +188,13 @@ static inline void hugetlb_cgroup_unchar
 {
 }
 
-static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
-{
-	return NULL;
-}
-
-static inline struct hugetlb_cgroup *
-hugetlb_cgroup_from_page_resv(struct page *page)
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_folio(struct folio *folio)
 {
 	return NULL;
 }
 
 static inline struct hugetlb_cgroup *
-hugetlb_cgroup_from_page_rsvd(struct page *page)
+hugetlb_cgroup_from_folio_rsvd(struct folio *folio)
 {
 	return NULL;
 }
--- a/mm/hugetlb.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios
+++ a/mm/hugetlb.c
@@ -1446,9 +1446,10 @@ static void __remove_hugetlb_page(struct
 							bool demote)
 {
 	int nid = page_to_nid(page);
+	struct folio *folio = page_folio(page);
 
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page_rsvd(page), page);
+	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio(folio), folio);
+	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -191,8 +191,9 @@ static void hugetlb_cgroup_move_parent(i
 	struct page_counter *counter;
 	struct hugetlb_cgroup *page_hcg;
 	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(h_cg);
+	struct folio *folio = page_folio(page);
 
-	page_hcg = hugetlb_cgroup_from_page(page);
+	page_hcg = hugetlb_cgroup_from_folio(folio);
 	/*
 	 * We can have pages in active list without any cgroup
 	 * ie, hugepage with less than 3 pages. We can safely
@@ -349,14 +350,15 @@ static void __hugetlb_cgroup_uncharge_pa
 					   struct page *page, bool rsvd)
 {
 	struct hugetlb_cgroup *h_cg;
+	struct folio *folio = page_folio(page);
 
 	if (hugetlb_cgroup_disabled())
 		return;
 	lockdep_assert_held(&hugetlb_lock);
-	h_cg = __hugetlb_cgroup_from_page(page, rsvd);
+	h_cg = __hugetlb_cgroup_from_folio(folio, rsvd);
 	if (unlikely(!h_cg))
 		return;
-	__set_hugetlb_cgroup(page_folio(page), NULL, rsvd);
+	__set_hugetlb_cgroup(folio, NULL, rsvd);
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
@@ -888,13 +890,14 @@ void hugetlb_cgroup_migrate(struct page
 	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
 	struct hstate *h = page_hstate(oldhpage);
+	struct folio *old_folio = page_folio(oldhpage);
 
 	if (hugetlb_cgroup_disabled())
 		return;
 
 	spin_lock_irq(&hugetlb_lock);
-	h_cg = hugetlb_cgroup_from_page(oldhpage);
-	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
+	h_cg = hugetlb_cgroup_from_folio(old_folio);
+	h_cg_rsvd = hugetlb_cgroup_from_folio_rsvd(old_folio);
 	set_hugetlb_cgroup(oldhpage, NULL);
 	set_hugetlb_cgroup_rsvd(oldhpage, NULL);
 
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

