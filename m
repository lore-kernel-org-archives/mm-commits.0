From: akpm@linux-foundation.org
Subject: + mips-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:44 -0800
Message-ID: <53165360.qzHyj6hK1VZsk0Sy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbaCDW1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, ralf@linux-mips.org, cl@linux.com

Subject: + mips-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,ralf@linux-mips.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:44 -0800


The patch titled
     Subject: mips: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     mips-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-replace-__get_cpu_var-uses.patch

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
Subject: mips: replace __get_cpu_var uses

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

	__this_cpu_write(y, x);

6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	__this_cpu_inc(y)

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/octeon-irq.c |   30 ++++++++++++-------------
 arch/mips/kernel/kprobes.c           |    6 ++---
 arch/mips/kernel/perf_event_mipsxx.c |   14 +++++------
 arch/mips/kernel/smp-bmips.c         |    2 -
 4 files changed, 26 insertions(+), 26 deletions(-)

diff -puN arch/mips/cavium-octeon/octeon-irq.c~mips-replace-__get_cpu_var-uses arch/mips/cavium-octeon/octeon-irq.c
--- a/arch/mips/cavium-octeon/octeon-irq.c~mips-replace-__get_cpu_var-uses
+++ a/arch/mips/cavium-octeon/octeon-irq.c
@@ -264,13 +264,13 @@ static void octeon_irq_ciu_enable_local(
 	unsigned long *pen;
 	unsigned long flags;
 	union octeon_ciu_chip_data cd;
-	raw_spinlock_t *lock = &__get_cpu_var(octeon_irq_ciu_spinlock);
+	raw_spinlock_t *lock = this_cpu_ptr(&octeon_irq_ciu_spinlock);
 
 	cd.p = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
 	if (cd.s.line == 0) {
-		pen = &__get_cpu_var(octeon_irq_ciu0_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu0_en_mirror);
 		__set_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -279,7 +279,7 @@ static void octeon_irq_ciu_enable_local(
 		wmb();
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
-		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
 		__set_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -296,13 +296,13 @@ static void octeon_irq_ciu_disable_local
 	unsigned long *pen;
 	unsigned long flags;
 	union octeon_ciu_chip_data cd;
-	raw_spinlock_t *lock = &__get_cpu_var(octeon_irq_ciu_spinlock);
+	raw_spinlock_t *lock = this_cpu_ptr(&octeon_irq_ciu_spinlock);
 
 	cd.p = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
 	if (cd.s.line == 0) {
-		pen = &__get_cpu_var(octeon_irq_ciu0_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu0_en_mirror);
 		__clear_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -311,7 +311,7 @@ static void octeon_irq_ciu_disable_local
 		wmb();
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
-		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
 		__clear_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -431,11 +431,11 @@ static void octeon_irq_ciu_enable_local_
 
 	if (cd.s.line == 0) {
 		int index = cvmx_get_core_num() * 2;
-		set_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu0_en_mirror));
+		set_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 	} else {
 		int index = cvmx_get_core_num() * 2 + 1;
-		set_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu1_en_mirror));
+		set_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 	}
 }
@@ -450,11 +450,11 @@ static void octeon_irq_ciu_disable_local
 
 	if (cd.s.line == 0) {
 		int index = cvmx_get_core_num() * 2;
-		clear_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu0_en_mirror));
+		clear_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 	} else {
 		int index = cvmx_get_core_num() * 2 + 1;
-		clear_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu1_en_mirror));
+		clear_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
 	}
 }
@@ -1063,7 +1063,7 @@ static void octeon_irq_ip2_ciu(void)
 	const unsigned long core_id = cvmx_get_core_num();
 	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INTX_SUM0(core_id * 2));
 
