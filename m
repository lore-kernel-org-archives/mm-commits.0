From: akpm@linux-foundation.org
Subject: + cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch added to -mm tree
Date: Sun, 04 Jan 2009 23:48:03 -0800
Message-ID: <200901050748.n057m3pt026613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZAEHs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 02:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com


The patch titled
     cpuset: convert cpuset->cpus_allowed to cpumask_var_t
has been added to the -mm tree.  Its filename is
     cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: convert cpuset->cpus_allowed to cpumask_var_t
From: Li Zefan <lizf@cn.fujitsu.com>

Impact: use new cpumask API

This patch mainly does the following things:
- change cs->cpus_allowed from cpumask_t to cpumask_var_t
- call alloc_bootmem_cpumask_var() for top_cpuset in cpuset_init_early()
- call alloc_cpumask_var() for other cpusets
- replace cpus_xxx() to cpumask_xxx()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  100 +++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 40 deletions(-)

diff -puN kernel/cpuset.c~cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t
+++ a/kernel/cpuset.c
@@ -84,7 +84,7 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
-	cpumask_t cpus_allowed;		/* CPUs allowed to tasks in cpuset */
+	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
 	struct cpuset *parent;		/* my parent */
@@ -195,8 +195,6 @@ static int cpuset_mems_generation;
 
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
-	.cpus_allowed = CPU_MASK_ALL,
-	.mems_allowed = NODE_MASK_ALL,
 };
 
 /*
@@ -278,7 +276,7 @@ static struct file_system_type cpuset_fs
 };
 
 /*
- * Return in *pmask the portion of a cpusets's cpus_allowed that
+ * Return in pmask the portion of a cpusets's cpus_allowed that
  * are online.  If none are online, walk up the cpuset hierarchy
  * until we find one that does have some online cpus.  If we get
  * all the way to the top and still haven't found any online cpus,
@@ -293,13 +291,13 @@ static struct file_system_type cpuset_fs
 
 static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t *pmask)
 {
-	while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
+	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cs = cs->parent;
 	if (cs)
-		cpus_and(*pmask, cs->cpus_allowed, cpu_online_map);
+		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 	else
-		*pmask = cpu_online_map;
-	BUG_ON(!cpus_intersects(*pmask, cpu_online_map));
+		cpumask_copy(pmask, cpu_online_mask);
+	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
 }
 
 /*
@@ -409,7 +407,7 @@ void cpuset_update_task_memory_state(voi
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
 {
-	return	cpus_subset(p->cpus_allowed, q->cpus_allowed) &&
+	return	cpumask_subset(p->cpus_allowed, q->cpus_allowed) &&
 		nodes_subset(p->mems_allowed, q->mems_allowed) &&
 		is_cpu_exclusive(p) <= is_cpu_exclusive(q) &&
 		is_mem_exclusive(p) <= is_mem_exclusive(q);
@@ -421,7 +419,19 @@ static int is_cpuset_subset(const struct
  */
 static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
 {
-	return kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+	struct cpuset *trial;
+
+	trial = kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+	if (!trial)
+		return NULL;
+
+	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL)) {
+		kfree(trial);
+		return NULL;
+	}
+	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+
+	return trial;
 }
 
 /**
@@ -430,6 +440,7 @@ static struct cpuset *alloc_trial_cpuset
  */
 static void free_trial_cpuset(struct cpuset *trial)
 {
+	free_cpumask_var(trial->cpus_allowed);
 	kfree(trial);
 }
 
@@ -482,7 +493,7 @@ static int validate_change(const struct 
 		c = cgroup_cs(cont);
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
 		    c != cur &&
-		    cpus_intersects(trial->cpus_allowed, c->cpus_allowed))
+		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
 			return -EINVAL;
 		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
 		    c != cur &&
