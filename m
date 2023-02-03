Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54F8C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjBCGhc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjBCGg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD20C8D62A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50C30B80966
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C2C433EF;
        Fri,  3 Feb 2023 06:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406174;
        bh=m8vt5WTLbGdRfCVN1S0sQ+iO4gIwlXwc2xnUDUuO2T0=;
        h=Date:To:From:Subject:From;
        b=fvc1X6UlDygr+IjngLN8Blwkw11Fg4n+IjGGhGYMpyjZBjWg8+Wyy89XWh8TJFdZF
         urRjLnLjzuwl3UfinvS8vJS+1gOPK/qNRMKSY/HPlKlIBCLH1RLRh4UYnBPLtkuK/g
         oSBiLiTq56lp8lKL6SgpOZamRCoUF9cEz6LUmv3c=
Date:   Thu, 02 Feb 2023 22:36:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-unpoison_memory-to-folios.patch removed from -mm tree
Message-Id: <20230203063613.EA4C2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert unpoison_memory() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-unpoison_memory-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert unpoison_memory() to folios
Date: Thu, 12 Jan 2023 14:46:08 -0600

Use a folio inside unpoison_memory which replaces a compound_head() call
with a call to page_folio().

Link: https://lkml.kernel.org/r/20230112204608.80136-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-convert-unpoison_memory-to-folios
+++ a/mm/memory-failure.c
@@ -2335,7 +2335,6 @@ core_initcall(memory_failure_init);
  */
 int unpoison_memory(unsigned long pfn)
 {
-	struct page *page;
 	struct folio *folio;
 	struct page *p;
 	int ret = -EBUSY;
@@ -2348,7 +2347,6 @@ int unpoison_memory(unsigned long pfn)
 		return -ENXIO;
 
 	p = pfn_to_page(pfn);
-	page = compound_head(p);
 	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
@@ -2360,31 +2358,31 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!PageHWPoison(p)) {
+	if (!folio_test_hwpoison(folio)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (page_count(page) > 1) {
+	if (folio_ref_count(folio) > 1) {
 		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (page_mapped(page)) {
+	if (folio_mapped(folio)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (page_mapping(page)) {
+	if (folio_mapping(folio)) {
 		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (PageSlab(page) || PageTable(page) || PageReserved(page))
+	if (folio_test_slab(folio) || PageTable(&folio->page) || folio_test_reserved(folio))
 		goto unlock_mutex;
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
@@ -2397,7 +2395,7 @@ int unpoison_memory(unsigned long pfn)
 				goto unlock_mutex;
 			}
 		}
-		ret = TestClearPageHWPoison(page) ? 0 : -EBUSY;
+		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
 	} else if (ret < 0) {
 		if (ret == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
@@ -2410,14 +2408,14 @@ int unpoison_memory(unsigned long pfn)
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0) {
 				ret = -EBUSY;
-				put_page(page);
+				folio_put(folio);
 				goto unlock_mutex;
 			}
 		}
 
-		put_page(page);
+		folio_put(folio);
 		if (TestClearPageHWPoison(p)) {
-			put_page(page);
+			folio_put(folio);
 			ret = 0;
 		}
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

