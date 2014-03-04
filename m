From: akpm@linux-foundation.org
Subject: + sh-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:28:03 -0800
Message-ID: <53165373.NJmKg84dN05Kfhu5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841AbaCDW2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:28:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lethal@linux-sh.org, cl@linux.com

Subject: + sh-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,lethal@linux-sh.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:28:03 -0800


The patch titled
     Subject: sh: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     sh-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-replace-__get_cpu_var-uses.patch

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
Subject: sh: replace __get_cpu_var uses

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
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/hw_breakpoint.c |    4 ++--
 arch/sh/kernel/kprobes.c       |   30 +++++++++++++++---------------
 arch/sh/kernel/localtimer.c    |    2 +-
 arch/sh/kernel/perf_event.c    |    8 ++++----
 arch/sh/kernel/smp.c           |    2 +-
 5 files changed, 23 insertions(+), 23 deletions(-)

diff -puN arch/sh/kernel/hw_breakpoint.c~sh-replace-__get_cpu_var-uses arch/sh/kernel/hw_breakpoint.c
--- a/arch/sh/kernel/hw_breakpoint.c~sh-replace-__get_cpu_var-uses
+++ a/arch/sh/kernel/hw_breakpoint.c
@@ -52,7 +52,7 @@ int arch_install_hw_breakpoint(struct pe
 	int i;
 
 	for (i = 0; i < sh_ubc->num_events; i++) {
-		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
 
 		if (!*slot) {
 			*slot = bp;
@@ -84,7 +84,7 @@ void arch_uninstall_hw_breakpoint(struct
 	int i;
 
 	for (i = 0; i < sh_ubc->num_events; i++) {
-		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
 
 		if (*slot == bp) {
 			*slot = NULL;
diff -puN arch/sh/kernel/kprobes.c~sh-replace-__get_cpu_var-uses arch/sh/kernel/kprobes.c
--- a/arch/sh/kernel/kprobes.c~sh-replace-__get_cpu_var-uses
+++ a/arch/sh/kernel/kprobes.c
@@ -102,7 +102,7 @@ int __kprobes kprobe_handle_illslot(unsi
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	struct kprobe *saved = &__get_cpu_var(saved_next_opcode);
+	struct kprobe *saved = this_cpu_ptr(&saved_next_opcode);
 
 	if (saved->addr) {
 		arch_disarm_kprobe(p);
@@ -111,7 +111,7 @@ void __kprobes arch_remove_kprobe(struct
 		saved->addr = NULL;
 		saved->opcode = 0;
 
-		saved = &__get_cpu_var(saved_next_opcode2);
+		saved = this_cpu_ptr(&saved_next_opcode2);
 		if (saved->addr) {
 			arch_disarm_kprobe(saved);
 
@@ -129,14 +129,14 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 					 struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 /*
@@ -146,15 +146,15 @@ static void __kprobes set_current_kprobe
  */
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
-	__get_cpu_var(saved_current_opcode).addr = (kprobe_opcode_t *)regs->pc;
+	__this_cpu_write(saved_current_opcode.addr, (kprobe_opcode_t *)regs->pc);
 
 	if (p != NULL) {
 		struct kprobe *op1, *op2;
 
 		arch_disarm_kprobe(p);
 
-		op1 = &__get_cpu_var(saved_next_opcode);
-		op2 = &__get_cpu_var(saved_next_opcode2);
+		op1 = this_cpu_ptr(&saved_next_opcode);
+		op2 = this_cpu_ptr(&saved_next_opcode2);
 
 		if (OPCODE_JSR(p->opcode) || OPCODE_JMP(p->opcode)) {
 			unsigned int reg_nr = ((p->opcode >> 8) & 0x000F);
@@ -249,7 +249,7 @@ static int __kprobes kprobe_handler(stru
 			kcb->kprobe_status = KPROBE_REENTER;
 			return 1;
 		} else {
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs)) {
 				goto ss_probe;
 			}
@@ -336,9 +336,9 @@ int __kprobes trampoline_probe_handler(s
 			continue;
 
 		if (ri->rp && ri->rp->handler) {
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			__this_cpu_write(current_kprobe, &ri->rp->kp);
 			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
+			__this_cpu_write(current_kprobe, NULL);
 		}
 
 		orig_ret_address = (unsigned long)ri->ret_addr;
@@ -383,19 +383,19 @@ static int __kprobes post_kprobe_handler
 		cur->post_handler(cur, regs, 0);
 	}
 
-	p = &__get_cpu_var(saved_next_opcode);
+	p = this_cpu_ptr(&saved_next_opcode);
 	if (p->addr) {
 		arch_disarm_kprobe(p);
 		p->addr = NULL;
 		p->opcode = 0;
 
-		addr = __get_cpu_var(saved_current_opcode).addr;
-		__get_cpu_var(saved_current_opcode).addr = NULL;
+		addr = __this_cpu_read(saved_current_opcode).addr;
+		__this_cpu_write(saved_current_opcode.addr, NULL);
 
 		p = get_kprobe(addr);
 		arch_arm_kprobe(p);
 
-		p = &__get_cpu_var(saved_next_opcode2);
+		p = this_cpu_ptr(&saved_next_opcode2);
 		if (p->addr) {
 			arch_disarm_kprobe(p);
 			p->addr = NULL;
@@ -511,7 +511,7 @@ int __kprobes kprobe_exceptions_notify(s
 				if (kprobe_handler(args->regs)) {
 					ret = NOTIFY_STOP;
 				} else {
-					p = __get_cpu_var(current_kprobe);
+					p = __this_cpu_read(current_kprobe);
 					if (p->break_handler &&
 					    p->break_handler(p, args->regs))
 						ret = NOTIFY_STOP;
diff -puN arch/sh/kernel/localtimer.c~sh-replace-__get_cpu_var-uses arch/sh/kernel/localtimer.c
--- a/arch/sh/kernel/localtimer.c~sh-replace-__get_cpu_var-uses
+++ a/arch/sh/kernel/localtimer.c
@@ -32,7 +32,7 @@ static DEFINE_PER_CPU(struct clock_event
  */
 void local_timer_interrupt(void)
 {
-	struct clock_event_device *clk = &__get_cpu_var(local_clockevent);
+	struct clock_event_device *clk = this_cpu_ptr(&local_clockevent);
 
 	irq_enter();
 	clk->event_handler(clk);
diff -puN arch/sh/kernel/perf_event.c~sh-replace-__get_cpu_var-uses arch/sh/kernel/perf_event.c
--- a/arch/sh/kernel/perf_event.c~sh-replace-__get_cpu_var-uses
+++ a/arch/sh/kernel/perf_event.c
@@ -227,7 +227,7 @@ again:
 
 static void sh_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -245,7 +245,7 @@ static void sh_pmu_stop(struct perf_even
 
 static void sh_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -262,7 +262,7 @@ static void sh_pmu_start(struct perf_eve
 
 static void sh_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	sh_pmu_stop(event, PERF_EF_UPDATE);
 	__clear_bit(event->hw.idx, cpuc->used_mask);
@@ -272,7 +272,7 @@ static void sh_pmu_del(struct perf_event
 
 static int sh_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	int ret = -EAGAIN;
diff -puN arch/sh/kernel/smp.c~sh-replace-__get_cpu_var-uses arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c~sh-replace-__get_cpu_var-uses
+++ a/arch/sh/kernel/smp.c
@@ -111,7 +111,7 @@ void play_dead_common(void)
 	irq_ctx_exit(raw_smp_processor_id());
 	mb();
 
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);
 	local_irq_disable();
 }
 
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

