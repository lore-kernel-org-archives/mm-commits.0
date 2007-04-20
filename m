From: akpm@linux-foundation.org
Subject: - forcedeth-work-around-null-skb-dereference-crash.patch removed from -mm tree
Date: Fri, 20 Apr 2007 11:45:09 -0700
Message-ID: <200704201845.l3KIjA2O021415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161228AbXDTSpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 14:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, aabdulla@nvidia.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     forcedeth: work around NULL skb dereference crash
has been removed from the -mm tree.  Its filename was
     forcedeth-work-around-null-skb-dereference-crash.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: forcedeth: work around NULL skb dereference crash
From: Ingo Molnar <mingo@elte.hu>

work around a NULL skb dereference crash that occurs during high load.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-work-around-null-skb-dereference-crash drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-work-around-null-skb-dereference-crash
+++ a/drivers/net/forcedeth.c
@@ -1905,6 +1905,16 @@ static void nv_tx_done(struct net_device
 						np->stats.tx_carrier_errors++;
 					np->stats.tx_errors++;
 				} else {
+					if (!np->get_tx_ctx->skb) {
+						printk("get_tx: %td, put_tx: "
+							"%td\n",
+							np->get_tx_ctx -
+							    np->first_tx_ctx,
+							np->put_tx_ctx -
+							    np->first_tx_ctx);
+						WARN_ON(1);
+						break;
+					}
 					np->stats.tx_packets++;
 					np->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
@@ -1920,6 +1930,16 @@ static void nv_tx_done(struct net_device
 						np->stats.tx_carrier_errors++;
 					np->stats.tx_errors++;
 				} else {
+					if (!np->get_tx_ctx->skb) {
+						printk("get_tx: %td, put_tx: "
+							"%td\n",
+							np->get_tx_ctx -
+							    np->first_tx_ctx,
+							np->put_tx_ctx -
+							    np->first_tx_ctx);
+						WARN_ON(1);
+						break;
+					}
 					np->stats.tx_packets++;
 					np->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
_

Patches currently in -mm which might be from mingo@elte.hu are

git-ieee1394.patch
git-kvm.patch
forcedeth-improve-napi-logic.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
forcedeth-work-around-null-skb-dereference-crash.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
enhance-initcall_debug-measure-latency.patch
simplify-kallsyms_lookup.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
highres-dyntick-prevent-xtime-lock-contention.patch
lockdep-lookup_chain_cache-comment-errata.patch
introduce-a-handy-list_first_entry-macro-v2.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
futex-new-private-futexes.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
