From: akpm@linux-foundation.org
Subject: + revert-x86_64-mm-nmi-watchdog-ops.patch added to -mm tree
Date: Wed, 25 Apr 2007 16:26:28 -0700
Message-ID: <200704252326.l3PNQSnJ015653@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXDYX0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 19:26:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de


The patch titled
     revert x86_64-mm-nmi-watchdog-ops
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-nmi-watchdog-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert x86_64-mm-nmi-watchdog-ops
From: Andrew Morton <akpm@linux-foundation.org>

arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'write_watchdog_counter':
arch/i386/kernel/cpu/perfctr-watchdog.c:203: warning: implicit declaration of function 'Dprintk'
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'setup_k7_watchdog':
arch/i386/kernel/cpu/perfctr-watchdog.c:247: warning: implicit declaration of function 'apic_write'
arch/i386/kernel/cpu/perfctr-watchdog.c:247: error: 'APIC_LVTPC' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c:247: error: (Each undeclared identifier is reported only once
arch/i386/kernel/cpu/perfctr-watchdog.c:247: error: for each function it appears in.)
arch/i386/kernel/cpu/perfctr-watchdog.c:247: error: 'APIC_DM_NMI' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'setup_p6_watchdog':
arch/i386/kernel/cpu/perfctr-watchdog.c:328: error: 'APIC_LVTPC' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c:328: error: 'APIC_DM_NMI' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'p6_rearm':
arch/i386/kernel/cpu/perfctr-watchdog.c:344: error: 'APIC_LVTPC' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c:344: error: 'APIC_DM_NMI' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'setup_p4_watchdog':
arch/i386/kernel/cpu/perfctr-watchdog.c:435: error: 'APIC_LVTPC' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c:435: error: 'APIC_DM_NMI' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'p4_reserve':
arch/i386/kernel/cpu/perfctr-watchdog.c:455: error: 'smp_num_siblings' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'p4_unreserve':
arch/i386/kernel/cpu/perfctr-watchdog.c:471: error: 'smp_num_siblings' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'p4_rearm':
arch/i386/kernel/cpu/perfctr-watchdog.c:490: error: 'APIC_LVTPC' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c:490: error: 'APIC_DM_NMI' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c: In function 'setup_intel_arch_watchdog':
arch/i386/kernel/cpu/perfctr-watchdog.c:547: error: 'APIC_LVTPC' undeclared (first use in this function)
arch/i386/kernel/cpu/perfctr-watchdog.c:547: error: 'APIC_DM_NMI' undeclared (first use in this function)

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/Makefile           |    2 
 arch/i386/kernel/cpu/perfctr-watchdog.c |  651 ------------------
 arch/i386/kernel/nmi.c                  |  762 ++++++++++++++++++++--
 include/asm-i386/nmi.h                  |    8 
 4 files changed, 710 insertions(+), 713 deletions(-)

diff -puN arch/i386/kernel/cpu/Makefile~revert-x86_64-mm-nmi-watchdog-ops arch/i386/kernel/cpu/Makefile
--- a/arch/i386/kernel/cpu/Makefile~revert-x86_64-mm-nmi-watchdog-ops
+++ a/arch/i386/kernel/cpu/Makefile
@@ -17,5 +17,3 @@ obj-$(CONFIG_X86_MCE)	+=	mcheck/
 
 obj-$(CONFIG_MTRR)	+= 	mtrr/
 obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
