From: akpm@linux-foundation.org
Subject: + cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:17:51 -0800
Message-ID: <200802181018.m1IAInk2019912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757485AbYBRKTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     cleanup_workqueue_thread: remove the unneeded "cpu" parameter
has been added to the -mm tree.  Its filename is
     cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch

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
Subject: cleanup_workqueue_thread: remove the unneeded "cpu" parameter
From: Oleg Nesterov <oleg@tv-sign.ru>

cleanup_workqueue_thread() doesn't need the second argument, remove it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/workqueue.c~cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter kernel/workqueue.c
--- a/kernel/workqueue.c~cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter
+++ a/kernel/workqueue.c
@@ -770,7 +770,7 @@ struct workqueue_struct *__create_workqu
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
 	 * Our caller is either destroy_workqueue() or CPU_DEAD,
@@ -806,7 +806,6 @@ static void cleanup_workqueue_thread(str
 void destroy_workqueue(struct workqueue_struct *wq)
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
-	struct cpu_workqueue_struct *cwq;
 	int cpu;
 
 	get_online_cpus();
@@ -814,10 +813,8 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask(cpu, *cpu_map) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-		cleanup_workqueue_thread(cwq, cpu);
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
 	put_online_cpus();
 
 	free_percpu(wq->cpu_wq);
@@ -858,7 +855,7 @@ static int __devinit workqueue_cpu_callb
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
-			cleanup_workqueue_thread(cwq, cpu);
+			cleanup_workqueue_thread(cwq);
 			break;
 		}
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
