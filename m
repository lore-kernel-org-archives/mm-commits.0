From: akpm@linux-foundation.org
Subject: + mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch added to -mm tree
Date: Mon, 11 Apr 2011 14:27:34 -0700
Message-ID: <201104112127.p3BLRYoq002176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab1DKV21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 17:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm, mem-hotplug: recalculate lowmem_reserve when memory hotplug occurs
has been added to the -mm tree.  Its filename is
     mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch

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
Subject: mm, mem-hotplug: recalculate lowmem_reserve when memory hotplug occurs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, memory hotplug calls setup_per_zone_wmarks() and
calculate_zone_inactive_ratio(), but doesn't call
setup_per_zone_lowmem_reserve().

It means the number of reserved pages aren't updated even if memory hot
plug occur.  This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/memory_hotplug.c |    9 +++++----
 mm/page_alloc.c     |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur include/linux/mm.h
--- a/include/linux/mm.h~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur
+++ a/include/linux/mm.h
@@ -1357,7 +1357,7 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
-extern void calculate_zone_inactive_ratio(struct zone *zone);
+extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
diff -puN mm/memory_hotplug.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur
+++ a/mm/memory_hotplug.c
@@ -459,8 +459,9 @@ int __ref online_pages(unsigned long pfn
 		zone_pcp_update(zone);
 
 	mutex_unlock(&zonelists_mutex);
-	setup_per_zone_wmarks();
-	calculate_zone_inactive_ratio(zone);
+
+	init_per_zone_wmark_min();
+
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
@@ -893,8 +894,8 @@ repeat:
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
 
-	setup_per_zone_wmarks();
-	calculate_zone_inactive_ratio(zone);
+	init_per_zone_wmark_min();
+
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
 		kswapd_stop(node);
diff -puN mm/page_alloc.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur mm/page_alloc.c
--- a/mm/page_alloc.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur
+++ a/mm/page_alloc.c
@@ -5066,7 +5066,7 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void __meminit calculate_zone_inactive_ratio(struct zone *zone)
+static void __meminit calculate_zone_inactive_ratio(struct zone *zone)
 {
 	unsigned int gb, ratio;
 
@@ -5112,7 +5112,7 @@ static void __meminit setup_per_zone_ina
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-static int __init init_per_zone_wmark_min(void)
+int __meminit init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

