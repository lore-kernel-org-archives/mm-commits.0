From: akpm@linux-foundation.org
Subject: + s390-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:47 -0800
Message-ID: <53165363.WuwhqnbWzxQz10WY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbaCDW1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, cl@linux.com

Subject: + s390-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,heiko.carstens@de.ibm.com,schwidefsky@de.ibm.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:47 -0800


The patch titled
     Subject: s390: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     s390-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-replace-__get_cpu_var-uses.patch

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
Subject: s390: replace __get_cpu_var uses

__get_cpu_var() is used for multiple purposes in the kernel source. One of
them is address calculation via the form &__get_cpu_var(x).  This calculates
the address for the instance of the percpu variable of the current processor
based on an offset.

Other use cases are for storing and retrieving data from the current
processors percpu area.  __get_cpu_var() can be used as an lvalue when
writing data or on the right side of an assignment.

__get_cpu_var() is defined as :

#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))

__get_cpu_var() always only does an address determination. However, store
and retrieve operations could use a segment prefix (or global register on
other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a
percpu area and use optimized assembly code to read and write per cpu
variables.

This patch converts __get_cpu_var into either an explicit address
calculation using this_cpu_ptr() or into a use of this_cpu operations that
use the offset.  Thereby address calculations are avoided and less registers
are used when code is generated.

At the end of the patch set all uses of __get_cpu_var have been removed so
the macro is removed too.

The patch set includes passes over all arches as well. Once these operations
are used throughout then specialized macros can be defined in non -x86
arches as well in order to optimize per cpu access by f.e.  using a global
register that may be set to the per cpu base.

Transformations done to __get_cpu_var()

1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);

2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);

3. Retrieve the content of the current processors instance of a per cpu
variable.

	DEFINE_PER_CPU(int, y);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);

4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(&x, this_cpu_ptr(&y), sizeof(x));

5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);

6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/cputime.h |    2 +-
 arch/s390/include/asm/irq.h     |    2 +-
 arch/s390/kernel/irq.c          |    2 +-
 arch/s390/kernel/kprobes.c      |    8 ++++----
 arch/s390/kernel/nmi.c          |    6 +++---
 arch/s390/kernel/perf_cpum_cf.c |   22 +++++++++++-----------
 arch/s390/kernel/processor.c    |    4 ++--
 arch/s390/kernel/time.c         |    6 +++---
 arch/s390/kernel/vtime.c        |    2 +-
 arch/s390/oprofile/hwsampler.c  |    2 +-
 10 files changed, 28 insertions(+), 28 deletions(-)

diff -puN arch/s390/include/asm/cputime.h~s390-replace-__get_cpu_var-uses arch/s390/include/asm/cputime.h
--- a/arch/s390/include/asm/cputime.h~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/include/asm/cputime.h
@@ -184,7 +184,7 @@ cputime64_t s390_get_idle_time(int cpu);
 
 static inline int s390_nohz_delay(int cpu)
 {
-	return __get_cpu_var(s390_idle).nohz_delay != 0;
+	return __this_cpu_read(s390_idle.nohz_delay) != 0;
 }
 
 #define arch_needs_cpu(cpu) s390_nohz_delay(cpu)
