From: akpm@linux-foundation.org
Subject: + freezer-fix-kthread_create-vs-freezer-theoretical-race.patch added to -mm tree
Date: Fri, 11 May 2007 12:42:35 -0700
Message-ID: <200705111942.l4BJgZQQ024849@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933647AbXEKTnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, ego@in.ibm.com, rjw@sisk.pl


The patch titled
     freezer: fix kthread_create vs freezer theoretical race
has been added to the -mm tree.  Its filename is
     freezer-fix-kthread_create-vs-freezer-theoretical-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
