Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F32CC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjBCGh1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjBCGgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B938D602
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22365B80966
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18D7C433D2;
        Fri,  3 Feb 2023 06:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406169;
        bh=in6aoUYt8NMzdqDxuL9QQFS4WTEr0Qnt/DqFpsNTEk0=;
        h=Date:To:From:Subject:From;
        b=0x/UeM+b0vFJZq3A9JgqvLWMP/oe8M/f7ixSUS1j0gdQVj8EgAV7caLA727s6UsmN
         1dJSrGYssoCQRw/wqNZSeooYcO6EX46KzBMuIgErOQWr6ArLTKM5EN321STqzRLRLo
         ftWVMzAZmn+ctfKzTMQRwtQLrWPkZxhQPIhVC36w=
Date:   Thu, 02 Feb 2023 22:36:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch removed from -mm tree
Message-Id: <20230203063609.C18D7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert free_raw_hwp_pages() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert free_raw_hwp_pages() to folios
Date: Thu, 12 Jan 2023 14:46:04 -0600

Change free_raw_hwp_pages() to folio_free_raw_hwp(), converts two users of
hugetlb specific page macro users to their folio equivalents.

Link: https://lkml.kernel.org/r/20230112204608.80136-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

