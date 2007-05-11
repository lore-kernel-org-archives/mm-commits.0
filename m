From: akpm@linux-foundation.org
Subject: - fix-kthread_create-vs-freezer-theoretical-race.patch removed from -mm tree
Date: Fri, 11 May 2007 12:29:07 -0700
Message-ID: <200705111929.l4BJT7aJ024582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759773AbXEKT3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     fix kthread_create() vs freezer theoretical race
has been removed from the -mm tree.  Its filename was
     fix-kthread_create-vs-freezer-theoretical-race.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fix kthread_create() vs freezer theoretical race
From: Oleg Nesterov <oleg@tv-sign.ru>

kthread() sleeps in TASK_INTERRUPTIBLE state waiting for the first wakeup.  In
theory, this wakeup may come from freeze_process()->signal_wake_up(), so the
task can disappear even before kthread_create() sets its ->comm.

Change kthread() to use TASK_UNINTERRUPTIBLE.

[akpm@linux-foundation.org: s/BUG_ON/WARN_ON+recover]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/kthread.c~fix-kthread_create-vs-freezer-theoretical-race kernel/kthread.c
--- a/kernel/kthread.c~fix-kthread_create-vs-freezer-theoretical-race
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
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
