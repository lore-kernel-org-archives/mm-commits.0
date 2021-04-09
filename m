Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ACEC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D7761177
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhDIFHB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhDIFGo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C6C611AB;
        Fri,  9 Apr 2021 05:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944781;
        bh=oUtGULBMefuASrfuPjGN4oNDUhCCk4wrzOaiTms02Go=;
        h=Date:From:To:Subject:From;
        b=SIVi34IIdhRT6dQBKEiFDuP31eApY4pxvP4OkFsJHBX7pk6khSY0tAhKFPPiLEzn8
         +Y0ZiZxJ1iim7Kf4hd/NjgqfZtqRvBMBy8Vy+NOF9LXJgwaH6INa4+tGNO+itjpSiw
         VFMDOXhFxpAGa+CFFmmCo3c4NjAlZvq5Wpd6thS8=
Date:   Thu, 08 Apr 2021 22:06:20 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.ibm.com,
        david@redhat.com, guro@fb.com, hdanton@sina.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, longman@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, peterz@infradead.org,
        rientjes@google.com, shakeelb@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        will@kernel.org, willy@infradead.org
Subject:  [to-be-updated]
 hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch removed from
 -mm tree
Message-ID: <20210409050620.emYqjbAs2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add lockdep_assert_held() calls for hugetlb_lock
has been removed from the -mm tree.  Its filename was
     hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add lockdep_assert_held() calls for hugetlb_lock

After making hugetlb lock irq safe and separating some functionality done
under the lock, add some lockdep_assert_held to help verify locking.

Link: https://lkml.kernel.org/r/20210331034148.112624-9-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -1069,6 +1069,8 @@ static void __enqueue_huge_page(struct l
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
+
+	lockdep_assert_held(&hugetlb_lock);
 	__enqueue_huge_page(&h->hugepage_freelists[nid], page);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
@@ -1079,6 +1081,7 @@ static struct page *dequeue_huge_page_no
 	struct page *page;
 	bool nocma = !!(current->flags & PF_MEMALLOC_NOCMA);
 
+	lockdep_assert_held(&hugetlb_lock);
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
 		if (nocma && is_migrate_cma_page(page))
 			continue;
@@ -1347,6 +1350,7 @@ static void remove_hugetlb_page(struct h
 {
 	int nid = page_to_nid(page);
 
+	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
@@ -1702,6 +1706,7 @@ static struct page *remove_pool_huge_pag
 	int nr_nodes, node;
 	struct page *page = NULL;
 
+	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
 		/*
 		 * If we're returning unused surplus pages, only examine
@@ -1951,6 +1956,7 @@ static int gather_surplus_pages(struct h
 	long needed, allocated;
 	bool alloc_ok = true;
 
+	lockdep_assert_held(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
@@ -2044,6 +2050,7 @@ static void return_unused_surplus_pages(
 	struct page *page;
 	LIST_HEAD(page_list);
 
+	lockdep_assert_held(&hugetlb_lock);
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
@@ -2642,6 +2649,7 @@ static void try_to_free_low(struct hstat
 	int i;
 	LIST_HEAD(page_list);
 
+	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h))
 		return;
 
@@ -2683,6 +2691,7 @@ static int adjust_pool_surplus(struct hs
 {
 	int nr_nodes, node;
 
+	lockdep_assert_held(&hugetlb_lock);
 	VM_BUG_ON(delta != -1 && delta != 1);
 
 	if (delta < 0) {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


