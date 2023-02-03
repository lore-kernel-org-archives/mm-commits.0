Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77CEC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjBCGhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjBCGgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35468CAAB
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E53161DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B54C4339B;
        Fri,  3 Feb 2023 06:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406166;
        bh=wPA+PLUDrZLN1CiblFT9vrpEwuypn0S2J46FnH4oYIQ=;
        h=Date:To:From:Subject:From;
        b=q1K7fn/rQ7a1EbOTI4wuyH9gk43jiO3reX9HF4pgcrO3BDPy25GFuyMjIRiUVHNxN
         rk7oZewDdbu8qHP0H9u0WmD75V/L8GyrHAABbxX6eh6k1cbJX68r4NmxdekFyNsyVg
         ZAeGh6issulCpg6cBIZKlvBj9WtRBUewkIPXJZHw=
Date:   Thu, 02 Feb 2023 22:36:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch removed from -mm tree
Message-Id: <20230203063606.A0B54C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert __get_huge_page_for_hwpoison() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

