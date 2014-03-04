From: akpm@linux-foundation.org
Subject: + time-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:25 -0800
Message-ID: <5316534d.eQwiH7m3ccqrqXq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbaCDW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, cl@linux.com

Subject: + time-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:25 -0800


The patch titled
     Subject: time: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     time-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/time-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/time-replace-__get_cpu_var-uses.patch

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
Subject: time: replace __get_cpu_var uses

Convert uses of __get_cpu_var for creating a address from a percpu offset
to this_cpu_ptr.

The two cases where get_cpu_var is used to actually access a percpu
variable are changed to use this_cpu_read/raw_cpu_read.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/dummy_timer.c |    2 +-
 kernel/hrtimer.c                  |   22 +++++++++++-----------
 kernel/irq_work.c                 |    6 +++---
 kernel/sched/clock.c              |    2 +-
 kernel/softirq.c                  |    4 ++--
 kernel/time/tick-common.c         |    6 +++---
 kernel/time/tick-oneshot.c        |    2 +-
 kernel/time/tick-sched.c          |   22 +++++++++++-----------
 kernel/timer.c                    |    2 +-
 9 files changed, 34 insertions(+), 34 deletions(-)

diff -puN drivers/clocksource/dummy_timer.c~time-replace-__get_cpu_var-uses drivers/clocksource/dummy_timer.c
--- a/drivers/clocksource/dummy_timer.c~time-replace-__get_cpu_var-uses
+++ a/drivers/clocksource/dummy_timer.c
@@ -28,7 +28,7 @@ static void dummy_timer_set_mode(enum cl
 static void dummy_timer_setup(void)
 {
 	int cpu = smp_processor_id();
-	struct clock_event_device *evt = __this_cpu_ptr(&dummy_timer_evt);
+	struct clock_event_device *evt = raw_cpu_ptr(&dummy_timer_evt);
 
 	evt->name	= "dummy_timer";
 	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
diff -puN kernel/hrtimer.c~time-replace-__get_cpu_var-uses kernel/hrtimer.c
--- a/kernel/hrtimer.c~time-replace-__get_cpu_var-uses
+++ a/kernel/hrtimer.c
@@ -598,7 +598,7 @@ hrtimer_force_reprogram(struct hrtimer_c
 static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 	int res;
 
@@ -681,7 +681,7 @@ static inline ktime_t hrtimer_update_bas
  */
 static void retrigger_next_event(void *arg)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *base = this_cpu_ptr(&hrtimer_bases);
 
 	if (!hrtimer_hres_active())
 		return;
@@ -955,7 +955,7 @@ remove_hrtimer(struct hrtimer *timer, st
 		 */
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
+		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 		/*
 		 * We must preserve the CALLBACK state flag here,
 		 * otherwise we could move the timer base in
@@ -1010,7 +1010,7 @@ int __hrtimer_start_range_ns(struct hrti
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+	if (leftmost && new_base->cpu_base == this_cpu_ptr(&hrtimer_bases)
 		&& hrtimer_enqueue_reprogram(timer, new_base)) {
 		if (wakeup) {
 			/*
@@ -1143,7 +1143,7 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
  */
 ktime_t hrtimer_get_next_event(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
@@ -1184,7 +1184,7 @@ static void __hrtimer_init(struct hrtime
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = raw_cpu_ptr(&hrtimer_bases);
 
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
@@ -1227,7 +1227,7 @@ int hrtimer_get_res(const clockid_t whic
 	struct hrtimer_cpu_base *cpu_base;
 	int base = hrtimer_clockid_to_base(which_clock);
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = raw_cpu_ptr(&hrtimer_bases);
 	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
 
 	return 0;
@@ -1282,7 +1282,7 @@ static void __run_hrtimer(struct hrtimer
  */
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
 
@@ -1416,7 +1416,7 @@ static void __hrtimer_peek_ahead_timers(
 	if (!hrtimer_hres_active())
 		return;
 
-	td = &__get_cpu_var(tick_cpu_device);
+	td = this_cpu_ptr(&tick_cpu_device);
 	if (td && td->evtdev)
 		hrtimer_interrupt(td->evtdev);
 }
@@ -1480,7 +1480,7 @@ void hrtimer_run_pending(void)
 void hrtimer_run_queues(void)
 {
 	struct timerqueue_node *node;
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	int index, gettime = 1;
 
@@ -1718,7 +1718,7 @@ static void migrate_hrtimers(int scpu)
 
 	local_irq_disable();
 	old_base = &per_cpu(hrtimer_bases, scpu);
-	new_base = &__get_cpu_var(hrtimer_bases);
+	new_base = this_cpu_ptr(&hrtimer_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
diff -puN kernel/irq_work.c~time-replace-__get_cpu_var-uses kernel/irq_work.c
--- a/kernel/irq_work.c~time-replace-__get_cpu_var-uses
+++ a/kernel/irq_work.c
@@ -70,7 +70,7 @@ bool irq_work_queue(struct irq_work *wor
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+	llist_add(&work->llnode, this_cpu_ptr(&irq_work_list));
 
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
@@ -92,7 +92,7 @@ bool irq_work_needs_cpu(void)
 {
 	struct llist_head *this_list;
 
-	this_list = &__get_cpu_var(irq_work_list);
+	this_list = this_cpu_ptr(&irq_work_list);
 	if (llist_empty(this_list))
 		return false;
 
@@ -117,7 +117,7 @@ static void __irq_work_run(void)
 	__this_cpu_write(irq_work_raised, 0);
 	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
+	this_list = this_cpu_ptr(&irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
diff -puN kernel/sched/clock.c~time-replace-__get_cpu_var-uses kernel/sched/clock.c
--- a/kernel/sched/clock.c~time-replace-__get_cpu_var-uses
+++ a/kernel/sched/clock.c
@@ -134,7 +134,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(str
 
 static inline struct sched_clock_data *this_scd(void)
 {
-	return &__get_cpu_var(sched_clock_data);
+	return this_cpu_ptr(&sched_clock_data);
 }
 
 static inline struct sched_clock_data *cpu_sdc(int cpu)
diff -puN kernel/softirq.c~time-replace-__get_cpu_var-uses kernel/softirq.c
--- a/kernel/softirq.c~time-replace-__get_cpu_var-uses
+++ a/kernel/softirq.c
@@ -486,7 +486,7 @@ static void tasklet_action(struct softir
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_vec.head);
 	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
+	__this_cpu_write(tasklet_vec.tail, this_cpu_ptr(&tasklet_vec.head));
 	local_irq_enable();
 
 	while (list) {
@@ -522,7 +522,7 @@ static void tasklet_hi_action(struct sof
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, NULL);
-	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head);
+	__this_cpu_write(tasklet_hi_vec.tail, this_cpu_ptr(&tasklet_hi_vec.head));
 	local_irq_enable();
 
 	while (list) {
diff -puN kernel/time/tick-common.c~time-replace-__get_cpu_var-uses kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~time-replace-__get_cpu_var-uses
+++ a/kernel/time/tick-common.c
@@ -224,7 +224,7 @@ static void tick_setup_device(struct tic
 
 void tick_install_replacement(struct clock_event_device *newdev)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
@@ -374,14 +374,14 @@ void tick_shutdown(unsigned int *cpup)
 
 void tick_suspend(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 
 	clockevents_shutdown(td->evtdev);
 }
 
 void tick_resume(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	int broadcast = tick_resume_broadcast();
 
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
diff -puN kernel/time/tick-oneshot.c~time-replace-__get_cpu_var-uses kernel/time/tick-oneshot.c
--- a/kernel/time/tick-oneshot.c~time-replace-__get_cpu_var-uses
+++ a/kernel/time/tick-oneshot.c
@@ -59,7 +59,7 @@ void tick_setup_oneshot(struct clock_eve
  */
 int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
diff -puN kernel/time/tick-sched.c~time-replace-__get_cpu_var-uses kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-replace-__get_cpu_var-uses
+++ a/kernel/time/tick-sched.c
@@ -201,7 +201,7 @@ static void tick_nohz_restart_sched_tick
  */
 void __tick_nohz_full_check(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (tick_nohz_full_cpu(smp_processor_id())) {
 		if (ts->tick_stopped && !is_idle_task(current)) {
@@ -227,7 +227,7 @@ static DEFINE_PER_CPU(struct irq_work, n
 void tick_nohz_full_kick(void)
 {
 	if (tick_nohz_full_cpu(smp_processor_id()))
-		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+		irq_work_queue(this_cpu_ptr(&nohz_full_kick_work));
 }
 
 static void nohz_full_kick_ipi(void *info)
@@ -530,7 +530,7 @@ static ktime_t tick_nohz_stop_sched_tick
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	unsigned long rcu_delta_jiffies;
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 	u64 time_delta;
 
 	time_delta = timekeeping_max_deferment();
@@ -798,7 +798,7 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_disable();
 
-	ts = &__get_cpu_var(tick_cpu_sched);
+	ts = this_cpu_ptr(&tick_cpu_sched);
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
@@ -816,7 +816,7 @@ EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
  */
 void tick_nohz_irq_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (ts->inidle)
 		__tick_nohz_idle_enter(ts);
@@ -831,7 +831,7 @@ void tick_nohz_irq_exit(void)
  */
 ktime_t tick_nohz_get_sleep_length(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	return ts->sleep_length;
 }
@@ -944,7 +944,7 @@ static int tick_nohz_reprogram(struct ti
  */
 static void tick_nohz_handler(struct clock_event_device *dev)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
@@ -964,7 +964,7 @@ static void tick_nohz_handler(struct clo
  */
 static void tick_nohz_switch_to_nohz(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t next;
 
 	if (!tick_nohz_active)
@@ -1100,7 +1100,7 @@ early_param("skew_tick", skew_tick);
  */
 void tick_setup_sched_timer(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now = ktime_get();
 
 	/*
@@ -1169,7 +1169,7 @@ void tick_clock_notify(void)
  */
 void tick_oneshot_notify(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	set_bit(0, &ts->check_clocks);
 }
@@ -1184,7 +1184,7 @@ void tick_oneshot_notify(void)
  */
 int tick_check_oneshot_change(int allow_nohz)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (!test_and_clear_bit(0, &ts->check_clocks))
 		return 0;
diff -puN kernel/timer.c~time-replace-__get_cpu_var-uses kernel/timer.c
--- a/kernel/timer.c~time-replace-__get_cpu_var-uses
+++ a/kernel/timer.c
@@ -638,7 +638,7 @@ static inline void debug_assert_init(str
 static void do_init_timer(struct timer_list *timer, unsigned int flags,
 			  const char *name, struct lock_class_key *key)
 {
-	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
+	struct tvec_base *base = raw_cpu_read(tvec_bases);
 
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);
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