-
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~revert-x86_64-mm-nmi-watchdog-ops /dev/null
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ /dev/null
@@ -1,651 +0,0 @@
-/* local apic based NMI watchdog for various CPUs.
-   This file also handles reservation of performance counters for coordination
-   with other users (like oprofile).
-
-   Note that these events normally don't tick when the CPU idles. This means
-   the frequency varies with CPU load.
-
-   Original code written by Keith Owens, but not much left of that. */
-
-#include <asm/intel_arch_perfmon.h>
-#include <linux/percpu.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/bitops.h>
-#include <linux/smp.h>
-#include <linux/nmi.h>
-
-struct nmi_watchdog_ctlblk {
-	unsigned int cccr_msr;
-	unsigned int perfctr_msr;  /* the MSR to reset in NMI handler */
-	unsigned int evntsel_msr;  /* the MSR to select the events to handle */
-};
-
-/* Interface defining a CPU specific perfctr watchdog */
-struct wd_ops {
-	int (*reserve)(void);
-	void (*unreserve)(void);
-	int (*setup)(unsigned nmi_hz);
-	void (*rearm)(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz);
-	void (*stop)(void *);
-	unsigned perfctr;
-	unsigned evntsel;
-	u64 checkbit;
-};
-
-static struct wd_ops *wd_ops;
-
-/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
- * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
- */
-#define NMI_MAX_COUNTER_BITS 66
-
-/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
- * evtsel_nmi_owner tracks the ownership of the event selection
- * - different performance counters/ event selection may be reserved for
- *   different subsystems this reservation system just tries to coordinate
- *   things a little
- */
-static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
-static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
-
-static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
-
-/* converts an msr to an appropriate reservation bit */
-static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
-{
-	return wd_ops ? msr - wd_ops->perfctr : 0;
-}
-
-/* converts an msr to an appropriate reservation bit */
-/* returns the bit offset of the event selection register */
-static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
-{
-	return wd_ops ? msr - wd_ops->evntsel : 0;
-}
-
-/* checks for a bit availability (hack for oprofile) */
-int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
-{
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	return (!test_bit(counter, perfctr_nmi_owner));
-}
-
-/* checks the an msr for availability */
-int avail_to_resrv_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	return (!test_bit(counter, perfctr_nmi_owner));
-}
-
-int reserve_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	if (!test_and_set_bit(counter, perfctr_nmi_owner))
-		return 1;
-	return 0;
-}
-
-void release_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	clear_bit(counter, perfctr_nmi_owner);
-}
-
-int reserve_evntsel_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	if (!test_and_set_bit(counter, evntsel_nmi_owner))
-		return 1;
-	return 0;
-}
-
-void release_evntsel_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	clear_bit(counter, evntsel_nmi_owner);
-}
-
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
-EXPORT_SYMBOL(reserve_perfctr_nmi);
-EXPORT_SYMBOL(release_perfctr_nmi);
-EXPORT_SYMBOL(reserve_evntsel_nmi);
-EXPORT_SYMBOL(release_evntsel_nmi);
-
-void disable_lapic_nmi_watchdog(void)
-{
-	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
-
-	if (atomic_read(&nmi_active) <= 0)
-		return;
-
-	on_each_cpu(wd_ops->stop, NULL, 0, 1);
-	wd_ops->unreserve();
-
-	BUG_ON(atomic_read(&nmi_active) != 0);
-}
-
-void enable_lapic_nmi_watchdog(void)
-{
-	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
-
-	/* are we already enabled */
-	if (atomic_read(&nmi_active) != 0)
-		return;
-
-	/* are we lapic aware */
-	if (!wd_ops)
-		return;
-	if (!wd_ops->reserve()) {
-		printk(KERN_ERR "NMI watchdog: cannot reserve perfctrs\n");
-		return;
-	}
-
-	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
-	touch_nmi_watchdog();
-}
-
-/*
- * Activate the NMI watchdog via the local APIC.
- */
-
-static unsigned int adjust_for_32bit_ctr(unsigned int hz)
-{
-	u64 counter_val;
-	unsigned int retval = hz;
-
-	/*
-	 * On Intel CPUs with P6/ARCH_PERFMON only 32 bits in the counter
-	 * are writable, with higher bits sign extending from bit 31.
-	 * So, we can only program the counter with 31 bit values and
-	 * 32nd bit should be 1, for 33.. to be 1.
-	 * Find the appropriate nmi_hz
-	 */
-	counter_val = (u64)cpu_khz * 1000;
-	do_div(counter_val, retval);
- 	if (counter_val > 0x7fffffffULL) {
-		u64 count = (u64)cpu_khz * 1000;
-		do_div(count, 0x7fffffffUL);
-		retval = count + 1;
-	}
-	return retval;
-}
-
-static void
-write_watchdog_counter(unsigned int perfctr_msr, const char *descr, unsigned nmi_hz)
-{
-	u64 count = (u64)cpu_khz * 1000;
-
-	do_div(count, nmi_hz);
-	if(descr)
-		Dprintk("setting %s to -0x%08Lx\n", descr, count);
-	wrmsrl(perfctr_msr, 0 - count);
-}
-
-static void write_watchdog_counter32(unsigned int perfctr_msr,
-		const char *descr, unsigned nmi_hz)
-{
-	u64 count = (u64)cpu_khz * 1000;
-
-	do_div(count, nmi_hz);
-	if(descr)
-		Dprintk("setting %s to -0x%08Lx\n", descr, count);
-	wrmsr(perfctr_msr, (u32)(-count), 0);
-}
-
-/* AMD K7/K8/Family10h/Family11h support. AMD keeps this interface
-   nicely stable so there is not much variety */
-
-#define K7_EVNTSEL_ENABLE	(1 << 22)
-#define K7_EVNTSEL_INT		(1 << 20)
-#define K7_EVNTSEL_OS		(1 << 17)
-#define K7_EVNTSEL_USR		(1 << 16)
-#define K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING	0x76
-#define K7_NMI_EVENT		K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING
-
-static int setup_k7_watchdog(unsigned nmi_hz)
-{
-	unsigned int perfctr_msr, evntsel_msr;
-	unsigned int evntsel;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	perfctr_msr = MSR_K7_PERFCTR0;
-	evntsel_msr = MSR_K7_EVNTSEL0;
-
-	wrmsrl(perfctr_msr, 0UL);
-
-	evntsel = K7_EVNTSEL_INT
-		| K7_EVNTSEL_OS
-		| K7_EVNTSEL_USR
-		| K7_NMI_EVENT;
-
-	/* setup the timer */
-	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0",nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= K7_EVNTSEL_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
-
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
-	return 1;
-}
-
-static void single_msr_stop_watchdog(void *arg)
-{
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	wrmsr(wd->evntsel_msr, 0, 0);
-}
-
-static int single_msr_reserve(void)
-{
-	if (!reserve_perfctr_nmi(wd_ops->perfctr))
-		return 0;
-
-	if (!reserve_evntsel_nmi(wd_ops->evntsel)) {
-		release_perfctr_nmi(wd_ops->perfctr);
-		return 0;
-	}
-	return 1;
-}
-
-static void single_msr_unreserve(void)
-{
-	release_evntsel_nmi(wd_ops->perfctr);
-	release_perfctr_nmi(wd_ops->evntsel);
-}
-
-static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
-{
-	/* start the cycle over again */
-	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
-}
-
-static struct wd_ops k7_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_k7_watchdog,
-	.rearm = single_msr_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_K7_PERFCTR0,
-	.evntsel = MSR_K7_EVNTSEL0,
-	.checkbit = 1ULL<<63,
-};
-
-/* Intel Model 6 (PPro+,P2,P3,P-M,Core1) */
-
-#define P6_EVNTSEL0_ENABLE	(1 << 22)
-#define P6_EVNTSEL_INT		(1 << 20)
-#define P6_EVNTSEL_OS		(1 << 17)
-#define P6_EVNTSEL_USR		(1 << 16)
-#define P6_EVENT_CPU_CLOCKS_NOT_HALTED	0x79
-#define P6_NMI_EVENT		P6_EVENT_CPU_CLOCKS_NOT_HALTED
-
-static int setup_p6_watchdog(unsigned nmi_hz)
-{
-	unsigned int perfctr_msr, evntsel_msr;
-	unsigned int evntsel;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	perfctr_msr = MSR_P6_PERFCTR0;
-	evntsel_msr = MSR_P6_EVNTSEL0;
-
-	wrmsrl(perfctr_msr, 0UL);
-
-	evntsel = P6_EVNTSEL_INT
-		| P6_EVNTSEL_OS
-		| P6_EVNTSEL_USR
-		| P6_NMI_EVENT;
-
-	/* setup the timer */
-	wrmsr(evntsel_msr, evntsel, 0);
-	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0",nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= P6_EVNTSEL0_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
-
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
-	return 1;
-}
-
-static void p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
-{
-	/* P6 based Pentium M need to re-unmask
-	 * the apic vector but it doesn't hurt
-	 * other P6 variant.
-	 * ArchPerfom/Core Duo also needs this */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	/* P6/ARCH_PERFMON has 32 bit counter write */
-	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
-}
-
-static struct wd_ops p6_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_p6_watchdog,
-	.rearm = p6_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_P6_PERFCTR0,
-	.evntsel = MSR_P6_EVNTSEL0,
-	.checkbit = 1ULL<<39,
-};
-
-/* Intel P4 performance counters. By far the most complicated of all. */
-
-#define MSR_P4_MISC_ENABLE_PERF_AVAIL	(1<<7)
-#define P4_ESCR_EVENT_SELECT(N)	((N)<<25)
-#define P4_ESCR_OS		(1<<3)
-#define P4_ESCR_USR		(1<<2)
-#define P4_CCCR_OVF_PMI0	(1<<26)
-#define P4_CCCR_OVF_PMI1	(1<<27)
-#define P4_CCCR_THRESHOLD(N)	((N)<<20)
-#define P4_CCCR_COMPLEMENT	(1<<19)
-#define P4_CCCR_COMPARE		(1<<18)
-#define P4_CCCR_REQUIRED	(3<<16)
-#define P4_CCCR_ESCR_SELECT(N)	((N)<<13)
-#define P4_CCCR_ENABLE		(1<<12)
-#define P4_CCCR_OVF 		(1<<31)
-
-/* Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
-   CRU_ESCR0 (with any non-null event selector) through a complemented
-   max threshold. [IA32-Vol3, Section 14.9.9] */
-
-static int setup_p4_watchdog(unsigned nmi_hz)
-{
-	unsigned int perfctr_msr, evntsel_msr, cccr_msr;
-	unsigned int evntsel, cccr_val;
-	unsigned int misc_enable, dummy;
-	unsigned int ht_num;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	rdmsr(MSR_IA32_MISC_ENABLE, misc_enable, dummy);
-	if (!(misc_enable & MSR_P4_MISC_ENABLE_PERF_AVAIL))
-		return 0;
-
-#ifdef CONFIG_SMP
-	/* detect which hyperthread we are on */
-	if (smp_num_siblings == 2) {
-		unsigned int ebx, apicid;
-
-        	ebx = cpuid_ebx(1);
-	        apicid = (ebx >> 24) & 0xff;
-        	ht_num = apicid & 1;
-	} else
-#endif
-		ht_num = 0;
-
-	/* performance counters are shared resources
-	 * assign each hyperthread its own set
-	 * (re-use the ESCR0 register, seems safe
-	 * and keeps the cccr_val the same)
-	 */
-	if (!ht_num) {
-		/* logical cpu 0 */
-		perfctr_msr = MSR_P4_IQ_PERFCTR0;
-		evntsel_msr = MSR_P4_CRU_ESCR0;
-		cccr_msr = MSR_P4_IQ_CCCR0;
-		cccr_val = P4_CCCR_OVF_PMI0 | P4_CCCR_ESCR_SELECT(4);
-	} else {
-		/* logical cpu 1 */
-		perfctr_msr = MSR_P4_IQ_PERFCTR1;
-		evntsel_msr = MSR_P4_CRU_ESCR0;
-		cccr_msr = MSR_P4_IQ_CCCR1;
-		cccr_val = P4_CCCR_OVF_PMI1 | P4_CCCR_ESCR_SELECT(4);
-	}
-
-	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
-	 	| P4_ESCR_OS
-		| P4_ESCR_USR;
-
-	cccr_val |= P4_CCCR_THRESHOLD(15)
-		 | P4_CCCR_COMPLEMENT
-		 | P4_CCCR_COMPARE
-		 | P4_CCCR_REQUIRED;
-
-	wrmsr(evntsel_msr, evntsel, 0);
-	wrmsr(cccr_msr, cccr_val, 0);
-	write_watchdog_counter(perfctr_msr, "P4_IQ_COUNTER0", nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	cccr_val |= P4_CCCR_ENABLE;
-	wrmsr(cccr_msr, cccr_val, 0);
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = cccr_msr;
-	return 1;
-}
-
-static void stop_p4_watchdog(void *arg)
-{
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-	wrmsr(wd->cccr_msr, 0, 0);
-	wrmsr(wd->evntsel_msr, 0, 0);
-}
-
-static int p4_reserve(void)
-{
-	if (!reserve_perfctr_nmi(MSR_P4_IQ_PERFCTR0))
-		return 0;
-	if (smp_num_siblings > 1 && !reserve_perfctr_nmi(MSR_P4_IQ_PERFCTR1))
-		goto fail1;
-	if (!reserve_evntsel_nmi(MSR_P4_CRU_ESCR0))
-		goto fail2;
-	/* RED-PEN why is ESCR1 not reserved here? */
-	return 1;
- fail2:
-	if (smp_num_siblings > 1)
-		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
- fail1:
-	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
-	return 0;
-}
-
-static void p4_unreserve(void)
-{
-	if (smp_num_siblings > 1)
-		release_evntsel_nmi(MSR_P4_IQ_PERFCTR1);
-	release_evntsel_nmi(MSR_P4_IQ_PERFCTR0);
-	release_perfctr_nmi(MSR_P4_CRU_ESCR0);
-}
-
-static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
-{
-	unsigned dummy;
-	/*
- 	 * P4 quirks:
-	 * - An overflown perfctr will assert its interrupt
-	 *   until the OVF flag in its CCCR is cleared.
-	 * - LVTPC is masked on interrupt and must be
-	 *   unmasked by the LVTPC handler.
-	 */
-	rdmsrl(wd->cccr_msr, dummy);
-	dummy &= ~P4_CCCR_OVF;
-	wrmsrl(wd->cccr_msr, dummy);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	/* start the cycle over again */
-	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
-}
-
-static struct wd_ops p4_wd_ops = {
-	.reserve = p4_reserve,
-	.unreserve = p4_unreserve,
-	.setup = setup_p4_watchdog,
-	.rearm = p4_rearm,
-	.stop = stop_p4_watchdog,
-	/* RED-PEN this is wrong for the other sibling */
-	.perfctr = MSR_P4_BPU_PERFCTR0,
-	.evntsel = MSR_P4_BSU_ESCR0,
-	.checkbit = 1ULL<<39,
-};
-
-/* Watchdog using the Intel architected PerfMon. Used for Core2 and hopefully
-   all future Intel CPUs. */
-
-#define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
-#define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
-
-static int setup_intel_arch_watchdog(unsigned nmi_hz)
-{
-	unsigned int ebx;
-	union cpuid10_eax eax;
-	unsigned int unused;
-	unsigned int perfctr_msr, evntsel_msr;
-	unsigned int evntsel;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	/*
-	 * Check whether the Architectural PerfMon supports
-	 * Unhalted Core Cycles Event or not.
-	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
-	 */
-	cpuid(10, &(eax.full), &ebx, &unused, &unused);
-	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
-	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
-		return 0;
-
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
-
-	wrmsrl(perfctr_msr, 0UL);
-
-	evntsel = ARCH_PERFMON_EVENTSEL_INT
-		| ARCH_PERFMON_EVENTSEL_OS
-		| ARCH_PERFMON_EVENTSEL_USR
-		| ARCH_PERFMON_NMI_EVENT_SEL
-		| ARCH_PERFMON_NMI_EVENT_UMASK;
-
-	/* setup the timer */
-	wrmsr(evntsel_msr, evntsel, 0);
-	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0", nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
-
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
-	wd_ops->checkbit = 1ULL << (eax.split.bit_width - 1);
-	return 1;
-}
-
-static struct wd_ops intel_arch_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_intel_arch_watchdog,
-	.rearm = p6_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
-};
-
-static void probe_nmi_watchdog(void)
-{
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
-			return;
-		wd_ops = &k7_wd_ops;
-		break;
-	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
-			wd_ops = &intel_arch_wd_ops;
-			break;
-		}
-		switch (boot_cpu_data.x86) {
-		case 6:
-			if (boot_cpu_data.x86_model > 0xd)
-				return;
-
-			wd_ops = &p6_wd_ops;
-			break;
-		case 15:
-			if (boot_cpu_data.x86_model > 0x4)
-				return;
-
-			wd_ops = &p4_wd_ops;
-			break;
-		default:
-			return;
-		}
-		break;
-	}
-}
-
-/* Interface to nmi.c */
-
-int lapic_watchdog_init(unsigned nmi_hz)
-{
-	if (!wd_ops) {
-		probe_nmi_watchdog();
-		if (!wd_ops)
-			return -1;
-	}
-
-	if (!(wd_ops->setup(nmi_hz))) {
-		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
-		       raw_smp_processor_id());
-		return -1;
-	}
-
-	return 0;
-}
-
-void lapic_watchdog_stop(void)
-{
-	if (wd_ops)
-		wd_ops->stop(NULL);
-}
-
-unsigned lapic_adjust_nmi_hz(unsigned hz)
-{
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-	if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
-	    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
-		hz = adjust_for_32bit_ctr(hz);
-	return hz;
-}
-
-int lapic_wd_event(unsigned nmi_hz)
-{
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-	u64 ctr;
-	rdmsrl(wd->perfctr_msr, ctr);
-	if (ctr & wd_ops->checkbit) { /* perfctr still running? */
-		return 0;
-	}
-	wd_ops->rearm(wd, nmi_hz);
-	return 1;
-}
-
-int lapic_watchdog_ok(void)
-{
-	return wd_ops != NULL;
-}
diff -puN arch/i386/kernel/nmi.c~revert-x86_64-mm-nmi-watchdog-ops arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~revert-x86_64-mm-nmi-watchdog-ops
+++ a/arch/i386/kernel/nmi.c
@@ -20,6 +20,7 @@
 #include <linux/sysdev.h>
 #include <linux/sysctl.h>
 #include <linux/percpu.h>
