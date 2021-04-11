Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3FEC433ED
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65516611CE
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhDKWcN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhDKWcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B51611AD;
        Sun, 11 Apr 2021 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618180316;
        bh=4e5XQcd1wSIPHBodUAK4BxfGyPWols3IbI+ht597xp8=;
        h=Date:From:To:Subject:From;
        b=DSM0Rhv+I1YbY3SZqb1VQNHm0VjHclk7iiv7fE1Z5FlQCNlZTFsvwzwlk9eXVdGDz
         u5W9aVLQzAua7Mt15OBBpvM5veyzBKcVkNLVIgoGw+AYWhox7nzzQLBZBhWRV8ZOcD
         8+nC2fcmyrn67CHYe6GI50pygn9Nh+hfOFM1cFNQ=
Date:   Sun, 11 Apr 2021 15:31:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        songmuchun@bytedance.com, song.bao.hua@hisilicon.com,
        shakeelb@google.com, rientjes@google.com, peterz@infradead.org,
        peterx@redhat.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        mhocko@suse.com, longman@redhat.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hdanton@sina.com, guro@fb.com,
        david@redhat.com, aneesh.kumar@linux.ibm.com,
        almasrymina@google.com, mike.kravetz@oracle.com
Subject:  +
 hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch added to -mm
 tree
Message-ID: <20210411223155.94Z73%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add lockdep_assert_held() calls for hugetlb_lock
has been added to the -mm tree.  Its filename is
     hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add lockdep_assert_held() calls for hugetlb_lock

After making hugetlb lock irq safe and separating some functionality done
under the lock, add some lockdep_assert_held to help verify locking.

Link: https://lkml.kernel.org/r/20210409205254.242291-9-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
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
Cc: Mina Almasry <almasrymina@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/hugetlb.c~hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock
+++ a/mm/hugetlb.c
@@ -1069,6 +1069,8 @@ static bool vma_has_reserves(struct vm_a
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
+
+	lockdep_assert_held(&hugetlb_lock);
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
@@ -1080,6 +1082,7 @@ static struct page *dequeue_huge_page_no
 	struct page *page;
 	bool nocma = !!(current->flags & PF_MEMALLOC_NOCMA);
 
+	lockdep_assert_held(&hugetlb_lock);
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
 		if (nocma && is_migrate_cma_page(page))
 			continue;
@@ -1351,6 +1354,7 @@ static void remove_hugetlb_page(struct h
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page_rsvd(page), page);
 
+	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
@@ -1701,6 +1705,7 @@ static struct page *remove_pool_huge_pag
 	int nr_nodes, node;
 	struct page *page = NULL;
 
+	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
 		/*
 		 * If we're returning unused surplus pages, only examine
@@ -1950,6 +1955,7 @@ static int gather_surplus_pages(struct h
 	long needed, allocated;
 	bool alloc_ok = true;
 
+	lockdep_assert_held(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
@@ -2043,6 +2049,7 @@ static void return_unused_surplus_pages(
 	struct page *page;
 	LIST_HEAD(page_list);
 
+	lockdep_assert_held(&hugetlb_lock);
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
@@ -2530,6 +2537,7 @@ static void try_to_free_low(struct hstat
 	int i;
 	LIST_HEAD(page_list);
 
+	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h))
 		return;
 
@@ -2571,6 +2579,7 @@ static int adjust_pool_surplus(struct hs
 {
 	int nr_nodes, node;
 
+	lockdep_assert_held(&hugetlb_lock);
 	VM_BUG_ON(delta != -1 && delta != 1);
 
 	if (delta < 0) {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-cma-change-cma-mutex-to-irq-safe-spinlock.patch
hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch
hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch
hugetlb-create-remove_hugetlb_page-to-separate-functionality.patch
hugetlb-call-update_and_free_page-without-hugetlb_lock.patch
hugetlb-change-free_pool_huge_page-to-remove_pool_huge_page.patch
hugetlb-make-free_huge_page-irq-safe.patch
hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

