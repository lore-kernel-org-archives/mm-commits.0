From: akpm@linux-foundation.org
Subject: +
 vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch added to -mm tree
Date: Wed, 07 Aug 2013 13:43:10 -0700
Message-ID: <5202b15e.fSoukSr00b8ZvJOT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3HGUnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, js1304@gmail.com, adobriyan@gmail.com, cl@linux.com

Subject: + vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch added to -mm tree
To: cl@linux.com,adobriyan@gmail.com,js1304@gmail.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:43:10 -0700


The patch titled
     Subject: vmstat: use this_cpu() to avoid irqon/off sequence in refresh_cpu_vm_stats
has been added to the -mm tree.  Its filename is
     vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch

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
Subject: vmstat: use this_cpu() to avoid irqon/off sequence in refresh_cpu_vm_stats

Disabling interrupts repeatedly can be avoided in the inner loop if we use
a this_cpu operation.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff -puN mm/vmstat.c~vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats mm/vmstat.c
--- a/mm/vmstat.c~vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats
+++ a/mm/vmstat.c
@@ -437,33 +437,29 @@ static inline void fold_diff(int *diff)
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
  */
-static void refresh_cpu_vm_stats(int cpu)
+static void refresh_cpu_vm_stats(void)
 {
 	struct zone *zone;
 	int i;
 	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 
 	for_each_populated_zone(zone) {
-		struct per_cpu_pageset *p;
+		struct per_cpu_pageset __percpu *p = zone->pageset;
 
-		p = per_cpu_ptr(zone->pageset, cpu);
+		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
+			int v;
 
-		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-			if (p->vm_stat_diff[i]) {
-				unsigned long flags;
-				int v;
+			v = this_cpu_xchg(p->vm_stat_diff[i], 0);
+			if (v) {
 
-				local_irq_save(flags);
-				v = p->vm_stat_diff[i];
-				p->vm_stat_diff[i] = 0;
-				local_irq_restore(flags);
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
-				p->expire = 3;
+				__this_cpu_write(p->expire, 3);
 #endif
 			}
+		}
 		cond_resched();
 #ifdef CONFIG_NUMA
 		/*
@@ -473,23 +469,24 @@ static void refresh_cpu_vm_stats(int cpu
 		 * Check if there are pages remaining in this pageset
 		 * if not then there is nothing to expire.
 		 */
-		if (!p->expire || !p->pcp.count)
+		if (!__this_cpu_read(p->expire) ||
+			       !__this_cpu_read(p->pcp.count))
 			continue;
 
 		/*
 		 * We never drain zones local to this processor.
 		 */
 		if (zone_to_nid(zone) == numa_node_id()) {
-			p->expire = 0;
+			__this_cpu_write(p->expire, 0);
 			continue;
 		}
 
-		p->expire--;
-		if (p->expire)
+
+		if (__this_cpu_dec_return(p->expire))
 			continue;
 
-		if (p->pcp.count)
-			drain_zone_pages(zone, &p->pcp);
+		if (__this_cpu_read(p->pcp.count))
+			drain_zone_pages(zone, __this_cpu_ptr(&p->pcp));
 #endif
 	}
 	fold_diff(global_diff);
@@ -1215,7 +1212,7 @@ int sysctl_stat_interval __read_mostly =
 
 static void vmstat_update(struct work_struct *w)
 {
-	refresh_cpu_vm_stats(smp_processor_id());
+	refresh_cpu_vm_stats();
 	schedule_delayed_work(&__get_cpu_var(vmstat_work),
 		round_jiffies_relative(sysctl_stat_interval));
 }
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
vmstat-create-fold_diff.patch
vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch
linux-next.patch

