From: akpm@linux-foundation.org
Subject: [merged] acpi-map-pxms-to-low-node-ids.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:51:07 -0400
Message-ID: <201004071852.o37IqXgY001376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab0DGSwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, lenb@kernel.org, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: map pxms to low node ids
has been removed from the -mm tree.  Its filename was
     acpi-map-pxms-to-low-node-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: map pxms to low node ids
From: David Rientjes <rientjes@google.com>

pxms are mapped to low node ids to maintain generic kernel use of
functions such as pxm_to_node() that are used to determine device
affinity.  Otherwise, there is no pxm-to-node and node-to-pxm matching
rule for x86_64 users of NUMA emulation where a single pxm may be bound to
multiple NUMA nodes.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/numa.c~acpi-map-pxms-to-low-node-ids drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-map-pxms-to-low-node-ids
+++ a/drivers/acpi/numa.c
@@ -61,8 +61,10 @@ int node_to_pxm(int node)
 
 void __acpi_map_pxm_to_node(int pxm, int node)
 {
-	pxm_to_node_map[pxm] = node;
-	node_to_pxm_map[node] = pxm;
+	if (pxm_to_node_map[pxm] == NUMA_NO_NODE || node < pxm_to_node_map[pxm])
+		pxm_to_node_map[pxm] = node;
+	if (node_to_pxm_map[node] == PXM_INVAL || pxm < node_to_pxm_map[node])
+		node_to_pxm_map[node] = pxm;
 }
 
 int acpi_map_pxm_to_node(int pxm)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
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
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
oom-move-sysctl-declarations-to-oomh.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

