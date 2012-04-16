From: akpm@linux-foundation.org
Subject: + memcg-add-hugetlb-extension.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:16:03 -0700
Message-ID: <20120416231603.20BDBA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63969 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2DPXQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:16:07 -0400
Received: by wibhj13 with SMTP id hj13so781wib.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:16:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: add HugeTLB extension
has been added to the -mm tree.  Its filename is
     memcg-add-hugetlb-extension.patch

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
@@ -226,6 +226,7 @@ struct hstate *size_to_hstate(unsigned l
 #define HUGE_MAX_HSTATE 1
 #endif
 
+extern int hugetlb_max_hstate;
 extern struct hstate hstates[HUGE_MAX_HSTATE];
 extern unsigned int default_hstate_idx;
 
diff -puN include/linux/memcontrol.h~memcg-add-hugetlb-extension include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-hugetlb-extension
+++ a/include/linux/memcontrol.h
@@ -448,5 +448,47 @@ static inline void sock_release_memcg(st
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
@@ -716,6 +716,14 @@ config CGROUP_PERF
 
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
@@ -252,6 +252,10 @@ struct mem_cgroup {
 	};
 
 	/*
+	 * the counter to account for hugepages from hugetlb.
+	 */
+	struct res_counter hugepage[HUGE_MAX_HSTATE];
+	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
 	 */
@@ -3213,6 +3217,114 @@ static inline int mem_cgroup_move_swap_a
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
@@ -4955,6 +5067,7 @@ err_cleanup:
 static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup *cont)
 {
+	int idx;
 	struct mem_cgroup *memcg, *parent;
 	long error = -ENOMEM;
 	int node;
@@ -4997,9 +5110,22 @@ mem_cgroup_create(struct cgroup *cont)
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
@@ -5030,6 +5156,12 @@ free_out:
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
Subject: Subject: memcg: add HugeTLB extension

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

