From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:37:55 -0700
Message-ID: <20170907183755.03ikLg9dQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55418 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSh4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz


The patch titled
     Subject: mm, page_alloc: remove boot pageset initialization from memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: remove boot pageset initialization from memory hotplug

boot_pageset is a boot time hack which gets superseded by normal pagesets
later in the boot process.  It makes zero sense to reinitialize it again
and again during memory hotplug.

Link: http://lkml.kernel.org/r/20170721143915.14161-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug
+++ a/mm/page_alloc.c
@@ -5141,7 +5141,7 @@ DEFINE_MUTEX(zonelists_mutex);
 static int __build_all_zonelists(void *data)
 {
 	int nid;
-	int cpu;
+	int __maybe_unused cpu;
 	pg_data_t *self = data;
 
 #ifdef CONFIG_NUMA
@@ -5162,23 +5162,8 @@ static int __build_all_zonelists(void *d
 		}
 	}
 
-	/*
-	 * Initialize the boot_pagesets that are going to be used
-	 * for bootstrapping processors. The real pagesets for
-	 * each zone will be allocated later when the per cpu
-	 * allocator is available.
-	 *
-	 * boot_pagesets are used also for bootstrapping offline
-	 * cpus if the system is already booted because the pagesets
-	 * are needed to initialize allocators on a specific cpu too.
-	 * F.e. the percpu allocator needs the page allocator which
-	 * needs the percpu allocator in order to allocate its pagesets
-	 * (a chicken-egg dilemma).
-	 */
-	for_each_possible_cpu(cpu) {
-		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
-
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
+	for_each_possible_cpu(cpu) {
 		/*
 		 * We now know the "local memory node" for each node--
 		 * i.e., the node of the first zone in the generic zonelist.
@@ -5189,8 +5174,8 @@ static int __build_all_zonelists(void *d
 		 */
 		if (cpu_online(cpu))
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
-#endif
 	}
+#endif
 
 	return 0;
 }
@@ -5198,7 +5183,26 @@ static int __build_all_zonelists(void *d
 static noinline void __init
 build_all_zonelists_init(void)
 {
+	int cpu;
+
 	__build_all_zonelists(NULL);
+
+	/*
+	 * Initialize the boot_pagesets that are going to be used
+	 * for bootstrapping processors. The real pagesets for
+	 * each zone will be allocated later when the per cpu
+	 * allocator is available.
+	 *
+	 * boot_pagesets are used also for bootstrapping offline
+	 * cpus if the system is already booted because the pagesets
+	 * are needed to initialize allocators on a specific cpu too.
+	 * F.e. the percpu allocator needs the page allocator which
+	 * needs the percpu allocator in order to allocate its pagesets
+	 * (a chicken-egg dilemma).
+	 */
+	for_each_possible_cpu(cpu)
+		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
+
 	mminit_verify_zonelist();
 	cpuset_init_current_mems_allowed();
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-introduce-add_pages.patch
mm-sparse-fix-typo-in-online_mem_sections.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

