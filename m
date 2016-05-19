From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-linux-nodemaskh-create-next_node_in-helper-fix.patch removed from
 -mm tree
Date: Thu, 19 May 2016 16:44:51 -0700
Message-ID: <573e4ff3.Od55tQR1luih/uvz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbcESXow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: use next_node_in() helper
has been removed from the -mm tree.  Its filename was
     include-linux-nodemaskh-create-next_node_in-helper-fix.patch

This patch was dropped because it was folded into include-linux-nodemaskh-create-next_node_in-helper.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: use next_node_in() helper

add missing parts found by
git grep -A1 "= *\<next_node("

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/setup.c |    4 +---
 arch/x86/mm/numa.c       |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/tile/kernel/setup.c~include-linux-nodemaskh-create-next_node_in-helper-fix arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~include-linux-nodemaskh-create-next_node_in-helper-fix
+++ a/arch/tile/kernel/setup.c
@@ -962,9 +962,7 @@ static void __init setup_numa_mapping(vo
 		cpumask_set_cpu(best_cpu, &node_2_cpu_mask[node]);
 		cpu_2_node[best_cpu] = node;
 		cpumask_clear_cpu(best_cpu, &unbound_cpus);
-		node = next_node(node, default_nodes);
-		if (node == MAX_NUMNODES)
-			node = first_node(default_nodes);
+		node = next_node_in(node, default_nodes);
 	}
 
 	/* Print out node assignments and set defaults for disabled cpus */
diff -puN arch/x86/mm/numa.c~include-linux-nodemaskh-create-next_node_in-helper-fix arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~include-linux-nodemaskh-create-next_node_in-helper-fix
+++ a/arch/x86/mm/numa.c
@@ -617,9 +617,7 @@ static void __init numa_init_array(void)
 		if (early_cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
 		numa_set_node(i, rr);
-		rr = next_node(rr, node_online_map);
-		if (rr == MAX_NUMNODES)
-			rr = first_node(node_online_map);
+		rr = next_node_in(rr, node_online_map);
 	}
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch

