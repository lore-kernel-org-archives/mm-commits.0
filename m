From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-replace-sysctls-with-quick-mode.patch removed from -mm tree
Date: Wed, 19 May 2010 11:47:56 -0700
Message-ID: <201005191847.o4JIlugu029442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410Ab0ESS6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: replace sysctls with quick mode
has been removed from the -mm tree.  Its filename was
     oom-replace-sysctls-with-quick-mode.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: replace sysctls with quick mode
From: David Rientjes <rientjes@google.com>

Two VM sysctls, oom dump_tasks and oom_kill_allocating_task, were
implemented for very large systems to avoid excessively long tasklist
scans.  The former suppresses helpful diagnostic messages that are emitted
for each thread group leader that are candidates for oom kill including
their pid, uid, vm size, rss, oom_adj value, and name; this information is
very helpful to users in understanding why a particular task was chosen
for kill over others.  The latter simply kills current, the task
triggering the oom condition, instead of iterating through the tasklist
looking for the worst offender.

Both of these sysctls are combined into one for use on the aforementioned
large systems: oom_kill_quick.  This disables the now-default
oom_dump_tasks and kills current whenever the oom killer is called.

This consolidation is possible because the audience for both tunables is
the same and there is no backwards compatibility issue in removing
oom_dump_tasks since its behavior is now default.  Since mempolicy ooms
now scan the tasklist, oom_kill_allocating_task may now find more users to
avoid the performance penalty, so it's better to unite them under one
sysctl than carry two for legacy purposes.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   44 ++++------------------------------
 kernel/sysctl.c             |   15 ++---------
 mm/oom_kill.c               |    9 +++---
 3 files changed, 13 insertions(+), 55 deletions(-)

diff -puN Documentation/sysctl/vm.txt~oom-replace-sysctls-with-quick-mode Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~oom-replace-sysctls-with-quick-mode
+++ a/Documentation/sysctl/vm.txt
@@ -43,9 +43,8 @@ Currently, these files are in /proc/sys/
 - nr_pdflush_threads
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
-- oom_dump_tasks
 - oom_forkbomb_thres
-- oom_kill_allocating_task
+- oom_kill_quick
 - overcommit_memory
 - overcommit_ratio
 - page-cluster
@@ -470,27 +469,6 @@ this is causing problems for your system
 
 ==============================================================
 
-oom_dump_tasks
-
-Enables a system-wide task dump (excluding kernel threads) to be
-produced when the kernel performs an OOM-killing and includes such
-information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
-name.  This is helpful to determine why the OOM killer was invoked
-and to identify the rogue task that caused it.
-
-If this is set to zero, this information is suppressed.  On very
-large systems with thousands of tasks it may not be feasible to dump
-the memory state information for each one.  Such systems should not
-be forced to incur a performance penalty in OOM conditions when the
-information may not be desired.
-
-If this is set to non-zero, this information is shown whenever the
-OOM killer actually kills a memory-hogging task.
-
-The default value is 0.
-
-==============================================================
-
 oom_forkbomb_thres
 
 This value defines how many children with a seperate address space a specific
@@ -511,22 +489,12 @@ The default value is 1000.
 
 ==============================================================
 
-oom_kill_allocating_task
-
-This enables or disables killing the OOM-triggering task in
-out-of-memory situations.
-
-If this is set to zero, the OOM killer will scan through the entire
-tasklist and select a task based on heuristics to kill.  This normally
-selects a rogue memory-hogging task that frees up a large amount of
-memory when killed.
-
-If this is set to non-zero, the OOM killer simply kills the task that
-triggered the out-of-memory condition.  This avoids the expensive
-tasklist scan.
+oom_kill_quick
 
-If panic_on_oom is selected, it takes precedence over whatever value
-is used in oom_kill_allocating_task.
+When enabled, this will always kill the task that triggered the oom killer, i.e.
+the task that attempted to allocate memory that could not be found.  It also
+suppresses the tasklist dump to the kernel log whenever the oom killer is
+called.  Typically set on systems with an extremely large number of tasks.
 
 The default value is 0.
 
diff -puN kernel/sysctl.c~oom-replace-sysctls-with-quick-mode kernel/sysctl.c
--- a/kernel/sysctl.c~oom-replace-sysctls-with-quick-mode
+++ a/kernel/sysctl.c
@@ -86,8 +86,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -982,16 +980,9 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "oom_kill_allocating_task",
-		.data		= &sysctl_oom_kill_allocating_task,
-		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "oom_dump_tasks",
-		.data		= &sysctl_oom_dump_tasks,
-		.maxlen		= sizeof(sysctl_oom_dump_tasks),
+		.procname	= "oom_kill_quick",
+		.data		= &sysctl_oom_kill_quick,
+		.maxlen		= sizeof(sysctl_oom_kill_quick),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
diff -puN mm/oom_kill.c~oom-replace-sysctls-with-quick-mode mm/oom_kill.c
--- a/mm/oom_kill.c~oom-replace-sysctls-with-quick-mode
+++ a/mm/oom_kill.c
@@ -33,9 +33,8 @@
 #include <linux/security.h>
 
 int sysctl_panic_on_oom;
-int sysctl_oom_kill_allocating_task;
-int sysctl_oom_dump_tasks;
 int sysctl_oom_forkbomb_thres = DEFAULT_OOM_FORKBOMB_THRES;
+int sysctl_oom_kill_quick;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
 int oom_kill_allocating_task_handler(struct ctl_table *table, int write,
@@ -424,7 +423,7 @@ static void dump_header(struct task_stru
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
-	if (sysctl_oom_dump_tasks)
+	if (!sysctl_oom_kill_quick)
 		dump_tasks(mem);
 }
 
@@ -673,9 +672,9 @@ static void __out_of_memory(gfp_t gfp_ma
 	struct task_struct *p;
 	unsigned int points;
 
-	if (sysctl_oom_kill_allocating_task)
+	if (sysctl_oom_kill_quick)
 		if (!oom_kill_process(current, gfp_mask, order, 0, totalpages,
-			NULL, "Out of memory (oom_kill_allocating_task)"))
+			NULL, "Out of memory (quick mode)"))
 			return;
 retry:
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch
oom-avoid-divide-by-zero.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-make-oom-killer-a-no-op-when-no-killable-task-can-be-found.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch

