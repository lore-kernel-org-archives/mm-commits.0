From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:07 -0700
Message-ID: <20120611211007.66A9DA03E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54380 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKVKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:08 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so382695qab.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: add a list for tracking in-use HugeTLB pages
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlbfs: add a list for tracking in-use HugeTLB pages

hugepage_activelist will be used to track currently used HugeTLB pages. 
We need to find the in-use HugeTLB pages to support memcg removal.  On
memcg removal we update the page's memory cgroup to point to parent
cgroup.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |   12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages
+++ a/include/linux/hugetlb.h
@@ -212,6 +212,7 @@ struct hstate {
 	unsigned long resv_huge_pages;
 	unsigned long surplus_huge_pages;
 	unsigned long nr_overcommit_huge_pages;
+	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
diff -puN mm/hugetlb.c~hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -512,7 +512,7 @@ void copy_huge_page(struct page *dst, st
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
-	list_add(&page->lru, &h->hugepage_freelists[nid]);
+	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
 }
@@ -524,7 +524,7 @@ static struct page *dequeue_huge_page_no
 	if (list_empty(&h->hugepage_freelists[nid]))
 		return NULL;
 	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
-	list_del(&page->lru);
+	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
@@ -628,12 +628,13 @@ static void free_huge_page(struct page *
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
-	INIT_LIST_HEAD(&page->lru);
 
 	mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
 					 pages_per_huge_page(h), page);
 	spin_lock(&hugetlb_lock);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
+		/* remove the page from active list */
+		list_del(&page->lru);
 		update_and_free_page(h, page);
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
@@ -646,6 +647,7 @@ static void free_huge_page(struct page *
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
+	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, free_huge_page);
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
@@ -894,6 +896,7 @@ static struct page *alloc_buddy_huge_pag
 
 	spin_lock(&hugetlb_lock);
 	if (page) {
+		INIT_LIST_HEAD(&page->lru);
 		r_nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
 		/*
@@ -998,7 +1001,6 @@ retry:
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
 			break;
-		list_del(&page->lru);
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
@@ -1013,7 +1015,6 @@ free:
 	/* Free unnecessary surplus pages to the buddy allocator */
 	if (!list_empty(&surplus_list)) {
 		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
-			list_del(&page->lru);
 			put_page(page);
 		}
 	}
@@ -1927,6 +1928,7 @@ void __init hugetlb_add_hstate(unsigned 
 	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+	INIT_LIST_HEAD(&h->hugepage_activelist);
 	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
 	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