-	ciu_sum &= __get_cpu_var(octeon_irq_ciu0_en_mirror);
+	ciu_sum &= __this_cpu_read(octeon_irq_ciu0_en_mirror);
 	if (likely(ciu_sum)) {
 		int bit = fls64(ciu_sum) - 1;
 		int irq = octeon_irq_ciu_to_irq[0][bit];
@@ -1080,7 +1080,7 @@ static void octeon_irq_ip3_ciu(void)
 {
 	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INT_SUM1);
 
-	ciu_sum &= __get_cpu_var(octeon_irq_ciu1_en_mirror);
+	ciu_sum &= __this_cpu_read(octeon_irq_ciu1_en_mirror);
 	if (likely(ciu_sum)) {
 		int bit = fls64(ciu_sum) - 1;
 		int irq = octeon_irq_ciu_to_irq[1][bit];
@@ -1129,10 +1129,10 @@ static void octeon_irq_init_ciu_percpu(v
 	int coreid = cvmx_get_core_num();
 
 
-	__get_cpu_var(octeon_irq_ciu0_en_mirror) = 0;
-	__get_cpu_var(octeon_irq_ciu1_en_mirror) = 0;
+	__this_cpu_write(octeon_irq_ciu0_en_mirror, 0);
+	__this_cpu_write(octeon_irq_ciu1_en_mirror, 0);
 	wmb();
-	raw_spin_lock_init(&__get_cpu_var(octeon_irq_ciu_spinlock));
+	raw_spin_lock_init(this_cpu_ptr(&octeon_irq_ciu_spinlock));
 	/*
 	 * Disable All CIU Interrupts. The ones we need will be
 	 * enabled later.  Read the SUM register so we know the write
diff -puN arch/mips/kernel/kprobes.c~mips-replace-__get_cpu_var-uses arch/mips/kernel/kprobes.c
--- a/arch/mips/kernel/kprobes.c~mips-replace-__get_cpu_var-uses
+++ a/arch/mips/kernel/kprobes.c
@@ -224,7 +224,7 @@ static void save_previous_kprobe(struct
 
 static void restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_old_SR = kcb->prev_kprobe.old_SR;
 	kcb->kprobe_saved_SR = kcb->prev_kprobe.saved_SR;
@@ -234,7 +234,7 @@ static void restore_previous_kprobe(stru
 static void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_SR = kcb->kprobe_old_SR = (regs->cp0_status & ST0_IE);
 	kcb->kprobe_saved_epc = regs->cp0_epc;
 }
@@ -385,7 +385,7 @@ static int __kprobes kprobe_handler(stru
 				ret = 1;
 				goto no_kprobe;
 			}
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs))
 				goto ss_probe;
 		}
diff -puN arch/mips/kernel/perf_event_mipsxx.c~mips-replace-__get_cpu_var-uses arch/mips/kernel/perf_event_mipsxx.c
--- a/arch/mips/kernel/perf_event_mipsxx.c~mips-replace-__get_cpu_var-uses
+++ a/arch/mips/kernel/perf_event_mipsxx.c
@@ -340,7 +340,7 @@ static int mipsxx_pmu_alloc_counter(stru
 
 static void mipsxx_pmu_enable_event(struct hw_perf_event *evt, int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
 
@@ -360,7 +360,7 @@ static void mipsxx_pmu_enable_event(stru
 
 static void mipsxx_pmu_disable_event(int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	unsigned long flags;
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
@@ -460,7 +460,7 @@ static void mipspmu_stop(struct perf_eve
 
 static int mipspmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx;
 	int err = 0;
@@ -496,7 +496,7 @@ out:
 
 static void mipspmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -1270,7 +1270,7 @@ static int __hw_perf_event_init(struct p
 
 static void pause_local_counters(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int ctr = mipspmu.num_counters;
 	unsigned long flags;
 
@@ -1286,7 +1286,7 @@ static void pause_local_counters(void)
 
 static void resume_local_counters(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int ctr = mipspmu.num_counters;
 
 	do {
@@ -1297,7 +1297,7 @@ static void resume_local_counters(void)
 
 static int mipsxx_pmu_handle_shared_irq(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_sample_data data;
 	unsigned int counters = mipspmu.num_counters;
 	u64 counter;
diff -puN arch/mips/kernel/smp-bmips.c~mips-replace-__get_cpu_var-uses arch/mips/kernel/smp-bmips.c
--- a/arch/mips/kernel/smp-bmips.c~mips-replace-__get_cpu_var-uses
+++ a/arch/mips/kernel/smp-bmips.c
@@ -353,7 +353,7 @@ static irqreturn_t bmips43xx_ipi_interru
 	int action, cpu = irq - IPI0_IRQ;
 
 	spin_lock_irqsave(&ipi_lock, flags);
-	action = __get_cpu_var(ipi_action_mask);
+	action = __this_cpu_read(ipi_action_mask);
 	per_cpu(ipi_action_mask, cpu) = 0;
 	clear_c0_cause(cpu ? C_SW1 : C_SW0);
 	spin_unlock_irqrestore(&ipi_lock, flags);
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

