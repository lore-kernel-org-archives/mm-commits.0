Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3FCC64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjBMXz2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjBMXzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8150E17CD8
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1E461360
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75381C433D2;
        Mon, 13 Feb 2023 23:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332520;
        bh=ezDktTpYnyb64MkJTdNrwf17KKVORWTTCYuGvkGEcwg=;
        h=Date:To:From:Subject:From;
        b=e2PgnrgrWdcycFFEQNI55FfJKuWeYHUm6gDgJxt+vK2tcGoBRVjqJSbsvCGqHnDvE
         UWi0Hx1pBdcEkWLnhsgqJ7ZwIjzSm0qHaVtk/rss8mKFjyYVAynQaLE/HBUx8ermS2
         +ZUHIzByq+tRm+7gfDPpHtp3Z18yFP8BKBx2XYNM=
Date:   Mon, 13 Feb 2023 15:55:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch removed from -mm tree
Message-Id: <20230213235520.75381C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert putback_active_hugepage to take in a folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert putback_active_hugepage to take in a folio
Date: Wed, 25 Jan 2023 09:05:32 -0800

Convert putback_active_hugepage() to folio_putback_active_hugetlb(), this
removes one user of the Huge Page macros which take in a page.  The
callers in migrate.c are also cleaned up by being able to directly use the
src and dst folio variables.

Link: https://lkml.kernel.org/r/20230125170537.96973-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio
+++ a/include/linux/hugetlb.h
@@ -175,7 +175,7 @@ int isolate_hugetlb(struct folio *folio,
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
-void putback_active_hugepage(struct page *page);
+void folio_putback_active_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
@@ -429,7 +429,7 @@ static inline int get_huge_page_for_hwpo
 	return 0;
 }
 
-static inline void putback_active_hugepage(struct page *page)
+static inline void folio_putback_active_hugetlb(struct folio *folio)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio
+++ a/mm/hugetlb.c
@@ -7300,13 +7300,13 @@ int get_huge_page_for_hwpoison(unsigned
 	return ret;
 }
 
-void putback_active_hugepage(struct page *page)
+void folio_putback_active_hugetlb(struct folio *folio)
 {
 	spin_lock_irq(&hugetlb_lock);
-	SetHPageMigratable(page);
-	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
+	folio_set_hugetlb_migratable(folio);
+	list_move_tail(&folio->lru, &(folio_hstate(folio))->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
-	put_page(page);
+	folio_put(folio);
 }
 
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
--- a/mm/migrate.c~mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio
+++ a/mm/migrate.c
@@ -151,7 +151,7 @@ void putback_movable_pages(struct list_h
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		if (unlikely(PageHuge(page))) {
-			putback_active_hugepage(page);
+			folio_putback_active_hugetlb(page_folio(page));
 			continue;
 		}
 		list_del(&page->lru);
@@ -1298,7 +1298,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
-		putback_active_hugepage(hpage);
+		folio_putback_active_hugetlb(src);
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -1383,7 +1383,7 @@ out_unlock:
 	folio_unlock(src);
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
-		putback_active_hugepage(hpage);
+		folio_putback_active_hugetlb(src);
 	else if (rc != -EAGAIN)
 		list_move_tail(&src->lru, ret);
 
@@ -1395,7 +1395,7 @@ out:
 	if (put_new_page)
 		put_new_page(new_hpage, private);
 	else
-		putback_active_hugepage(new_hpage);
+		folio_putback_active_hugetlb(dst);
 
 	return rc;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


