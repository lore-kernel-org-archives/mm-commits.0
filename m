From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-hugetlb-extension.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:46 -0700
Message-ID: <20120611210946.8F1FDA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:52808 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2FKVJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:48 -0400
Received: by wibhn6 with SMTP id hn6so235063wib.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add HugeTLB extension
has been removed from the -mm tree.  Its filename was
     memcg-add-hugetlb-extension.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: memcg: add HugeTLB extension

This patch implements a memcg extension that allows us to control HugeTLB
allocations via memory controller.  The extension allows to limit the
HugeTLB usage per control group and enforces the controller limit during
page fault.  Since HugeTLB doesn't support page reclaim, enforcing the
limit at page fault time implies that, the application will get SIGBUS
signal if it tries to access HugeTLB pages beyond its limit.  This
requires the application to know beforehand how much HugeTLB pages it
would require for its use.

The charge/uncharge calls will be added to HugeTLB code in later patch. 
Support for memcg removal will be added in later patches.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    1 
 include/linux/memcontrol.h |   42 +++++++++++
 init/Kconfig               |    8 ++
 mm/hugetlb.c               |    2 
 mm/memcontrol.c            |  132 +++++++++++++++++++++++++++++++++++
 5 files changed, 184 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~memcg-add-hugetlb-extension include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~memcg-add-hugetlb-extension
+++ a/include/linux/hugetlb.h
@@ -238,6 +238,7 @@ struct hstate *size_to_hstate(unsigned l
 #define HUGE_MAX_HSTATE 1
 #endif
 
+extern int hugetlb_max_hstate;
 extern struct hstate hstates[HUGE_MAX_HSTATE];
 extern unsigned int default_hstate_idx;
 
diff -puN include/linux/memcontrol.h~memcg-add-hugetlb-extension include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-hugetlb-extension
+++ a/include/linux/memcontrol.h
@@ -417,5 +417,47 @@ static inline void sock_release_memcg(st
 {
 }
 #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
+
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+extern int mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
+					  struct mem_cgroup **ptr);
+extern void mem_cgroup_hugetlb_commit_charge(int idx, unsigned long nr_pages,
+					     struct mem_cgroup *memcg,
+					     struct page *page);
+extern void mem_cgroup_hugetlb_uncharge_page(int idx, unsigned long nr_pages,
+					     struct page *page);
+extern void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
+					      struct mem_cgroup *memcg);
+
+#else
+static inline int
+mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
+						 struct mem_cgroup **ptr)
+{
+	return 0;
+}
+
+static inline void
+mem_cgroup_hugetlb_commit_charge(int idx, unsigned long nr_pages,
+				 struct mem_cgroup *memcg,
+				 struct page *page)
+{
+	return;
+}
+
+static inline void
+mem_cgroup_hugetlb_uncharge_page(int idx, unsigned long nr_pages,
+				 struct page *page)
+{
+	return;
+}
+
+static inline void
+mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
+				  struct mem_cgroup *memcg)
+{
+	return;
+}
+#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN init/Kconfig~memcg-add-hugetlb-extension init/Kconfig
--- a/init/Kconfig~memcg-add-hugetlb-extension
+++ a/init/Kconfig
@@ -761,6 +761,14 @@ config CGROUP_PERF
 
 	  Say N if unsure.
 
+config MEM_RES_CTLR_HUGETLB
+	bool "Memory Resource Controller HugeTLB Extension (EXPERIMENTAL)"
+	depends on CGROUP_MEM_RES_CTLR && HUGETLB_PAGE && EXPERIMENTAL
+	default n
+	help
+	  Add HugeTLB management to memory resource controller. When you
+	  enable this, you can put a per cgroup limit on HugeTLB usage.
+
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
 	default n
