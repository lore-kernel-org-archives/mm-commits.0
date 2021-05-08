Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D07C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9456101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWsn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWsm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E36E7613E8;
        Sat,  8 May 2021 22:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514060;
        bh=HmRnTDxHQdB62xY2iLnjYq073ump6W6o/K8fPy4PdYE=;
        h=Date:From:To:Subject:From;
        b=auMGUVDFzPYSHCAYsdYBcCNwC+Im2sUsxcLbwtI4xFP78suKrNMdUI2gJ+qwSiOIW
         4UtjE0ainlGC5TnrFwRga9IekIIj8SH7VfdMQcrF6vfyI+dfdHeRCdGDlzdYSX2Mmv
         v6lWn2Vb23CUP041zkn1mSgZNw0c4GTAS1QX8oGw=
Date:   Sat, 08 May 2021 15:47:39 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.ibm.com,
        david@redhat.com, guro@fb.com, hdanton@sina.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, longman@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, peterz@infradead.org,
        rientjes@google.com, shakeelb@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        will@kernel.org, willy@infradead.org
Subject:  [merged] hugetlb-make-free_huge_page-irq-safe.patch
 removed from -mm tree
Message-ID: <20210508224739.SJKZr09cW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: make free_huge_page irq safe
has been removed from the -mm tree.  Its filename was
     hugetlb-make-free_huge_page-irq-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: make free_huge_page irq safe

Commit c77c0a8ac4c5 ("mm/hugetlb: defer freeing of huge pages if in
non-task context") was added to address the issue of free_huge_page being
called from irq context.  That commit hands off free_huge_page processing
to a workqueue if !in_task.  However, this doesn't cover all the cases as
pointed out by 0day bot lockdep report [1].

:  Possible interrupt unsafe locking scenario:
:
:        CPU0                    CPU1
:        ----                    ----
:   lock(hugetlb_lock);
:                                local_irq_disable();
:                                lock(slock-AF_INET);
:                                lock(hugetlb_lock);
:   <Interrupt>
:     lock(slock-AF_INET);

Shakeel has later explained that this is very likely TCP TX zerocopy from
hugetlb pages scenario when the networking code drops a last reference to
hugetlb page while having IRQ disabled.  Hugetlb freeing path doesn't
disable IRQ while holding hugetlb_lock so a lock dependency chain can lead
to a deadlock.

This commit addresses the issue by doing the following:
- Make hugetlb_lock irq safe.  This is mostly a simple process of
  changing spin_*lock calls to spin_*lock_irq* calls.
- Make subpool lock irq safe in a similar manner.
- Revert the !in_task check and workqueue handoff.

[1] https://lore.kernel.org/linux-mm/000000000000f1c03b05bc43aadc@google.com/

Link: https://lkml.kernel.org/r/20210409205254.242291-8-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
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

 mm/hugetlb.c        |  169 +++++++++++++++---------------------------
 mm/hugetlb_cgroup.c |    8 -
 2 files changed, 67 insertions(+), 110 deletions(-)

--- a/mm/hugetlb.c~hugetlb-make-free_huge_page-irq-safe
+++ a/mm/hugetlb.c
@@ -94,9 +94,10 @@ static inline bool subpool_is_free(struc
 	return true;
 }
 
-static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
+static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
+						unsigned long irq_flags)
 {
-	spin_unlock(&spool->lock);
+	spin_unlock_irqrestore(&spool->lock, irq_flags);
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
@@ -135,10 +136,12 @@ struct hugepage_subpool *hugepage_new_su
 
 void hugepage_put_subpool(struct hugepage_subpool *spool)
 {
-	spin_lock(&spool->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&spool->lock, flags);
 	BUG_ON(!spool->count);
 	spool->count--;
-	unlock_or_release_subpool(spool);
+	unlock_or_release_subpool(spool, flags);
 }
 
 /*
@@ -157,7 +160,7 @@ static long hugepage_subpool_get_pages(s
 	if (!spool)
 		return ret;
 
-	spin_lock(&spool->lock);
+	spin_lock_irq(&spool->lock);
 
 	if (spool->max_hpages != -1) {		/* maximum size accounting */
 		if ((spool->used_hpages + delta) <= spool->max_hpages)
@@ -184,7 +187,7 @@ static long hugepage_subpool_get_pages(s
 	}
 
 unlock_ret:
-	spin_unlock(&spool->lock);
+	spin_unlock_irq(&spool->lock);
 	return ret;
 }
 
