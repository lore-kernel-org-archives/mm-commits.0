From: akpm@linux-foundation.org
Subject: [merged] cpuset-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:01 -0800
Message-ID: <20121214232802.50E3F200093@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37407 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2LNX2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:05 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so208128wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     cpuset-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2026,7 +2026,7 @@ static struct cpuset *cpuset_next(struct
  * before dropping down to the next.  It always processes a node before
  * any of its children.
  *
- * In the case of memory hot-unplug, it will remove nodes from N_HIGH_MEMORY
+ * In the case of memory hot-unplug, it will remove nodes from N_MEMORY
  * if all present pages from a node are offlined.
  */
 static void
@@ -2065,7 +2065,7 @@ scan_cpusets_upon_hotplug(struct cpuset 
 
 			/* Continue past cpusets with all mems online */
 			if (nodes_subset(cp->mems_allowed,
-					node_states[N_HIGH_MEMORY]))
+					node_states[N_MEMORY]))
 				continue;
 
 			oldmems = cp->mems_allowed;
@@ -2073,7 +2073,7 @@ scan_cpusets_upon_hotplug(struct cpuset 
 			/* Remove offline mems from this cpuset. */
 			mutex_lock(&callback_mutex);
 			nodes_and(cp->mems_allowed, cp->mems_allowed,
-						node_states[N_HIGH_MEMORY]);
+						node_states[N_MEMORY]);
 			mutex_unlock(&callback_mutex);
 
 			/* Move tasks from the empty cpuset to a parent */
@@ -2126,8 +2126,8 @@ void cpuset_update_active_cpus(bool cpu_
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
- * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
- * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
+ * Keep top_cpuset.mems_allowed tracking node_states[N_MEMORY].
+ * Call this routine anytime after node_states[N_MEMORY] changes.
  * See cpuset_update_active_cpus() for CPU hotplug handling.
  */
 static int cpuset_track_online_nodes(struct notifier_block *self,
@@ -2140,7 +2140,7 @@ static int cpuset_track_online_nodes(str
 	case MEM_ONLINE:
 		oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
-		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+		top_cpuset.mems_allowed = node_states[N_MEMORY];
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
 		break;
@@ -2169,7 +2169,7 @@ static int cpuset_track_online_nodes(str
 void __init cpuset_init_smp(void)
 {
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	top_cpuset.mems_allowed = node_states[N_MEMORY];
 
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
 
@@ -2237,7 +2237,7 @@ void cpuset_init_current_mems_allowed(vo
  *
  * Description: Returns the nodemask_t mems_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
- * subset of node_states[N_HIGH_MEMORY], even if this means going outside the
+ * subset of node_states[N_MEMORY], even if this means going outside the
  * tasks cpuset.
  **/
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

