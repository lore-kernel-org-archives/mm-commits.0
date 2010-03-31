From: akpm@linux-foundation.org
Subject: + acpi-map-pxms-to-low-node-ids.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:01:28 -0700
Message-ID: <201003312101.o2VL1Srq008250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758146Ab0CaVFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux-foundation.org, lenb@kernel.org, suresh.b.siddha@intel.com


The patch titled
     acpi: map pxms to low node ids
has been added to the -mm tree.  Its filename is
     acpi-map-pxms-to-low-node-ids.patch

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

linux-next.patch
acpi-map-pxms-to-low-node-ids.patch
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

