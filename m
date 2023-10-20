Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67783C0032E
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 23:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjJTXul (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 19:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjJTXuk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 19:50:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56E6D51
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 16:50:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7379CC433C7;
        Fri, 20 Oct 2023 23:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697845835;
        bh=EzQ9svJ0wTbcD/ruWaTE6sHjwzwlK7bUqx+hdBx1q0o=;
        h=Date:To:From:Subject:From;
        b=HiEP6UggQDRcPg+VKGPdTT9ncu8aQg0bJbJbS9lUwblH19NVf8A6lE0XcgWXpCnEy
         U65uFvXZNcpWE+Xp46XCRp+Jl88r4ASGdeVd1r6X0f/3ADjefZnZ4SCoG3EA6uWs/S
         EkB24MIxhrDvAiEYk80YF7YhAr57u5GBhTHMs++M=
Date:   Fri, 20 Oct 2023 16:50:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, shy828301@gmail.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch added to mm-unstable branch
Message-Id: <20231020235035.7379CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: convert __collapse_huge_page_isolate() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/khugepaged: convert __collapse_huge_page_isolate() to use folios
Date: Fri, 20 Oct 2023 11:33:27 -0700

Patch series "Some khugepaged folio conversions", v3.

This patchset converts a number of functions to use folios.  This cleans
up some khugepaged code and removes a large number of hidden
compound_head() calls.


This patch (of 5):

Replaces 11 calls to compound_head() with 1, and removes 1348 bytes of
kernel text.

Link: https://lkml.kernel.org/r/20231020183331.10770-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20231020183331.10770-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios
+++ a/mm/khugepaged.c
@@ -542,6 +542,7 @@ static int __collapse_huge_page_isolate(
 					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
+	struct folio *folio = NULL;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 	bool writable = false;
@@ -576,7 +577,8 @@ static int __collapse_huge_page_isolate(
 			goto out;
 		}
 
-		VM_BUG_ON_PAGE(!PageAnon(page), page);
+		folio = page_folio(page);
+		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		if (page_mapcount(page) > 1) {
 			++shared;
@@ -588,16 +590,15 @@ static int __collapse_huge_page_isolate(
 			}
 		}
 
-		if (PageCompound(page)) {
-			struct page *p;
-			page = compound_head(page);
+		if (folio_test_large(folio)) {
+			struct folio *f;
 
 			/*
 			 * Check if we have dealt with the compound page
 			 * already
 			 */
-			list_for_each_entry(p, compound_pagelist, lru) {
-				if (page == p)
+			list_for_each_entry(f, compound_pagelist, lru) {
+				if (folio == f)
 					goto next;
 			}
 		}
@@ -608,7 +609,7 @@ static int __collapse_huge_page_isolate(
 		 * is needed to serialize against split_huge_page
 		 * when invoked from the VM.
 		 */
-		if (!trylock_page(page)) {
+		if (!folio_trylock(folio)) {
 			result = SCAN_PAGE_LOCK;
 			goto out;
 		}
@@ -624,8 +625,8 @@ static int __collapse_huge_page_isolate(
 		 * but not from this process. The other process cannot write to
 		 * the page, only trigger CoW.
 		 */
-		if (!is_refcount_suitable(page)) {
-			unlock_page(page);
+		if (!is_refcount_suitable(&folio->page)) {
+			folio_unlock(folio);
 			result = SCAN_PAGE_COUNT;
 			goto out;
 		}
@@ -634,27 +635,27 @@ static int __collapse_huge_page_isolate(
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
 		 */
-		if (!isolate_lru_page(page)) {
-			unlock_page(page);
+		if (!folio_isolate_lru(folio)) {
+			folio_unlock(folio);
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
 		}
-		mod_node_page_state(page_pgdat(page),
-				NR_ISOLATED_ANON + page_is_file_lru(page),
-				compound_nr(page));
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		VM_BUG_ON_PAGE(PageLRU(page), page);
+		node_stat_mod_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio),
+				folio_nr_pages(folio));
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-		if (PageCompound(page))
-			list_add_tail(&page->lru, compound_pagelist);
+		if (folio_test_large(folio))
+			list_add_tail(&folio->lru, compound_pagelist);
 next:
 		/*
 		 * If collapse was initiated by khugepaged, check that there is
 		 * enough young pte to justify collapsing the page
 		 */
 		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || page_is_young(page) ||
-		     PageReferenced(page) || mmu_notifier_test_young(vma->vm_mm,
+		    (pte_young(pteval) || folio_test_young(folio) ||
+		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
 								     address)))
 			referenced++;
 
@@ -668,13 +669,13 @@ next:
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(page, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(&folio->page, none_or_zero,
 						    referenced, writable, result);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(page, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(&folio->page, none_or_zero,
 					    referenced, writable, result);
 	return result;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch
mm-khugepaged-convert-hpage_collapse_scan_pmd-to-use-folios.patch
mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch
mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch

