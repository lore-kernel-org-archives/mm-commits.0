From: akpm@osdl.org
Subject: + x86-rewrite-smp-tsc-sync-code.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:57 -0800
Message-ID: <200701250635.l0P6Zvqd008286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50468 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965596AbXAYGja (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     x86: rewrite SMP TSC sync code
has been added to the -mm tree.  Its filename is
     x86-rewrite-smp-tsc-sync-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: rewrite SMP TSC sync code
From: Ingo Molnar <mingo@elte.hu>

make the TSC synchronization code more robust, and unify it between x86_64 and
i386.

The biggest change is the removal of the 'fix up TSCs' code on x86_64 and
i386, in some rare cases it was /causing/ time-warps on SMP systems.

The new code only checks for TSC asynchronity - and if it can prove a
time-warp (if it can observe the TSC going backwards when going from one CPU
to another within a critical section), then the TSC clock-source is turned
off.

The TSC synchronization-checking code also got moved into a separate file.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/Makefile     |    2 
 arch/i386/kernel/smpboot.c    |  178 +-----------------------
 arch/i386/kernel/tsc.c        |    4 
 arch/i386/kernel/tsc_sync.c   |    1 
 arch/x86_64/kernel/Makefile   |    2 
 arch/x86_64/kernel/smpboot.c  |  230 +-------------------------------
 arch/x86_64/kernel/time.c     |   11 +
 arch/x86_64/kernel/tsc_sync.c |  187 ++++++++++++++++++++++++++
 include/asm-i386/tsc.h        |   49 ------
 include/asm-x86_64/proto.h    |    2 
 include/asm-x86_64/timex.h    |   26 ---
 include/asm-x86_64/tsc.h      |   66 +++++++++
 12 files changed, 295 insertions(+), 463 deletions(-)

diff -puN arch/i386/kernel/Makefile~x86-rewrite-smp-tsc-sync-code arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~x86-rewrite-smp-tsc-sync-code
+++ a/arch/i386/kernel/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o
+obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
diff -puN arch/i386/kernel/smpboot.c~x86-rewrite-smp-tsc-sync-code arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~x86-rewrite-smp-tsc-sync-code
+++ a/arch/i386/kernel/smpboot.c
@@ -93,12 +93,6 @@ cpumask_t cpu_possible_map;
 EXPORT_SYMBOL(cpu_possible_map);
 static cpumask_t smp_commenced_mask;
 
-/* TSC's upper 32 bits can't be written in eariler CPU (before prescott), there
- * is no way to resync one AP against BP. TBD: for prescott and above, we
- * should use IA64's algorithm
- */
-static int __devinitdata tsc_sync_disabled;
-
 /* Per CPU bogomips and other parameters */
 struct cpuinfo_x86 cpu_data[NR_CPUS] __cacheline_aligned;
 EXPORT_SYMBOL(cpu_data);
@@ -215,151 +209,6 @@ valid_k7:
 	;
 }
 
-/*
- * TSC synchronization.
- *
- * We first check whether all CPUs have their TSC's synchronized,
- * then we print a warning if not, and always resync.
- */
-
-static struct {
-	atomic_t start_flag;
-	atomic_t count_start;
-	atomic_t count_stop;
-	unsigned long long values[NR_CPUS];
-} tsc __cpuinitdata = {
-	.start_flag = ATOMIC_INIT(0),
-	.count_start = ATOMIC_INIT(0),
-	.count_stop = ATOMIC_INIT(0),
-};
-
-#define NR_LOOPS 5
-
-static void __init synchronize_tsc_bp(void)
-{
-	int i;
-	unsigned long long t0;
-	unsigned long long sum, avg;
-	long long delta;
-	unsigned int one_usec;
-	int buggy = 0;
-
-	printk(KERN_INFO "checking TSC synchronization across %u CPUs: ", num_booting_cpus());
-
-	/* convert from kcyc/sec to cyc/usec */
-	one_usec = cpu_khz / 1000;
-
-	atomic_set(&tsc.start_flag, 1);
-	wmb();
-
-	/*
-	 * We loop a few times to get a primed instruction cache,
-	 * then the last pass is more or less synchronized and
-	 * the BP and APs set their cycle counters to zero all at
-	 * once. This reduces the chance of having random offsets
-	 * between the processors, and guarantees that the maximum
-	 * delay between the cycle counters is never bigger than
-	 * the latency of information-passing (cachelines) between
-	 * two CPUs.
-	 */
-	for (i = 0; i < NR_LOOPS; i++) {
-		/*
-		 * all APs synchronize but they loop on '== num_cpus'
-		 */
-		while (atomic_read(&tsc.count_start) != num_booting_cpus()-1)
-			cpu_relax();
-		atomic_set(&tsc.count_stop, 0);
-		wmb();
-		/*
-		 * this lets the APs save their current TSC:
-		 */
-		atomic_inc(&tsc.count_start);
-
-		rdtscll(tsc.values[smp_processor_id()]);
-		/*
-		 * We clear the TSC in the last loop:
-		 */
-		if (i == NR_LOOPS-1)
-			write_tsc(0, 0);
-
-		/*
-		 * Wait for all APs to leave the synchronization point:
-		 */
-		while (atomic_read(&tsc.count_stop) != num_booting_cpus()-1)
-			cpu_relax();
-		atomic_set(&tsc.count_start, 0);
-		wmb();
-		atomic_inc(&tsc.count_stop);
-	}
-
-	sum = 0;
-	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_isset(i, cpu_callout_map)) {
-			t0 = tsc.values[i];
-			sum += t0;
-		}
-	}
-	avg = sum;
-	do_div(avg, num_booting_cpus());
-
-	for (i = 0; i < NR_CPUS; i++) {
-		if (!cpu_isset(i, cpu_callout_map))
-			continue;
-		delta = tsc.values[i] - avg;
-		if (delta < 0)
-			delta = -delta;
-		/*
-		 * We report bigger than 2 microseconds clock differences.
-		 */
-		if (delta > 2*one_usec) {
-			long long realdelta;
-
-			if (!buggy) {
-				buggy = 1;
-				printk("\n");
-			}
-			realdelta = delta;
-			do_div(realdelta, one_usec);
-			if (tsc.values[i] < avg)
-				realdelta = -realdelta;
-
-			if (realdelta)
-				printk(KERN_INFO "CPU#%d had %Ld usecs TSC "
-					"skew, fixed it up.\n", i, realdelta);
-		}
-	}
-	if (!buggy)
-		printk("passed.\n");
-}
-
-static void __cpuinit synchronize_tsc_ap(void)
-{
-	int i;
-
-	/*
-	 * Not every cpu is online at the time
-	 * this gets called, so we first wait for the BP to
-	 * finish SMP initialization:
-	 */
-	while (!atomic_read(&tsc.start_flag))
-		cpu_relax();
-
-	for (i = 0; i < NR_LOOPS; i++) {
-		atomic_inc(&tsc.count_start);
-		while (atomic_read(&tsc.count_start) != num_booting_cpus())
-			cpu_relax();
-
-		rdtscll(tsc.values[smp_processor_id()]);
-		if (i == NR_LOOPS-1)
-			write_tsc(0, 0);
-
-		atomic_inc(&tsc.count_stop);
-		while (atomic_read(&tsc.count_stop) != num_booting_cpus())
-			cpu_relax();
-	}
-}
-#undef NR_LOOPS
-
 extern void calibrate_delay(void);
 
 static atomic_t init_deasserted;
@@ -445,12 +294,6 @@ static void __cpuinit smp_callin(void)
 	 * Allow the master to continue.
 	 */
 	cpu_set(cpuid, cpu_callin_map);
-
-	/*
-	 *      Synchronize the TSC with the BP
-	 */
-	if (cpu_has_tsc && cpu_khz && !tsc_sync_disabled)
-		synchronize_tsc_ap();
 }
 
 static int cpucount;
