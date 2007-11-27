From: akpm@linux-foundation.org
Subject: + per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:02:34 -0800
Message-ID: <200711272202.lARM2YBF032603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756739AbXK0WEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, riel@redhat.com, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     per-zone and reclaim enhancements for memory controller: per-zone active inactive counter
has been added to the -mm tree.  Its filename is
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: per-zone and reclaim enhancements for memory controller: per-zone active inactive counter
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch adds per-zone status in memory cgroup.  These values are often read
(as per-zone value) by page reclaiming.

In current design, per-zone stat is just a unsigned long value and not an
atomic value because they are modified only under lru_lock.  (So, atomic_ops
is not necessary.)

This patch adds ACTIVE and INACTIVE per-zone status values.

For handling per-zone status, this patch adds
  struct mem_cgroup_per_zone {
		...
  }
and some helper functions. This will be useful to add per-zone objects
in mem_cgroup.

This patch turns memory controller's early_init to be 0 for calling
kmalloc() in initialization.

Changelog V2 -> V3
  - fixed comments.

Changelog V1 -> V2
  - added mem_cgroup_per_zone struct.
      This will help following patches to implement per-zone objects and
      pack them into a struct.
  - added __mem_cgroup_add_list() and __mem_cgroup_remove_list()
  - fixed page migration handling.
  - renamed zstat to info (per-zone-info)
    This will be place for per-zone information(lru, lock, ..)
  - use page_cgroup_nid()/zid() funcs.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
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

 mm/memcontrol.c |  164 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 157 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter mm/memcontrol.c
--- a/mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter
+++ a/mm/memcontrol.c
@@ -78,6 +78,31 @@ static s64 mem_cgroup_read_stat(struct m
 }
 
 /*
+ * per-zone information in memory controller.
+ */
+
+enum mem_cgroup_zstat_index {
+	MEM_CGROUP_ZSTAT_ACTIVE,
+	MEM_CGROUP_ZSTAT_INACTIVE,
+
+	NR_MEM_CGROUP_ZSTAT,
+};
+
+struct mem_cgroup_per_zone {
+	unsigned long count[NR_MEM_CGROUP_ZSTAT];
+};
+/* Macro for accessing counter */
+#define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
+
+struct mem_cgroup_per_node {
+	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
+};
+
+struct mem_cgroup_lru_info {
+	struct mem_cgroup_per_node *nodeinfo[MAX_NUMNODES];
+};
+
+/*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
@@ -101,6 +126,7 @@ struct mem_cgroup {
 	 */
 	struct list_head active_list;
 	struct list_head inactive_list;
+	struct mem_cgroup_lru_info info;
 	/*
 	 * spin_lock to protect the per cgroup LRU
 	 */
@@ -158,6 +184,7 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
 };
 
+
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
  */
@@ -173,7 +200,39 @@ static void mem_cgroup_charge_statistics
 					MEM_CGROUP_STAT_CACHE, val);
 	else
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
+}
 
+static inline struct mem_cgroup_per_zone *
+mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
+{
+	if (!mem->info.nodeinfo[nid])
+		return NULL;
+	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
+}
+
+static inline struct mem_cgroup_per_zone *
+page_cgroup_zoneinfo(struct page_cgroup *pc)
+{
+	struct mem_cgroup *mem = pc->mem_cgroup;
+	int nid = page_cgroup_nid(pc);
+	int zid = page_cgroup_zid(pc);
+
+	return mem_cgroup_zoneinfo(mem, nid, zid);
+}
+
+static unsigned long mem_cgroup_get_all_zonestat(struct mem_cgroup *mem,
+					enum mem_cgroup_zstat_index idx)
+{
+	int nid, zid;
+	struct mem_cgroup_per_zone *mz;
+	u64 total = 0;
+
+	for_each_online_node(nid)
+		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+			mz = mem_cgroup_zoneinfo(mem, nid, zid);
+			total += MEM_CGROUP_ZSTAT(mz, idx);
+		}
+	return total;
 }
 
 static struct mem_cgroup init_mem_cgroup;
@@ -286,12 +345,51 @@ static struct page_cgroup *clear_page_cg
 	return ret;
 }
 
+static void __mem_cgroup_remove_list(struct page_cgroup *pc)
+{
+	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+
+	if (from)
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
+	else
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
+
+	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, false);
+	list_del_init(&pc->lru);
+}
+
+static void __mem_cgroup_add_list(struct page_cgroup *pc)
+{
+	int to = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+
+	if (!to) {
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
+		list_add(&pc->lru, &pc->mem_cgroup->inactive_list);
+	} else {
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
+		list_add(&pc->lru, &pc->mem_cgroup->active_list);
+	}
+	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, true);
+}
+
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
+	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+
+	if (from)
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
+	else
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
+
 	if (active) {
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
 		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
 		list_move(&pc->lru, &pc->mem_cgroup->active_list);
 	} else {
+		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
 		list_move(&pc->lru, &pc->mem_cgroup->inactive_list);
 	}
