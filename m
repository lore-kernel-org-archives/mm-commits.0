From: akpm@linux-foundation.org
Subject: + cpuset-use-n_memory-instead-n_high_memory.patch added to -mm tree
Date: Thu, 15 Nov 2012 16:34:24 -0800
Message-ID: <20121116003425.3C142100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:56932 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2KPAe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 19:34:26 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so247679yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 16:34:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: cpuset: use N_MEMORY instead N_HIGH_MEMORY
has been added to the -mm tree.  Its filename is
     cpuset-use-n_memory-instead-n_high_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: cpuset: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cpusets.txt |    2 -
 include/linux/cpuset.h            |    2 -
 kernel/cpuset.c                   |   32 ++++++++++++++--------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff -puN Documentation/cgroups/cpusets.txt~cpuset-use-n_memory-instead-n_high_memory Documentation/cgroups/cpusets.txt
--- a/Documentation/cgroups/cpusets.txt~cpuset-use-n_memory-instead-n_high_memory
+++ a/Documentation/cgroups/cpusets.txt
@@ -218,7 +218,7 @@ and name space for cpusets, with a minim
 The cpus and mems files in the root (top_cpuset) cpuset are
 read-only.  The cpus file automatically tracks the value of
 cpu_online_mask using a CPU hotplug notifier, and the mems file
-automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,
+automatically tracks the value of node_states[N_MEMORY]--i.e.,
 nodes with memory--using the cpuset_track_online_nodes() hook.
 
 
diff -puN include/linux/cpuset.h~cpuset-use-n_memory-instead-n_high_memory include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-use-n_memory-instead-n_high_memory
+++ a/include/linux/cpuset.h
@@ -144,7 +144,7 @@ static inline nodemask_t cpuset_mems_all
 	return node_possible_map;
 }
 
-#define cpuset_current_mems_allowed (node_states[N_HIGH_MEMORY])
+#define cpuset_current_mems_allowed (node_states[N_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
 
 static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
diff -puN kernel/cpuset.c~cpuset-use-n_memory-instead-n_high_memory kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-use-n_memory-instead-n_high_memory
+++ a/kernel/cpuset.c
@@ -302,10 +302,10 @@ static void guarantee_online_cpus(const 
  * are online, with memory.  If none are online with memory, walk
  * up the cpuset hierarchy until we find one that does have some
  * online mems.  If we get all the way to the top and still haven't
- * found any online mems, return node_states[N_HIGH_MEMORY].
+ * found any online mems, return node_states[N_MEMORY].
  *
  * One way or another, we guarantee to return some non-empty subset
- * of node_states[N_HIGH_MEMORY].
+ * of node_states[N_MEMORY].
  *
  * Call with callback_mutex held.
  */
@@ -313,14 +313,14 @@ static void guarantee_online_cpus(const 
 static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 {
 	while (cs && !nodes_intersects(cs->mems_allowed,
-					node_states[N_HIGH_MEMORY]))
+					node_states[N_MEMORY]))
 		cs = cs->parent;
 	if (cs)
 		nodes_and(*pmask, cs->mems_allowed,
-					node_states[N_HIGH_MEMORY]);
+					node_states[N_MEMORY]);
 	else
-		*pmask = node_states[N_HIGH_MEMORY];
-	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
+		*pmask = node_states[N_MEMORY];
+	BUG_ON(!nodes_intersects(*pmask, node_states[N_MEMORY]));
 }
 
 /*
@@ -1100,7 +1100,7 @@ static int update_nodemask(struct cpuset
 		return -ENOMEM;
 
 	/*
-	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
+	 * top_cpuset.mems_allowed tracks node_stats[N_MEMORY];
 	 * it's read-only
 	 */
 	if (cs == &top_cpuset) {
@@ -1122,7 +1122,7 @@ static int update_nodemask(struct cpuset
 			goto done;
 
 		if (!nodes_subset(trialcs->mems_allowed,
-				node_states[N_HIGH_MEMORY])) {
+				node_states[N_MEMORY])) {
 			retval =  -EINVAL;
 			goto done;
 		}
@@ -2034,7 +2034,7 @@ static struct cpuset *cpuset_next(struct
  * before dropping down to the next.  It always processes a node before
  * any of its children.
  *
- * In the case of memory hot-unplug, it will remove nodes from N_HIGH_MEMORY
+ * In the case of memory hot-unplug, it will remove nodes from N_MEMORY
  * if all present pages from a node are offlined.
  */
 static void
@@ -2073,7 +2073,7 @@ scan_cpusets_upon_hotplug(struct cpuset 
 
 			/* Continue past cpusets with all mems online */
 			if (nodes_subset(cp->mems_allowed,
-					node_states[N_HIGH_MEMORY]))
+					node_states[N_MEMORY]))
 				continue;
 
 			oldmems = cp->mems_allowed;
@@ -2081,7 +2081,7 @@ scan_cpusets_upon_hotplug(struct cpuset 
 			/* Remove offline mems from this cpuset. */
 			mutex_lock(&callback_mutex);
 			nodes_and(cp->mems_allowed, cp->mems_allowed,
-						node_states[N_HIGH_MEMORY]);
+						node_states[N_MEMORY]);
 			mutex_unlock(&callback_mutex);
 
 			/* Move tasks from the empty cpuset to a parent */
@@ -2134,8 +2134,8 @@ void cpuset_update_active_cpus(bool cpu_
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
- * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
- * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
+ * Keep top_cpuset.mems_allowed tracking node_states[N_MEMORY].
+ * Call this routine anytime after node_states[N_MEMORY] changes.
  * See cpuset_update_active_cpus() for CPU hotplug handling.
  */
 static int cpuset_track_online_nodes(struct notifier_block *self,
@@ -2148,7 +2148,7 @@ static int cpuset_track_online_nodes(str
 	case MEM_ONLINE:
 		oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
-		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+		top_cpuset.mems_allowed = node_states[N_MEMORY];
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
 		break;
@@ -2177,7 +2177,7 @@ static int cpuset_track_online_nodes(str
 void __init cpuset_init_smp(void)
 {
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	top_cpuset.mems_allowed = node_states[N_MEMORY];
 
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
 
@@ -2245,7 +2245,7 @@ void cpuset_init_current_mems_allowed(vo
  *
  * Description: Returns the nodemask_t mems_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
- * subset of node_states[N_HIGH_MEMORY], even if this means going outside the
+ * subset of node_states[N_MEMORY], even if this means going outside the
  * tasks cpuset.
  **/
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch

