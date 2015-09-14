From: akpm@linux-foundation.org
Subject: + memcg-flatten-task_struct-memcg_oom.patch added to -mm tree
Date: Mon, 14 Sep 2015 14:06:27 -0700
Message-ID: <55f736d3.KixoHAWvFi+5Gd/c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbINVG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: flatten task_struct->memcg_oom
has been added to the -mm tree.  Its filename is
     memcg-flatten-task_struct-memcg_oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-flatten-task_struct-memcg_oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-flatten-task_struct-memcg_oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++++-----
 include/linux/sched.h      |   13 ++++++-------
 mm/memcontrol.c            |   16 ++++++++--------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-flatten-task_struct-memcg_oom include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-flatten-task_struct-memcg_oom
+++ a/include/linux/memcontrol.h
@@ -407,19 +407,19 @@ void mem_cgroup_print_oom_info(struct me
 
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
@@ -1451,7 +1451,9 @@ struct task_struct {
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
@@ -1782,12 +1784,9 @@ struct task_struct {
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
@@ -1652,7 +1652,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_oom.may_oom)
+	if (!current->memcg_may_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
@@ -1669,9 +1669,9 @@ static void mem_cgroup_oom(struct mem_cg
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
@@ -1693,7 +1693,7 @@ static void mem_cgroup_oom(struct mem_cg
  */
 bool mem_cgroup_oom_synchronize(bool handle)
 {
-	struct mem_cgroup *memcg = current->memcg_oom.memcg;
+	struct mem_cgroup *memcg = current->memcg_in_oom;
 	struct oom_wait_info owait;
 	bool locked;
 
@@ -1721,8 +1721,8 @@ bool mem_cgroup_oom_synchronize(bool han
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
@@ -1739,7 +1739,7 @@ bool mem_cgroup_oom_synchronize(bool han
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

memcg-flatten-task_struct-memcg_oom.patch
memcg-punt-high-overage-reclaim-to-return-to-userland-path.patch

