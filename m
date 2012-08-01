From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:37 -0700
Message-ID: <20120801201237.DD6F91E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:12:39 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:12:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liwp.linux@gmail.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup

Add the charge and uncharge routines for hugetlb cgroup.  We do cgroup
charging in page alloc and uncharge in compound page destructor. 
Assigning page's hugetlb cgroup is protected by hugetlb_lock.

[liwp@linux.vnet.ibm.com: add huge_page_order check to avoid incorrect uncharge]
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   38 ++++++++++++++
 mm/hugetlb.c                   |   16 +++++-
 mm/hugetlb_cgroup.c            |   80 +++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb_cgroup.h~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup
+++ a/include/linux/hugetlb_cgroup.h
@@ -53,6 +53,16 @@ static inline bool hugetlb_cgroup_disabl
 	return false;
 }
 
+extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+					struct hugetlb_cgroup **ptr);
+extern void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+					 struct hugetlb_cgroup *h_cg,
+					 struct page *page);
+extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+					 struct page *page);
+extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+					   struct hugetlb_cgroup *h_cg);
+
 #else
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 {
@@ -70,5 +80,33 @@ static inline bool hugetlb_cgroup_disabl
 	return true;
 }
 
+static inline int
+hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+			     struct hugetlb_cgroup **ptr)
+{
+	return 0;
+}
+
+static inline void
+hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+			     struct hugetlb_cgroup *h_cg,
+			     struct page *page)
+{
+	return;
+}
+
+static inline void
+hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages, struct page *page)
+{
+	return;
+}
+
+static inline void
+hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+			       struct hugetlb_cgroup *h_cg)
+{
+	return;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif
diff -puN mm/hugetlb.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup
+++ a/mm/hugetlb.c
@@ -627,6 +627,8 @@ static void free_huge_page(struct page *
 	BUG_ON(page_mapcount(page));
 
 	spin_lock(&hugetlb_lock);
+	hugetlb_cgroup_uncharge_page(hstate_index(h),
+				     pages_per_huge_page(h), page);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		/* remove the page from active list */
 		list_del(&page->lru);
@@ -1115,7 +1117,10 @@ static struct page *alloc_huge_page(stru
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	long chg;
+	int ret, idx;
+	struct hugetlb_cgroup *h_cg;
 
+	idx = hstate_index(h);
 	/*
 	 * Processes that did not create the mapping will have no
 	 * reserves and will not have accounted against subpool
@@ -1131,6 +1136,11 @@ static struct page *alloc_huge_page(stru
 		if (hugepage_subpool_get_pages(spool, chg))
 			return ERR_PTR(-ENOSPC);
 
+	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
+	if (ret) {
+		hugepage_subpool_put_pages(spool, chg);
+		return ERR_PTR(-ENOSPC);
+	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
 	spin_unlock(&hugetlb_lock);
@@ -1138,6 +1148,9 @@ static struct page *alloc_huge_page(stru
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
+			hugetlb_cgroup_uncharge_cgroup(idx,
+						       pages_per_huge_page(h),
+						       h_cg);
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
@@ -1146,7 +1159,8 @@ static struct page *alloc_huge_page(stru
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-
+	/* update page cgroup details */
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	return page;
 }
 
diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup
+++ a/mm/hugetlb_cgroup.c
@@ -111,6 +111,86 @@ static int hugetlb_cgroup_pre_destroy(st
 	   return -EBUSY;
 }
 
+int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+				 struct hugetlb_cgroup **ptr)
+{
+	int ret = 0;
+	struct res_counter *fail_res;
+	struct hugetlb_cgroup *h_cg = NULL;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled())
+		goto done;
+	/*
+	 * We don't charge any cgroup if the compound page have less
+	 * than 3 pages.
+	 */
+	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
+		goto done;
+again:
+	rcu_read_lock();
+	h_cg = hugetlb_cgroup_from_task(current);
+	if (!css_tryget(&h_cg->css)) {
+		rcu_read_unlock();
+		goto again;
+	}
+	rcu_read_unlock();
+
+	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
+	css_put(&h_cg->css);
+done:
+	*ptr = h_cg;
+	return ret;
+}
+
+void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+				  struct hugetlb_cgroup *h_cg,
+				  struct page *page)
+{
+	if (hugetlb_cgroup_disabled() || !h_cg)
+		return;
+
+	spin_lock(&hugetlb_lock);
+	set_hugetlb_cgroup(page, h_cg);
+	spin_unlock(&hugetlb_lock);
+	return;
+}
+
+/*
+ * Should be called with hugetlb_lock held
+ */
+void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+				  struct page *page)
+{
+	struct hugetlb_cgroup *h_cg;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled())
+		return;
+	VM_BUG_ON(!spin_is_locked(&hugetlb_lock));
+	h_cg = hugetlb_cgroup_from_page(page);
+	if (unlikely(!h_cg))
+		return;
+	set_hugetlb_cgroup(page, NULL);
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
+void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+				    struct hugetlb_cgroup *h_cg)
+{
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled() || !h_cg)
+		return;
+
+	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
+		return;
+
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

