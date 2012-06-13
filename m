From: akpm@linux-foundation.org
Subject: + hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:09 -0700
Message-ID: <20120613204610.0012FA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35262 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2FMUqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:10 -0400
Received: by mail-gg0-f202.google.com with SMTP id h3so89256gge.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb: add a list for tracking in-use HugeTLB pages
has been added to the -mm tree.  Its filename is
     hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: add a list for tracking in-use HugeTLB pages

hugepage_activelist will be used to track currently used HugeTLB pages.
We need to find the in-use HugeTLB pages to support HugeTLB cgroup removal.
On cgroup removal we update the page's HugeTLB cgroup to point to parent
cgroup.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |   12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages
+++ a/include/linux/hugetlb.h
@@ -211,6 +211,7 @@ struct hstate {
 	unsigned long resv_huge_pages;
 	unsigned long surplus_huge_pages;
 	unsigned long nr_overcommit_huge_pages;
+	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
diff -puN mm/hugetlb.c~hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -510,7 +510,7 @@ void copy_huge_page(struct page *dst, st
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
-	list_add(&page->lru, &h->hugepage_freelists[nid]);
+	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
 }
@@ -522,7 +522,7 @@ static struct page *dequeue_huge_page_no
 	if (list_empty(&h->hugepage_freelists[nid]))
 		return NULL;
 	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
-	list_del(&page->lru);
+	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
@@ -626,10 +626,11 @@ static void free_huge_page(struct page *
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
-	INIT_LIST_HEAD(&page->lru);
 
 	spin_lock(&hugetlb_lock);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
+		/* remove the page from active list */
+		list_del(&page->lru);
 		update_and_free_page(h, page);
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
@@ -642,6 +643,7 @@ static void free_huge_page(struct page *
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
+	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, free_huge_page);
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
@@ -890,6 +892,7 @@ static struct page *alloc_buddy_huge_pag
 
 	spin_lock(&hugetlb_lock);
 	if (page) {
+		INIT_LIST_HEAD(&page->lru);
 		r_nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
 		/*
@@ -994,7 +997,6 @@ retry:
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
 			break;
-		list_del(&page->lru);
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
@@ -1009,7 +1011,6 @@ free:
 	/* Free unnecessary surplus pages to the buddy allocator */
 	if (!list_empty(&surplus_list)) {
 		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
-			list_del(&page->lru);
 			put_page(page);
 		}
 	}
@@ -1909,6 +1910,7 @@ void __init hugetlb_add_hstate(unsigned 
 	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+	INIT_LIST_HEAD(&h->hugepage_activelist);
 	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
 	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
_
Subject: Subject: hugetlb: add a list for tracking in-use HugeTLB pages

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch

