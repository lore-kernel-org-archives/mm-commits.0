From: akpm@linux-foundation.org
Subject: + hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:16:07 -0700
Message-ID: <20120416231607.CB55DA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55690 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2DPXQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:16:08 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so4979qab.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:16:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb: add charge/uncharge calls for HugeTLB alloc/free
has been added to the -mm tree.  Its filename is
     hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch

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
Subject: hugetlb: add charge/uncharge calls for HugeTLB alloc/free

This adds necessary charge/uncharge calls in the HugeTLB code.  We do
memcg charge in page alloc and uncharge in compound page destructor.  We
also need to ignore HugeTLB pages in __mem_cgroup_uncharge_common because
that get called from delete_from_page_cache

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c    |   20 +++++++++++++++++++-
 mm/memcontrol.c |    5 +++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free
+++ a/mm/hugetlb.c
@@ -21,6 +21,8 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/memcontrol.h>
+#include <linux/page_cgroup.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -628,6 +630,8 @@ static void free_huge_page(struct page *
 	BUG_ON(page_mapcount(page));
 	INIT_LIST_HEAD(&page->lru);
 
+	mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
+					 pages_per_huge_page(h), page);
 	spin_lock(&hugetlb_lock);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		update_and_free_page(h, page);
@@ -1113,7 +1117,10 @@ static struct page *alloc_huge_page(stru
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	long chg;
+	int ret, idx;
+	struct mem_cgroup *memcg;
 
+	idx = hstate_index(h);
 	/*
 	 * Processes that did not create the mapping will have no
 	 * reserves and will not have accounted against subpool
@@ -1129,6 +1136,12 @@ static struct page *alloc_huge_page(stru
 		if (hugepage_subpool_get_pages(spool, chg))
 			return ERR_PTR(-ENOSPC);
 
+	ret = mem_cgroup_hugetlb_charge_page(idx, pages_per_huge_page(h),
+					     &memcg);
+	if (ret) {
+		hugepage_subpool_put_pages(spool, chg);
+		return ERR_PTR(-ENOSPC);
+	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
 	spin_unlock(&hugetlb_lock);
@@ -1136,6 +1149,9 @@ static struct page *alloc_huge_page(stru
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
+			mem_cgroup_hugetlb_uncharge_memcg(idx,
+							  pages_per_huge_page(h),
+							  memcg);
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
@@ -1144,7 +1160,9 @@ static struct page *alloc_huge_page(stru
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-
+	/* update page cgroup details */
+	mem_cgroup_hugetlb_commit_charge(idx, pages_per_huge_page(h),
+					 memcg, page);
 	return page;
 }
 
diff -puN mm/memcontrol.c~hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free mm/memcontrol.c
--- a/mm/memcontrol.c~hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free
+++ a/mm/memcontrol.c
@@ -2966,6 +2966,11 @@ __mem_cgroup_uncharge_common(struct page
 
 	if (PageSwapCache(page))
 		return NULL;
+	/*
+	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
+	 */
+	if (PageHuge(page))
+		return NULL;
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
_
Subject: Subject: hugetlb: add charge/uncharge calls for HugeTLB alloc/free

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

