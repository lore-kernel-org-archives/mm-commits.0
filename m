Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8E1C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4322E61410
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhEEBgB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBgA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8005613FE;
        Wed,  5 May 2021 01:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178504;
        bh=qMI56c3SCUa3oIgT+sClG4lI57dh/k1WEwmSnxBJvgU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AR/xJqxRlnrVMijoOmzo82USmguwuSRLSQHv0um+vpoOD6bkLpshuohQ79j8y4Rdg
         gC0BmjGPCpbrcTXkM8R7F0WqjYwafh17CP5wwgVeoyt6Ibl1J66aLlG2kR9P7j0ggi
         8xqXmDAFUe8M77emvuZevwdAPWo2DOqR0glwHqCg=
Date:   Tue, 04 May 2021 18:35:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        aneesh.kumar@linux.ibm.com, david@redhat.com, guro@fb.com,
        hdanton@sina.com, iamjoonsoo.kim@lge.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, longman@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, peterx@redhat.com,
        peterz@infradead.org, rientjes@google.com, shakeelb@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, will@kernel.org, willy@infradead.org
Subject:  [patch 044/143] hugetlb: change free_pool_huge_page to
 remove_pool_huge_page
Message-ID: <20210505013503._MzT0qnGc%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: change free_pool_huge_page to remove_pool_huge_page

free_pool_huge_page was called with hugetlb_lock held.  It would remove a
hugetlb page, and then free the corresponding pages to the lower level
allocators such as buddy.  free_pool_huge_page was called in a loop to
remove hugetlb pages and these loops could hold the hugetlb_lock for a
considerable time.

Create new routine remove_pool_huge_page to replace free_pool_huge_page. 
remove_pool_huge_page will remove the hugetlb page, and it must be called
with the hugetlb_lock held.  It will return the removed page and it is the
responsibility of the caller to free the page to the lower level
allocators.  The hugetlb_lock is dropped before freeing to these
allocators which results in shorter lock hold times.

Add new helper routine to call update_and_free_page for a list of pages.

Note: Some changes to the routine return_unused_surplus_pages are in need
of explanation.  Commit e5bbc8a6c992 ("mm/hugetlb.c: fix reservation race
when freeing surplus pages") modified this routine to address a race which
could occur when dropping the hugetlb_lock in the loop that removes pool
pages.  Accounting changes introduced in that commit were subtle and took
some thought to understand.  This commit removes the cond_resched_lock()
and the potential race.  Therefore, remove the subtle code and restore the
more straight forward accounting effectively reverting the commit.

Link: https://lkml.kernel.org/r/20210409205254.242291-7-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   93 ++++++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 42 deletions(-)

--- a/mm/hugetlb.c~hugetlb-change-free_pool_huge_page-to-remove_pool_huge_page
+++ a/mm/hugetlb.c
@@ -1211,7 +1211,7 @@ static int hstate_next_node_to_alloc(str
 }
 
 /*
- * helper for free_pool_huge_page() - return the previously saved
+ * helper for remove_pool_huge_page() - return the previously saved
  * node ["this node"] from which to free a huge page.  Advance the
  * next node id whether or not we find a free huge page to free so
  * that the next attempt to free addresses the next node.
@@ -1391,6 +1391,16 @@ static void update_and_free_page(struct
 	}
 }
 
+static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
+{
+	struct page *page, *t_page;
+
+	list_for_each_entry_safe(page, t_page, list, lru) {
+		update_and_free_page(h, page);
+		cond_resched();
+	}
+}
+
 struct hstate *size_to_hstate(unsigned long size)
 {
 	struct hstate *h;
@@ -1721,16 +1731,18 @@ static int alloc_pool_huge_page(struct h
 }
 
 /*
- * Free huge page from pool from next node to free.
- * Attempt to keep persistent huge pages more or less
- * balanced over allowed nodes.
+ * Remove huge page from pool from next node to free.  Attempt to keep
+ * persistent huge pages more or less balanced over allowed nodes.
+ * This routine only 'removes' the hugetlb page.  The caller must make
+ * an additional call to free the page to low level allocators.
  * Called with hugetlb_lock locked.
  */
-static int free_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
-							 bool acct_surplus)
+static struct page *remove_pool_huge_page(struct hstate *h,
+						nodemask_t *nodes_allowed,
+						 bool acct_surplus)
 {
 	int nr_nodes, node;
-	int ret = 0;
+	struct page *page = NULL;
 
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
 		/*
@@ -1739,23 +1751,14 @@ static int free_pool_huge_page(struct hs
 		 */
 		if ((!acct_surplus || h->surplus_huge_pages_node[node]) &&
 		    !list_empty(&h->hugepage_freelists[node])) {
-			struct page *page =
-				list_entry(h->hugepage_freelists[node].next,
+			page = list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
 			remove_hugetlb_page(h, page, acct_surplus);
-			/*
-			 * unlock/lock around update_and_free_page is temporary
-			 * and will be removed with subsequent patch.
-			 */
-			spin_unlock(&hugetlb_lock);
-			update_and_free_page(h, page);
-			spin_lock(&hugetlb_lock);
-			ret = 1;
 			break;
 		}
 	}
 
-	return ret;
+	return page;
 }
 
 /*
@@ -2075,17 +2078,16 @@ free:
  *    to the associated reservation map.
  * 2) Free any unused surplus pages that may have been allocated to satisfy
  *    the reservation.  As many as unused_resv_pages may be freed.
- *
- * Called with hugetlb_lock held.  However, the lock could be dropped (and
- * reacquired) during calls to cond_resched_lock.  Whenever dropping the lock,
- * we must make sure nobody else can claim pages we are in the process of
- * freeing.  Do this by ensuring resv_huge_page always is greater than the
- * number of huge pages we plan to free when dropping the lock.
  */
 static void return_unused_surplus_pages(struct hstate *h,
 					unsigned long unused_resv_pages)
 {
 	unsigned long nr_pages;
+	struct page *page;
+	LIST_HEAD(page_list);
+
+	/* Uncommit the reservation */
+	h->resv_huge_pages -= unused_resv_pages;
 
 	/* Cannot return gigantic pages currently */
 	if (hstate_is_gigantic(h))
@@ -2102,24 +2104,21 @@ static void return_unused_surplus_pages(
 	 * evenly across all nodes with memory. Iterate across these nodes
 	 * until we can no longer free unreserved surplus pages. This occurs
 	 * when the nodes with surplus pages have no free pages.
-	 * free_pool_huge_page() will balance the freed pages across the
+	 * remove_pool_huge_page() will balance the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
-	 *
-	 * Note that we decrement resv_huge_pages as we free the pages.  If
-	 * we drop the lock, resv_huge_pages will still be sufficiently large
-	 * to cover subsequent pages we may free.
 	 */
 	while (nr_pages--) {
-		h->resv_huge_pages--;
-		unused_resv_pages--;
-		if (!free_pool_huge_page(h, &node_states[N_MEMORY], 1))
+		page = remove_pool_huge_page(h, &node_states[N_MEMORY], 1);
+		if (!page)
 			goto out;
-		cond_resched_lock(&hugetlb_lock);
+
+		list_add(&page->lru, &page_list);
 	}
 
 out:
-	/* Fully uncommit the reservation */
-	h->resv_huge_pages -= unused_resv_pages;
+	spin_unlock(&hugetlb_lock);
+	update_and_free_pages_bulk(h, &page_list);
+	spin_lock(&hugetlb_lock);
 }
 
 
@@ -2572,7 +2571,6 @@ static void try_to_free_low(struct hstat
 						nodemask_t *nodes_allowed)
 {
 	int i;
-	struct page *page, *next;
 	LIST_HEAD(page_list);
 
 	if (hstate_is_gigantic(h))
@@ -2582,6 +2580,7 @@ static void try_to_free_low(struct hstat
 	 * Collect pages to be freed on a list, and free after dropping lock
 	 */
 	for_each_node_mask(i, *nodes_allowed) {
+		struct page *page, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(page, next, freel, lru) {
 			if (count >= h->nr_huge_pages)
@@ -2595,10 +2594,7 @@ static void try_to_free_low(struct hstat
 
 out:
 	spin_unlock(&hugetlb_lock);
-	list_for_each_entry_safe(page, next, &page_list, lru) {
-		update_and_free_page(h, page);
-		cond_resched();
-	}
+	update_and_free_pages_bulk(h, &page_list);
 	spin_lock(&hugetlb_lock);
 }
 #else
@@ -2645,6 +2641,8 @@ static int set_max_huge_pages(struct hst
 			      nodemask_t *nodes_allowed)
 {
 	unsigned long min_count, ret;
+	struct page *page;
+	LIST_HEAD(page_list);
 	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
 
 	/*
@@ -2757,11 +2755,22 @@ static int set_max_huge_pages(struct hst
 	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
 	min_count = max(count, min_count);
 	try_to_free_low(h, min_count, nodes_allowed);
+
+	/*
+	 * Collect pages to be removed on list without dropping lock
+	 */
 	while (min_count < persistent_huge_pages(h)) {
-		if (!free_pool_huge_page(h, nodes_allowed, 0))
+		page = remove_pool_huge_page(h, nodes_allowed, 0);
+		if (!page)
 			break;
-		cond_resched_lock(&hugetlb_lock);
+
+		list_add(&page->lru, &page_list);
 	}
+	/* free the pages after dropping lock */
+	spin_unlock(&hugetlb_lock);
+	update_and_free_pages_bulk(h, &page_list);
+	spin_lock(&hugetlb_lock);
+
 	while (count < persistent_huge_pages(h)) {
 		if (!adjust_pool_surplus(h, nodes_allowed, 1))
 			break;
_
