From: akpm@linux-foundation.org
Subject: + mm-oom-add-memcg-to-oom_control.patch added to -mm tree
Date: Fri, 27 May 2016 13:42:17 -0700
Message-ID: <5748b129.VKY7pGiujD5E7Dbf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbcE0UmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:42:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom: add memcg to oom_control
has been added to the -mm tree.  Its filename is
     mm-oom-add-memcg-to-oom_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-add-memcg-to-oom_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-add-memcg-to-oom_control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: oom: add memcg to oom_control

It's a part of oom context just like allocation order and nodemask, so
let's move it to oom_control instead of passing it in the argument list.

Link: http://lkml.kernel.org/r/40e03fd7aaf1f55c75d787128d6d17c5a71226c2.1464358556.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    1 +
 include/linux/oom.h |    8 +++++---
 mm/memcontrol.c     |    5 +++--
 mm/oom_kill.c       |   32 +++++++++++++++-----------------
 mm/page_alloc.c     |    1 +
 5 files changed, 25 insertions(+), 22 deletions(-)

diff -puN drivers/tty/sysrq.c~mm-oom-add-memcg-to-oom_control drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~mm-oom-add-memcg-to-oom_control
+++ a/drivers/tty/sysrq.c
@@ -363,6 +363,7 @@ static void moom_callback(struct work_st
 	struct oom_control oc = {
 		.zonelist = node_zonelist(first_memory_node, gfp_mask),
 		.nodemask = NULL,
+		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = -1,
 	};
diff -puN include/linux/oom.h~mm-oom-add-memcg-to-oom_control include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-add-memcg-to-oom_control
+++ a/include/linux/oom.h
@@ -23,6 +23,9 @@ struct oom_control {
 	/* Used to determine mempolicy */
 	nodemask_t *nodemask;
 
+	/* Memory cgroup in which oom is invoked, or NULL for global oom */
+	struct mem_cgroup *memcg;
+
 	/* Used to determine cpuset and node locality requirement */
 	const gfp_t gfp_mask;
 
@@ -83,11 +86,10 @@ extern unsigned long oom_badness(struct
 
 extern void oom_kill_process(struct oom_control *oc, struct task_struct *p,
 			     unsigned int points, unsigned long totalpages,
-			     struct mem_cgroup *memcg, const char *message);
+			     const char *message);
 
 extern void check_panic_on_oom(struct oom_control *oc,
-			       enum oom_constraint constraint,
-			       struct mem_cgroup *memcg);
+			       enum oom_constraint constraint);
 
 extern enum oom_scan_t oom_scan_process_thread(struct oom_control *oc,
 		struct task_struct *task, unsigned long totalpages);
diff -puN mm/memcontrol.c~mm-oom-add-memcg-to-oom_control mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-add-memcg-to-oom_control
+++ a/mm/memcontrol.c
@@ -1259,6 +1259,7 @@ static bool mem_cgroup_out_of_memory(str
 	struct oom_control oc = {
 		.zonelist = NULL,
 		.nodemask = NULL,
+		.memcg = memcg,
 		.gfp_mask = gfp_mask,
 		.order = order,
 	};
@@ -1281,7 +1282,7 @@ static bool mem_cgroup_out_of_memory(str
 		goto unlock;
 	}
 
-	check_panic_on_oom(&oc, CONSTRAINT_MEMCG, memcg);
+	check_panic_on_oom(&oc, CONSTRAINT_MEMCG);
 	totalpages = mem_cgroup_get_limit(memcg) ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
@@ -1329,7 +1330,7 @@ static bool mem_cgroup_out_of_memory(str
 
 	if (chosen) {
 		points = chosen_points * 1000 / totalpages;
-		oom_kill_process(&oc, chosen, points, totalpages, memcg,
+		oom_kill_process(&oc, chosen, points, totalpages,
 				 "Memory cgroup out of memory");
 	}
 unlock:
diff -puN mm/oom_kill.c~mm-oom-add-memcg-to-oom_control mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-add-memcg-to-oom_control
+++ a/mm/oom_kill.c
@@ -383,8 +383,7 @@ static void dump_tasks(struct mem_cgroup
 	rcu_read_unlock();
 }
 
-static void dump_header(struct oom_control *oc, struct task_struct *p,
-			struct mem_cgroup *memcg)
+static void dump_header(struct oom_control *oc, struct task_struct *p)
 {
 	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
@@ -392,12 +391,12 @@ static void dump_header(struct oom_contr
 
 	cpuset_print_current_mems_allowed();
 	dump_stack();
-	if (memcg)
-		mem_cgroup_print_oom_info(memcg, p);
+	if (oc->memcg)
+		mem_cgroup_print_oom_info(oc->memcg, p);
 	else
 		show_mem(SHOW_MEM_FILTER_NODES);
 	if (sysctl_oom_dump_tasks)
-		dump_tasks(memcg, oc->nodemask);
+		dump_tasks(oc->memcg, oc->nodemask);
 }
 
 /*
@@ -749,7 +748,7 @@ void oom_killer_enable(void)
  */
 void oom_kill_process(struct oom_control *oc, struct task_struct *p,
 		      unsigned int points, unsigned long totalpages,
-		      struct mem_cgroup *memcg, const char *message)
+		      const char *message)
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
@@ -775,7 +774,7 @@ void oom_kill_process(struct oom_control
 	task_unlock(p);
 
 	if (__ratelimit(&oom_rs))
-		dump_header(oc, p, memcg);
+		dump_header(oc, p);
 
 	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
@@ -796,8 +795,8 @@ void oom_kill_process(struct oom_control
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
 			 */
-			child_points = oom_badness(child, memcg, oc->nodemask,
-								totalpages);
+			child_points = oom_badness(child,
+					oc->memcg, oc->nodemask, totalpages);
 			if (child_points > victim_points) {
 				put_task_struct(victim);
 				victim = child;
@@ -875,8 +874,7 @@ void oom_kill_process(struct oom_control
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-void check_panic_on_oom(struct oom_control *oc, enum oom_constraint constraint,
-			struct mem_cgroup *memcg)
+void check_panic_on_oom(struct oom_control *oc, enum oom_constraint constraint)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -892,7 +890,7 @@ void check_panic_on_oom(struct oom_contr
 	/* Do not panic for oom kills triggered by sysrq */
 	if (is_sysrq_oom(oc))
 		return;
-	dump_header(oc, NULL, memcg);
+	dump_header(oc, NULL);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
@@ -967,13 +965,13 @@ bool out_of_memory(struct oom_control *o
 	constraint = constrained_alloc(oc, &totalpages);
 	if (constraint != CONSTRAINT_MEMORY_POLICY)
 		oc->nodemask = NULL;
-	check_panic_on_oom(oc, constraint, NULL);
+	check_panic_on_oom(oc, constraint);
 
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, oc->nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
 		get_task_struct(current);
-		oom_kill_process(oc, current, 0, totalpages, NULL,
+		oom_kill_process(oc, current, 0, totalpages,
 				 "Out of memory (oom_kill_allocating_task)");
 		return true;
 	}
@@ -981,12 +979,11 @@ bool out_of_memory(struct oom_control *o
 	p = select_bad_process(oc, &points, totalpages);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p && !is_sysrq_oom(oc)) {
-		dump_header(oc, NULL, NULL);
+		dump_header(oc, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
 	if (p && p != (void *)-1UL) {
-		oom_kill_process(oc, p, points, totalpages, NULL,
-				 "Out of memory");
+		oom_kill_process(oc, p, points, totalpages, "Out of memory");
 		/*
 		 * Give the killed process a good chance to exit before trying
 		 * to allocate memory again.
@@ -1006,6 +1003,7 @@ void pagefault_out_of_memory(void)
 	struct oom_control oc = {
 		.zonelist = NULL,
 		.nodemask = NULL,
+		.memcg = NULL,
 		.gfp_mask = 0,
 		.order = 0,
 	};
diff -puN mm/page_alloc.c~mm-oom-add-memcg-to-oom_control mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-add-memcg-to-oom_control
+++ a/mm/page_alloc.c
@@ -3101,6 +3101,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	struct oom_control oc = {
 		.zonelist = ac->zonelist,
 		.nodemask = ac->nodemask,
+		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
 	};
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup.patch
mm-zap-zone_oom_locked.patch
mm-oom-add-memcg-to-oom_control.patch

