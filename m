From: akpm@linux-foundation.org
Subject: + powerpc-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:53 -0800
Message-ID: <53165369.JtjLR22YUXS1TQk4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbaCDW1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paulus@samba.org, benh@kernel.crashing.org, cl@linux.com

Subject: + powerpc-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,benh@kernel.crashing.org,paulus@samba.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:53 -0800


The patch titled
     Subject: powerpc: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     powerpc-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-replace-__get_cpu_var-uses.patch

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
Subject: powerpc: replace __get_cpu_var uses

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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/cputime.h           |    6 ++--
 arch/powerpc/include/asm/hardirq.h           |    2 -
 arch/powerpc/include/asm/tlbflush.h          |    4 +--
 arch/powerpc/include/asm/xics.h              |    8 +++---
 arch/powerpc/kernel/dbell.c                  |    2 -
 arch/powerpc/kernel/hw_breakpoint.c          |    6 ++--
 arch/powerpc/kernel/iommu.c                  |    2 -
 arch/powerpc/kernel/irq.c                    |    2 -
 arch/powerpc/kernel/kprobes.c                |    6 ++--
 arch/powerpc/kernel/process.c                |   10 +++----
 arch/powerpc/kernel/smp.c                    |    6 ++--
 arch/powerpc/kernel/sysfs.c                  |    4 +--
 arch/powerpc/kernel/time.c                   |   14 +++++-----
 arch/powerpc/kernel/traps.c                  |    4 +--
 arch/powerpc/kvm/e500.c                      |   14 +++++-----
 arch/powerpc/kvm/e500mc.c                    |    4 +--
 arch/powerpc/mm/hash_native_64.c             |    2 -
 arch/powerpc/mm/hash_utils_64.c              |    2 -
 arch/powerpc/mm/hugetlbpage-book3e.c         |    4 +--
 arch/powerpc/mm/hugetlbpage.c                |    2 -
 arch/powerpc/mm/stab.c                       |   12 ++++-----
 arch/powerpc/perf/core-book3s.c              |   22 ++++++++---------
 arch/powerpc/perf/core-fsl-emb.c             |    6 ++--
 arch/powerpc/platforms/cell/interrupt.c      |    6 ++--
 arch/powerpc/platforms/ps3/interrupt.c       |    2 -
 arch/powerpc/platforms/pseries/dtl.c         |    2 -
 arch/powerpc/platforms/pseries/hvCall_inst.c |    4 +--
 arch/powerpc/platforms/pseries/iommu.c       |    8 +++---
 arch/powerpc/platforms/pseries/lpar.c        |    6 ++--
 arch/powerpc/platforms/pseries/ras.c         |    4 +--
 arch/powerpc/sysdev/xics/xics-common.c       |    2 -
 31 files changed, 89 insertions(+), 89 deletions(-)

diff -puN arch/powerpc/include/asm/cputime.h~powerpc-replace-__get_cpu_var-uses arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/include/asm/cputime.h
@@ -56,10 +56,10 @@ static inline unsigned long cputime_to_j
 static inline cputime_t cputime_to_scaled(const cputime_t ct)
 {
 	if (cpu_has_feature(CPU_FTR_SPURR) &&
-	    __get_cpu_var(cputime_last_delta))
+	    __this_cpu_read(cputime_last_delta))
 		return (__force u64) ct *
-			__get_cpu_var(cputime_scaled_last_delta) /
-			__get_cpu_var(cputime_last_delta);
+			__this_cpu_read(cputime_scaled_last_delta) /
+			__this_cpu_read(cputime_last_delta);
 	return ct;
 }
 
diff -puN arch/powerpc/include/asm/hardirq.h~powerpc-replace-__get_cpu_var-uses arch/powerpc/include/asm/hardirq.h
--- a/arch/powerpc/include/asm/hardirq.h~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/include/asm/hardirq.h
@@ -20,7 +20,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define __ARCH_IRQ_STAT
 
-#define local_softirq_pending()	__get_cpu_var(irq_stat).__softirq_pending
+#define local_softirq_pending()	__this_cpu_read(irq_stat.__softirq_pending)
 
 static inline void ack_bad_irq(unsigned int irq)
 {
diff -puN arch/powerpc/include/asm/tlbflush.h~powerpc-replace-__get_cpu_var-uses arch/powerpc/include/asm/tlbflush.h
--- a/arch/powerpc/include/asm/tlbflush.h~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/include/asm/tlbflush.h
@@ -107,14 +107,14 @@ extern void __flush_tlb_pending(struct p
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	batch->active = 1;
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
diff -puN arch/powerpc/include/asm/xics.h~powerpc-replace-__get_cpu_var-uses arch/powerpc/include/asm/xics.h
--- a/arch/powerpc/include/asm/xics.h~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/include/asm/xics.h
@@ -97,7 +97,7 @@ DECLARE_PER_CPU(struct xics_cppr, xics_c
 
 static inline void xics_push_cppr(unsigned int vec)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	if (WARN_ON(os_cppr->index >= MAX_NUM_PRIORITIES - 1))
 		return;
@@ -110,7 +110,7 @@ static inline void xics_push_cppr(unsign
 
 static inline unsigned char xics_pop_cppr(void)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	if (WARN_ON(os_cppr->index < 1))
 		return LOWEST_PRIORITY;
@@ -120,7 +120,7 @@ static inline unsigned char xics_pop_cpp
 
 static inline void xics_set_base_cppr(unsigned char cppr)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	/* we only really want to set the priority when there's
 	 * just one cppr value on the stack
@@ -132,7 +132,7 @@ static inline void xics_set_base_cppr(un
 
 static inline unsigned char xics_cppr_top(void)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 	
 	return os_cppr->stack[os_cppr->index];
 }
diff -puN arch/powerpc/kernel/dbell.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/dbell.c
--- a/arch/powerpc/kernel/dbell.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/dbell.c
@@ -41,7 +41,7 @@ void doorbell_exception(struct pt_regs *
 
 	may_hard_irq_enable();
 
-	__get_cpu_var(irq_stat).doorbell_irqs++;
+	__this_cpu_inc(irq_stat.doorbell_irqs);
 
 	smp_ipi_demux();
 
diff -puN arch/powerpc/kernel/hw_breakpoint.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/hw_breakpoint.c
--- a/arch/powerpc/kernel/hw_breakpoint.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/hw_breakpoint.c
@@ -63,7 +63,7 @@ int hw_breakpoint_slots(int type)
 int arch_install_hw_breakpoint(struct perf_event *bp)
 {
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	struct perf_event **slot = &__get_cpu_var(bp_per_reg);
+	struct perf_event **slot = this_cpu_ptr(&bp_per_reg);
 
 	*slot = bp;
 
@@ -88,7 +88,7 @@ int arch_install_hw_breakpoint(struct pe
  */
 void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 {
-	struct perf_event **slot = &__get_cpu_var(bp_per_reg);
+	struct perf_event **slot = this_cpu_ptr(&bp_per_reg);
 
 	if (*slot != bp) {
 		WARN_ONCE(1, "Can't find the breakpoint");
@@ -226,7 +226,7 @@ int __kprobes hw_breakpoint_handler(stru
 	 */
 	rcu_read_lock();
 
-	bp = __get_cpu_var(bp_per_reg);
+	bp = __this_cpu_read(bp_per_reg);
 	if (!bp)
 		goto out;
 	info = counter_arch_bp(bp);
diff -puN arch/powerpc/kernel/iommu.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/iommu.c
@@ -208,7 +208,7 @@ static unsigned long iommu_range_alloc(s
 	 * We don't need to disable preemption here because any CPU can
 	 * safely use any IOMMU pool.
 	 */
-	pool_nr = __raw_get_cpu_var(iommu_pool_hash) & (tbl->nr_pools - 1);
+	pool_nr = __this_cpu_read(iommu_pool_hash) & (tbl->nr_pools - 1);
 
 	if (largealloc)
 		pool = &(tbl->large_pool);
diff -puN arch/powerpc/kernel/irq.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/irq.c
@@ -114,7 +114,7 @@ static inline notrace void set_soft_enab
 static inline notrace int decrementer_check_overflow(void)
 {
  	u64 now = get_tb_or_rtc();
- 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+	u64 *next_tb = this_cpu_ptr(&decrementers_next_tb);
  
 	return now >= *next_tb;
 }
diff -puN arch/powerpc/kernel/kprobes.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/kprobes.c
@@ -118,7 +118,7 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_saved_msr = kcb->prev_kprobe.saved_msr;
 }
@@ -126,7 +126,7 @@ static void __kprobes restore_previous_k
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_msr = regs->msr;
 }
 
@@ -191,7 +191,7 @@ static int __kprobes kprobe_handler(stru
 				ret = 1;
 				goto no_kprobe;
 			}
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs)) {
 				goto ss_probe;
 			}
diff -puN arch/powerpc/kernel/process.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/process.c
@@ -497,7 +497,7 @@ static inline int set_dawr(struct arch_h
 
 int set_breakpoint(struct arch_hw_breakpoint *brk)
 {
-	__get_cpu_var(current_brk) = *brk;
+	__this_cpu_write(current_brk, *brk);
 
 	if (cpu_has_feature(CPU_FTR_DAWR))
 		return set_dawr(brk);
@@ -811,7 +811,7 @@ struct task_struct *__switch_to(struct t
  * schedule DABR
  */
 #ifndef CONFIG_HAVE_HW_BREAKPOINT
-	if (unlikely(!hw_brk_match(&__get_cpu_var(current_brk), &new->thread.hw_brk)))
+	if (unlikely(!hw_brk_match(this_cpu_ptr(&current_brk), &new->thread.hw_brk)))
 		set_breakpoint(&new->thread.hw_brk);
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 #endif
@@ -825,7 +825,7 @@ struct task_struct *__switch_to(struct t
 	 * Collect processor utilization data per process
 	 */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
+		struct cpu_usage *cu = this_cpu_ptr(&cpu_usage_array);
 		long unsigned start_tb, current_tb;
 		start_tb = old_thread->start_tb;
 		cu->current_tb = current_tb = mfspr(SPRN_PURR);
@@ -835,7 +835,7 @@ struct task_struct *__switch_to(struct t
 #endif /* CONFIG_PPC64 */
 
 #ifdef CONFIG_PPC_BOOK3S_64
-	batch = &__get_cpu_var(ppc64_tlb_batch);
+	batch = this_cpu_ptr(&ppc64_tlb_batch);
 	if (batch->active) {
 		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
 		if (batch->index)
@@ -858,7 +858,7 @@ struct task_struct *__switch_to(struct t
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
 		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
-		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch = this_cpu_ptr(&ppc64_tlb_batch);
 		batch->active = 1;
 	}
 #endif /* CONFIG_PPC_BOOK3S_64 */
diff -puN arch/powerpc/kernel/smp.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/smp.c
@@ -240,7 +240,7 @@ void smp_muxed_ipi_message_pass(int cpu,
 
 irqreturn_t smp_ipi_demux(void)
 {
-	struct cpu_messages *info = &__get_cpu_var(ipi_message);
+	struct cpu_messages *info = this_cpu_ptr(&ipi_message);
 	unsigned int all;
 
 	mb();	/* order any irq clear */
@@ -420,9 +420,9 @@ void generic_mach_cpu_die(void)
 	idle_task_exit();
 	cpu = smp_processor_id();
 	printk(KERN_DEBUG "CPU%d offline\n", cpu);
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);
 	smp_wmb();
-	while (__get_cpu_var(cpu_state) != CPU_UP_PREPARE)
+	while (__this_cpu_read(cpu_state) != CPU_UP_PREPARE)
 		cpu_relax();
 }
 
diff -puN arch/powerpc/kernel/sysfs.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/sysfs.c
@@ -394,10 +394,10 @@ void ppc_enable_pmcs(void)
 	ppc_set_pmu_inuse(1);
 
 	/* Only need to enable them once */
-	if (__get_cpu_var(pmcs_enabled))
+	if (__this_cpu_read(pmcs_enabled))
 		return;
 
-	__get_cpu_var(pmcs_enabled) = 1;
+	__this_cpu_write(pmcs_enabled, 1);
 
 	if (ppc_md.enable_pmcs)
 		ppc_md.enable_pmcs();
diff -puN arch/powerpc/kernel/time.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/time.c
@@ -457,9 +457,9 @@ static inline void clear_irq_work_pendin
 
 DEFINE_PER_CPU(u8, irq_work_pending);
 
-#define set_irq_work_pending_flag()	__get_cpu_var(irq_work_pending) = 1
-#define test_irq_work_pending()		__get_cpu_var(irq_work_pending)
-#define clear_irq_work_pending()	__get_cpu_var(irq_work_pending) = 0
+#define set_irq_work_pending_flag()	__this_cpu_write(irq_work_pending, 1)
+#define test_irq_work_pending()		__this_cpu_read(irq_work_pending)
+#define clear_irq_work_pending()	__this_cpu_write(irq_work_pending, 0)
 
 #endif /* 32 vs 64 bit */
 
@@ -485,8 +485,8 @@ void arch_irq_work_raise(void)
 void timer_interrupt(struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
-	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
-	struct clock_event_device *evt = &__get_cpu_var(decrementers);
+	u64 *next_tb = this_cpu_ptr(&decrementers_next_tb);
+	struct clock_event_device *evt = this_cpu_ptr(&decrementers);
 	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
@@ -545,7 +545,7 @@ void timer_interrupt(struct pt_regs * re
 #ifdef CONFIG_PPC64
 	/* collect purr register values often, for accurate calculations */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
+		struct cpu_usage *cu = this_cpu_ptr(&cpu_usage_array);
 		cu->current_tb = mfspr(SPRN_PURR);
 	}
 #endif
@@ -808,7 +808,7 @@ static int decrementer_set_next_event(un
 	/* Don't adjust the decrementer if some irq work is pending */
 	if (test_irq_work_pending())
 		return 0;
-	__get_cpu_var(decrementers_next_tb) = get_tb_or_rtc() + evt;
+	__this_cpu_write(decrementers_next_tb, get_tb_or_rtc() + evt);
 	set_dec(evt);
 
 	/* We may have raced with new irq work */
diff -puN arch/powerpc/kernel/traps.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kernel/traps.c
@@ -688,7 +688,7 @@ void machine_check_exception(struct pt_r
 	enum ctx_state prev_state = exception_enter();
 	int recover = 0;
 
-	__get_cpu_var(irq_stat).mce_exceptions++;
+	__this_cpu_inc(irq_stat.mce_exceptions);
 
 	/* See if any machine dependent calls. In theory, we would want
 	 * to call the CPU first, and call the ppc_md. one if the CPU
@@ -1492,7 +1492,7 @@ void vsx_unavailable_tm(struct pt_regs *
 
 void performance_monitor_exception(struct pt_regs *regs)
 {
-	__get_cpu_var(irq_stat).pmu_irqs++;
+	__this_cpu_inc(irq_stat.pmu_irqs);
 
 	perf_irq(regs);
 }
diff -puN arch/powerpc/kvm/e500.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kvm/e500.c
--- a/arch/powerpc/kvm/e500.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kvm/e500.c
@@ -76,11 +76,11 @@ static inline int local_sid_setup_one(st
 	unsigned long sid;
 	int ret = -1;
 
-	sid = ++(__get_cpu_var(pcpu_last_used_sid));
+	sid = __this_cpu_inc_return(pcpu_last_used_sid);
 	if (sid < NUM_TIDS) {
-		__get_cpu_var(pcpu_sids).entry[sid] = entry;
+		__this_cpu_write(pcpu_sids)entry[sid], entry);
 		entry->val = sid;
-		entry->pentry = &__get_cpu_var(pcpu_sids).entry[sid];
+		entry->pentry = this_cpu_ptr(&pcpu_sids.entry[sid]);
 		ret = sid;
 	}
 
@@ -108,8 +108,8 @@ static inline int local_sid_setup_one(st
 static inline int local_sid_lookup(struct id *entry)
 {
 	if (entry && entry->val != 0 &&
-	    __get_cpu_var(pcpu_sids).entry[entry->val] == entry &&
-	    entry->pentry == &__get_cpu_var(pcpu_sids).entry[entry->val])
+	    __this_cpu_read(pcpu_sids.entry[entry->val]) == entry &&
+	    entry->pentry == this_cpu_ptr(&pcpu_sids.entry[entry->val]))
 		return entry->val;
 	return -1;
 }
@@ -117,8 +117,8 @@ static inline int local_sid_lookup(struc
 /* Invalidate all id mappings on local core -- call with preempt disabled */
 static inline void local_sid_destroy_all(void)
 {
-	__get_cpu_var(pcpu_last_used_sid) = 0;
-	memset(&__get_cpu_var(pcpu_sids), 0, sizeof(__get_cpu_var(pcpu_sids)));
+	__this_cpu_write(pcpu_last_used_sid, 0);
+	memset(this_cpu_ptr(&pcpu_sids), 0, sizeof(pcpu_sids));
 }
 
 static void *kvmppc_e500_id_table_alloc(struct kvmppc_vcpu_e500 *vcpu_e500)
diff -puN arch/powerpc/kvm/e500mc.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/kvm/e500mc.c
--- a/arch/powerpc/kvm/e500mc.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/kvm/e500mc.c
@@ -141,9 +141,9 @@ static void kvmppc_core_vcpu_load_e500mc
 	mtspr(SPRN_GESR, vcpu->arch.shared->esr);
 
 	if (vcpu->arch.oldpir != mfspr(SPRN_PIR) ||
-	    __get_cpu_var(last_vcpu_on_cpu) != vcpu) {
+	    __this_cpu_read(last_vcpu_on_cpu) != vcpu) {
 		kvmppc_e500_tlbil_all(vcpu_e500);
-		__get_cpu_var(last_vcpu_on_cpu) = vcpu;
+		__this_cpu_read(last_vcpu_on_cpu) = vcpu;
 	}
 
 	kvmppc_load_guest_fp(vcpu);
diff -puN arch/powerpc/mm/hash_native_64.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/mm/hash_native_64.c
--- a/arch/powerpc/mm/hash_native_64.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/mm/hash_native_64.c
@@ -649,7 +649,7 @@ static void native_flush_hash_range(unsi
 	unsigned long want_v;
 	unsigned long flags;
 	real_pte_t pte;
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 	unsigned long psize = batch->psize;
 	int ssize = batch->ssize;
 	int i;
diff -puN arch/powerpc/mm/hash_utils_64.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -1298,7 +1298,7 @@ void flush_hash_range(unsigned long numb
 	else {
 		int i;
 		struct ppc64_tlb_batch *batch =
-			&__get_cpu_var(ppc64_tlb_batch);
+			this_cpu_ptr(&ppc64_tlb_batch);
 
 		for (i = 0; i < number; i++)
 			flush_hash_page(batch->vpn[i], batch->pte[i],
diff -puN arch/powerpc/mm/hugetlbpage-book3e.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/mm/hugetlbpage-book3e.c
--- a/arch/powerpc/mm/hugetlbpage-book3e.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/mm/hugetlbpage-book3e.c
@@ -37,9 +37,9 @@ static inline int tlb1_next(void)
 
 	/* Just round-robin the entries and wrap when we hit the end */
 	if (unlikely(index == ncams - 1))
-		__get_cpu_var(next_tlbcam_idx) = tlbcam_index;
+		__this_cpu_write(next_tlbcam_idx, tlbcam_index);
 	else
-		__get_cpu_var(next_tlbcam_idx)++;
+		__this_cpu_inc(next_tlbcam_idx);
 
 	return index;
 }
diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -472,7 +472,7 @@ static void hugepd_free(struct mmu_gathe
 {
 	struct hugepd_freelist **batchp;
 
-	batchp = &get_cpu_var(hugepd_freelist_cur);
+	batchp = this_cpu_ptr(&hugepd_freelist_cur);
 
 	if (atomic_read(&tlb->mm->mm_users) < 2 ||
 	    cpumask_equal(mm_cpumask(tlb->mm),
diff -puN arch/powerpc/mm/stab.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/mm/stab.c
--- a/arch/powerpc/mm/stab.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/mm/stab.c
@@ -133,12 +133,12 @@ static int __ste_allocate(unsigned long
 	stab_entry = make_ste(get_paca()->stab_addr, GET_ESID(ea), vsid);
 
 	if (!is_kernel_addr(ea)) {
-		offset = __get_cpu_var(stab_cache_ptr);
+		offset = __this_cpu_read(stab_cache_ptr);
 		if (offset < NR_STAB_CACHE_ENTRIES)
-			__get_cpu_var(stab_cache[offset++]) = stab_entry;
+			__this_cpu_read(stab_cache[offset++]) = stab_entry;
 		else
 			offset = NR_STAB_CACHE_ENTRIES+1;
-		__get_cpu_var(stab_cache_ptr) = offset;
+		__this_cpu_write(stab_cache_ptr, offset);
 
 		/* Order update */
 		asm volatile("sync":::"memory");
@@ -177,12 +177,12 @@ void switch_stab(struct task_struct *tsk
 	 */
 	hard_irq_disable();
 
-	offset = __get_cpu_var(stab_cache_ptr);
+	offset = __this_cpu_read(stab_cache_ptr);
 	if (offset <= NR_STAB_CACHE_ENTRIES) {
 		int i;
 
 		for (i = 0; i < offset; i++) {
-			ste = stab + __get_cpu_var(stab_cache[i]);
+			ste = stab + __this_cpu_read(stab_cache[i]);
 			ste->esid_data = 0; /* invalidate entry */
 		}
 	} else {
@@ -206,7 +206,7 @@ void switch_stab(struct task_struct *tsk
 
 	asm volatile("sync; slbia; sync":::"memory");
 
-	__get_cpu_var(stab_cache_ptr) = 0;
+	__this_cpu_write(stab_cache_ptr, 0);
 
 	/* Now preload some entries for the new task */
 	if (test_tsk_thread_flag(tsk, TIF_32BIT))
diff -puN arch/powerpc/perf/core-book3s.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/perf/core-book3s.c
--- a/arch/powerpc/perf/core-book3s.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/perf/core-book3s.c
@@ -332,7 +332,7 @@ static void power_pmu_bhrb_reset(void)
 
 static void power_pmu_bhrb_enable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!ppmu->bhrb_nr)
 		return;
@@ -347,7 +347,7 @@ static void power_pmu_bhrb_enable(struct
 
 static void power_pmu_bhrb_disable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!ppmu->bhrb_nr)
 		return;
@@ -961,7 +961,7 @@ static void power_pmu_disable(struct pmu
 	if (!ppmu)
 		return;
 	local_irq_save(flags);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuhw->disabled) {
 		/*
@@ -1027,7 +1027,7 @@ static void power_pmu_enable(struct pmu
 		return;
 	local_irq_save(flags);
 
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	if (!cpuhw->disabled)
 		goto out;
 
@@ -1212,7 +1212,7 @@ static int power_pmu_add(struct perf_eve
 	 * Add the event to the list (if there is room)
 	 * and check whether the total set is still feasible.
 	 */
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	n0 = cpuhw->n_events;
 	if (n0 >= ppmu->n_counter)
 		goto out;
@@ -1278,7 +1278,7 @@ static void power_pmu_del(struct perf_ev
 
 	power_pmu_read(event);
 
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	for (i = 0; i < cpuhw->n_events; ++i) {
 		if (event == cpuhw->event[i]) {
 			while (++i < cpuhw->n_events) {
@@ -1384,7 +1384,7 @@ static void power_pmu_stop(struct perf_e
  */
 void power_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	perf_pmu_disable(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
@@ -1398,7 +1398,7 @@ void power_pmu_start_txn(struct pmu *pmu
  */
 void power_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 	perf_pmu_enable(pmu);
@@ -1416,7 +1416,7 @@ int power_pmu_commit_txn(struct pmu *pmu
 
 	if (!ppmu)
 		return -EAGAIN;
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	n = cpuhw->n_events;
 	if (check_excludes(cpuhw->event, cpuhw->flags, 0, n))
 		return -EAGAIN;
@@ -1773,7 +1773,7 @@ static void record_and_restart(struct pe
 
 		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK) {
 			struct cpu_hw_events *cpuhw;
-			cpuhw = &__get_cpu_var(cpu_hw_events);
+			cpuhw = this_cpu_ptr(&cpu_hw_events);
 			power_pmu_bhrb_read(cpuhw);
 			data.br_stack = &cpuhw->bhrb_stack;
 		}
@@ -1846,7 +1846,7 @@ static bool pmc_overflow(unsigned long v
 static void perf_event_interrupt(struct pt_regs *regs)
 {
 	int i, j;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	unsigned long val[8];
 	int found, active;
diff -puN arch/powerpc/perf/core-fsl-emb.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/perf/core-fsl-emb.c
--- a/arch/powerpc/perf/core-fsl-emb.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/perf/core-fsl-emb.c
@@ -210,7 +210,7 @@ static void fsl_emb_pmu_disable(struct p
 	unsigned long flags;
 
 	local_irq_save(flags);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuhw->disabled) {
 		cpuhw->disabled = 1;
@@ -249,7 +249,7 @@ static void fsl_emb_pmu_enable(struct pm
 	unsigned long flags;
 
 	local_irq_save(flags);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	if (!cpuhw->disabled)
 		goto out;
 
@@ -653,7 +653,7 @@ static void record_and_restart(struct pe
 static void perf_event_interrupt(struct pt_regs *regs)
 {
 	int i;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	unsigned long val;
 	int found = 0;
diff -puN arch/powerpc/platforms/cell/interrupt.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/cell/interrupt.c
--- a/arch/powerpc/platforms/cell/interrupt.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/cell/interrupt.c
@@ -82,7 +82,7 @@ static void iic_unmask(struct irq_data *
 
 static void iic_eoi(struct irq_data *d)
 {
-	struct iic *iic = &__get_cpu_var(cpu_iic);
+	struct iic *iic = this_cpu_ptr(&cpu_iic);
 	out_be64(&iic->regs->prio, iic->eoi_stack[--iic->eoi_ptr]);
 	BUG_ON(iic->eoi_ptr < 0);
 }
@@ -148,7 +148,7 @@ static unsigned int iic_get_irq(void)
 	struct iic *iic;
 	unsigned int virq;
 
-	iic = &__get_cpu_var(cpu_iic);
+	iic = this_cpu_ptr(&cpu_iic);
 	*(unsigned long *) &pending =
 		in_be64((u64 __iomem *) &iic->regs->pending_destr);
 	if (!(pending.flags & CBE_IIC_IRQ_VALID))
@@ -163,7 +163,7 @@ static unsigned int iic_get_irq(void)
 
 void iic_setup_cpu(void)
 {
-	out_be64(&__get_cpu_var(cpu_iic).regs->prio, 0xff);
+	out_be64(this_cpu_ptr(&cpu_iic.regs->prio), 0xff);
 }
 
 u8 iic_get_target_id(int cpu)
diff -puN arch/powerpc/platforms/ps3/interrupt.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/ps3/interrupt.c
--- a/arch/powerpc/platforms/ps3/interrupt.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/ps3/interrupt.c
@@ -711,7 +711,7 @@ void __init ps3_register_ipi_irq(unsigne
 
 static unsigned int ps3_get_irq(void)
 {
-	struct ps3_private *pd = &__get_cpu_var(ps3_private);
+	struct ps3_private *pd = this_cpu_ptr(&ps3_private);
 	u64 x = (pd->bmp.status & pd->bmp.mask);
 	unsigned int plug;
 
diff -puN arch/powerpc/platforms/pseries/dtl.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/pseries/dtl.c
--- a/arch/powerpc/platforms/pseries/dtl.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/pseries/dtl.c
@@ -74,7 +74,7 @@ static atomic_t dtl_count;
  */
 static void consume_dtle(struct dtl_entry *dtle, u64 index)
 {
-	struct dtl_ring *dtlr = &__get_cpu_var(dtl_rings);
+	struct dtl_ring *dtlr = this_cpu_ptr(&dtl_rings);
 	struct dtl_entry *wp = dtlr->write_ptr;
 	struct lppaca *vpa = local_paca->lppaca_ptr;
 
diff -puN arch/powerpc/platforms/pseries/hvCall_inst.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/pseries/hvCall_inst.c
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -109,7 +109,7 @@ static void probe_hcall_entry(void *igno
 	if (opcode > MAX_HCALL_OPCODE)
 		return;
 
-	h = &__get_cpu_var(hcall_stats)[opcode / 4];
+	h = this_cpu_ptr(&hcall_stats[opcode / 4]);
 	h->tb_start = mftb();
 	h->purr_start = mfspr(SPRN_PURR);
 }
@@ -122,7 +122,7 @@ static void probe_hcall_exit(void *ignor
 	if (opcode > MAX_HCALL_OPCODE)
 		return;
 
-	h = &__get_cpu_var(hcall_stats)[opcode / 4];
+	h = this_cpu_ptr(&hcall_stats[opcode / 4]);
 	h->num_calls++;
 	h->tb_total += mftb() - h->tb_start;
 	h->purr_total += mfspr(SPRN_PURR) - h->purr_start;
diff -puN arch/powerpc/platforms/pseries/iommu.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/pseries/iommu.c
--- a/arch/powerpc/platforms/pseries/iommu.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/pseries/iommu.c
@@ -200,7 +200,7 @@ static int tce_buildmulti_pSeriesLP(stru
 
 	local_irq_save(flags);	/* to protect tcep and the page behind it */
 
-	tcep = __get_cpu_var(tce_page);
+	tcep = __this_cpu_read(tce_page);
 
 	/* This is safe to do since interrupts are off when we're called
 	 * from iommu_alloc{,_sg}()
@@ -213,7 +213,7 @@ static int tce_buildmulti_pSeriesLP(stru
 			return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
 					    direction, attrs);
 		}
-		__get_cpu_var(tce_page) = tcep;
+		__this_cpu_write(tce_page, tcep);
 	}
 
 	rpn = __pa(uaddr) >> TCE_SHIFT;
@@ -399,7 +399,7 @@ static int tce_setrange_multi_pSeriesLP(
 	long l, limit;
 
 	local_irq_disable();	/* to protect tcep and the page behind it */
-	tcep = __get_cpu_var(tce_page);
+	tcep = __this_cpu_read(tce_page);
 
 	if (!tcep) {
 		tcep = (__be64 *)__get_free_page(GFP_ATOMIC);
@@ -407,7 +407,7 @@ static int tce_setrange_multi_pSeriesLP(
 			local_irq_enable();
 			return -ENOMEM;
 		}
-		__get_cpu_var(tce_page) = tcep;
+		__this_cpu_write(tce_page, tcep);
 	}
 
 	proto_tce = TCE_PCI_READ | TCE_PCI_WRITE;
diff -puN arch/powerpc/platforms/pseries/lpar.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/pseries/lpar.c
--- a/arch/powerpc/platforms/pseries/lpar.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/pseries/lpar.c
@@ -514,7 +514,7 @@ static void pSeries_lpar_flush_hash_rang
 	unsigned long vpn;
 	unsigned long i, pix, rc;
 	unsigned long flags = 0;
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 	int lock_tlbie = !mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE);
 	unsigned long param[9];
 	unsigned long hash, index, shift, hidx, slot;
@@ -689,7 +689,7 @@ void __trace_hcall_entry(unsigned long o
 
 	local_irq_save(flags);
 
-	depth = &__get_cpu_var(hcall_trace_depth);
+	depth = this_cpu_ptr(&hcall_trace_depth);
 
 	if (*depth)
 		goto out;
@@ -714,7 +714,7 @@ void __trace_hcall_exit(long opcode, uns
 
 	local_irq_save(flags);
 
-	depth = &__get_cpu_var(hcall_trace_depth);
+	depth = this_cpu_ptr(&hcall_trace_depth);
 
 	if (*depth)
 		goto out;
diff -puN arch/powerpc/platforms/pseries/ras.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/platforms/pseries/ras.c
--- a/arch/powerpc/platforms/pseries/ras.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/platforms/pseries/ras.c
@@ -301,8 +301,8 @@ static struct rtas_error_log *fwnmi_get_
 	/* If it isn't an extended log we can use the per cpu 64bit buffer */
 	h = (struct rtas_error_log *)&savep[1];
 	if (!h->extended) {
-		memcpy(&__get_cpu_var(mce_data_buf), h, sizeof(__u64));
-		errhdr = (struct rtas_error_log *)&__get_cpu_var(mce_data_buf);
+		memcpy(this_cpu_ptr(&mce_data_buf), h, sizeof(__u64));
+		errhdr = (struct rtas_error_log *)this_cpu_ptr(&mce_data_buf);
 	} else {
 		int len;
 
diff -puN arch/powerpc/sysdev/xics/xics-common.c~powerpc-replace-__get_cpu_var-uses arch/powerpc/sysdev/xics/xics-common.c
--- a/arch/powerpc/sysdev/xics/xics-common.c~powerpc-replace-__get_cpu_var-uses
+++ a/arch/powerpc/sysdev/xics/xics-common.c
@@ -155,7 +155,7 @@ int __init xics_smp_probe(void)
 
 void xics_teardown_cpu(void)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	/*
 	 * we have to reset the cppr index to 0 because we're
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

