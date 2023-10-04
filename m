Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409F4E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbjJDUXL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243761AbjJDUWd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E84EE
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB94C433C8;
        Wed,  4 Oct 2023 20:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450949;
        bh=4FpI9A3UyrIR92L0XeiJr+9RAo40PyB2TqvrowSWkCA=;
        h=Date:To:From:Subject:From;
        b=CjdtcSJoeYv4U38xLEjsFFWw6yyvHC57tL1mAfnh4FAECZ/gpRJ6FD1pmFzBJt8jI
         UGVlCho//ZS0Z9QNcx7VfhTT/7qNf62wk5cP8oc7otBdc1uOw6XvlaqZRZVTVy5NAa
         oSz6NWpIFkMOEG7qmsC6WMAuLZILuF+v8xZTQrEI=
Date:   Wed, 04 Oct 2023 13:22:27 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch removed from -mm tree
Message-Id: <20231004202229.2FB94C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: convert remove_pool_huge_page() to remove_pool_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: convert remove_pool_huge_page() to remove_pool_hugetlb_folio()
Date: Thu, 24 Aug 2023 15:13:25 +0100

Convert the callers to expect a folio and remove the unnecesary conversion
back to a struct page.

Link: https://lkml.kernel.org/r/20230824141325.2704553-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1446,7 +1446,7 @@ static int hstate_next_node_to_alloc(str
 }
 
 /*
- * helper for remove_pool_huge_page() - return the previously saved
+ * helper for remove_pool_hugetlb_folio() - return the previously saved
  * node ["this node"] from which to free a huge page.  Advance the
  * next node id whether or not we find a free huge page to free so
  * that the next attempt to free addresses the next node.
@@ -2222,9 +2222,8 @@ static int alloc_pool_huge_page(struct h
  * an additional call to free the page to low level allocators.
  * Called with hugetlb_lock locked.
  */
-static struct page *remove_pool_huge_page(struct hstate *h,
-						nodemask_t *nodes_allowed,
-						 bool acct_surplus)
+static struct folio *remove_pool_hugetlb_folio(struct hstate *h,
+		nodemask_t *nodes_allowed, bool acct_surplus)
 {
 	int nr_nodes, node;
 	struct folio *folio = NULL;
@@ -2244,7 +2243,7 @@ static struct page *remove_pool_huge_pag
 		}
 	}
 
-	return &folio->page;
+	return folio;
 }
 
 /*
@@ -2598,7 +2597,6 @@ static void return_unused_surplus_pages(
 					unsigned long unused_resv_pages)
 {
 	unsigned long nr_pages;
-	struct page *page;
 	LIST_HEAD(page_list);
 
 	lockdep_assert_held(&hugetlb_lock);
@@ -2619,15 +2617,17 @@ static void return_unused_surplus_pages(
 	 * evenly across all nodes with memory. Iterate across these nodes
 	 * until we can no longer free unreserved surplus pages. This occurs
 	 * when the nodes with surplus pages have no free pages.
-	 * remove_pool_huge_page() will balance the freed pages across the
+	 * remove_pool_hugetlb_folio() will balance the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 */
 	while (nr_pages--) {
-		page = remove_pool_huge_page(h, &node_states[N_MEMORY], 1);
-		if (!page)
+		struct folio *folio;
+
+		folio = remove_pool_hugetlb_folio(h, &node_states[N_MEMORY], 1);
+		if (!folio)
 			goto out;
 
-		list_add(&page->lru, &page_list);
+		list_add(&folio->lru, &page_list);
 	}
 
 out:
@@ -3472,7 +3472,6 @@ static int set_max_huge_pages(struct hst
 			      nodemask_t *nodes_allowed)
 {
 	unsigned long min_count, ret;
-	struct page *page;
 	LIST_HEAD(page_list);
 	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
 
@@ -3594,11 +3593,13 @@ static int set_max_huge_pages(struct hst
 	 * Collect pages to be removed on list without dropping lock
 	 */
 	while (min_count < persistent_huge_pages(h)) {
-		page = remove_pool_huge_page(h, nodes_allowed, 0);
-		if (!page)
+		struct folio *folio;
+
+		folio = remove_pool_hugetlb_folio(h, nodes_allowed, 0);
+		if (!folio)
 			break;
 
-		list_add(&page->lru, &page_list);
+		list_add(&folio->lru, &page_list);
 	}
 	/* free the pages after dropping lock */
 	spin_unlock_irq(&hugetlb_lock);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

