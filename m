From: akpm@linux-foundation.org
Subject: - timer-cleanups.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:55 -0800
Message-ID: <200712010023.lB10NtoG032020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758095AbXLAA22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, johnstul@us.ibm.com, mingo@elte.hu, pavel@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: timer cleanups
has been removed from the -mm tree.  Its filename was
     timer-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: time: timer cleanups
From: Pavel Machek <pavel@ucw.cz>

Small cleanups to tick-related code. Wrong preempt count is followed
by BUG(), so it is hardly KERN_WARNING.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    4 ++--
 kernel/timer.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/tick-sched.c~timer-cleanups kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~timer-cleanups
+++ a/kernel/time/tick-sched.c
@@ -289,7 +289,7 @@ void tick_nohz_stop_sched_tick(void)
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
 				goto out;
-		} else if(!tick_program_event(expires, 0))
+		} else if (!tick_program_event(expires, 0))
 				goto out;
 		/*
 		 * We are past the event already. So we crossed a
@@ -500,7 +500,7 @@ static inline void tick_nohz_switch_to_n
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
- * We rearm the timer until we get disabled by the idle code
+ * We rearm the timer until we get disabled by the idle code.
  * Called with interrupts disabled and timer->base->cpu_base->lock held.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
diff -puN kernel/timer.c~timer-cleanups kernel/timer.c
--- a/kernel/timer.c~timer-cleanups
+++ a/kernel/timer.c
@@ -655,7 +655,7 @@ static inline void __run_timers(struct t
 				int preempt_count = preempt_count();
 				fn(data);
 				if (preempt_count != preempt_count()) {
-					printk(KERN_WARNING "huh, entered %p "
+					printk(KERN_ERR "huh, entered %p "
 					       "with preempt_count %08x, exited"
 					       " with %08x?\n",
 					       fn, preempt_count,
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-x86.patch
fix-proc-net-breakage.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
