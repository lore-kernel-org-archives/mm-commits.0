From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_same_or_subtree-helper.patch added to -mm tree
Date: Fri, 22 Jul 2011 14:35:53 -0700
Message-ID: <201107222135.p6MLZr7H013737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269Ab1GVVgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 17:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: add mem_cgroup_same_or_subtree() helper
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_same_or_subtree-helper.patch

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
Subject: memcg: add mem_cgroup_same_or_subtree() helper
From: Michal Hocko <mhocko@suse.cz>

We are checking whether a given two groups are same or at least in the
same subtree of a hierarchy at several places.  Let's make a helper for it
to make code easier to read.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   51 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_same_or_subtree-helper mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_same_or_subtree-helper
+++ a/mm/memcontrol.c
@@ -1062,6 +1062,21 @@ void mem_cgroup_move_lists(struct page *
 	mem_cgroup_add_lru_list(page, to);
 }
 
+/*
+ * Checks whether given mem is same or in the root_mem's
+ * hierarchy subtree
+ */
+static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_mem,
+		struct mem_cgroup *mem)
+{
+	if (root_mem != mem) {
+		return (root_mem->use_hierarchy &&
+			css_is_ancestor(&mem->css, &root_mem->css));
+	}
+
+	return true;
+}
+
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 {
 	int ret;
@@ -1081,10 +1096,7 @@ int task_in_mem_cgroup(struct task_struc
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
-	if (mem->use_hierarchy)
-		ret = css_is_ancestor(&curr->css, &mem->css);
-	else
-		ret = (curr == mem);
+	ret = mem_cgroup_same_or_subtree(mem, curr);
 	css_put(&curr->css);
 	return ret;
 }
@@ -1323,10 +1335,9 @@ static bool mem_cgroup_under_move(struct
 	to = mc.to;
 	if (!from)
 		goto unlock;
-	if (from == mem || to == mem
-	    || (mem->use_hierarchy && css_is_ancestor(&from->css, &mem->css))
-	    || (mem->use_hierarchy && css_is_ancestor(&to->css,	&mem->css)))
-		ret = true;
+
+	ret = mem_cgroup_same_or_subtree(mem, from)
+		|| mem_cgroup_same_or_subtree(mem, to);
 unlock:
 	spin_unlock(&mc.lock);
 	return ret;
@@ -1812,25 +1823,20 @@ struct oom_wait_info {
 static int memcg_oom_wake_function(wait_queue_t *wait,
 	unsigned mode, int sync, void *arg)
 {
-	struct mem_cgroup *wake_mem = (struct mem_cgroup *)arg;
+	struct mem_cgroup *wake_mem = (struct mem_cgroup *)arg,
+			  *oom_wait_mem;
 	struct oom_wait_info *oom_wait_info;
 
 	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
+	oom_wait_mem = oom_wait_info->mem;
 
-	if (oom_wait_info->mem == wake_mem)
-		goto wakeup;
-	/* if no hierarchy, no match */
-	if (!oom_wait_info->mem->use_hierarchy || !wake_mem->use_hierarchy)
-		return 0;
 	/*
 	 * Both of oom_wait_info->mem and wake_mem are stable under us.
 	 * Then we can use css_is_ancestor without taking care of RCU.
 	 */
-	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
-	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
+	if (!mem_cgroup_same_or_subtree(oom_wait_mem, wake_mem)
+			&& !mem_cgroup_same_or_subtree(wake_mem, oom_wait_mem))
 		return 0;
-
-wakeup:
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
@@ -2075,13 +2081,8 @@ static void drain_all_stock(struct mem_c
 		mem = stock->cached;
 		if (!mem || !stock->nr_pages)
 			continue;
-		if (mem != root_mem) {
-			if (!root_mem->use_hierarchy)
-				continue;
-			/* check whether "mem" is under tree of "root_mem" */
-			if (!css_is_ancestor(&mem->css, &root_mem->css))
-				continue;
-		}
+		if (!mem_cgroup_same_or_subtree(root_mem, mem))
+			continue;
 		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
 			if (cpu == curcpu)
 				drain_local_stock(&stock->work);
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-remove-the-leftovers-of-noswapaccount.patch
mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
um-clean-up-vm-flagsh.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch
memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch
memcg-add-mem_cgroup_same_or_subtree-helper.patch
memcg-get-rid-of-percpu_charge_mutex-lock.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

