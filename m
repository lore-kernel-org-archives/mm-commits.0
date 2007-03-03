From: akpm@linux-foundation.org
Subject: + dynticks-dont-unlock-spinlock-twice.patch added to -mm tree
Date: Fri, 02 Mar 2007 19:05:59 -0800
Message-ID: <200703030305.l2335xnI026717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52171 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992954AbXCCDGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 22:06:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     dynticks: don't unlock spinlock twice
has been added to the -mm tree.  Its filename is
     dynticks-dont-unlock-spinlock-twice.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dynticks: don't unlock spinlock twice
From: Andres Salomon <dilinger@debian.org>

During boot with dynticks enabled, we would sometimes get:

[   35.271900] Switched to high resolution mode on CPU 0
[   35.304468] BUG: spinlock already unlocked on CPU#0, swapper/1
[   35.338099]  lock: c06428a0, .magic: dead4ead, .owner: <none>/-1,
.owner_cpu:
 -1
[   35.373597]  [<c04d7cf0>] _raw_spin_unlock+0x28/0x67
[   35.406647]  [<c05ba279>] _spin_unlock+0x5/0x23
[   35.439369]  [<c04255f7>] tick_sched_timer+0x4e/0xa7
[   35.472388]  [<c04255a9>] tick_sched_timer+0x0/0xa7
[   35.504833]  [<c0422528>] hrtimer_run_queues+0x199/0x1ec
[   35.537617]  [<c0416b72>] run_timer_softirq+0x12/0x166
[   35.570019]  [<c04144d9>] __do_softirq+0x40/0x85

[   35.601542]  [<c0405494>] do_softirq+0x53/0xa9
...

This appears to be caused by run_hrtimer_queue() (called by
hrtimer_run_queues) calling spin_unlock_irq(&cpu_base->lock) before calling
timer->function(timer).  The callback function (tick_sched_timer) expects
cpu_base->lock to be held when it is called, and attempts to unlock it. 
Since it doesn't seem like anything within tick_sched_timer really needs to
hold the lock (afaict), the attached patch simply removes the lock handling
from tick_sched_timer.  Things called by tick_sched_timer may grab the
base->lock, but that's fine (and their responsibility).  Let me know if
there's some reason why the lock should be held, and I can rework this.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/time/tick-sched.c~dynticks-dont-unlock-spinlock-twice kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~dynticks-dont-unlock-spinlock-twice
+++ a/kernel/time/tick-sched.c
@@ -422,13 +422,12 @@ static inline void tick_nohz_switch_to_n
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * We rearm the timer until we get disabled by the idle code
- * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ * Called with interrupts disabled and timer->base->cpu_base->lock *not* held.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
 	struct tick_sched *ts =
 		container_of(timer, struct tick_sched, sched_timer);
-	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
@@ -454,13 +453,12 @@ static enum hrtimer_restart tick_sched_t
 		}
 		/*
 		 * update_process_times() might take tasklist_lock, hence
-		 * drop the base lock. sched-tick hrtimers are per-CPU and
-		 * never accessible by userspace APIs, so this is safe to do.
+		 * we don't attempt to grab the base lock here.
+		 * sched-tick hrtimers are per-CPU and never accessible by
+		 * userspace APIs, so this is safe to do.
 		 */
-		spin_unlock(&base->lock);
 		update_process_times(user_mode(regs));
 		profile_tick(CPU_PROFILING);
-		spin_lock(&base->lock);
 	}
 
 	/* Do not restart, when we are in the idle loop */
_

Patches currently in -mm which might be from dilinger@debian.org are

dynticks-dont-unlock-spinlock-twice.patch
