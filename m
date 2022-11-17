Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA78DC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbiKQVZs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240890AbiKQVZX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E14DF9C
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844316227F
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B0BC433C1;
        Thu, 17 Nov 2022 21:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720241;
        bh=ZrSXMpjCNXUdmu05AzDTXVmCWRf8E9+IKXOdWQJuXfs=;
        h=Date:To:From:Subject:From;
        b=XgaTeY5/2fqs2mhDiGgqg3oakbOcxOi1rDXHNBo9kDXaq/dwUfHVc7HwZT/wF5cGA
         QoWWcyKtZpBbVHYaQ2HgfxBOERxbeLO4An2FTQRqu7z38xvwpxh1BoHvxxF0YUKDdc
         UOKwqW0AI9G0OP4QcvFBn2x6R/rE4iLED1ASijbY=
Date:   Thu, 17 Nov 2022 13:24:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212401.D7B0BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert hugetlb prep functions to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch

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
Subject: mm/hugetlb: convert hugetlb prep functions to folios
Date: Thu, 17 Nov 2022 13:15:00 -0800

Convert prep_new_huge_page() and __prep_compound_gigantic_page() to
folios.

Link: https://lkml.kernel.org/r/20221117211501.17150-10-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   61 +++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb-prep-functions-to-folios
+++ a/mm/hugetlb.c
@@ -1789,28 +1789,26 @@ static void __prep_new_hugetlb_folio(str
 	set_hugetlb_cgroup_rsvd(folio, NULL);
 }
 
-static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
+static void prep_new_hugetlb_folio(struct hstate *h, struct folio *folio, int nid)
 {
-	struct folio *folio = page_folio(page);
-
 	__prep_new_hugetlb_folio(h, folio);
 	spin_lock_irq(&hugetlb_lock);
 	__prep_account_new_huge_page(h, nid);
 	spin_unlock_irq(&hugetlb_lock);
 }
 
-static bool __prep_compound_gigantic_page(struct page *page, unsigned int order,
-								bool demote)
+static bool __prep_compound_gigantic_folio(struct folio *folio,
+					unsigned int order, bool demote)
 {
 	int i, j;
 	int nr_pages = 1 << order;
 	struct page *p;
 
-	/* we rely on prep_new_huge_page to set the destructor */
-	set_compound_order(page, order);
-	__SetPageHead(page);
+	/* we rely on prep_new_hugetlb_folio to set the destructor */
+	folio_set_compound_order(folio, order);
+	__SetPageHead(&folio->page);
 	for (i = 0; i < nr_pages; i++) {
-		p = nth_page(page, i);
+		p = folio_page(folio, i);
 
 		/*
 		 * For gigantic hugepages allocated through bootmem at
@@ -1851,43 +1849,41 @@ static bool __prep_compound_gigantic_pag
 			VM_BUG_ON_PAGE(page_count(p), p);
 		}
 		if (i != 0)
-			set_compound_head(p, page);
+			set_compound_head(p, &folio->page);
 	}
-	atomic_set(compound_mapcount_ptr(page), -1);
-	atomic_set(subpages_mapcount_ptr(page), 0);
-	atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(folio_mapcount_ptr(folio), -1);
+	atomic_set(folio_subpages_mapcount_ptr(folio), 0);
+	atomic_set(folio_pincount_ptr(folio), 0);
 	return true;
 
 out_error:
 	/* undo page modifications made above */
 	for (j = 0; j < i; j++) {
-		p = nth_page(page, j);
+		p = folio_page(folio, j);
 		if (j != 0)
 			clear_compound_head(p);
 		set_page_refcounted(p);
 	}
 	/* need to clear PG_reserved on remaining tail pages  */
 	for (; j < nr_pages; j++) {
-		p = nth_page(page, j);
+		p = folio_page(folio, j);
 		__ClearPageReserved(p);
 	}
-	set_compound_order(page, 0);
-#ifdef CONFIG_64BIT
-	page[1].compound_nr = 0;
-#endif
-	__ClearPageHead(page);
+	folio_set_compound_order(folio, 0);
+	folio_clear_head(folio);
 	return false;
 }
 
-static bool prep_compound_gigantic_page(struct page *page, unsigned int order)
+static bool prep_compound_gigantic_folio(struct folio *folio,
+							unsigned int order)
 {
-	return __prep_compound_gigantic_page(page, order, false);
+	return __prep_compound_gigantic_folio(folio, order, false);
 }
 
-static bool prep_compound_gigantic_page_for_demote(struct page *page,
+static bool prep_compound_gigantic_folio_for_demote(struct folio *folio,
 							unsigned int order)
 {
-	return __prep_compound_gigantic_page(page, order, true);
+	return __prep_compound_gigantic_folio(folio, order, true);
 }
 
 /*
@@ -2039,7 +2035,7 @@ retry:
 		return NULL;
 	folio = page_folio(page);
 	if (hstate_is_gigantic(h)) {
-		if (!prep_compound_gigantic_page(page, huge_page_order(h))) {
+		if (!prep_compound_gigantic_folio(folio, huge_page_order(h))) {
 			/*
 			 * Rare failure to convert pages to compound page.
 			 * Free pages and try again - ONCE!
@@ -2052,7 +2048,7 @@ retry:
 			return NULL;
 		}
 	}
-	prep_new_huge_page(h, page, page_to_nid(page));
+	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
 
 	return page;
 }
@@ -3056,10 +3052,10 @@ static void __init gather_bootmem_preall
 		struct hstate *h = m->hstate;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-		WARN_ON(page_count(page) != 1);
-		if (prep_compound_gigantic_page(page, huge_page_order(h))) {
-			WARN_ON(PageReserved(page));
-			prep_new_huge_page(h, page, page_to_nid(page));
+		WARN_ON(folio_ref_count(folio) != 1);
+		if (prep_compound_gigantic_folio(folio, huge_page_order(h))) {
+			WARN_ON(folio_test_reserved(folio));
+			prep_new_hugetlb_folio(h, folio, folio_nid(folio));
 			free_huge_page(page); /* add to the hugepage allocator */
 		} else {
 			/* VERY unlikely inflated ref count on a tail page */
@@ -3478,13 +3474,14 @@ static int demote_free_huge_page(struct
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
 		subpage = nth_page(page, i);
+		folio = page_folio(subpage);
 		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_page_for_demote(subpage,
+			prep_compound_gigantic_folio_for_demote(folio,
 							target_hstate->order);
 		else
 			prep_compound_page(subpage, target_hstate->order);
 		set_page_private(subpage, 0);
-		prep_new_huge_page(target_hstate, subpage, nid);
+		prep_new_hugetlb_folio(target_hstate, folio, nid);
 		free_huge_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
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

