From: akpm@linux-foundation.org
Subject: + per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:02:48 -0800
Message-ID: <200711272202.lARM2nVv032661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbXK0WOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, riel@redhat.com, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     per-zone and reclaim enhancements for memory controller: per zone lru for cgroup
has been added to the -mm tree.  Its filename is
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: per-zone and reclaim enhancements for memory controller: per zone lru for cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch implements per-zone lru for memory cgroup.
This patch makes use of mem_cgroup_per_zone struct for per zone lru.

LRU can be accessed by

   mz = mem_cgroup_zoneinfo(mem_cgroup, node, zone);
   &mz->active_list
   &mz->inactive_list

   or
   mz = page_cgroup_zoneinfo(page_cgroup);
   &mz->active_list
   &mz->inactive_list

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

 mm/memcontrol.c |   63 ++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff -puN mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup
+++ a/mm/memcontrol.c
@@ -89,6 +89,8 @@ enum mem_cgroup_zstat_index {
 };
 
 struct mem_cgroup_per_zone {
+	struct list_head	active_list;
+	struct list_head	inactive_list;
 	unsigned long count[NR_MEM_CGROUP_ZSTAT];
 };
 /* Macro for accessing counter */
@@ -122,10 +124,7 @@ struct mem_cgroup {
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
-	 * TODO: Consider making these lists per zone
 	 */
-	struct list_head active_list;
-	struct list_head inactive_list;
 	struct mem_cgroup_lru_info info;
 	/*
 	 * spin_lock to protect the per cgroup LRU
@@ -367,10 +366,10 @@ static void __mem_cgroup_add_list(struct
 
 	if (!to) {
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
-		list_add(&pc->lru, &pc->mem_cgroup->inactive_list);
+		list_add(&pc->lru, &mz->inactive_list);
 	} else {
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
-		list_add(&pc->lru, &pc->mem_cgroup->active_list);
+		list_add(&pc->lru, &mz->active_list);
 	}
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, true);
 }
@@ -388,11 +387,11 @@ static void __mem_cgroup_move_lists(stru
 	if (active) {
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
 		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-		list_move(&pc->lru, &pc->mem_cgroup->active_list);
+		list_move(&pc->lru, &mz->active_list);
 	} else {
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
-		list_move(&pc->lru, &pc->mem_cgroup->inactive_list);
+		list_move(&pc->lru, &mz->inactive_list);
 	}
 }
 
@@ -518,11 +517,16 @@ unsigned long mem_cgroup_isolate_pages(u
 	LIST_HEAD(pc_list);
 	struct list_head *src;
 	struct page_cgroup *pc, *tmp;
+	int nid = z->zone_pgdat->node_id;
+	int zid = zone_idx(z);
+	struct mem_cgroup_per_zone *mz;
 
+	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
 	if (active)
-		src = &mem_cont->active_list;
+		src = &mz->active_list;
 	else
-		src = &mem_cont->inactive_list;
+		src = &mz->inactive_list;
+
 
 	spin_lock(&mem_cont->lru_lock);
 	scan = 0;
@@ -544,13 +548,6 @@ unsigned long mem_cgroup_isolate_pages(u
 			continue;
 		}
 
-		/*
-		 * Reclaim, per zone
-		 * TODO: make the active/inactive lists per zone
-		 */
-		if (page_zone(page) != z)
-			continue;
-
 		scan++;
 		list_move(&pc->lru, &pc_list);
 
@@ -832,6 +829,8 @@ mem_cgroup_force_empty_list(struct mem_c
 	int count;
 	unsigned long flags;
 
+	if (list_empty(list))
+		return;
 retry:
 	count = FORCE_UNCHARGE_BATCH;
 	spin_lock_irqsave(&mem->lru_lock, flags);
@@ -867,20 +866,27 @@ retry:
 int mem_cgroup_force_empty(struct mem_cgroup *mem)
 {
 	int ret = -EBUSY;
+	int node, zid;
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
 `	 * active_list <-> inactive_list while we don't take a lock.
 	 * So, we have to do loop here until all lists are empty.
 	 */
-	while (!(list_empty(&mem->active_list) &&
-		 list_empty(&mem->inactive_list))) {
+	while (mem->res.usage > 0) {
 		if (atomic_read(&mem->css.cgroup->count) > 0)
 			goto out;
-		/* drop all page_cgroup in active_list */
-		mem_cgroup_force_empty_list(mem, &mem->active_list);
-		/* drop all page_cgroup in inactive_list */
-		mem_cgroup_force_empty_list(mem, &mem->inactive_list);
+		for_each_node_state(node, N_POSSIBLE)
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+				struct mem_cgroup_per_zone *mz;
+				mz = mem_cgroup_zoneinfo(mem, node, zid);
+				/* drop all page_cgroup in active_list */
+				mem_cgroup_force_empty_list(mem,
+							&mz->active_list);
+				/* drop all page_cgroup in inactive_list */
+				mem_cgroup_force_empty_list(mem,
+							&mz->inactive_list);
+			}
 	}
 	ret = 0;
 out:
@@ -1092,15 +1098,25 @@ static struct cftype mem_cgroup_files[] 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 {
 	struct mem_cgroup_per_node *pn;
+	struct mem_cgroup_per_zone *mz;
+	int zone;
 
 	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
 	if (!pn)
 		return 1;
+
 	mem->info.nodeinfo[node] = pn;
 	memset(pn, 0, sizeof(*pn));
+
+	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		mz = &pn->zoneinfo[zone];
+		INIT_LIST_HEAD(&mz->active_list);
+		INIT_LIST_HEAD(&mz->inactive_list);
+	}
 	return 0;
 }
 
+
 static struct mem_cgroup init_mem_cgroup;
 
 static struct cgroup_subsys_state *
@@ -1119,8 +1135,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		return NULL;
 
 	res_counter_init(&mem->res);
-	INIT_LIST_HEAD(&mem->active_list);
-	INIT_LIST_HEAD(&mem->inactive_list);
+
 	spin_lock_init(&mem->lru_lock);
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
