From: akpm@linux-foundation.org
Subject: + sched_clock-prevent-scd-clock-from-moving-backwards-take-2.patch added to -mm tree
Date: Mon, 05 Jan 2009 14:38:48 -0800
Message-ID: <200901052238.n05Mcm5X002865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbZAEWje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 17:39:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, dev@jaysonking.com, mingo@elte.hu, stable@kernel.org


The patch titled
     sched_clock: prevent scd->clock from moving backwards
has been added to the -mm tree.  Its filename is
     sched_clock-prevent-scd-clock-from-moving-backwards-take-2.patch

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
Subject: sched_clock: prevent scd->clock from moving backwards
From: Thomas Gleixner <tglx@linutronix.de>

Redo:

  5b7dba4: sched_clock: prevent scd->clock from moving backwards

which had to be reverted due to s2ram hangs:

  ca7e716: Revert "sched_clock: prevent scd->clock from moving backwards"

... this time with resume restoring GTOD later in the sequence
taken into account as well.

The "timekeeping_suspended" flag is not very nice but we cannot call into
GTOD before it has been properly resumed and the scheduler will run very
early in the resume sequence.

Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Jayson King <dev@jaysonking.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |    1 +
 kernel/sched_clock.c      |    5 ++++-
 kernel/time/timekeeping.c |    7 +++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/time.h~sched_clock-prevent-scd-clock-from-moving-backwards-take-2 include/linux/time.h
--- a/include/linux/time.h~sched_clock-prevent-scd-clock-from-moving-backwards-take-2
+++ a/include/linux/time.h
@@ -105,6 +105,7 @@ extern unsigned long read_persistent_clo
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
+extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
diff -puN kernel/sched_clock.c~sched_clock-prevent-scd-clock-from-moving-backwards-take-2 kernel/sched_clock.c
--- a/kernel/sched_clock.c~sched_clock-prevent-scd-clock-from-moving-backwards-take-2
+++ a/kernel/sched_clock.c
@@ -124,7 +124,7 @@ static u64 __update_sched_clock(struct s
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
@@ -227,6 +227,9 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep
  */
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
+	if (timekeeping_suspended)
+		return;
+
 	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
diff -puN kernel/time/timekeeping.c~sched_clock-prevent-scd-clock-from-moving-backwards-take-2 kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~sched_clock-prevent-scd-clock-from-moving-backwards-take-2
+++ a/kernel/time/timekeeping.c
@@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((al
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
+/* flag for if timekeeping is suspended */
+int __read_mostly timekeeping_suspended;
+
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
@@ -92,6 +95,8 @@ void getnstimeofday(struct timespec *ts)
 	unsigned long seq;
 	s64 nsecs;
 
+	WARN_ON(timekeeping_suspended);
+
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
@@ -305,8 +310,6 @@ void __init timekeeping_init(void)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
-/* flag for if timekeeping is suspended */
-static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
sched_clock-prevent-scd-clock-from-moving-backwards-take-2.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
allow-times-and-time-system-calls-to-return-small-negative-values.patch
smp_call_function_single-be-slightly-less-stupid.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
remove-lots-of-double-semicolons.patch

