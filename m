From: akpm@linux-foundation.org
Subject: + alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2.patch added to -mm tree
Date: Wed, 28 Jul 2010 12:53:41 -0700
Message-ID: <201007281953.o6SJrfuX031431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab0G1Tyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 15:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcree@orcon.net.nz, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, mattst88@gmail.com, mingo@elte.hu, peterz@infradead.org, rth@twiddle.net, tglx@linutronix.de


The patch titled
     alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2
has been added to the -mm tree.  Its filename is
     alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2
From: Michael Cree <mcree@orcon.net.nz>

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/perf_event.c |   32 ++++++++++++++++++-------------
 arch/alpha/kernel/time.c       |   26 +++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 13 deletions(-)

diff -puN arch/alpha/kernel/perf_event.c~alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2 arch/alpha/kernel/perf_event.c
--- a/arch/alpha/kernel/perf_event.c~alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2
+++ a/arch/alpha/kernel/perf_event.c
@@ -517,8 +517,10 @@ static void alpha_pmu_read(struct perf_e
 static void alpha_pmu_unthrottle(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	wrperfmon(PERFMON_CMD_ENABLE, (1<<hwc->idx));
+	cpuc->idx_mask |= 1UL<<hwc->idx;
+	wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
 }
 
 
@@ -756,12 +758,19 @@ static void alpha_perf_event_irq_handler
 	__get_cpu_var(irq_pmi_count)++;
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	/* la_ptr is the counter that overflowed. */
+	/* Completely counting through the PMC's period to trigger a new PMC
+	 * overflow interrupt while in this interrupt routine is utterly
+	 * disastrous!  The EV6 and EV67 counters are sufficiently large to
+	 * prevent this but to be really sure disable the PMCs.
+	 */
+	wrperfmon(PERFMON_CMD_DISABLE, cpuc->idx_mask);
 
-	if (la_ptr >= perf_max_events) {
+	/* la_ptr is the counter that overflowed. */
+	if (unlikely(la_ptr >= perf_max_events)) {
 		/* This should never occur! */
 		irq_err_count++;
 		pr_warning("PMI: silly index %ld\n", la_ptr);
+		wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 		return;
 	}
 
@@ -773,17 +782,19 @@ static void alpha_perf_event_irq_handler
 			break;
 	}
 
-	if (j == cpuc->n_events) {
+	if (unlikely(j == cpuc->n_events)) {
 		/* This can occur if the event is disabled right on a PMC overflow. */
+		wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 		return;
 	}
 
 	event = cpuc->event[j];
 
-	if (!event) {
+	if (unlikely(!event)) {
 		/* This should never occur! */
 		irq_err_count++;
 		pr_warning("PMI: No event at index %d!\n", idx);
+		wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 		return;
 	}
 
@@ -792,24 +803,19 @@ static void alpha_perf_event_irq_handler
 	data.period = event->hw.last_period;
 
 	if (alpha_perf_event_set_period(event, hwc, idx)) {
-		if (perf_event_overflow(event, 0, &data, regs)) {
+		if (perf_event_overflow(event, 1, &data, regs)) {
 			/* Interrupts coming too quickly; "throttle" the
 			 * counter, i.e., disable it for a little while.
 			 */
-			wrperfmon(PERFMON_CMD_DISABLE, 1<<idx);
+			cpuc->idx_mask &= ~(1UL<<idx);
 		}
 	}
+	wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 
 	return;
 }
 
 
-/* I wonder what this is for ??? */
-void set_perf_event_pending(void)
-{
-}
-
-
 
 /*
  * Init call to initialise performance events at kernel startup.
diff -puN arch/alpha/kernel/time.c~alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2 arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2
+++ a/arch/alpha/kernel/time.c
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/bcd.h>
 #include <linux/profile.h>
+#include <linux/perf_event.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -82,6 +83,26 @@ static struct {
 
 unsigned long est_cycle_freq;
 
+#ifdef CONFIG_PERF_EVENTS
+
+DEFINE_PER_CPU(u8, perf_event_pending);
+
+#define set_perf_event_pending_flag()  __get_cpu_var(perf_event_pending) = 1
+#define test_perf_event_pending()      __get_cpu_var(perf_event_pending)
+#define clear_perf_event_pending()     __get_cpu_var(perf_event_pending) = 0
+
+void set_perf_event_pending(void)
+{
+	set_perf_event_pending_flag();
+}
+
+#else  /* CONFIG_PERF_EVENTS */
+
+#define test_perf_event_pending()      0
+#define clear_perf_event_pending()
+
+#endif /* CONFIG_PERF_EVENTS */
+
 
 static inline __u32 rpcc(void)
 {
@@ -175,6 +196,11 @@ irqreturn_t timer_interrupt(int irq, voi
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
+	if (test_perf_event_pending()) {
+		clear_perf_event_pending();
+		perf_event_do_pending();
+	}
+
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from mcree@orcon.net.nz are

alpha-add-performance-monitor-interrupt-counter.patch
alpha-add-wrperfmonh-header-file-to-aid-use-of-wrperfmon-palcall.patch
alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus.patch
alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus-v2.patch