+#include <linux/dmi.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
 #include <linux/kernel_stat.h>
@@ -27,14 +28,30 @@
 #include <asm/smp.h>
 #include <asm/nmi.h>
 #include <asm/kdebug.h>
+#include <asm/intel_arch_perfmon.h>
 
 #include "mach_traps.h"
 
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-static cpumask_t backtrace_mask = CPU_MASK_NONE;
+/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
+ * evtsel_nmi_owner tracks the ownership of the event selection
+ * - different performance counters/ event selection may be reserved for
+ *   different subsystems this reservation system just tries to coordinate
+ *   things a little
+ */
+
+/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
+ * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
+ */
+#define NMI_MAX_COUNTER_BITS 66
+#define NMI_MAX_COUNTER_LONGS BITS_TO_LONGS(NMI_MAX_COUNTER_BITS)
 
+static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner[NMI_MAX_COUNTER_LONGS]);
+static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[NMI_MAX_COUNTER_LONGS]);
+
+static cpumask_t backtrace_mask = CPU_MASK_NONE;
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
  * <0: the lapic NMI watchdog has not been set up, and cannot
@@ -46,11 +63,138 @@ atomic_t nmi_active = ATOMIC_INIT(0);		/
 unsigned int nmi_watchdog = NMI_DEFAULT;
 static unsigned int nmi_hz = HZ;
 
