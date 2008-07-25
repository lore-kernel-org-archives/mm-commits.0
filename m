From: akpm@linux-foundation.org
Subject: - s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:20 -0700
Message-ID: <200807252300.m6PN0KXK003576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935AbYGYXJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, heiko.carstens@de.ibm.com, maxk@qualcomm.com, menage@google.com, mingo@elte.hu, peterz@infradead.org, pj@sgi.com, schwidefsky@de.ibm.com, vegard.nossu


The patch titled
     S390 topology: don't use kthread() for arch_reinit_sched_domains()
has been removed from the -mm tree.  Its filename was
     s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

