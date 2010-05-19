From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-hold-tasklist_lock-when-dumping-tasks.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:20 -0700
Message-ID: <201005191848.o4JImK9S029496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101Ab0ESSz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     oom: hold tasklist_lock when dumping tasks
has been removed from the -mm tree.  Its filename was
     oom-hold-tasklist_lock-when-dumping-tasks.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: hold tasklist_lock when dumping tasks
From: David Rientjes <rientjes@google.com>

dump_header() always requires tasklist_lock to be held because it calls
dump_tasks() which iterates through the tasklist.  There are a few places
where this isn't maintained, so make sure tasklist_lock is always held
whenever calling dump_header().

This also fixes the pagefault case where oom_kill_process() is called on
current without tasklist_lock.  It is necessary to hold a readlock for
both calling dump_header() and iterating its children.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN mm/oom_kill.c~oom-hold-tasklist_lock-when-dumping-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~oom-hold-tasklist_lock-when-dumping-tasks
+++ a/mm/oom_kill.c
@@ -414,6 +414,9 @@ static void dump_tasks(const struct mem_
 	} while_each_thread(g, p);
 }
 
+/*
+ * Call with tasklist_lock read-locked.
+ */
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 							struct mem_cgroup *mem)
 {
@@ -660,8 +663,8 @@ retry:
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		read_unlock(&tasklist_lock);
 		dump_header(NULL, gfp_mask, order, NULL);
+		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -694,11 +697,6 @@ void out_of_memory(struct zonelist *zone
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom == 2) {
-		dump_header(NULL, gfp_mask, order, NULL);
-		panic("out of memory. Compulsory panic_on_oom is selected.\n");
-	}
-
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
@@ -707,15 +705,12 @@ void out_of_memory(struct zonelist *zone
 						&totalpages);
 	read_lock(&tasklist_lock);
 	if (unlikely(sysctl_panic_on_oom)) {
-		/*
-		 * panic_on_oom only affects CONSTRAINT_NONE, the kernel
-		 * should not panic for cpuset or mempolicy induced memory
-		 * failures.
-		 */
-		if (constraint == CONSTRAINT_NONE) {
+		if (sysctl_panic_on_oom == 2 || constraint == CONSTRAINT_NONE) {
 			dump_header(NULL, gfp_mask, order, NULL);
 			read_unlock(&tasklist_lock);
-			panic("Out of memory: panic_on_oom is enabled\n");
+			panic("Out of memory: %s panic_on_oom is enabled\n",
+				sysctl_panic_on_oom == 2 ? "compulsory" :
+							   "system-wide");
 		}
 	}
 	__out_of_memory(gfp_mask, order, totalpages, constraint, nodemask);
@@ -743,8 +738,10 @@ void pagefault_out_of_memory(void)
 
 	if (try_set_system_oom()) {
 		constrained_alloc(NULL, 0, NULL, &totalpages);
+		read_lock(&tasklist_lock);
 		err = oom_kill_process(current, 0, 0, 0, totalpages, NULL,
 					"Out of memory (pagefault)");
+		read_unlock(&tasklist_lock);
 		if (err)
 			out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

