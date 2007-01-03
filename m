From: akpm@osdl.org
Subject: + fix-flush_workqueue-vs-cpu_dead-race.patch added to -mm tree
Date: Tue, 02 Jan 2007 16:26:26 -0800
Message-ID: <200701030026.l030QQjf002534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXACA0k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com


The patch titled
     fix flush_workqueue() vs CPU_DEAD race
has been added to the -mm tree.  Its filename is
     fix-flush_workqueue-vs-cpu_dead-race.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix flush_workqueue() vs CPU_DEAD race
From: Oleg Nesterov <oleg@tv-sign.ru>

"[PATCH 1/2] reimplement flush_workqueue()" fixed one race when CPU goes
down while flush_cpu_workqueue() plays with it.  But there is another
problem, CPU can die before flush_workqueue() has a chance to call
flush_cpu_workqueue().  In that case pending work_structs can migrate to
CPU which was already checked, so we should redo the
"for_each_online_cpu(cpu)" loop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN kernel/workqueue.c~fix-flush_workqueue-vs-cpu_dead-race kernel/workqueue.c
--- a/kernel/workqueue.c~fix-flush_workqueue-vs-cpu_dead-race
+++ a/kernel/workqueue.c
@@ -65,6 +65,7 @@ struct workqueue_struct {
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
+static long hotplug_sequence __read_mostly;
 static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
@@ -454,10 +455,16 @@ void fastcall flush_workqueue(struct wor
 		/* Always use first cpu's area. */
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
 	} else {
+		long sequence;
 		int cpu;
+again:
+		sequence = hotplug_sequence;
 
 		for_each_online_cpu(cpu)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+
+		if (unlikely(sequence != hotplug_sequence))
+			goto again;
 	}
 	mutex_unlock(&workqueue_mutex);
 }
@@ -880,6 +887,7 @@ static int __devinit workqueue_cpu_callb
 			cleanup_workqueue_thread(wq, hotcpu);
 		list_for_each_entry(wq, &workqueues, list)
 			take_over_work(wq, hotcpu);
+		hotplug_sequence++;
 		break;
 
 	case CPU_LOCK_RELEASE:
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
fix-flush_workqueue-vs-cpu_dead-race.patch
