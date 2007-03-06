From: akpm@linux-foundation.org
Subject: + highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:21:02 -0800
Message-ID: <200703060321.l263L2PN010529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933903AbXCFDVK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:21:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, dilinger@debian.org, mingo@elte.hu


The patch titled
     highres: do not run the TIMER_SOFTIRQ after switching to highres mode
has been added to the -mm tree.  Its filename is
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: highres: do not run the TIMER_SOFTIRQ after switching to highres mode
From: Thomas Gleixner <tglx@linutronix.de>

The TIMER_SOFTIRQ runs the hrtimers during bootup until a usable
clocksource and clock event sources are registered.  The switch to high
resolution mode happens inside of the TIMER_SOFTIRQ, but runs the softirq
afterwards.  That way the tick emulation timer, which was set up in the
switch to highres might be executed in the softirq context, which is a BUG.
 The rbtree has not to be touched by the softirq after the highres switch.

This BUG was observed by Andres Salomon, who provided the information to
debug it.

Return early from the softirq, when the switch was sucessful.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode kernel/hrtimer.c
--- a/kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode
+++ a/kernel/hrtimer.c
@@ -540,19 +540,19 @@ static inline int hrtimer_enqueue_reprog
 /*
  * Switch to high resolution mode
  */
-static void hrtimer_switch_to_hres(void)
+static int hrtimer_switch_to_hres(void)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 	unsigned long flags;
 
 	if (base->hres_active)
-		return;
+		return 1;
 
 	local_irq_save(flags);
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 	base->hres_active = 1;
 	base->clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES;
@@ -565,13 +565,14 @@ static void hrtimer_switch_to_hres(void)
 	local_irq_restore(flags);
 	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
 	       smp_processor_id());
+	return 1;
 }
 
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
-static inline void hrtimer_switch_to_hres(void) { }
+static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base)
@@ -1173,7 +1174,8 @@ void hrtimer_run_queues(void)
 	 * deadlock vs. xtime_lock.
 	 */
 	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
-		hrtimer_switch_to_hres();
+		if (hrtimer_switch_to_hres())
+			return;
 
 	hrtimer_get_softirq_time(cpu_base);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
hrtimers-hrtimer_clock_base-description-typo.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
