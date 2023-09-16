Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7175AC46CA1
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbjIPUHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbjIPUHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:07:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD311B5
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:07:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E5FC433C8;
        Sat, 16 Sep 2023 20:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694894855;
        bh=GgNF+rPagjTlvRT2TxdcAdFaS2uuhv/7IvTkaUsdXNg=;
        h=Date:To:From:Subject:From;
        b=uwJRNLz5Vs3ZeYpNaAvHRlOLxWrIOPZxGxHCllUvM28z9Jrxmo1Zr6mz54A5G+Rb+
         wim3yFKxz3sMG3JF+13wEECgiMpTXFjTkipjcbJczPFZjo6nPHB8f0ZD0XKD6aFtI+
         8l937PQt2jBWZyQpqqMgofAo0IWTachUuczrE9fc=
Date:   Sat, 16 Sep 2023 13:07:34 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20230916200734.E8E5FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: convert remove_pool_huge_page() to remove_pool_hugetlb_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

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
@@ -1439,7 +1439,7 @@ static int hstate_next_node_to_alloc(str
 }
 
 /*
- * helper for remove_pool_huge_page() - return the previously saved
+ * helper for remove_pool_hugetlb_folio() - return the previously saved
  * node ["this node"] from which to free a huge page.  Advance the
  * next node id whether or not we find a free huge page to free so
  * that the next attempt to free addresses the next node.
@@ -2201,9 +2201,8 @@ static int alloc_pool_huge_page(struct h
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
@@ -2223,7 +2222,7 @@ static struct page *remove_pool_huge_pag
 		}
 	}
 
-	return &folio->page;
+	return folio;
 }
 
 /*
@@ -2577,7 +2576,6 @@ static void return_unused_surplus_pages(
 					unsigned long unused_resv_pages)
 {
 	unsigned long nr_pages;
-	struct page *page;
 	LIST_HEAD(page_list);
 
 	lockdep_assert_held(&hugetlb_lock);
@@ -2598,15 +2596,17 @@ static void return_unused_surplus_pages(
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
@@ -3451,7 +3451,6 @@ static int set_max_huge_pages(struct hst
 			      nodemask_t *nodes_allowed)
 {
 	unsigned long min_count, ret;
-	struct page *page;
 	LIST_HEAD(page_list);
 	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
 
@@ -3573,11 +3572,13 @@ static int set_max_huge_pages(struct hst
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

