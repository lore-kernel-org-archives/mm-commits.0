From: akpm@linux-foundation.org
Subject: + oom-add-sysctl-to-enable-task-memory-dump.patch added to -mm tree
Date: Thu, 27 Sep 2007 17:09:02 -0700
Message-ID: <200709280009.l8S093rF002163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759561AbXI1AJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 20:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, balbir@linux.vnet.ibm.com, clameter@sgi.com


The patch titled
     oom: add sysctl to enable task memory dump
has been added to the -mm tree.  Its filename is
     oom-add-sysctl-to-enable-task-memory-dump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: add sysctl to enable task memory dump
From: David Rientjes <rientjes@google.com>

Adds a new sysctl, 'oom_dump_tasks', that enables the kernel to produce a
dump of all system tasks (excluding kernel threads) when performing an
OOM-killing.  Information includes pid, uid, tgid, vm size, rss, cpu,
oom_adj score, and name.

This is helpful for determining why there was an OOM condition and which
rogue task caused it.

It is configurable so that large systems, such as those with several
thousand tasks, do not incur a performance penalty associated with dumping
data they may not desire.

If an OOM was triggered as a result of a memory controller, the tasklist
shall be filtered to exclude tasks that are not a member of the same
cgroup.

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/sysctl/vm.txt~oom-add-sysctl-to-enable-task-memory-dump Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~oom-add-sysctl-to-enable-task-memory-dump
+++ a/Documentation/sysctl/vm.txt
@@ -31,6 +31,7 @@ Currently, these files are in /proc/sys/
 - min_unmapped_ratio
 - min_slab_ratio
 - panic_on_oom
+- oom_dump_tasks
 - oom_kill_allocating_task
 - mmap_min_address
 - numa_zonelist_order
@@ -223,6 +224,27 @@ according to your policy of failover.
 
 =============================================================
 
+oom_dump_tasks
+
+Enables a system-wide task dump (excluding kernel threads) to be
+produced when the kernel performs an OOM-killing and includes such
+information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
+name.  This is helpful to determine why the OOM killer was invoked
+and to identify the rogue task that caused it.
+
+If this is set to zero, this information is suppressed.  On very
+large systems with thousands of tasks it may not be feasible to dump
+the memory state information for each one.  Such systems should not
+be forced to incur a performance penalty in OOM conditions when the
+information may not be desired.
+
+If this is set to non-zero, this information is shown whenever the
+OOM killer actually kills a memory-hogging task.
+
+The default value is 0.
+
+=============================================================
+
 oom_kill_allocating_task
 
 This enables or disables killing the OOM-triggering task in
diff -puN kernel/sysctl.c~oom-add-sysctl-to-enable-task-memory-dump kernel/sysctl.c
--- a/kernel/sysctl.c~oom-add-sysctl-to-enable-task-memory-dump
+++ a/kernel/sysctl.c
@@ -66,6 +66,7 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -789,6 +790,14 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_dump_tasks",
+		.data		= &sysctl_oom_dump_tasks,
+		.maxlen		= sizeof(sysctl_oom_dump_tasks),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= VM_OVERCOMMIT_RATIO,
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
diff -puN mm/oom_kill.c~oom-add-sysctl-to-enable-task-memory-dump mm/oom_kill.c
--- a/mm/oom_kill.c~oom-add-sysctl-to-enable-task-memory-dump
+++ a/mm/oom_kill.c
@@ -29,6 +29,7 @@
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
+int sysctl_oom_dump_tasks;
 static DEFINE_SPINLOCK(zone_scan_mutex);
 /* #define DEBUG */
 
@@ -264,6 +265,41 @@ static struct task_struct *select_bad_pr
 }
 
 /**
+ * Dumps the current memory state of all system tasks, excluding kernel threads.
+ * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
+ * score, and name.
+ *
+ * If the actual is non-NULL, only tasks that are a member of the mem_cgroup are
+ * shown.
+ *
+ * Call with tasklist_lock read-locked.
+ */
+static void dump_tasks(const struct mem_cgroup *mem)
+{
+	struct task_struct *g, *p;
+
+	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
+	       "name\n");
+	do_each_thread(g, p) {
+		/*
+		 * total_vm and rss sizes do not exist for tasks with a
+		 * detached mm so there's no need to report them.
+		 */
+		if (!p->mm)
+			continue;
+		if (mem && !task_in_mem_cgroup(p, mem))
+			continue;
+
+		task_lock(p);
+		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
+		       p->pid, p->uid, p->tgid, p->mm->total_vm,
+		       get_mm_rss(p->mm), (int)task_cpu(p), p->oomkilladj,
+		       p->comm);
+		task_unlock(p);
+	} while_each_thread(g, p);
+}
+
+/**
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
  * set.
@@ -339,7 +375,8 @@ static int oom_kill_task(struct task_str
 }
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
-			    unsigned long points, const char *message)
+			    unsigned long points, struct mem_cgroup *mem,
+			    const char *message)
 {
 	struct task_struct *c;
 
@@ -349,6 +386,8 @@ static int oom_kill_process(struct task_
 			current->comm, gfp_mask, order, current->oomkilladj);
 		dump_stack();
 		show_mem();
+		if (sysctl_oom_dump_tasks)
+			dump_tasks(mem);
 	}
 
 	/*
@@ -389,7 +428,7 @@ retry:
 	if (!p)
 		p = current;
 
-	if (oom_kill_process(p, gfp_mask, 0, points,
+	if (oom_kill_process(p, gfp_mask, 0, points, mem,
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
@@ -495,7 +534,7 @@ void out_of_memory(struct zonelist *zone
 
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, gfp_mask, order, points,
+		oom_kill_process(current, gfp_mask, order, points, NULL,
 				"No available memory (MPOL_BIND)");
 		break;
 
@@ -505,7 +544,7 @@ void out_of_memory(struct zonelist *zone
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
 		if (sysctl_oom_kill_allocating_task) {
-			oom_kill_process(current, gfp_mask, order, points,
+			oom_kill_process(current, gfp_mask, order, points, NULL,
 					"Out of memory (oom_kill_allocating_task)");
 			break;
 		}
@@ -525,7 +564,7 @@ retry:
 			panic("Out of memory and no killable processes...\n");
 		}
 
-		if (oom_kill_process(p, points, gfp_mask, order,
+		if (oom_kill_process(p, points, gfp_mask, order, NULL,
 				     "Out of memory"))
 			goto retry;
 
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
oom-move-prototypes-to-appropriate-header-file-fix.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
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
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
