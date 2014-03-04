From: akpm@linux-foundation.org
Subject: + tile-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:57 -0800
Message-ID: <5316536d.HaTEgNopqql27gCC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbaCDW16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, cmetcalf@tilera.com, cl@linux.com

Subject: + tile-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,cmetcalf@tilera.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:57 -0800


The patch titled
     Subject: tile: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     tile-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-replace-__get_cpu_var-uses.patch

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
Subject: tile: replace __get_cpu_var uses

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
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/irqflags.h    |    4 ++--
 arch/tile/include/asm/mmu_context.h |    6 +++---
 arch/tile/kernel/irq.c              |   14 +++++++-------
 arch/tile/kernel/messaging.c        |    6 +++---
 arch/tile/kernel/process.c          |    2 +-
 arch/tile/kernel/setup.c            |    3 ++-
 arch/tile/kernel/single_step.c      |    4 ++--
 arch/tile/kernel/smp.c              |    2 +-
 arch/tile/kernel/smpboot.c          |    6 +++---
 arch/tile/kernel/time.c             |    8 ++++----
 arch/tile/mm/highmem.c              |    2 +-
 arch/tile/mm/init.c                 |    4 ++--
 12 files changed, 31 insertions(+), 30 deletions(-)

diff -puN arch/tile/include/asm/irqflags.h~tile-replace-__get_cpu_var-uses arch/tile/include/asm/irqflags.h
--- a/arch/tile/include/asm/irqflags.h~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/include/asm/irqflags.h
@@ -140,12 +140,12 @@ extern unsigned int debug_smp_processor_
 
 /*
  * Read the set of maskable interrupts.
- * We avoid the preemption warning here via __this_cpu_ptr since even
+ * We avoid the preemption warning here via raw_cpu_ptr since even
  * if irqs are already enabled, it's harmless to read the wrong cpu's
  * enabled mask.
  */
 #define arch_local_irqs_enabled() \
-	(*__this_cpu_ptr(&interrupts_enabled_mask))
+	(*raw_cpu_ptr(&interrupts_enabled_mask))
 
 /* Re-enable all maskable interrupts. */
 #define arch_local_irq_enable() \
diff -puN arch/tile/include/asm/mmu_context.h~tile-replace-__get_cpu_var-uses arch/tile/include/asm/mmu_context.h
--- a/arch/tile/include/asm/mmu_context.h~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/include/asm/mmu_context.h
@@ -84,7 +84,7 @@ static inline void enter_lazy_tlb(struct
 	 * clear any pending DMA interrupts.
 	 */
 	if (current->thread.tile_dma_state.enabled)
-		install_page_table(mm->pgd, __get_cpu_var(current_asid));
+		install_page_table(mm->pgd, __this_cpu_read(current_asid));
 #endif
 }
 
