From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
 added to -mm tree
Date: Fri, 21 Jul 2017 12:12:08 -0700
Message-ID: <59725208.Cg+t13dKgA9Q6m1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbdGUTMJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: do not set_cpu_numa_mem on empty nodes initialization
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch

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
@@ -5096,10 +5096,8 @@ static int __build_all_zonelists(void *d
 
 			build_zonelists(pgdat);
 		}
-	}
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
-	for_each_possible_cpu(cpu) {
 		/*
 		 * We now know the "local memory node" for each node--
 		 * i.e., the node of the first zone in the generic zonelist.
@@ -5108,10 +5106,10 @@ static int __build_all_zonelists(void *d
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

