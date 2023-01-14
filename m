Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B93C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjANDx0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31966C18
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3120623AF
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E44C433EF;
        Sat, 14 Jan 2023 03:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668380;
        bh=QurRC28dhMVjhGMDa6piakRjxGxGl54QYkqGmdTalCI=;
        h=Date:To:From:Subject:From;
        b=idK33HxUgBduwmVRNqpVhdL1CraSJ2gkDLlemYEq5z5H0Yb0nzQr8d/xqabhJMRYy
         ZyY64J5fPAWhnFG7wUOw5nYbW98+SO3PLva6p9FRW+eqesGYFqiuuFfAb3GUj3dwDI
         H+DXftDYdiyVeJrNQi10sLza3h+60qDoSnmQ8OnQ=
Date:   Fri, 13 Jan 2023 19:52:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-__update_and_free_page-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035300.21E44C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert __update_and_free_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-__update_and_free_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-__update_and_free_page-to-folios.patch

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
Subject: mm/hugetlb: convert __update_and_free_page() to folios
Date: Fri, 13 Jan 2023 16:30:51 -0600

Change __update_and_free_page() to __update_and_free_hugetlb_folio() by
changing its callers to pass in a folio.

Link: https://lkml.kernel.org/r/20230113223057.173292-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-__update_and_free_page-to-folios
+++ a/mm/hugetlb.c
@@ -1698,10 +1698,10 @@ static void add_hugetlb_folio(struct hst
 	enqueue_hugetlb_folio(h, folio);
 }
 
-static void __update_and_free_page(struct hstate *h, struct page *page)
+static void __update_and_free_hugetlb_folio(struct hstate *h,
+						struct folio *folio)
 {
 	int i;
-	struct folio *folio = page_folio(page);
 	struct page *subpage;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
@@ -1714,7 +1714,7 @@ static void __update_and_free_page(struc
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
 
-	if (hugetlb_vmemmap_restore(h, page)) {
+	if (hugetlb_vmemmap_restore(h, &folio->page)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1750,7 +1750,7 @@ static void __update_and_free_page(struc
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
-		__free_pages(page, huge_page_order(h));
+		__free_pages(&folio->page, huge_page_order(h));
 	}
 }
 
@@ -1790,7 +1790,7 @@ static void free_hpage_workfn(struct wor
 		 */
 		h = size_to_hstate(page_size(page));
 
-		__update_and_free_page(h, page);
+		__update_and_free_hugetlb_folio(h, page_folio(page));
 
 		cond_resched();
 	}
@@ -1807,7 +1807,7 @@ static void update_and_free_hugetlb_foli
 				 bool atomic)
 {
 	if (!folio_test_hugetlb_vmemmap_optimized(folio) || !atomic) {
-		__update_and_free_page(h, &folio->page);
+		__update_and_free_hugetlb_folio(h, folio);
 		return;
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