-static DEFINE_PER_CPU(short, wd_enabled);
+struct nmi_watchdog_ctlblk {
+	int enabled;
+	u64 check_bit;
+	unsigned int cccr_msr;
+	unsigned int perfctr_msr;  /* the MSR to reset in NMI handler */
+	unsigned int evntsel_msr;  /* the MSR to select the events to handle */
+};
+static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
 
 /* local prototypes */
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
 
+/* converts an msr to an appropriate reservation bit */
+static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
+{
+	/* returns the bit offset of the performance counter register */
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		return (msr - MSR_K7_PERFCTR0);
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+			return (msr - MSR_ARCH_PERFMON_PERFCTR0);
+
+		switch (boot_cpu_data.x86) {
+		case 6:
+			return (msr - MSR_P6_PERFCTR0);
+		case 15:
+			return (msr - MSR_P4_BPU_PERFCTR0);
+		}
+	}
+	return 0;
+}
+
+/* converts an msr to an appropriate reservation bit */
+static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
+{
+	/* returns the bit offset of the event selection register */
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		return (msr - MSR_K7_EVNTSEL0);
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+			return (msr - MSR_ARCH_PERFMON_EVENTSEL0);
+
+		switch (boot_cpu_data.x86) {
+		case 6:
+			return (msr - MSR_P6_EVNTSEL0);
+		case 15:
+			return (msr - MSR_P4_BSU_ESCR0);
+		}
+	}
+	return 0;
+}
+
+/* checks for a bit availability (hack for oprofile) */
+int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
+{
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
+}
+
+/* checks the an msr for availability */
+int avail_to_resrv_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
+}
+
+int reserve_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	if (!test_and_set_bit(counter, &__get_cpu_var(perfctr_nmi_owner)))
+		return 1;
+	return 0;
+}
+
+void release_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	clear_bit(counter, &__get_cpu_var(perfctr_nmi_owner));
+}
+
+int reserve_evntsel_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_evntsel_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	if (!test_and_set_bit(counter, &__get_cpu_var(evntsel_nmi_owner)[0]))
+		return 1;
+	return 0;
+}
+
+void release_evntsel_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_evntsel_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	clear_bit(counter, &__get_cpu_var(evntsel_nmi_owner)[0]);
+}
+
+static __cpuinit inline int nmi_known_cpu(void)
+{
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		return ((boot_cpu_data.x86 == 15) || (boot_cpu_data.x86 == 6)
+			|| (boot_cpu_data.x86 == 16));
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+			return 1;
+		else
+			return ((boot_cpu_data.x86 == 15) || (boot_cpu_data.x86 == 6));
+	}
+	return 0;
+}
+
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
@@ -72,6 +216,28 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
+static unsigned int adjust_for_32bit_ctr(unsigned int hz)
+{
+	u64 counter_val;
+	unsigned int retval = hz;
+
+	/*
+	 * On Intel CPUs with P6/ARCH_PERFMON only 32 bits in the counter
+	 * are writable, with higher bits sign extending from bit 31.
+	 * So, we can only program the counter with 31 bit values and
+	 * 32nd bit should be 1, for 33.. to be 1.
+	 * Find the appropriate nmi_hz
+	 */
+	counter_val = (u64)cpu_khz * 1000;
+	do_div(counter_val, retval);
+ 	if (counter_val > 0x7fffffffULL) {
+		u64 count = (u64)cpu_khz * 1000;
+		do_div(count, 0x7fffffffUL);
+		retval = count + 1;
+	}
+	return retval;
+}
+
 static int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -104,14 +270,14 @@ static int __init check_nmi_watchdog(voi
 		if (!cpu_isset(cpu, cpu_callin_map))
 			continue;
 #endif
-		if (!per_cpu(wd_enabled, cpu))
+		if (!per_cpu(nmi_watchdog_ctlblk, cpu).enabled)
 			continue;
 		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
 			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
 				nmi_count(cpu));
