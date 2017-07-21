From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch added to
 -mm tree
Date: Fri, 21 Jul 2017 12:12:17 -0700
Message-ID: <59725211.3ElIKWzUDzKrdY1r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754431AbdGUTMS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, tglx@linutronix.de, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove stop_machine from build_all_zonelists
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch

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
@@ -5073,8 +5073,7 @@ static DEFINE_PER_CPU(struct per_cpu_nod
  */
 DEFINE_MUTEX(zonelists_mutex);
 
-/* return values int ....just for stop_machine() */
-static int __build_all_zonelists(void *data)
+static void __build_all_zonelists(void *data)
 {
 	int nid;
 	int __maybe_unused cpu;
@@ -5110,8 +5109,6 @@ static int __build_all_zonelists(void *d
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
 #endif
 	}
-
-	return 0;
 }
 
 static noinline void __init
@@ -5153,9 +5150,7 @@ void __ref build_all_zonelists(pg_data_t
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

