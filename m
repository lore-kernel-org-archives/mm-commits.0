Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92528C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjBCGh1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBCGgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794588D439
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BA02B8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6860C4339B;
        Fri,  3 Feb 2023 06:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406168;
        bh=ZYBw6SoFqrUxYf2wGBQ5aB1NZgrGNnW9cJ4cxhzbK+U=;
        h=Date:To:From:Subject:From;
        b=ysr5MT+FB74Dh733ancs10NCNwkyTLP4War5oIOKVBhfg6VERJXTaSbrKtD5Vw4vB
         cQn8mIirHwp5MU0NKUlTXC+N6IKWR5VyWHfL+5qHEzNOYz8hMwLeLGBOq2+R4IHg1X
         YQQkBXJBROtCLhFW+LkXo93Rv531DnSf9s8J1SzI=
Date:   Thu, 02 Feb 2023 22:36:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch removed from -mm tree
Message-Id: <20230203063608.C6860C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert hugetlb_clear_page_hwpoison to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert hugetlb_clear_page_hwpoison to folios
Date: Thu, 12 Jan 2023 14:46:03 -0600

Change hugetlb_clear_page_hwpoison() to folio_clear_hugetlb_hwpoison() by
changing the function to take in a folio.  This converts one use of
ClearPageHWPoison and HPageRawHwpUnreliable to their folio equivalents.

Link: https://lkml.kernel.org/r/20230112204608.80136-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios
+++ a/include/linux/hugetlb.h
@@ -878,9 +878,9 @@ extern int dissolve_free_huge_pages(unsi
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

mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

