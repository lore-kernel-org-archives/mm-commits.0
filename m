From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-get-rid-of-zonelists_mutex.patch added to -mm tree
Date: Fri, 21 Jul 2017 12:12:19 -0700
Message-ID: <59725213.RLKwKCNejtzUIoy7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754431AbdGUTMU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, fengguang.wu@intel.com, haicheng.li@linux.intel.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: get rid of zonelists_mutex
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-get-rid-of-zonelists_mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-get-rid-of-zonelists_mutex.patch

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
Subject: mm, memory_hotplug: get rid of zonelists_mutex

zonelists_mutex has been introduced by 4eaf3f64397c ("mem-hotplug: fix
potential race while building zonelist for new populated zone") to protect
zonelist building from races.  This is no longer needed though because
both memory online and offline are fully serialized.  New users have grown
since then.

Notably setup_per_zone_wmarks wants to prevent from races between memory
hotplug, khugepaged setup and manual min_free_kbytes update via sysctl
(see cfd3da1e49bb ("mm: Serialize access to min_free_kbytes").  Let's add
a private lock for that purpose.  This will not prevent from seeing
halfway through memory hotplug operation but that shouldn't be a big deal
becuse memory hotplug will update watermarks explicitly so we will
eventually get a full picture.  The lock just makes sure we won't race
when updating watermarks leading to weird results.

Also __build_all_zonelists manipulates global data so add a private lock
for it as well.  This doesn't seem to be necessary today but it is more
robust to have a lock there.

While we are at it make sure we document that memory online/offline
depends on a full serialization either via mem_hotplug_begin() or
device_lock.

Link: http://lkml.kernel.org/r/20170721143915.14161-9-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/memory_hotplug.c    |   12 ++----------
 mm/page_alloc.c        |   18 +++++++++---------
 3 files changed, 11 insertions(+), 20 deletions(-)

diff -puN include/linux/mmzone.h~mm-memory_hotplug-get-rid-of-zonelists_mutex include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-memory_hotplug-get-rid-of-zonelists_mutex
+++ a/include/linux/mmzone.h
@@ -770,7 +770,6 @@ static inline bool is_dev_zone(const str
 
 #include <linux/memory_hotplug.h>
 
-extern struct mutex zonelists_mutex;
 void build_all_zonelists(pg_data_t *pgdat);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-get-rid-of-zonelists_mutex mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-get-rid-of-zonelists_mutex
+++ a/mm/memory_hotplug.c
@@ -901,7 +901,7 @@ static struct zone * __meminit move_pfn_
 	return zone;
 }
 
-/* Must be protected by mem_hotplug_begin() */
+/* Must be protected by mem_hotplug_begin() or a device_lock */
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
 {
 	unsigned long flags;
@@ -930,7 +930,6 @@ int __ref online_pages(unsigned long pfn
 	 * This means the page allocator ignores this zone.
 	 * So, zonelist must be updated after online.
 	 */
-	mutex_lock(&zonelists_mutex);
 	if (!populated_zone(zone)) {
 		need_zonelists_rebuild = 1;
 		setup_zone_pageset(zone);
@@ -941,7 +940,6 @@ int __ref online_pages(unsigned long pfn
 	if (ret) {
 		if (need_zonelists_rebuild)
 			zone_pcp_reset(zone);
-		mutex_unlock(&zonelists_mutex);
 		goto failed_addition;
 	}
 
@@ -959,8 +957,6 @@ int __ref online_pages(unsigned long pfn
 			zone_pcp_update(zone);
 	}
 
-	mutex_unlock(&zonelists_mutex);
-
 	init_per_zone_wmark_min();
 
 	if (onlined_pages) {
@@ -1031,9 +1027,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 	 * The node we allocated has no zone fallback lists. For avoiding
 	 * to access not-initialized zonelist, build here.
 	 */
-	mutex_lock(&zonelists_mutex);
 	build_all_zonelists(pgdat);
-	mutex_unlock(&zonelists_mutex);
 
 	/*
 	 * zone->managed_pages is set to an approximate value in
@@ -1702,9 +1696,7 @@ repeat:
 
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
-		mutex_lock(&zonelists_mutex);
 		build_all_zonelists(NULL);
-		mutex_unlock(&zonelists_mutex);
 	} else
 		zone_pcp_update(zone);
 
@@ -1730,7 +1722,7 @@ failed_removal:
 	return ret;
 }
 
-/* Must be protected by mem_hotplug_begin() */
+/* Must be protected by mem_hotplug_begin() or a device_lock */
 int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
 	return __offline_pages(start_pfn, start_pfn + nr_pages, 120 * HZ);
diff -puN mm/page_alloc.c~mm-memory_hotplug-get-rid-of-zonelists_mutex mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-get-rid-of-zonelists_mutex
+++ a/mm/page_alloc.c
@@ -5067,17 +5067,14 @@ static void setup_pageset(struct per_cpu
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
-/*
- * Global mutex to protect against size modification of zonelists
- * as well as to serialize pageset setup for the new populated zone.
- */
-DEFINE_MUTEX(zonelists_mutex);
-
 static void __build_all_zonelists(void *data)
 {
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
+	static DEFINE_SPINLOCK(lock);
+
+	spin_lock(&lock);
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
@@ -5109,6 +5106,8 @@ static void __build_all_zonelists(void *
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
 #endif
 	}
+
+	spin_unlock(&lock);
 }
 
 static noinline void __init
@@ -5139,7 +5138,6 @@ build_all_zonelists_init(void)
 }
 
 /*
- * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
  *
  * __ref due to call of __init annotated helper build_all_zonelists_init
@@ -6875,9 +6873,11 @@ static void __setup_per_zone_wmarks(void
  */
 void setup_per_zone_wmarks(void)
 {
-	mutex_lock(&zonelists_mutex);
+	static DEFINE_SPINLOCK(lock);
+
+	spin_lock(&lock);
 	__setup_per_zone_wmarks();
-	mutex_unlock(&zonelists_mutex);
+	spin_unlock(&lock);
 }
 
 /*
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

