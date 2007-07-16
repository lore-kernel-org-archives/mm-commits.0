From: akpm@linux-foundation.org
Subject: - sys_time-speedup.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:34 -0700
Message-ID: <200707162057.l6GKvYRF002205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760940AbXGPVVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     sys_time() speedup
has been removed from the -mm tree.  Its filename was
     sys_time-speedup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sys_time() speedup
From: Ingo Molnar <mingo@elte.hu>

Improve performance of sys_time().  sys_time() returns time in seconds, but
it does so by calling do_gettimeofday() and then returning the tv_sec
portion of the GTOD time.  But the data structure "xtime", which is updated
by every timer/scheduler tick, already offers HZ granularity time.

The patch improves the sysbench OLTP macrobenchmark significantly:

2.6.22-rc6:

#threads
   1:        transactions:                        3733   (373.21 per sec.)
   2:        transactions:                        6676   (667.46 per sec.)
   3:        transactions:                        6957   (695.50 per sec.)
   4:        transactions:                        7055   (705.48 per sec.)
   5:        transactions:                        6596   (659.33 per sec.)

2.6.22-rc6 + sys_time.patch:

   1:        transactions:                        4005   (400.47 per sec.)
   2:        transactions:                        7379   (737.77 per sec.)
   3:        transactions:                        7347   (734.49 per sec.)
   4:        transactions:                        7468   (746.65 per sec.)
   5:        transactions:                        7428   (742.47 per sec.)

Mixed API uses of gettimeofday() and time() are guaranteed to be coherent
via the use of a at-most-once-per-second slowpath that updates xtime.

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff -puN kernel/time.c~sys_time-speedup kernel/time.c
--- a/kernel/time.c~sys_time-speedup
+++ a/kernel/time.c
@@ -57,14 +57,17 @@ EXPORT_SYMBOL(sys_tz);
  */
 asmlinkage long sys_time(time_t __user * tloc)
 {
-	time_t i;
-	struct timeval tv;
+	/*
+	 * We read xtime.tv_sec atomically - it's updated
+	 * atomically by update_wall_time(), so no need to
+	 * even read-lock the xtime seqlock:
+	 */
+	time_t i = xtime.tv_sec;
 
-	do_gettimeofday(&tv);
-	i = tv.tv_sec;
+	smp_rmb(); /* sys_time() results are coherent */
 
 	if (tloc) {
-		if (put_user(i,tloc))
+		if (put_user(i, tloc))
 			i = -EFAULT;
 	}
 	return i;
@@ -373,12 +376,25 @@ void do_gettimeofday (struct timeval *tv
 
 	tv->tv_sec = sec;
 	tv->tv_usec = usec;
-}
 
+	/*
+	 * Make sure xtime.tv_sec [returned by sys_time()] always
+	 * follows the gettimeofday() result precisely. This
+	 * condition is extremely unlikely, it can hit at most
+	 * once per second:
+	 */
+	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
+		unsigned long flags;
+
+		write_seqlock_irqsave(&xtime_lock, flags);
+		update_wall_time();
+		write_sequnlock_irqrestore(&xtime_lock, flags);
+	}
+}
 EXPORT_SYMBOL(do_gettimeofday);
 
+#else	/* CONFIG_TIME_INTERPOLATION */
 
-#else
 #ifndef CONFIG_GENERIC_TIME
 /*
  * Simulate gettimeofday using do_gettimeofday which only allows a timeval
@@ -394,7 +410,7 @@ void getnstimeofday(struct timespec *tv)
 }
 EXPORT_SYMBOL_GPL(getnstimeofday);
 #endif
-#endif
+#endif	/* CONFIG_TIME_INTERPOLATION */
 
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
