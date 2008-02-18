From: akpm@linux-foundation.org
Subject: + workqueues-shrink-cpu_populated_map-when-cpu-dies.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:17:41 -0800
Message-ID: <200802181018.m1IAIdAq019900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566AbYBRKTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     workqueues: shrink cpu_populated_map when CPU dies
has been added to the -mm tree.  Its filename is
     workqueues-shrink-cpu_populated_map-when-cpu-dies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: shrink cpu_populated_map when CPU dies
From: Oleg Nesterov <oleg@tv-sign.ru>

When cpu_populated_map was introduced, it was supposed that cwq->thread can
survive after CPU_DEAD, that is why we never shrink cpu_populated_map.

This is not very nice, we can safely remove the already dead CPU from the map.
 The only required change is that destroy_workqueue() must hold the hotplug
lock until it destroys all cwq->thread's, to protect the cpu_populated_map. 
We could make the local copy of cpu mask and drop the lock, but
sizeof(cpumask_t) may be very large.

Also, fix the comment near queue_work().  Unless _cpu_down() happens we do
guarantee the cpu-affinity of the work_struct, and we have users which rely on
this.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~workqueues-shrink-cpu_populated_map-when-cpu-dies kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-shrink-cpu_populated_map-when-cpu-dies
+++ a/kernel/workqueue.c
@@ -158,8 +158,8 @@ static void __queue_work(struct cpu_work
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
- * We queue the work to the CPU it was submitted, but there is no
- * guarantee that it will be processed by that CPU.
+ * We queue the work to the CPU it was submitted, but if CPU dies
+ * it can be processed by another CPU.
  */
 int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
@@ -813,12 +813,12 @@ void destroy_workqueue(struct workqueue_
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
-	put_online_cpus();
 
 	for_each_cpu_mask(cpu, *cpu_map) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
+	put_online_cpus();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -836,7 +836,6 @@ static int __devinit workqueue_cpu_callb
 	action &= ~CPU_TASKS_FROZEN;
 
 	switch (action) {
-
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
@@ -864,6 +863,12 @@ static int __devinit workqueue_cpu_callb
 		}
 	}
 
+	switch (action) {
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		cpu_clear(cpu, cpu_populated_map);
+	}
+
 	return NOTIFY_OK;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
