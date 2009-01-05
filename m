From: akpm@linux-foundation.org
Subject: - workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch removed from -mm tree
Date: Mon, 05 Jan 2009 12:12:02 -0800
Message-ID: <200901052012.n05KC3e2013332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbZAEUMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 15:12:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     workqueues: kill cpu_singlethread_map, use get_cpu_mask() instead
has been removed from the -mm tree.  Its filename was
     workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: kill cpu_singlethread_map, use get_cpu_mask() instead
From: Oleg Nesterov <oleg@redhat.com>

Now that we have cpu_bit_bitmap[] we don't need cpu_singlethread_map, we
can use get_cpu_mask(singlethread_cpu) directly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead
+++ a/kernel/workqueue.c
@@ -73,7 +73,6 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static const struct cpumask *cpu_singlethread_map __read_mostly;
 /*
  * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
  * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
@@ -92,7 +91,7 @@ static inline int is_wq_single_threaded(
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_wq_single_threaded(wq)
-		? cpu_singlethread_map : cpu_populated_map;
+		 ? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
 }
 
 static
@@ -1021,7 +1020,6 @@ void __init init_workqueues(void)
 
 	cpumask_copy(cpu_populated_map, cpu_online_mask);
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
-	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
forkc-cleanup-for-copy_sighand.patch
poll-allow-f_op-poll-to-sleep-take6.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch
pid-implement-ns_of_pid.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

