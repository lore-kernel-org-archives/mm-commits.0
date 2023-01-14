Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B58FC6379F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjANDx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F1060DC
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 563FF623B3
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D41C433F0;
        Sat, 14 Jan 2023 03:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668392;
        bh=AbwUK9KDRsQpdlqmmqrhW+fXOelecKVMYPDx0CiqmwQ=;
        h=Date:To:From:Subject:From;
        b=froL6sKuP6xEL1byDqL+DmXjBHDqjJ+iGBhNRD3P4Cm9iq4K1xokRIMyL+iKL3LSX
         EYQ/K/V8VfgD+/XNLQ5okOY5T/WOKDTsvExLzANbrJjHkkRK7skFDSJ9UOG0UWSueh
         QD06HWjUR7BmWUuLQkuoVtq0qkC2IJLRvgAxPU8Q=
Date:   Fri, 13 Jan 2023 19:53:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-demote_free_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035312.A8D41C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert demote_free_huge_page to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-demote_free_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-demote_free_huge_page-to-folios.patch

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
Subject: mm/hugetlb: convert demote_free_huge_page to folios
Date: Fri, 13 Jan 2023 16:30:57 -0600

Change demote_free_huge_page to demote_free_hugetlb_folio() and change
demote_pool_huge_page() pass in a folio.

Link: https://lkml.kernel.org/r/20230113223057.173292-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-demote_free_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -3579,12 +3579,12 @@ out:
 	return 0;
 }
 
-static int demote_free_huge_page(struct hstate *h, struct page *page)
+static int demote_free_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
-	int i, nid = page_to_nid(page);
+	int i, nid = folio_nid(folio);
 	struct hstate *target_hstate;
-	struct folio *folio = page_folio(page);
 	struct page *subpage;
+	struct folio *inner_folio;
 	int rc = 0;
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
@@ -3592,18 +3592,18 @@ static int demote_free_huge_page(struct
 	remove_hugetlb_folio_for_demote(h, folio, false);
 	spin_unlock_irq(&hugetlb_lock);
 
-	rc = hugetlb_vmemmap_restore(h, page);
+	rc = hugetlb_vmemmap_restore(h, &folio->page);
 	if (rc) {
-		/* Allocation of vmemmmap failed, we can not demote page */
+		/* Allocation of vmemmmap failed, we can not demote folio */
 		spin_lock_irq(&hugetlb_lock);
-		set_page_refcounted(page);
-		add_hugetlb_folio(h, page_folio(page), false);
+		folio_ref_unfreeze(folio, 1);
+		add_hugetlb_folio(h, folio, false);
 		return rc;
 	}
 
 	/*
 	 * Use destroy_compound_hugetlb_folio_for_demote for all huge page
-	 * sizes as it will not ref count pages.
+	 * sizes as it will not ref count folios.
 	 */
 	destroy_compound_hugetlb_folio_for_demote(folio, huge_page_order(h));
 
@@ -3618,15 +3618,15 @@ static int demote_free_huge_page(struct
 	mutex_lock(&target_hstate->resize_lock);
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
-		subpage = nth_page(page, i);
-		folio = page_folio(subpage);
+		subpage = folio_page(folio, i);
+		inner_folio = page_folio(subpage);
 		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_folio_for_demote(folio,
+			prep_compound_gigantic_folio_for_demote(inner_folio,
 							target_hstate->order);
 		else
 			prep_compound_page(subpage, target_hstate->order);
-		set_page_private(subpage, 0);
-		prep_new_hugetlb_folio(target_hstate, folio, nid);
+		folio_change_private(inner_folio, NULL);
+		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
 		free_huge_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
@@ -3648,7 +3648,7 @@ static int demote_pool_huge_page(struct
 	__must_hold(&hugetlb_lock)
 {
 	int nr_nodes, node;
-	struct page *page;
+	struct folio *folio;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -3659,11 +3659,10 @@ static int demote_pool_huge_page(struct
 	}
 
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
-			if (PageHWPoison(page))
+		list_for_each_entry(folio, &h->hugepage_freelists[node], lru) {
+			if (folio_test_hwpoison(folio))
 				continue;
-
-			return demote_free_huge_page(h, page);
+			return demote_free_hugetlb_folio(h, folio);
 		}
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch

