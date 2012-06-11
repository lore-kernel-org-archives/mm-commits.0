From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:09 -0700
Message-ID: <20120611211009.6F232A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49946 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKVKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:10 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so124916qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move HugeTLB resource count to parent cgroup on memcg removal
has been removed from the -mm tree.  Its filename was
     memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: memcg: move HugeTLB resource count to parent cgroup on memcg removal

Add support for memcg removal with HugeTLB resource usage.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    8 ++++
 include/linux/memcontrol.h |   14 +++++++
 mm/hugetlb.c               |   43 +++++++++++++++++++++++
 mm/memcontrol.c            |   65 +++++++++++++++++++++++++++++------
 4 files changed, 120 insertions(+), 10 deletions(-)

diff -puN include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal
+++ a/include/linux/hugetlb.h
@@ -348,4 +348,12 @@ static inline unsigned int pages_per_hug
 #define hstate_index(h) 0
 #endif
 
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
+#else
+static inline int hugetlb_force_memcg_empty(struct cgroup *cgroup)
+{
+	return 0;
+}
+#endif
 #endif /* _LINUX_HUGETLB_H */
diff -puN include/linux/memcontrol.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal
+++ a/include/linux/memcontrol.h
@@ -429,6 +429,9 @@ extern void mem_cgroup_hugetlb_uncharge_
 extern void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
 					      struct mem_cgroup *memcg);
 extern int mem_cgroup_hugetlb_file_init(int idx) __init;
+extern int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
+					  struct page *page);
+extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
 #else
 static inline int
@@ -465,6 +468,17 @@ static inline int mem_cgroup_hugetlb_fil
 	return 0;
 }
 
+static inline int
+mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
+			       struct page *page)
+{
+	return 0;
+}
+
+static inline bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup)
+{
+	return 0;
+}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/hugetlb.c~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal mm/hugetlb.c
--- a/mm/hugetlb.c~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal
+++ a/mm/hugetlb.c
@@ -1909,6 +1909,49 @@ static int __init hugetlb_init(void)
 }
 module_init(hugetlb_init);
 
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+/*
+ * Force the memcg to empty the hugetlb resources by moving them to
+ * the parent cgroup. We can fail if the parent cgroup's limit prevented
+ * the charging. This should only happen if use_hierarchy is not set.
+ */
+int hugetlb_force_memcg_empty(struct cgroup *cgroup)
+{
+	struct hstate *h;
+	struct page *page;
+	int ret = 0, idx = 0;
+
+	do {
+		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
+			goto out;
+		/*
+		 * If the task doing the cgroup_rmdir got a signal
+		 * we don't really need to loop till the hugetlb resource
+		 * usage become zero.
+		 */
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
+		for_each_hstate(h) {
+			spin_lock(&hugetlb_lock);
+			list_for_each_entry(page, &h->hugepage_activelist, lru) {
+				ret = mem_cgroup_move_hugetlb_parent(idx, cgroup, page);
+				if (ret) {
+					spin_unlock(&hugetlb_lock);
+					goto out;
+				}
+			}
+			spin_unlock(&hugetlb_lock);
+			idx++;
+		}
+		cond_resched();
+	} while (mem_cgroup_have_hugetlb_usage(cgroup));
+out:
+	return ret;
+}
+#endif
+
 /* Should be called on processing a hugepagesz=... option */
 void __init hugetlb_add_hstate(unsigned order)
 {
diff -puN mm/memcontrol.c~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal
+++ a/mm/memcontrol.c
@@ -3186,9 +3186,11 @@ static inline int mem_cgroup_move_swap_a
 #endif
 
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
-static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
+bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup)
 {
 	int idx;
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
+
 	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
 		if ((res_counter_read_u64(&memcg->hugepage[idx], RES_USAGE)) > 0)
 			return 1;
@@ -3286,10 +3288,54 @@ void mem_cgroup_hugetlb_uncharge_memcg(i
 	res_counter_uncharge(&memcg->hugepage[idx], csize);
 	return;
 }
-#else
-static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
+
+int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
+				   struct page *page)
 {
-	return 0;
+	struct page_cgroup *pc;
+	int csize,  ret = 0;
+	struct res_counter *fail_res;
+	struct cgroup *pcgrp = cgroup->parent;
+	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
+	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
+
+	if (!get_page_unless_zero(page))
+		goto out;
+
+	pc = lookup_page_cgroup(page);
+	lock_page_cgroup(pc);
+	if (!PageCgroupUsed(pc) || pc->mem_cgroup != memcg)
+		goto err_out;
+
+	csize = PAGE_SIZE << compound_order(page);
+	/*
+	 * If we have use_hierarchy set we can never fail here. So instead of
+	 * using res_counter_uncharge use the open-coded variant which just
+	 * uncharge the child res_counter. The parent will retain the charge.
+	 */
+	if (parent->use_hierarchy) {
+		unsigned long flags;
+		struct res_counter *counter;
+
+		counter = &memcg->hugepage[idx];
+		spin_lock_irqsave(&counter->lock, flags);
+		res_counter_uncharge_locked(counter, csize);
+		spin_unlock_irqrestore(&counter->lock, flags);
+	} else {
+		ret = res_counter_charge(&parent->hugepage[idx],
+					 csize, &fail_res);
+		if (ret) {
+			ret = -EBUSY;
+			goto err_out;
+		}
+		res_counter_uncharge(&memcg->hugepage[idx], csize);
+	}
+	pc->mem_cgroup = parent;
+err_out:
+	unlock_page_cgroup(pc);
+	put_page(page);
+out:
+	return ret;
 }
 #endif /* CONFIG_MEM_RES_CTLR_HUGETLB */
 
@@ -3818,6 +3864,11 @@ static int mem_cgroup_force_empty(struct
 	/* should free all ? */
 	if (free_all)
 		goto try_to_free;
+
+	/* move the hugetlb charges */
+	ret = hugetlb_force_memcg_empty(cgrp);
+	if (ret)
+		goto out;
 move_account:
 	do {
 		ret = -EBUSY;
@@ -5095,12 +5146,6 @@ free_out:
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	/*
-	 * Don't allow memcg removal if we have HugeTLB resource
-	 * usage.
-	 */
-	if (mem_cgroup_have_hugetlb_usage(memcg))
-		return -EBUSY;
 
 	return mem_cgroup_force_empty(memcg, false);
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
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

