Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89A3C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjASBNy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjASBNo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:13:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E844769225
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97EE0B81FB5
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0F8C433D2;
        Thu, 19 Jan 2023 01:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090811;
        bh=IyVELQZxH9nFzhuCPaTssZzlBMLFn28W1//cnIsWRlY=;
        h=Date:To:From:Subject:From;
        b=AeKIS6zX+HGUxmX7fTG71nJ+ebxHYuYpYtgMtYt3RsFpOEeRZYiUTYxb0gDMR1KKO
         wChM1pf+39obERWuI/lmPpaBMvrf7T2kch4+0Ud+hxQrfU8MBxPN/sGP74kCPsm6Qy
         zCWPDqgI/cIKap3s6aZS4QgJ7Ct7Dd8k5puLTaeU=
Date:   Wed, 18 Jan 2023 17:13:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-folio_set_compound_order-to-mm-internalh.patch removed from -mm tree
Message-Id: <20230119011331.3E0F8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move folio_set_compound_order() to mm/internal.h
has been removed from the -mm tree.  Its filename was
     mm-move-folio_set_compound_order-to-mm-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: move folio_set_compound_order() to mm/internal.h
Date: Wed, 14 Dec 2022 22:17:57 -0800

folio_set_compound_order() is moved to an mm-internal location so external
folio users cannot misuse this function.  Change the name of the function
to folio_set_order() and use WARN_ON_ONCE() rather than BUG_ON.  Also,
handle the case if a non-large folio is passed and add clarifying comments
to the function.

Link: https://lore.kernel.org/lkml/20221207223731.32784-1-sidhartha.kumar@oracle.com/T/
Link: https://lkml.kernel.org/r/20221215061757.223440-1-sidhartha.kumar@oracle.com
Fixes: 9fd330582b2f ("mm: add folio dtor and order setter functions")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 ----------------
 mm/hugetlb.c       |    6 +++---
 mm/internal.h      |   19 +++++++++++++++++++
 3 files changed, 22 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-move-folio_set_compound_order-to-mm-internalh
+++ a/include/linux/mm.h
@@ -1019,22 +1019,6 @@ static inline void set_compound_order(st
 #endif
 }
 
-/*
- * folio_set_compound_order is generally passed a non-zero order to
- * initialize a large folio.  However, hugetlb code abuses this by
- * passing in zero when 'dissolving' a large folio.
- */
-static inline void folio_set_compound_order(struct folio *folio,
-		unsigned int order)
-{
-	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
-
-	folio->_folio_order = order;
-#ifdef CONFIG_64BIT
-	folio->_folio_nr_pages = order ? 1U << order : 0;
-#endif
-}
-
 /* Returns the number of pages in this potentially compound page. */
 static inline unsigned long compound_nr(struct page *page)
 {
--- a/mm/hugetlb.c~mm-move-folio_set_compound_order-to-mm-internalh
+++ a/mm/hugetlb.c
@@ -1492,7 +1492,7 @@ static void __destroy_compound_gigantic_
 			set_page_refcounted(p);
 	}
 
-	folio_set_compound_order(folio, 0);
+	folio_set_order(folio, 0);
 	__folio_clear_head(folio);
 }
 
@@ -1956,7 +1956,7 @@ static bool __prep_compound_gigantic_fol
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
 	/* we rely on prep_new_hugetlb_folio to set the destructor */
-	folio_set_compound_order(folio, order);
+	folio_set_order(folio, order);
 	for (i = 0; i < nr_pages; i++) {
 		p = folio_page(folio, i);
 
@@ -2020,7 +2020,7 @@ out_error:
 		p = folio_page(folio, j);
 		__ClearPageReserved(p);
 	}
-	folio_set_compound_order(folio, 0);
+	folio_set_order(folio, 0);
 	__folio_clear_head(folio);
 	return false;
 }
--- a/mm/internal.h~mm-move-folio_set_compound_order-to-mm-internalh
+++ a/mm/internal.h
@@ -378,6 +378,25 @@ extern void *memmap_alloc(phys_addr_t si
 int split_free_page(struct page *free_page,
 			unsigned int order, unsigned long split_pfn_offset);
 
+/*
+ * This will have no effect, other than possibly generating a warning, if the
+ * caller passes in a non-large folio.
+ */
+static inline void folio_set_order(struct folio *folio, unsigned int order)
+{
+	if (WARN_ON_ONCE(!folio_test_large(folio)))
+		return;
+
+	folio->_folio_order = order;
+#ifdef CONFIG_64BIT
+	/*
+	 * When hugetlb dissolves a folio, we need to clear the tail
+	 * page, rather than setting nr_pages to 1.
+	 */
+	folio->_folio_nr_pages = order ? 1U << order : 0;
+#endif
+}
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

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
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch

