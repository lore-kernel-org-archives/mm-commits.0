From: akpm@linux-foundation.org
Subject: - hrtimers-clean-up-callback-tracking.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:31 -0800
Message-ID: <200702170714.l1H7EV79021530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946560AbXBQHR5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrtimers: clean up callback tracking
has been removed from the -mm tree.  Its filename was
     hrtimers-clean-up-callback-tracking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimers: clean up callback tracking
From: Thomas Gleixner <tglx@linutronix.de>

Reintroduce ktimers feature "optimized away" by the ktimers review process:
remove the curr_timer pointer from the cpu-base and use the hrtimer state.

No functional changes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    1 -
 kernel/hrtimer.c        |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimers-clean-up-callback-tracking include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-clean-up-callback-tracking
+++ a/include/linux/hrtimer.h
@@ -136,7 +136,6 @@ struct hrtimer_cpu_base {
 	spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
-	struct hrtimer			*curr_timer;
 };
 
 /*
diff -puN kernel/hrtimer.c~hrtimers-clean-up-callback-tracking kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-clean-up-callback-tracking
+++ a/kernel/hrtimer.c
@@ -172,8 +172,6 @@ static inline int hrtimer_callback_runni
  */
 #ifdef CONFIG_SMP
 
-#define set_curr_timer(b, t)		do { (b)->curr_timer = (t); } while (0)
-
 /*
  * We are using hashed locking: holding per_cpu(hrtimer_bases)[n].lock
  * means that all timers which are tied to this base via timer->base are
@@ -227,7 +225,7 @@ switch_hrtimer_base(struct hrtimer *time
 		 * completed. There is no conflict as we hold the lock until
 		 * the timer is enqueued.
 		 */
-		if (unlikely(base->cpu_base->curr_timer == timer))
+		if (unlikely(timer->state & HRTIMER_STATE_CALLBACK))
 			return base;
 
 		/* See the comment in lock_timer_base() */
@@ -241,8 +239,6 @@ switch_hrtimer_base(struct hrtimer *time
 
 #else /* CONFIG_SMP */
 
-#define set_curr_timer(b, t)		do { } while (0)
-
 static inline struct hrtimer_clock_base *
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
@@ -670,7 +666,6 @@ static inline void run_hrtimer_queue(str
 			break;
 
 		fn = timer->function;
-		set_curr_timer(cpu_base, timer);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
 		spin_unlock_irq(&cpu_base->lock);
 
@@ -684,7 +679,6 @@ static inline void run_hrtimer_queue(str
 			enqueue_hrtimer(timer, base);
 		}
 	}
-	set_curr_timer(cpu_base, NULL);
 	spin_unlock_irq(&cpu_base->lock);
 }
 
@@ -871,8 +865,6 @@ static void migrate_hrtimers(int cpu)
 	spin_lock(&old_base->lock);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		BUG_ON(old_base->curr_timer);
-
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
