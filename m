From: akpm@linux-foundation.org
Subject: + mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:52 -0800
Message-ID: <20120128001552.2A8F0A043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:56201 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2A1APy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:54 -0500
Received: by wicr5 with SMTP id r5so52960wic.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, penberg@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: only IPI CPUs to drain local pages if they exist
has been added to the -mm tree.  Its filename is
     mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist
+++ a/mm/page_alloc.c
@@ -1178,7 +1178,36 @@ void drain_local_pages(void *arg)
  */
 void drain_all_pages(void)
 {
-	on_each_cpu(drain_local_pages, NULL, 1);
+	int cpu;
+	struct per_cpu_pageset *pcp;
+	struct zone *zone;
+
+	/* Allocate in the BSS so we wont require allocation in
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
Subject: Subject: mm: only IPI CPUs to drain local pages if they exist

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

