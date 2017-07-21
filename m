From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
 added to -mm tree
Date: Fri, 21 Jul 2017 12:12:06 -0700
Message-ID: <59725206.usTFI6cnxOKM3Qr7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbdGUTMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove boot pageset initialization from memory hotplug
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5077,7 +5077,7 @@ DEFINE_MUTEX(zonelists_mutex);
 static int __build_all_zonelists(void *data)
 {
 	int nid;
-	int cpu;
+	int __maybe_unused cpu;
 	pg_data_t *self = data;
 
 #ifdef CONFIG_NUMA
@@ -5098,23 +5098,8 @@ static int __build_all_zonelists(void *d
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
@@ -5125,8 +5110,8 @@ static int __build_all_zonelists(void *d
 		 */
 		if (cpu_online(cpu))
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
-#endif
 	}
+#endif
 
 	return 0;
 }
@@ -5134,7 +5119,26 @@ static int __build_all_zonelists(void *d
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

mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch

