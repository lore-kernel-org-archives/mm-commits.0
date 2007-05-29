From: akpm@linux-foundation.org
Subject: - freezer-fix-kthread_create-vs-freezer-theoretical-race.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:14 -0700
Message-ID: <200705291850.l4TIoD7R008246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbXE2Sup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, ego@in.ibm.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     freezer: fix kthread_create vs freezer theoretical race
has been removed from the -mm tree.  Its filename was
     freezer-fix-kthread_create-vs-freezer-theoretical-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: fix kthread_create vs freezer theoretical race
From: Oleg Nesterov <oleg@tv-sign.ru>

kthread() sleeps in TASK_INTERRUPTIBLE state waiting for the first wakeup.  In
theory, this wakeup may come from freeze_process()->signal_wake_up(), so the
task can disappear even before kthread_create() sets its ->comm.

Change kthread() to use TASK_UNINTERRUPTIBLE.

[akpm@linux-foundation.org: s/BUG_ON/WARN_ON+recover]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/kthread.c~freezer-fix-kthread_create-vs-freezer-theoretical-race kernel/kthread.c
--- a/kernel/kthread.c~freezer-fix-kthread_create-vs-freezer-theoretical-race
+++ a/kernel/kthread.c
@@ -70,7 +70,7 @@ static int kthread(void *_create)
 	data = create->data;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
-	__set_current_state(TASK_INTERRUPTIBLE);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
 	complete(&create->started);
 	schedule();
 
@@ -162,7 +162,10 @@ EXPORT_SYMBOL(kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	BUG_ON(k->state != TASK_INTERRUPTIBLE);
+	if (k->state != TASK_UNINTERRUPTIBLE) {
+		WARN_ON(1);
+		return;
+	}
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	wait_task_inactive(k);
 	set_task_cpu(k, cpu);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

libata-core-convert-to-use-cancel_rearming_delayed_work.patch
freezer-run-show_state-when-freezing-times-out.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