diff -puN mm/hugetlb.c~memcg-add-hugetlb-extension mm/hugetlb.c
--- a/mm/hugetlb.c~memcg-add-hugetlb-extension
+++ a/mm/hugetlb.c
@@ -35,7 +35,7 @@ const unsigned long hugetlb_zero = 0, hu
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-static int hugetlb_max_hstate;
+int hugetlb_max_hstate;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
diff -puN mm/memcontrol.c~memcg-add-hugetlb-extension mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-hugetlb-extension
+++ a/mm/memcontrol.c
@@ -265,6 +265,10 @@ struct mem_cgroup {
 	};
 
 	/*
+	 * the counter to account for hugepages from hugetlb.
+	 */
+	struct res_counter hugepage[HUGE_MAX_HSTATE];
+	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
 	 */
@@ -3161,6 +3165,114 @@ static inline int mem_cgroup_move_swap_a
 }
 #endif
 
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
+{
+	int idx;
+	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
+		if ((res_counter_read_u64(&memcg->hugepage[idx], RES_USAGE)) > 0)
+			return 1;
+	}
+	return 0;
+}
+
+int mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
+				   struct mem_cgroup **ptr)
+{
+	int ret = 0;
+	struct mem_cgroup *memcg = NULL;
+	struct res_counter *fail_res;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (mem_cgroup_disabled())
+		goto done;
+again:
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	if (!css_tryget(&memcg->css)) {
+		rcu_read_unlock();
+		goto again;
+	}
+	rcu_read_unlock();
+
+	ret = res_counter_charge(&memcg->hugepage[idx], csize, &fail_res);
+	css_put(&memcg->css);
+done:
+	*ptr = memcg;
+	return ret;
+}
+
+void mem_cgroup_hugetlb_commit_charge(int idx, unsigned long nr_pages,
+				      struct mem_cgroup *memcg,
+				      struct page *page)
+{
+	struct page_cgroup *pc;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(page);
+	lock_page_cgroup(pc);
+	if (unlikely(PageCgroupUsed(pc))) {
+		unlock_page_cgroup(pc);
+		mem_cgroup_hugetlb_uncharge_memcg(idx, nr_pages, memcg);
+		return;
+	}
+	pc->mem_cgroup = memcg;
+	SetPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+	return;
+}
+
+void mem_cgroup_hugetlb_uncharge_page(int idx, unsigned long nr_pages,
+				      struct page *page)
+{
+	struct page_cgroup *pc;
+	struct mem_cgroup *memcg;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!PageCgroupUsed(pc)))
+		return;
+
+	lock_page_cgroup(pc);
+	if (!PageCgroupUsed(pc)) {
+		unlock_page_cgroup(pc);
+		return;
+	}
+	memcg = pc->mem_cgroup;
+	pc->mem_cgroup = root_mem_cgroup;
+	ClearPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+
+	res_counter_uncharge(&memcg->hugepage[idx], csize);
+	return;
+}
+
+void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
+				       struct mem_cgroup *memcg)
+{
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	res_counter_uncharge(&memcg->hugepage[idx], csize);
+	return;
+}
+#else
+static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+#endif /* CONFIG_MEM_RES_CTLR_HUGETLB */
+
 /*
  * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
  * page belongs to.
@@ -4859,6 +4971,7 @@ err_cleanup:
 static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup *cont)
 {
+	int idx;
 	struct mem_cgroup *memcg, *parent;
 	long error = -ENOMEM;
 	int node;
@@ -4901,9 +5014,22 @@ mem_cgroup_create(struct cgroup *cont)
 		 * mem_cgroup(see mem_cgroup_put).
 		 */
 		mem_cgroup_get(parent);
+		/*
+		 * We could get called before hugetlb init is called.
+		 * Use HUGE_MAX_HSTATE as the max index.
+		 */
+		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
+			res_counter_init(&memcg->hugepage[idx],
+					 &parent->hugepage[idx]);
 	} else {
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
+		/*
+		 * We could get called before hugetlb init is called.
+		 * Use HUGE_MAX_HSTATE as the max index.
+		 */
+		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
+			res_counter_init(&memcg->hugepage[idx], NULL);
 	}
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
@@ -4934,6 +5060,12 @@ free_out:
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	/*
+	 * Don't allow memcg removal if we have HugeTLB resource
+	 * usage.
+	 */
+	if (mem_cgroup_have_hugetlb_usage(memcg))
+		return -EBUSY;
 
 	return mem_cgroup_force_empty(memcg, false);
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
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

