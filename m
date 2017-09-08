From: akpm@linux-foundation.org
Subject: [patch 037/126] mm: consider the number in local CPUs when
 reading NUMA stats
Date: Fri, 08 Sep 2017 16:12:55 -0700
Message-ID: <20170908231255.VTTpwZl76%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757223AbdIHXM5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:12:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaron.lu@intel.com, akpm@linux-foundation.org, andi.kleen@intel.com, brouer@redhat.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, kemi.wang@intel.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, tim.c.chen@intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Kemi Wang <kemi.wang@intel.com>
Subject: mm: consider the number in local CPUs when reading NUMA stats

To avoid deviation, the per cpu number of NUMA stats in
vm_numa_stat_diff[] is included when a user *reads* the NUMA stats.

Since NUMA stats does not be read by users frequently, and kernel does not
need it to make a decision, it will not be a problem to make the readers
more expensive.

Link: http://lkml.kernel.org/r/1503568801-21305-4-git-send-email-kemi.wang@intel.com
Signed-off-by: Kemi Wang <kemi.wang@intel.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Ying Huang <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    6 +++++-
 mm/vmstat.c            |    9 +++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/vmstat.h~mm-consider-the-number-in-local-cpus-when-reads-numa-stats include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-consider-the-number-in-local-cpus-when-reads-numa-stats
+++ a/include/linux/vmstat.h
@@ -125,10 +125,14 @@ static inline unsigned long global_numa_
 	return x;
 }
 
-static inline unsigned long zone_numa_state(struct zone *zone,
+static inline unsigned long zone_numa_state_snapshot(struct zone *zone,
 					enum numa_stat_item item)
 {
 	long x = atomic_long_read(&zone->vm_numa_stat[item]);
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		x += per_cpu_ptr(zone->pageset, cpu)->vm_numa_stat_diff[item];
 
 	return x;
 }
diff -puN mm/vmstat.c~mm-consider-the-number-in-local-cpus-when-reads-numa-stats mm/vmstat.c
--- a/mm/vmstat.c~mm-consider-the-number-in-local-cpus-when-reads-numa-stats
+++ a/mm/vmstat.c
@@ -897,6 +897,10 @@ unsigned long sum_zone_node_page_state(i
 	return count;
 }
 
+/*
+ * Determine the per node value of a numa stat item. To avoid deviation,
+ * the per cpu stat number in vm_numa_stat_diff[] is also included.
+ */
 unsigned long sum_zone_numa_state(int node,
 				 enum numa_stat_item item)
 {
@@ -905,7 +909,7 @@ unsigned long sum_zone_numa_state(int no
 	unsigned long count = 0;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
-		count += zone_numa_state(zones + i, item);
+		count += zone_numa_state_snapshot(zones + i, item);
 
 	return count;
 }
@@ -1536,7 +1540,7 @@ static void zoneinfo_show_print(struct s
 	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu",
 				vmstat_text[i + NR_VM_ZONE_STAT_ITEMS],
-				zone_numa_state(zone, i));
+				zone_numa_state_snapshot(zone, i));
 #endif
 
 	seq_printf(m, "\n  pagesets");
@@ -1792,6 +1796,7 @@ static bool need_update(int cpu)
 #ifdef CONFIG_NUMA
 		BUILD_BUG_ON(sizeof(p->vm_numa_stat_diff[0]) != 2);
 #endif
+
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
 		 * This works because the diffs are byte sized items.
_
