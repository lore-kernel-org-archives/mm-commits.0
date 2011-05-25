From: akpm@linux-foundation.org
Subject: [merged] mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:38 -0700
Message-ID: <201105252026.p4PKQ1nZ014457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab1EYU0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm, mem-hotplug: fix section mismatch. setup_per_zone_inactive_ratio() should be __meminit.
has been removed from the -mm tree.  Its filename was
     mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm, mem-hotplug: fix section mismatch. setup_per_zone_inactive_ratio() should be __meminit.
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Commit bce7394a3e ("page-allocator: reset wmark_min and inactive ratio of
zone when hotplug happens") introduced invalid section references.  Now,
setup_per_zone_inactive_ratio() is marked __init and then it can't be
referenced from memory hotplug code.

This patch marks it as __meminit and also marks caller as __ref.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 mm/page_alloc.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit
+++ a/mm/memory_hotplug.c
@@ -400,7 +400,7 @@ static int online_pages_range(unsigned l
 }
 
 
-int online_pages(unsigned long pfn, unsigned long nr_pages)
+int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
@@ -795,7 +795,7 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-static int offline_pages(unsigned long start_pfn,
+static int __ref offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
 	unsigned long pfn, nr_pages, expire;
diff -puN mm/page_alloc.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit mm/page_alloc.c
--- a/mm/page_alloc.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit
+++ a/mm/page_alloc.c
@@ -5094,7 +5094,7 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void calculate_zone_inactive_ratio(struct zone *zone)
+void __meminit calculate_zone_inactive_ratio(struct zone *zone)
 {
 	unsigned int gb, ratio;
 
@@ -5108,7 +5108,7 @@ void calculate_zone_inactive_ratio(struc
 	zone->inactive_ratio = ratio;
 }
 
-static void __init setup_per_zone_inactive_ratio(void)
+static void __meminit setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

