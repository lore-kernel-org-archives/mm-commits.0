From: akpm@linux-foundation.org
Subject: + mm-oom-reduce-dependency-on-tasklist_lock.patch added to -mm tree
Date: Tue, 10 Jul 2012 14:18:04 -0700
Message-ID: <20120710211805.451E0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46343 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2GJVSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 17:18:06 -0400
Received: by qcqs25 with SMTP id s25so53629qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 14:18:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com


The patch titled
     Subject: mm, oom: reduce dependency on tasklist_lock
has been added to the -mm tree.  Its filename is
     mm-oom-reduce-dependency-on-tasklist_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 mm/oom_kill.c   |   40 +++++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~mm-oom-reduce-dependency-on-tasklist_lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-reduce-dependency-on-tasklist_lock
+++ a/mm/memcontrol.c
@@ -1521,10 +1521,8 @@ void __mem_cgroup_out_of_memory(struct m
 	if (!chosen)
 		return;
 	points = chosen_points * 1000 / totalpages;
-	read_lock(&tasklist_lock);
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
-	read_unlock(&tasklist_lock);
 	put_task_struct(chosen);
 }
 
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
 
@@ -370,6 +371,9 @@ static struct task_struct *select_bad_pr
 			chosen_points = points;
 		}
 	} while_each_thread(g, p);
+	if (chosen)
+		get_task_struct(chosen);
+	rcu_read_unlock();
 
 	*ppoints = chosen_points * 1000 / totalpages;
 	return chosen;
@@ -385,8 +389,6 @@ static struct task_struct *select_bad_pr
  * are not shown.
  * State information includes task's pid, uid, tgid, vm size, rss, nr_ptes,
  * swapents, oom_score_adj value, and name.
- *
- * Call with tasklist_lock read-locked.
  */
 static void dump_tasks(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
@@ -394,6 +396,7 @@ static void dump_tasks(const struct mem_
 	struct task_struct *task;
 
 	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name\n");
+	rcu_read_lock();
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
 			continue;
@@ -416,6 +419,7 @@ static void dump_tasks(const struct mem_
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
 	}
+	rcu_read_unlock();
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
@@ -436,6 +440,10 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
+/*
+ * Must be called while holding a reference to p, which will be released upon
+ * returning.
+ */
 void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		      unsigned int points, unsigned long totalpages,
 		      struct mem_cgroup *memcg, nodemask_t *nodemask,
@@ -455,6 +463,7 @@ void oom_kill_process(struct task_struct
 	 */
 	if (p->flags & PF_EXITING) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
+		put_task_struct(p);
 		return;
 	}
 
@@ -472,6 +481,7 @@ void oom_kill_process(struct task_struct
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
+	read_lock(&tasklist_lock);
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
@@ -484,15 +494,26 @@ void oom_kill_process(struct task_struct
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
@@ -523,9 +544,11 @@ void oom_kill_process(struct task_struct
 			task_unlock(p);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
+	rcu_read_unlock();
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
+	put_task_struct(victim);
 }
 #undef K
 
@@ -546,9 +569,7 @@ static void check_panic_on_oom(enum oom_
 		if (constraint != CONSTRAINT_NONE)
 			return;
 	}
-	read_lock(&tasklist_lock);
 	dump_header(NULL, gfp_mask, order, NULL, nodemask);
-	read_unlock(&tasklist_lock);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
@@ -721,10 +742,10 @@ void out_of_memory(struct zonelist *zone
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
@@ -735,7 +756,6 @@ void out_of_memory(struct zonelist *zone
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
-		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 	if (PTR_ERR(p) != -1UL) {
@@ -744,8 +764,6 @@ void out_of_memory(struct zonelist *zone
 		killed = 1;
 	}
 out:
-	read_unlock(&tasklist_lock);
-
 	/*
 	 * Give the killed threads a good chance of exiting before trying to
 	 * allocate memory again.
_
Subject: Subject: mm, oom: reduce dependency on tasklist_lock

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch
slab-do-not-call-compound_head-in-page_get_cache.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch
mm-oom-replace-some-information-in-tasklist-dump.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh.patch
mm-oom-introduce-helper-function-to-process-threads-during-scan.patch
mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch
mm-oom-reduce-dependency-on-tasklist_lock.patch
mm-memcg-move-all-oom-handling-to-memcontrolc.patch