-			per_cpu(wd_enabled, cpu) = 0;
+			per_cpu(nmi_watchdog_ctlblk, cpu).enabled = 0;
 			atomic_dec(&nmi_active);
 		}
 	}
@@ -125,8 +291,16 @@ static int __init check_nmi_watchdog(voi
 
 	/* now that we know it works we can reduce NMI frequency to
 	   something more reasonable; makes a difference in some configs */
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		nmi_hz = lapic_adjust_nmi_hz(1);
+	if (nmi_watchdog == NMI_LOCAL_APIC) {
+		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+		nmi_hz = 1;
+
+		if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
+		    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
+			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+		}
+	}
 
 	kfree(prev_nmi_count);
 	return 0;
@@ -149,8 +323,85 @@ static int __init setup_nmi_watchdog(cha
 
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
+static void disable_lapic_nmi_watchdog(void)
+{
+	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
+
+	if (atomic_read(&nmi_active) <= 0)
+		return;
 
-/* Suspend/resume support */
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
+
+	BUG_ON(atomic_read(&nmi_active) != 0);
+}
+
+static void enable_lapic_nmi_watchdog(void)
+{
+	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
+
+	/* are we already enabled */
+	if (atomic_read(&nmi_active) != 0)
+		return;
+
+	/* are we lapic aware */
+	if (nmi_known_cpu() <= 0)
+		return;
+
+	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
+	touch_nmi_watchdog();
+}
+
+void disable_timer_nmi_watchdog(void)
+{
+	BUG_ON(nmi_watchdog != NMI_IO_APIC);
+
+	if (atomic_read(&nmi_active) <= 0)
+		return;
+
+	disable_irq(0);
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
+
+	BUG_ON(atomic_read(&nmi_active) != 0);
+}
+
+void enable_timer_nmi_watchdog(void)
+{
+	BUG_ON(nmi_watchdog != NMI_IO_APIC);
+
+	if (atomic_read(&nmi_active) == 0) {
+		touch_nmi_watchdog();
+		on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
+		enable_irq(0);
+	}
+}
+
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI);
+}
+
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
 
 #ifdef CONFIG_PM
 