diff -puN arch/s390/include/asm/irq.h~s390-replace-__get_cpu_var-uses arch/s390/include/asm/irq.h
--- a/arch/s390/include/asm/irq.h~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/include/asm/irq.h
@@ -66,7 +66,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct ir
 
 static __always_inline void inc_irq_stat(enum interruption_class irq)
 {
-	__get_cpu_var(irq_stat).irqs[irq]++;
+	__this_cpu_inc(irq_stat.irqs[irq]);
 }
 
 struct ext_code {
diff -puN arch/s390/kernel/irq.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/irq.c
--- a/arch/s390/kernel/irq.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/irq.c
@@ -252,7 +252,7 @@ static irqreturn_t do_ext_interrupt(int
 
 	ext_code = *(struct ext_code *) &regs->int_code;
 	if (ext_code.code != 0x1004)
-		__get_cpu_var(s390_idle).nohz_delay = 1;
+		__this_cpu_write(s390_idle.nohz_delay, 1);
 
 	index = ext_hash(ext_code.code);
 	rcu_read_lock();
diff -puN arch/s390/kernel/kprobes.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/kprobes.c
@@ -366,9 +366,9 @@ static void __kprobes disable_singlestep
  */
 static void __kprobes push_kprobe(struct kprobe_ctlblk *kcb, struct kprobe *p)
 {
-	kcb->prev_kprobe.kp = __get_cpu_var(current_kprobe);
+	kcb->prev_kprobe.kp = __this_cpu_read(current_kprobe);
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 /*
@@ -378,7 +378,7 @@ static void __kprobes push_kprobe(struct
  */
 static void __kprobes pop_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
@@ -459,7 +459,7 @@ static int __kprobes kprobe_handler(stru
 		enable_singlestep(kcb, regs, (unsigned long) p->ainsn.insn);
 		return 1;
 	} else if (kprobe_running()) {
-		p = __get_cpu_var(current_kprobe);
+		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			/*
 			 * Continuation after the jprobe completed and
diff -puN arch/s390/kernel/nmi.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/nmi.c
--- a/arch/s390/kernel/nmi.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/nmi.c
@@ -53,8 +53,8 @@ void s390_handle_mcck(void)
 	 */
 	local_irq_save(flags);
 	local_mcck_disable();
-	mcck = __get_cpu_var(cpu_mcck);
-	memset(&__get_cpu_var(cpu_mcck), 0, sizeof(struct mcck_struct));
+	mcck = __this_cpu_read(cpu_mcck);
+	memset(this_cpu_ptr(&cpu_mcck), 0, sizeof(struct mcck_struct));
 	clear_thread_flag(TIF_MCCK_PENDING);
 	local_mcck_enable();
 	local_irq_restore(flags);
@@ -253,7 +253,7 @@ void notrace s390_do_machine_check(struc
 	nmi_enter();
 	inc_irq_stat(NMI_NMI);
 	mci = (struct mci *) &S390_lowcore.mcck_interruption_code;
-	mcck = &__get_cpu_var(cpu_mcck);
+	mcck = this_cpu_ptr(&cpu_mcck);
 	umode = user_mode(regs);
 
 	if (mci->sd) {
diff -puN arch/s390/kernel/perf_cpum_cf.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/perf_cpum_cf.c
--- a/arch/s390/kernel/perf_cpum_cf.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/perf_cpum_cf.c
@@ -173,7 +173,7 @@ static int validate_ctr_auth(const struc
  */
 static void cpumf_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	int err;
 
 	if (cpuhw->flags & PMU_F_ENABLED)
@@ -196,7 +196,7 @@ static void cpumf_pmu_enable(struct pmu
  */
 static void cpumf_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	int err;
 	u64 inactive;
 
@@ -230,7 +230,7 @@ static void cpumf_measurement_alert(stru
 		return;
 
 	inc_irq_stat(IRQEXT_CMC);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	/* Measurement alerts are shared and might happen when the PMU
 	 * is not reserved.  Ignore these alerts in this case. */
@@ -250,7 +250,7 @@ static void cpumf_measurement_alert(stru
 #define PMC_RELEASE   1
 static void setup_pmc_cpu(void *flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	switch (*((int *) flags)) {
 	case PMC_INIT:
@@ -481,7 +481,7 @@ static void cpumf_pmu_read(struct perf_e
 
 static void cpumf_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
@@ -512,7 +512,7 @@ static void cpumf_pmu_start(struct perf_
 
 static void cpumf_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (!(hwc->state & PERF_HES_STOPPED)) {
@@ -533,7 +533,7 @@ static void cpumf_pmu_stop(struct perf_e
 
 static int cpumf_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	/* Check authorization for the counter set to which this
 	 * counter belongs.
@@ -557,7 +557,7 @@ static int cpumf_pmu_add(struct perf_eve
 
 static void cpumf_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	cpumf_pmu_stop(event, PERF_EF_UPDATE);
 
@@ -581,7 +581,7 @@ static void cpumf_pmu_del(struct perf_ev
  */
 static void cpumf_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	perf_pmu_disable(pmu);
 	cpuhw->flags |= PERF_EVENT_TXN;
@@ -595,7 +595,7 @@ static void cpumf_pmu_start_txn(struct p
  */
 static void cpumf_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	WARN_ON(cpuhw->tx_state != cpuhw->state);
 
@@ -610,7 +610,7 @@ static void cpumf_pmu_cancel_txn(struct
  */
 static int cpumf_pmu_commit_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	u64 state;
 
 	/* check if the updated state can be scheduled */
diff -puN arch/s390/kernel/processor.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/processor.c
--- a/arch/s390/kernel/processor.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/processor.c
@@ -23,8 +23,8 @@ static DEFINE_PER_CPU(struct cpuid, cpu_
  */
 void cpu_init(void)
 {
-	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
-	struct cpuid *id = &__get_cpu_var(cpu_id);
+	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
+	struct cpuid *id = this_cpu_ptr(&cpu_id);
 
 	get_cpu_id(id);
 	atomic_inc(&init_mm.mm_count);
diff -puN arch/s390/kernel/time.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/time.c
@@ -92,7 +92,7 @@ void clock_comparator_work(void)
 	struct clock_event_device *cd;
 
 	S390_lowcore.clock_comparator = -1ULL;
-	cd = &__get_cpu_var(comparators);
+	cd = this_cpu_ptr(&comparators);
 	cd->event_handler(cd);
 }
 
@@ -360,7 +360,7 @@ EXPORT_SYMBOL(get_sync_clock);
  */
 static void disable_sync_clock(void *dummy)
 {
-	atomic_t *sw_ptr = &__get_cpu_var(clock_sync_word);
+	atomic_t *sw_ptr = this_cpu_ptr(&clock_sync_word);
 	/*
 	 * Clear the in-sync bit 2^31. All get_sync_clock calls will
 	 * fail until the sync bit is turned back on. In addition
@@ -377,7 +377,7 @@ static void disable_sync_clock(void *dum
  */
 static void enable_sync_clock(void)
 {
-	atomic_t *sw_ptr = &__get_cpu_var(clock_sync_word);
+	atomic_t *sw_ptr = this_cpu_ptr(&clock_sync_word);
 	atomic_set_mask(0x80000000, sw_ptr);
 }
 
diff -puN arch/s390/kernel/vtime.c~s390-replace-__get_cpu_var-uses arch/s390/kernel/vtime.c
--- a/arch/s390/kernel/vtime.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/kernel/vtime.c
@@ -154,7 +154,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void __kprobes vtime_stop_cpu(void)
 {
-	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
+	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
 	unsigned long long idle_time;
 	unsigned long psw_mask;
 
diff -puN arch/s390/oprofile/hwsampler.c~s390-replace-__get_cpu_var-uses arch/s390/oprofile/hwsampler.c
--- a/arch/s390/oprofile/hwsampler.c~s390-replace-__get_cpu_var-uses
+++ a/arch/s390/oprofile/hwsampler.c
@@ -178,7 +178,7 @@ static int smp_ctl_qsi(int cpu)
 static void hws_ext_handler(struct ext_code ext_code,
 			    unsigned int param32, unsigned long param64)
 {
-	struct hws_cpu_buffer *cb = &__get_cpu_var(sampler_cpu_buffer);
+	struct hws_cpu_buffer *cb = this_cpu_ptr(&sampler_cpu_buffer);
 
 	if (!(param32 & CPU_MF_INT_SF_MASK))
 		return;
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

