From: akpm@linux-foundation.org
Subject: + oom-kill-add-lowmem-usage-aware-oom-kill-handling.patch added to -mm tree
Date: Tue, 26 Jan 2010 15:12:37 -0800
Message-ID: <201001262312.o0QNCbKK027605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889Ab0AZXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 18:12:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     oom-kill: add lowmem usage aware oom kill handling
has been added to the -mm tree.  Its filename is
     oom-kill-add-lowmem-usage-aware-oom-kill-handling.patch

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
Subject: oom-kill: add lowmem usage aware oom kill handling
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Default oom-killer uses badness calculation based on process's vm_size and
some amounts of heuristics.  Some users see proc->oom_score and
proc->oom_adj to control oom-killed tendency under their server.

Now, we know oom-killer don't work ideally in some situaion, in PCs.  Some
enhancements are demanded.  But such enhancements for oom-killer makes
incomaptibility to oom-controls in enterprise world.  So, this patch adds
sysctl for extensions for oom-killer.  Main purpose is for making a chance
for wider test for new scheme.

One cause of OOM-Killer is memory shortage in lower zones.  (If memory is
enough, lowmem_reserve_ratio works well.  but..) I saw lowmem-oom
frequently on x86-32 and sometimes on ia64 in my cusotmer support jobs. 
If we just see process's vm_size at oom, we can never kill a process which
has lowmem.  At last, there will be an oom-serial-killer.

Now, we have per-mm lowmem usage counter. We can make use of it
to select a good victim.

This patch does
  - add sysctl for new bahavior.
  - add CONSTRAINT_LOWMEM to oom's constraint type.
  - pass constraint to __badness()
  - change calculation based on constraint. If CONSTRAINT_LOWMEM,
    use low_rss instead of vmsize.

Changelog 2010/01/25
 - showing extension_mask value in OOM kill main log header.
Changelog 2010/01/22:
 - added sysctl
 - fixed !CONFIG_MMU
 - fixed fs/proc/base.c breakacge.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   16 +++++
 fs/proc/base.c              |    5 +
 include/linux/oom.h         |    1 
 kernel/sysctl.c             |   10 +++
 mm/oom_kill.c               |   92 +++++++++++++++++++++++++---------
 5 files changed, 97 insertions(+), 27 deletions(-)

diff -puN Documentation/sysctl/vm.txt~oom-kill-add-lowmem-usage-aware-oom-kill-handling Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~oom-kill-add-lowmem-usage-aware-oom-kill-handling
+++ a/Documentation/sysctl/vm.txt
@@ -45,6 +45,7 @@ Currently, these files are in /proc/sys/
 - numa_zonelist_order
 - oom_dump_tasks
 - oom_kill_allocating_task
+- oom_kill_extension_mask
 - overcommit_memory
 - overcommit_ratio
 - page-cluster
@@ -511,6 +512,21 @@ The default value is 0.
 
 ==============================================================
 
+oom_kill_extension_mask:
+
+This is a mask for oom-killer extension features.
+Setting these flags may cause incompatibility for proc->oom_score and
+proc->oom_adj controls. So, please set carefully.
+
+bit 0....lowmem aware oom-killing.
+    If set, at lowmem shortage oom killing (for example, exhausting NORMAL_ZONE
+    under x86-32 HIGHMEM host), oom-killer will see lowmem rss usage of
+    processes instead of vmsize. Works only when CONFIG_MMU=y.
+
+The default value is 0
+
+==============================================================
+
 overcommit_memory:
 
 This value contains a flag that enables memory overcommitment.
diff -puN fs/proc/base.c~oom-kill-add-lowmem-usage-aware-oom-kill-handling fs/proc/base.c
--- a/fs/proc/base.c~oom-kill-add-lowmem-usage-aware-oom-kill-handling
+++ a/fs/proc/base.c
@@ -439,7 +439,8 @@ static const struct file_operations proc
 #endif
 
 /* The badness from the OOM killer */
-unsigned long badness(struct task_struct *p, unsigned long uptime);
+unsigned long badness(struct task_struct *p,
+	unsigned long uptime, int constraint);
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
 	unsigned long points;