@@ -197,7 +448,7 @@ static int __init init_lapic_nmi_sysfs(v
 	if (nmi_watchdog != NMI_LOCAL_APIC)
 		return 0;
 
-	if (atomic_read(&nmi_active) < 0)
+	if ( atomic_read(&nmi_active) < 0 )
 		return 0;
 
 	error = sysdev_class_register(&nmi_sysclass);
@@ -210,37 +461,344 @@ late_initcall(init_lapic_nmi_sysfs);
 
 #endif	/* CONFIG_PM */
 
-static void __acpi_nmi_disable(void *__unused)
+/*
+ * Activate the NMI watchdog via the local APIC.
+ * Original code written by Keith Owens.
+ */
+
+static void write_watchdog_counter(unsigned int perfctr_msr, const char *descr)
 {
-	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+	u64 count = (u64)cpu_khz * 1000;
+
+	do_div(count, nmi_hz);
+	if(descr)
+		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+	wrmsrl(perfctr_msr, 0 - count);
 }
 
-/*
- * Disable timer based NMIs on all CPUs:
- */
-void acpi_nmi_disable(void)
+static void write_watchdog_counter32(unsigned int perfctr_msr,
+		const char *descr)
 {
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+	u64 count = (u64)cpu_khz * 1000;
+
+	do_div(count, nmi_hz);
+	if(descr)
+		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+	wrmsr(perfctr_msr, (u32)(-count), 0);
 }
 
-static void __acpi_nmi_enable(void *__unused)
+/* Note that these events don't tick when the CPU idles. This means
+   the frequency varies with CPU load. */
+
+#define K7_EVNTSEL_ENABLE	(1 << 22)
+#define K7_EVNTSEL_INT		(1 << 20)
+#define K7_EVNTSEL_OS		(1 << 17)
+#define K7_EVNTSEL_USR		(1 << 16)
+#define K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING	0x76
+#define K7_NMI_EVENT		K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING
+
+static int setup_k7_watchdog(void)
 {
-	apic_write_around(APIC_LVT0, APIC_DM_NMI);
+	unsigned int perfctr_msr, evntsel_msr;
+	unsigned int evntsel;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	perfctr_msr = MSR_K7_PERFCTR0;
+	evntsel_msr = MSR_K7_EVNTSEL0;
+	if (!reserve_perfctr_nmi(perfctr_msr))
+		goto fail;
+
+	if (!reserve_evntsel_nmi(evntsel_msr))
+		goto fail1;
+
+	wrmsrl(perfctr_msr, 0UL);
+
+	evntsel = K7_EVNTSEL_INT
+		| K7_EVNTSEL_OS
+		| K7_EVNTSEL_USR
+		| K7_NMI_EVENT;
+
+	/* setup the timer */
+	wrmsr(evntsel_msr, evntsel, 0);
+	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0");
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= K7_EVNTSEL_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = 0;  //unused
+	wd->check_bit = 1ULL<<63;
+	return 1;
+fail1:
+	release_perfctr_nmi(perfctr_msr);
+fail:
+	return 0;
 }
 
-/*
- * Enable timer based NMIs on all CPUs:
- */
-void acpi_nmi_enable(void)
+static void stop_k7_watchdog(void)
 {
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	wrmsr(wd->evntsel_msr, 0, 0);
+
+	release_evntsel_nmi(wd->evntsel_msr);
+	release_perfctr_nmi(wd->perfctr_msr);
+}
+
+#define P6_EVNTSEL0_ENABLE	(1 << 22)
+#define P6_EVNTSEL_INT		(1 << 20)
+#define P6_EVNTSEL_OS		(1 << 17)
+#define P6_EVNTSEL_USR		(1 << 16)
+#define P6_EVENT_CPU_CLOCKS_NOT_HALTED	0x79
+#define P6_NMI_EVENT		P6_EVENT_CPU_CLOCKS_NOT_HALTED
+
+static int setup_p6_watchdog(void)
+{
+	unsigned int perfctr_msr, evntsel_msr;
+	unsigned int evntsel;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	perfctr_msr = MSR_P6_PERFCTR0;
+	evntsel_msr = MSR_P6_EVNTSEL0;
+	if (!reserve_perfctr_nmi(perfctr_msr))
+		goto fail;
+
+	if (!reserve_evntsel_nmi(evntsel_msr))
+		goto fail1;
+
+	wrmsrl(perfctr_msr, 0UL);
+
+	evntsel = P6_EVNTSEL_INT
+		| P6_EVNTSEL_OS
+		| P6_EVNTSEL_USR
+		| P6_NMI_EVENT;
+
+	/* setup the timer */
+	wrmsr(evntsel_msr, evntsel, 0);
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0");
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= P6_EVNTSEL0_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = 0;  //unused
+	wd->check_bit = 1ULL<<39;
+	return 1;
+fail1:
+	release_perfctr_nmi(perfctr_msr);
+fail:
+	return 0;
+}
+
+static void stop_p6_watchdog(void)
+{
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	wrmsr(wd->evntsel_msr, 0, 0);
+
+	release_evntsel_nmi(wd->evntsel_msr);
+	release_perfctr_nmi(wd->perfctr_msr);
+}
+
+/* Note that these events don't tick when the CPU idles. This means
+   the frequency varies with CPU load. */
+
+#define MSR_P4_MISC_ENABLE_PERF_AVAIL	(1<<7)
+#define P4_ESCR_EVENT_SELECT(N)	((N)<<25)
+#define P4_ESCR_OS		(1<<3)
+#define P4_ESCR_USR		(1<<2)
+#define P4_CCCR_OVF_PMI0	(1<<26)
+#define P4_CCCR_OVF_PMI1	(1<<27)
+#define P4_CCCR_THRESHOLD(N)	((N)<<20)
+#define P4_CCCR_COMPLEMENT	(1<<19)
+#define P4_CCCR_COMPARE		(1<<18)
+#define P4_CCCR_REQUIRED	(3<<16)
+#define P4_CCCR_ESCR_SELECT(N)	((N)<<13)
+#define P4_CCCR_ENABLE		(1<<12)
+#define P4_CCCR_OVF 		(1<<31)
+/* Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
+   CRU_ESCR0 (with any non-null event selector) through a complemented
+   max threshold. [IA32-Vol3, Section 14.9.9] */
+
+static int setup_p4_watchdog(void)
+{
+	unsigned int perfctr_msr, evntsel_msr, cccr_msr;
+	unsigned int evntsel, cccr_val;
+	unsigned int misc_enable, dummy;
+	unsigned int ht_num;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	rdmsr(MSR_IA32_MISC_ENABLE, misc_enable, dummy);
+	if (!(misc_enable & MSR_P4_MISC_ENABLE_PERF_AVAIL))
+		return 0;
+
+#ifdef CONFIG_SMP
+	/* detect which hyperthread we are on */
+	if (smp_num_siblings == 2) {
+		unsigned int ebx, apicid;
+
+        	ebx = cpuid_ebx(1);
+	        apicid = (ebx >> 24) & 0xff;
+        	ht_num = apicid & 1;
+	} else
+#endif
+		ht_num = 0;
+
+	/* performance counters are shared resources
+	 * assign each hyperthread its own set
+	 * (re-use the ESCR0 register, seems safe
+	 * and keeps the cccr_val the same)
+	 */
+	if (!ht_num) {
+		/* logical cpu 0 */
+		perfctr_msr = MSR_P4_IQ_PERFCTR0;
+		evntsel_msr = MSR_P4_CRU_ESCR0;
+		cccr_msr = MSR_P4_IQ_CCCR0;
+		cccr_val = P4_CCCR_OVF_PMI0 | P4_CCCR_ESCR_SELECT(4);
+	} else {
+		/* logical cpu 1 */
+		perfctr_msr = MSR_P4_IQ_PERFCTR1;
+		evntsel_msr = MSR_P4_CRU_ESCR0;
+		cccr_msr = MSR_P4_IQ_CCCR1;
+		cccr_val = P4_CCCR_OVF_PMI1 | P4_CCCR_ESCR_SELECT(4);
+	}
+
+	if (!reserve_perfctr_nmi(perfctr_msr))
+		goto fail;
+
+	if (!reserve_evntsel_nmi(evntsel_msr))
+		goto fail1;
+
+	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
+	 	| P4_ESCR_OS
+		| P4_ESCR_USR;
+
+	cccr_val |= P4_CCCR_THRESHOLD(15)
+		 | P4_CCCR_COMPLEMENT
+		 | P4_CCCR_COMPARE
+		 | P4_CCCR_REQUIRED;
+
+	wrmsr(evntsel_msr, evntsel, 0);
+	wrmsr(cccr_msr, cccr_val, 0);
+	write_watchdog_counter(perfctr_msr, "P4_IQ_COUNTER0");
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	cccr_val |= P4_CCCR_ENABLE;
+	wrmsr(cccr_msr, cccr_val, 0);
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = cccr_msr;
+	wd->check_bit = 1ULL<<39;
+	return 1;
+fail1:
+	release_perfctr_nmi(perfctr_msr);
+fail:
+	return 0;
+}
+
+static void stop_p4_watchdog(void)
+{
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	wrmsr(wd->cccr_msr, 0, 0);
+	wrmsr(wd->evntsel_msr, 0, 0);
+
+	release_evntsel_nmi(wd->evntsel_msr);
+	release_perfctr_nmi(wd->perfctr_msr);
+}
+
+#define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
+#define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
+
+static int setup_intel_arch_watchdog(void)
+{
+	unsigned int ebx;
+	union cpuid10_eax eax;
+	unsigned int unused;
+	unsigned int perfctr_msr, evntsel_msr;
+	unsigned int evntsel;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Unhalted Core Cycles Event or not.
+	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
+	 */
+	cpuid(10, &(eax.full), &ebx, &unused, &unused);
+	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
+	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
+		goto fail;
+
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
+
+	if (!reserve_perfctr_nmi(perfctr_msr))
+		goto fail;
+
+	if (!reserve_evntsel_nmi(evntsel_msr))
+		goto fail1;
+
+	wrmsrl(perfctr_msr, 0UL);
+
+	evntsel = ARCH_PERFMON_EVENTSEL_INT
+		| ARCH_PERFMON_EVENTSEL_OS
+		| ARCH_PERFMON_EVENTSEL_USR
+		| ARCH_PERFMON_NMI_EVENT_SEL
+		| ARCH_PERFMON_NMI_EVENT_UMASK;
+
+	/* setup the timer */
+	wrmsr(evntsel_msr, evntsel, 0);
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0");
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = 0;  //unused
+	wd->check_bit = 1ULL << (eax.split.bit_width - 1);
+	return 1;
+fail1:
+	release_perfctr_nmi(perfctr_msr);
+fail:
+	return 0;
+}
+
+static void stop_intel_arch_watchdog(void)
+{
+	unsigned int ebx;
+	union cpuid10_eax eax;
+	unsigned int unused;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Unhalted Core Cycles Event or not.
+	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
+	 */
+	cpuid(10, &(eax.full), &ebx, &unused, &unused);
+	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
+	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
+		return;
+
+	wrmsr(wd->evntsel_msr, 0, 0);
+	release_evntsel_nmi(wd->evntsel_msr);
+	release_perfctr_nmi(wd->perfctr_msr);
 }
 
 void setup_apic_nmi_watchdog (void *unused)
 {
-	if (__get_cpu_var(wd_enabled))
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	/* only support LOCAL and IO APICs for now */
+	if ((nmi_watchdog != NMI_LOCAL_APIC) &&
+	    (nmi_watchdog != NMI_IO_APIC))
+	    	return;
+
+	if (wd->enabled == 1)
 		return;
 
 	/* cheap hack to support suspend/resume */
@@ -248,31 +806,88 @@ void setup_apic_nmi_watchdog (void *unus
 	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
 		return;
 
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		__get_cpu_var(wd_enabled) = 1; /* enable it before to avoid race with handler */
-		if (lapic_watchdog_init(nmi_hz) < 0) {
-			__get_cpu_var(wd_enabled) = 0;
+	if (nmi_watchdog == NMI_LOCAL_APIC) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_AMD:
+			if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
+				boot_cpu_data.x86 != 16)
+				return;
+			if (!setup_k7_watchdog())
+				return;
+			break;
+		case X86_VENDOR_INTEL:
+			if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+				if (!setup_intel_arch_watchdog())
+					return;
+				break;
+			}
+			switch (boot_cpu_data.x86) {
+			case 6:
+				if (boot_cpu_data.x86_model > 0xd)
+					return;
+
+				if (!setup_p6_watchdog())
+					return;
+				break;
+			case 15:
+				if (boot_cpu_data.x86_model > 0x4)
+					return;
+
+				if (!setup_p4_watchdog())
+					return;
+				break;
+			default:
+				return;
+			}
+			break;
+		default:
 			return;
 		}
-		/* FALL THROUGH */
-	case NMI_IO_APIC:
-		__get_cpu_var(wd_enabled) = 1;
-		atomic_inc(&nmi_active);
 	}
