From: akpm@linux-foundation.org
Subject: + mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch added to -mm tree
Date: Mon, 11 Apr 2011 14:27:37 -0700
Message-ID: <201104112127.p3BLRcB7002179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab1DKV23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 17:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
has been added to the -mm tree.  Its filename is
     mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch

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
Subject: mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, cpu hotplug updates pcp->stat_threshold, but memory hotplug
doesn't.  There is no reason for this.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 +
 mm/page_alloc.c        |    2 ++
 mm/vmstat.c            |    3 +--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur
+++ a/include/linux/vmstat.h
@@ -261,6 +261,7 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
+void refresh_zone_stat_thresholds(void);
 
 int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
diff -puN mm/page_alloc.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur mm/page_alloc.c
--- a/mm/page_alloc.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur
+++ a/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
 #include <linux/memcontrol.h>
+#include <linux/vmstat.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -5124,6 +5125,7 @@ int __meminit init_per_zone_wmark_min(vo
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
 	setup_per_zone_wmarks();
+	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();
 	return 0;
diff -puN mm/vmstat.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur mm/vmstat.c
--- a/mm/vmstat.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur
+++ a/mm/vmstat.c
@@ -157,7 +157,7 @@ int calculate_normal_threshold(struct zo
 /*
  * Refresh the thresholds for each zone.
  */
-static void refresh_zone_stat_thresholds(void)
+void refresh_zone_stat_thresholds(void)
 {
 	struct zone *zone;
 	int cpu;
@@ -1198,7 +1198,6 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_SMP
 	int cpu;
 
-	refresh_zone_stat_thresholds();
 	register_cpu_notifier(&vmstat_notifier);
 
 	for_each_online_cpu(cpu)
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

