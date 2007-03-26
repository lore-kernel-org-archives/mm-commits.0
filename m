From: akpm@linux-foundation.org
Subject: + forcedeth-work-around-null-skb-dereference-crash.patch added to -mm tree
Date: Mon, 26 Mar 2007 01:11:04 -0800
Message-ID: <200703260911.l2Q9B4ZV015327@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbXCZJL1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 05:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, aabdulla@nvidia.com, jeff@garzik.org


The patch titled
     forcedeth: work around NULL skb dereference crash
has been added to the -mm tree.  Its filename is
     forcedeth-work-around-null-skb-dereference-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: work around NULL skb dereference crash
From: Ingo Molnar <mingo@elte.hu>

work around a NULL skb dereference crash that occurs during high load.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-work-around-null-skb-dereference-crash drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-work-around-null-skb-dereference-crash
+++ a/drivers/net/forcedeth.c
@@ -1902,6 +1902,11 @@ static void nv_tx_done(struct net_device
 						np->stats.tx_carrier_errors++;
 					np->stats.tx_errors++;
 				} else {
+					if (!np->get_tx_ctx->skb) {
+						printk("get_tx: %ld, put_tx: %ld\n", np->get_tx_ctx - np->first_tx_ctx, np->put_tx_ctx - np->first_tx_ctx);
+						WARN_ON(1);
+						break;
+					}
 					np->stats.tx_packets++;
 					np->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
@@ -1917,6 +1922,11 @@ static void nv_tx_done(struct net_device
 						np->stats.tx_carrier_errors++;
 					np->stats.tx_errors++;
 				} else {
+					if (!np->get_tx_ctx->skb) {
+						printk("get_tx: %ld, put_tx: %ld\n", np->get_tx_ctx - np->first_tx_ctx, np->put_tx_ctx - np->first_tx_ctx);
+						WARN_ON(1);
+						break;
+					}
 					np->stats.tx_packets++;
 					np->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
_

Patches currently in -mm which might be from mingo@elte.hu are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-work-around-null-skb-dereference-crash.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
allow-per-cpu-variables-to-be-page-aligned.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
fix-bogus-softlockup-warning-with-sysrq-t.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-accurate-user-accounting.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-rsdl-improvements.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
mm-only-hrtimers-debug-patch.patch
mm-only-hrtimers-debug-patch-fix.patch