+	wd->enabled = 1;
+	atomic_inc(&nmi_active);
 }
 
 void stop_apic_nmi_watchdog(void *unused)
 {
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
 	/* only support LOCAL and IO APICs for now */
 	if ((nmi_watchdog != NMI_LOCAL_APIC) &&
 	    (nmi_watchdog != NMI_IO_APIC))
 	    	return;
-	if (__get_cpu_var(wd_enabled) == 0)
+
+	if (wd->enabled == 0)
 		return;
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		lapic_watchdog_stop();
-	__get_cpu_var(wd_enabled) = 0;
+
+	if (nmi_watchdog == NMI_LOCAL_APIC) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_AMD:
+			stop_k7_watchdog();
+			break;
+		case X86_VENDOR_INTEL:
+			if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+				stop_intel_arch_watchdog();
+				break;
+			}
+			switch (boot_cpu_data.x86) {
+			case 6:
+				if (boot_cpu_data.x86_model > 0xd)
+					break;
+				stop_p6_watchdog();
+				break;
+			case 15:
+				if (boot_cpu_data.x86_model > 0x4)
+					break;
+				stop_p4_watchdog();
+				break;
+			}
+			break;
+		default:
+			return;
+		}
+	}
+	wd->enabled = 0;
 	atomic_dec(&nmi_active);
 }
 
