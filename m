From: akpm@linux-foundation.org
Subject: [merged] memcg-flatten-task_struct-memcg_oom.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:07:20 -0800
Message-ID: <563d0878.iQZLBFu4KEZbzfWk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbbKFUHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: flatten task_struct->memcg_oom
has been removed from the -mm tree.  Its filename was
     memcg-flatten-task_struct-memcg_oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: flatten task_struct->memcg_oom

task_struct->memcg_oom is a sub-struct containing fields which are used
for async memcg oom handling.  Most task_struct fields aren't packaged
this way and it can lead to unnecessary alignment paddings.  This patch
flattens it.

* task.memcg_oom.memcg          -> task.memcg_in_oom
* task.memcg_oom.gfp_mask	-> task.memcg_oom_gfp_mask
* task.memcg_oom.order          -> task.memcg_oom_order
* task.memcg_oom.may_oom        -> task.memcg_may_oom

In addition, task.memcg_may_oom is relocated to where other bitfields are
which reduces the size of task_struct.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++++-----
 include/linux/sched.h      |   13 ++++++-------
 mm/memcontrol.c            |   16 ++++++++--------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-flatten-task_struct-memcg_oom include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-flatten-task_struct-memcg_oom
+++ a/include/linux/memcontrol.h
@@ -406,19 +406,19 @@ void mem_cgroup_print_oom_info(struct me
 
 static inline void mem_cgroup_oom_enable(void)
 {
-	WARN_ON(current->memcg_oom.may_oom);
-	current->memcg_oom.may_oom = 1;
+	WARN_ON(current->memcg_may_oom);
+	current->memcg_may_oom = 1;
 }
 
 static inline void mem_cgroup_oom_disable(void)
 {
-	WARN_ON(!current->memcg_oom.may_oom);
-	current->memcg_oom.may_oom = 0;
+	WARN_ON(!current->memcg_may_oom);
+	current->memcg_may_oom = 0;
 }
 
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
-	return p->memcg_oom.memcg;
+	return p->memcg_in_oom;
 }
 
 bool mem_cgroup_oom_synchronize(bool wait);
diff -puN include/linux/sched.h~memcg-flatten-task_struct-memcg_oom include/linux/sched.h
--- a/include/linux/sched.h~memcg-flatten-task_struct-memcg_oom
+++ a/include/linux/sched.h
@@ -1473,7 +1473,9 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 	unsigned sched_migrated:1;
-
+#ifdef CONFIG_MEMCG
+	unsigned memcg_may_oom:1;
+#endif
 #ifdef CONFIG_MEMCG_KMEM
 	unsigned memcg_kmem_skip_account:1;
 #endif
@@ -1804,12 +1806,9 @@ struct task_struct {
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_MEMCG
-	struct memcg_oom_info {
-		struct mem_cgroup *memcg;
-		gfp_t gfp_mask;
-		int order;
-		unsigned int may_oom:1;
-	} memcg_oom;
+	struct mem_cgroup *memcg_in_oom;
+	gfp_t memcg_oom_gfp_mask;
+	int memcg_oom_order;
 #endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
diff -puN mm/memcontrol.c~memcg-flatten-task_struct-memcg_oom mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-flatten-task_struct-memcg_oom
+++ a/mm/memcontrol.c
@@ -1661,7 +1661,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_oom.may_oom)
+	if (!current->memcg_may_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
@@ -1678,9 +1678,9 @@ static void mem_cgroup_oom(struct mem_cg
 	 * and when we know whether the fault was overall successful.
 	 */
 	css_get(&memcg->css);
-	current->memcg_oom.memcg = memcg;
-	current->memcg_oom.gfp_mask = mask;
-	current->memcg_oom.order = order;
+	current->memcg_in_oom = memcg;
+	current->memcg_oom_gfp_mask = mask;
+	current->memcg_oom_order = order;
 }
 
 /**
@@ -1702,7 +1702,7 @@ static void mem_cgroup_oom(struct mem_cg
  */
 bool mem_cgroup_oom_synchronize(bool handle)
 {
-	struct mem_cgroup *memcg = current->memcg_oom.memcg;
+	struct mem_cgroup *memcg = current->memcg_in_oom;
 	struct oom_wait_info owait;
 	bool locked;
 
@@ -1730,8 +1730,8 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked && !memcg->oom_kill_disable) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, current->memcg_oom.gfp_mask,
-					 current->memcg_oom.order);
+		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
+					 current->memcg_oom_order);
 	} else {
 		schedule();
 		mem_cgroup_unmark_under_oom(memcg);
@@ -1748,7 +1748,7 @@ bool mem_cgroup_oom_synchronize(bool han
 		memcg_oom_recover(memcg);
 	}
 cleanup:
-	current->memcg_oom.memcg = NULL;
+	current->memcg_in_oom = NULL;
 	css_put(&memcg->css);
 	return true;
 }
_

Patches currently in -mm which might be from tj@kernel.org are