@@ -96,12 +96,12 @@ static inline void switch_mm(struct mm_s
 		int cpu = smp_processor_id();
 
 		/* Pick new ASID. */
-		int asid = __get_cpu_var(current_asid) + 1;
+		int asid = __this_cpu_read(current_asid) + 1;
 		if (asid > max_asid) {
 			asid = min_asid;
 			local_flush_tlb();
 		}
-		__get_cpu_var(current_asid) = asid;
+		__this_cpu_write(current_asid, asid);
 
 		/* Clear cpu from the old mm, and set it in the new one. */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
diff -puN arch/tile/kernel/irq.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/irq.c
--- a/arch/tile/kernel/irq.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/irq.c
@@ -79,7 +79,7 @@ static DEFINE_SPINLOCK(available_irqs_lo
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
-	int depth = __get_cpu_var(irq_depth)++;
+	int depth = __this_cpu_inc_return(irq_depth);
 	unsigned long original_irqs;
 	unsigned long remaining_irqs;
 	struct pt_regs *old_regs;
@@ -126,7 +126,7 @@ void tile_dev_intr(struct pt_regs *regs,
 
 		/* Count device irqs; Linux IPIs are counted elsewhere. */
 		if (irq != IRQ_RESCHEDULE)
-			__get_cpu_var(irq_stat).irq_dev_intr_count++;
+			__this_cpu_inc(irq_stat.irq_dev_intr_count);
 
 		generic_handle_irq(irq);
 	}
@@ -136,10 +136,10 @@ void tile_dev_intr(struct pt_regs *regs,
 	 * including any that were reenabled during interrupt
 	 * handling.
 	 */
-	if (depth == 0)
-		unmask_irqs(~__get_cpu_var(irq_disable_mask));
+	if (depth == 1)
+		unmask_irqs(~__this_cpu_read(irq_disable_mask));
 
-	__get_cpu_var(irq_depth)--;
+	__this_cpu_dec(irq_depth);
 
 	/*
 	 * Track time spent against the current process again and
@@ -157,7 +157,7 @@ void tile_dev_intr(struct pt_regs *regs,
 static void tile_irq_chip_enable(struct irq_data *d)
 {
 	get_cpu_var(irq_disable_mask) &= ~(1UL << d->irq);
-	if (__get_cpu_var(irq_depth) == 0)
+	if (__this_cpu_read(irq_depth) == 0)
 		unmask_irqs(1UL << d->irq);
 	put_cpu_var(irq_disable_mask);
 }
@@ -203,7 +203,7 @@ static void tile_irq_chip_ack(struct irq
  */
 static void tile_irq_chip_eoi(struct irq_data *d)
 {
-	if (!(__get_cpu_var(irq_disable_mask) & (1UL << d->irq)))
+	if (!(__this_cpu_read(irq_disable_mask) & (1UL << d->irq)))
 		unmask_irqs(1UL << d->irq);
 }
 
diff -puN arch/tile/kernel/messaging.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/messaging.c
--- a/arch/tile/kernel/messaging.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/messaging.c
@@ -28,7 +28,7 @@ static DEFINE_PER_CPU(HV_MsgState, msg_s
 void init_messaging(void)
 {
 	/* Allocate storage for messages in kernel space */
-	HV_MsgState *state = &__get_cpu_var(msg_state);
+	HV_MsgState *state = this_cpu_ptr(&msg_state);
 	int rc = hv_register_message_state(state);
 	if (rc != HV_OK)
 		panic("hv_register_message_state: error %d", rc);
@@ -68,7 +68,7 @@ void hv_message_intr(struct pt_regs *reg
 #endif
 
 	while (1) {
-		rmi = hv_receive_message(__get_cpu_var(msg_state),
+		rmi = hv_receive_message(__this_cpu_read(msg_state),
 					 (HV_VirtAddr) message,
 					 sizeof(message));
 		if (rmi.msglen == 0)
@@ -96,7 +96,7 @@ void hv_message_intr(struct pt_regs *reg
 			struct hv_driver_cb *cb =
 				(struct hv_driver_cb *)him->intarg;
 			cb->callback(cb, him->intdata);
-			__get_cpu_var(irq_stat).irq_hv_msg_count++;
+			__this_cpu_inc(irq_stat.irq_hv_msg_count);
 		}
 	}
 
diff -puN arch/tile/kernel/process.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/process.c
--- a/arch/tile/kernel/process.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/process.c
@@ -64,7 +64,7 @@ early_param("idle", idle_setup);
 
 void arch_cpu_idle(void)
 {
-	__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+	__this_cpu_write(irq_stat.idle_timestamp, jiffies);
 	_cpu_idle();
 }
 
diff -puN arch/tile/kernel/setup.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/setup.c
@@ -1220,7 +1220,8 @@ static void __init validate_hv(void)
 	 * various asid variables to their appropriate initial states.
 	 */
 	asid_range = hv_inquire_asid(0);
-	__get_cpu_var(current_asid) = min_asid = asid_range.start;
+	min_asid = asid_range.start;
+	__this_cpu_write(current_asid, min_asid);
 	max_asid = asid_range.start + asid_range.size - 1;
 
 	if (hv_confstr(HV_CONFSTR_CHIP_MODEL, (HV_VirtAddr)chip_model,
diff -puN arch/tile/kernel/single_step.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/single_step.c
--- a/arch/tile/kernel/single_step.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/single_step.c
@@ -740,7 +740,7 @@ static DEFINE_PER_CPU(unsigned long, ss_
 
 void gx_singlestep_handle(struct pt_regs *regs, int fault_num)
 {
-	unsigned long *ss_pc = &__get_cpu_var(ss_saved_pc);
+	unsigned long *ss_pc = this_cpu_ptr(&ss_saved_pc);
 	struct thread_info *info = (void *)current_thread_info();
 	int is_single_step = test_ti_thread_flag(info, TIF_SINGLESTEP);
 	unsigned long control = __insn_mfspr(SPR_SINGLE_STEP_CONTROL_K);
@@ -766,7 +766,7 @@ void gx_singlestep_handle(struct pt_regs
 
 void single_step_once(struct pt_regs *regs)
 {
-	unsigned long *ss_pc = &__get_cpu_var(ss_saved_pc);
+	unsigned long *ss_pc = this_cpu_ptr(&ss_saved_pc);
 	unsigned long control = __insn_mfspr(SPR_SINGLE_STEP_CONTROL_K);
 
 	*ss_pc = regs->pc;
diff -puN arch/tile/kernel/smp.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/smp.c
--- a/arch/tile/kernel/smp.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/smp.c
@@ -188,7 +188,7 @@ void flush_icache_range(unsigned long st
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
 static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
-	__get_cpu_var(irq_stat).irq_resched_count++;
+	__this_cpu_inc(irq_stat.irq_resched_count);
 	scheduler_ipi();
 
 	return IRQ_HANDLED;
diff -puN arch/tile/kernel/smpboot.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/smpboot.c
--- a/arch/tile/kernel/smpboot.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/smpboot.c
@@ -41,7 +41,7 @@ void __init smp_prepare_boot_cpu(void)
 	int cpu = smp_processor_id();
 	set_cpu_online(cpu, 1);
 	set_cpu_present(cpu, 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
+	__this_cpu_write(cpu_state, CPU_ONLINE);
 
 	init_messaging();
 }
@@ -158,7 +158,7 @@ static void start_secondary(void)
 	/* printk(KERN_DEBUG "Initializing CPU#%d\n", cpuid); */
 
 	/* Initialize the current asid for our first page table. */
-	__get_cpu_var(current_asid) = min_asid;
+	__this_cpu_write(current_asid, min_asid);
 
 	/* Set up this thread as another owner of the init_mm */
 	atomic_inc(&init_mm.mm_count);
@@ -201,7 +201,7 @@ void online_secondary(void)
 	notify_cpu_starting(smp_processor_id());
 
 	set_cpu_online(smp_processor_id(), 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
+	__this_cpu_write(cpu_state, CPU_ONLINE);
 
 	/* Set up tile-specific state for this cpu. */
 	setup_cpu(0);
diff -puN arch/tile/kernel/time.c~tile-replace-__get_cpu_var-uses arch/tile/kernel/time.c
--- a/arch/tile/kernel/time.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/kernel/time.c
@@ -162,7 +162,7 @@ static DEFINE_PER_CPU(struct clock_event
 
 void setup_tile_timer(void)
 {
-	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+	struct clock_event_device *evt = this_cpu_ptr(&tile_timer);
 
 	/* Fill in fields that are speed-specific. */
 	clockevents_calc_mult_shift(evt, cycles_per_sec, TILE_MINSEC);
@@ -182,7 +182,7 @@ void setup_tile_timer(void)
 void do_timer_interrupt(struct pt_regs *regs, int fault_num)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+	struct clock_event_device *evt = this_cpu_ptr(&tile_timer);
 
 	/*
 	 * Mask the timer interrupt here, since we are a oneshot timer
@@ -194,7 +194,7 @@ void do_timer_interrupt(struct pt_regs *
 	irq_enter();
 
 	/* Track interrupt count. */
-	__get_cpu_var(irq_stat).irq_timer_count++;
+	__this_cpu_inc(irq_stat.irq_timer_count);
 
 	/* Call the generic timer handler */
 	evt->event_handler(evt);
@@ -235,7 +235,7 @@ cycles_t ns2cycles(unsigned long nsecs)
 	 * We do not have to disable preemption here as each core has the same
 	 * clock frequency.
 	 */
-	struct clock_event_device *dev = &__raw_get_cpu_var(tile_timer);
+	struct clock_event_device *dev = raw_cpu_ptr(&tile_timer);
 	return ((u64)nsecs * dev->mult) >> dev->shift;
 }
 
diff -puN arch/tile/mm/highmem.c~tile-replace-__get_cpu_var-uses arch/tile/mm/highmem.c
--- a/arch/tile/mm/highmem.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/mm/highmem.c
@@ -103,7 +103,7 @@ static void kmap_atomic_register(struct
 	spin_lock(&amp_lock);
 
 	/* With interrupts disabled, now fill in the per-cpu info. */
-	amp = &__get_cpu_var(amps).per_type[type];
+	amp = this_cpu_ptr(&amps.per_type[type]);
 	amp->page = page;
 	amp->cpu = smp_processor_id();
 	amp->va = va;
diff -puN arch/tile/mm/init.c~tile-replace-__get_cpu_var-uses arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~tile-replace-__get_cpu_var-uses
+++ a/arch/tile/mm/init.c
@@ -593,14 +593,14 @@ static void __init kernel_physical_mappi
 	interrupt_mask_set_mask(-1ULL);
 	rc = flush_and_install_context(__pa(pgtables),
 				       init_pgprot((unsigned long)pgtables),
-				       __get_cpu_var(current_asid),
+				       __this_cpu_read(current_asid),
 				       cpumask_bits(my_cpu_mask));
 	interrupt_mask_restore_mask(irqmask);
 	BUG_ON(rc != 0);
 
 	/* Copy the page table back to the normal swapper_pg_dir. */
 	memcpy(pgd_base, pgtables, sizeof(pgtables));
-	__install_page_table(pgd_base, __get_cpu_var(current_asid),
+	__install_page_table(pgd_base, __this_cpu_read(current_asid),
 			     swapper_pgprot);
 
 	/*
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

