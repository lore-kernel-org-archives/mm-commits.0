From: akpm@linux-foundation.org
Subject: - per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:05:01 -0800
Message-ID: <200802080804.m1884gM0014277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760499AbYBHIbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:31:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     per-zone and reclaim enhancements for memory controller: per zone lru for cgroup
has been removed from the -mm tree.  Its filename was
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

 mm/memcontrol.c |   86 +++++++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 28 deletions(-)

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
@@ -366,10 +365,10 @@ static void __mem_cgroup_add_list(struct
 
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
@@ -387,11 +386,11 @@ static void __mem_cgroup_move_lists(stru
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
 
@@ -517,11 +516,16 @@ unsigned long mem_cgroup_isolate_pages(u
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
@@ -543,13 +547,6 @@ unsigned long mem_cgroup_isolate_pages(u
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
 
@@ -826,6 +823,8 @@ mem_cgroup_force_empty_list(struct mem_c
 	int count;
 	unsigned long flags;
 
+	if (list_empty(list))
+		return;
 retry:
 	count = FORCE_UNCHARGE_BATCH;
 	spin_lock_irqsave(&mem->lru_lock, flags);
@@ -859,20 +858,27 @@ retry:
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
@@ -1084,15 +1090,40 @@ static struct cftype mem_cgroup_files[] 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 {
 	struct mem_cgroup_per_node *pn;
-
-	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	struct mem_cgroup_per_zone *mz;
+	int zone;
+	/*
+	 * This routine is called against possible nodes.
+	 * But it's BUG to call kmalloc() against offline node.
+	 *
+	 * TODO: this routine can waste much memory for nodes which will
+	 *       never be onlined. It's better to use memory hotplug callback
+	 *       function.
+	 */
+	if (node_state(node, N_HIGH_MEMORY))
+		pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	else
+		pn = kmalloc(sizeof(*pn), GFP_KERNEL);
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
 
+static void free_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
+{
+	kfree(mem->info.nodeinfo[node]);
+}
+
+
 static struct mem_cgroup init_mem_cgroup;
 
 static struct cgroup_subsys_state *
@@ -1111,8 +1142,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		return NULL;
 
 	res_counter_init(&mem->res);
-	INIT_LIST_HEAD(&mem->active_list);
-	INIT_LIST_HEAD(&mem->inactive_list);
+
 	spin_lock_init(&mem->lru_lock);
 	mem->control_type = MEM_CGROUP_TYPE_ALL;
 	memset(&mem->info, 0, sizeof(mem->info));
@@ -1124,7 +1154,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
-		kfree(mem->info.nodeinfo[node]);
+		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
 		kfree(mem);
 	return NULL;
@@ -1144,7 +1174,7 @@ static void mem_cgroup_destroy(struct cg
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
 
 	for_each_node_state(node, N_POSSIBLE)
-		kfree(mem->info.nodeinfo[node]);
+		free_mem_cgroup_per_zone_info(mem, node);
 
 	kfree(mem_cgroup_from_cont(cont));
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
