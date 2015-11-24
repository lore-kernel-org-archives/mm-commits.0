From: akpm@linux-foundation.org
Subject: +
 mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch added to -mm tree
Date: Tue, 24 Nov 2015 15:46:32 -0800
Message-ID: <5654f6d8.5MhmscVU9hWSgSXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbbKXXqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 18:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arekm@maven.pl, clameter@sgi.com, js1304@gmail.com, penguin-kernel@I-love.SAKURA.ne.jp, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: allow WQ concurrency to discover memory reclaim doesn't make any progress
has been added to the -mm tree.  Its filename is
     mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmstat: allow WQ concurrency to discover memory reclaim doesn't make any progress

Tetsuo Handa has reported that the system might basically livelock in OOM
condition without triggering the OOM killer.  The issue is caused by
internal dependency of the direct reclaim on vmstat counter updates (via
zone_reclaimable) which are performed from the workqueue context.  If all
the current workers get assigned to an allocation request, though, they
will be looping inside the allocator trying to reclaim memory but
zone_reclaimable can see stalled numbers so it will consider a zone
reclaimable even though it has been scanned way too much.  WQ concurrency
logic will not consider this situation as a congested workqueue because it
relies that worker would have to sleep in such a situation.  This also
means that it doesn't try to spawn new workers or invoke the rescuer
thread if the one is assigned to the queue.

In order to fix this issue we need to do two things.  First we have to let
wq concurrency code know that we are in trouble so we have to do a short
sleep.  In order to prevent from issues handled by 0e093d99763e
("writeback: do not sleep on the congestion queue if there are no
congested BDIs or if significant congestion is not being encountered in
the current zone") we limit the sleep only to worker threads which are the
ones of the interest anyway.

The second thing to do is to create a dedicated workqueue for vmstat and
mark it WQ_MEM_RECLAIM to note it participates in the reclaim and to have
a spare worker thread for it.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tejun Heo <tj@kernel.org>
Cc: Cristopher Lameter <clameter@sgi.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   19 ++++++++++++++++---
 mm/vmstat.c      |    6 ++++--
 2 files changed, 20 insertions(+), 5 deletions(-)

diff -puN mm/backing-dev.c~mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress mm/backing-dev.c
--- a/mm/backing-dev.c~mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress
+++ a/mm/backing-dev.c
@@ -957,8 +957,9 @@ EXPORT_SYMBOL(congestion_wait);
  * jiffies for either a BDI to exit congestion of the given @sync queue
  * or a write to complete.
  *
- * In the absence of zone congestion, cond_resched() is called to yield
- * the processor if necessary but otherwise does not sleep.
+ * In the absence of zone congestion, a short sleep or a cond_resched is
+ * performed to yield the processor and to allow other subsystems to make
+ * a forward progress.
  *
  * The return value is 0 if the sleep is for the full timeout. Otherwise,
  * it is the number of jiffies that were still remaining when the function
@@ -978,7 +979,19 @@ long wait_iff_congested(struct zone *zon
 	 */
 	if (atomic_read(&nr_wb_congested[sync]) == 0 ||
 	    !test_bit(ZONE_CONGESTED, &zone->flags)) {
-		cond_resched();
+
+		/*
+		 * Memory allocation/reclaim might be called from a WQ
+		 * context and the current implementation of the WQ
+		 * concurrency control doesn't recognize that a particular
+		 * WQ is congested if the worker thread is looping without
+		 * ever sleeping. Therefore we have to do a short sleep
+		 * here rather than calling cond_resched().
+		 */
+		if (current->flags & PF_WQ_WORKER)
+			schedule_timeout(1);
+		else
+			cond_resched();
 
 		/* In case we scheduled, work out time remaining */
 		ret = timeout - (jiffies - start);
diff -puN mm/vmstat.c~mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress
+++ a/mm/vmstat.c
@@ -1379,6 +1379,7 @@ static const struct file_operations proc
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
+static struct workqueue_struct *vmstat_wq;
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
 static cpumask_var_t cpu_stat_off;
@@ -1391,7 +1392,7 @@ static void vmstat_update(struct work_st
 		 * to occur in the future. Keep on running the
 		 * update worker thread.
 		 */
-		schedule_delayed_work_on(smp_processor_id(),
+		queue_delayed_work_on(smp_processor_id(), vmstat_wq,
 			this_cpu_ptr(&vmstat_work),
 			round_jiffies_relative(sysctl_stat_interval));
 	} else {
@@ -1460,7 +1461,7 @@ static void vmstat_shepherd(struct work_
 		if (need_update(cpu) &&
 			cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
 
-			schedule_delayed_work_on(cpu,
+			queue_delayed_work_on(cpu, vmstat_wq,
 				&per_cpu(vmstat_work, cpu), 0);
 
 	put_online_cpus();
@@ -1549,6 +1550,7 @@ static int __init setup_vmstat(void)
 
 	start_shepherd_timer();
 	cpu_notifier_register_done();
+	vmstat_wq = alloc_workqueue("vmstat", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch

