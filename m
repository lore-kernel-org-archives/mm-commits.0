From: akpm@linux-foundation.org
Subject: + x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch added to -mm tree
Date: Fri, 13 Jan 2012 15:16:40 -0800
Message-ID: <20120113231641.09B1E5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62264 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 18:16:43 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so29015eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 15:16:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, cl@gentwo.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org


The patch titled
     Subject: x86: use this_cpu_xxx to replace percpu_xxx funcs
has been added to the -mm tree.  Its filename is
     x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: x86: use this_cpu_xxx to replace percpu_xxx funcs

Since percpu_xxx() serial functions are duplicate with this_cpu_xxx(). 
Removing percpu_xxx() definition and replacing them by this_cpu_xxx() in
code.

And further more, as Christoph Lameter's requirement, I try to use
__this_cpu_xx to replace this_cpu_xxx if it is in preempt safe scenario.
The preempt safe scenarios include:
1, in irq/softirq/nmi handler
2, protected by preempt_disable
3, protected by spin_lock
4, if the code context imply that it is preempt safe, like the code is
follows or be followed a preempt safe code.

BTW, In fact, this_cpu_xxx are same as __this_cpu_xxx since all funcs
implement in a single instruction for x86 machine.  But it maybe other
platforms' performance.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/hardirq.h        |    9 +++++----
 arch/x86/include/asm/irq_regs.h       |    4 ++--
 arch/x86/include/asm/mmu_context.h    |   12 ++++++------
 arch/x86/include/asm/percpu.h         |    2 +-
 arch/x86/include/asm/smp.h            |    4 ++--
 arch/x86/include/asm/stackprotector.h |    4 ++--
 arch/x86/include/asm/tlbflush.h       |    4 ++--
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    4 ++--
 arch/x86/kernel/paravirt.c            |   12 ++++++------
 arch/x86/kernel/process_32.c          |    2 +-
 arch/x86/kernel/process_64.c          |   12 ++++++------
 arch/x86/mm/tlb.c                     |   10 +++++-----
 include/linux/topology.h              |    4 ++--
 14 files changed, 43 insertions(+), 42 deletions(-)