@@ -447,7 +448,7 @@ static int proc_oom_score(struct task_st
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
-	points = badness(task->group_leader, uptime.tv_sec);
+	points = badness(task->group_leader, uptime.tv_sec, CONSTRAINT_NONE);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff -puN include/linux/oom.h~oom-kill-add-lowmem-usage-aware-oom-kill-handling include/linux/oom.h
--- a/include/linux/oom.h~oom-kill-add-lowmem-usage-aware-oom-kill-handling
+++ a/include/linux/oom.h
@@ -20,6 +20,7 @@ struct notifier_block;
  */
 enum oom_constraint {
 	CONSTRAINT_NONE,
+	CONSTRAINT_LOWMEM,
 	CONSTRAINT_CPUSET,
 	CONSTRAINT_MEMORY_POLICY,
 };
diff -puN kernel/sysctl.c~oom-kill-add-lowmem-usage-aware-oom-kill-handling kernel/sysctl.c
--- a/kernel/sysctl.c~oom-kill-add-lowmem-usage-aware-oom-kill-handling
+++ a/kernel/sysctl.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
-#include <linux/sysctl.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
@@ -72,6 +71,7 @@ extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
+extern int sysctl_oom_kill_extension_mask;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -202,6 +202,7 @@ extern struct ctl_table epoll_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+
 extern int prove_locking;
 extern int lock_stat;
 
@@ -1282,6 +1283,13 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+	{
+		.procname	= "oom_kill_extension_mask",
+		.data		= &sysctl_oom_kill_extension_mask,
+		.maxlen		= sizeof(sysctl_oom_kill_extension_mask),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 
 /*
  * NOTE: do not add new entries to this table unless you have read
diff -puN mm/oom_kill.c~oom-kill-add-lowmem-usage-aware-oom-kill-handling mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-add-lowmem-usage-aware-oom-kill-handling
+++ a/mm/oom_kill.c
@@ -34,6 +34,23 @@ int sysctl_oom_dump_tasks;
 static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
+int sysctl_oom_kill_extension_mask;
+enum {
+	EXT_LOWMEM_OOM,
+};
+
+#ifdef CONFIG_MMU
+static int oom_extension(int idx)
+{
+	return sysctl_oom_kill_extension_mask & (1 << idx);
+}
+#else
+static int oom_extension(int idx)
+{
+	return 0;
+}
+#endif
+
 /*
  * Is all threads of the target process nodes overlap ours?
  */
@@ -55,6 +72,7 @@ static int has_intersects_mems_allowed(s
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
  * @uptime: current uptime in seconds
+ * @constraint: context of badness calculation.
  *
  * The formula used is relatively simple and documented inline in the
  * function. The main rationale is that we want to select a good task
@@ -70,7 +88,8 @@ static int has_intersects_mems_allowed(s
  *    of least surprise ... (be careful when you change it)
  */
 
-unsigned long badness(struct task_struct *p, unsigned long uptime)
+unsigned long badness(struct task_struct *p, unsigned long uptime,
+			int constraint)
 {
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
@@ -89,11 +108,16 @@ unsigned long badness(struct task_struct
 		task_unlock(p);
 		return 0;
 	}
-
-	/*
-	 * The memory size of the process is the basis for the badness.
-	 */
-	points = mm->total_vm;
+	switch  (constraint) {
+	case CONSTRAINT_LOWMEM:
+		/* use lowmem usage as the basis for the badness */
+		points = get_low_rss(mm);
+		break;
+	default:
+		/* use virtual memory size as the basis for the badness */
+		points = mm->total_vm;
+		break;
+	}
 
 	/*
 	 * After this unlock we can no longer dereference local variable `mm'
@@ -113,12 +137,17 @@ unsigned long badness(struct task_struct
 	 * machine with an endless amount of children. In case a single
 	 * child is eating the vast majority of memory, adding only half
 	 * to the parents will make the child our kill candidate of choice.
+	 *
+	 * At lowmem shortage, this part is skipped because children's lowmem
+	 * usage is not related to its parent.
 	 */
-	list_for_each_entry(child, &p->children, sibling) {
-		task_lock(child);
-		if (child->mm != mm && child->mm)
-			points += child->mm->total_vm/2 + 1;
-		task_unlock(child);
+	if (constraint != CONSTRAINT_LOWMEM) {
+		list_for_each_entry(child, &p->children, sibling) {
+			task_lock(child);
+			if (child->mm != mm && child->mm)
+				points += child->mm->total_vm/2 + 1;
+			task_unlock(child);
+		}
 	}
 
 	/*
@@ -212,6 +241,9 @@ static enum oom_constraint constrained_a
 	if (gfp_mask & __GFP_THISNODE)
 		return CONSTRAINT_NONE;
 
+	if (oom_extension(EXT_LOWMEM_OOM) && (high_zoneidx <= lowmem_zone))
+		return CONSTRAINT_LOWMEM;
+
 	/*
 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
@@ -233,6 +265,10 @@ static enum oom_constraint constrained_a
 static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 				gfp_t gfp_mask, nodemask_t *nodemask)
 {
+	int zone_idx = gfp_zone(gfp_mask);
+
+	if (oom_extension(EXT_LOWMEM_OOM) && (zone_idx <= lowmem_zone))
+		return CONSTRAINT_LOWMEM;
 	return CONSTRAINT_NONE;
 }
 #endif
@@ -244,7 +280,7 @@ static enum oom_constraint constrained_a
  * (not docbooked, we don't want this one cluttering up the manual)
  */
 static struct task_struct *select_bad_process(unsigned long *ppoints,
-						struct mem_cgroup *mem)
+				struct mem_cgroup *mem, int constraint)
 {
 	struct task_struct *p;
 	struct task_struct *chosen = NULL;
@@ -300,7 +336,7 @@ static struct task_struct *select_bad_pr
 		if (p->signal->oom_adj == OOM_DISABLE)
 			continue;
 
-		points = badness(p, uptime.tv_sec);
+		points = badness(p, uptime.tv_sec, constraint);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
@@ -360,8 +396,9 @@ static void dump_header(struct task_stru
 							struct mem_cgroup *mem)
 {
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
-		"oom_adj=%d\n",
-		current->comm, gfp_mask, order, current->signal->oom_adj);
+		"oom_adj=%d extesion=%x\n",
+		current->comm, gfp_mask, order,
+		current->signal->oom_adj, sysctl_oom_kill_extension_mask);
 	task_lock(current);
 	cpuset_print_task_mems_allowed(current);
 	task_unlock(current);
@@ -455,7 +492,7 @@ static int oom_kill_process(struct task_
 	}
 
 	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
-					message, task_pid_nr(p), p->comm, points);
+				message, task_pid_nr(p), p->comm, points);
 
 	/* Try to kill a child first */
 	list_for_each_entry(c, &p->children, sibling) {
@@ -475,7 +512,7 @@ void mem_cgroup_out_of_memory(struct mem
 
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, mem);
+	p = select_bad_process(&points, mem, CONSTRAINT_NONE);
 	if (PTR_ERR(p) == -1UL)
 		goto out;
 
@@ -557,7 +594,7 @@ void clear_zonelist_oom(struct zonelist 
 /*
  * Must be called with tasklist_lock held for read.
  */
-static void __out_of_memory(gfp_t gfp_mask, int order)
+static void __out_of_memory(gfp_t gfp_mask, int order, int constraint)
 {
 	struct task_struct *p;
 	unsigned long points;
@@ -571,7 +608,7 @@ retry:
 	 * Rambo mode: Shoot down a process and hope it solves whatever
 	 * issues we may have.
 	 */
-	p = select_bad_process(&points, NULL);
+	p = select_bad_process(&points, NULL, constraint);
 
 	if (PTR_ERR(p) == -1UL)
 		return;
@@ -583,9 +620,16 @@ retry:
 		panic("Out of memory and no killable processes...\n");
 	}
 
-	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+	switch (constraint) {
+	case CONSTRAINT_LOWMEM:
+		if (oom_kill_process(p, gfp_mask, order, points, NULL,
+			"Out of memory (in lowmem)"))
+			goto retry;
+	default:
+		if (oom_kill_process(p, gfp_mask, order, points, NULL,
 			     "Out of memory"))
-		goto retry;
+			goto retry;
+	}
 }
 
 /*
@@ -612,7 +656,7 @@ void pagefault_out_of_memory(void)
 		panic("out of memory from page fault. panic_on_oom is selected.\n");
 
 	read_lock(&tasklist_lock);
-	__out_of_memory(0, 0); /* unknown gfp_mask and order */
+	__out_of_memory(0, 0, CONSTRAINT_NONE); /* unknown gfp_mask and order */
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -663,7 +707,7 @@ void out_of_memory(struct zonelist *zone
 		oom_kill_process(current, gfp_mask, order, 0, NULL,
 				"No available memory (MPOL_BIND)");
 		break;
-
+	case CONSTRAINT_LOWMEM:
 	case CONSTRAINT_NONE:
 		if (sysctl_panic_on_oom) {
 			dump_header(NULL, gfp_mask, order, NULL);
@@ -671,7 +715,7 @@ void out_of_memory(struct zonelist *zone
 		}
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
-		__out_of_memory(gfp_mask, order);
+		__out_of_memory(gfp_mask, order, constraint);
 		break;
 	}
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
oom-kill-add-lowmem-usage-aware-oom-kill-handling.patch
nodemaskh-remove-macro-any_online_node.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch

