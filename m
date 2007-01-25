From: akpm@osdl.org
Subject: + fix-cascade-lookup-of-next_timer_interrupt.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:21 -0800
Message-ID: <200701250636.l0P6aLZb008328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50765 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXAYGqC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:46:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Fix cascade lookup of next_timer_interrupt
has been added to the -mm tree.  Its filename is
     fix-cascade-lookup-of-next_timer_interrupt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix cascade lookup of next_timer_interrupt
From: Thomas Gleixner <tglx@linutronix.de>

When searching for the next pending timer in the timer wheel we need to take
the cascade into account.  The current code has several problems:

 1. it looks into the previous cascade
 2. it ignores a pending cascade
 3. it ignores multiple cascades

Change the cascade lookup, so it calculates the array index from the point of
the next cascade and always look at the cascade buckets, when the cascade is
pending, i.e.  gets executed in the next timer softirq.  When multiple
cascades are pending, then lookup the next buckets too.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/timer.c |  151 +++++++++++++++++++++++++----------------------
 1 file changed, 81 insertions(+), 70 deletions(-)

diff -puN kernel/timer.c~fix-cascade-lookup-of-next_timer_interrupt kernel/timer.c
--- a/kernel/timer.c~fix-cascade-lookup-of-next_timer_interrupt
+++ a/kernel/timer.c
@@ -597,99 +597,110 @@ static inline void __run_timers(tvec_bas
  * is used on S/390 to stop all activity when a cpus is idle.
  * This functions needs to be called disabled.
  */
-unsigned long next_timer_interrupt(void)
+static unsigned long __next_timer_interrupt(tvec_base_t *base)
 {
-	tvec_base_t *base;
-	struct list_head *list;
+	unsigned long timer_jiffies = base->timer_jiffies;
+	unsigned long expires = timer_jiffies + (LONG_MAX >> 1);
+	int index, slot, array, found = 0;
 	struct timer_list *nte;
-	unsigned long expires;
-	unsigned long hr_expires = MAX_JIFFY_OFFSET;
-	ktime_t hr_delta;
 	tvec_t *varray[4];
-	int i, j;
-
-	hr_delta = hrtimer_get_next_event();
-	if (hr_delta.tv64 != KTIME_MAX) {
-		struct timespec tsdelta;
-		tsdelta = ktime_to_timespec(hr_delta);
-		hr_expires = timespec_to_jiffies(&tsdelta);
-		if (hr_expires < 3)
-			return hr_expires + jiffies;
-	}
-	hr_expires += jiffies;
-
-	base = __get_cpu_var(tvec_bases);
-	spin_lock(&base->lock);
-	expires = base->timer_jiffies + (LONG_MAX >> 1);
-	list = NULL;
 
 	/* Look for timer events in tv1. */
-	j = base->timer_jiffies & TVR_MASK;
+	index = slot = timer_jiffies & TVR_MASK;
 	do {
-		list_for_each_entry(nte, base->tv1.vec + j, entry) {
+		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+			found = 1;
 			expires = nte->expires;
-			if (j < (base->timer_jiffies & TVR_MASK))
-				list = base->tv2.vec + (INDEX(0));
-			goto found;
+			/* Look at the cascade bucket(s)? */
+			if (!index || slot < index)
+				goto cascade;
+			return expires;
 		}
-		j = (j + 1) & TVR_MASK;
-	} while (j != (base->timer_jiffies & TVR_MASK));
+		slot = (slot + 1) & TVR_MASK;
+	} while (slot != index);
+
+cascade:
+	/* Calculate the next cascade event */
+	if (index)
+		timer_jiffies += TVR_SIZE - index;
+	timer_jiffies >>= TVR_BITS;
 
 	/* Check tv2-tv5. */
 	varray[0] = &base->tv2;
 	varray[1] = &base->tv3;
 	varray[2] = &base->tv4;
 	varray[3] = &base->tv5;
-	for (i = 0; i < 4; i++) {
-		j = INDEX(i);
+
+	for (array = 0; array < 4; array++) {
+		tvec_t *varp = varray[array];
+
+		index = slot = timer_jiffies & TVN_MASK;
 		do {
-			if (list_empty(varray[i]->vec + j)) {
-				j = (j + 1) & TVN_MASK;
-				continue;
-			}
-			list_for_each_entry(nte, varray[i]->vec + j, entry)
+			list_for_each_entry(nte, varp->vec + slot, entry) {
+				found = 1;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
-			if (j < (INDEX(i)) && i < 3)
-				list = varray[i + 1]->vec + (INDEX(i + 1));
-			goto found;
-		} while (j != (INDEX(i)));
-	}
-found:
-	if (list) {
-		/*
-		 * The search wrapped. We need to look at the next list
-		 * from next tv element that would cascade into tv element
-		 * where we found the timer element.
-		 */
-		list_for_each_entry(nte, list, entry) {
-			if (time_before(nte->expires, expires))
-				expires = nte->expires;
-		}
+			}
+			/*
+			 * Do we still search for the first timer or are
+			 * we looking up the cascade buckets ?
+			 */
+			if (found) {
+				/* Look at the cascade bucket(s)? */
+				if (!index || slot < index)
+					break;
+				return expires;
+			}
+			slot = (slot + 1) & TVN_MASK;
+		} while (slot != index);
+
+		if (index)
+			timer_jiffies += TVN_SIZE - index;
+		timer_jiffies >>= TVN_BITS;
 	}
-	spin_unlock(&base->lock);
+	return expires;
+}
 
-	/*
-	 * It can happen that other CPUs service timer IRQs and increment
-	 * jiffies, but we have not yet got a local timer tick to process
-	 * the timer wheels.  In that case, the expiry time can be before
-	 * jiffies, but since the high-resolution timer here is relative to
-	 * jiffies, the default expression when high-resolution timers are
-	 * not active,
-	 *
-	 *   time_before(MAX_JIFFY_OFFSET + jiffies, expires)
-	 *
-	 * would falsely evaluate to true.  If that is the case, just
-	 * return jiffies so that we can immediately fire the local timer
-	 */
-	if (time_before(expires, jiffies))
-		return jiffies;
+/*
+ * Check, if the next hrtimer event is before the next timer wheel
+ * event:
+ */
+static unsigned long cmp_next_hrtimer_event(unsigned long now,
+					    unsigned long expires)
+{
+	ktime_t hr_delta = hrtimer_get_next_event();
+	struct timespec tsdelta;
 
-	if (time_before(hr_expires, expires))
-		return hr_expires;
+	if (hr_delta.tv64 == KTIME_MAX)
+		return expires;
 
+	if (hr_delta.tv64 <= TICK_NSEC)
+		return now;
+
+	tsdelta = ktime_to_timespec(hr_delta);
+	now += timespec_to_jiffies(&tsdelta);
+	if (time_before(now, expires))
+		return now;
 	return expires;
 }
+
+/**
+ * next_timer_interrupt - return the jiffy of the next pending timer
+ */
+unsigned long next_timer_interrupt(void)
+{
+	tvec_base_t *base = __get_cpu_var(tvec_bases);
+	unsigned long expires, now = jiffies;
+
+	spin_lock(&base->lock);
+	expires = __next_timer_interrupt(base);
+	spin_unlock(&base->lock);
+
+	if (time_before_eq(expires, now))
+		return now;
+
+	return cmp_next_hrtimer_event(now, expires);
+}
 #endif
 
 /******************************************************************/
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
