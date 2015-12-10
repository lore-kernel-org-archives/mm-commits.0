From: akpm@linux-foundation.org
Subject: +
 vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch
 added to -mm tree
Date: Thu, 10 Dec 2015 15:31:26 -0800
Message-ID: <566a0b4e.0G46D9QvzIpW9ZuC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbLJXb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 18:31:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, hannes@cmpxchg.org, mhocko@suse.cz, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: make vmstat_updater deferrable again and shut down on idle
has been added to the -mm tree.  Its filename is
     vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch

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
Subject: vmstat: make vmstat_updater deferrable again and shut down on idle

Currently the vmstat updater is not deferrable as a result of ba4877b9ca51
("vmstat: do not use deferrable delayed work for vmstat_update").  This in
turn can cause multiple interruptions of the applications because the
vmstat updater may run at

Make vmstate_update deferrable again and provide a function that folds the
differentials when the processor is going to idle mode thus addressing the
issue of the above commit in a clean way.

Note that the shepherd thread will continue scanning the differentials
from another processor and will reenable the vmstat workers if it detects
any changes.

Fixes: ba4877b9ca51 ("vmstat: do not use deferrable delayed work for vmstat_update")
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +
 kernel/sched/idle.c    |    1 
 mm/vmstat.c            |   66 ++++++++++++++++++++++++---------------
 3 files changed, 44 insertions(+), 25 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle
+++ a/include/linux/vmstat.h
@@ -189,6 +189,7 @@ extern void __inc_zone_state(struct zone
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
+void quiet_vmstat(void);
 void cpu_vm_stats_fold(int cpu);
 void refresh_zone_stat_thresholds(void);
 
@@ -249,6 +250,7 @@ static inline void __dec_zone_page_state
 
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
+static inline void quiet_vmstat(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_pageset *pset) { }
diff -puN kernel/sched/idle.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle kernel/sched/idle.c
--- a/kernel/sched/idle.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle
+++ a/kernel/sched/idle.c
@@ -219,6 +219,7 @@ static void cpu_idle_loop(void)
 		 */
 
 		__current_set_polling();
+		quiet_vmstat();
 		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
diff -puN mm/vmstat.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle mm/vmstat.c
--- a/mm/vmstat.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle
+++ a/mm/vmstat.c
@@ -460,7 +460,7 @@ static int fold_diff(int *diff)
  *
  * The function returns the number of global counters updated.
  */
-static int refresh_cpu_vm_stats(void)
+static int refresh_cpu_vm_stats(bool do_pagesets)
 {
 	struct zone *zone;
 	int i;
@@ -484,33 +484,35 @@ static int refresh_cpu_vm_stats(void)
 #endif
 			}
 		}
-		cond_resched();
 #ifdef CONFIG_NUMA
-		/*
-		 * Deal with draining the remote pageset of this
-		 * processor
-		 *
-		 * Check if there are pages remaining in this pageset
-		 * if not then there is nothing to expire.
-		 */
-		if (!__this_cpu_read(p->expire) ||
+		if (do_pagesets) {
+			cond_resched();
+			/*
+			 * Deal with draining the remote pageset of this
+			 * processor
+			 *
+			 * Check if there are pages remaining in this pageset
+			 * if not then there is nothing to expire.
+			 */
+			if (!__this_cpu_read(p->expire) ||
 			       !__this_cpu_read(p->pcp.count))
-			continue;
+				continue;
 
-		/*
-		 * We never drain zones local to this processor.
-		 */
-		if (zone_to_nid(zone) == numa_node_id()) {
-			__this_cpu_write(p->expire, 0);
-			continue;
-		}
+			/*
+			 * We never drain zones local to this processor.
+			 */
+			if (zone_to_nid(zone) == numa_node_id()) {
+				__this_cpu_write(p->expire, 0);
+				continue;
+			}
 
-		if (__this_cpu_dec_return(p->expire))
-			continue;
+			if (__this_cpu_dec_return(p->expire))
+				continue;
 
-		if (__this_cpu_read(p->pcp.count)) {
-			drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
-			changes++;
+			if (__this_cpu_read(p->pcp.count)) {
+				drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
+				changes++;
+			}
 		}
 #endif
 	}
@@ -1386,7 +1388,7 @@ static cpumask_var_t cpu_stat_off;
 
 static void vmstat_update(struct work_struct *w)
 {
-	if (refresh_cpu_vm_stats()) {
+	if (refresh_cpu_vm_stats(true)) {
 		/*
 		 * Counters were updated so we expect more updates
 		 * to occur in the future. Keep on running the
@@ -1418,6 +1420,20 @@ static void vmstat_update(struct work_st
 }
 
 /*
+ * Switch off vmstat processing and then fold all the remaining differentials
+ * until the diffs stay at zero. The function is used by NOHZ and can only be
+ * invoked when tick processing is not active.
+ */
+void quiet_vmstat(void)
+{
+	do {
+		if (!cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
+			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
+
+	} while (refresh_cpu_vm_stats(false));
+}
+
+/*
  * Check if the diffs for a certain cpu indicate that
  * an update is needed.
  */
@@ -1449,7 +1465,7 @@ static bool need_update(int cpu)
  */
 static void vmstat_shepherd(struct work_struct *w);
 
-static DECLARE_DELAYED_WORK(shepherd, vmstat_shepherd);
+static DECLARE_DEFERRABLE_WORK(shepherd, vmstat_shepherd);
 
 static void vmstat_shepherd(struct work_struct *w)
 {
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch

