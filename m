From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-make-quiet_vmstat-lighter.patch removed from
 -mm tree
Date: Wed, 10 Feb 2016 11:35:34 -0800
Message-ID: <56bb9106.UyxVYy00PWrVvJCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbcBJTff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, mgalbraith@suse.de, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: make quiet_vmstat lighter
has been removed from the -mm tree.  Its filename was
     mm-vmstat-make-quiet_vmstat-lighter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmstat: make quiet_vmstat lighter

Mike has reported a considerable overhead of refresh_cpu_vm_stats from the
idle entry during pipe test:

    12.89%  [kernel]       [k] refresh_cpu_vm_stats.isra.12
     4.75%  [kernel]       [k] __schedule
     4.70%  [kernel]       [k] mutex_unlock
     3.14%  [kernel]       [k] __switch_to

This is caused by 0eb77e988032 ("vmstat: make vmstat_updater deferrable
again and shut down on idle") which has placed quiet_vmstat into
cpu_idle_loop.  The main reason here seems to be that the idle entry has
to get over all zones and perform atomic operations for each vmstat entry
even though there might be no per cpu diffs.  This is a pointless overhead
for _each_ idle entry.

Make sure that quiet_vmstat is as light as possible.

First of all it doesn't make any sense to do any local sync if the current
cpu is already set in oncpu_stat_off because vmstat_update puts itself
there only if there is nothing to do.

Then we can check need_update which should be a cheap way to check for
potential per-cpu diffs and only then do refresh_cpu_vm_stats.

The original patch also did cancel_delayed_work which we are not doing
here.  There are two reasons for that.  Firstly cancel_delayed_work from
idle context will blow up on RT kernels (reported by Mike):

[    2.279582] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.5.0-rt3 #7
[    2.280444] Hardware name: MEDION MS-7848/MS-7848, BIOS M7848W08.20C 09/23/2013
[    2.281316]  ffff88040b00d640 ffff88040b01fe10 ffffffff812d20e2 0000000000000000
[    2.282202]  ffff88040b01fe30 ffffffff81081095 ffff88041ec4cee0 ffff88041ec501e0
[    2.283073]  ffff88040b01fe48 ffffffff815ff910 ffff88041ec4cee0 ffff88040b01fe88
[    2.283941] Call Trace:
[    2.284797]  [<ffffffff812d20e2>] dump_stack+0x49/0x67
[    2.285658]  [<ffffffff81081095>] ___might_sleep+0xf5/0x180
[    2.286521]  [<ffffffff815ff910>] rt_spin_lock+0x20/0x50
[    2.287382]  [<ffffffff81075919>] try_to_grab_pending+0x69/0x240
[    2.288239]  [<ffffffff81075b16>] cancel_delayed_work+0x26/0xe0
[    2.289094]  [<ffffffff8115ec05>] quiet_vmstat+0x75/0xa0
[    2.289949]  [<ffffffff8109ab38>] cpu_idle_loop+0x38/0x3e0
[    2.290800]  [<ffffffff8109aef3>] cpu_startup_entry+0x13/0x20
[    2.291647]  [<ffffffff81036164>] start_secondary+0x114/0x140

And secondly, even on !RT kernels it might add some non trivial overhead
which is not necessary.  Even if the vmstat worker wakes up and preempts
idle then it will be most likely a single shot noop because the stats were
already synced and so it would end up on the oncpu_stat_off anyway.  We
just need to teach both vmstat_shepherd and vmstat_update to stop
scheduling the worker if there is nothing to do.

[mgalbraith@suse.de: cancel pending work of the cpu_stat_off CPU]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   68 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-make-quiet_vmstat-lighter mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-make-quiet_vmstat-lighter
+++ a/mm/vmstat.c
@@ -1396,10 +1396,15 @@ static void vmstat_update(struct work_st
 		 * Counters were updated so we expect more updates
 		 * to occur in the future. Keep on running the
 		 * update worker thread.
+		 * If we were marked on cpu_stat_off clear the flag
+		 * so that vmstat_shepherd doesn't schedule us again.
 		 */
-		queue_delayed_work_on(smp_processor_id(), vmstat_wq,
-			this_cpu_ptr(&vmstat_work),
-			round_jiffies_relative(sysctl_stat_interval));
+		if (!cpumask_test_and_clear_cpu(smp_processor_id(),
+						cpu_stat_off)) {
+			queue_delayed_work_on(smp_processor_id(), vmstat_wq,
+				this_cpu_ptr(&vmstat_work),
+				round_jiffies_relative(sysctl_stat_interval));
+		}
 	} else {
 		/*
 		 * We did not update any counters so the app may be in
@@ -1417,18 +1422,6 @@ static void vmstat_update(struct work_st
  * until the diffs stay at zero. The function is used by NOHZ and can only be
  * invoked when tick processing is not active.
  */
-void quiet_vmstat(void)
-{
-	if (system_state != SYSTEM_RUNNING)
-		return;
-
-	do {
-		if (!cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
-			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
-
-	} while (refresh_cpu_vm_stats(false));
-}
-
 /*
  * Check if the diffs for a certain cpu indicate that
  * an update is needed.
@@ -1452,6 +1445,30 @@ static bool need_update(int cpu)
 	return false;
 }
 
+void quiet_vmstat(void)
+{
+	if (system_state != SYSTEM_RUNNING)
+		return;
+
+	/*
+	 * If we are already in hands of the shepherd then there
+	 * is nothing for us to do here.
+	 */
+	if (cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
+		return;
+
+	if (!need_update(smp_processor_id()))
+		return;
+
+	/*
+	 * Just refresh counters and do not care about the pending delayed
+	 * vmstat_update. It doesn't fire that often to matter and canceling
+	 * it would be too expensive from this path.
+	 * vmstat_shepherd will take care about that for us.
+	 */
+	refresh_cpu_vm_stats(false);
+}
+
 
 /*
  * Shepherd worker thread that checks the
@@ -1469,18 +1486,25 @@ static void vmstat_shepherd(struct work_
 
 	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
-	for_each_cpu(cpu, cpu_stat_off)
-		if (need_update(cpu) &&
-			cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
-
-			queue_delayed_work_on(cpu, vmstat_wq,
-				&per_cpu(vmstat_work, cpu), 0);
+	for_each_cpu(cpu, cpu_stat_off) {
+		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
+		if (need_update(cpu)) {
+			if (cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
+				queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
+		} else {
+			/*
+			 * Cancel the work if quiet_vmstat has put this
+			 * cpu on cpu_stat_off because the work item might
+			 * be still scheduled
+			 */
+			cancel_delayed_work(dw);
+		}
+	}
 	put_online_cpus();
 
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
