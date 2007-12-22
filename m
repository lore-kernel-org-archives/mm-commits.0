From: akpm@linux-foundation.org
Subject: + memory-controller-remove-control_type-feature.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:57:10 -0800
Message-ID: <200712220657.lBM6vAmC021859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbXLVG5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Memory controller remove control_type feature
has been added to the -mm tree.  Its filename is
     memory-controller-remove-control_type-feature.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller remove control_type feature
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Based on the discussion at http://lkml.org/lkml/2007/12/20/383, it was felt
that control_type might not be a good thing to implement right away.  We
can add this flexibility at a later point when required.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 --
 mm/memcontrol.c            |   91 ++++++-----------------------------
 2 files changed, 18 insertions(+), 79 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-remove-control_type-feature include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-remove-control_type-feature
+++ a/include/linux/memcontrol.h
@@ -35,6 +35,7 @@ extern struct page_cgroup *page_get_page
 extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 extern void mem_cgroup_uncharge(struct page_cgroup *pc);
+extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_move_lists(struct page_cgroup *pc, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
@@ -52,11 +53,6 @@ static inline struct mem_cgroup *mm_cgro
 	return rcu_dereference(mm->mem_cgroup);
 }
 
-static inline void mem_cgroup_uncharge_page(struct page *page)
-{
-	mem_cgroup_uncharge(page_get_page_cgroup(page));
-}
-
 extern int mem_cgroup_prepare_migration(struct page *page);
 extern void mem_cgroup_end_migration(struct page *page);
 extern void mem_cgroup_page_migration(struct page *page, struct page *newpage);
diff -puN mm/memcontrol.c~memory-controller-remove-control_type-feature mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-remove-control_type-feature
+++ a/mm/memcontrol.c
@@ -131,7 +131,6 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_lru_info info;
 
-	unsigned long control_type;	/* control RSS or RSS+Pagecache */
 	int	prev_priority;	/* for recording reclaim priority */
 	/*
 	 * statistics.
@@ -709,24 +708,17 @@ int mem_cgroup_cache_charge(struct page 
 				gfp_t gfp_mask)
 {
 	int ret = 0;
-	struct mem_cgroup *mem;
 	if (!mm)
 		mm = &init_mm;
 
-	rcu_read_lock();
-	mem = rcu_dereference(mm->mem_cgroup);
-	css_get(&mem->css);
-	rcu_read_unlock();
-	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
+	ret = mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE);
-	css_put(&mem->css);
 	return ret;
 }
 
 /*
  * Uncharging is always a welcome operation, we never complain, simply
- * uncharge.
+ * uncharge. This routine should be called with lock_page_cgroup held
  */
 void mem_cgroup_uncharge(struct page_cgroup *pc)
 {
@@ -736,8 +728,7 @@ void mem_cgroup_uncharge(struct page_cgr
 	unsigned long flags;
 
 	/*
-	 * This can handle cases when a page is not charged at all and we
-	 * are switching between handling the control_type.
+	 * Check if our page_cgroup is valid
 	 */
 	if (!pc)
 		return;
@@ -749,6 +740,7 @@ void mem_cgroup_uncharge(struct page_cgr
 		 * get page->cgroup and clear it under lock.
 		 * force_empty can drop page->cgroup without checking refcnt.
 		 */
+		unlock_page_cgroup(page);
 		if (clear_page_cgroup(page, pc) == pc) {
 			mem = pc->mem_cgroup;
 			css_put(&mem->css);
@@ -758,9 +750,17 @@ void mem_cgroup_uncharge(struct page_cgr
 			spin_unlock_irqrestore(&mz->lru_lock, flags);
 			kfree(pc);
 		}
+		lock_page_cgroup(page);
 	}
 }
 
+void mem_cgroup_uncharge_page(struct page *page)
+{
+	lock_page_cgroup(page);
+	mem_cgroup_uncharge(page_get_page_cgroup(page));
+	unlock_page_cgroup(page);
+}
+
 /*
  * Returns non-zero if a page (under migration) has valid page_cgroup member.
  * Refcnt of page_cgroup is incremented.
@@ -780,8 +780,12 @@ int mem_cgroup_prepare_migration(struct 
 
 void mem_cgroup_end_migration(struct page *page)
 {
-	struct page_cgroup *pc = page_get_page_cgroup(page);
+	struct page_cgroup *pc;
+
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
 	mem_cgroup_uncharge(pc);
+	unlock_page_cgroup(page);
 }
 /*
  * We know both *page* and *newpage* are now not-on-LRU and Pg_locked.
@@ -936,61 +940,6 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
-static ssize_t mem_control_type_write(struct cgroup *cont,
-			struct cftype *cft, struct file *file,
-			const char __user *userbuf,
-			size_t nbytes, loff_t *pos)
-{
-	int ret;
-	char *buf, *end;
-	unsigned long tmp;
-	struct mem_cgroup *mem;
-
-	mem = mem_cgroup_from_cont(cont);
-	buf = kmalloc(nbytes + 1, GFP_KERNEL);
-	ret = -ENOMEM;
-	if (buf == NULL)
-		goto out;
-
-	buf[nbytes] = 0;
-	ret = -EFAULT;
-	if (copy_from_user(buf, userbuf, nbytes))
-		goto out_free;
-
-	ret = -EINVAL;
-	tmp = simple_strtoul(buf, &end, 10);
-	if (*end != '\0')
-		goto out_free;
-
-	if (tmp <= MEM_CGROUP_TYPE_UNSPEC || tmp >= MEM_CGROUP_TYPE_MAX)
-		goto out_free;
-
-	mem->control_type = tmp;
-	ret = nbytes;
-out_free:
-	kfree(buf);
-out:
-	return ret;
-}
-
-static ssize_t mem_control_type_read(struct cgroup *cont,
-				struct cftype *cft,
-				struct file *file, char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
-{
-	unsigned long val;
-	char buf[64], *s;
-	struct mem_cgroup *mem;
-
-	mem = mem_cgroup_from_cont(cont);
-	s = buf;
-	val = mem->control_type;
-	s += sprintf(s, "%lu\n", val);
-	return simple_read_from_buffer((void __user *)userbuf, nbytes,
-			ppos, buf, s - buf);
-}
-
-
 static ssize_t mem_force_empty_write(struct cgroup *cont,
 				struct cftype *cft, struct file *file,
 				const char __user *userbuf,
@@ -1089,11 +1038,6 @@ static struct cftype mem_cgroup_files[] 
 		.read = mem_cgroup_read,
 	},
 	{
-		.name = "control_type",
-		.write = mem_control_type_write,
-		.read = mem_control_type_read,
-	},
-	{
 		.name = "force_empty",
 		.write = mem_force_empty_write,
 		.read = mem_force_empty_read,
@@ -1161,7 +1105,6 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	res_counter_init(&mem->res);
 
-	mem->control_type = MEM_CGROUP_TYPE_ALL;
 	memset(&mem->info, 0, sizeof(mem->info));
 
 	for_each_node_state(node, N_POSSIBLE)
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

git-powerpc.patch
swapoff-scan-ptes-preemptibly.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
remove-unused-code-from-mm-tiny-shmemc.patch
memory-controller-add-documentation.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-memory-accounting-v7-move-page_assign_page_cgroup-to-vm_bug_on-in-free_hot_cold_page.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-improve-user-interface-memory-controller-enhancements-for-reclaiming-take2-possible-race-fix-in-res_counter.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
memcgroup-reinstate-swapoff-mod.patch
memory-controller-bug_on.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-clean-up-remove-unused-variable.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-add-bug_on-in-mem_cgroup_zoneinfo.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix-accounting-in-vmscanc-for-memory-controller.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
memory-controller-remove-control_type-feature.patch
update-documentation-controller-memorytxt.patch