@@ -328,6 +943,8 @@ __kprobes int nmi_watchdog_tick(struct p
 	unsigned int sum;
 	int touched = 0;
 	int cpu = smp_processor_id();
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+	u64 dummy;
 	int rc=0;
 
 	/* check for other users first */
@@ -370,20 +987,53 @@ __kprobes int nmi_watchdog_tick(struct p
 		alert_counter[cpu] = 0;
 	}
 	/* see if the nmi watchdog went off */
-	if (!__get_cpu_var(wd_enabled))
-		return rc;
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		rc |= lapic_wd_event(nmi_hz);
-		break;
-	case NMI_IO_APIC:
-		/* don't know how to accurately check for this.
-		 * just assume it was a watchdog timer interrupt
-		 * This matches the old behaviour.
-		 */
-		rc = 1;
-		break;
+	if (wd->enabled) {
+		if (nmi_watchdog == NMI_LOCAL_APIC) {
+			rdmsrl(wd->perfctr_msr, dummy);
+			if (dummy & wd->check_bit){
+				/* this wasn't a watchdog timer interrupt */
+				goto done;
+			}
+
+			/* only Intel P4 uses the cccr msr */
+	 		if (wd->cccr_msr != 0) {
+	 			/*
+	 			 * P4 quirks:
+	 			 * - An overflown perfctr will assert its interrupt
+	 			 *   until the OVF flag in its CCCR is cleared.
+	 			 * - LVTPC is masked on interrupt and must be
+	 			 *   unmasked by the LVTPC handler.
+	 			 */
+				rdmsrl(wd->cccr_msr, dummy);
+				dummy &= ~P4_CCCR_OVF;
+	 			wrmsrl(wd->cccr_msr, dummy);
+	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* start the cycle over again */
+				write_watchdog_counter(wd->perfctr_msr, NULL);
+	 		}
+			else if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
+				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
+				/* P6 based Pentium M need to re-unmask
+				 * the apic vector but it doesn't hurt
+				 * other P6 variant.
+				 * ArchPerfom/Core Duo also needs this */
+				apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* P6/ARCH_PERFMON has 32 bit counter write */
+				write_watchdog_counter32(wd->perfctr_msr, NULL);
+			} else {
+				/* start the cycle over again */
+				write_watchdog_counter(wd->perfctr_msr, NULL);
+			}
+			rc = 1;
+		} else if (nmi_watchdog == NMI_IO_APIC) {
+			/* don't know how to accurately check for this.
+			 * just assume it was a watchdog timer interrupt
+			 * This matches the old behaviour.
+			 */
+			rc = 1;
+		}
 	}
+done:
 	return rc;
 }
 
@@ -428,7 +1078,7 @@ int proc_nmi_enabled(struct ctl_table *t
 	}
 
 	if (nmi_watchdog == NMI_DEFAULT) {
-		if (lapic_watchdog_ok())
+		if (nmi_known_cpu() > 0)
 			nmi_watchdog = NMI_LOCAL_APIC;
 		else
 			nmi_watchdog = NMI_IO_APIC;
@@ -464,3 +1114,11 @@ void __trigger_all_cpu_backtrace(void)
 
 EXPORT_SYMBOL(nmi_active);
 EXPORT_SYMBOL(nmi_watchdog);
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
+EXPORT_SYMBOL(reserve_perfctr_nmi);
+EXPORT_SYMBOL(release_perfctr_nmi);
+EXPORT_SYMBOL(reserve_evntsel_nmi);
+EXPORT_SYMBOL(release_evntsel_nmi);
+EXPORT_SYMBOL(disable_timer_nmi_watchdog);
+EXPORT_SYMBOL(enable_timer_nmi_watchdog);
diff -puN include/asm-i386/nmi.h~revert-x86_64-mm-nmi-watchdog-ops include/asm-i386/nmi.h
--- a/include/asm-i386/nmi.h~revert-x86_64-mm-nmi-watchdog-ops
+++ a/include/asm-i386/nmi.h
@@ -50,12 +50,4 @@ void __trigger_all_cpu_backtrace(void);
 
 #endif
 
-void lapic_watchdog_stop(void);
-int lapic_watchdog_init(unsigned nmi_hz);
-int lapic_wd_event(unsigned nmi_hz);
-unsigned lapic_adjust_nmi_hz(unsigned hz);
-int lapic_watchdog_ok(void);
-void disable_lapic_nmi_watchdog(void);
-void enable_lapic_nmi_watchdog(void);
-
 #endif /* ASM_NMI_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
packet-fix-error-handling.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
device_schedule_callback-needs-a-module-reference-fix.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-fix.patch
dev_dbg-check-dev_dbg-arguments-fix.patch
dev_dbg-check-dev_dbg-arguments-fix-2.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
sbp2-include-fixes.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-irq-registration-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-fix-yamc.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-3.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
pci-error-recovery-symbios-scsi-base-support-fixes.patch
pci-error-recovery-symbios-scsi-first-failure-fix.patch
cxacru-add-documentation-file-fix.patch
revert-x86_64-mm-nmi-watchdog-ops.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
extend-print_symbol-capability-fix-fix.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-more-statics.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
