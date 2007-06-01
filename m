From: akpm@linux-foundation.org
Subject: - timer-stats-speedups.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:39 -0700
Message-ID: <200706011748.l51Hmcjm015223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761931AbXFARtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer stats: speedups
has been removed from the -mm tree.  Its filename was
     timer-stats-speedups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: timer stats: speedups
From: Ingo Molnar <mingo@elte.hu>

Make timer-stats have almost zero overhead when enabled in the config but
not used.  (this way distros can enable it more easily)

Also update the documentation about overhead of timer_stats - it was
written for the first version which had a global lock and a linear list
walk based lookup ;-)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hrtimer/timer_stats.txt |    7 ++++---
 kernel/time/timer_stats.c             |    7 ++++++-
 lib/Kconfig.debug                     |    5 ++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff -puN Documentation/hrtimer/timer_stats.txt~timer-stats-speedups Documentation/hrtimer/timer_stats.txt
--- a/Documentation/hrtimer/timer_stats.txt~timer-stats-speedups
+++ a/Documentation/hrtimer/timer_stats.txt
@@ -2,9 +2,10 @@ timer_stats - timer usage statistics
 ------------------------------------
 
 timer_stats is a debugging facility to make the timer (ab)usage in a Linux
-system visible to kernel and userspace developers. It is not intended for
-production usage as it adds significant overhead to the (hr)timer code and the
-(hr)timer data structures.
+system visible to kernel and userspace developers. If enabled in the config
+but not used it has almost zero runtime overhead, and a relatively small
+data structure overhead. Even if collection is enabled runtime all the
+locking is per-CPU and lookup is hashed.
 
 timer_stats should be used by kernel and userspace developers to verify that
 their code does not make unduly use of timers. This helps to avoid unnecessary
diff -puN kernel/time/timer_stats.c~timer-stats-speedups kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~timer-stats-speedups
+++ a/kernel/time/timer_stats.c
@@ -236,10 +236,15 @@ void timer_stats_update_stats(void *time
 	/*
 	 * It doesnt matter which lock we take:
 	 */
-	spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+	spinlock_t *lock;
 	struct entry *entry, input;
 	unsigned long flags;
 
+	if (likely(!active))
+		return;
+
+	lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+
 	input.timer = timer;
 	input.start_func = startf;
 	input.expire_func = timerf;
diff -puN lib/Kconfig.debug~timer-stats-speedups lib/Kconfig.debug
--- a/lib/Kconfig.debug~timer-stats-speedups
+++ a/lib/Kconfig.debug
@@ -126,7 +126,10 @@ config TIMER_STATS
 	  reprogrammed. The statistics can be read from /proc/timer_stats.
 	  The statistics collection is started by writing 1 to /proc/timer_stats,
 	  writing 0 stops it. This feature is useful to collect information
-	  about timer usage patterns in kernel and userspace.
+	  about timer usage patterns in kernel and userspace. This feature
+	  is lightweight if enabled in the kernel config but not activated
+	  (it defaults to deactivated on bootup and will only be activated
+	  if some application like powertop activates it explicitly).
 
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-kvm.patch
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
cfs-scheduler.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-v14-rc2-mm1.patch
cfs-scheduler-warning-fixes.patch
cfs-scheduler-v15-rc3-mm1.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
