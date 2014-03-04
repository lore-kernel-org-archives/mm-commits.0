From: akpm@linux-foundation.org
Subject: + x86-change-__get_cpu_var-calls-introduced-in-314.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:40 -0800
Message-ID: <5316535c.GqSPewH3vIw811Em%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbaCDW1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@kernel.org, hpa@linux.intel.com, cl@linux.com

Subject: + x86-change-__get_cpu_var-calls-introduced-in-314.patch added to -mm tree
To: cl@linux.com,hpa@linux.intel.com,mingo@kernel.org,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:40 -0800


The patch titled
     Subject: x86: change __get_cpu_var calls introduced in 3.14
has been added to the -mm tree.  Its filename is
     x86-change-__get_cpu_var-calls-introduced-in-314.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-change-__get_cpu_var-calls-introduced-in-314.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-change-__get_cpu_var-calls-introduced-in-314.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: x86: change __get_cpu_var calls introduced in 3.14

More were added recently.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_intel_rapl.c |   12 ++++++------
 kernel/sched/deadline.c                     |    2 +-
 kernel/time/tick-broadcast.c                |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel_rapl.c~x86-change-__get_cpu_var-calls-introduced-in-314 arch/x86/kernel/cpu/perf_event_intel_rapl.c
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c~x86-change-__get_cpu_var-calls-introduced-in-314
+++ a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -129,7 +129,7 @@ static inline u64 rapl_scale(u64 v)
 	 * or use ldexp(count, -32).
 	 * Watts = Joules/Time delta
 	 */
-	return v << (32 - __get_cpu_var(rapl_pmu)->hw_unit);
+	return v << (32 - __this_cpu_read(rapl_pmu->hw_unit));
 }
 
 static u64 rapl_event_update(struct perf_event *event)
@@ -181,7 +181,7 @@ static void rapl_stop_hrtimer(struct rap
 
 static enum hrtimer_restart rapl_hrtimer_handle(struct hrtimer *hrtimer)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	struct perf_event *event;
 	unsigned long flags;
 
@@ -228,7 +228,7 @@ static void __rapl_pmu_event_start(struc
 
 static void rapl_pmu_event_start(struct perf_event *event, int mode)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	unsigned long flags;
 
 	spin_lock_irqsave(&pmu->lock, flags);
@@ -238,7 +238,7 @@ static void rapl_pmu_event_start(struct
 
 static void rapl_pmu_event_stop(struct perf_event *event, int mode)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long flags;
 
@@ -272,7 +272,7 @@ static void rapl_pmu_event_stop(struct p
 
 static int rapl_pmu_event_add(struct perf_event *event, int mode)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long flags;
 
@@ -662,7 +662,7 @@ static int __init rapl_pmu_init(void)
 		return -1;
 	}
 
-	pmu = __get_cpu_var(rapl_pmu);
+	pmu = __this_cpu_read(rapl_pmu);
 
 	pr_info("RAPL PMU detected, hw unit 2^-%d Joules,"
 		" API unit is 2^-32 Joules,"
diff -puN kernel/sched/deadline.c~x86-change-__get_cpu_var-calls-introduced-in-314 kernel/sched/deadline.c
--- a/kernel/sched/deadline.c~x86-change-__get_cpu_var-calls-introduced-in-314
+++ a/kernel/sched/deadline.c
@@ -1141,7 +1141,7 @@ static DEFINE_PER_CPU(cpumask_var_t, loc
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
+	struct cpumask *later_mask = this_cpu_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
 	int best_cpu, cpu = task_cpu(task);
 
diff -puN kernel/time/tick-broadcast.c~x86-change-__get_cpu_var-calls-introduced-in-314 kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~x86-change-__get_cpu_var-calls-introduced-in-314
+++ a/kernel/time/tick-broadcast.c
@@ -554,7 +554,7 @@ int tick_resume_broadcast_oneshot(struct
 void tick_check_oneshot_broadcast_this_cpu(void)
 {
 	if (cpumask_test_cpu(smp_processor_id(), tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+		struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 
 		/*
 		 * We might be in the middle of switching over from
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

