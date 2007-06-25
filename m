From: akpm@linux-foundation.org
Subject: + sys_time-speedup.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:15:16 -0700
Message-ID: <200706252215.l5PMFGkF012306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbXFYWQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     sys_time() speedup
has been added to the -mm tree.  Its filename is
     sys_time-speedup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

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
@@ -373,6 +376,20 @@ void do_gettimeofday (struct timeval *tv
 
 	tv->tv_sec = sec;
 	tv->tv_usec = usec;
+
+	/*
+	 * Make sure xtime.tv_sec [returned by sys_time()] always
+	 * follows the gettimeofday() result precisely. This
+	 * condition is extremely unlikely, it can hit at most
+	 * once per second:
+	 */
+	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
+		unsigned long flags;
+
+		write_seqlock_irqsave(&xtime_lock);
+		update_wall_time();
+		write_seqlock_irqrestore(&xtime_lock);
+	}
 }
 
 EXPORT_SYMBOL(do_gettimeofday);
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi-add-exports.patch
git-kvm.patch
git-selinux.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
pie-randomization.patch
vdso-print-fatal-signals.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
introduce-o_cloexec-take-2.patch
introduce-o_cloexec-parisc-fix.patch
o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
allow-softlockup-to-be-runtime-disabled.patch
sys_time-speedup.patch
cfs-scheduler.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-v14-rc2-mm1.patch
cfs-scheduler-warning-fixes.patch
cfs-scheduler-v15-rc3-mm1.patch
fs-proc-basec-make-a-struct-static.patch
cfs-warning-fixes.patch
schedstats-fix-printk-format.patch
cfs-scheduler-v16.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
