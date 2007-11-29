From: akpm@linux-foundation.org
Subject: + time-fix-typo-in-comments.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:50:06 -0800
Message-ID: <200711292350.lATNo6Ek013589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763398AbXK2Xvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: fix typo in comments
has been added to the -mm tree.  Its filename is
     time-fix-typo-in-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time: fix typo in comments
From: Li Zefan <lizf@cn.fujitsu.com>

Fix typo in comments.

BTW: I have to fix coding style in arch/ia64/kernel/time.c also, otherwise
checkpatch.pl will be complaining.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/time.c   |   14 +++++++-------
 arch/x86/kernel/time_64.c |    2 +-
 include/linux/hrtimer.h   |    2 +-
 include/linux/jiffies.h   |    6 +++---
 kernel/time.c             |    4 ++--
 kernel/time/clockevents.c |    2 +-
 kernel/time/timekeeping.c |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

diff -puN arch/ia64/kernel/time.c~time-fix-typo-in-comments arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~time-fix-typo-in-comments
+++ a/arch/ia64/kernel/time.c
@@ -49,13 +49,13 @@ EXPORT_SYMBOL(last_cli_ip);
 #endif
 
 static struct clocksource clocksource_itc = {
-        .name           = "itc",
-        .rating         = 350,
-        .read           = itc_get_cycles,
-        .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
-        .shift          = 16,
-        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+	.name           = "itc",
+	.rating         = 350,
+	.read           = itc_get_cycles,
+	.mask           = CLOCKSOURCE_MASK(64),
+	.mult           = 0, /*to be calculated*/
+	.shift          = 16,
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 static struct clocksource *itc_clocksource;
 
diff -puN arch/x86/kernel/time_64.c~time-fix-typo-in-comments arch/x86/kernel/time_64.c
--- a/arch/x86/kernel/time_64.c~time-fix-typo-in-comments
+++ a/arch/x86/kernel/time_64.c
@@ -75,7 +75,7 @@ static unsigned int __init tsc_calibrate
 		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 	local_irq_save(flags);
-	/* start meauring cycles, incrementing from 0 */
+	/* start measuring cycles, incrementing from 0 */
 	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
 	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
 	rdtscl(tsc_start);
diff -puN include/linux/hrtimer.h~time-fix-typo-in-comments include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~time-fix-typo-in-comments
+++ a/include/linux/hrtimer.h
@@ -78,7 +78,7 @@ enum hrtimer_cb_mode {
  * as otherwise the timer could be removed before the softirq code finishes the
  * the handling of the timer.
  *
- * The HRTIMER_STATE_ENQUEUE bit is always or'ed to the current state to
+ * The HRTIMER_STATE_ENQUEUED bit is always or'ed to the current state to
  * preserve the HRTIMER_STATE_CALLBACK bit in the above scenario.
  *
  * All state transitions are protected by cpu_base->lock.
diff -puN include/linux/jiffies.h~time-fix-typo-in-comments include/linux/jiffies.h
--- a/include/linux/jiffies.h~time-fix-typo-in-comments
+++ a/include/linux/jiffies.h
@@ -36,7 +36,7 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, the we can
+/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
  * This however means trouble for large NOM, because (NOM << LSH) may no
@@ -154,7 +154,7 @@ extern unsigned long preset_lpj;
  * We want to do realistic conversions of time so we need to use the same
  * values the update wall clock code uses as the jiffies size.  This value
  * is: TICK_NSEC (which is defined in timex.h).  This
- * is a constant and is in nanoseconds.  We will used scaled math
+ * is a constant and is in nanoseconds.  We will use scaled math
  * with a set of scales defined here as SEC_JIFFIE_SC,  USEC_JIFFIE_SC and
  * NSEC_JIFFIE_SC.  Note that these defines contain nothing but
  * constants and so are computed at compile time.  SHIFT_HZ (computed in
@@ -198,7 +198,7 @@ extern unsigned long preset_lpj;
  * operator if the result is a long long AND at least one of the
  * operands is cast to long long (usually just prior to the "*" so as
  * not to confuse it into thinking it really has a 64-bit operand,
- * which, buy the way, it can do, but it take more code and at least 2
+ * which, buy the way, it can do, but it takes more code and at least 2
  * mpys).
 
  * We also need to be aware that one second in nanoseconds is only a
diff -puN kernel/time.c~time-fix-typo-in-comments kernel/time.c
--- a/kernel/time.c~time-fix-typo-in-comments
+++ a/kernel/time.c
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(jiffies_to_usecs);
  *
  * This function should be only used for timestamps returned by
  * current_kernel_time() or CURRENT_TIME, not with do_gettimeofday() because
- * it doesn't handle the better resolution of the later.
+ * it doesn't handle the better resolution of the latter.
  */
 struct timespec timespec_trunc(struct timespec t, unsigned gran)
 {
@@ -314,7 +314,7 @@ EXPORT_SYMBOL_GPL(getnstimeofday);
  * This algorithm was first published by Gauss (I think).
  *
  * WARNING: this function will overflow on 2106-02-07 06:28:16 on
- * machines were long is 32-bit! (However, as time_t is signed, we
+ * machines where long is 32-bit! (However, as time_t is signed, we
  * will already get problems at other places on 2038-01-19 03:14:08)
  */
 unsigned long
diff -puN kernel/time/clockevents.c~time-fix-typo-in-comments kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~time-fix-typo-in-comments
+++ a/kernel/time/clockevents.c
@@ -123,7 +123,7 @@ static void clockevents_do_notify(unsign
 }
 
 /*
- * Called after a notify add to make devices availble which were
+ * Called after a notify add to make devices available which were
  * released from the notifier call.
  */
 static void clockevents_notify_released(void)
diff -puN kernel/time/timekeeping.c~time-fix-typo-in-comments kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-fix-typo-in-comments
+++ a/kernel/time/timekeeping.c
@@ -360,7 +360,7 @@ static __always_inline int clocksource_b
 	 * with losing too many ticks, otherwise we would overadjust and
 	 * produce an even larger error.  The smaller the adjustment the
 	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adusted
+	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
 	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
