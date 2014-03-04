From: akpm@linux-foundation.org
Subject: + blackfin-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:59 -0800
Message-ID: <5316536f.5yFn2X9ZrVnJUe55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbaCDW2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:28:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, tj@kernel.org, cl@linux.com

Subject: + blackfin-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,tj@kernel.org,vapier@gentoo.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:59 -0800


The patch titled
     Subject: blackfin: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     blackfin-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blackfin-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blackfin-replace-__get_cpu_var-uses.patch

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
Subject: blackfin: replace __get_cpu_var uses

[Patch depends on another patch in this series that introduces raw_cpu_ops]

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
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/ipipe.h         |    2 +-
 arch/blackfin/kernel/perf_event.c         |   10 +++++-----
 arch/blackfin/mach-common/ints-priority.c |    8 ++++----
 arch/blackfin/mach-common/smp.c           |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/blackfin/include/asm/ipipe.h~blackfin-replace-__get_cpu_var-uses arch/blackfin/include/asm/ipipe.h
--- a/arch/blackfin/include/asm/ipipe.h~blackfin-replace-__get_cpu_var-uses
+++ a/arch/blackfin/include/asm/ipipe.h
@@ -157,7 +157,7 @@ static inline unsigned long __ipipe_ffnz
 }
 
 #define __ipipe_do_root_xirq(ipd, irq)					\
-	((ipd)->irqs[irq].handler(irq, &__raw_get_cpu_var(__ipipe_tick_regs)))
+	((ipd)->irqs[irq].handler(irq, raw_cpu_ptr(&__ipipe_tick_regs)))
 
 #define __ipipe_run_irqtail(irq)  /* Must be a macro */			\
 	do {								\
diff -puN arch/blackfin/kernel/perf_event.c~blackfin-replace-__get_cpu_var-uses arch/blackfin/kernel/perf_event.c
--- a/arch/blackfin/kernel/perf_event.c~blackfin-replace-__get_cpu_var-uses
+++ a/arch/blackfin/kernel/perf_event.c
@@ -300,7 +300,7 @@ again:
 
 static void bfin_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -318,7 +318,7 @@ static void bfin_pmu_stop(struct perf_ev
 
 static void bfin_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -335,7 +335,7 @@ static void bfin_pmu_start(struct perf_e
 
 static void bfin_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	bfin_pmu_stop(event, PERF_EF_UPDATE);
 	__clear_bit(event->hw.idx, cpuc->used_mask);
@@ -345,7 +345,7 @@ static void bfin_pmu_del(struct perf_eve
 
 static int bfin_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	int ret = -EAGAIN;
@@ -429,7 +429,7 @@ static int bfin_pmu_event_init(struct pe
 
 static void bfin_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	int i;
diff -puN arch/blackfin/mach-common/ints-priority.c~blackfin-replace-__get_cpu_var-uses arch/blackfin/mach-common/ints-priority.c
--- a/arch/blackfin/mach-common/ints-priority.c~blackfin-replace-__get_cpu_var-uses
+++ a/arch/blackfin/mach-common/ints-priority.c
@@ -1311,12 +1311,12 @@ asmlinkage int __ipipe_grab_irq(int vec,
 		bfin_write_TIMER_STATUS(1); /* Latch TIMIL0 */
 #endif
 		/* This is basically what we need from the register frame. */
-		__raw_get_cpu_var(__ipipe_tick_regs).ipend = regs->ipend;
-		__raw_get_cpu_var(__ipipe_tick_regs).pc = regs->pc;
+		__this_cpu_write(__ipipe_tick_regs.ipend, regs->ipend);
+		__this_cpu_write(__ipipe_tick_regs.pc, regs->pc);
 		if (this_domain != ipipe_root_domain)
-			__raw_get_cpu_var(__ipipe_tick_regs).ipend &= ~0x10;
+			__this_cpu_and(__ipipe_tick_regs.ipend, ~0x10);
 		else
-			__raw_get_cpu_var(__ipipe_tick_regs).ipend |= 0x10;
+			__this_cpu_or(__ipipe_tick_regs.ipend, 0x10);
 	}
 
 	/*
diff -puN arch/blackfin/mach-common/smp.c~blackfin-replace-__get_cpu_var-uses arch/blackfin/mach-common/smp.c
--- a/arch/blackfin/mach-common/smp.c~blackfin-replace-__get_cpu_var-uses
+++ a/arch/blackfin/mach-common/smp.c
@@ -146,7 +146,7 @@ static irqreturn_t ipi_handler_int1(int
 	platform_clear_ipi(cpu, IRQ_SUPPLE_1);
 
 	smp_rmb();
-	bfin_ipi_data = &__get_cpu_var(bfin_ipi);
+	bfin_ipi_data = this_cpu_ptr(&bfin_ipi);
 	while ((pending = atomic_xchg(&bfin_ipi_data->bits, 0)) != 0) {
 		msg = 0;
 		do {
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

