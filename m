Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDEAE8FDC7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244575AbjJDUXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244557AbjJDUWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044DDF1
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43496C433C8;
        Wed,  4 Oct 2023 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450953;
        bh=jUfW7xmF7WC1WEh6gHusjk8+4wCHuFPqOu/WzR9E+UY=;
        h=Date:To:From:Subject:From;
        b=WHglTKvTySSNl16ZmRQfRaa/wJdDS5z77SpwV4+qiEvK4fn59KSD7o0RERaavf6pb
         kPfT+40t3XFEL34IqGCYd5j8qOHAisjnZadUdF60h7olLVWswHHiAUX+yaiZlz2g0A
         5lpF/iu0asom8ACexfUY40Ji+7QpOg/Zb5eE8tQI=
Date:   Wed, 04 Oct 2023 13:22:31 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-a-few-calls-to-page_folio.patch removed from -mm tree
Message-Id: <20231004202233.43496C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove a few calls to page_folio()
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-a-few-calls-to-page_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1836,11 +1836,9 @@ static void update_and_free_hugetlb_foli
 
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
@@ -2229,8 +2227,7 @@ static struct page *remove_pool_huge_pag
 						 bool acct_surplus)
 {
 	int nr_nodes, node;
-	struct page *page = NULL;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
@@ -2240,15 +2237,14 @@ static struct page *remove_pool_huge_pag
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
@@ -3414,15 +3410,15 @@ static void try_to_free_low(struct hstat
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

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

