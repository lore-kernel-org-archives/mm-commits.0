From: akpm@linux-foundation.org
Subject: + s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:46:30 -0700
Message-ID: <200806302346.m5UNkUxJ031677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbYF3XrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, heiko.carstens@de.ibm.com, maxk@qualcomm.com, menage@google.com, mingo@elte.hu, peterz@infradead.org, pj@sgi.com, schwidefsky@de.ibm.com, vegard.nossum@gmail.com


The patch titled
     S390 topology: don't use kthread() for arch_reinit_sched_domains()
has been added to the -mm tree.  Its filename is
     s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch

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
Subject: S390 topology: don't use kthread() for arch_reinit_sched_domains()
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that it is safe to use get_online_cpus() we can revert

	[S390] cpu topology: Fix possible deadlock.
	commit: fd781fa25c9e9c6fd1599df060b05e7c4ad724e5

and call arch_reinit_sched_domains() directly from topology_work_fn().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/topology.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN arch/s390/kernel/topology.c~s390-topology-dont-use-kthread-for-arch_reinit_sched_domains arch/s390/kernel/topology.c
--- a/arch/s390/kernel/topology.c~s390-topology-dont-use-kthread-for-arch_reinit_sched_domains
+++ a/arch/s390/kernel/topology.c
@@ -9,7 +9,6 @@
 #include <linux/device.h>
 #include <linux/bootmem.h>
 #include <linux/sched.h>
-#include <linux/kthread.h>
 #include <linux/workqueue.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
@@ -230,20 +229,9 @@ void arch_update_cpu_topology(void)
 	}
 }
 
-static int topology_kthread(void *data)
-{
-	arch_reinit_sched_domains();
-	return 0;
-}
-
 static void topology_work_fn(struct work_struct *work)
 {
-	/* We can't call arch_reinit_sched_domains() from a multi-threaded
-	 * workqueue context since it may deadlock in case of cpu hotplug.
-	 * So we have to create a kernel thread in order to call
-	 * arch_reinit_sched_domains().
-	 */
-	kthread_run(topology_kthread, NULL, "topology_update");
+	arch_reinit_sched_domains();
 }
 
 void topology_schedule_update(void)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
migrate_timers-add-comment-use-spinlock_irq.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