@@ -511,8 +609,7 @@ noreclaim:
 
 	spin_lock_irqsave(&mem->lru_lock, flags);
 	/* Update statistics vector */
-	mem_cgroup_charge_statistics(mem, pc->flags, true);
-	list_add(&pc->lru, &mem->active_list);
+	__mem_cgroup_add_list(pc);
 	spin_unlock_irqrestore(&mem->lru_lock, flags);
 
 done:
@@ -576,13 +673,13 @@ void mem_cgroup_uncharge(struct page_cgr
 			css_put(&mem->css);
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			spin_lock_irqsave(&mem->lru_lock, flags);
-			list_del_init(&pc->lru);
-			mem_cgroup_charge_statistics(mem, pc->flags, false);
+			__mem_cgroup_remove_list(pc);
 			spin_unlock_irqrestore(&mem->lru_lock, flags);
 			kfree(pc);
 		}
 	}
 }
+
 /*
  * Returns non-zero if a page (under migration) has valid page_cgroup member.
  * Refcnt of page_cgroup is incremented.
@@ -614,16 +711,26 @@ void mem_cgroup_end_migration(struct pag
 void mem_cgroup_page_migration(struct page *page, struct page *newpage)
 {
 	struct page_cgroup *pc;
+	struct mem_cgroup *mem;
+	unsigned long flags;
 retry:
 	pc = page_get_page_cgroup(page);
 	if (!pc)
 		return;
+	mem = pc->mem_cgroup;
 	if (clear_page_cgroup(page, pc) != pc)
 		goto retry;
+
+	spin_lock_irqsave(&mem->lru_lock, flags);
+
+	__mem_cgroup_remove_list(pc);
 	pc->page = newpage;
 	lock_page_cgroup(newpage);
 	page_assign_page_cgroup(newpage, pc);
 	unlock_page_cgroup(newpage);
+	__mem_cgroup_add_list(pc);
+
+	spin_unlock_irqrestore(&mem->lru_lock, flags);
 	return;
 }
 
@@ -651,10 +758,11 @@ retry:
 		/* Avoid race with charge */
 		atomic_set(&pc->ref_cnt, 0);
 		if (clear_page_cgroup(page, pc) == pc) {
+			int active;
 			css_put(&mem->css);
+			active = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
-			list_del_init(&pc->lru);
-			mem_cgroup_charge_statistics(mem, pc->flags, false);
+			__mem_cgroup_remove_list(pc);
 			kfree(pc);
 		} else 	/* being uncharged ? ...do relax */
 			break;
@@ -833,6 +941,17 @@ static int mem_control_stat_show(struct 
 		seq_printf(m, "%s %lld\n", mem_cgroup_stat_desc[i].msg,
 				(long long)val);
 	}
+	/* showing # of active pages */
+	{
+		unsigned long active, inactive;
+
+		inactive = mem_cgroup_get_all_zonestat(mem_cont,
+						MEM_CGROUP_ZSTAT_INACTIVE);
+		active = mem_cgroup_get_all_zonestat(mem_cont,
+						MEM_CGROUP_ZSTAT_ACTIVE);
+		seq_printf(m, "active %ld\n", (active) * PAGE_SIZE);
+		seq_printf(m, "inactive %ld\n", (inactive) * PAGE_SIZE);
+	}
 	return 0;
 }
 
@@ -886,12 +1005,25 @@ static struct cftype mem_cgroup_files[] 
 	},
 };
 
+static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
+{
+	struct mem_cgroup_per_node *pn;
+
+	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	if (!pn)
+		return 1;
+	mem->info.nodeinfo[node] = pn;
+	memset(pn, 0, sizeof(*pn));
+	return 0;
+}
+
 static struct mem_cgroup init_mem_cgroup;
 
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem;
+	int node;
 
 	if (unlikely((cont->parent) == NULL)) {
 		mem = &init_mem_cgroup;
@@ -907,7 +1039,19 @@ mem_cgroup_create(struct cgroup_subsys *
 	INIT_LIST_HEAD(&mem->inactive_list);
 	spin_lock_init(&mem->lru_lock);
 	mem->control_type = MEM_CGROUP_TYPE_ALL;
+	memset(&mem->info, 0, sizeof(mem->info));
+
+	for_each_node_state(node, N_POSSIBLE)
+		if (alloc_mem_cgroup_per_zone_info(mem, node))
+			goto free_out;
+
 	return &mem->css;
+free_out:
+	for_each_node_state(node, N_POSSIBLE)
+		kfree(mem->info.nodeinfo[node]);
+	if (cont->parent != NULL)
+		kfree(mem);
+	return NULL;
 }
 
 static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
@@ -920,6 +1064,12 @@ static void mem_cgroup_pre_destroy(struc
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
+	int node;
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+
+	for_each_node_state(node, N_POSSIBLE)
+		kfree(mem->info.nodeinfo[node]);
+
 	kfree(mem_cgroup_from_cont(cont));
 }
 
@@ -972,5 +1122,5 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.destroy = mem_cgroup_destroy,
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
-	.early_init = 1,
+	.early_init = 0,
 };
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
