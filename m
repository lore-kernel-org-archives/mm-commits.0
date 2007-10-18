From: akpm@linux-foundation.org
Subject: - oom-add-oom_kill_allocating_task-sysctl.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:48 -0700
Message-ID: <200710180651.l9I6pmZj030217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761341AbXJRHpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: add oom_kill_allocating_task sysctl
has been removed from the -mm tree.  Its filename was
     oom-add-oom_kill_allocating_task-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: add oom_kill_allocating_task sysctl
From: David Rientjes <rientjes@google.com>

Adds a new sysctl, 'oom_kill_allocating_task', which will automatically kill
the OOM-triggering task instead of scanning through the tasklist to find a
memory-hogging target.  This is helpful for systems with an insanely large
number of tasks where scanning the tasklist significantly degrades
performance.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   22 ++++++++++++++++++++++
 kernel/sysctl.c             |    9 +++++++++
 mm/oom_kill.c               |   13 ++++++++-----
 3 files changed, 39 insertions(+), 5 deletions(-)

diff -puN Documentation/sysctl/vm.txt~oom-add-oom_kill_allocating_task-sysctl Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~oom-add-oom_kill_allocating_task-sysctl
+++ a/Documentation/sysctl/vm.txt
@@ -31,6 +31,7 @@ Currently, these files are in /proc/sys/
 - min_unmapped_ratio
 - min_slab_ratio
 - panic_on_oom
+- oom_kill_allocating_task
 - mmap_min_address
 - numa_zonelist_order
 
@@ -220,6 +221,27 @@ The default value is 0.
 1 and 2 are for failover of clustering. Please select either
 according to your policy of failover.
 
+=============================================================
+
+oom_kill_allocating_task
+
+This enables or disables killing the OOM-triggering task in
+out-of-memory situations.
+
+If this is set to zero, the OOM killer will scan through the entire
+tasklist and select a task based on heuristics to kill.  This normally
+selects a rogue memory-hogging task that frees up a large amount of
+memory when killed.
+
+If this is set to non-zero, the OOM killer simply kills the task that
+triggered the out-of-memory condition.  This avoids the expensive
+tasklist scan.
+
+If panic_on_oom is selected, it takes precedence over whatever value
+is used in oom_kill_allocating_task.
+
+The default value is 0.
+
 ==============================================================
 
 mmap_min_addr
diff -puN kernel/sysctl.c~oom-add-oom_kill_allocating_task-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~oom-add-oom_kill_allocating_task-sysctl
+++ a/kernel/sysctl.c
@@ -63,6 +63,7 @@ extern int print_fatal_signals;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
+extern int sysctl_oom_kill_allocating_task;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -781,6 +782,14 @@ static ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_kill_allocating_task",
+		.data		= &sysctl_oom_kill_allocating_task,
+		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= VM_OVERCOMMIT_RATIO,
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
diff -puN mm/oom_kill.c~oom-add-oom_kill_allocating_task-sysctl mm/oom_kill.c
--- a/mm/oom_kill.c~oom-add-oom_kill_allocating_task-sysctl
+++ a/mm/oom_kill.c
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 
 int sysctl_panic_on_oom;
+int sysctl_oom_kill_allocating_task;
 static DEFINE_MUTEX(zone_scan_mutex);
 /* #define DEBUG */
 
@@ -471,14 +472,16 @@ void out_of_memory(struct zonelist *zone
 				"No available memory (MPOL_BIND)");
 		break;
 
-	case CONSTRAINT_CPUSET:
-		oom_kill_process(current, points,
-				"No available memory in cpuset");
-		break;
-
 	case CONSTRAINT_NONE:
 		if (sysctl_panic_on_oom)
 			panic("out of memory. panic_on_oom is selected\n");
+		/* Fall-through */
+	case CONSTRAINT_CPUSET:
+		if (sysctl_oom_kill_allocating_task) {
+			oom_kill_process(current, points,
+					"Out of memory (oom_kill_allocating_task)");
+			break;
+		}
 retry:
 		/*
 		 * Rambo mode: Shoot down a process and hope it solves whatever
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