@@ -198,11 +201,12 @@ static long hugepage_subpool_put_pages(s
 				       long delta)
 {
 	long ret = delta;
+	unsigned long flags;
 
 	if (!spool)
 		return delta;
 
-	spin_lock(&spool->lock);
+	spin_lock_irqsave(&spool->lock, flags);
 
 	if (spool->max_hpages != -1)		/* maximum size accounting */
 		spool->used_hpages -= delta;
@@ -223,7 +227,7 @@ static long hugepage_subpool_put_pages(s
 	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
 	 * quota reference, free it now.
 	 */
-	unlock_or_release_subpool(spool);
+	unlock_or_release_subpool(spool, flags);
 
 	return ret;
 }
@@ -1412,7 +1416,7 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-static void __free_huge_page(struct page *page)
+void free_huge_page(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
@@ -1422,6 +1426,7 @@ static void __free_huge_page(struct page
 	int nid = page_to_nid(page);
 	struct hugepage_subpool *spool = hugetlb_page_subpool(page);
 	bool restore_reserve;
+	unsigned long flags;
 
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(page_mapcount(page), page);
@@ -1450,7 +1455,7 @@ static void __free_huge_page(struct page
 			restore_reserve = true;
 	}
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irqsave(&hugetlb_lock, flags);
 	ClearHPageMigratable(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
@@ -1461,66 +1466,18 @@ static void __free_huge_page(struct page
 
 	if (HPageTemporary(page)) {
 		remove_hugetlb_page(h, page, false);
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		remove_hugetlb_page(h, page, true);
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page);
 	} else {
 		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
-		spin_unlock(&hugetlb_lock);
-	}
-}
-
-/*
- * As free_huge_page() can be called from a non-task context, we have
- * to defer the actual freeing in a workqueue to prevent potential
- * hugetlb_lock deadlock.
- *
- * free_hpage_workfn() locklessly retrieves the linked list of pages to
- * be freed and frees them one-by-one. As the page->mapping pointer is
- * going to be cleared in __free_huge_page() anyway, it is reused as the
- * llist_node structure of a lockless linked list of huge pages to be freed.
- */
-static LLIST_HEAD(hpage_freelist);
-
-static void free_hpage_workfn(struct work_struct *work)
-{
-	struct llist_node *node;
-	struct page *page;
-
-	node = llist_del_all(&hpage_freelist);
-
-	while (node) {
-		page = container_of((struct address_space **)node,
-				     struct page, mapping);
-		node = node->next;
-		__free_huge_page(page);
-	}
-}
-static DECLARE_WORK(free_hpage_work, free_hpage_workfn);
-
-void free_huge_page(struct page *page)
-{
-	/*
-	 * Defer freeing if in non-task context to avoid hugetlb_lock deadlock.
-	 */
-	if (!in_task()) {
-		/*
-		 * Only call schedule_work() if hpage_freelist is previously
-		 * empty. Otherwise, schedule_work() had been called but the
-		 * workfn hasn't retrieved the list yet.
-		 */
-		if (llist_add((struct llist_node *)&page->mapping,
-			      &hpage_freelist))
-			schedule_work(&free_hpage_work);
-		return;
+		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-
-	__free_huge_page(page);
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -1530,11 +1487,11 @@ static void prep_new_huge_page(struct hs
 	hugetlb_set_page_subpool(page, NULL);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	ClearHPageFreed(page);
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 }
 
 static void prep_compound_gigantic_page(struct page *page, unsigned int order)
@@ -1780,7 +1737,7 @@ retry:
 	if (!PageHuge(page))
 		return 0;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	if (!PageHuge(page)) {
 		rc = 0;
 		goto out;
@@ -1797,7 +1754,7 @@ retry:
 		 * when it is dissolved.
 		 */
 		if (unlikely(!HPageFreed(head))) {
-			spin_unlock(&hugetlb_lock);
+			spin_unlock_irq(&hugetlb_lock);
 			cond_resched();
 
 			/*
@@ -1821,12 +1778,12 @@ retry:
 		}
 		remove_hugetlb_page(h, page, false);
 		h->max_huge_pages--;
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 		update_and_free_page(h, head);
 		return 0;
 	}
 out:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	return rc;
 }
 
@@ -1868,16 +1825,16 @@ static struct page *alloc_surplus_huge_p
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages)
 		goto out_unlock;
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask, NULL);
 	if (!page)
 		return NULL;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -1887,7 +1844,7 @@ static struct page *alloc_surplus_huge_p
 	 */
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		SetHPageTemporary(page);
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 		put_page(page);
 		return NULL;
 	} else {
@@ -1896,7 +1853,7 @@ static struct page *alloc_surplus_huge_p
 	}
 
 out_unlock:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	return page;
 }
@@ -1946,17 +1903,17 @@ struct page *alloc_buddy_huge_page_with_
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0) {
 		struct page *page;
 
 		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
 		if (page) {
-			spin_unlock(&hugetlb_lock);
+			spin_unlock_irq(&hugetlb_lock);
 			return page;
 		}
 	}
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	return alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
@@ -2004,7 +1961,7 @@ static int gather_surplus_pages(struct h
 
 	ret = -ENOMEM;
 retry:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		page = alloc_surplus_huge_page(h, htlb_alloc_mask(h),
 				NUMA_NO_NODE, NULL);
@@ -2021,7 +1978,7 @@ retry:
 	 * After retaking hugetlb_lock, we need to recalculate 'needed'
 	 * because either resv_huge_pages or free_huge_pages may have changed.
 	 */
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) -
 			(h->free_huge_pages + allocated);
 	if (needed > 0) {
@@ -2061,12 +2018,12 @@ retry:
 		enqueue_huge_page(h, page);
 	}
 free:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
 		put_page(page);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
 }
@@ -2116,9 +2073,9 @@ static void return_unused_surplus_pages(
 	}
 
 out:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	update_and_free_pages_bulk(h, &page_list);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 }
 
 
@@ -2352,7 +2309,7 @@ struct page *alloc_huge_page(struct vm_a
 	if (ret)
 		goto out_uncharge_cgroup_reservation;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * glb_chg is passed to indicate whether or not a page must be taken
 	 * from the global free pool (global change).  gbl_chg == 0 indicates
@@ -2360,7 +2317,7 @@ struct page *alloc_huge_page(struct vm_a
 	 */
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
 	if (!page) {
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
@@ -2368,7 +2325,7 @@ struct page *alloc_huge_page(struct vm_a
 			SetHPageRestoreReserve(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock(&hugetlb_lock);
+		spin_lock_irq(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
@@ -2381,7 +2338,7 @@ struct page *alloc_huge_page(struct vm_a
 						  h_cg, page);
 	}
 
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	hugetlb_set_page_subpool(page, spool);
 
@@ -2593,9 +2550,9 @@ static void try_to_free_low(struct hstat
 	}
 
 out:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	update_and_free_pages_bulk(h, &page_list);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 }
 #else
 static inline void try_to_free_low(struct hstate *h, unsigned long count,
@@ -2660,7 +2617,7 @@ static int set_max_huge_pages(struct hst
 	 * pages in hstate via the proc/sysfs interfaces.
 	 */
 	mutex_lock(&h->resize_lock);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 
 	/*
 	 * Check for a node specific request.
@@ -2691,7 +2648,7 @@ static int set_max_huge_pages(struct hst
 	 */
 	if (hstate_is_gigantic(h) && !IS_ENABLED(CONFIG_CONTIG_ALLOC)) {
 		if (count > persistent_huge_pages(h)) {
-			spin_unlock(&hugetlb_lock);
+			spin_unlock_irq(&hugetlb_lock);
 			mutex_unlock(&h->resize_lock);
 			NODEMASK_FREE(node_alloc_noretry);
 			return -EINVAL;
@@ -2721,14 +2678,14 @@ static int set_max_huge_pages(struct hst
 		 * page, free_huge_page will handle it by freeing the page
 		 * and reducing the surplus.
 		 */
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 
 		/* yield cpu to avoid soft lockup */
 		cond_resched();
 
 		ret = alloc_pool_huge_page(h, nodes_allowed,
 						node_alloc_noretry);
-		spin_lock(&hugetlb_lock);
+		spin_lock_irq(&hugetlb_lock);
 		if (!ret)
 			goto out;
 
@@ -2767,9 +2724,9 @@ static int set_max_huge_pages(struct hst
 		list_add(&page->lru, &page_list);
 	}
 	/* free the pages after dropping lock */
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	update_and_free_pages_bulk(h, &page_list);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 
 	while (count < persistent_huge_pages(h)) {
 		if (!adjust_pool_surplus(h, nodes_allowed, 1))
@@ -2777,7 +2734,7 @@ static int set_max_huge_pages(struct hst
 	}
 out:
 	h->max_huge_pages = persistent_huge_pages(h);
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	mutex_unlock(&h->resize_lock);
 
 	NODEMASK_FREE(node_alloc_noretry);
@@ -2933,9 +2890,9 @@ static ssize_t nr_overcommit_hugepages_s
 	if (err)
 		return err;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	h->nr_overcommit_huge_pages = input;
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	return count;
 }
@@ -3522,9 +3479,9 @@ int hugetlb_overcommit_handler(struct ct
 		goto out;
 
 	if (write) {
-		spin_lock(&hugetlb_lock);
+		spin_lock_irq(&hugetlb_lock);
 		h->nr_overcommit_huge_pages = tmp;
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 	}
 out:
 	return ret;
@@ -3620,7 +3577,7 @@ static int hugetlb_acct_memory(struct hs
 	if (!delta)
 		return 0;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * When cpuset is configured, it breaks the strict hugetlb page
 	 * reservation as the accounting is done on a global variable. Such
@@ -3659,7 +3616,7 @@ static int hugetlb_acct_memory(struct hs
 		return_unused_surplus_pages(h, (unsigned long) -delta);
 
 out:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	return ret;
 }
 
@@ -5687,7 +5644,7 @@ bool isolate_huge_page(struct page *page
 {
 	bool ret = true;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	if (!PageHeadHuge(page) ||
 	    !HPageMigratable(page) ||
 	    !get_page_unless_zero(page)) {
@@ -5697,16 +5654,16 @@ bool isolate_huge_page(struct page *page
 	ClearHPageMigratable(page);
 	list_move_tail(&page->lru, list);
 unlock:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	return ret;
 }
 
 void putback_active_hugepage(struct page *page)
 {
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	SetHPageMigratable(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	put_page(page);
 }
 
@@ -5740,12 +5697,12 @@ void move_hugetlb_state(struct page *old
 		 */
 		if (new_nid == old_nid)
 			return;
-		spin_lock(&hugetlb_lock);
+		spin_lock_irq(&hugetlb_lock);
 		if (h->surplus_huge_pages_node[old_nid]) {
 			h->surplus_huge_pages_node[old_nid]--;
 			h->surplus_huge_pages_node[new_nid]++;
 		}
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 	}
 }
 
--- a/mm/hugetlb_cgroup.c~hugetlb-make-free_huge_page-irq-safe
+++ a/mm/hugetlb_cgroup.c
@@ -204,11 +204,11 @@ static void hugetlb_cgroup_css_offline(s
 	do {
 		idx = 0;
 		for_each_hstate(h) {
-			spin_lock(&hugetlb_lock);
+			spin_lock_irq(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru)
 				hugetlb_cgroup_move_parent(idx, h_cg, page);
 
-			spin_unlock(&hugetlb_lock);
+			spin_unlock_irq(&hugetlb_lock);
 			idx++;
 		}
 		cond_resched();
@@ -784,7 +784,7 @@ void hugetlb_cgroup_migrate(struct page
 	if (hugetlb_cgroup_disabled())
 		return;
 
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
@@ -794,7 +794,7 @@ void hugetlb_cgroup_migrate(struct page
 	set_hugetlb_cgroup(newhpage, h_cg);
 	set_hugetlb_cgroup_rsvd(newhpage, h_cg_rsvd);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 	return;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


