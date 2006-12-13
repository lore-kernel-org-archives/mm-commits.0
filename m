From: akpm@osdl.org
Subject: - sched-remove-lb_stopbalance-counter.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:40 -0800
Message-ID: <200612130654.kBD6sejH030564@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57661 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965009AbWLMGyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, mingo@elte.hu, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: remove lb_stopbalance counter
has been removed from the -mm tree.  Its filename was
     sched-remove-lb_stopbalance-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: remove lb_stopbalance counter
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

Remove scheduler stats lb_stopbalance counter.  This counter can be
calculated by: lb_balanced - lb_nobusyg - lb_nobusyq.  There is no need to
create gazillion counters while we can derive the value.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    1 -
 kernel/sched.c        |   11 ++++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~sched-remove-lb_stopbalance-counter include/linux/sched.h
--- a/include/linux/sched.h~sched-remove-lb_stopbalance-counter
+++ a/include/linux/sched.h
@@ -707,7 +707,6 @@ struct sched_domain {
 	unsigned long lb_hot_gained[MAX_IDLE_TYPES];
 	unsigned long lb_nobusyg[MAX_IDLE_TYPES];
 	unsigned long lb_nobusyq[MAX_IDLE_TYPES];
-	unsigned long lb_stopbalance[MAX_IDLE_TYPES];
 
 	/* Active load balancing */
 	unsigned long alb_cnt;
diff -puN kernel/sched.c~sched-remove-lb_stopbalance-counter kernel/sched.c
--- a/kernel/sched.c~sched-remove-lb_stopbalance-counter
+++ a/kernel/sched.c
@@ -428,7 +428,7 @@ static inline void task_rq_unlock(struct
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 13
+#define SCHEDSTAT_VERSION 14
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
@@ -466,7 +466,7 @@ static int show_schedstat(struct seq_fil
 			seq_printf(seq, "domain%d %s", dcnt++, mask_str);
 			for (itype = SCHED_IDLE; itype < MAX_IDLE_TYPES;
 					itype++) {
-				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu",
+				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu",
 				    sd->lb_cnt[itype],
 				    sd->lb_balanced[itype],
 				    sd->lb_failed[itype],
@@ -474,8 +474,7 @@ static int show_schedstat(struct seq_fil
 				    sd->lb_gained[itype],
 				    sd->lb_hot_gained[itype],
 				    sd->lb_nobusyq[itype],
-				    sd->lb_nobusyg[itype],
-				    sd->lb_stopbalance[itype]);
+				    sd->lb_nobusyg[itype]);
 			}
 			seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu\n",
 			    sd->alb_cnt, sd->alb_failed, sd->alb_pushed,
@@ -2596,10 +2595,8 @@ redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
 				   &cpus, balance);
 
-	if (*balance == 0) {
-		schedstat_inc(sd, lb_stopbalance[idle]);
+	if (*balance == 0)
 		goto out_balanced;
-	}
 
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[idle]);
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

