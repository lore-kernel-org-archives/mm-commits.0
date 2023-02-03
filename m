Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAF3C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjBCGmn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBCGl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8F78B305
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E94DCE2EA1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72153C433EF;
        Fri,  3 Feb 2023 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406275;
        bh=Zv/NLFYfGe+whrUyDfaGLrpJYXb0ObNg3GXAB7wGVHc=;
        h=Date:To:From:Subject:From;
        b=P9jxBGmTONf4+WxKpQkpuIrPIbQfiTiAlC12U6UsFM5pe+OmS+LWbm3keDjddZhuO
         eK/CwcCS+hXnCz0JBOn7o73r2hryvFvkZpqzQE3crNs+C7HXQLSisznt6nJybg55Ja
         ooqTE+PeSpMwmbQOxIhuB8vH9KVC/ZeIAMrWbmqM=
Date:   Thu, 02 Feb 2023 22:37:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch removed from -mm tree
Message-Id: <20230203063755.72153C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert get_hwpoison_huge_page() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert get_hwpoison_huge_page() to folios
Date: Wed, 18 Jan 2023 09:40:39 -0800

Straightforward conversion of get_hwpoison_huge_page() to
get_hwpoison_hugetlb_folio().  Reduces two references to a head page in
memory-failure.c

[arnd@arndb.de: fix get_hwpoison_hugetlb_folio() stub]
  Link: https://lkml.kernel.org/r/20230119111920.635260-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20230118174039.14247-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios
+++ a/include/linux/hugetlb.h
@@ -172,7 +172,7 @@ bool hugetlb_reserve_pages(struct inode
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 int isolate_hugetlb(struct page *page, struct list_head *list);
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison);
+int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
 void putback_active_hugepage(struct page *page);
@@ -418,7 +418,7 @@ static inline int isolate_hugetlb(struct
 	return -EBUSY;
 }
 
-static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
+static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -7268,18 +7268,18 @@ unlock:
 	return ret;
 }
 
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
+int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison)
 {
 	int ret = 0;
 
 	*hugetlb = false;
 	spin_lock_irq(&hugetlb_lock);
-	if (PageHeadHuge(page)) {
+	if (folio_test_hugetlb(folio)) {
 		*hugetlb = true;
-		if (HPageFreed(page))
+		if (folio_test_hugetlb_freed(folio))
 			ret = 0;
-		else if (HPageMigratable(page) || unpoison)
-			ret = get_page_unless_zero(page);
+		else if (folio_test_hugetlb_migratable(folio) || unpoison)
+			ret = folio_try_get(folio);
 		else
 			ret = -EBUSY;
 	}
--- a/mm/memory-failure.c~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios
+++ a/mm/memory-failure.c
@@ -1257,28 +1257,28 @@ static inline bool HWPoisonHandlable(str
 
 static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
-	struct page *head = compound_head(page);
+	struct folio *folio = page_folio(page);
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb, false);
+	ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, false);
 	if (hugetlb)
 		return ret;
 
 	/*
-	 * This check prevents from calling get_page_unless_zero() for any
-	 * unsupported type of page in order to reduce the risk of unexpected
-	 * races caused by taking a page refcount.
+	 * This check prevents from calling folio_try_get() for any
+	 * unsupported type of folio in order to reduce the risk of unexpected
+	 * races caused by taking a folio refcount.
 	 */
-	if (!HWPoisonHandlable(head, flags))
+	if (!HWPoisonHandlable(&folio->page, flags))
 		return -EBUSY;
 
-	if (get_page_unless_zero(head)) {
-		if (head == compound_head(page))
+	if (folio_try_get(folio)) {
+		if (folio == page_folio(page))
 			return 1;
 
 		pr_info("%#lx cannot catch tail\n", page_to_pfn(page));
-		put_page(head);
+		folio_put(folio);
 	}
 
 	return 0;
@@ -1347,11 +1347,11 @@ out:
 
 static int __get_unpoison_page(struct page *page)
 {
-	struct page *head = compound_head(page);
+	struct folio *folio = page_folio(page);
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb, true);
+	ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, true);
 	if (hugetlb)
 		return ret;
 
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

