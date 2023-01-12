Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA69C63797
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjALVcu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbjALVb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:31:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D9725ED
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E1B462190
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C546AC433EF;
        Thu, 12 Jan 2023 21:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558186;
        bh=kNs7UpJrXbh/NHSZDurw4JekMX2TLhFPlbtjXN/ngOg=;
        h=Date:To:From:Subject:From;
        b=oXACBkkX+ipSzqG7pdemVbY5bE1u5Cd4gX9Z6UnlivxWkgY6/P+Mp3eFDOeC2i4iX
         ldRTQsv0X3/Hy/S39Xk+dMUWk3MavzuMW8oTpMf5QH4IF557PV3aA4iLPQtRGGs61w
         yBnPEkC48wIUJ4qefNJiIJp8gVmij2bArBaFuG30=
Date:   Thu, 12 Jan 2023 13:16:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211626.C546AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert __get_huge_page_for_hwpoison() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch

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
Subject: mm/memory-failure: convert __get_huge_page_for_hwpoison() to folios
Date: Thu, 12 Jan 2023 14:46:01 -0600

Patch series "convert hugepage memory failure functions to folios".

This series contains a 1:1 straightforward page to folio conversion for
memory failure functions which deal with huge pages.  I renamed a few
functions to fit with how other folio operating functions are named. 
These include:

hugetlb_clear_page_hwpoison -> folio_clear_hugetlb_hwpoison
free_raw_hwp_pages -> folio_free_raw_hwp
__free_raw_hwp_pages -> __folio_free_raw_hwp
hugetlb_set_page_hwpoison -> folio_set_hugetlb_hwpoison

The goal of this series was to reduce users of the hugetlb specific page
flag macros which take in a page so users are protected by the compiler to
make sure they are operating on a head page.


This patch (of 8):

Use a folio throughout the function rather than using a head page.  This
also reduces the users of the page version of hugetlb specific page flags.

Link: https://lkml.kernel.org/r/20230112204608.80136-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios
+++ a/mm/memory-failure.c
@@ -1807,20 +1807,20 @@ int __get_huge_page_for_hwpoison(unsigne
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
-	struct page *head = compound_head(page);
+	struct folio *folio = page_folio(page);
 	int ret = 2;	/* fallback to normal page handling */
 	bool count_increased = false;
 
-	if (!PageHeadHuge(head))
+	if (!folio_test_hugetlb(folio))
 		goto out;
 
 	if (flags & MF_COUNT_INCREASED) {
 		ret = 1;
 		count_increased = true;
-	} else if (HPageFreed(head)) {
+	} else if (folio_test_hugetlb_freed(folio)) {
 		ret = 0;
-	} else if (HPageMigratable(head)) {
-		ret = get_page_unless_zero(head);
+	} else if (folio_test_hugetlb_migratable(folio)) {
+		ret = folio_try_get(folio);
 		if (ret)
 			count_increased = true;
 	} else {
@@ -1829,24 +1829,24 @@ int __get_huge_page_for_hwpoison(unsigne
 			goto out;
 	}
 
-	if (hugetlb_set_page_hwpoison(head, page)) {
+	if (hugetlb_set_page_hwpoison(&folio->page, page)) {
 		ret = -EHWPOISON;
 		goto out;
 	}
 
 	/*
-	 * Clearing HPageMigratable for hwpoisoned hugepages to prevent them
+	 * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
 	 * from being migrated by memory hotremove.
 	 */
-	if (count_increased && HPageMigratable(head)) {
-		ClearHPageMigratable(head);
+	if (count_increased && folio_test_hugetlb_migratable(folio)) {
+		folio_clear_hugetlb_migratable(folio);
 		*migratable_cleared = true;
 	}
 
 	return ret;
 out:
 	if (count_increased)
-		put_page(head);
+		folio_put(folio);
 	return ret;
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