@@ -492,7 +503,7 @@ static int validate_change(const struct 
 
 	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
 	if (cgroup_task_count(cur->css.cgroup)) {
-		if (cpus_empty(trial->cpus_allowed) ||
+		if (cpumask_empty(trial->cpus_allowed) ||
 		    nodes_empty(trial->mems_allowed)) {
 			return -ENOSPC;
 		}
@@ -507,7 +518,7 @@ static int validate_change(const struct 
  */
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 {
-	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
+	return cpumask_intersects(a->cpus_allowed, b->cpus_allowed);
 }
 
 static void
@@ -532,7 +543,7 @@ update_domain_attr_tree(struct sched_dom
 		cp = list_first_entry(&q, struct cpuset, stack_list);
 		list_del(q.next);
 
-		if (cpus_empty(cp->cpus_allowed))
+		if (cpumask_empty(cp->cpus_allowed))
 			continue;
 
 		if (is_sched_load_balance(cp))
@@ -627,7 +638,7 @@ static int generate_sched_domains(cpumas
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		*doms = top_cpuset.cpus_allowed;
+		cpumask_copy(doms, top_cpuset.cpus_allowed);
 
 		ndoms = 1;
 		goto done;
@@ -646,7 +657,7 @@ static int generate_sched_domains(cpumas
 		cp = list_first_entry(&q, struct cpuset, stack_list);
 		list_del(q.next);
 
-		if (cpus_empty(cp->cpus_allowed))
+		if (cpumask_empty(cp->cpus_allowed))
 			continue;
 
 		/*
@@ -739,7 +750,7 @@ restart:
 			struct cpuset *b = csa[j];
 
 			if (apn == b->pn) {
-				cpus_or(*dp, *dp, b->cpus_allowed);
+				cpumask_or(dp, dp, b->cpus_allowed);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -848,7 +859,7 @@ void rebuild_sched_domains(void)
 static int cpuset_test_cpumask(struct task_struct *tsk,
 			       struct cgroup_scanner *scan)
 {
-	return !cpus_equal(tsk->cpus_allowed,
+	return !cpumask_equal(&tsk->cpus_allowed,
 			(cgroup_cs(scan->cg))->cpus_allowed);
 }
 
@@ -866,7 +877,7 @@ static int cpuset_test_cpumask(struct ta
 static void cpuset_change_cpumask(struct task_struct *tsk,
 				  struct cgroup_scanner *scan)
 {
-	set_cpus_allowed_ptr(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
+	set_cpus_allowed_ptr(tsk, ((cgroup_cs(scan->cg))->cpus_allowed));
 }
 
 /**
@@ -916,13 +927,13 @@ static int update_cpumask(struct cpuset 
 	 * with tasks have cpus.
 	 */
 	if (!*buf) {
-		cpus_clear(trialcs->cpus_allowed);
+		cpumask_clear(trialcs->cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, &trialcs->cpus_allowed);
+		retval = cpulist_parse(buf, trialcs->cpus_allowed);
 		if (retval < 0)
 			return retval;
 
-		if (!cpus_subset(trialcs->cpus_allowed, cpu_online_map))
+		if (!cpumask_subset(trialcs->cpus_allowed, cpu_online_mask))
 			return -EINVAL;
 	}
 	retval = validate_change(cs, trialcs);
@@ -930,7 +941,7 @@ static int update_cpumask(struct cpuset 
 		return retval;
 
 	/* Nothing to do if the cpus didn't change */
-	if (cpus_equal(cs->cpus_allowed, trialcs->cpus_allowed))
+	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
@@ -940,7 +951,7 @@ static int update_cpumask(struct cpuset 
 	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
-	cs->cpus_allowed = trialcs->cpus_allowed;
+	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1028,7 +1039,7 @@ static int update_tasks_nodemask(struct 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
 	fudge = 10;				/* spare mmarray[] slots */
-	fudge += cpus_weight(cs->cpus_allowed);	/* imagine one fork-bomb/cpu */
+	fudge += cpumask_weight(cs->cpus_allowed);/* imagine 1 fork-bomb/cpu */
 	retval = -ENOMEM;
 
 	/*
@@ -1176,7 +1187,8 @@ static int update_relax_domain_level(str
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
+		if (!cpumask_empty(cs->cpus_allowed) &&
+		    is_sched_load_balance(cs))
 			async_rebuild_sched_domains();
 	}
 
@@ -1219,7 +1231,7 @@ static int update_flag(cpuset_flagbits_t
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
 
-	if (!cpus_empty(trialcs->cpus_allowed) && balance_flag_changed)
+	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
 out:
@@ -1340,12 +1352,12 @@ static int cpuset_can_attach(struct cgro
 	struct cpuset *cs = cgroup_cs(cont);
 	int ret = 0;
 
-	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
+	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
 
 	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		if (!cpus_equal(tsk->cpus_allowed, cs->cpus_allowed))
+		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
 
@@ -1534,7 +1546,7 @@ static int cpuset_sprintf_cpulist(char *
 	int ret;
 
 	mutex_lock(&callback_mutex);
-	ret = cpulist_scnprintf(page, PAGE_SIZE, &cs->cpus_allowed);
+	ret = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	return ret;
@@ -1773,7 +1785,7 @@ static void cpuset_post_clone(struct cgr
 	parent_cs = cgroup_cs(parent);
 
 	cs->mems_allowed = parent_cs->mems_allowed;
-	cs->cpus_allowed = parent_cs->cpus_allowed;
+	cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
 	return;
 }
 
@@ -1799,6 +1811,10 @@ static struct cgroup_subsys_state *cpuse
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
+	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
+		kfree(cs);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	cpuset_update_task_memory_state();
 	cs->flags = 0;
@@ -1807,7 +1823,7 @@ static struct cgroup_subsys_state *cpuse
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
-	cpus_clear(cs->cpus_allowed);
+	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
 	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
@@ -1834,6 +1850,7 @@ static void cpuset_destroy(struct cgroup
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	number_of_cpusets--;
+	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
 }
 
@@ -1857,6 +1874,8 @@ struct cgroup_subsys cpuset_subsys = {
 
 int __init cpuset_init_early(void)
 {
+	alloc_bootmem_cpumask_var(&top_cpuset.cpus_allowed);
+
 	top_cpuset.mems_generation = cpuset_mems_generation++;
 	return 0;
 }
@@ -1872,7 +1891,7 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
-	cpus_setall(top_cpuset.cpus_allowed);
+	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 
 	fmeter_init(&top_cpuset.fmeter);
@@ -1958,7 +1977,7 @@ static void remove_tasks_in_empty_cpuset
 	 * has online cpus, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpus_empty(parent->cpus_allowed) ||
+	while (cpumask_empty(parent->cpus_allowed) ||
 			nodes_empty(parent->mems_allowed))
 		parent = parent->parent;
 
@@ -1999,7 +2018,7 @@ static void scan_for_empty_cpusets(struc
 		}
 
 		/* Continue past cpusets with all cpus, mems online */
-		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
+		if (cpumask_subset(cp->cpus_allowed, cpu_online_mask) &&
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
@@ -2007,13 +2026,14 @@ static void scan_for_empty_cpusets(struc
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
-		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
+		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
+			    cpu_online_mask);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);
 
 		/* Move tasks from the empty cpuset to a parent */
-		if (cpus_empty(cp->cpus_allowed) ||
+		if (cpumask_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
 		else {
@@ -2054,7 +2074,7 @@ static int cpuset_track_online_cpus(stru
 	}
 
 	cgroup_lock();
-	top_cpuset.cpus_allowed = cpu_online_map;
+	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
@@ -2099,7 +2119,7 @@ static int cpuset_track_online_nodes(str
 
 void __init cpuset_init_smp(void)
 {
-	top_cpuset.cpus_allowed = cpu_online_map;
+	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
@@ -2111,7 +2131,7 @@ void __init cpuset_init_smp(void)
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
  * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
  *
- * Description: Returns the cpumask_t cpus_allowed of the cpuset
+ * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
  * subset of cpu_online_map, even if this means going outside the
  * tasks cpuset.
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
vfs-factor-out-duplicated-code-in-get_fs_type.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-make-cgroup_path-rcu-safe.patch
cgroups-make-cgroup_path-rcu-safe-fixlet.patch
devices-cgroup-allow-mkfifo.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-swapout-refcnt-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch
cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch
cpuset-dont-allocate-trial-cpuset-on-stack.patch
cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch
cpuset-remove-remaining-pointers-to-cpumask_t.patch

