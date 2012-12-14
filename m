From: akpm@linux-foundation.org
Subject: [merged] mempolicy-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:24 -0800
Message-ID: <20121214232825.30DA8200086@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:36847 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422639Ab2LNX21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:27 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so208143eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     mempolicy-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: mempolicy: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-use-n_memory-instead-n_high_memory mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-use-n_memory-instead-n_high_memory
+++ a/mm/mempolicy.c
@@ -212,9 +212,9 @@ static int mpol_set_nodemask(struct memp
 	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
 	if (pol == NULL)
 		return 0;
-	/* Check N_HIGH_MEMORY */
+	/* Check N_MEMORY */
 	nodes_and(nsc->mask1,
-		  cpuset_current_mems_allowed, node_states[N_HIGH_MEMORY]);
+		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
 
 	VM_BUG_ON(!nodes);
 	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
@@ -1388,7 +1388,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		goto out_put;
 	}
 
-	if (!nodes_subset(*new, node_states[N_HIGH_MEMORY])) {
+	if (!nodes_subset(*new, node_states[N_MEMORY])) {
 		err = -EINVAL;
 		goto out_put;
 	}
@@ -2326,7 +2326,7 @@ void __init numa_policy_init(void)
 	 * fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -2407,7 +2407,7 @@ int mpol_parse_str(char *str, struct mem
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(nodes, node_states[N_HIGH_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_MEMORY]))
 			goto out;
 	} else
 		nodes_clear(nodes);
@@ -2441,7 +2441,7 @@ int mpol_parse_str(char *str, struct mem
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			nodes = node_states[N_HIGH_MEMORY];
+			nodes = node_states[N_MEMORY];
 		break;
 	case MPOL_LOCAL:
 		/*
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

