From: akpm@linux-foundation.org
Subject: - remvoe-kthread_bind-call-from-_cpu_down.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:39 -0700
Message-ID: <200705092152.l49LqdBf003020@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759385AbXEIVxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Remove kthread_bind() call from _cpu_down()
has been removed from the -mm tree.  Its filename was
     remvoe-kthread_bind-call-from-_cpu_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove kthread_bind() call from _cpu_down()
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
 1 file changed, 4 deletions(-)

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

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
