From: akpm@linux-foundation.org
Subject: + cpuset-dont-allocate-trial-cpuset-on-stack.patch added to -mm tree
Date: Sun, 04 Jan 2009 23:48:01 -0800
Message-ID: <200901050748.n057m1i8026604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbZAEHs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 02:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com


The patch titled
     cpuset: don't allocate trial cpuset on stack
has been added to the -mm tree.  Its filename is
     cpuset-dont-allocate-trial-cpuset-on-stack.patch

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
Subject: cpuset: don't allocate trial cpuset on stack
From: Li Zefan <lizf@cn.fujitsu.com>

Impact: cleanups, reduce stack usage

This patch prepares for the next patch.  When we convert
cpuset.cpus_allowed to cpumask_var_t, (trialcs = *cs) no longer works.

Another result of this patch is reducing stack usage of trialcs. 
sizeof(*cs) can be as large as 148 bytes on x86_64, so it's really not
good to have it on stack.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   93 +++++++++++++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 33 deletions(-)

diff -puN kernel/cpuset.c~cpuset-dont-allocate-trial-cpuset-on-stack kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-dont-allocate-trial-cpuset-on-stack
+++ a/kernel/cpuset.c
@@ -415,6 +415,24 @@ static int is_cpuset_subset(const struct
 		is_mem_exclusive(p) <= is_mem_exclusive(q);
 }
 
+/**
+ * alloc_trial_cpuset - allocate a trial cpuset
+ * @cs: the cpuset that the trial cpuset duplicates
+ */
+static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
+{
+	return kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+}
+
+/**
+ * free_trial_cpuset - free the trial cpuset
+ * @trial: the trial cpuset to be freed
+ */
+static void free_trial_cpuset(struct cpuset *trial)
+{
+	kfree(trial);
+}
+
 /*
  * validate_change() - Used to validate that any proposed cpuset change
  *		       follows the structural rules for cpusets.
@@ -880,10 +898,10 @@ static void update_tasks_cpumask(struct 
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
  */
-static int update_cpumask(struct cpuset *cs, const char *buf)
+static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
+			  const char *buf)
 {
 	struct ptr_heap heap;
-	struct cpuset trialcs;
 	int retval;
 	int is_load_balanced;
 
@@ -891,8 +909,6 @@ static int update_cpumask(struct cpuset 
 	if (cs == &top_cpuset)
 		return -EACCES;
 
-	trialcs = *cs;
-
 	/*
 	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
 	 * Since cpulist_parse() fails on an empty mask, we special case
@@ -900,31 +916,31 @@ static int update_cpumask(struct cpuset 
 	 * with tasks have cpus.
 	 */
 	if (!*buf) {
-		cpus_clear(trialcs.cpus_allowed);
+		cpus_clear(trialcs->cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, &trialcs.cpus_allowed);
+		retval = cpulist_parse(buf, &trialcs->cpus_allowed);
 		if (retval < 0)
 			return retval;
 
-		if (!cpus_subset(trialcs.cpus_allowed, cpu_online_map))
+		if (!cpus_subset(trialcs->cpus_allowed, cpu_online_map))
 			return -EINVAL;
 	}
-	retval = validate_change(cs, &trialcs);
+	retval = validate_change(cs, trialcs);
 	if (retval < 0)
 		return retval;
 
 	/* Nothing to do if the cpus didn't change */
-	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
+	if (cpus_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
 
-	is_load_balanced = is_sched_load_balance(&trialcs);
+	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
-	cs->cpus_allowed = trialcs.cpus_allowed;
+	cs->cpus_allowed = trialcs->cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1099,9 +1115,9 @@ done:
  * lock each such tasks mm->mmap_sem, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
  */
-static int update_nodemask(struct cpuset *cs, const char *buf)
+static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
+			   const char *buf)
 {
-	struct cpuset trialcs;
 	nodemask_t oldmem;
 	int retval;
 
@@ -1112,8 +1128,6 @@ static int update_nodemask(struct cpuset
 	if (cs == &top_cpuset)
 		return -EACCES;
 
-	trialcs = *cs;
-
 	/*
 	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
 	 * Since nodelist_parse() fails on an empty mask, we special case
@@ -1121,27 +1135,27 @@ static int update_nodemask(struct cpuset
 	 * with tasks have memory.
 	 */
 	if (!*buf) {
-		nodes_clear(trialcs.mems_allowed);
+		nodes_clear(trialcs->mems_allowed);
 	} else {
-		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		retval = nodelist_parse(buf, trialcs->mems_allowed);
 		if (retval < 0)
 			goto done;
 
-		if (!nodes_subset(trialcs.mems_allowed,
+		if (!nodes_subset(trialcs->mems_allowed,
 				node_states[N_HIGH_MEMORY]))
 			return -EINVAL;
 	}
 	oldmem = cs->mems_allowed;
-	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
+	if (nodes_equal(oldmem, trialcs->mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	retval = validate_change(cs, &trialcs);
+	retval = validate_change(cs, trialcs);
 	if (retval < 0)
 		goto done;
 
 	mutex_lock(&callback_mutex);
-	cs->mems_allowed = trialcs.mems_allowed;
+	cs->mems_allowed = trialcs->mems_allowed;
 	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
@@ -1181,31 +1195,36 @@ static int update_relax_domain_level(str
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
-	struct cpuset trialcs;
+	struct cpuset *trialcs;
 	int err;
 	int balance_flag_changed;
 
-	trialcs = *cs;
+	trialcs = alloc_trial_cpuset(cs);
+	if (!trialcs)
+		return -ENOMEM;
+
 	if (turning_on)
-		set_bit(bit, &trialcs.flags);
+		set_bit(bit, &trialcs->flags);
 	else
-		clear_bit(bit, &trialcs.flags);
+		clear_bit(bit, &trialcs->flags);
 
-	err = validate_change(cs, &trialcs);
+	err = validate_change(cs, trialcs);
 	if (err < 0)
-		return err;
+		goto out;
 
 	balance_flag_changed = (is_sched_load_balance(cs) !=
-		 			is_sched_load_balance(&trialcs));
+				is_sched_load_balance(trialcs));
 
 	mutex_lock(&callback_mutex);
-	cs->flags = trialcs.flags;
+	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
 
-	if (!cpus_empty(trialcs.cpus_allowed) && balance_flag_changed)
+	if (!cpus_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
-	return 0;
+out:
+	free_trial_cpuset(trialcs);
+	return err;
 }
 
 /*
@@ -1471,21 +1490,29 @@ static int cpuset_write_resmask(struct c
 				const char *buf)
 {
 	int retval = 0;
+	struct cpuset *cs = cgroup_cs(cgrp);
+	struct cpuset *trialcs;
 
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 
+	trialcs = alloc_trial_cpuset(cs);
+	if (!trialcs)
+		return -ENOMEM;
+
 	switch (cft->private) {
 	case FILE_CPULIST:
-		retval = update_cpumask(cgroup_cs(cgrp), buf);
+		retval = update_cpumask(cs, trialcs, buf);
 		break;
 	case FILE_MEMLIST:
-		retval = update_nodemask(cgroup_cs(cgrp), buf);
+		retval = update_nodemask(cs, trialcs, buf);
 		break;
 	default:
 		retval = -EINVAL;
 		break;
 	}
+
+	free_trial_cpuset(trialcs);
 	cgroup_unlock();
 	return retval;
 }
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

