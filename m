From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-avoid-divide-by-zero.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:34 -0700
Message-ID: <201005191848.o4JImYxK029518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab0ESStA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     oom: avoid divide by zero
has been removed from the -mm tree.  Its filename was
     oom-avoid-divide-by-zero.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: avoid divide by zero
From: David Rientjes <rientjes@google.com>

It's evidently possible for a memory controller to have a limit of 0
bytes, so it's possible for the oom killer to have a divide by zero error
in such circumstances.

When this is the case, each candidate task's rss and swap is divided by
one so they are essentially ranked according to whichever task attached to
the cgroup has the most resident RAM and swap.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Tested-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/oom_kill.c~oom-avoid-divide-by-zero mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-divide-by-zero
+++ a/mm/oom_kill.c
@@ -189,6 +189,14 @@ unsigned int oom_badness(struct task_str
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 0;
+
+	/*
+	 * The memory controller can have a limit of 0 bytes, so avoid a divide
+	 * by zero if necessary.
+	 */
+	if (!totalpages)
+		totalpages = 1;
+
 	/*
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss and swap space use.
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

