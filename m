From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:17 -0700
Message-ID: <20120613204618.1CC12A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36795 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2FMUqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:20 -0400
Received: by wgbdt11 with SMTP id dt11so60137wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch

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
Subject: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup

Add the charge and uncharge routines for hugetlb cgroup.  We do cgroup
charging in page alloc and uncharge in compound page destructor. 
Assigning page's hugetlb cgroup is protected by hugetlb_lock.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
@@ -113,6 +113,86 @@ static int hugetlb_cgroup_pre_destroy(st
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
+	if (!h_cg)
+		h_cg = root_h_cgroup;
+
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
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
_
Subject: Subject: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup

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

