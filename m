From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:38:10 -0700
Message-ID: <20170907183810.8yYGe6d5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755722AbdIGSiL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, shaohua.li@intel.com, tglx@linutronix.de, toshi.kani@hpe.com, vbabka@suse.cz


The patch titled
     Subject: mm, page_alloc: remove stop_machine from build_all_zonelists
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: remove stop_machine from build_all_zonelists

build_all_zonelists has been (ab)using stop_machine to make sure that
zonelists do not change while somebody is looking at them.  This is is
just a gross hack because a) it complicates the context from which we can
call build_all_zonelists (see 3f906ba23689 ("mm/memory-hotplug: switch
locking to a percpu rwsem")) and b) is is not really necessary especially
after "mm, page_alloc: simplify zonelist initialization" and c) it doesn't
really provide the protection it claims (see below).

Updates of the zonelists happen very seldom, basically only when a zone
becomes populated during memory online or when it loses all the memory
during offline.  A racing iteration over zonelists could either miss a
zone or try to work on one zone twice.  Both of these are something we can
live with occasionally because there will always be at least one zone
visible so we are not likely to fail allocation too easily for example.

Please note that the original stop_machine approach doesn't really provide
a better exclusion because the iteration might be interrupted half way
(unless the whole iteration is preempt disabled which is not the case in
most cases) so the some zones could still be seen twice or a zone missed.

I have run the pathological online/offline of the single memblock in the
movable zone while stressing the same small node with some memory
pressure.

Node 1, zone      DMA
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        protection: (0, 943, 943, 943)
Node 1, zone    DMA32
  pages free     227310
        min      8294
        low      10367
        high     12440
        spanned  262112
        present  262112
        managed  241436
        protection: (0, 0, 0, 0)
Node 1, zone   Normal
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        protection: (0, 0, 0, 1024)
Node 1, zone  Movable
  pages free     32722
        min      85
        low      117
        high     149
        spanned  32768
        present  32768
        managed  32768
        protection: (0, 0, 0, 0)

root@test1:/sys/devices/system/node/node1# while true
do
	echo offline > memory34/state
	echo online_movable > memory34/state
done

root@test1:/mnt/data/test/linux-3.7-rc5# numactl --preferred=1 make -j4

and it survived without any unexpected behavior.  While this is not really
a great testing coverage it should exercise the allocation path quite a
lot.

Link: http://lkml.kernel.org/r/20170721143915.14161-8-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-stop_machine-from-build_all_zonelists mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-stop_machine-from-build_all_zonelists
+++ a/mm/page_alloc.c
@@ -5137,8 +5137,7 @@ static DEFINE_PER_CPU(struct per_cpu_nod
  */
 DEFINE_MUTEX(zonelists_mutex);
 
-/* return values int ....just for stop_machine() */
-static int __build_all_zonelists(void *data)
+static void __build_all_zonelists(void *data)
 {
 	int nid;
 	int __maybe_unused cpu;
@@ -5174,8 +5173,6 @@ static int __build_all_zonelists(void *d
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
 #endif
 	}
-
-	return 0;
 }
 
 static noinline void __init
@@ -5217,9 +5214,7 @@ void __ref build_all_zonelists(pg_data_t
 	if (system_state == SYSTEM_BOOTING) {
 		build_all_zonelists_init();
 	} else {
-		/* we have to stop all cpus to guarantee there is no user
-		   of zonelist */
-		stop_machine_cpuslocked(__build_all_zonelists, pgdat, NULL);
+		__build_all_zonelists(pgdat);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-introduce-add_pages.patch
mm-sparse-fix-typo-in-online_mem_sections.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

