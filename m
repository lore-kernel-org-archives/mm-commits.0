From: akpm@linux-foundation.org
Subject: - lock-debugging-loop-nicer-in-mark_rt_mutex_waiters.patch removed from -mm tree
Date: Mon, 18 Jun 2007 00:37:43 -0700
Message-ID: <200706180737.l5I7bhMN001237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342AbXFRHi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jun 2007 03:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     lock debugging: loop nicer in mark_rt_mutex_waiters
has been removed from the -mm tree.  Its filename was
     lock-debugging-loop-nicer-in-mark_rt_mutex_waiters.patch

This patch was dropped because futex-revert-the-non-functional-requeue_pi.patch destroyed it

------------------------------------------------------
Subject: lock debugging: loop nicer in mark_rt_mutex_waiters
From: Ingo Molnar <mingo@elte.hu>

Loop nicer in the mark_rt_mutex_waiters() busy loop.

Fix white space damage while at it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rtmutex_common.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/rtmutex_common.h~lock-debugging-loop-nicer-in-mark_rt_mutex_waiters kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~lock-debugging-loop-nicer-in-mark_rt_mutex_waiters
+++ a/kernel/rtmutex_common.h
@@ -103,7 +103,7 @@ static inline struct task_struct *rt_mut
 
 static inline struct task_struct *rt_mutex_real_owner(struct rt_mutex *lock)
 {
- 	return (struct task_struct *)
+	return (struct task_struct *)
 		((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
 }
 
@@ -120,11 +120,13 @@ static inline unsigned long rt_mutex_own
 # define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
 static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 {
-	unsigned long owner, *p = (unsigned long *) &lock->owner;
+	unsigned long *p = (unsigned long *) &lock->owner;
+	unsigned long owner = *p;
 
-	do {
+	while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner) {
+		cpu_relax();
 		owner = *p;
-	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
+	}
 }
 #else
 # define rt_mutex_cmpxchg(l,c,n)	(0)
_

Patches currently in -mm which might be from mingo@elte.hu are

sched-fix-sysrq-n-normalize-rt-tasks.patch
futex-revert-the-non-functional-requeue_pi.patch
git-acpi-add-exports.patch
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
lock-debugging-loop-nicer-in-mark_rt_mutex_waiters.patch
allow-softlockup-to-be-runtime-disabled.patch
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
