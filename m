From: akpm@linux-foundation.org
Subject: - hrtimer-speedup-hrtimer_enqueue.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:08 -0700
Message-ID: <200707230934.l6N9Y84O016358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbXGWJfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: speedup hrtimer_enqueue
has been removed from the -mm tree.  Its filename was
     hrtimer-speedup-hrtimer_enqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimer: speedup hrtimer_enqueue
From: Ingo Molnar <mingo@elte.hu>

Speedup hrtimer_enqueue by evaluating the rbtree insertion result.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/hrtimer.c~hrtimer-speedup-hrtimer_enqueue kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-speedup-hrtimer_enqueue
+++ a/kernel/hrtimer.c
@@ -686,6 +686,7 @@ static void enqueue_hrtimer(struct hrtim
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
 	struct hrtimer *entry;
+	int leftmost = 1;
 
 	/*
 	 * Find the right place in the rbtree:
@@ -697,18 +698,19 @@ static void enqueue_hrtimer(struct hrtim
 		 * We dont care about collisions. Nodes with
 		 * the same expiry time stay together.
 		 */
-		if (timer->expires.tv64 < entry->expires.tv64)
+		if (timer->expires.tv64 < entry->expires.tv64) {
 			link = &(*link)->rb_left;
-		else
+		} else {
 			link = &(*link)->rb_right;
+			leftmost = 0;
+		}
 	}
 
 	/*
 	 * Insert the timer to the rbtree and check whether it
 	 * replaces the first pending timer
 	 */
-	if (!base->first || timer->expires.tv64 <
-	    rb_entry(base->first, struct hrtimer, node)->expires.tv64) {
+	if (leftmost) {
 		/*
 		 * Reprogram the clock event device. When the timer is already
 		 * expired hrtimer_enqueue_reprogram has either called the
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi.patch
git-kvm.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
mark-sysrq_sched_debug_show-static.patch
cfs-mark-print_cfs_stats-static.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
