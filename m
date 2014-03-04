From: akpm@linux-foundation.org
Subject: + x86-replace-__get_cpu_var-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:38 -0800
Message-ID: <5316535a.otsSIX1gErksWSaU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbaCDW1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@kernel.org, hpa@linux.intel.com, cl@linux.com

Subject: + x86-replace-__get_cpu_var-uses.patch added to -mm tree
To: cl@linux.com,hpa@linux.intel.com,mingo@kernel.org,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:38 -0800


The patch titled
     Subject: x86: replace __get_cpu_var uses
has been added to the -mm tree.  Its filename is
     x86-replace-__get_cpu_var-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-replace-__get_cpu_var-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-replace-__get_cpu_var-uses.patch

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
Subject: x86: replace __get_cpu_var uses

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
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/debugreg.h            |    4 -
 arch/x86/include/asm/perf_event_p4.h       |    2 
 arch/x86/include/asm/uv/uv_hub.h           |    2 
 arch/x86/kernel/apb_timer.c                |    4 -
 arch/x86/kernel/apic/apic.c                |    4 -
 arch/x86/kernel/apic/x2apic_cluster.c      |    2 
 arch/x86/kernel/cpu/common.c               |    6 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c    |    6 +-
 arch/x86/kernel/cpu/mcheck/mce.c           |   44 +++++++++----------
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |    2 
 arch/x86/kernel/cpu/mcheck/mce_intel.c     |   20 ++++----
 arch/x86/kernel/cpu/perf_event.c           |   22 ++++-----
 arch/x86/kernel/cpu/perf_event_amd.c       |    4 -
 arch/x86/kernel/cpu/perf_event_intel.c     |   18 +++----
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   20 ++++----
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   12 ++---
 arch/x86/kernel/cpu/perf_event_knc.c       |    2 
 arch/x86/kernel/cpu/perf_event_p4.c        |    6 +-
 arch/x86/kernel/hw_breakpoint.c            |    8 +--
 arch/x86/kernel/irq_64.c                   |    6 +-
 arch/x86/kernel/kvm.c                      |   22 ++++-----
 arch/x86/kvm/svm.c                         |    6 +-
 arch/x86/kvm/vmx.c                         |   10 ++--
 arch/x86/kvm/x86.c                         |    2 
 arch/x86/mm/kmemcheck/kmemcheck.c          |   14 +++---
 arch/x86/oprofile/nmi_int.c                |    8 +--
 arch/x86/oprofile/op_model_p4.c            |    2 
 arch/x86/platform/uv/uv_time.c             |    2 
 arch/x86/xen/enlighten.c                   |    4 -
 arch/x86/xen/multicalls.c                  |    8 +--
 arch/x86/xen/spinlock.c                    |    2 
 arch/x86/xen/time.c                        |   10 ++--
 32 files changed, 142 insertions(+), 142 deletions(-)

diff -puN arch/x86/include/asm/debugreg.h~x86-replace-__get_cpu_var-uses arch/x86/include/asm/debugreg.h
--- a/arch/x86/include/asm/debugreg.h~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/include/asm/debugreg.h
@@ -97,11 +97,11 @@ extern void hw_breakpoint_restore(void);
 DECLARE_PER_CPU(int, debug_stack_usage);
 static inline void debug_stack_usage_inc(void)
 {
-	__get_cpu_var(debug_stack_usage)++;
+	__this_cpu_inc(debug_stack_usage);
 }
 static inline void debug_stack_usage_dec(void)
 {
-	__get_cpu_var(debug_stack_usage)--;
+	__this_cpu_dec(debug_stack_usage);
 }
 int is_debug_stack(unsigned long addr);
 void debug_stack_set_zero(void);
diff -puN arch/x86/include/asm/perf_event_p4.h~x86-replace-__get_cpu_var-uses arch/x86/include/asm/perf_event_p4.h
--- a/arch/x86/include/asm/perf_event_p4.h~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/include/asm/perf_event_p4.h
@@ -189,7 +189,7 @@ static inline int p4_ht_thread(int cpu)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings == 2)
-		return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+		return cpu != cpumask_first(this_cpu_ptr(cpu_sibling_map));
 #endif
 	return 0;
 }
