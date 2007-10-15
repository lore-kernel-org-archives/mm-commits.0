From: akpm@linux-foundation.org
Subject: + make-rcutorture-rng-use-temporal-entropy-fix.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:28:33 -0700
Message-ID: <200710152128.l9FLSXs2025846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbXJOV24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:28:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, josh@kernel.org, paulmck@linux.vnet.ibm.com


The patch titled
     Use raw_smp_processor_id() in rcu_random()
has been added to the -mm tree.  Its filename is
     make-rcutorture-rng-use-temporal-entropy-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use raw_smp_processor_id() in rcu_random()
From: Gautham R Shenoy <ego@in.ibm.com>

With CONFIG_PREEMPT=y on 2.6.23-rc8-mm2, rcu_random() calls
smp_processor_id() from a preemptible context, triggering the following
kernel error.

BUG: using smp_processor_id() in preemptible [00000001] code: rcu_torture_fak/5155
caller is rcu_random+0x16/0x39 [rcutorture]
 [<c010612f>] dump_trace+0x68/0x1d2
 [<c01062b1>] show_trace_log_lvl+0x18/0x2c
 [<c0106c23>] show_trace+0xf/0x11
 [<c0106d33>] dump_stack+0x12/0x14
 [<c02a0a25>] debug_smp_processor_id+0xa1/0xb4
 [<f887064c>] rcu_random+0x16/0x39 [rcutorture]
 [<f8870cdf>] <3>BUG: using smp_processor_id() in preemptible [00000001] code: rcu_torture_fak/5156
rcu_torture_fakewriter+0x4d/0xc5 [rcutorture]
 [<c0139b32>] caller is rcu_random+0x16/0x39 [rcutorture]
kthread+0x38/0x5e
 [<c0105ca7>] kernel_thread_helper+0x7/0x10
 =======================
 [<c010612f>] dump_trace+0x68/0x1d2
 [<c01062b1>] show_trace_log_lvl+0x18/0x2c
 [<c0106c23>] show_trace+0xf/0x11
 [<c0106d33>] dump_stack+0x12/0x14
 [<c02a0a25>] debug_smp_processor_id+0xa1/0xb4
 [<f887064c>] rcu_random+0x16/0x39 [rcutorture]
 [<f8870cdf>] rcu_torture_fakewriter+0x4d/0xc5 [rcutorture]

rcu_random() can do with raw_smp_processor_id() as a parameter to
cpu_clock() in this particular context.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Josh Triplett <josh@kernel.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~make-rcutorture-rng-use-temporal-entropy-fix kernel/rcutorture.c
--- a/kernel/rcutorture.c~make-rcutorture-rng-use-temporal-entropy-fix
+++ a/kernel/rcutorture.c
@@ -170,7 +170,8 @@ static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
 	if (--rrsp->rrs_count < 0) {
-		rrsp->rrs_state += (unsigned long)cpu_clock(smp_processor_id());
+		rrsp->rrs_state +=
+			(unsigned long)cpu_clock(raw_smp_processor_id());
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
_

Patches currently in -mm which might be from ego@in.ibm.com are

git-sched.patch
make-rcutorture-rng-use-temporal-entropy-fix.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
