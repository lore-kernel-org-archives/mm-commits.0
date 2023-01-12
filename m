Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76DFC54EBE
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbjALVcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjALVcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E78B395C1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8C7AB81E63
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C5C433F1;
        Thu, 12 Jan 2023 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558193;
        bh=t2OjrGgok0zd4sJYkkZ6iIh8SbS+fzmlFd8TUhLT4aE=;
        h=Date:To:From:Subject:From;
        b=ekEklyN8Lc/oVIawyZcgl3wi/01Txw7y2Ub1+WgbWmmDvYxIAlct3bQA2gkjp0dKw
         p/kxlNQLvFgisnzGYTechX8BVJ7Y4h0eMWpOALB2pISncPILUcTuvB1rjohk1x69Av
         IBcVQe4bVlFeUHOebdQoDeBktXsH90wQHgn+WyB8=
Date:   Thu, 12 Jan 2023 13:16:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211633.750C5C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert free_raw_hwp_pages() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch

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
Subject: mm/memory-failure: convert free_raw_hwp_pages() to folios
Date: Thu, 12 Jan 2023 14:46:04 -0600

Change free_raw_hwp_pages() to folio_free_raw_hwp(), converts two users of
hugetlb specific page macro users to their folio equivalents.

Link: https://lkml.kernel.org/r/20230112204608.80136-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-free_raw_hwp_pages-to-folios
+++ a/mm/memory-failure.c
@@ -1766,23 +1766,23 @@ static int hugetlb_set_page_hwpoison(str
 	return ret;
 }
 
-static unsigned long free_raw_hwp_pages(struct page *hpage, bool move_flag)
+static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
 	/*
-	 * HPageVmemmapOptimized hugepages can't be freed because struct
+	 * hugetlb_vmemmap_optimized hugepages can't be freed because struct
 	 * pages for tail pages are required but they don't exist.
 	 */
-	if (move_flag && HPageVmemmapOptimized(hpage))
+	if (move_flag && folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
 	/*
-	 * HPageRawHwpUnreliable hugepages shouldn't be unpoisoned by
+	 * hugetlb_raw_hwp_unreliable hugepages shouldn't be unpoisoned by
 	 * definition.
 	 */
-	if (HPageRawHwpUnreliable(hpage))
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return 0;
 
-	return __free_raw_hwp_pages(hpage, move_flag);
+	return __free_raw_hwp_pages(&folio->page, move_flag);
 }
 
 void folio_clear_hugetlb_hwpoison(struct folio *folio)
@@ -1790,7 +1790,7 @@ void folio_clear_hugetlb_hwpoison(struct
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
 	folio_clear_hwpoison(folio);
-	free_raw_hwp_pages(&folio->page, true);
+	folio_free_raw_hwp(folio, true);
 }
 
 /*
@@ -1929,7 +1929,7 @@ static inline int try_memory_failure_hug
 	return 0;
 }
 
-static inline unsigned long free_raw_hwp_pages(struct page *hpage, bool flag)
+static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
 {
 	return 0;
 }
@@ -2336,6 +2336,7 @@ core_initcall(memory_failure_init);
 int unpoison_memory(unsigned long pfn)
 {
 	struct page *page;
+	struct folio *folio;
 	struct page *p;
 	int ret = -EBUSY;
 	unsigned long count = 1;
@@ -2348,6 +2349,7 @@ int unpoison_memory(unsigned long pfn)
 
 	p = pfn_to_page(pfn);
 	page = compound_head(p);
+	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
 
@@ -2389,7 +2391,7 @@ int unpoison_memory(unsigned long pfn)
 	if (!ret) {
 		if (PageHuge(p)) {
 			huge = true;
-			count = free_raw_hwp_pages(page, false);
+			count = folio_free_raw_hwp(folio, false);
 			if (count == 0) {
 				ret = -EBUSY;
 				goto unlock_mutex;
@@ -2405,7 +2407,7 @@ int unpoison_memory(unsigned long pfn)
 	} else {
 		if (PageHuge(p)) {
 			huge = true;
-			count = free_raw_hwp_pages(page, false);
+			count = folio_free_raw_hwp(folio, false);
 			if (count == 0) {
 				ret = -EBUSY;
 				put_page(page);
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