diff -puN arch/x86/include/asm/uv/uv_hub.h~x86-replace-__get_cpu_var-uses arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -164,7 +164,7 @@ struct uv_hub_info_s {
 };
 
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
-#define uv_hub_info		(&__get_cpu_var(__uv_hub_info))
+#define uv_hub_info		this_cpu_ptr(&__uv_hub_info)
 #define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
 
 /*
diff -puN arch/x86/kernel/apb_timer.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/apb_timer.c
--- a/arch/x86/kernel/apb_timer.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/apb_timer.c
@@ -146,7 +146,7 @@ static inline int is_apbt_capable(void)
 static int __init apbt_clockevent_register(void)
 {
 	struct sfi_timer_table_entry *mtmr;
-	struct apbt_dev *adev = &__get_cpu_var(cpu_apbt_dev);
+	struct apbt_dev *adev = this_cpu_ptr(&cpu_apbt_dev);
 
 	mtmr = sfi_get_mtmr(APBT_CLOCKEVENT0_NUM);
 	if (mtmr == NULL) {
@@ -200,7 +200,7 @@ void apbt_setup_secondary_clock(void)
 	if (!cpu)
 		return;
 
-	adev = &__get_cpu_var(cpu_apbt_dev);
+	adev = this_cpu_ptr(&cpu_apbt_dev);
 	if (!adev->timer) {
 		adev->timer = dw_apb_clockevent_init(cpu, adev->name,
 			APBT_CLOCKEVENT_RATING, adev_virt_addr(adev),
diff -puN arch/x86/kernel/apic/apic.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/apic/apic.c
@@ -557,7 +557,7 @@ static DEFINE_PER_CPU(struct clock_event
  */
 static void setup_APIC_timer(void)
 {
-	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+	struct clock_event_device *levt = this_cpu_ptr(&lapic_events);
 
 	if (this_cpu_has(X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
@@ -692,7 +692,7 @@ calibrate_by_pmtimer(long deltapm, long
 
 static int __init calibrate_APIC_clock(void)
 {
-	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+	struct clock_event_device *levt = this_cpu_ptr(&lapic_events);
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
 	long delta, deltatsc;
diff -puN arch/x86/kernel/apic/x2apic_cluster.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/apic/x2apic_cluster.c
--- a/arch/x86/kernel/apic/x2apic_cluster.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/apic/x2apic_cluster.c
@@ -42,7 +42,7 @@ __x2apic_send_IPI_mask(const struct cpum
 	 * We are to modify mask, so we need an own copy
 	 * and be sure it's manipulated with irq off.
 	 */
-	ipi_mask_ptr = __raw_get_cpu_var(ipi_mask);
+	ipi_mask_ptr = this_cpu_ptr(ipi_mask);
 	cpumask_copy(ipi_mask_ptr, mask);
 
 	/*
diff -puN arch/x86/kernel/cpu/common.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/common.c
@@ -1156,9 +1156,9 @@ DEFINE_PER_CPU(int, debug_stack_usage);
 
 int is_debug_stack(unsigned long addr)
 {
-	return __get_cpu_var(debug_stack_usage) ||
-		(addr <= __get_cpu_var(debug_stack_addr) &&
-		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
+	return __this_cpu_read(debug_stack_usage) ||
+		(addr <= __this_cpu_read(debug_stack_addr) &&
+		 addr > (__this_cpu_read(debug_stack_addr) - DEBUG_STKSZ));
 }
 
 DEFINE_PER_CPU(u32, debug_idt_ctr);
diff -puN arch/x86/kernel/cpu/mcheck/mce-inject.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/mcheck/mce-inject.c
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -83,7 +83,7 @@ static DEFINE_MUTEX(mce_inject_mutex);
 static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
 	int cpu = smp_processor_id();
-	struct mce *m = &__get_cpu_var(injectm);
+	struct mce *m = this_cpu_ptr(&injectm);
 	if (!cpumask_test_cpu(cpu, mce_inject_cpumask))
 		return NMI_DONE;
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
@@ -97,7 +97,7 @@ static int mce_raise_notify(unsigned int
 static void mce_irq_ipi(void *info)
 {
 	int cpu = smp_processor_id();
-	struct mce *m = &__get_cpu_var(injectm);
+	struct mce *m = this_cpu_ptr(&injectm);
 
 	if (cpumask_test_cpu(cpu, mce_inject_cpumask) &&
 			m->inject_flags & MCJ_EXCEPTION) {
@@ -109,7 +109,7 @@ static void mce_irq_ipi(void *info)
 /* Inject mce on current CPU */
 static int raise_local(void)
 {
-	struct mce *m = &__get_cpu_var(injectm);
+	struct mce *m = this_cpu_ptr(&injectm);
 	int context = MCJ_CTX(m->inject_flags);
 	int ret = 0;
 	int cpu = m->extcpu;
diff -puN arch/x86/kernel/cpu/mcheck/mce.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -399,7 +399,7 @@ static u64 mce_rdmsrl(u32 msr)
 
 		if (offset < 0)
 			return 0;
-		return *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
+		return *(u64 *)((char *)this_cpu_ptr(&injectm) + offset);
 	}
 
 	if (rdmsrl_safe(msr, &v)) {
@@ -421,7 +421,7 @@ static void mce_wrmsrl(u32 msr, u64 v)
 		int offset = msr_to_offset(msr);
 
 		if (offset >= 0)
-			*(u64 *)((char *)&__get_cpu_var(injectm) + offset) = v;
+			*(u64 *)((char *)this_cpu_ptr(&injectm) + offset) = v;
 		return;
 	}
 	wrmsrl(msr, v);
@@ -477,7 +477,7 @@ static DEFINE_PER_CPU(struct mce_ring, m
 /* Runs with CPU affinity in workqueue */
 static int mce_ring_empty(void)
 {
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
+	struct mce_ring *r = this_cpu_ptr(&mce_ring);
 
 	return r->start == r->end;
 }
@@ -489,7 +489,7 @@ static int mce_ring_get(unsigned long *p
 
 	*pfn = 0;
 	get_cpu();
-	r = &__get_cpu_var(mce_ring);
+	r = this_cpu_ptr(&mce_ring);
 	if (r->start == r->end)
 		goto out;
 	*pfn = r->ring[r->start];
@@ -503,7 +503,7 @@ out:
 /* Always runs in MCE context with preempt off */
 static int mce_ring_add(unsigned long pfn)
 {
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
+	struct mce_ring *r = this_cpu_ptr(&mce_ring);
 	unsigned next;
 
 	next = (r->end + 1) % MCE_RING_SIZE;
@@ -525,7 +525,7 @@ int mce_available(struct cpuinfo_x86 *c)
 static void mce_schedule_work(void)
 {
 	if (!mce_ring_empty())
-		schedule_work(&__get_cpu_var(mce_work));
+		schedule_work(this_cpu_ptr(&mce_work));
 }
 
 DEFINE_PER_CPU(struct irq_work, mce_irq_work);
@@ -550,7 +550,7 @@ static void mce_report_event(struct pt_r
 		return;
 	}
 
-	irq_work_queue(&__get_cpu_var(mce_irq_work));
+	irq_work_queue(this_cpu_ptr(&mce_irq_work));
 }
 
 /*
@@ -1046,7 +1046,7 @@ void do_machine_check(struct pt_regs *re
 
 	mce_gather_info(&m, regs);
 
-	final = &__get_cpu_var(mces_seen);
+	final = this_cpu_ptr(&mces_seen);
 	*final = m;
 
 	memset(valid_banks, 0, sizeof(valid_banks));
@@ -1280,14 +1280,14 @@ static unsigned long (*mce_adjust_timer)
 
 static void mce_timer_fn(unsigned long data)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
+	struct timer_list *t = this_cpu_ptr(&mce_timer);
 	unsigned long iv;
 
 	WARN_ON(smp_processor_id() != data);
 
-	if (mce_available(__this_cpu_ptr(&cpu_info))) {
+	if (mce_available(this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
-				&__get_cpu_var(mce_poll_banks));
+				this_cpu_ptr(&mce_poll_banks));
 		mce_intel_cmci_poll();
 	}
 
@@ -1315,7 +1315,7 @@ static void mce_timer_fn(unsigned long d
  */
 void mce_timer_kick(unsigned long interval)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
+	struct timer_list *t = this_cpu_ptr(&mce_timer);
 	unsigned long when = jiffies + interval;
 	unsigned long iv = __this_cpu_read(mce_next_interval);
 
@@ -1651,7 +1651,7 @@ static void mce_start_timer(unsigned int
 
 static void __mcheck_cpu_init_timer(void)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
+	struct timer_list *t = this_cpu_ptr(&mce_timer);
 	unsigned int cpu = smp_processor_id();
 
 	setup_timer(t, mce_timer_fn, cpu);
@@ -1694,8 +1694,8 @@ void mcheck_cpu_init(struct cpuinfo_x86
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
-	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
-	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
+	INIT_WORK(this_cpu_ptr(&mce_work), mce_process_work);
+	init_irq_work(this_cpu_ptr(&mce_irq_work), &mce_irq_work_cb);
 }
 
 /*
@@ -1947,7 +1947,7 @@ static struct miscdevice mce_chrdev_devi
 static void __mce_disable_bank(void *arg)
 {
 	int bank = *((int *)arg);
-	__clear_bit(bank, __get_cpu_var(mce_poll_banks));
+	__clear_bit(bank, this_cpu_ptr(mce_poll_banks));
 	cmci_disable_bank(bank);
 }
 
@@ -2057,7 +2057,7 @@ static void mce_syscore_shutdown(void)
 static void mce_syscore_resume(void)
 {
 	__mcheck_cpu_init_generic();
-	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));
+	__mcheck_cpu_init_vendor(raw_cpu_ptr(&cpu_info));
 }
 
 static struct syscore_ops mce_syscore_ops = {
@@ -2072,7 +2072,7 @@ static struct syscore_ops mce_syscore_op
 
 static void mce_cpu_restart(void *data)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!mce_available(raw_cpu_ptr(&cpu_info)))
 		return;
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_timer();
@@ -2088,14 +2088,14 @@ static void mce_restart(void)
 /* Toggle features for corrected errors */
 static void mce_disable_cmci(void *data)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!mce_available(raw_cpu_ptr(&cpu_info)))
 		return;
 	cmci_clear();
 }
 
 static void mce_enable_ce(void *all)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!mce_available(raw_cpu_ptr(&cpu_info)))
 		return;
 	cmci_reenable();
 	cmci_recheck();
@@ -2328,7 +2328,7 @@ static void mce_disable_cpu(void *h)
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!mce_available(raw_cpu_ptr(&cpu_info)))
 		return;
 
 	if (!(action & CPU_TASKS_FROZEN))
@@ -2346,7 +2346,7 @@ static void mce_reenable_cpu(void *h)
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!mce_available(raw_cpu_ptr(&cpu_info)))
 		return;
 
 	if (!(action & CPU_TASKS_FROZEN))
diff -puN arch/x86/kernel/cpu/mcheck/mce_amd.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/mcheck/mce_amd.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -310,7 +310,7 @@ static void amd_threshold_interrupt(void
 			 * event.
 			 */
 			machine_check_poll(MCP_TIMESTAMP,
-					&__get_cpu_var(mce_poll_banks));
+					this_cpu_ptr(&mce_poll_banks));
 
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
diff -puN arch/x86/kernel/cpu/mcheck/mce_intel.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/mcheck/mce_intel.c
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -85,7 +85,7 @@ void mce_intel_cmci_poll(void)
 {
 	if (__this_cpu_read(cmci_storm_state) == CMCI_STORM_NONE)
 		return;
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned));
 }
 
 void mce_intel_hcpu_update(unsigned long cpu)
@@ -178,7 +178,7 @@ static void intel_threshold_interrupt(vo
 {
 	if (cmci_storm_detect())
 		return;
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned));
 	mce_notify_irq();
 }
 
@@ -189,7 +189,7 @@ static void intel_threshold_interrupt(vo
  */
 static void cmci_discover(int banks)
 {
-	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	unsigned long *owned = (void *)this_cpu_ptr(&mce_banks_owned);
 	unsigned long flags;
 	int i;
 	int bios_wrong_thresh = 0;
@@ -211,7 +211,7 @@ static void cmci_discover(int banks)
 		/* Already owned by someone else? */
 		if (val & MCI_CTL2_CMCI_EN) {
 			clear_bit(i, owned);
-			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			__clear_bit(i, this_cpu_ptr(mce_poll_banks));
 			continue;
 		}
 
@@ -235,7 +235,7 @@ static void cmci_discover(int banks)
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & MCI_CTL2_CMCI_EN) {
 			set_bit(i, owned);
-			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			__clear_bit(i, this_cpu_ptr(mce_poll_banks));
 			/*
 			 * We are able to set thresholds for some banks that
 			 * had a threshold of 0. This means the BIOS has not
@@ -246,7 +246,7 @@ static void cmci_discover(int banks)
 					(val & MCI_CTL2_CMCI_THRESHOLD_MASK))
 				bios_wrong_thresh = 1;
 		} else {
-			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
+			WARN_ON(!test_bit(i, this_cpu_ptr(mce_poll_banks)));
 		}
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
@@ -267,10 +267,10 @@ void cmci_recheck(void)
 	unsigned long flags;
 	int banks;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
+	if (!mce_available(raw_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
 		return;
 	local_irq_save(flags);
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned));
 	local_irq_restore(flags);
 }
 
@@ -279,12 +279,12 @@ static void __cmci_disable_bank(int bank
 {
 	u64 val;
 
-	if (!test_bit(bank, __get_cpu_var(mce_banks_owned)))
+	if (!test_bit(bank, this_cpu_ptr(mce_banks_owned)))
 		return;
 	rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
 	val &= ~MCI_CTL2_CMCI_EN;
 	wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
-	__clear_bit(bank, __get_cpu_var(mce_banks_owned));
+	__clear_bit(bank, this_cpu_ptr(mce_banks_owned));
 }
 
 /*
diff -puN arch/x86/kernel/cpu/perf_event.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -493,7 +493,7 @@ static int __x86_pmu_event_init(struct p
 
 void x86_pmu_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
@@ -511,7 +511,7 @@ void x86_pmu_disable_all(void)
 
 static void x86_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!x86_pmu_initialized())
 		return;
@@ -528,7 +528,7 @@ static void x86_pmu_disable(struct pmu *
 
 void x86_pmu_enable_all(int added)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
@@ -874,7 +874,7 @@ static void x86_pmu_start(struct perf_ev
 
 static void x86_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	int i, added = cpuc->n_added;
@@ -1025,7 +1025,7 @@ void x86_pmu_enable_event(struct perf_ev
  */
 static int x86_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc;
 	int assign[X86_PMC_IDX_MAX];
 	int n, n0, ret;
@@ -1076,7 +1076,7 @@ out:
 
 static void x86_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx = event->hw.idx;
 
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
@@ -1155,7 +1155,7 @@ void perf_event_print_debug(void)
 
 void x86_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
@@ -1177,7 +1177,7 @@ void x86_pmu_stop(struct perf_event *eve
 
 static void x86_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int i;
 
 	/*
@@ -1232,7 +1232,7 @@ int x86_pmu_handle_irq(struct pt_regs *r
 	int idx, handled = 0;
 	u64 val;
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	/*
 	 * Some chipsets need to unmask the LVTPC in a particular spot
@@ -1631,7 +1631,7 @@ static void x86_pmu_cancel_txn(struct pm
  */
 static int x86_pmu_commit_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int assign[X86_PMC_IDX_MAX];
 	int n, ret;
 
@@ -1990,7 +1990,7 @@ static unsigned long get_segment_base(un
 		if (idx > GDT_ENTRIES)
 			return 0;
 
-		desc = __this_cpu_ptr(&gdt_page.gdt[0]);
+		desc = raw_cpu_ptr(gdt_page.gdt);
 	}
 
 	return get_desc_base(desc + idx);
diff -puN arch/x86/kernel/cpu/perf_event_amd.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event_amd.c
--- a/arch/x86/kernel/cpu/perf_event_amd.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event_amd.c
@@ -699,7 +699,7 @@ __init int amd_pmu_init(void)
 
 void amd_pmu_enable_virt(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	cpuc->perf_ctr_virt_mask = 0;
 
@@ -711,7 +711,7 @@ EXPORT_SYMBOL_GPL(amd_pmu_enable_virt);
 
 void amd_pmu_disable_virt(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	/*
 	 * We only mask out the Host-only bit so that host-only counting works
diff -puN arch/x86/kernel/cpu/perf_event_intel.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event_intel.c
--- a/arch/x86/kernel/cpu/perf_event_intel.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1046,7 +1046,7 @@ static inline bool intel_pmu_needs_lbr_s
 
 static void intel_pmu_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
@@ -1059,7 +1059,7 @@ static void intel_pmu_disable_all(void)
 
 static void intel_pmu_enable_all(int added)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
@@ -1093,7 +1093,7 @@ static void intel_pmu_enable_all(int add
  */
 static void intel_pmu_nhm_workaround(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	static const unsigned long nhm_magic[4] = {
 		0x4300B5,
 		0x4300D2,
@@ -1192,7 +1192,7 @@ static inline bool event_is_checkpointed
 static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
@@ -1256,7 +1256,7 @@ static void intel_pmu_enable_fixed(struc
 static void intel_pmu_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
 		if (!__this_cpu_read(cpu_hw_events.enabled))
@@ -1350,7 +1350,7 @@ static int intel_pmu_handle_irq(struct p
 	u64 status;
 	int handled;
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	/*
 	 * No known reason to not always do late ACK,
@@ -1773,7 +1773,7 @@ EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
 static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
 
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
@@ -1794,7 +1794,7 @@ static struct perf_guest_switch_msr *int
 
 static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
 	int idx;
 
@@ -1828,7 +1828,7 @@ static void core_pmu_enable_event(struct
 
 static void core_pmu_enable_all(int added)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
diff -puN arch/x86/kernel/cpu/perf_event_intel_ds.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event_intel_ds.c
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -457,7 +457,7 @@ void intel_pmu_enable_bts(u64 config)
 
 void intel_pmu_disable_bts(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	unsigned long debugctlmsr;
 
 	if (!cpuc->ds)
@@ -474,7 +474,7 @@ void intel_pmu_disable_bts(void)
 
 int intel_pmu_drain_bts_buffer(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct bts_record {
 		u64	from;
@@ -694,7 +694,7 @@ struct event_constraint *intel_pebs_cons
 
 void intel_pmu_pebs_enable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
@@ -709,7 +709,7 @@ void intel_pmu_pebs_enable(struct perf_e
 
 void intel_pmu_pebs_disable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
@@ -727,7 +727,7 @@ void intel_pmu_pebs_disable(struct perf_
 
 void intel_pmu_pebs_enable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->pebs_enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
@@ -735,7 +735,7 @@ void intel_pmu_pebs_enable_all(void)
 
 void intel_pmu_pebs_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->pebs_enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
@@ -743,7 +743,7 @@ void intel_pmu_pebs_disable_all(void)
 
 static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	unsigned long from = cpuc->lbr_entries[0].from;
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
@@ -850,7 +850,7 @@ static void __intel_pmu_pebs_event(struc
 	 * We cast to the biggest pebs_record but are careful not to
 	 * unconditionally access the 'extra' entries.
 	 */
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct pebs_record_hsw *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
@@ -939,7 +939,7 @@ static void __intel_pmu_pebs_event(struc
 
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
@@ -980,7 +980,7 @@ static void intel_pmu_drain_pebs_core(st
 
 static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = NULL;
 	void *at, *top;
diff -puN arch/x86/kernel/cpu/perf_event_intel_lbr.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event_intel_lbr.c
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -133,7 +133,7 @@ static void intel_pmu_lbr_filter(struct
 static void __intel_pmu_lbr_enable(void)
 {
 	u64 debugctl;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->lbr_sel)
 		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
@@ -183,7 +183,7 @@ void intel_pmu_lbr_reset(void)
 
 void intel_pmu_lbr_enable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!x86_pmu.lbr_nr)
 		return;
@@ -203,7 +203,7 @@ void intel_pmu_lbr_enable(struct perf_ev
 
 void intel_pmu_lbr_disable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!x86_pmu.lbr_nr)
 		return;
@@ -220,7 +220,7 @@ void intel_pmu_lbr_disable(struct perf_e
 
 void intel_pmu_lbr_enable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->lbr_users)
 		__intel_pmu_lbr_enable();
@@ -228,7 +228,7 @@ void intel_pmu_lbr_enable_all(void)
 
 void intel_pmu_lbr_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->lbr_users)
 		__intel_pmu_lbr_disable();
@@ -332,7 +332,7 @@ static void intel_pmu_lbr_read_64(struct
 
 void intel_pmu_lbr_read(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuc->lbr_users)
 		return;
diff -puN arch/x86/kernel/cpu/perf_event_knc.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event_knc.c
--- a/arch/x86/kernel/cpu/perf_event_knc.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event_knc.c
@@ -217,7 +217,7 @@ static int knc_pmu_handle_irq(struct pt_
 	int bit, loops;
 	u64 status;
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	knc_pmu_disable_all();
 
diff -puN arch/x86/kernel/cpu/perf_event_p4.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/cpu/perf_event_p4.c
--- a/arch/x86/kernel/cpu/perf_event_p4.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/cpu/perf_event_p4.c
@@ -915,7 +915,7 @@ static inline void p4_pmu_disable_event(
 
 static void p4_pmu_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
@@ -984,7 +984,7 @@ static void p4_pmu_enable_event(struct p
 
 static void p4_pmu_enable_all(int added)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
@@ -1004,7 +1004,7 @@ static int p4_pmu_handle_irq(struct pt_r
 	int idx, handled = 0;
 	u64 val;
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		int overflow;
diff -puN arch/x86/kernel/hw_breakpoint.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/hw_breakpoint.c
--- a/arch/x86/kernel/hw_breakpoint.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/hw_breakpoint.c
@@ -109,7 +109,7 @@ int arch_install_hw_breakpoint(struct pe
 	int i;
 
 	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
 
 		if (!*slot) {
 			*slot = bp;
@@ -123,7 +123,7 @@ int arch_install_hw_breakpoint(struct pe
 	set_debugreg(info->address, i);
 	__this_cpu_write(cpu_debugreg[i], info->address);
 
-	dr7 = &__get_cpu_var(cpu_dr7);
+	dr7 = this_cpu_ptr(&cpu_dr7);
 	*dr7 |= encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
@@ -147,7 +147,7 @@ void arch_uninstall_hw_breakpoint(struct
 	int i;
 
 	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
 
 		if (*slot == bp) {
 			*slot = NULL;
@@ -158,7 +158,7 @@ void arch_uninstall_hw_breakpoint(struct
 	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
 		return;
 
-	dr7 = &__get_cpu_var(cpu_dr7);
+	dr7 = this_cpu_ptr(&cpu_dr7);
 	*dr7 &= ~__encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
diff -puN arch/x86/kernel/irq_64.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/irq_64.c
--- a/arch/x86/kernel/irq_64.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/irq_64.c
@@ -52,13 +52,13 @@ static inline void stack_overflow_check(
 	    regs->sp <= curbase + THREAD_SIZE)
 		return;
 
-	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack) +
+	irq_stack_top = (u64)this_cpu_ptr(irq_stack_union.irq_stack) +
 			STACK_TOP_MARGIN;
-	irq_stack_bottom = (u64)__get_cpu_var(irq_stack_ptr);
+	irq_stack_bottom = (u64)__this_cpu_read(irq_stack_ptr);
 	if (regs->sp >= irq_stack_top && regs->sp <= irq_stack_bottom)
 		return;
 
-	oist = &__get_cpu_var(orig_ist);
+	oist = this_cpu_ptr(&orig_ist);
 	estack_top = (u64)oist->ist[0] - EXCEPTION_STKSZ + STACK_TOP_MARGIN;
 	estack_bottom = (u64)oist->ist[N_EXCEPTION_STACKS - 1];
 	if (regs->sp >= estack_top && regs->sp <= estack_bottom)
diff -puN arch/x86/kernel/kvm.c~x86-replace-__get_cpu_var-uses arch/x86/kernel/kvm.c
--- a/arch/x86/kernel/kvm.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kernel/kvm.c
@@ -243,9 +243,9 @@ u32 kvm_read_and_reset_pf_reason(void)
 {
 	u32 reason = 0;
 
-	if (__get_cpu_var(apf_reason).enabled) {
-		reason = __get_cpu_var(apf_reason).reason;
-		__get_cpu_var(apf_reason).reason = 0;
+	if (__this_cpu_read(apf_reason.enabled)) {
+		reason = __this_cpu_read(apf_reason.reason);
+		__this_cpu_write(apf_reason.reason, 0);
 	}
 
 	return reason;
@@ -316,7 +316,7 @@ static void kvm_guest_apic_eoi_write(u32
 	 * there's no need for lock or memory barriers.
 	 * An optimization barrier is implied in apic write.
 	 */
-	if (__test_and_clear_bit(KVM_PV_EOI_BIT, &__get_cpu_var(kvm_apic_eoi)))
+	if (__test_and_clear_bit(KVM_PV_EOI_BIT, this_cpu_ptr(&kvm_apic_eoi)))
 		return;
 	apic_write(APIC_EOI, APIC_EOI_ACK);
 }
@@ -327,13 +327,13 @@ void kvm_guest_cpu_init(void)
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
-		u64 pa = slow_virt_to_phys(&__get_cpu_var(apf_reason));
+		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
 
 #ifdef CONFIG_PREEMPT
 		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
 #endif
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa | KVM_ASYNC_PF_ENABLED);
-		__get_cpu_var(apf_reason).enabled = 1;
+		__this_cpu_write(apf_reason.enabled, 1);
 		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
 		       smp_processor_id());
 	}
@@ -342,8 +342,8 @@ void kvm_guest_cpu_init(void)
 		unsigned long pa;
 		/* Size alignment is implied but just to make it explicit. */
 		BUILD_BUG_ON(__alignof__(kvm_apic_eoi) < 4);
-		__get_cpu_var(kvm_apic_eoi) = 0;
-		pa = slow_virt_to_phys(&__get_cpu_var(kvm_apic_eoi))
+		__this_cpu_write(kvm_apic_eoi, 0);
+		pa = slow_virt_to_phys(this_cpu_ptr(&kvm_apic_eoi))
 			| KVM_MSR_ENABLED;
 		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
 	}
@@ -354,11 +354,11 @@ void kvm_guest_cpu_init(void)
 
 static void kvm_pv_disable_apf(void)
 {
-	if (!__get_cpu_var(apf_reason).enabled)
+	if (!__this_cpu_read(apf_reason.enabled))
 		return;
 
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
-	__get_cpu_var(apf_reason).enabled = 0;
+	__this_cpu_write(apf_reason.enabled, 0);
 
 	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
 	       smp_processor_id());
@@ -714,7 +714,7 @@ __visible void kvm_lock_spinning(struct
 	if (in_nmi())
 		return;
 
-	w = &__get_cpu_var(klock_waiting);
+	w = this_cpu_ptr(&klock_waiting);
 	cpu = smp_processor_id();
 	start = spin_time_start();
 
diff -puN arch/x86/kvm/svm.c~x86-replace-__get_cpu_var-uses arch/x86/kvm/svm.c
--- a/arch/x86/kvm/svm.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kvm/svm.c
@@ -654,7 +654,7 @@ static int svm_hardware_enable(void *gar
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
-		__get_cpu_var(current_tsc_ratio) = TSC_RATIO_DEFAULT;
+		__this_cpu_write(current_tsc_ratio, TSC_RATIO_DEFAULT);
 	}
 
 
@@ -1312,8 +1312,8 @@ static void svm_vcpu_load(struct kvm_vcp
 		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR) &&
-	    svm->tsc_ratio != __get_cpu_var(current_tsc_ratio)) {
-		__get_cpu_var(current_tsc_ratio) = svm->tsc_ratio;
+	    svm->tsc_ratio != __this_cpu_read(current_tsc_ratio)) {
+		__this_cpu_write(current_tsc_ratio, svm->tsc_ratio);
 		wrmsrl(MSR_AMD64_TSC_RATIO, svm->tsc_ratio);
 	}
 }
diff -puN arch/x86/kvm/vmx.c~x86-replace-__get_cpu_var-uses arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kvm/vmx.c
@@ -1582,7 +1582,7 @@ static void reload_tss(void)
 	/*
 	 * VT restores TR but not its size.  Useless.
 	 */
-	struct desc_ptr *gdt = &__get_cpu_var(host_gdt);
+	struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
 	struct desc_struct *descs;
 
 	descs = (void *)gdt->address;
@@ -1628,7 +1628,7 @@ static bool update_transition_efer(struc
 
 static unsigned long segment_base(u16 selector)
 {
-	struct desc_ptr *gdt = &__get_cpu_var(host_gdt);
+	struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
 	struct desc_struct *d;
 	unsigned long table_base;
 	unsigned long v;
@@ -1758,7 +1758,7 @@ static void __vmx_load_host_state(struct
 	 */
 	if (!user_has_fpu() && !vmx->vcpu.guest_fpu_loaded)
 		stts();
-	load_gdt(&__get_cpu_var(host_gdt));
+	load_gdt(this_cpu_ptr(&host_gdt));
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -1788,7 +1788,7 @@ static void vmx_vcpu_load(struct kvm_vcp
 	}
 
 	if (vmx->loaded_vmcs->cpu != cpu) {
-		struct desc_ptr *gdt = &__get_cpu_var(host_gdt);
+		struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
 		unsigned long sysenter_esp;
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
@@ -2706,7 +2706,7 @@ static int hardware_enable(void *garbage
 		ept_sync_global();
 	}
 
-	native_store_gdt(&__get_cpu_var(host_gdt));
+	native_store_gdt(this_cpu_ptr(&host_gdt));
 
 	return 0;
 }
diff -puN arch/x86/kvm/x86.c~x86-replace-__get_cpu_var-uses arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/kvm/x86.c
@@ -1541,7 +1541,7 @@ static int kvm_guest_time_update(struct
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	this_tsc_khz = __this_cpu_read(cpu_tsc_khz);
 	if (unlikely(this_tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
diff -puN arch/x86/mm/kmemcheck/kmemcheck.c~x86-replace-__get_cpu_var-uses arch/x86/mm/kmemcheck/kmemcheck.c
--- a/arch/x86/mm/kmemcheck/kmemcheck.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -140,7 +140,7 @@ static DEFINE_PER_CPU(struct kmemcheck_c
 
 bool kmemcheck_active(struct pt_regs *regs)
 {
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 
 	return data->balance > 0;
 }
@@ -148,7 +148,7 @@ bool kmemcheck_active(struct pt_regs *re
 /* Save an address that needs to be shown/hidden */
 static void kmemcheck_save_addr(unsigned long addr)
 {
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 
 	BUG_ON(data->n_addrs >= ARRAY_SIZE(data->addr));
 	data->addr[data->n_addrs++] = addr;
@@ -156,7 +156,7 @@ static void kmemcheck_save_addr(unsigned
 
 static unsigned int kmemcheck_show_all(void)
 {
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 	unsigned int i;
 	unsigned int n;
 
@@ -169,7 +169,7 @@ static unsigned int kmemcheck_show_all(v
 
 static unsigned int kmemcheck_hide_all(void)
 {
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 	unsigned int i;
 	unsigned int n;
 
@@ -185,7 +185,7 @@ static unsigned int kmemcheck_hide_all(v
  */
 void kmemcheck_show(struct pt_regs *regs)
 {
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 
 	BUG_ON(!irqs_disabled());
 
@@ -226,7 +226,7 @@ void kmemcheck_show(struct pt_regs *regs
  */
 void kmemcheck_hide(struct pt_regs *regs)
 {
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 	int n;
 
 	BUG_ON(!irqs_disabled());
@@ -528,7 +528,7 @@ static void kmemcheck_access(struct pt_r
 	const uint8_t *insn_primary;
 	unsigned int size;
 
-	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	struct kmemcheck_context *data = this_cpu_ptr(&kmemcheck_context);
 
 	/* Recursive fault -- ouch. */
 	if (data->busy) {
diff -puN arch/x86/oprofile/nmi_int.c~x86-replace-__get_cpu_var-uses arch/x86/oprofile/nmi_int.c
--- a/arch/x86/oprofile/nmi_int.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/oprofile/nmi_int.c
@@ -64,11 +64,11 @@ u64 op_x86_get_ctrl(struct op_x86_model_
 static int profile_exceptions_notify(unsigned int val, struct pt_regs *regs)
 {
 	if (ctr_running)
-		model->check_ctrs(regs, &__get_cpu_var(cpu_msrs));
+		model->check_ctrs(regs, this_cpu_ptr(&cpu_msrs));
 	else if (!nmi_enabled)
 		return NMI_DONE;
 	else
-		model->stop(&__get_cpu_var(cpu_msrs));
+		model->stop(this_cpu_ptr(&cpu_msrs));
 	return NMI_HANDLED;
 }
 
@@ -91,7 +91,7 @@ static void nmi_cpu_save_registers(struc
 
 static void nmi_cpu_start(void *dummy)
 {
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs const *msrs = this_cpu_ptr(&cpu_msrs);
 	if (!msrs->controls)
 		WARN_ON_ONCE(1);
 	else
@@ -111,7 +111,7 @@ static int nmi_start(void)
 
 static void nmi_cpu_stop(void *dummy)
 {
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs const *msrs = this_cpu_ptr(&cpu_msrs);
 	if (!msrs->controls)
 		WARN_ON_ONCE(1);
 	else
diff -puN arch/x86/oprofile/op_model_p4.c~x86-replace-__get_cpu_var-uses arch/x86/oprofile/op_model_p4.c
--- a/arch/x86/oprofile/op_model_p4.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/oprofile/op_model_p4.c
@@ -372,7 +372,7 @@ static unsigned int get_stagger(void)
 {
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+	return cpu != cpumask_first(this_cpu_ptr(cpu_sibling_map));
 #endif
 	return 0;
 }
diff -puN arch/x86/platform/uv/uv_time.c~x86-replace-__get_cpu_var-uses arch/x86/platform/uv/uv_time.c
--- a/arch/x86/platform/uv/uv_time.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/platform/uv/uv_time.c
@@ -365,7 +365,7 @@ __setup("uvrtcevt", uv_enable_evt_rtc);
 
 static __init void uv_rtc_register_clockevents(struct work_struct *dummy)
 {
-	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
+	struct clock_event_device *ced = this_cpu_ptr(&cpu_ced);
 
 	*ced = clock_event_device_uv;
 	ced->cpumask = cpumask_of(smp_processor_id());
diff -puN arch/x86/xen/enlighten.c~x86-replace-__get_cpu_var-uses arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/xen/enlighten.c
@@ -821,7 +821,7 @@ static void xen_convert_trap_info(const
 
 void xen_copy_trap_info(struct trap_info *traps)
 {
-	const struct desc_ptr *desc = &__get_cpu_var(idt_desc);
+	const struct desc_ptr *desc = this_cpu_ptr(&idt_desc);
 
 	xen_convert_trap_info(desc, traps);
 }
@@ -838,7 +838,7 @@ static void xen_load_idt(const struct de
 
 	spin_lock(&lock);
 
-	__get_cpu_var(idt_desc) = *desc;
+	memcpy(this_cpu_ptr(&idt_desc), desc, sizeof(idt_desc));
 
 	xen_convert_trap_info(desc, traps);
 
diff -puN arch/x86/xen/multicalls.c~x86-replace-__get_cpu_var-uses arch/x86/xen/multicalls.c
--- a/arch/x86/xen/multicalls.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/xen/multicalls.c
@@ -54,7 +54,7 @@ DEFINE_PER_CPU(unsigned long, xen_mc_irq
 
 void xen_mc_flush(void)
 {
-	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct mc_buffer *b = this_cpu_ptr(&mc_buffer);
 	struct multicall_entry *mc;
 	int ret = 0;
 	unsigned long flags;
@@ -131,7 +131,7 @@ void xen_mc_flush(void)
 
 struct multicall_space __xen_mc_entry(size_t args)
 {
-	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct mc_buffer *b = this_cpu_ptr(&mc_buffer);
 	struct multicall_space ret;
 	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
@@ -162,7 +162,7 @@ struct multicall_space __xen_mc_entry(si
 
 struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
 {
-	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct mc_buffer *b = this_cpu_ptr(&mc_buffer);
 	struct multicall_space ret = { NULL, NULL };
 
 	BUG_ON(preemptible());
@@ -192,7 +192,7 @@ out:
 
 void xen_mc_callback(void (*fn)(void *), void *data)
 {
-	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct mc_buffer *b = this_cpu_ptr(&mc_buffer);
 	struct callback *cb;
 
 	if (b->cbidx == MC_BATCH) {
diff -puN arch/x86/xen/spinlock.c~x86-replace-__get_cpu_var-uses arch/x86/xen/spinlock.c
--- a/arch/x86/xen/spinlock.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/xen/spinlock.c
@@ -109,7 +109,7 @@ static bool xen_pvspin = true;
 __visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
-	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
+	struct xen_lock_waiting *w = this_cpu_ptr(&lock_waiting);
 	int cpu = smp_processor_id();
 	u64 start;
 	unsigned long flags;
diff -puN arch/x86/xen/time.c~x86-replace-__get_cpu_var-uses arch/x86/xen/time.c
--- a/arch/x86/xen/time.c~x86-replace-__get_cpu_var-uses
+++ a/arch/x86/xen/time.c
@@ -80,7 +80,7 @@ static void get_runstate_snapshot(struct
 
 	BUG_ON(preemptible());
 
-	state = &__get_cpu_var(xen_runstate);
+	state = this_cpu_ptr(&xen_runstate);
 
 	/*
 	 * The runstate info is always updated by the hypervisor on
@@ -123,7 +123,7 @@ static void do_stolen_accounting(void)
 
 	WARN_ON(state.state != RUNSTATE_running);
 
-	snap = &__get_cpu_var(xen_runstate_snapshot);
+	snap = this_cpu_ptr(&xen_runstate_snapshot);
 
 	/* work out how much time the VCPU has not been runn*ing*  */
 	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
@@ -158,7 +158,7 @@ cycle_t xen_clocksource_read(void)
 	cycle_t ret;
 
 	preempt_disable_notrace();
-	src = &__get_cpu_var(xen_vcpu)->time;
+	src = this_cpu_ptr(&xen_vcpu->time);
 	ret = pvclock_clocksource_read(src);
 	preempt_enable_notrace();
 	return ret;
@@ -397,7 +397,7 @@ static DEFINE_PER_CPU(struct xen_clock_e
 
 static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = &__get_cpu_var(xen_clock_events).evt;
+	struct clock_event_device *evt = this_cpu_ptr(&xen_clock_events.evt);
 	irqreturn_t ret;
 
 	ret = IRQ_NONE;
@@ -460,7 +460,7 @@ void xen_setup_cpu_clockevents(void)
 {
 	BUG_ON(preemptible());
 
-	clockevents_register_device(&__get_cpu_var(xen_clock_events).evt);
+	clockevents_register_device(this_cpu_ptr(&xen_clock_events.evt));
 }
 
 void xen_timer_resume(void)
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

