Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0870C54EBE
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbjALVck (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240612AbjALVcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8C9392D2
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B098B82022
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5F2C433EF;
        Thu, 12 Jan 2023 21:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558191;
        bh=Y7Nm/eYhl4x7zeCjO9fbuXmfYrlXRSSLZLDsKJVIdtU=;
        h=Date:To:From:Subject:From;
        b=0nIygv5j62zbay8+j/MD7moNF5CILFoJpoQlYVGN+RQ/5q0GBVUf2+0UHuovYaHDS
         MB62rcGPADY9+oA+U5qveckoBL3R8rusq0yUVevwMZtJeBm5YB7O+T7Z+33yrFd350
         aDZN5U/tmAR5ccZR3ZG9ocTF5ZBJdXkK3ahgGqyk=
Date:   Thu, 12 Jan 2023 13:16:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211630.DE5F2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert hugetlb_clear_page_hwpoison to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch

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
Subject: mm/memory-failure: convert hugetlb_clear_page_hwpoison to folios
Date: Thu, 12 Jan 2023 14:46:03 -0600

Change hugetlb_clear_page_hwpoison() to folio_clear_hugetlb_hwpoison() by
changing the function to take in a folio.  This converts one use of
ClearPageHWPoison and HPageRawHwpUnreliable to their folio equivalents.

Link: https://lkml.kernel.org/r/20230112204608.80136-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    2 +-
 mm/memory-failure.c     |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb.h~mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios
+++ a/include/linux/hugetlb.h
@@ -877,9 +877,9 @@ extern int dissolve_free_huge_pages(unsi
 				    unsigned long end_pfn);
 
 #ifdef CONFIG_MEMORY_FAILURE
-extern void hugetlb_clear_page_hwpoison(struct page *hpage);
+extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
 #else
-static inline void hugetlb_clear_page_hwpoison(struct page *hpage)
+static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
 }
 #endif
--- a/mm/hugetlb.c~mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios
+++ a/mm/hugetlb.c
@@ -1731,7 +1731,7 @@ static void __update_and_free_page(struc
 	 * which makes any healthy subpages reusable.
 	 */
 	if (unlikely(folio_test_hwpoison(folio)))
-		hugetlb_clear_page_hwpoison(&folio->page);
+		folio_clear_hugetlb_hwpoison(folio);
 
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		subpage = folio_page(folio, i);
--- a/mm/memory-failure.c~mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios
+++ a/mm/memory-failure.c
@@ -1785,12 +1785,12 @@ static unsigned long free_raw_hwp_pages(
 	return __free_raw_hwp_pages(hpage, move_flag);
 }
 
-void hugetlb_clear_page_hwpoison(struct page *hpage)
+void folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
-	if (HPageRawHwpUnreliable(hpage))
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
-	ClearPageHWPoison(hpage);
-	free_raw_hwp_pages(hpage, true);
+	folio_clear_hwpoison(folio);
+	free_raw_hwp_pages(&folio->page, true);
 }
 
 /*
@@ -1889,7 +1889,7 @@ retry:
 	folio_lock(folio);
 
 	if (hwpoison_filter(p)) {
-		hugetlb_clear_page_hwpoison(&folio->page);
+		folio_clear_hugetlb_hwpoison(folio);
 		if (migratable_cleared)
 			folio_set_hugetlb_migratable(folio);
 		folio_unlock(folio);
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

