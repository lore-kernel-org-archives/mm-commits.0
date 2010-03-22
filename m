From: akpm@linux-foundation.org
Subject: + oom-replace-sysctls-with-quick-mode.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:21:58 -0700
Message-ID: <201003222021.o2MKLwHM025228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755774Ab0CVUWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: replace sysctls with quick mode
has been added to the -mm tree.  Its filename is
     oom-replace-sysctls-with-quick-mode.patch

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
 kernel/sysctl.c             |   16 +++---------
 mm/oom_kill.c               |    9 +++---
 3 files changed, 14 insertions(+), 55 deletions(-)

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
@@ -82,8 +82,7 @@
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
+extern int sysctl_oom_kill_quick;
 extern int sysctl_oom_forkbomb_thres;
 extern int max_threads;
 extern int core_uses_pid;
@@ -952,16 +951,9 @@ static struct ctl_table vm_table[] = {
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
@@ -32,9 +32,8 @@
 #include <linux/security.h>
 
 int sysctl_panic_on_oom;
-int sysctl_oom_kill_allocating_task;
-int sysctl_oom_dump_tasks;
 int sysctl_oom_forkbomb_thres = DEFAULT_OOM_FORKBOMB_THRES;
+int sysctl_oom_kill_quick;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
 /*
@@ -409,7 +408,7 @@ static void dump_header(struct task_stru
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
-	if (sysctl_oom_dump_tasks)
+	if (!sysctl_oom_kill_quick)
 		dump_tasks(mem);
 }
 
@@ -658,9 +657,9 @@ static void __out_of_memory(gfp_t gfp_ma
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

linux-next.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

