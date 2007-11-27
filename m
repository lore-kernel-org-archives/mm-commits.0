From: akpm@linux-foundation.org
Subject: + per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:02:50 -0800
Message-ID: <200711272202.lARM2pt5032664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756574AbXK0WJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, kmaezawa.hiroyu@jp.fujitsu.com, menage@google.com, nickpiggin@yahoo.com.au, riel@redhat.com, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     per-zone and reclaim enhancements for memory controller: per-zone-lock for cgroup
has been added to the -mm tree.  Its filename is
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: per-zone and reclaim enhancements for memory controller: per-zone-lock for cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, lru is per-zone.

Then, lru_lock can be (should be) per-zone, too.
This patch implementes per-zone lru lock.

lru_lock is placed into mem_cgroup_per_zone struct.

lock can be accessed by
   mz = mem_cgroup_zoneinfo(mem_cgroup, node, zone);
   &mz->lru_lock

   or
   mz = page_cgroup_zoneinfo(page_cgroup);
   &mz->lru_lock

Signed-off-by: KAMEZAWA hiroyuki <kmaezawa.hiroyu@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   71 ++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff -puN mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup
+++ a/mm/memcontrol.c
@@ -89,6 +89,10 @@ enum mem_cgroup_zstat_index {
 };
 
 struct mem_cgroup_per_zone {
+	/*
+	 * spin_lock to protect the per cgroup LRU
+	 */
+	spinlock_t		lru_lock;
 	struct list_head	active_list;
 	struct list_head	inactive_list;
 	unsigned long count[NR_MEM_CGROUP_ZSTAT];
@@ -126,10 +130,7 @@ struct mem_cgroup {
 	 * per zone LRU lists.
 	 */
 	struct mem_cgroup_lru_info info;
-	/*
-	 * spin_lock to protect the per cgroup LRU
-	 */
-	spinlock_t lru_lock;
+
 	unsigned long control_type;	/* control RSS or RSS+Pagecache */
 	int	prev_priority;	/* for recording reclaim priority */
 	/*
@@ -410,15 +411,16 @@ int task_in_mem_cgroup(struct task_struc
  */
 void mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup_per_zone *mz;
+	unsigned long flags;
+
 	if (!pc)
 		return;
 
-	mem = pc->mem_cgroup;
-
-	spin_lock(&mem->lru_lock);
+	mz = page_cgroup_zoneinfo(pc);
+	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_move_lists(pc, active);
-	spin_unlock(&mem->lru_lock);
+	spin_unlock_irqrestore(&mz->lru_lock, flags);
 }
 
 /*
@@ -528,7 +530,7 @@ unsigned long mem_cgroup_isolate_pages(u
 		src = &mz->inactive_list;
 
 
-	spin_lock(&mem_cont->lru_lock);
+	spin_lock(&mz->lru_lock);
 	scan = 0;
 	list_for_each_entry_safe_reverse(pc, tmp, src, lru) {
 		if (scan >= nr_to_scan)
@@ -558,7 +560,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	}
 
 	list_splice(&pc_list, src);
-	spin_unlock(&mem_cont->lru_lock);
+	spin_unlock(&mz->lru_lock);
 
 	*scanned = scan;
 	return nr_taken;
@@ -577,6 +579,7 @@ static int mem_cgroup_charge_common(stru
 	struct page_cgroup *pc;
 	unsigned long flags;
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct mem_cgroup_per_zone *mz;
 
 	/*
 	 * Should page_cgroup's go to their own slab?
@@ -688,10 +691,11 @@ noreclaim:
 		goto retry;
 	}
 
-	spin_lock_irqsave(&mem->lru_lock, flags);
+	mz = page_cgroup_zoneinfo(pc);
+	spin_lock_irqsave(&mz->lru_lock, flags);
 	/* Update statistics vector */
 	__mem_cgroup_add_list(pc);
-	spin_unlock_irqrestore(&mem->lru_lock, flags);
+	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
 done:
 	return 0;
@@ -733,6 +737,7 @@ int mem_cgroup_cache_charge(struct page 
 void mem_cgroup_uncharge(struct page_cgroup *pc)
 {
 	struct mem_cgroup *mem;
+	struct mem_cgroup_per_zone *mz;
 	struct page *page;
 	unsigned long flags;
 
@@ -745,6 +750,7 @@ void mem_cgroup_uncharge(struct page_cgr
 
 	if (atomic_dec_and_test(&pc->ref_cnt)) {
 		page = pc->page;
+		mz = page_cgroup_zoneinfo(pc);
 		/*
 		 * get page->cgroup and clear it under lock.
 		 * force_empty can drop page->cgroup without checking refcnt.
@@ -753,9 +759,9 @@ void mem_cgroup_uncharge(struct page_cgr
 			mem = pc->mem_cgroup;
 			css_put(&mem->css);
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
-			spin_lock_irqsave(&mem->lru_lock, flags);
+			spin_lock_irqsave(&mz->lru_lock, flags);
 			__mem_cgroup_remove_list(pc);
-			spin_unlock_irqrestore(&mem->lru_lock, flags);
+			spin_unlock_irqrestore(&mz->lru_lock, flags);
 			kfree(pc);
 		}
 	}
@@ -794,24 +800,29 @@ void mem_cgroup_page_migration(struct pa
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem;
 	unsigned long flags;
+	struct mem_cgroup_per_zone *mz;
 retry:
 	pc = page_get_page_cgroup(page);
 	if (!pc)
 		return;
 	mem = pc->mem_cgroup;
+	mz = page_cgroup_zoneinfo(pc);
 	if (clear_page_cgroup(page, pc) != pc)
 		goto retry;
-
-	spin_lock_irqsave(&mem->lru_lock, flags);
+	spin_lock_irqsave(&mz->lru_lock, flags);
 
 	__mem_cgroup_remove_list(pc);
+	spin_unlock_irqrestore(&mz->lru_lock, flags);
+
 	pc->page = newpage;
 	lock_page_cgroup(newpage);
 	page_assign_page_cgroup(newpage, pc);
 	unlock_page_cgroup(newpage);
-	__mem_cgroup_add_list(pc);
 
-	spin_unlock_irqrestore(&mem->lru_lock, flags);
+	mz = page_cgroup_zoneinfo(pc);
+	spin_lock_irqsave(&mz->lru_lock, flags);
+	__mem_cgroup_add_list(pc);
+	spin_unlock_irqrestore(&mz->lru_lock, flags);
 	return;
 }
 
@@ -822,18 +833,26 @@ retry:
  */
 #define FORCE_UNCHARGE_BATCH	(128)
 static void
-mem_cgroup_force_empty_list(struct mem_cgroup *mem, struct list_head *list)
+mem_cgroup_force_empty_list(struct mem_cgroup *mem,
+			    struct mem_cgroup_per_zone *mz,
+			    int active)
 {
 	struct page_cgroup *pc;
 	struct page *page;
 	int count;
 	unsigned long flags;
+	struct list_head *list;
+
+	if (active)
+		list = &mz->active_list;
+	else
+		list = &mz->inactive_list;
 
 	if (list_empty(list))
 		return;
 retry:
 	count = FORCE_UNCHARGE_BATCH;
-	spin_lock_irqsave(&mem->lru_lock, flags);
+	spin_lock_irqsave(&mz->lru_lock, flags);
 
 	while (--count && !list_empty(list)) {
 		pc = list_entry(list->prev, struct page_cgroup, lru);
@@ -850,7 +869,7 @@ retry:
 		} else 	/* being uncharged ? ...do relax */
 			break;
 	}
-	spin_unlock_irqrestore(&mem->lru_lock, flags);
+	spin_unlock_irqrestore(&mz->lru_lock, flags);
 	if (!list_empty(list)) {
 		cond_resched();
 		goto retry;
@@ -881,11 +900,9 @@ int mem_cgroup_force_empty(struct mem_cg
 				struct mem_cgroup_per_zone *mz;
 				mz = mem_cgroup_zoneinfo(mem, node, zid);
 				/* drop all page_cgroup in active_list */
-				mem_cgroup_force_empty_list(mem,
-							&mz->active_list);
+				mem_cgroup_force_empty_list(mem, mz, 1);
 				/* drop all page_cgroup in inactive_list */
-				mem_cgroup_force_empty_list(mem,
-							&mz->inactive_list);
+				mem_cgroup_force_empty_list(mem, mz, 0);
 			}
 	}
 	ret = 0;
@@ -1112,6 +1129,7 @@ static int alloc_mem_cgroup_per_zone_inf
 		mz = &pn->zoneinfo[zone];
 		INIT_LIST_HEAD(&mz->active_list);
 		INIT_LIST_HEAD(&mz->inactive_list);
+		spin_lock_init(&mz->lru_lock);
 	}
 	return 0;
 }
@@ -1136,7 +1154,6 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	res_counter_init(&mem->res);
 
-	spin_lock_init(&mem->lru_lock);
 	mem->control_type = MEM_CGROUP_TYPE_ALL;
 	memset(&mem->info, 0, sizeof(mem->info));
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch
memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch
swapoff-scan-ptes-preemptibly.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
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
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
