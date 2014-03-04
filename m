From: akpm@linux-foundation.org
Subject: + scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch added
 to -mm tree
Date: Tue, 04 Mar 2014 14:27:27 -0800
Message-ID: <5316534f.3ofTEbKhBAjeCehb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbaCDW12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, peterz@infradead.org, mingo@kernel.org, cl@linux.com

Subject: + scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch added to -mm tree
To: cl@linux.com,mingo@kernel.org,peterz@infradead.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:27 -0800


The patch titled
     Subject: scheduler: replace __get_cpu_var with this_cpu_ptr
has been added to the -mm tree.  Its filename is
     scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch

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
Subject: scheduler: replace __get_cpu_var with this_cpu_ptr

Convert all uses of __get_cpu_var for address calculation to use
this_cpu_ptr instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel_stat.h   |    4 ++--
 kernel/events/callchain.c     |    4 ++--
 kernel/events/core.c          |   22 +++++++++++-----------
 kernel/sched/fair.c           |    2 +-
 kernel/sched/rt.c             |    2 +-
 kernel/sched/sched.h          |    4 ++--
 kernel/taskstats.c            |    2 +-
 kernel/user-return-notifier.c |    4 ++--
 8 files changed, 22 insertions(+), 22 deletions(-)

diff -puN include/linux/kernel_stat.h~scheduler-replace-__get_cpu_var-with-this_cpu_ptr include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/include/linux/kernel_stat.h
@@ -44,8 +44,8 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 /* Must have preemption disabled for this to be meaningful. */
-#define kstat_this_cpu (&__get_cpu_var(kstat))
-#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
+#define kstat_this_cpu this_cpu_ptr(&kstat)
+#define kcpustat_this_cpu this_cpu_ptr(&kernel_cpustat)
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
 #define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
 
diff -puN kernel/events/callchain.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/events/callchain.c
--- a/kernel/events/callchain.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/events/callchain.c
@@ -137,7 +137,7 @@ static struct perf_callchain_entry *get_
 	int cpu;
 	struct callchain_cpus_entries *entries;
 
-	*rctx = get_recursion_context(__get_cpu_var(callchain_recursion));
+	*rctx = get_recursion_context(this_cpu_ptr(callchain_recursion));
 	if (*rctx == -1)
 		return NULL;
 
@@ -153,7 +153,7 @@ static struct perf_callchain_entry *get_
 static void
 put_callchain_entry(int rctx)
 {
-	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
+	put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
 }
 
 struct perf_callchain_entry *
diff -puN kernel/events/core.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/events/core.c
--- a/kernel/events/core.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/events/core.c
@@ -259,10 +259,10 @@ void perf_sample_event_took(u64 sample_l
 		return;
 
 	/* decay the counter by 1 average sample */
-	local_samples_len = __get_cpu_var(running_sample_length);
+	local_samples_len = __this_cpu_read(running_sample_length);
 	local_samples_len -= local_samples_len/NR_ACCUMULATED_SAMPLES;
 	local_samples_len += sample_len_ns;
-	__get_cpu_var(running_sample_length) = local_samples_len;
+	__this_cpu_write(running_sample_length, local_samples_len);
 
 	/*
 	 * note: this will be biased artifically low until we have
@@ -874,7 +874,7 @@ static DEFINE_PER_CPU(struct list_head,
 static void perf_pmu_rotate_start(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 
 	WARN_ON(!irqs_disabled());
 
@@ -2370,7 +2370,7 @@ void __perf_event_task_sched_out(struct
 	 * to check if we have to switch out PMU state.
 	 * cgroup event are system-wide mode only
 	 */
-	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+	if (atomic_read(this_cpu_ptr(&perf_cgroup_events)))
 		perf_cgroup_sched_out(task, next);
 }
 
@@ -2613,11 +2613,11 @@ void __perf_event_task_sched_in(struct t
 	 * to check if we have to switch in PMU state.
 	 * cgroup event are system-wide mode only
 	 */
-	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+	if (atomic_read(this_cpu_ptr(&perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
 
 	/* check for system-wide branch_stack events */
-	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
+	if (atomic_read(this_cpu_ptr(&perf_branch_stack_events)))
 		perf_branch_stack_sched_in(prev, task);
 }
 
@@ -2872,7 +2872,7 @@ bool perf_event_can_stop_tick(void)
 
 void perf_event_task_tick(void)
 {
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
 	struct perf_event_context *ctx;
 	int throttled;
@@ -5586,7 +5586,7 @@ static void do_perf_sw_event(enum perf_t
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct perf_event *event;
 	struct hlist_head *head;
 
@@ -5605,7 +5605,7 @@ end:
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	return get_recursion_context(swhash->recursion);
 }
@@ -5613,7 +5613,7 @@ EXPORT_SYMBOL_GPL(perf_swevent_get_recur
 
 inline void perf_swevent_put_recursion_context(int rctx)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	put_recursion_context(swhash->recursion, rctx);
 }
@@ -5642,7 +5642,7 @@ static void perf_swevent_read(struct per
 
 static int perf_swevent_add(struct perf_event *event, int flags)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct hw_perf_event *hwc = &event->hw;
 	struct hlist_head *head;
 
diff -puN kernel/sched/fair.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/sched/fair.c
--- a/kernel/sched/fair.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/sched/fair.c
@@ -6412,7 +6412,7 @@ static int load_balance(int this_cpu, st
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_ptr(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
diff -puN kernel/sched/rt.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/sched/rt.c
--- a/kernel/sched/rt.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/sched/rt.c
@@ -1448,7 +1448,7 @@ static DEFINE_PER_CPU(cpumask_var_t, loc
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = this_cpu_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
diff -puN kernel/sched/sched.h~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/sched/sched.h
--- a/kernel/sched/sched.h~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/sched/sched.h
@@ -645,10 +645,10 @@ static inline int cpu_of(struct rq *rq)
 DECLARE_PER_CPU(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
+#define this_rq()		this_cpu_ptr(&runqueues)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+#define raw_rq()		raw_cpu_ptr(&runqueues)
 
 static inline u64 rq_clock(struct rq *rq)
 {
diff -puN kernel/taskstats.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/taskstats.c
--- a/kernel/taskstats.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/taskstats.c
@@ -638,7 +638,7 @@ void taskstats_exit(struct task_struct *
 		fill_tgid_exit(tsk);
 	}
 
-	listeners = __this_cpu_ptr(&listener_array);
+	listeners = raw_cpu_ptr(&listener_array);
 	if (list_empty(&listeners->list))
 		return;
 
diff -puN kernel/user-return-notifier.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr kernel/user-return-notifier.c
--- a/kernel/user-return-notifier.c~scheduler-replace-__get_cpu_var-with-this_cpu_ptr
+++ a/kernel/user-return-notifier.c
@@ -14,7 +14,7 @@ static DEFINE_PER_CPU(struct hlist_head,
 void user_return_notifier_register(struct user_return_notifier *urn)
 {
 	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
-	hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
+	hlist_add_head(&urn->link, this_cpu_ptr(&return_notifier_list));
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
@@ -25,7 +25,7 @@ EXPORT_SYMBOL_GPL(user_return_notifier_r
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
 	hlist_del(&urn->link);
-	if (hlist_empty(&__get_cpu_var(return_notifier_list)))
+	if (hlist_empty(this_cpu_ptr(&return_notifier_list)))
 		clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_unregister);
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

