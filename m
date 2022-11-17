Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AF7C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiKQVZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbiKQVZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21CD15837
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:23:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3381C61E76
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE00C433C1;
        Thu, 17 Nov 2022 21:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720228;
        bh=W4b3S1wp/9lAoAC3/2Vk2L5T8GSExgfQLRhIlEQzwcc=;
        h=Date:To:From:Subject:From;
        b=ZYByyuRlq0W7+1TQt8tIpbbTvpFvv0nCPmmuj1Bwv3qsfo52u8cKGUjAcz6He7J9j
         mtPs5bQTbgfOFMT2Y1iAaOfIK/KSmME2ShNMu6AbSApQSZ0R334T13TFvL6rLSIuKV
         +e9YZv2lsfd42Js8WUJt97xU+v/dk6LtHXW/ayMk=
Date:   Thu, 17 Nov 2022 13:23:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212348.8DE00C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert destroy_compound_gigantic_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert destroy_compound_gigantic_page() to folios
Date: Thu, 17 Nov 2022 13:14:53 -0800

Convert page operations within __destroy_compound_gigantic_page() to the
corresponding folio operations.

Link: https://lkml.kernel.org/r/20221117211501.17150-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios
+++ a/mm/hugetlb.c
@@ -1325,43 +1325,40 @@ static int hstate_next_node_to_free(stru
 		nr_nodes--)
 
 /* used to demote non-gigantic_huge pages as well */
-static void __destroy_compound_gigantic_page(struct page *page,
+static void __destroy_compound_gigantic_folio(struct folio *folio,
 					unsigned int order, bool demote)
 {
 	int i;
 	int nr_pages = 1 << order;
 	struct page *p;
 
-	atomic_set(compound_mapcount_ptr(page), 0);
-	atomic_set(subpages_mapcount_ptr(page), 0);
-	atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(folio_mapcount_ptr(folio), 0);
+	atomic_set(folio_subpages_mapcount_ptr(folio), 0);
+	atomic_set(folio_pincount_ptr(folio), 0);
 
 	for (i = 1; i < nr_pages; i++) {
-		p = nth_page(page, i);
+		p = folio_page(folio, i);
 		p->mapping = NULL;
 		clear_compound_head(p);
 		if (!demote)
 			set_page_refcounted(p);
 	}
 
-	set_compound_order(page, 0);
-#ifdef CONFIG_64BIT
-	page[1].compound_nr = 0;
-#endif
-	__ClearPageHead(page);
+	folio_set_compound_order(folio, 0);
+	folio_clear_head(folio);
 }
 
-static void destroy_compound_hugetlb_page_for_demote(struct page *page,
+static void destroy_compound_hugetlb_folio_for_demote(struct folio *folio,
 					unsigned int order)
 {
-	__destroy_compound_gigantic_page(page, order, true);
+	__destroy_compound_gigantic_folio(folio, order, true);
 }
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-static void destroy_compound_gigantic_page(struct page *page,
+static void destroy_compound_gigantic_folio(struct folio *folio,
 					unsigned int order)
 {
-	__destroy_compound_gigantic_page(page, order, false);
+	__destroy_compound_gigantic_folio(folio, order, false);
 }
 
 static void free_gigantic_page(struct page *page, unsigned int order)
@@ -1430,7 +1427,7 @@ static struct page *alloc_gigantic_page(
 	return NULL;
 }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
-static inline void destroy_compound_gigantic_page(struct page *page,
+static inline void destroy_compound_gigantic_folio(struct folio *folio,
 						unsigned int order) { }
 #endif
 
@@ -1477,8 +1474,8 @@ static void __remove_hugetlb_page(struct
 	 *
 	 * For gigantic pages set the destructor to the null dtor.  This
 	 * destructor will never be called.  Before freeing the gigantic
-	 * page destroy_compound_gigantic_page will turn the compound page
-	 * into a simple group of pages.  After this the destructor does not
+	 * page destroy_compound_gigantic_folio will turn the folio into a
+	 * simple group of pages.  After this the destructor does not
 	 * apply.
 	 *
 	 * This handles the case where more than one ref is held when and
@@ -1559,6 +1556,7 @@ static void add_hugetlb_page(struct hsta
 static void __update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	struct folio *folio = page_folio(page);
 	struct page *subpage;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
@@ -1587,8 +1585,8 @@ static void __update_and_free_page(struc
 	 * Move PageHWPoison flag from head page to the raw error pages,
 	 * which makes any healthy subpages reusable.
 	 */
-	if (unlikely(PageHWPoison(page)))
-		hugetlb_clear_page_hwpoison(page);
+	if (unlikely(folio_test_hwpoison(folio)))
+		hugetlb_clear_page_hwpoison(&folio->page);
 
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		subpage = nth_page(page, i);
@@ -1604,7 +1602,7 @@ static void __update_and_free_page(struc
 	 */
 	if (hstate_is_gigantic(h) ||
 	    hugetlb_cma_page(page, huge_page_order(h))) {
-		destroy_compound_gigantic_page(page, huge_page_order(h));
+		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
 	} else {
 		__free_pages(page, huge_page_order(h));
@@ -3435,6 +3433,7 @@ static int demote_free_huge_page(struct
 {
 	int i, nid = page_to_nid(page);
 	struct hstate *target_hstate;
+	struct folio *folio = page_folio(page);
 	struct page *subpage;
 	int rc = 0;
 
@@ -3453,10 +3452,10 @@ static int demote_free_huge_page(struct
 	}
 
 	/*
-	 * Use destroy_compound_hugetlb_page_for_demote for all huge page
+	 * Use destroy_compound_hugetlb_folio_for_demote for all huge page
 	 * sizes as it will not ref count pages.
 	 */
-	destroy_compound_hugetlb_page_for_demote(page, huge_page_order(h));
+	destroy_compound_hugetlb_folio_for_demote(folio, huge_page_order(h));
 
 	/*
 	 * Taking target hstate mutex synchronizes with set_max_huge_pages.
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch
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

