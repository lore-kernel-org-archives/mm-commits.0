From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-reintroduce-and-deprecate-oom_kill_allocating_task.patch removed from -mm tree
Date: Wed, 19 May 2010 11:47:50 -0700
Message-ID: <201005191847.o4JIloEE029431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab0ESS5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: reintroduce and deprecate oom_kill_allocating_task
has been removed from the -mm tree.  Its filename was
     oom-reintroduce-and-deprecate-oom_kill_allocating_task.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: reintroduce and deprecate oom_kill_allocating_task
From: David Rientjes <rientjes@google.com>

There's a concern that removing /proc/sys/vm/oom_kill_allocating_task will
unnecessarily break the userspace API as the result of the oom killer
rewrite.

This patch reintroduces the sysctl and deprecates it by adding an entry to
Documentation/feature-removal-schedule.txt with a suggested removal date
of December 2011 and emitting a warning the first time it is written
including the writing task's name and pid.

/proc/sys/vm/oom_kill_allocating task mirrors the value of
/proc/sys/vm/oom_kill_quick.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   19 +++++++++++++++++++
 include/linux/oom.h                        |    2 ++
 kernel/sysctl.c                            |    7 +++++++
 mm/oom_kill.c                              |   14 ++++++++++++++
 4 files changed, 42 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~oom-reintroduce-and-deprecate-oom_kill_allocating_task Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~oom-reintroduce-and-deprecate-oom_kill_allocating_task
+++ a/Documentation/feature-removal-schedule.txt
@@ -174,6 +174,25 @@ Who:	Eric Biederman <ebiederm@xmission.c
 
 ---------------------------
 
+What:	/proc/sys/vm/oom_kill_allocating_task
+When:	December 2011
+Why:	/proc/sys/vm/oom_kill_allocating_task is equivalent to
+	/proc/sys/vm/oom_kill_quick.  The two sysctls will mirror each other's
+	value when set.
+
+	Existing users of /proc/sys/vm/oom_kill_allocating_task should simply
+	write a non-zero value to /proc/sys/vm/oom_kill_quick.  This will also
+	suppress a costly tasklist scan when dumping VM information for all
+	oom kill candidates.
+
+	A warning will be emitted to the kernel log if an application uses this
+	deprecated interface.  After it is printed once, future warning will be
+	suppressed until the kernel is rebooted.
+
+Who:	David Rientjes <rientjes@google.com>
+
+---------------------------
+
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff -puN include/linux/oom.h~oom-reintroduce-and-deprecate-oom_kill_allocating_task include/linux/oom.h
--- a/include/linux/oom.h~oom-reintroduce-and-deprecate-oom_kill_allocating_task
+++ a/include/linux/oom.h
@@ -46,6 +46,8 @@ extern void out_of_memory(struct zonelis
 		int order, nodemask_t *mask);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
+extern int oom_kill_allocating_task_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos);
 
 extern bool oom_killer_disabled;
 
diff -puN kernel/sysctl.c~oom-reintroduce-and-deprecate-oom_kill_allocating_task kernel/sysctl.c
--- a/kernel/sysctl.c~oom-reintroduce-and-deprecate-oom_kill_allocating_task
+++ a/kernel/sysctl.c
@@ -997,6 +997,13 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "oom_kill_allocating_task",
+		.data		= &sysctl_oom_kill_quick,
+		.maxlen		= sizeof(sysctl_oom_kill_quick),
+		.mode		= 0644,
+		.proc_handler	= oom_kill_allocating_task_handler,
+	},
+	{
 		.procname	= "oom_forkbomb_thres",
 		.data		= &sysctl_oom_forkbomb_thres,
 		.maxlen		= sizeof(sysctl_oom_forkbomb_thres),
diff -puN mm/oom_kill.c~oom-reintroduce-and-deprecate-oom_kill_allocating_task mm/oom_kill.c
--- a/mm/oom_kill.c~oom-reintroduce-and-deprecate-oom_kill_allocating_task
+++ a/mm/oom_kill.c
@@ -38,6 +38,20 @@ int sysctl_oom_dump_tasks;
 int sysctl_oom_forkbomb_thres = DEFAULT_OOM_FORKBOMB_THRES;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+int oom_kill_allocating_task_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (!ret && write)
+		printk_once(KERN_WARNING "%s (%d): "
+			"/proc/sys/vm/oom_kill_allocating_task is deprecated, "
+			"please use /proc/sys/vm/oom_kill_quick instead.\n",
+			current->comm, task_pid_nr(current));
+	return ret;
+}
+
 /*
  * Do all threads of the target process overlap our allowed nodes?
  * @tsk: task struct of which task to consider
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
oom-reintroduce-and-deprecate-oom_kill_allocating_task.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-deprecate-oom_adj-tunable.patch
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

