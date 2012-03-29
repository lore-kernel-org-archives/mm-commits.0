From: akpm@linux-foundation.org
Subject: [merged] mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:39 -0700
Message-ID: <20120329191339.C7290A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47238 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2C2TNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:42 -0400
Received: by wgbdt11 with SMTP id dt11so111425wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mina86@mina86.org, penberg@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: only IPI CPUs to drain local pages if they exist
has been removed from the -mm tree.  Its filename was
     mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: mm: only IPI CPUs to drain local pages if they exist

Calculate a cpumask of CPUs with per-cpu pages in any zone and only send
an IPI requesting CPUs to drain these pages to the buddy allocator if they
actually have pages when asked to flush.

This patch saves 85%+ of IPIs asking to drain per-cpu pages in case of
severe memory pressure that leads to OOM since in these cases multiple,
possibly concurrent, allocation requests end up in the direct reclaim code
path so when the per-cpu pages end up reclaimed on first allocation
failure for most of the proceeding allocation attempts until the memory
pressure is off (possibly via the OOM killer) there are no per-cpu pages
on most CPUs (and there can easily be hundreds of them).

This also has the side effect of shortening the average latency of direct
reclaim by 1 or more order of magnitude since waiting for all the CPUs to
ACK the IPI takes a long time.

Tested by running "hackbench 400" on a 8 CPU x86 VM and observing the
difference between the number of direct reclaim attempts that end up in
drain_all_pages() and those were more then 1/2 of the online CPU had any
per-cpu page in them, using the vmstat counters introduced in the next
patch in the series and using proc/interrupts.

In the test sceanrio, this was seen to save around 3600 global
IPIs after trigerring an OOM on a concurrent workload:

$ cat /proc/vmstat | tail -n 2
pcp_global_drain 0
pcp_global_ipi_saved 0

$ cat /proc/interrupts | grep CAL
CAL:          1          2          1          2
          2          2          2          2   Function call interrupts

$ hackbench 400
[OOM messages snipped]

$ cat /proc/vmstat | tail -n 2
pcp_global_drain 3647
pcp_global_ipi_saved 3642

$ cat /proc/interrupts | grep CAL
CAL:          6         13          6          3
          3          3         1 2          7   Function call interrupts

Please note that if the global drain is removed from the direct reclaim
path as a patch from Mel Gorman currently suggests this should be replaced
with an on_each_cpu_cond invocation.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: Michal Nazarewicz <mina86@mina86.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist
+++ a/mm/page_alloc.c
@@ -1161,11 +1161,47 @@ void drain_local_pages(void *arg)
 }
 
 /*
- * Spill all the per-cpu pages from all CPUs back into the buddy allocator
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
+ *
+ * Note that this code is protected against sending an IPI to an offline
+ * CPU but does not guarantee sending an IPI to newly hotplugged CPUs:
+ * on_each_cpu_mask() blocks hotplug and won't talk to offlined CPUs but
+ * nothing keeps CPUs from showing up after we populated the cpumask and
+ * before the call to on_each_cpu_mask().
  */
 void drain_all_pages(void)
 {
-	on_each_cpu(drain_local_pages, NULL, 1);
+	int cpu;
+	struct per_cpu_pageset *pcp;
+	struct zone *zone;
+
+	/*
+	 * Allocate in the BSS so we wont require allocation in
+	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
+	 */
+	static cpumask_t cpus_with_pcps;
+
+	/*
+	 * We don't care about racing with CPU hotplug event
+	 * as offline notification will cause the notified
+	 * cpu to drain that CPU pcps and on_each_cpu_mask
+	 * disables preemption as part of its processing
+	 */
+	for_each_online_cpu(cpu) {
+		bool has_pcps = false;
+		for_each_populated_zone(zone) {
+			pcp = per_cpu_ptr(zone->pageset, cpu);
+			if (pcp->pcp.count) {
+				has_pcps = true;
+				break;
+			}
+		}
+		if (has_pcps)
+			cpumask_set_cpu(cpu, &cpus_with_pcps);
+		else
+			cpumask_clear_cpu(cpu, &cpus_with_pcps);
+	}
+	on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
 }
 
 #ifdef CONFIG_HIBERNATION
_

Patches currently in -mm which might be from gilad@benyossef.com are

origin.patch