diff -puN arch/x86/include/asm/hardirq.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/hardirq.h
--- a/arch/x86/include/asm/hardirq.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/hardirq.h
@@ -36,14 +36,15 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
+#define inc_irq_stat(member)	__this_cpu_inc(irq_stat.member)
 
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+#define local_softirq_pending()	__this_cpu_read(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING
 
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+#define set_softirq_pending(x)	\
+		__this_cpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)	__this_cpu_or(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
diff -puN arch/x86/include/asm/irq_regs.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/irq_regs.h
--- a/arch/x86/include/asm/irq_regs.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/irq_regs.h
@@ -15,7 +15,7 @@ DECLARE_PER_CPU(struct pt_regs *, irq_re
 
 static inline struct pt_regs *get_irq_regs(void)
 {
-	return percpu_read(irq_regs);
+	return __this_cpu_read(irq_regs);
 }
 
 static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
@@ -23,7 +23,7 @@ static inline struct pt_regs *set_irq_re
 	struct pt_regs *old_regs;
 
 	old_regs = get_irq_regs();
-	percpu_write(irq_regs, new_regs);
+	__this_cpu_write(irq_regs, new_regs);
 
 	return old_regs;
 }
diff -puN arch/x86/include/asm/mmu_context.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/mmu_context.h
--- a/arch/x86/include/asm/mmu_context.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/mmu_context.h
@@ -25,8 +25,8 @@ void destroy_context(struct mm_struct *m
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
-		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
+	if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		__this_cpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -37,8 +37,8 @@ static inline void switch_mm(struct mm_s
 
 	if (likely(prev != next)) {
 #ifdef CONFIG_SMP
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		percpu_write(cpu_tlbstate.active_mm, next);
+		__this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		__this_cpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpumask_set_cpu(cpu, mm_cpumask(next));
 
@@ -56,8 +56,8 @@ static inline void switch_mm(struct mm_s
 	}
 #ifdef CONFIG_SMP
 	else {
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
+		__this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(__this_cpu_read(cpu_tlbstate.active_mm) != next);
 
 		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
 			/* We were in lazy tlb mode and leave_mm disabled
diff -puN arch/x86/include/asm/percpu.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/percpu.h
@@ -46,7 +46,7 @@
 
 #ifdef CONFIG_SMP
 #define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
-#define __my_cpu_offset		percpu_read(this_cpu_off)
+#define __my_cpu_offset		__this_cpu_read(this_cpu_off)
 
 /*
  * Compared to the generic __my_cpu_offset version, the following
diff -puN arch/x86/include/asm/smp.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/smp.h
--- a/arch/x86/include/asm/smp.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/smp.h
@@ -188,11 +188,11 @@ extern unsigned disabled_cpus __cpuinitd
  * from the initial startup. We map APIC_BASE very early in page_setup(),
  * so this is correct in the x86 case.
  */
-#define raw_smp_processor_id() (percpu_read(cpu_number))
+#define raw_smp_processor_id() (this_cpu_read(cpu_number))
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id() (percpu_read(cpu_number))
+#define raw_smp_processor_id() (this_cpu_read(cpu_number))
 
 #define stack_smp_processor_id()					\
 ({								\
diff -puN arch/x86/include/asm/stackprotector.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/stackprotector.h
--- a/arch/x86/include/asm/stackprotector.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/stackprotector.h
@@ -76,9 +76,9 @@ static __always_inline void boot_init_st
 
 	current->stack_canary = canary;
 #ifdef CONFIG_X86_64
-	percpu_write(irq_stack_union.stack_canary, canary);
+	__this_cpu_write(irq_stack_union.stack_canary, canary);
 #else
-	percpu_write(stack_canary.canary, canary);
+	__this_cpu_write(stack_canary.canary, canary);
 #endif
 }
 
diff -puN arch/x86/include/asm/tlbflush.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/include/asm/tlbflush.h
@@ -156,8 +156,8 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct tl
 
 static inline void reset_lazy_tlbstate(void)
 {
-	percpu_write(cpu_tlbstate.state, 0);
-	percpu_write(cpu_tlbstate.active_mm, &init_mm);
+	__this_cpu_write(cpu_tlbstate.state, 0);
+	__this_cpu_write(cpu_tlbstate.active_mm, &init_mm);
 }
 
 #endif	/* SMP */
diff -puN arch/x86/kernel/cpu/common.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/kernel/cpu/common.c
@@ -1189,7 +1189,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (cpu != 0 && __this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
diff -puN arch/x86/kernel/cpu/mcheck/mce.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -562,7 +562,7 @@ void machine_check_poll(enum mcp_flags f
 	struct mce m;
 	int i;
 
-	percpu_inc(mce_poll_count);
+	__this_cpu_inc(mce_poll_count);
 
 	mce_gather_info(&m, NULL);
 
@@ -954,7 +954,7 @@ void do_machine_check(struct pt_regs *re
 
 	atomic_inc(&mce_entry);
 
-	percpu_inc(mce_exception_count);
+	__this_cpu_inc(mce_exception_count);
 
 	if (!banks)
 		goto out;
diff -puN arch/x86/kernel/paravirt.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/kernel/paravirt.c
@@ -239,16 +239,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(percpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(__this_cpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 
-	percpu_write(paravirt_lazy_mode, mode);
+	__this_cpu_write(paravirt_lazy_mode, mode);
 }
 
 static void leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(percpu_read(paravirt_lazy_mode) != mode);
+	BUG_ON(__this_cpu_read(paravirt_lazy_mode) != mode);
 
-	percpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
+	__this_cpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -265,7 +265,7 @@ void paravirt_start_context_switch(struc
 {
 	BUG_ON(preemptible());
 
-	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+	if (__this_cpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
 		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
@@ -287,7 +287,7 @@ enum paravirt_lazy_mode paravirt_get_laz
 	if (in_interrupt())
 		return PARAVIRT_LAZY_NONE;
 
-	return percpu_read(paravirt_lazy_mode);
+	return __this_cpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
diff -puN arch/x86/kernel/process_32.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/kernel/process_32.c
@@ -377,7 +377,7 @@ __switch_to(struct task_struct *prev_p, 
 	if (prev->gs | next->gs)
 		lazy_load_gs(next->gs);
 
-	percpu_write(current_task, next_p);
+	__this_cpu_write(current_task, next_p);
 
 	return prev_p;
 }
diff -puN arch/x86/kernel/process_64.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/kernel/process_64.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregist
 
 void enter_idle(void)
 {
-	percpu_write(is_idle, 1);
+	__this_cpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
@@ -343,7 +343,7 @@ start_thread_common(struct pt_regs *regs
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	percpu_write(old_rsp, new_sp);
+	this_cpu_write(old_rsp, new_sp);
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
@@ -477,11 +477,11 @@ __switch_to(struct task_struct *prev_p, 
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = percpu_read(old_rsp);
-	percpu_write(old_rsp, next->usersp);
-	percpu_write(current_task, next_p);
+	prev->usersp = __this_cpu_read(old_rsp);
+	__this_cpu_write(old_rsp, next->usersp);
+	__this_cpu_write(current_task, next_p);
 
-	percpu_write(kernel_stack,
+	__this_cpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 
diff -puN arch/x86/mm/tlb.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/arch/x86/mm/tlb.c
@@ -61,10 +61,10 @@ static DEFINE_PER_CPU_READ_MOSTLY(int, t
  */
 void leave_mm(int cpu)
 {
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+	if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
 	cpumask_clear_cpu(cpu,
-			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
+			  mm_cpumask(__this_cpu_read(cpu_tlbstate.active_mm)));
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -152,8 +152,8 @@ void smp_invalidate_interrupt(struct pt_
 		 * BUG();
 		 */
 
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+	if (f->flush_mm == __this_cpu_read(cpu_tlbstate.active_mm)) {
+		if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -322,7 +322,7 @@ void flush_tlb_page(struct vm_area_struc
 static void do_flush_tlb_all(void *info)
 {
 	__flush_tlb_all();
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
+	if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
 }
 
diff -puN include/linux/topology.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs include/linux/topology.h
--- a/include/linux/topology.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs
+++ a/include/linux/topology.h
@@ -239,7 +239,7 @@ static inline int cpu_to_node(int cpu)
 #ifndef set_numa_node
 static inline void set_numa_node(int node)
 {
-	percpu_write(numa_node, node);
+	__this_cpu_write(numa_node, node);
 }
 #endif
 
@@ -274,7 +274,7 @@ DECLARE_PER_CPU(int, _numa_mem_);
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
-	percpu_write(_numa_mem_, node);
+	__this_cpu_write(_numa_mem_, node);
 }
 #endif
 
_
Subject: Subject: x86: use this_cpu_xxx to replace percpu_xxx funcs

Patches currently in -mm which might be from alex.shi@intel.com are

origin.patch
net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
xen-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
percpu-remove-percpu_xxx-functions.patch

