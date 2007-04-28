From: akpm@linux-foundation.org
Subject: + remvoe-kthread_bind-call-from-_cpu_down.patch added to -mm tree
Date: Fri, 27 Apr 2007 18:43:02 -0700
Message-ID: <200704280143.l3S1h2fF012729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030862AbXD1BnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, rjw@sisk.pl


The patch titled
     Remvoe kthread_bind() call from _cpu_down()
has been added to the -mm tree.  Its filename is
     remvoe-kthread_bind-call-from-_cpu_down.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remvoe kthread_bind() call from _cpu_down()
From: Gautham R Shenoy <ego@in.ibm.com>

We are anyway kthread_stop()ping other per-cpu kernel threads after
move_task_off_dead_cpu(), so we can do it with the stop_machine_run thread
as well.

I just checked with Vatsa if there was any subtle reason why they
had put in the kthread_bind() in cpu.c. Vatsa cannot seem to recollect
any and I can't see any. So let us just remove the kthread_bind.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN kernel/cpu.c~remvoe-kthread_bind-call-from-_cpu_down kernel/cpu.c
--- a/kernel/cpu.c~remvoe-kthread_bind-call-from-_cpu_down
+++ a/kernel/cpu.c
@@ -175,10 +175,6 @@ static int _cpu_down(unsigned int cpu)
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
 
-	/* Move it here so it can run. */
-	kthread_bind(p, get_cpu());
-	put_cpu();
-
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
 	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD, hcpu) == NOTIFY_BAD)
 		BUG();
_

Patches currently in -mm which might be from ego@in.ibm.com are

i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
