From: akpm@linux-foundation.org
Subject: + oom-add-oom_kill_allocating_task-sysctl.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:11:07 -0700
Message-ID: <200709210911.l8L9B7kQ028210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbXIUJLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: add oom_kill_allocating_task sysctl
has been added to the -mm tree.  Its filename is
     oom-add-oom_kill_allocating_task-sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -776,6 +777,14 @@ static ctl_table vm_table[] = {
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

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
