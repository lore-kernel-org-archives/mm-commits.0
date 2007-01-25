From: akpm@osdl.org
Subject: - dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:11:50 -0800
Message-ID: <200701250611.l0P6BoIV007721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49341 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXAYGPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, bunk@stusta.de, cotte@de.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     dynticks: extend next_timer_interrupt() to use a reference jiffie
has been removed from the -mm tree.  Its filename was
     dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: dynticks: extend next_timer_interrupt() to use a reference jiffie
From: Thomas Gleixner <tglx@linutronix.de>

For CONFIG_NO_HZ we need to calculate the next timer wheel event based
on a given jiffie value.  Extend the existing code to allow the extra
'now' argument. Provide a compability function for the existing
implementations to call the function with now == jiffies. (This also
solves the racyness of the original code vs. jiffies changing during
the iteration.)

No functional changes to existing users of this infrastructure.

[ remove WARN_ON() that triggered on s390, by Carsten Otte <cotte@de.ibm.com> ]
[ made new helper static, Adrian Bunk <bunk@stusta.de> ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/timer.h |   10 ++++
 kernel/timer.c        |   97 +++++++++++++++++++++++++++++-----------
 2 files changed, 81 insertions(+), 26 deletions(-)

diff -puN include/linux/timer.h~dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie include/linux/timer.h
--- a/include/linux/timer.h~dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/include/linux/timer.h
@@ -61,7 +61,17 @@ extern int del_timer(struct timer_list *
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base:
+ */
 extern unsigned long next_timer_interrupt(void);
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base and does the comparison against the given
+ * jiffie.
+ */
+extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /***
  * add_timer - start a timer
diff -puN kernel/timer.c~dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie kernel/timer.c
--- a/kernel/timer.c~dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/kernel/timer.c
@@ -597,29 +597,15 @@ static inline void __run_timers(tvec_bas
  * is used on S/390 to stop all activity when a cpus is idle.
  * This functions needs to be called disabled.
  */
-unsigned long next_timer_interrupt(void)
+static unsigned long __next_timer_interrupt(tvec_base_t *base,
+					    unsigned long now)
 {
-	tvec_base_t *base;
 	struct list_head *list;
-	struct timer_list *nte;
+	struct timer_list *nte, *found = NULL;
 	unsigned long expires;
-	unsigned long hr_expires = MAX_JIFFY_OFFSET;
-	ktime_t hr_delta;
 	tvec_t *varray[4];
 	int i, j;
 
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
 	expires = base->timer_jiffies + (LONG_MAX >> 1);
 	list = NULL;
 
@@ -628,6 +614,7 @@ unsigned long next_timer_interrupt(void)
 	do {
 		list_for_each_entry(nte, base->tv1.vec + j, entry) {
 			expires = nte->expires;
+			found = nte;
 			if (j < (base->timer_jiffies & TVR_MASK))
 				list = base->tv2.vec + (INDEX(0));
 			goto found;
@@ -647,9 +634,12 @@ unsigned long next_timer_interrupt(void)
 				j = (j + 1) & TVN_MASK;
 				continue;
 			}
-			list_for_each_entry(nte, varray[i]->vec + j, entry)
-				if (time_before(nte->expires, expires))
+			list_for_each_entry(nte, varray[i]->vec + j, entry) {
+				if (time_before(nte->expires, expires)) {
 					expires = nte->expires;
+					found = nte;
+				}
+			}
 			if (j < (INDEX(i)) && i < 3)
 				list = varray[i + 1]->vec + (INDEX(i + 1));
 			goto found;
@@ -663,10 +653,58 @@ found:
 		 * where we found the timer element.
 		 */
 		list_for_each_entry(nte, list, entry) {
-			if (time_before(nte->expires, expires))
+			if (time_before(nte->expires, expires)) {
 				expires = nte->expires;
+				found = nte;
+			}
 		}
 	}
+
+	return expires;
+}
+
+#ifdef CONFIG_NO_HZ
+
+unsigned long get_next_timer_interrupt(unsigned long now)
+{
+	tvec_base_t *base = __get_cpu_var(tvec_bases);
+	unsigned long expires;
+
+	spin_lock(&base->lock);
+	expires = __next_timer_interrupt(base, now);
+	spin_unlock(&base->lock);
+
+	/*
+	 * 'Timer wheel time' can lag behind 'jiffies time' due to
+	 * delayed processing, so make sure we return a value that
+	 * makes sense externally. base->timer_jiffies is unchanged,
+	 * so it is safe to access it outside the lock.
+	 */
+
+	return expires - (now - base->timer_jiffies);
+}
+
+#else
+
+unsigned long next_timer_interrupt(void)
+{
+	tvec_base_t *base = __get_cpu_var(tvec_bases);
+	unsigned long expires;
+	unsigned long now = jiffies;
+	unsigned long hr_expires = MAX_JIFFY_OFFSET;
+	ktime_t hr_delta = hrtimer_get_next_event();
+
+	if (hr_delta.tv64 != KTIME_MAX) {
+		struct timespec tsdelta;
+		tsdelta = ktime_to_timespec(hr_delta);
+		hr_expires = timespec_to_jiffies(&tsdelta);
+		if (hr_expires < 3)
+			return hr_expires + now;
+	}
+	hr_expires += now;
+
+	spin_lock(&base->lock);
+	expires = __next_timer_interrupt(base, now);
 	spin_unlock(&base->lock);
 
 	/*
@@ -682,16 +720,23 @@ found:
 	 * would falsely evaluate to true.  If that is the case, just
 	 * return jiffies so that we can immediately fire the local timer
 	 */
-	if (time_before(expires, jiffies))
-		return jiffies;
+	if (time_before(expires, now))
+		expires = now;
+	else if (time_before(hr_expires, expires))
+		expires = hr_expires;
 
-	if (time_before(hr_expires, expires))
-		return hr_expires;
-
-	return expires;
+	/*
+	 * 'Timer wheel time' can lag behind 'jiffies time' due to
+	 * delayed processing, so make sure we return a value that
+	 * makes sense externally. base->timer_jiffies is unchanged,
+	 * so it is safe to access it outside the lock.
+	 */
+	return expires - (now - base->timer_jiffies);
 }
 #endif
 
+#endif
+
 /******************************************************************/
 
 /* 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
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
