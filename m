From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:37:58 -0700
Message-ID: <20170907183758.lJB0PPs1n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSh7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz


The patch titled
     Subject: mm, page_alloc: do not set_cpu_numa_mem on empty nodes initialization
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: do not set_cpu_numa_mem on empty nodes initialization

__build_all_zonelists reinitializes each online cpu local node for
CONFIG_HAVE_MEMORYLESS_NODES.  This makes sense because previously memory
less nodes could gain some memory during memory hotplug and so the local
node should be changed for CPUs close to such a node.  It makes less sense
to do that unconditionally for a newly creaded NUMA node which is still
offline and without any memory.

Let's also simplify the cpu loop and use for_each_online_cpu instead of an
explicit cpu_online check for all possible cpus.

Link: http://lkml.kernel.org/r/20170721143915.14161-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization
+++ a/mm/page_alloc.c
@@ -5160,10 +5160,8 @@ static int __build_all_zonelists(void *d
 
 			build_zonelists(pgdat);
 		}
-	}
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
-	for_each_possible_cpu(cpu) {
 		/*
 		 * We now know the "local memory node" for each node--
 		 * i.e., the node of the first zone in the generic zonelist.
@@ -5172,10 +5170,10 @@ static int __build_all_zonelists(void *d
 		 * secondary cpus' numa_mem as they come on-line.  During
 		 * node/memory hotplug, we'll fixup all on-line cpus.
 		 */
-		if (cpu_online(cpu))
+		for_each_online_cpu(cpu)
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
-	}
 #endif
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-introduce-add_pages.patch
mm-sparse-fix-typo-in-online_mem_sections.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

