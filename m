Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DF9C2BA1B
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjIPUHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbjIPUHi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:07:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6BD1B5
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:07:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35117C433C7;
        Sat, 16 Sep 2023 20:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694894853;
        bh=elFIuOH+BsLQVSSRO7GEkFpcBrkiH5o0Sae0pWeyPJ0=;
        h=Date:To:From:Subject:From;
        b=ZaYU72UBwYkfjnQEyggoT8tz7fbVpwv21P80025L4UA4sD+YcrAzqGUzyvcn9WwtM
         zysNPDqoGQXVIavllPXV/Zjmq/XkRJ4BTKhXUX+sfWczXC0YIiFqKx0YvHobPzcgGa
         fA5TA7V3PpmZwSxvAKRhi5fbJHYbVUUkt/6llYxU=
Date:   Sat, 16 Sep 2023 13:07:32 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-remove-a-few-calls-to-page_folio.patch added to mm-unstable branch
Message-Id: <20230916200733.35117C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove a few calls to page_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-remove-a-few-calls-to-page_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-remove-a-few-calls-to-page_folio.patch

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
Subject: hugetlb: remove a few calls to page_folio()
Date: Thu, 24 Aug 2023 15:13:24 +0100

Anything found on a linked list threaded through ->lru is guaranteed to be
a folio as the compound_head found in a tail page overlaps the ->lru
member of struct page.  So we can pull folios directly off these lists no
matter whether pages or folios were added to the list.

Link: https://lkml.kernel.org/r/20230824141325.2704553-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-a-few-calls-to-page_folio
+++ a/mm/hugetlb.c
@@ -1829,11 +1829,9 @@ static void update_and_free_hugetlb_foli
 
 static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
 {
-	struct page *page, *t_page;
-	struct folio *folio;
+	struct folio *folio, *t_folio;
 
-	list_for_each_entry_safe(page, t_page, list, lru) {
-		folio = page_folio(page);
+	list_for_each_entry_safe(folio, t_folio, list, lru) {
 		update_and_free_hugetlb_folio(h, folio, false);
 		cond_resched();
 	}
@@ -2208,8 +2206,7 @@ static struct page *remove_pool_huge_pag
 						 bool acct_surplus)
 {
 	int nr_nodes, node;
-	struct page *page = NULL;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
@@ -2219,15 +2216,14 @@ static struct page *remove_pool_huge_pag
 		 */
 		if ((!acct_surplus || h->surplus_huge_pages_node[node]) &&
 		    !list_empty(&h->hugepage_freelists[node])) {
-			page = list_entry(h->hugepage_freelists[node].next,
-					  struct page, lru);
-			folio = page_folio(page);
+			folio = list_entry(h->hugepage_freelists[node].next,
+					  struct folio, lru);
 			remove_hugetlb_folio(h, folio, acct_surplus);
 			break;
 		}
 	}
 
-	return page;
+	return &folio->page;
 }
 
 /*
@@ -3393,15 +3389,15 @@ static void try_to_free_low(struct hstat
 	 * Collect pages to be freed on a list, and free after dropping lock
 	 */
 	for_each_node_mask(i, *nodes_allowed) {
-		struct page *page, *next;
+		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
-		list_for_each_entry_safe(page, next, freel, lru) {
+		list_for_each_entry_safe(folio, next, freel, lru) {
 			if (count >= h->nr_huge_pages)
 				goto out;
-			if (PageHighMem(page))
+			if (folio_test_highmem(folio))
 				continue;
-			remove_hugetlb_folio(h, page_folio(page), false);
-			list_add(&page->lru, &page_list);
+			remove_hugetlb_folio(h, folio, false);
+			list_add(&folio->lru, &page_list);
 		}
 	}
 
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

