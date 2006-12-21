From: akpm@osdl.org
Subject: + generic-vsyscall-gtod-support-for-generic_time.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:32:15 -0800
Message-ID: <200612210632.kBL6WF70017754@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422745AbWLUGdK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:33:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ak@muc.de, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     generic: vsyscall-gtod support for GENERIC_TIME
has been added to the -mm tree.  Its filename is
     generic-vsyscall-gtod-support-for-generic_time.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: generic: vsyscall-gtod support for GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>

Provides generic infrastructure for vsyscall-gtod.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clocksource.h |    8 ++++++++
 kernel/timer.c              |    1 +
 2 files changed, 9 insertions(+)

diff -puN include/linux/clocksource.h~generic-vsyscall-gtod-support-for-generic_time include/linux/clocksource.h
--- a/include/linux/clocksource.h~generic-vsyscall-gtod-support-for-generic_time
+++ a/include/linux/clocksource.h
@@ -46,6 +46,7 @@ typedef u64 cycle_t;
  * @shift:		cycle to nanosecond divisor (power of two)
  * @update_callback:	called when safe to alter clocksource values
  * @is_continuous:	defines if clocksource is free-running.
+ * @vread:		vsyscall based read
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -59,6 +60,7 @@ struct clocksource {
 	u32 shift;
 	int (*update_callback)(void);
 	int is_continuous;
+	cycle_t (*vread)(void);
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_last, cycle_interval;
@@ -182,4 +184,10 @@ int clocksource_register(struct clocksou
 void clocksource_reselect(void);
 struct clocksource* clocksource_get_next(void);
 
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL
+extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+#else
+#define update_vsyscall(now, c) do { } while(0)
+#endif
+
 #endif /* _LINUX_CLOCKSOURCE_H */
diff -puN kernel/timer.c~generic-vsyscall-gtod-support-for-generic_time kernel/timer.c
--- a/kernel/timer.c~generic-vsyscall-gtod-support-for-generic_time
+++ a/kernel/timer.c
@@ -1199,6 +1199,7 @@ static void update_wall_time(void)
 		hrtimer_clock_notify();
 		clocksource_calculate_interval(clock, tick_nsec);
 	}
+	update_vsyscall(&xtime, clock);
 }
 
 /*
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
clockevents-core.patch
clockevents-i386-drivers.patch
high-res-timers-core.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch

