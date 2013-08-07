From: akpm@linux-foundation.org
Subject: +
 vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch added to -mm tree
Date: Wed, 07 Aug 2013 13:43:06 -0700
Message-ID: <5202b15a.VNGLv+sHVHuYs8vE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab3HGUnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, js1304@gmail.com, adobriyan@gmail.com, cl@linux.com

Subject: + vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch added to -mm tree
To: cl@linux.com,adobriyan@gmail.com,js1304@gmail.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:43:06 -0700


The patch titled
     Subject: vmstat: create separate function to fold per cpu diffs into local counters
has been added to the -mm tree.  Its filename is
     vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat: create separate function to fold per cpu diffs into local counters

The main idea behind this patchset is to reduce the vmstat update overhead
by avoiding interrupt enable/disable and the use of per cpu atomics.


This patch (of 3):

It is better to have a separate folding function because
refresh_cpu_vm_stats() also does other things like expire pages in the
page allocator caches.

If we have a separate function then refresh_cpu_vm_stats() is only called
from the local cpu which allows additional optimizations.

The folding function is only called when a cpu is being downed and
therefore no other processor will be accessing the counters.  Also
simplifies synchronization.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 -
 mm/page_alloc.c        |    2 -
 mm/vmstat.c            |   40 +++++++++++++++++++++++++++++++++------
 3 files changed, 36 insertions(+), 8 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters
+++ a/include/linux/vmstat.h
@@ -198,7 +198,7 @@ extern void __inc_zone_state(struct zone
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
-void refresh_cpu_vm_stats(int);
+void cpu_vm_stats_fold(int);
 void refresh_zone_stat_thresholds(void);
 
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *);
diff -puN mm/page_alloc.c~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters mm/page_alloc.c
--- a/mm/page_alloc.c~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters
+++ a/mm/page_alloc.c
@@ -5404,7 +5404,7 @@ static int page_alloc_cpu_notify(struct
 		 * This is only okay since the processor is dead and cannot
 		 * race with what we are doing.
 		 */
-		refresh_cpu_vm_stats(cpu);
+		cpu_vm_stats_fold(cpu);
 	}
 	return NOTIFY_OK;
 }
diff -puN mm/vmstat.c~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters mm/vmstat.c
--- a/mm/vmstat.c~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters
+++ a/mm/vmstat.c
@@ -415,11 +415,7 @@ EXPORT_SYMBOL(dec_zone_page_state);
 #endif
 
 /*
- * Update the zone counters for one cpu.
- *
- * The cpu specified must be either the current cpu or a processor that
- * is not online. If it is the current cpu then the execution thread must
- * be pinned to the current cpu.
+ * Update the zone counters for the current cpu.
  *
  * Note that refresh_cpu_vm_stats strives to only access
  * node local memory. The per cpu pagesets on remote zones are placed
@@ -432,7 +428,7 @@ EXPORT_SYMBOL(dec_zone_page_state);
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
  */
-void refresh_cpu_vm_stats(int cpu)
+static void refresh_cpu_vm_stats(int cpu)
 {
 	struct zone *zone;
 	int i;
@@ -489,6 +485,38 @@ void refresh_cpu_vm_stats(int cpu)
 	}
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		if (global_diff[i])
+			atomic_long_add(global_diff[i], &vm_stat[i]);
+}
+
+/*
+ * Fold the data for an offline cpu into the global array.
+ * There cannot be any access by the offline cpu and therefore
+ * synchronization is simplified.
+ */
+void cpu_vm_stats_fold(int cpu)
+{
+	struct zone *zone;
+	int i;
+	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
+
+	for_each_populated_zone(zone) {
+		struct per_cpu_pageset *p;
+
+		p = per_cpu_ptr(zone->pageset, cpu);
+
+		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+			if (p->vm_stat_diff[i]) {
+				int v;
+
+				v = p->vm_stat_diff[i];
+				p->vm_stat_diff[i] = 0;
+				atomic_long_add(v, &zone->vm_stat[i]);
+				global_diff[i] += v;
+			}
+	}
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		if (global_diff[i])
 			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
vmstat-create-fold_diff.patch
vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch
linux-next.patch