@@ -553,6 +396,11 @@ static void __cpuinit start_secondary(vo
 	smp_callin();
 	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
 		rep_nop();
+	/*
+	 * Check TSC synchronization with the BP:
+	 */
+	check_tsc_sync_target();
+
 	setup_secondary_clock();
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
@@ -1125,8 +973,6 @@ static int __cpuinit __smp_prepare_cpu(i
 	info.cpu = cpu;
 	INIT_WORK(&info.task, do_warm_boot_cpu);
 
-	tsc_sync_disabled = 1;
-
 	/* init low mem mapping */
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
 			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
@@ -1134,7 +980,6 @@ static int __cpuinit __smp_prepare_cpu(i
 	schedule_work(&info.task);
 	wait_for_completion(&done);
 
-	tsc_sync_disabled = 0;
 	zap_low_mappings();
 	ret = 0;
 exit:
@@ -1331,12 +1176,6 @@ static void __init smp_boot_cpus(unsigne
 	smpboot_setup_io_apic();
 
 	setup_boot_clock();
-
-	/*
-	 * Synchronize the TSC with the AP
-	 */
-	if (cpu_has_tsc && cpucount && cpu_khz)
-		synchronize_tsc_bp();
 }
 
 /* These are wrappers to interface to the new boot process.  Someone
@@ -1471,9 +1310,16 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	}
 
 	local_irq_enable();
+
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Unleash the CPU! */
 	cpu_set(cpu, smp_commenced_mask);
+
+	/*
+	 * Check TSC synchronization with the AP:
+	 */
+	check_tsc_sync_source(cpu);
+
 	while (!cpu_isset(cpu, cpu_online_map))
 		cpu_relax();
 	return 0;
diff -puN arch/i386/kernel/tsc.c~x86-rewrite-smp-tsc-sync-code arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~x86-rewrite-smp-tsc-sync-code
+++ a/arch/i386/kernel/tsc.c
@@ -407,8 +407,10 @@ out:
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
  */
-static __init int unsynchronized_tsc(void)
+__cpuinit int unsynchronized_tsc(void)
 {
+	if (!cpu_has_tsc || tsc_unstable)
+		return 1;
 	/*
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
diff -puN /dev/null arch/i386/kernel/tsc_sync.c
--- /dev/null
+++ a/arch/i386/kernel/tsc_sync.c
@@ -0,0 +1 @@
+#include "../../x86_64/kernel/tsc_sync.c"
diff -puN arch/x86_64/kernel/Makefile~x86-rewrite-smp-tsc-sync-code arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~x86-rewrite-smp-tsc-sync-code
+++ a/arch/x86_64/kernel/Makefile
@@ -19,7 +19,7 @@ obj-$(CONFIG_ACPI)		+= acpi/
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o
+obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o tsc_sync.o
 obj-y				+= apic.o  nmi.o
 obj-y				+= io_apic.o mpparse.o genapic.o genapic_flat.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
diff -puN arch/x86_64/kernel/smpboot.c~x86-rewrite-smp-tsc-sync-code arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86-rewrite-smp-tsc-sync-code
+++ a/arch/x86_64/kernel/smpboot.c
@@ -147,217 +147,6 @@ static void __cpuinit smp_store_cpu_info
 	print_cpu_info(c);
 }
 
-/*
- * New Funky TSC sync algorithm borrowed from IA64.
- * Main advantage is that it doesn't reset the TSCs fully and
- * in general looks more robust and it works better than my earlier
- * attempts. I believe it was written by David Mosberger. Some minor
- * adjustments for x86-64 by me -AK
- *
- * Original comment reproduced below.
- *
- * Synchronize TSC of the current (slave) CPU with the TSC of the
- * MASTER CPU (normally the time-keeper CPU).  We use a closed loop to
- * eliminate the possibility of unaccounted-for errors (such as
- * getting a machine check in the middle of a calibration step).  The
- * basic idea is for the slave to ask the master what itc value it has
- * and to read its own itc before and after the master responds.  Each
- * iteration gives us three timestamps:
- *
- *	slave		master
- *
- *	t0 ---\
- *             ---\
- *		   --->
- *			tm
- *		   /---
- *	       /---
- *	t1 <---
- *
- *
- * The goal is to adjust the slave's TSC such that tm falls exactly
- * half-way between t0 and t1.  If we achieve this, the clocks are
- * synchronized provided the interconnect between the slave and the
- * master is symmetric.  Even if the interconnect were asymmetric, we
- * would still know that the synchronization error is smaller than the
- * roundtrip latency (t0 - t1).
- *
- * When the interconnect is quiet and symmetric, this lets us
- * synchronize the TSC to within one or two cycles.  However, we can
- * only *guarantee* that the synchronization is accurate to within a
- * round-trip time, which is typically in the range of several hundred
- * cycles (e.g., ~500 cycles).  In practice, this means that the TSCs
- * are usually almost perfectly synchronized, but we shouldn't assume
- * that the accuracy is much better than half a micro second or so.
- *
- * [there are other errors like the latency of RDTSC and of the
- * WRMSR. These can also account to hundreds of cycles. So it's
- * probably worse. It claims 153 cycles error on a dual Opteron,
- * but I suspect the numbers are actually somewhat worse -AK]
- */
-
-#define MASTER	0
-#define SLAVE	(SMP_CACHE_BYTES/8)
-
-/* Intentionally don't use cpu_relax() while TSC synchronization
-   because we don't want to go into funky power save modi or cause
-   hypervisors to schedule us away.  Going to sleep would likely affect
-   latency and low latency is the primary objective here. -AK */
-#define no_cpu_relax() barrier()
-
-static __cpuinitdata DEFINE_SPINLOCK(tsc_sync_lock);
-static volatile __cpuinitdata unsigned long go[SLAVE + 1];
-static int notscsync __cpuinitdata;
-
-#undef DEBUG_TSC_SYNC
-
-#define NUM_ROUNDS	64	/* magic value */
-#define NUM_ITERS	5	/* likewise */
-
-/* Callback on boot CPU */
-static __cpuinit void sync_master(void *arg)
-{
-	unsigned long flags, i;
-
-	go[MASTER] = 0;
-
-	local_irq_save(flags);
-	{
-		for (i = 0; i < NUM_ROUNDS*NUM_ITERS; ++i) {
-			while (!go[MASTER])
-				no_cpu_relax();
-			go[MASTER] = 0;
-			rdtscll(go[SLAVE]);
-		}
-	}
-	local_irq_restore(flags);
-}
-
-/*
- * Return the number of cycles by which our tsc differs from the tsc
- * on the master (time-keeper) CPU.  A positive number indicates our
- * tsc is ahead of the master, negative that it is behind.
- */
-static inline long
-get_delta(long *rt, long *master)
-{
-	unsigned long best_t0 = 0, best_t1 = ~0UL, best_tm = 0;
-	unsigned long tcenter, t0, t1, tm;
-	int i;
-
-	for (i = 0; i < NUM_ITERS; ++i) {
-		rdtscll(t0);
-		go[MASTER] = 1;
-		while (!(tm = go[SLAVE]))
-			no_cpu_relax();
-		go[SLAVE] = 0;
-		rdtscll(t1);
-
-		if (t1 - t0 < best_t1 - best_t0)
-			best_t0 = t0, best_t1 = t1, best_tm = tm;
-	}
-
-	*rt = best_t1 - best_t0;
-	*master = best_tm - best_t0;
-
-	/* average best_t0 and best_t1 without overflow: */
-	tcenter = (best_t0/2 + best_t1/2);
-	if (best_t0 % 2 + best_t1 % 2 == 2)
-		++tcenter;
-	return tcenter - best_tm;
-}
-
-static __cpuinit void sync_tsc(unsigned int master)
-{
-	int i, done = 0;
-	long delta, adj, adjust_latency = 0;
-	unsigned long flags, rt, master_time_stamp, bound;
-#ifdef DEBUG_TSC_SYNC
-	static struct syncdebug {
-		long rt;	/* roundtrip time */
-		long master;	/* master's timestamp */
-		long diff;	/* difference between midpoint and master's timestamp */
-		long lat;	/* estimate of tsc adjustment latency */
-	} t[NUM_ROUNDS] __cpuinitdata;
-#endif
-
-	printk(KERN_INFO "CPU %d: Syncing TSC to CPU %u.\n",
-		smp_processor_id(), master);
-
-	go[MASTER] = 1;
-
-	/* It is dangerous to broadcast IPI as cpus are coming up,
-	 * as they may not be ready to accept them.  So since
-	 * we only need to send the ipi to the boot cpu direct
-	 * the message, and avoid the race.
-	 */
-	smp_call_function_single(master, sync_master, NULL, 1, 0);
-
-	while (go[MASTER])	/* wait for master to be ready */
-		no_cpu_relax();
-
-	spin_lock_irqsave(&tsc_sync_lock, flags);
-	{
-		for (i = 0; i < NUM_ROUNDS; ++i) {
-			delta = get_delta(&rt, &master_time_stamp);
-			if (delta == 0) {
-				done = 1;	/* let's lock on to this... */
-				bound = rt;
-			}
-
-			if (!done) {
-				unsigned long t;
-				if (i > 0) {
-					adjust_latency += -delta;
-					adj = -delta + adjust_latency/4;
-				} else
-					adj = -delta;
-
-				rdtscll(t);
-				wrmsrl(MSR_IA32_TSC, t + adj);
-			}
-#ifdef DEBUG_TSC_SYNC
-			t[i].rt = rt;
-			t[i].master = master_time_stamp;
-			t[i].diff = delta;
-			t[i].lat = adjust_latency/4;
-#endif
-		}
-	}
-	spin_unlock_irqrestore(&tsc_sync_lock, flags);
-
-#ifdef DEBUG_TSC_SYNC
-	for (i = 0; i < NUM_ROUNDS; ++i)
-		printk("rt=%5ld master=%5ld diff=%5ld adjlat=%5ld\n",
-		       t[i].rt, t[i].master, t[i].diff, t[i].lat);
-#endif
-
-	printk(KERN_INFO
-	       "CPU %d: synchronized TSC with CPU %u (last diff %ld cycles, "
-	       "maxerr %lu cycles)\n",
-	       smp_processor_id(), master, delta, rt);
-}
-
-static void __cpuinit tsc_sync_wait(void)
-{
-	/*
-	 * When the CPU has synchronized TSCs assume the BIOS
-  	 * or the hardware already synced.  Otherwise we could
-	 * mess up a possible perfect synchronization with a
-	 * not-quite-perfect algorithm.
-	 */
-	if (notscsync || !cpu_has_tsc || !unsynchronized_tsc())
-		return;
-	sync_tsc(0);
-}
-
-static __init int notscsync_setup(char *s)
-{
-	notscsync = 1;
-	return 1;
-}
-__setup("notscsync", notscsync_setup);
-
 static atomic_t init_deasserted __cpuinitdata;
 
 /*
@@ -545,6 +334,11 @@ void __cpuinit start_secondary(void)
 	/* otherwise gcc will move up the smp_processor_id before the cpu_init */
 	barrier();
 
+	/*
+  	 * Check TSC sync first:
+ 	 */
+	check_tsc_sync_target();
+
 	Dprintk("cpu %d: setting up apic clock\n", smp_processor_id()); 	
 	setup_secondary_APIC_clock();
 
@@ -564,14 +358,6 @@ void __cpuinit start_secondary(void)
 	 */
 	set_cpu_sibling_map(smp_processor_id());
 
-	/* 
-  	 * Wait for TSC sync to not schedule things before.
-	 * We still process interrupts, which could see an inconsistent
-	 * time in that window unfortunately. 
-	 * Do this here because TSC sync has global unprotected state.
- 	 */
-	tsc_sync_wait();
-
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
@@ -591,6 +377,7 @@ void __cpuinit start_secondary(void)
 	cpu_set(smp_processor_id(), cpu_online_map);
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
+
 	unlock_ipi_call_lock();
 
 	cpu_idle();
@@ -1166,6 +953,11 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	/* Unleash the CPU! */
 	Dprintk("waiting for cpu %d\n", cpu);
 
+	/*
+  	 * Make sure and check TSC sync:
+ 	 */
+	check_tsc_sync_source(cpu);
+
 	while (!cpu_isset(cpu, cpu_online_map))
 		cpu_relax();
 	err = 0;
diff -puN arch/x86_64/kernel/time.c~x86-rewrite-smp-tsc-sync-code arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86-rewrite-smp-tsc-sync-code
+++ a/arch/x86_64/kernel/time.c
@@ -939,12 +939,23 @@ void __init time_init(void)
 #endif
 }
 
+static int tsc_unstable = 0;
+
+void mark_tsc_unstable(void)
+{
+	tsc_unstable = 1;
+}
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
  */
 __cpuinit int unsynchronized_tsc(void)
 {
+	if (tsc_unstable)
+		return 1;
+
 #ifdef CONFIG_SMP
 	if (apic_is_clustered_box())
 		return 1;
diff -puN /dev/null arch/x86_64/kernel/tsc_sync.c
--- /dev/null
+++ a/arch/x86_64/kernel/tsc_sync.c
@@ -0,0 +1,187 @@
+/*
+ * arch/x86_64/kernel/tsc_sync.c: check TSC synchronization.
+ *
+ * Copyright (C) 2006, Red Hat, Inc., Ingo Molnar
+ *
+ * We check whether all boot CPUs have their TSC's synchronized,
+ * print a warning if not and turn off the TSC clock-source.
+ *
+ * The warp-check is point-to-point between two CPUs, the CPU
+ * initiating the bootup is the 'source CPU', the freshly booting
+ * CPU is the 'target CPU'.
+ *
+ * Only two CPUs may participate - they can enter in any order.
+ * ( The serial nature of the boot logic and the CPU hotplug lock
+ *   protects against more than 2 CPUs entering this code. )
+ */
+#include <linux/spinlock.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/nmi.h>
+#include <asm/tsc.h>
+
+/*
+ * Entry/exit counters that make sure that both CPUs
+ * run the measurement code at once:
+ */
+static __cpuinitdata atomic_t start_count;
+static __cpuinitdata atomic_t stop_count;
+
+/*
+ * We use a raw spinlock in this exceptional case, because
+ * we want to have the fastest, inlined, non-debug version
+ * of a critical section, to be able to prove TSC time-warps:
+ */
+static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static __cpuinitdata cycles_t last_tsc;
+static __cpuinitdata cycles_t max_warp;
+static __cpuinitdata int nr_warps;
+
+/*
+ * TSC-warp measurement loop running on both CPUs:
+ */
+static __cpuinit void check_tsc_warp(void)
+{
+	cycles_t start, now, prev, end;
+	int i;
+
+	start = get_cycles_sync();
+	/*
+	 * The measurement runs for 20 msecs:
+	 */
+	end = start + cpu_khz * 20ULL;
+	now = start;
+
+	for (i = 0; ; i++) {
+		/*
+		 * We take the global lock, measure TSC, save the
+		 * previous TSC that was measured (possibly on
+		 * another CPU) and update the previous TSC timestamp.
+		 */
+		__raw_spin_lock(&sync_lock);
+		prev = last_tsc;
+		now = get_cycles_sync();
+		last_tsc = now;
+		__raw_spin_unlock(&sync_lock);
+
+		/*
+		 * Be nice every now and then (and also check whether
+		 * measurement is done [we also insert a 100 million
+		 * loops safety exit, so we dont lock up in case the
+		 * TSC readout is totally broken]):
+		 */
+		if (unlikely(!(i & 7))) {
+			if (now > end || i > 100000000)
+				break;
+			cpu_relax();
+			touch_nmi_watchdog();
+		}
+		/*
+		 * Outside the critical section we can now see whether
+		 * we saw a time-warp of the TSC going backwards:
+		 */
+		if (unlikely(prev > now)) {
+			__raw_spin_lock(&sync_lock);
+			max_warp = max(max_warp, prev - now);
+			nr_warps++;
+			__raw_spin_unlock(&sync_lock);
+		}
+
+	}
+}
+
+/*
+ * Source CPU calls into this - it waits for the freshly booted
+ * target CPU to arrive and then starts the measurement:
+ */
+void __cpuinit check_tsc_sync_source(int cpu)
+{
+	int cpus = 2;
+
+	/*
+	 * No need to check if we already know that the TSC is not
+	 * synchronized:
+	 */
+	if (unsynchronized_tsc())
+		return;
+
+	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
+			  smp_processor_id(), cpu);
+
+	/*
+	 * Reset it - in case this is a second bootup:
+	 */
+	atomic_set(&stop_count, 0);
+
+	/*
+	 * Wait for the target to arrive:
+	 */
+	while (atomic_read(&start_count) != cpus-1)
+		cpu_relax();
+	/*
+	 * Trigger the target to continue into the measurement too:
+	 */
+	atomic_inc(&start_count);
+
+	check_tsc_warp();
+
+	while (atomic_read(&stop_count) != cpus-1)
+		cpu_relax();
+
+	/*
+	 * Reset it - just in case we boot another CPU later:
+	 */
+	atomic_set(&start_count, 0);
+
+	if (nr_warps) {
+		printk("\n");
+		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
+				    " turning off TSC clock.\n", max_warp);
+		mark_tsc_unstable();
+		nr_warps = 0;
+		max_warp = 0;
+		last_tsc = 0;
+	} else {
+		printk(" passed.\n");
+	}
+
+	/*
+	 * Let the target continue with the bootup:
+	 */
+	atomic_inc(&stop_count);
+}
+
+/*
+ * Freshly booted CPUs call into this:
+ */
+void __cpuinit check_tsc_sync_target(void)
+{
+	int cpus = 2;
+
+	if (unsynchronized_tsc())
+		return;
+
+	/*
+	 * Register this CPU's participation and wait for the
+	 * source CPU to start the measurement:
+	 */
+	atomic_inc(&start_count);
+	while (atomic_read(&start_count) != cpus)
+		cpu_relax();
+
+	check_tsc_warp();
+
+	/*
+	 * Ok, we are done:
+	 */
+	atomic_inc(&stop_count);
+
+	/*
+	 * Wait for the source CPU to print stuff:
+	 */
+	while (atomic_read(&stop_count) != cpus)
+		cpu_relax();
+}
+#undef NR_LOOPS
+
diff -puN include/asm-i386/tsc.h~x86-rewrite-smp-tsc-sync-code include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~x86-rewrite-smp-tsc-sync-code
+++ a/include/asm-i386/tsc.h
@@ -1,48 +1 @@
-/*
- * linux/include/asm-i386/tsc.h
- *
- * i386 TSC related functions
- */
-#ifndef _ASM_i386_TSC_H
-#define _ASM_i386_TSC_H
-
-#include <asm/processor.h>
-
-/*
- * Standard way to access the cycle counter on i586+ CPUs.
- * Currently only used on SMP.
- *
- * If you really have a SMP machine with i486 chips or older,
- * compile for that, and this will just always return zero.
- * That's ok, it just means that the nicer scheduling heuristics
- * won't work for you.
- *
- * We only use the low 32 bits, and we'd simply better make sure
- * that we reschedule before that wraps. Scheduling at least every
- * four billion cycles just basically sounds like a good idea,
- * regardless of how fast the machine is.
- */
-typedef unsigned long long cycles_t;
-
-extern unsigned int cpu_khz;
-extern unsigned int tsc_khz;
-
-static inline cycles_t get_cycles(void)
-{
-	unsigned long long ret = 0;
-
-#ifndef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		return 0;
-#endif
-
-#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
-	rdtscll(ret);
-#endif
-	return ret;
-}
-
-extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
-
-#endif
+#include <asm-x86_64/tsc.h>
diff -puN include/asm-x86_64/proto.h~x86-rewrite-smp-tsc-sync-code include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86-rewrite-smp-tsc-sync-code
+++ a/include/asm-x86_64/proto.h
@@ -90,8 +90,6 @@ extern void check_efer(void);
 
 extern int unhandled_signal(struct task_struct *tsk, int sig);
 
-extern int unsynchronized_tsc(void);
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long table_start, table_end;
diff -puN include/asm-x86_64/timex.h~x86-rewrite-smp-tsc-sync-code include/asm-x86_64/timex.h
--- a/include/asm-x86_64/timex.h~x86-rewrite-smp-tsc-sync-code
+++ a/include/asm-x86_64/timex.h
@@ -12,35 +12,11 @@
 #include <asm/hpet.h>
 #include <asm/system.h>
 #include <asm/processor.h>
+#include <asm/tsc.h>
 #include <linux/compiler.h>
 
 #define CLOCK_TICK_RATE	PIT_TICK_RATE	/* Underlying HZ */
 
-typedef unsigned long long cycles_t;
-
-static inline cycles_t get_cycles (void)
-{
-	unsigned long long ret;
-
-	rdtscll(ret);
-	return ret;
-}
-
-/* Like get_cycles, but make sure the CPU is synchronized. */
-static __always_inline cycles_t get_cycles_sync(void)
-{
-	unsigned long long ret;
-	unsigned eax;
-	/* Don't do an additional sync on CPUs where we know
-	   RDTSC is already synchronous. */
-	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
-			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-	rdtscll(ret);
-	return ret;
-}
-
-extern unsigned int cpu_khz;
-
 extern int read_current_timer(unsigned long *timer_value);
 #define ARCH_HAS_READ_CURRENT_TIMER	1
 
diff -puN /dev/null include/asm-x86_64/tsc.h
--- /dev/null
+++ a/include/asm-x86_64/tsc.h
@@ -0,0 +1,66 @@
+/*
+ * linux/include/asm-x86_64/tsc.h
+ *
+ * x86_64 TSC related functions
+ */
+#ifndef _ASM_x86_64_TSC_H
+#define _ASM_x86_64_TSC_H
+
+#include <asm/processor.h>
+
+/*
+ * Standard way to access the cycle counter.
+ */
+typedef unsigned long long cycles_t;
+
+extern unsigned int cpu_khz;
+extern unsigned int tsc_khz;
+
+static inline cycles_t get_cycles(void)
+{
+	unsigned long long ret = 0;
+
+#ifndef CONFIG_X86_TSC
+	if (!cpu_has_tsc)
+		return 0;
+#endif
+
+#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
+	rdtscll(ret);
+#endif
+	return ret;
+}
+
+/* Like get_cycles, but make sure the CPU is synchronized. */
+static __always_inline cycles_t get_cycles_sync(void)
+{
+	unsigned long long ret;
+#ifdef X86_FEATURE_SYNC_RDTSC
+	unsigned eax;
+
+	/*
+	 * Don't do an additional sync on CPUs where we know
+	 * RDTSC is already synchronous:
+	 */
+	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
+			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
+#else
+	sync_core();
+#endif
+	rdtscll(ret);
+
+	return ret;
+}
+
+extern void tsc_init(void);
+extern void mark_tsc_unstable(void);
+extern int unsynchronized_tsc(void);
+
+/*
+ * Boot-time check whether the TSCs are synchronized across
+ * all CPUs/cores:
+ */
+extern void check_tsc_sync_source(int cpu);
+extern void check_tsc_sync_target(void);
+
+#endif
_

Patches currently in -mm which might be from mingo@elte.hu are

kvm-add-vm-exit-profiling-fix.patch
revert-nmi_known_cpu-check-during-boot-option-parsing.patch
paravirt-mark-the-paravirt_ops-export-internal.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
acpi-fix-cpufreq-regression.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
i386-enable-dynticks-in-kconfig.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
sched-avoid-div-in-rebalance_tick.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
