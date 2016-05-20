From: akpm@linux-foundation.org
Subject: [patch 040/162] vmstat: get rid of the ugly cpu_stat_off variable
Date: Fri, 20 May 2016 16:58:21 -0700
Message-ID: <573fa49d.mHLgvto41kLS+q4v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcETX6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com, htejun@gmail.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp

From: Christoph Lameter <cl@linux.com>
Subject: vmstat: get rid of the ugly cpu_stat_off variable

The cpu_stat_off variable is unecessary since we can check if a workqueue
request is pending otherwise.  Removal of cpu_stat_off makes it pretty
easy for the vmstat shepherd to ensure that the proper things happen.

Removing the state also removes all races related to it.  Should a
workqueue not be scheduled as needed for vmstat_update then the shepherd
will notice and schedule it as needed.  Should a workqueue be unecessarily
scheduled then the vmstat updater will disable it.

[akpm@linux-foundation.org: fix indentation, per Michal]
Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1605061306460.17934@east.gentwo.org
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   51 +++++++++-----------------------------------------
 1 file changed, 10 insertions(+), 41 deletions(-)

diff -puN mm/vmstat.c~vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2 mm/vmstat.c
--- a/mm/vmstat.c~vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2
+++ a/mm/vmstat.c
@@ -1352,7 +1352,6 @@ static const struct file_operations proc
 static struct workqueue_struct *vmstat_wq;
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
-static cpumask_var_t cpu_stat_off;
 
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
@@ -1421,24 +1420,10 @@ static void vmstat_update(struct work_st
 		 * Counters were updated so we expect more updates
 		 * to occur in the future. Keep on running the
 		 * update worker thread.
-		 * If we were marked on cpu_stat_off clear the flag
-		 * so that vmstat_shepherd doesn't schedule us again.
 		 */
-		if (!cpumask_test_and_clear_cpu(smp_processor_id(),
-						cpu_stat_off)) {
-			queue_delayed_work_on(smp_processor_id(), vmstat_wq,
+		queue_delayed_work_on(smp_processor_id(), vmstat_wq,
 				this_cpu_ptr(&vmstat_work),
 				round_jiffies_relative(sysctl_stat_interval));
-		}
-	} else {
-		/*
-		 * We did not update any counters so the app may be in
-		 * a mode where it does not cause counter updates.
-		 * We may be uselessly running vmstat_update.
-		 * Defer the checking for differentials to the
-		 * shepherd thread on a different processor.
-		 */
-		cpumask_set_cpu(smp_processor_id(), cpu_stat_off);
 	}
 }
 
@@ -1470,16 +1455,17 @@ static bool need_update(int cpu)
 	return false;
 }
 
+/*
+ * Switch off vmstat processing and then fold all the remaining differentials
+ * until the diffs stay at zero. The function is used by NOHZ and can only be
+ * invoked when tick processing is not active.
+ */
 void quiet_vmstat(void)
 {
 	if (system_state != SYSTEM_RUNNING)
 		return;
 
-	/*
-	 * If we are already in hands of the shepherd then there
-	 * is nothing for us to do here.
-	 */
-	if (cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
+	if (!delayed_work_pending(this_cpu_ptr(&vmstat_work)))
 		return;
 
 	if (!need_update(smp_processor_id()))
@@ -1494,7 +1480,6 @@ void quiet_vmstat(void)
 	refresh_cpu_vm_stats(false);
 }
 
-
 /*
  * Shepherd worker thread that checks the
  * differentials of processors that have their worker
@@ -1511,20 +1496,11 @@ static void vmstat_shepherd(struct work_
 
 	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
-	for_each_cpu(cpu, cpu_stat_off) {
+	for_each_online_cpu(cpu) {
 		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
-		if (need_update(cpu)) {
-			if (cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
-				queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
-		} else {
-			/*
-			 * Cancel the work if quiet_vmstat has put this
-			 * cpu on cpu_stat_off because the work item might
-			 * be still scheduled
-			 */
-			cancel_delayed_work(dw);
-		}
+		if (!delayed_work_pending(dw) && need_update(cpu))
+			queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
 	}
 	put_online_cpus();
 
@@ -1540,10 +1516,6 @@ static void __init start_shepherd_timer(
 		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
-	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
-		BUG();
-	cpumask_copy(cpu_stat_off, cpu_online_mask);
