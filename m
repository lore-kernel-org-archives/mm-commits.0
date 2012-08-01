From: akpm@linux-foundation.org
Subject: [merged] mm-oom-reduce-dependency-on-tasklist_lock.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:15 -0700
Message-ID: <20120801201516.396295C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65135 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:18 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so342543wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: reduce dependency on tasklist_lock
has been removed from the -mm tree.  Its filename was
     mm-oom-reduce-dependency-on-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: reduce dependency on tasklist_lock

Since exiting tasks require write_lock_irq(&tasklist_lock) several times,
try to reduce the amount of time the readside is held for oom kills.  This
makes the interface with the memcg oom handler more consistent since it
now never needs to take tasklist_lock unnecessarily.

The only time the oom killer now takes tasklist_lock is when iterating the
children of the selected task, everything else is protected by
rcu_read_lock().

This requires that a reference to the selected process, p, is grabbed
before calling oom_kill_process().  It may release it and grab a reference
on another one of p's threads if !p->mm, but it also guarantees that it
will release the reference before returning.

[hughd@google.com: fix duplicate put_task_struct()]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 mm/oom_kill.c   |   41 ++++++++++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~mm-oom-reduce-dependency-on-tasklist_lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-reduce-dependency-on-tasklist_lock
+++ a/mm/memcontrol.c
@@ -1521,11 +1521,8 @@ void __mem_cgroup_out_of_memory(struct m
 	if (!chosen)
 		return;
 	points = chosen_points * 1000 / totalpages;
-	read_lock(&tasklist_lock);
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
-	read_unlock(&tasklist_lock);
-	put_task_struct(chosen);
 }
 
 static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
diff -puN mm/oom_kill.c~mm-oom-reduce-dependency-on-tasklist_lock mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-reduce-dependency-on-tasklist_lock
+++ a/mm/oom_kill.c
@@ -336,7 +336,7 @@ enum oom_scan_t oom_scan_process_thread(
 
 /*
  * Simple selection loop. We chose the process with the highest
- * number of 'points'. We expect the caller will lock the tasklist.
+ * number of 'points'.
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
@@ -348,6 +348,7 @@ static struct task_struct *select_bad_pr
 	struct task_struct *chosen = NULL;
 	unsigned long chosen_points = 0;
 
+	rcu_read_lock();
 	do_each_thread(g, p) {
 		unsigned int points;
 
@@ -360,6 +361,7 @@ static struct task_struct *select_bad_pr
 		case OOM_SCAN_CONTINUE:
 			continue;
 		case OOM_SCAN_ABORT:
+			rcu_read_unlock();
 			return ERR_PTR(-1UL);
 		case OOM_SCAN_OK:
 			break;
@@ -370,6 +372,9 @@ static struct task_struct *select_bad_pr
 			chosen_points = points;
 		}
 	} while_each_thread(g, p);
+	if (chosen)
+		get_task_struct(chosen);
+	rcu_read_unlock();
 
 	*ppoints = chosen_points * 1000 / totalpages;
 	return chosen;
@@ -385,8 +390,6 @@ static struct task_struct *select_bad_pr
  * are not shown.
  * State information includes task's pid, uid, tgid, vm size, rss, nr_ptes,
  * swapents, oom_score_adj value, and name.
- *
- * Call with tasklist_lock read-locked.
  */
 static void dump_tasks(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
@@ -394,6 +397,7 @@ static void dump_tasks(const struct mem_
 	struct task_struct *task;
 
 	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name\n");
+	rcu_read_lock();
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
 			continue;
@@ -416,6 +420,7 @@ static void dump_tasks(const struct mem_
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
 	}
+	rcu_read_unlock();
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
@@ -436,6 +441,10 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
+/*
+ * Must be called while holding a reference to p, which will be released upon
+ * returning.
+ */
 void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		      unsigned int points, unsigned long totalpages,
 		      struct mem_cgroup *memcg, nodemask_t *nodemask,
@@ -455,6 +464,7 @@ void oom_kill_process(struct task_struct
 	 */
 	if (p->flags & PF_EXITING) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
+		put_task_struct(p);
 		return;
 	}
 
@@ -472,6 +482,7 @@ void oom_kill_process(struct task_struct
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
+	read_lock(&tasklist_lock);
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
@@ -484,15 +495,26 @@ void oom_kill_process(struct task_struct
 			child_points = oom_badness(child, memcg, nodemask,
 								totalpages);
 			if (child_points > victim_points) {
+				put_task_struct(victim);
 				victim = child;
 				victim_points = child_points;
+				get_task_struct(victim);
 			}
 		}
 	} while_each_thread(p, t);
+	read_unlock(&tasklist_lock);
 
-	victim = find_lock_task_mm(victim);
-	if (!victim)
+	rcu_read_lock();
+	p = find_lock_task_mm(victim);
+	if (!p) {
+		rcu_read_unlock();
+		put_task_struct(victim);
 		return;
+	} else if (victim != p) {
+		get_task_struct(p);
+		put_task_struct(victim);
+		victim = p;
+	}
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
@@ -523,9 +545,11 @@ void oom_kill_process(struct task_struct
 			task_unlock(p);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
+	rcu_read_unlock();
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
+	put_task_struct(victim);
 }
 #undef K
 
@@ -546,9 +570,7 @@ static void check_panic_on_oom(enum oom_
 		if (constraint != CONSTRAINT_NONE)
 			return;
 	}
-	read_lock(&tasklist_lock);
 	dump_header(NULL, gfp_mask, order, NULL, nodemask);
-	read_unlock(&tasklist_lock);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
@@ -721,10 +743,10 @@ void out_of_memory(struct zonelist *zone
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
-	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
+		get_task_struct(current);
 		oom_kill_process(current, gfp_mask, order, 0, totalpages, NULL,
 				 nodemask,
 				 "Out of memory (oom_kill_allocating_task)");
@@ -735,7 +757,6 @@ void out_of_memory(struct zonelist *zone
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
-		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 	if (PTR_ERR(p) != -1UL) {
@@ -744,8 +765,6 @@ void out_of_memory(struct zonelist *zone
 		killed = 1;
 	}
 out:
-	read_unlock(&tasklist_lock);
