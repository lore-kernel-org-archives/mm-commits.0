From: akpm@linux-foundation.org
Subject: [merged] mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:34 -0800
Message-ID: <20120113203335.1ECA620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:38 -0500
Received: by eaad12 with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unify remaining mem_cont, mem, etc. variable names to memcg
has been removed from the -mm tree.  Its filename was
     mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: unify remaining mem_cont, mem, etc. variable names to memcg

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 +++++-----
 include/linux/oom.h        |    2 -
 include/linux/rmap.h       |    4 +-
 mm/memcontrol.c            |   52 ++++++++++++++++++-----------------
 mm/oom_kill.c              |   38 ++++++++++++-------------
 mm/rmap.c                  |   20 ++++++-------
 mm/swapfile.c              |    9 +++---
 mm/vmscan.c                |   12 ++++----
 8 files changed, 78 insertions(+), 75 deletions(-)

diff -puN include/linux/memcontrol.h~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/include/linux/memcontrol.h
@@ -54,10 +54,10 @@ extern int mem_cgroup_newpage_charge(str
 				gfp_t gfp_mask);
 /* for swap handling */
 extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
-		struct page *page, gfp_t mask, struct mem_cgroup **ptr);
+		struct page *page, gfp_t mask, struct mem_cgroup **memcgp);
 extern void mem_cgroup_commit_charge_swapin(struct page *page,
-					struct mem_cgroup *ptr);
-extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr);
+					struct mem_cgroup *memcg);
+extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg);
 
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
@@ -101,7 +101,7 @@ extern struct cgroup_subsys_state *mem_c
 
 extern int
 mem_cgroup_prepare_migration(struct page *page,
-	struct page *newpage, struct mem_cgroup **ptr, gfp_t gfp_mask);
+	struct page *newpage, struct mem_cgroup **memcgp, gfp_t gfp_mask);
 extern void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 	struct page *oldpage, struct page *newpage, bool migration_ok);
 
@@ -186,17 +186,17 @@ static inline int mem_cgroup_cache_charg
 }
 
 static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
-		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
+		struct page *page, gfp_t gfp_mask, struct mem_cgroup **memcgp)
 {
 	return 0;
 }
 
 static inline void mem_cgroup_commit_charge_swapin(struct page *page,
-					  struct mem_cgroup *ptr)
+					  struct mem_cgroup *memcg)
 {
 }
 
-static inline void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr)
+static inline void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
 {
 }
 
@@ -275,7 +275,7 @@ static inline struct cgroup_subsys_state
 
 static inline int
 mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
-	struct mem_cgroup **ptr, gfp_t gfp_mask)
+	struct mem_cgroup **memcgp, gfp_t gfp_mask)
 {
 	return 0;
 }
diff -puN include/linux/oom.h~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg include/linux/oom.h
--- a/include/linux/oom.h~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/include/linux/oom.h
@@ -43,7 +43,7 @@ enum oom_constraint {
 extern void compare_swap_oom_score_adj(int old_val, int new_val);
 extern int test_set_oom_score_adj(int new_val);
 
-extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
+extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 			const nodemask_t *nodemask, unsigned long totalpages);
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
diff -puN include/linux/rmap.h~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg include/linux/rmap.h
--- a/include/linux/rmap.h~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/include/linux/rmap.h
@@ -158,7 +158,7 @@ static inline void page_dup_rmap(struct 
  * Called from mm/vmscan.c to handle paging out
  */
 int page_referenced(struct page *, int is_locked,
-			struct mem_cgroup *cnt, unsigned long *vm_flags);
+			struct mem_cgroup *memcg, unsigned long *vm_flags);
 int page_referenced_one(struct page *, struct vm_area_struct *,
 	unsigned long address, unsigned int *mapcount, unsigned long *vm_flags);
 
@@ -236,7 +236,7 @@ int rmap_walk(struct page *page, int (*r
 #define anon_vma_link(vma)	do {} while (0)
 
 static inline int page_referenced(struct page *page, int is_locked,
-				  struct mem_cgroup *cnt,
+				  struct mem_cgroup *memcg,
 				  unsigned long *vm_flags)
 {
 	*vm_flags = 0;
diff -puN mm/memcontrol.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/mm/memcontrol.c
@@ -2844,12 +2844,12 @@ int mem_cgroup_cache_charge(struct page 
  */
 int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 				 struct page *page,
-				 gfp_t mask, struct mem_cgroup **ptr)
+				 gfp_t mask, struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
-	*ptr = NULL;
+	*memcgp = NULL;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -2867,27 +2867,27 @@ int mem_cgroup_try_charge_swapin(struct 
 	memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		goto charge_cur_mm;
-	*ptr = memcg;
-	ret = __mem_cgroup_try_charge(NULL, mask, 1, ptr, true);
+	*memcgp = memcg;
+	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
 	css_put(&memcg->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, 1, ptr, true);
+	return __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
 }
 
 static void
-__mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
+__mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
 	if (mem_cgroup_disabled())
 		return;
-	if (!ptr)
+	if (!memcg)
 		return;
-	cgroup_exclude_rmdir(&ptr->css);
+	cgroup_exclude_rmdir(&memcg->css);
 
-	__mem_cgroup_commit_charge_lrucare(page, ptr, ctype);
+	__mem_cgroup_commit_charge_lrucare(page, memcg, ctype);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -2897,21 +2897,22 @@ __mem_cgroup_commit_charge_swapin(struct
 	 */
 	if (do_swap_account && PageSwapCache(page)) {
 		swp_entry_t ent = {.val = page_private(page)};
+		struct mem_cgroup *swap_memcg;
 		unsigned short id;
-		struct mem_cgroup *memcg;
 
 		id = swap_cgroup_record(ent, 0);
 		rcu_read_lock();
-		memcg = mem_cgroup_lookup(id);
-		if (memcg) {
+		swap_memcg = mem_cgroup_lookup(id);
+		if (swap_memcg) {
 			/*
 			 * This recorded memcg can be obsolete one. So, avoid
 			 * calling css_tryget
 			 */
-			if (!mem_cgroup_is_root(memcg))
-				res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
-			mem_cgroup_swap_statistics(memcg, false);
-			mem_cgroup_put(memcg);
+			if (!mem_cgroup_is_root(swap_memcg))
+				res_counter_uncharge(&swap_memcg->memsw,
+						     PAGE_SIZE);
+			mem_cgroup_swap_statistics(swap_memcg, false);
+			mem_cgroup_put(swap_memcg);
 		}
 		rcu_read_unlock();
 	}
@@ -2920,13 +2921,14 @@ __mem_cgroup_commit_charge_swapin(struct
 	 * So, rmdir()->pre_destroy() can be called while we do this charge.
 	 * In that case, we need to call pre_destroy() again. check it here.
 	 */
-	cgroup_release_and_wakeup_rmdir(&ptr->css);
+	cgroup_release_and_wakeup_rmdir(&memcg->css);
 }
 
-void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
+void mem_cgroup_commit_charge_swapin(struct page *page,
+				     struct mem_cgroup *memcg)
 {
-	__mem_cgroup_commit_charge_swapin(page, ptr,
-					MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	__mem_cgroup_commit_charge_swapin(page, memcg,
+					  MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
@@ -3255,14 +3257,14 @@ static inline int mem_cgroup_move_swap_a
  * page belongs to.
  */
 int mem_cgroup_prepare_migration(struct page *page,
-	struct page *newpage, struct mem_cgroup **ptr, gfp_t gfp_mask)
+	struct page *newpage, struct mem_cgroup **memcgp, gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg = NULL;
 	struct page_cgroup *pc;
 	enum charge_type ctype;
 	int ret = 0;
 
-	*ptr = NULL;
+	*memcgp = NULL;
 
 	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
@@ -3313,10 +3315,10 @@ int mem_cgroup_prepare_migration(struct 
 	if (!memcg)
 		return 0;
 
-	*ptr = memcg;
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, 1, ptr, false);
+	*memcgp = memcg;
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, 1, memcgp, false);
 	css_put(&memcg->css);/* drop extra refcnt */
-	if (ret || *ptr == NULL) {
+	if (ret || *memcgp == NULL) {
 		if (PageAnon(page)) {
 			lock_page_cgroup(pc);
 			ClearPageCgroupMigration(pc);
diff -puN mm/oom_kill.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg mm/oom_kill.c
--- a/mm/oom_kill.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/mm/oom_kill.c
@@ -152,7 +152,7 @@ struct task_struct *find_lock_task_mm(st
 
 /* return true if the task is not adequate as candidate victim task. */
 static bool oom_unkillable_task(struct task_struct *p,
-		const struct mem_cgroup *mem, const nodemask_t *nodemask)
+		const struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
 	if (is_global_init(p))
 		return true;
@@ -160,7 +160,7 @@ static bool oom_unkillable_task(struct t
 		return true;
 
 	/* When mem_cgroup_out_of_memory() and p is not member of the group */
-	if (mem && !task_in_mem_cgroup(p, mem))
+	if (memcg && !task_in_mem_cgroup(p, memcg))
 		return true;
 
 	/* p may not have freeable memory in nodemask */
@@ -179,12 +179,12 @@ static bool oom_unkillable_task(struct t
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
+unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 		      const nodemask_t *nodemask, unsigned long totalpages)
 {
 	long points;
 
-	if (oom_unkillable_task(p, mem, nodemask))
+	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
 
 	p = find_lock_task_mm(p);
@@ -308,7 +308,7 @@ static enum oom_constraint constrained_a
  * (not docbooked, we don't want this one cluttering up the manual)
  */
 static struct task_struct *select_bad_process(unsigned int *ppoints,
-		unsigned long totalpages, struct mem_cgroup *mem,
+		unsigned long totalpages, struct mem_cgroup *memcg,
 		const nodemask_t *nodemask)
 {
 	struct task_struct *g, *p;
@@ -320,7 +320,7 @@ static struct task_struct *select_bad_pr
 
 		if (p->exit_state)
 			continue;
-		if (oom_unkillable_task(p, mem, nodemask))
+		if (oom_unkillable_task(p, memcg, nodemask))
 			continue;
 
 		/*
@@ -364,7 +364,7 @@ static struct task_struct *select_bad_pr
 			}
 		}
 
-		points = oom_badness(p, mem, nodemask, totalpages);
+		points = oom_badness(p, memcg, nodemask, totalpages);
 		if (points > *ppoints) {
 			chosen = p;
 			*ppoints = points;
@@ -387,14 +387,14 @@ static struct task_struct *select_bad_pr
  *
  * Call with tasklist_lock read-locked.
  */
-static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
+static void dump_tasks(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *task;
 
 	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
 	for_each_process(p) {
-		if (oom_unkillable_task(p, mem, nodemask))
+		if (oom_unkillable_task(p, memcg, nodemask))
 			continue;
 
 		task = find_lock_task_mm(p);
@@ -417,7 +417,7 @@ static void dump_tasks(const struct mem_
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
-			struct mem_cgroup *mem, const nodemask_t *nodemask)
+			struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
 	task_lock(current);
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
@@ -427,10 +427,10 @@ static void dump_header(struct task_stru
 	cpuset_print_task_mems_allowed(current);
 	task_unlock(current);
 	dump_stack();
-	mem_cgroup_print_oom_info(mem, p);
+	mem_cgroup_print_oom_info(memcg, p);
 	show_mem(SHOW_MEM_FILTER_NODES);
 	if (sysctl_oom_dump_tasks)
-		dump_tasks(mem, nodemask);
+		dump_tasks(memcg, nodemask);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -484,7 +484,7 @@ static int oom_kill_task(struct task_str
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			    unsigned int points, unsigned long totalpages,
-			    struct mem_cgroup *mem, nodemask_t *nodemask,
+			    struct mem_cgroup *memcg, nodemask_t *nodemask,
 			    const char *message)
 {
 	struct task_struct *victim = p;
@@ -493,7 +493,7 @@ static int oom_kill_process(struct task_
 	unsigned int victim_points = 0;
 
 	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, mem, nodemask);
+		dump_header(p, gfp_mask, order, memcg, nodemask);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -524,7 +524,7 @@ static int oom_kill_process(struct task_
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
 			 */
-			child_points = oom_badness(child, mem, nodemask,
+			child_points = oom_badness(child, memcg, nodemask,
 								totalpages);
 			if (child_points > victim_points) {
 				victim = child;
@@ -561,7 +561,7 @@ static void check_panic_on_oom(enum oom_
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
+void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask)
 {
 	unsigned long limit;
 	unsigned int points = 0;
@@ -578,14 +578,14 @@ void mem_cgroup_out_of_memory(struct mem
 	}
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
-	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
+	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, limit, mem, NULL);
+	p = select_bad_process(&points, limit, memcg, NULL);
 	if (!p || PTR_ERR(p) == -1UL)
 		goto out;
 
-	if (oom_kill_process(p, gfp_mask, 0, points, limit, mem, NULL,
+	if (oom_kill_process(p, gfp_mask, 0, points, limit, memcg, NULL,
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
diff -puN mm/rmap.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg mm/rmap.c
--- a/mm/rmap.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/mm/rmap.c
@@ -773,7 +773,7 @@ out:
 }
 
 static int page_referenced_anon(struct page *page,
-				struct mem_cgroup *mem_cont,
+				struct mem_cgroup *memcg,
 				unsigned long *vm_flags)
 {
 	unsigned int mapcount;
@@ -796,7 +796,7 @@ static int page_referenced_anon(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
+		if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
 			continue;
 		referenced += page_referenced_one(page, vma, address,
 						  &mapcount, vm_flags);
@@ -811,7 +811,7 @@ static int page_referenced_anon(struct p
 /**
  * page_referenced_file - referenced check for object-based rmap
  * @page: the page we're checking references on.
- * @mem_cont: target memory controller
+ * @memcg: target memory control group
  * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
  *
  * For an object-based mapped page, find all the places it is mapped and
@@ -822,7 +822,7 @@ static int page_referenced_anon(struct p
  * This function is only called from page_referenced for object-based pages.
  */
 static int page_referenced_file(struct page *page,
-				struct mem_cgroup *mem_cont,
+				struct mem_cgroup *memcg,
 				unsigned long *vm_flags)
 {
 	unsigned int mapcount;
@@ -864,7 +864,7 @@ static int page_referenced_file(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
+		if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
 			continue;
 		referenced += page_referenced_one(page, vma, address,
 						  &mapcount, vm_flags);
@@ -880,7 +880,7 @@ static int page_referenced_file(struct p
  * page_referenced - test if the page was referenced
  * @page: the page to test
  * @is_locked: caller holds lock on the page
- * @mem_cont: target memory controller
+ * @memcg: target memory cgroup
  * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
  *
  * Quick test_and_clear_referenced for all mappings to a page,
@@ -888,7 +888,7 @@ static int page_referenced_file(struct p
  */
 int page_referenced(struct page *page,
 		    int is_locked,
-		    struct mem_cgroup *mem_cont,
+		    struct mem_cgroup *memcg,
 		    unsigned long *vm_flags)
 {
 	int referenced = 0;
@@ -904,13 +904,13 @@ int page_referenced(struct page *page,
 			}
 		}
 		if (unlikely(PageKsm(page)))
-			referenced += page_referenced_ksm(page, mem_cont,
+			referenced += page_referenced_ksm(page, memcg,
 								vm_flags);
 		else if (PageAnon(page))
-			referenced += page_referenced_anon(page, mem_cont,
+			referenced += page_referenced_anon(page, memcg,
 								vm_flags);
 		else if (page->mapping)
-			referenced += page_referenced_file(page, mem_cont,
+			referenced += page_referenced_file(page, memcg,
 								vm_flags);
 		if (we_locked)
 			unlock_page(page);
diff -puN mm/swapfile.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg mm/swapfile.c
--- a/mm/swapfile.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/mm/swapfile.c
@@ -847,12 +847,13 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
-	struct mem_cgroup *ptr;
+	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;
 
-	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page, GFP_KERNEL, &ptr)) {
+	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
+					 GFP_KERNEL, &memcg)) {
 		ret = -ENOMEM;
 		goto out_nolock;
 	}
@@ -860,7 +861,7 @@ static int unuse_pte(struct vm_area_stru
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same(*pte, swp_entry_to_pte(entry)))) {
 		if (ret > 0)
-			mem_cgroup_cancel_charge_swapin(ptr);
+			mem_cgroup_cancel_charge_swapin(memcg);
 		ret = 0;
 		goto out;
 	}
@@ -871,7 +872,7 @@ static int unuse_pte(struct vm_area_stru
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	page_add_anon_rmap(page, vma, addr);
-	mem_cgroup_commit_charge_swapin(page, ptr);
+	mem_cgroup_commit_charge_swapin(page, memcg);
 	swap_free(entry);
 	/*
 	 * Move the page to the active list so it is not
diff -puN mm/vmscan.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg mm/vmscan.c
--- a/mm/vmscan.c~mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg
+++ a/mm/vmscan.c
@@ -2376,7 +2376,7 @@ unsigned long try_to_free_pages(struct z
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
-unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
+unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
 						gfp_t gfp_mask, bool noswap,
 						struct zone *zone,
 						unsigned long *nr_scanned)
@@ -2388,10 +2388,10 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.order = 0,
-		.target_mem_cgroup = mem,
+		.target_mem_cgroup = memcg,
 	};
 	struct mem_cgroup_zone mz = {
-		.mem_cgroup = mem,
+		.mem_cgroup = memcg,
 		.zone = zone,
 	};
 
@@ -2417,7 +2417,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	return sc.nr_reclaimed;
 }
 
-unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   gfp_t gfp_mask,
 					   bool noswap)
 {
@@ -2430,7 +2430,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.order = 0,
-		.target_mem_cgroup = mem_cont,
+		.target_mem_cgroup = memcg,
 		.nodemask = NULL, /* we don't care the placement */
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
@@ -2444,7 +2444,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	 * take care of from where we get pages. So the node where we start the
 	 * scan does not need to be the current node.
 	 */
-	nid = mem_cgroup_select_victim_node(mem_cont);
+	nid = mem_cgroup_select_victim_node(memcg);
 
 	zonelist = NODE_DATA(nid)->node_zonelists;
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

