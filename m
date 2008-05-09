From: akpm@linux-foundation.org
Subject: - revert-git-block.patch removed from -mm tree
Date: Fri, 09 May 2008 14:41:12 -0700
Message-ID: <200805092141.m49LfCwL026910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbYEIVlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     revert git-block
has been removed from the -mm tree.  Its filename was
     revert-git-block.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert git-block
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                               |    3 
 arch/alpha/Kconfig                         |    1 
 arch/alpha/kernel/core_marvel.c            |    6 
 arch/alpha/kernel/smp.c                    |  170 +
 arch/arm/Kconfig                           |    1 
 arch/arm/kernel/smp.c                      |  157 -
 arch/ia64/Kconfig                          |    1 
 arch/ia64/kernel/smp.c                     |  217 +
 arch/m32r/Kconfig                          |    1 
 arch/m32r/kernel/m32r_ksyms.c              |    3 
 arch/m32r/kernel/smp.c                     |  128 
 arch/m32r/kernel/traps.c                   |    3 
 arch/mips/Kconfig                          |    1 
 arch/mips/kernel/smp.c                     |  139 
 arch/mips/kernel/smtc.c                    |    1 
 arch/parisc/Kconfig                        |    1 
 arch/parisc/kernel/smp.c                   |  134 
 arch/powerpc/Kconfig                       |    1 
 arch/powerpc/kernel/smp.c                  |  220 +
 arch/powerpc/platforms/cell/interrupt.c    |    1 
 arch/powerpc/platforms/ps3/smp.c           |    7 
 arch/powerpc/platforms/pseries/xics.c      |    6 
 arch/powerpc/sysdev/mpic.c                 |    2 
 arch/sh/Kconfig                            |    1 
 arch/sh/kernel/smp.c                       |   48 
 arch/x86/Kconfig                           |    1 
 arch/x86/kernel/apic_32.c                  |    4 
 arch/x86/kernel/entry_64.S                 |    3 
 arch/x86/kernel/i8259_64.c                 |    4 
 arch/x86/kernel/smp.c                      |  152 -
 arch/x86/kernel/smpcommon.c                |   56 
 arch/x86/mach-voyager/voyager_smp.c        |   94 
 arch/x86/xen/enlighten.c                   |    4 
 arch/x86/xen/mmu.c                         |    2 
 arch/x86/xen/smp.c                         |  130 
 arch/x86/xen/xen-ops.h                     |    9 
 block/Kconfig.iosched                      |   12 
 block/Makefile                             |    4 
 block/as-iosched.c                         |    6 
 block/bfq-iosched.c                        | 2748 -------------------
 block/blk-core.c                           |  193 -
 block/blk-ioc.c                            |   22 
 block/blk-merge.c                          |   12 
 block/blk-settings.c                       |   38 
 block/blk-softirq.c                        |  173 -
 block/blk-sysfs.c                          |  104 
 block/blk-tag.c                            |    9 
 block/blk.h                                |   12 
 block/cfq-iosched.c                        |   25 
 drivers/block/aoe/aoecmd.c                 |   10 
 fs/bio.c                                   |    3 
 fs/ioprio.c                                |    2 
 fs/splice.c                                |  370 --
 include/asm-alpha/smp.h                    |    2 
 include/asm-ia64/smp.h                     |    3 
 include/asm-m32r/smp.h                     |    1 
 include/asm-mips/smp.h                     |   10 
 include/asm-powerpc/smp.h                  |    5 
 include/asm-sh/smp.h                       |   12 
 include/asm-x86/hw_irq_32.h                |    1 
 include/asm-x86/hw_irq_64.h                |    2 
 include/asm-x86/mach-default/entry_arch.h  |    1 
 include/asm-x86/mach-default/irq_vectors.h |    1 
 include/asm-x86/mach-voyager/entry_arch.h  |    2 
 include/asm-x86/mach-voyager/irq_vectors.h |    4 
 include/asm-x86/smp.h                      |   19 
 include/linux/bio.h                        |    1 
 include/linux/blkdev.h                     |   14 
 include/linux/elevator.h                   |    8 
 include/linux/fs.h                         |    1 
 include/linux/genhd.h                      |   37 
 include/linux/iocontext.h                  |    4 
 include/linux/ioprio.h                     |   14 
 include/linux/smp.h                        |   31 
 include/linux/workqueue.h                  |    2 
 init/main.c                                |    1 
 kernel/Makefile                            |    1 
 kernel/smp.c                               |  362 --
 kernel/workqueue.c                         |   31 
 mm/filemap.c                               |    2 
 80 files changed, 1866 insertions(+), 4161 deletions(-)

diff -puN arch/Kconfig~revert-git-block arch/Kconfig
--- a/arch/Kconfig~revert-git-block
+++ a/arch/Kconfig
@@ -39,6 +39,3 @@ config HAVE_KRETPROBES
 
 config HAVE_DMA_ATTRS
 	def_bool n
-
-config USE_GENERIC_SMP_HELPERS
-	def_bool n
diff -puN arch/alpha/Kconfig~revert-git-block arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~revert-git-block
+++ a/arch/alpha/Kconfig
@@ -528,7 +528,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/alpha/kernel/core_marvel.c~revert-git-block arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c~revert-git-block
+++ a/arch/alpha/kernel/core_marvel.c
@@ -660,9 +660,9 @@ __marvel_rtc_io(u8 b, unsigned long addr
 
 #ifdef CONFIG_SMP
 		if (smp_processor_id() != boot_cpuid)
-			smp_call_function_single(boot_cpuid,
-						 __marvel_access_rtc,
-						 &rtc_access, 1, 1);
+			smp_call_function_on_cpu(__marvel_access_rtc,
+						 &rtc_access, 1, 1,
+						 cpumask_of_cpu(boot_cpuid));
 		else
 			__marvel_access_rtc(&rtc_access);
 #else
diff -puN arch/alpha/kernel/smp.c~revert-git-block arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~revert-git-block
+++ a/arch/alpha/kernel/smp.c
@@ -62,7 +62,6 @@ static struct {
 enum ipi_message_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
@@ -559,6 +558,51 @@ send_ipi_message(cpumask_t to_whom, enum
 		wripir(i);
 }
 
+/* Structure and data for smp_call_function.  This is designed to 
+   minimize static memory requirements.  Plus it looks cleaner.  */
+
+struct smp_call_struct {
+	void (*func) (void *info);
+	void *info;
+	long wait;
+	atomic_t unstarted_count;
+	atomic_t unfinished_count;
+};
+
+static struct smp_call_struct *smp_call_function_data;
+
+/* Atomicly drop data into a shared pointer.  The pointer is free if
+   it is initially locked.  If retry, spin until free.  */
+
+static int
+pointer_lock (void *lock, void *data, int retry)
+{
+	void *old, *tmp;
+
+	mb();
+ again:
+	/* Compare and swap with zero.  */
+	asm volatile (
+	"1:	ldq_l	%0,%1\n"
+	"	mov	%3,%2\n"
+	"	bne	%0,2f\n"
+	"	stq_c	%2,%1\n"
+	"	beq	%2,1b\n"
+	"2:"
+	: "=&r"(old), "=m"(*(void **)lock), "=&r"(tmp)
+	: "r"(data)
+	: "memory");
+
+	if (old == 0)
+		return 0;
+	if (! retry)
+		return -EBUSY;
+
+	while (*(void **)lock)
+		barrier();
+	goto again;
+}
+
 void
 handle_ipi(struct pt_regs *regs)
 {
@@ -588,12 +632,31 @@ handle_ipi(struct pt_regs *regs)
 			break;
 
 		case IPI_CALL_FUNC:
-			generic_smp_call_function_interrupt();
-			break;
-
-		case IPI_CALL_FUNC_SINGLE:
-			generic_smp_call_function_single_interrupt();
+		    {
+			struct smp_call_struct *data;
+			void (*func)(void *info);
+			void *info;
+			int wait;
+
+			data = smp_call_function_data;
+			func = data->func;
+			info = data->info;
+			wait = data->wait;
+
+			/* Notify the sending CPU that the data has been
+			   received, and execution is about to begin.  */
+			mb();
+			atomic_dec (&data->unstarted_count);
+
+			/* At this point the structure may be gone unless
+			   wait is true.  */
+			(*func)(info);
+
+			/* Notify the sending CPU that the task is done.  */
+			mb();
+			if (wait) atomic_dec (&data->unfinished_count);
 			break;
+		    }
 
 		case IPI_CPU_STOP:
 			halt();
@@ -637,15 +700,102 @@ smp_send_stop(void)
 	send_ipi_message(to_whom, IPI_CPU_STOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+/*
+ * Run a function on all other CPUs.
+ *  <func>	The function to run. This must be fast and non-blocking.
+ *  <info>	An arbitrary pointer to pass to the function.
+ *  <retry>	If true, keep retrying until ready.
+ *  <wait>	If true, wait until function has completed on other CPUs.
+ *  [RETURNS]   0 on success, else a negative status code.
+ *
+ * Does not return until remote CPUs are nearly ready to execute <func>
+ * or are or have executed.
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+
+int
+smp_call_function_on_cpu (void (*func) (void *info), void *info, int retry,
+			  int wait, cpumask_t to_whom)
 {
-	send_ipi_message(mask, IPI_CALL_FUNC);
+	struct smp_call_struct data;
+	unsigned long timeout;
+	int num_cpus_to_call;
+	
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	data.wait = wait;
+
+	cpu_clear(smp_processor_id(), to_whom);
+	num_cpus_to_call = cpus_weight(to_whom);
+
+	atomic_set(&data.unstarted_count, num_cpus_to_call);
+	atomic_set(&data.unfinished_count, num_cpus_to_call);
+
+	/* Acquire the smp_call_function_data mutex.  */
+	if (pointer_lock(&smp_call_function_data, &data, retry))
+		return -EBUSY;
+
+	/* Send a message to the requested CPUs.  */
+	send_ipi_message(to_whom, IPI_CALL_FUNC);
+
+	/* Wait for a minimal response.  */
+	timeout = jiffies + HZ;
+	while (atomic_read (&data.unstarted_count) > 0
+	       && time_before (jiffies, timeout))
+		barrier();
+
+	/* If there's no response yet, log a message but allow a longer
+	 * timeout period -- if we get a response this time, log
+	 * a message saying when we got it.. 
+	 */
+	if (atomic_read(&data.unstarted_count) > 0) {
+		long start_time = jiffies;
+		printk(KERN_ERR "%s: initial timeout -- trying long wait\n",
+		       __func__);
+		timeout = jiffies + 30 * HZ;
+		while (atomic_read(&data.unstarted_count) > 0
+		       && time_before(jiffies, timeout))
+			barrier();
+		if (atomic_read(&data.unstarted_count) <= 0) {
+			long delta = jiffies - start_time;
+			printk(KERN_ERR 
+			       "%s: response %ld.%ld seconds into long wait\n",
+			       __func__, delta / HZ,
+			       (100 * (delta - ((delta / HZ) * HZ))) / HZ);
+		}
+	}
+
+	/* We either got one or timed out -- clear the lock. */
+	mb();
+	smp_call_function_data = NULL;
+
+	/* 
+	 * If after both the initial and long timeout periods we still don't
+	 * have a response, something is very wrong...
+	 */
+	BUG_ON(atomic_read (&data.unstarted_count) > 0);
+
+	/* Wait for a complete response, if needed.  */
+	if (wait) {
+		while (atomic_read (&data.unfinished_count) > 0)
+			barrier();
+	}
+
+	return 0;
 }
+EXPORT_SYMBOL(smp_call_function_on_cpu);
 
-void arch_send_call_function_single_ipi(int cpu)
+int
+smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
 {
-	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
+	return smp_call_function_on_cpu (func, info, retry, wait,
+					 cpu_online_map);
 }
+EXPORT_SYMBOL(smp_call_function);
 
 static void
 ipi_imb(void *ignored)
diff -puN arch/arm/Kconfig~revert-git-block arch/arm/Kconfig
--- a/arch/arm/Kconfig~revert-git-block
+++ a/arch/arm/Kconfig
@@ -653,7 +653,6 @@ source "kernel/time/Kconfig"
 config SMP
 	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP)
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/arm/kernel/smp.c~revert-git-block arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c~revert-git-block
+++ a/arch/arm/kernel/smp.c
@@ -68,10 +68,20 @@ enum ipi_msg_type {
 	IPI_TIMER,
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
+struct smp_call_struct {
+	void (*func)(void *info);
+	void *info;
+	int wait;
+	cpumask_t pending;
+	cpumask_t unfinished;
+};
+
+static struct smp_call_struct * volatile smp_call_function_data;
+static DEFINE_SPINLOCK(smp_call_function_lock);
+
 int __cpuinit __cpu_up(unsigned int cpu)
 {
 	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
@@ -356,15 +366,114 @@ static void send_ipi_message(cpumask_t c
 	local_irq_restore(flags);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+/*
+ * You must not call this function with disabled interrupts, from a
+ * hardware interrupt handler, nor from a bottom half handler.
+ */
+static int smp_call_function_on_cpu(void (*func)(void *info), void *info,
+				    int retry, int wait, cpumask_t callmap)
+{
+	struct smp_call_struct data;
+	unsigned long timeout;
+	int ret = 0;
+
+	data.func = func;
+	data.info = info;
+	data.wait = wait;
+
+	cpu_clear(smp_processor_id(), callmap);
+	if (cpus_empty(callmap))
+		goto out;
+
+	data.pending = callmap;
+	if (wait)
+		data.unfinished = callmap;
+
+	/*
+	 * try to get the mutex on smp_call_function_data
+	 */
+	spin_lock(&smp_call_function_lock);
+	smp_call_function_data = &data;
+
+	send_ipi_message(callmap, IPI_CALL_FUNC);
+
+	timeout = jiffies + HZ;
+	while (!cpus_empty(data.pending) && time_before(jiffies, timeout))
+		barrier();
+
+	/*
+	 * did we time out?
+	 */
+	if (!cpus_empty(data.pending)) {
+		/*
+		 * this may be causing our panic - report it
+		 */
+		printk(KERN_CRIT
+		       "CPU%u: smp_call_function timeout for %p(%p)\n"
+		       "      callmap %lx pending %lx, %swait\n",
+		       smp_processor_id(), func, info, *cpus_addr(callmap),
+		       *cpus_addr(data.pending), wait ? "" : "no ");
+
+		/*
+		 * TRACE
+		 */
+		timeout = jiffies + (5 * HZ);
+		while (!cpus_empty(data.pending) && time_before(jiffies, timeout))
+			barrier();
+
+		if (cpus_empty(data.pending))
+			printk(KERN_CRIT "     RESOLVED\n");
+		else
+			printk(KERN_CRIT "     STILL STUCK\n");
+	}
+
+	/*
+	 * whatever happened, we're done with the data, so release it
+	 */
+	smp_call_function_data = NULL;
+	spin_unlock(&smp_call_function_lock);
+
+	if (!cpus_empty(data.pending)) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	if (wait)
+		while (!cpus_empty(data.unfinished))
+			barrier();
+ out:
+
+	return 0;
+}
+
+int smp_call_function(void (*func)(void *info), void *info, int retry,
+                      int wait)
 {
-	send_ipi_message(mask, IPI_CALL_FUNC);
+	return smp_call_function_on_cpu(func, info, retry, wait,
+					cpu_online_map);
 }
+EXPORT_SYMBOL_GPL(smp_call_function);
 
-void arch_send_call_function_single_ipi(int cpu)
+int smp_call_function_single(int cpu, void (*func)(void *info), void *info,
+			     int retry, int wait)
 {
-	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
+	/* prevent preemption and reschedule on another processor */
+	int current_cpu = get_cpu();
+	int ret = 0;
+
+	if (cpu == current_cpu) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	} else
+		ret = smp_call_function_on_cpu(func, info, retry, wait,
+					       cpumask_of_cpu(cpu));
+
+	put_cpu();
+
+	return ret;
 }
+EXPORT_SYMBOL_GPL(smp_call_function_single);
 
 void show_ipi_list(struct seq_file *p)
 {
@@ -412,6 +521,27 @@ asmlinkage void __exception do_local_tim
 }
 #endif
 
+/*
+ * ipi_call_function - handle IPI from smp_call_function()
+ *
+ * Note that we copy data out of the cross-call structure and then
+ * let the caller know that we're here and have done with their data
+ */
+static void ipi_call_function(unsigned int cpu)
+{
+	struct smp_call_struct *data = smp_call_function_data;
+	void (*func)(void *info) = data->func;
+	void *info = data->info;
+	int wait = data->wait;
+
+	cpu_clear(cpu, data->pending);
+
+	func(info);
+
+	if (wait)
+		cpu_clear(cpu, data->unfinished);
+}
+
 static DEFINE_SPINLOCK(stop_lock);
 
 /*
@@ -481,11 +611,7 @@ asmlinkage void __exception do_IPI(struc
 				break;
 
 			case IPI_CALL_FUNC:
-				generic_smp_call_function_interrupt();
-				break;
-
-			case IPI_CALL_FUNC_SINGLE:
-				generic_smp_call_function_single_interrupt();
+				ipi_call_function(cpu);
 				break;
 
 			case IPI_CPU_STOP:
@@ -536,13 +662,14 @@ int setup_profiling_timer(unsigned int m
 }
 
 static int
-on_each_cpu_mask(void (*func)(void *), void *info, int wait, cpumask_t mask)
+on_each_cpu_mask(void (*func)(void *), void *info, int retry, int wait,
+		 cpumask_t mask)
 {
 	int ret = 0;
 
 	preempt_disable();
 
-	ret = smp_call_function_mask(mask, func, info, wait);
+	ret = smp_call_function_on_cpu(func, info, retry, wait, mask);
 	if (cpu_isset(smp_processor_id(), mask))
 		func(info);
 
@@ -611,7 +738,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	cpumask_t mask = mm->cpu_vm_mask;
 
-	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, 1, mask);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
@@ -622,7 +749,7 @@ void flush_tlb_page(struct vm_area_struc
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, 1, mask);
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -644,7 +771,7 @@ void flush_tlb_range(struct vm_area_stru
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, 1, mask);
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
diff -puN arch/ia64/Kconfig~revert-git-block arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~revert-git-block
+++ a/arch/ia64/Kconfig
@@ -290,7 +290,6 @@ config VIRT_CPU_ACCOUNTING
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N.  If you have a system with more
diff -puN arch/ia64/kernel/smp.c~revert-git-block arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~revert-git-block
+++ a/arch/ia64/kernel/smp.c
@@ -60,9 +60,25 @@ static struct local_tlb_flush_counts {
 
 static DEFINE_PER_CPU(unsigned int, shadow_flush_counts[NR_CPUS]) ____cacheline_aligned;
 
+
+/*
+ * Structure and data for smp_call_function(). This is designed to minimise static memory
+ * requirements. It also looks cleaner.
+ */
+static  __cacheline_aligned DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	long wait;
+	atomic_t started;
+	atomic_t finished;
+};
+
+static volatile struct call_data_struct *call_data;
+
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
-#define IPI_CALL_FUNC_SINGLE	2
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
@@ -73,13 +89,13 @@ extern void cpu_halt (void);
 void
 lock_ipi_calllock(void)
 {
-	spin_lock_irq(&call_function_lock);
+	spin_lock_irq(&call_lock);
 }
 
 void
 unlock_ipi_calllock(void)
 {
-	spin_unlock_irq(&call_function_lock);
+	spin_unlock_irq(&call_lock);
 }
 
 static inline void
@@ -147,14 +163,12 @@ handle_IPI (int irq, void *dev_id)
 			ops &= ~(1 << which);
 
 			switch (which) {
-			case IPI_CPU_STOP:
-				stop_this_cpu();
-				break;
 			case IPI_CALL_FUNC:
-				generic_smp_call_function_interrupt();
+				handle_call_data();
 				break;
-			case IPI_CALL_FUNC_SINGLE:
-				generic_smp_call_function_single_interrupt();
+
+			case IPI_CPU_STOP:
+				stop_this_cpu();
 				break;
 #ifdef CONFIG_KEXEC
 			case IPI_KDUMP_CPU_STOP:
@@ -173,8 +187,6 @@ handle_IPI (int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-
-
 /*
  * Called with preemption disabled.
  */
@@ -348,15 +360,190 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1, 1);
 }
 
-void arch_send_call_function_single_ipi(int cpu)
+/*
+ * Run a function on a specific CPU
+ *  <func>	The function to run. This must be fast and non-blocking.
+ *  <info>	An arbitrary pointer to pass to the function.
+ *  <nonatomic>	Currently unused.
+ *  <wait>	If true, wait until function has completed on other CPUs.
+ *  [RETURNS]   0 on success, else a negative status code.
+ *
+ * Does not return until the remote CPU is nearly ready to execute <func>
+ * or is or has executed.
+ */
+
+int
+smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int nonatomic,
+			  int wait)
 {
-	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+	struct call_data_struct data;
+	int cpus = 1;
+	int me = get_cpu(); /* prevent preemption and reschedule on another processor */
+
+	if (cpuid == me) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+		put_cpu();
+		return 0;
+	}
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	spin_lock_bh(&call_lock);
+
+	call_data = &data;
+	mb();	/* ensure store to call_data precedes setting of IPI_CALL_FUNC */
+  	send_IPI_single(cpuid, IPI_CALL_FUNC);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	call_data = NULL;
+
+	spin_unlock_bh(&call_lock);
+	put_cpu();
+	return 0;
 }
+EXPORT_SYMBOL(smp_call_function_single);
 
-void arch_send_call_function_ipi(cpumask_t mask)
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * <mask>	The set of cpus to run on.  Must not include the current cpu.
+ * <func> 	The function to run. This must be fast and non-blocking.
+ * <info>	An arbitrary pointer to pass to the function.
+ * <wait>	If true, wait (atomically) until function
+ *		has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function_mask(cpumask_t mask,
+			   void (*func)(void *), void *info,
+			   int wait)
+{
+	struct call_data_struct data;
+	cpumask_t allbutself;
+	int cpus;
+
+	spin_lock(&call_lock);
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb(); /* ensure store to call_data precedes setting of IPI_CALL_FUNC*/
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(IPI_CALL_FUNC);
+	else
+		send_IPI_mask(mask, IPI_CALL_FUNC);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	call_data = NULL;
+
+	spin_unlock(&call_lock);
+	return 0;
+
+}
+EXPORT_SYMBOL(smp_call_function_mask);
+
+/*
+ * this function sends a 'generic call function' IPI to all other CPUs
+ * in the system.
+ */
+
+/*
+ *  [SUMMARY]	Run a function on all other CPUs.
+ *  <func>	The function to run. This must be fast and non-blocking.
+ *  <info>	An arbitrary pointer to pass to the function.
+ *  <nonatomic>	currently unused.
+ *  <wait>	If true, wait (atomically) until function has completed on other CPUs.
+ *  [RETURNS]   0 on success, else a negative status code.
+ *
+ * Does not return until remote CPUs are nearly ready to execute <func> or are or have
+ * executed.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int
+smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wait)
 {
-	send_IPI_mask(mask, IPI_CALL_FUNC);
+	struct call_data_struct data;
+	int cpus;
+
+	spin_lock(&call_lock);
+	cpus = num_online_cpus() - 1;
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();	/* ensure store to call_data precedes setting of IPI_CALL_FUNC */
+	send_IPI_allbutself(IPI_CALL_FUNC);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	call_data = NULL;
+
+	spin_unlock(&call_lock);
+	return 0;
 }
+EXPORT_SYMBOL(smp_call_function);
 
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
diff -puN arch/m32r/Kconfig~revert-git-block arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~revert-git-block
+++ a/arch/m32r/Kconfig
@@ -296,7 +296,6 @@ config PREEMPT
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/m32r/kernel/m32r_ksyms.c~revert-git-block arch/m32r/kernel/m32r_ksyms.c
--- a/arch/m32r/kernel/m32r_ksyms.c~revert-git-block
+++ a/arch/m32r/kernel/m32r_ksyms.c
@@ -43,6 +43,9 @@ EXPORT_SYMBOL(dcache_dummy);
 #endif
 EXPORT_SYMBOL(cpu_data);
 
+/* Global SMP stuff */
+EXPORT_SYMBOL(smp_call_function);
+
 /* TLB flushing */
 EXPORT_SYMBOL(smp_flush_tlb_page);
 #endif
diff -puN arch/m32r/kernel/smp.c~revert-git-block arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~revert-git-block
+++ a/arch/m32r/kernel/smp.c
@@ -35,6 +35,22 @@
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*
+ * Structure and data for smp_call_function(). This is designed to minimise
+ * static memory requirements. It also looks cleaner.
+ */
+static DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	atomic_t started;
+	atomic_t finished;
+	int wait;
+} __attribute__ ((__aligned__(SMP_CACHE_BYTES)));
+
+static struct call_data_struct *call_data;
+
+/*
  * For flush_cache_all()
  */
 static DEFINE_SPINLOCK(flushcache_lock);
@@ -80,6 +96,9 @@ void smp_invalidate_interrupt(void);
 void smp_send_stop(void);
 static void stop_this_cpu(void *);
 
+int smp_call_function(void (*) (void *), void *, int, int);
+void smp_call_function_interrupt(void);
+
 void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
@@ -546,14 +565,86 @@ static void stop_this_cpu(void *dummy)
 	for ( ; ; );
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
-{
-	send_IPI_mask(mask, CALL_FUNCTION_IPI, 0);
-}
+/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
+/* Call function Routines                                                    */
+/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
-void arch_send_call_function_single_ipi(int cpu)
+/*==========================================================================*
+ * Name:         smp_call_function
+ *
+ * Description:  This routine sends a 'CALL_FUNCTION_IPI' to all other CPUs
+ *               in the system.
+ *
+ * Born on Date: 2002.02.05
+ *
+ * Arguments:    *func - The function to run. This must be fast and
+ *                       non-blocking.
+ *               *info - An arbitrary pointer to pass to the function.
+ *               nonatomic - currently unused.
+ *               wait - If true, wait (atomically) until function has
+ *                      completed on other CPUs.
+ *
+ * Returns:      0 on success, else a negative status code. Does not return
+ *               until remote CPUs are nearly ready to execute <<func>> or
+ *               are or have executed.
+ *
+ * Cautions:     You must not call this function with disabled interrupts or
+ *               from a hardware interrupt handler, you may call it from a
+ *               bottom half handler.
+ *
+ * Modification log:
+ * Date       Who Description
+ * ---------- --- --------------------------------------------------------
+ *
+ *==========================================================================*/
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+	int wait)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNC_SINGLE_IPI, 0);
+	struct call_data_struct data;
+	int cpus;
+
+#ifdef DEBUG_SMP
+	unsigned long flags;
+	__save_flags(flags);
+	if (!(flags & 0x0040))	/* Interrupt Disable NONONO */
+		BUG();
+#endif /* DEBUG_SMP */
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+	cpus = num_online_cpus() - 1;
+
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();
+
+	/* Send a message to all other CPUs and wait for them to respond */
+	send_IPI_allbutself(CALL_FUNCTION_IPI, 0);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		barrier();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			barrier();
+	spin_unlock(&call_lock);
+
+	return 0;
 }
 
 /*==========================================================================*
@@ -575,16 +666,27 @@ void arch_send_call_function_single_ipi(
  *==========================================================================*/
 void smp_call_function_interrupt(void)
 {
-	irq_enter();
-	generic_smp_call_function_interrupt();
-	irq_exit();
-}
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	int wait = call_data->wait;
 
-void smp_call_function_single_interrupt(void)
-{
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	mb();
+	atomic_inc(&call_data->started);
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
 	irq_enter();
-	generic_smp_call_function_single_interrupt();
+	(*func)(info);
 	irq_exit();
+
+	if (wait) {
+		mb();
+		atomic_inc(&call_data->finished);
+	}
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
diff -puN arch/m32r/kernel/traps.c~revert-git-block arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~revert-git-block
+++ a/arch/m32r/kernel/traps.c
@@ -40,7 +40,6 @@ extern void smp_invalidate_interrupt(voi
 extern void smp_call_function_interrupt(void);
 extern void smp_ipi_timer_interrupt(void);
 extern void smp_flush_cache_all_interrupt(void);
-extern void smp_call_function_single_interrupt(void);
 
 /*
  * for Boot AP function
@@ -104,7 +103,7 @@ void	set_eit_vector_entries(void)
 	eit_vector[186] = (unsigned long)smp_call_function_interrupt;
 	eit_vector[187] = (unsigned long)smp_ipi_timer_interrupt;
 	eit_vector[188] = (unsigned long)smp_flush_cache_all_interrupt;
-	eit_vector[189] = (unsigned long)smp_call_function_single_interrupt;
+	eit_vector[189] = 0;
 	eit_vector[190] = 0;
 	eit_vector[191] = 0;
 #endif
diff -puN arch/mips/Kconfig~revert-git-block arch/mips/Kconfig
--- a/arch/mips/Kconfig~revert-git-block
+++ a/arch/mips/Kconfig
@@ -1763,7 +1763,6 @@ config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
 	select IRQ_PER_CPU
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/mips/kernel/smp.c~revert-git-block arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c~revert-git-block
+++ a/arch/mips/kernel/smp.c
@@ -131,28 +131,145 @@ asmlinkage __cpuinit void start_secondar
 	cpu_idle();
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+DEFINE_SPINLOCK(smp_call_lock);
+
+struct call_data_struct *call_data;
+
+/*
+ * Run a function on all other CPUs.
+ *
+ *  <mask>	cpuset_t of all processors to run the function on.
+ *  <func>      The function to run. This must be fast and non-blocking.
+ *  <info>      An arbitrary pointer to pass to the function.
+ *  <retry>     If true, keep retrying until ready.
+ *  <wait>      If true, wait until function has completed on other CPUs.
+ *  [RETURNS]   0 on success, else a negative status code.
+ *
+ * Does not return until remote CPUs are nearly ready to execute <func>
+ * or are or have executed.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler:
+ *
+ * CPU A                               CPU B
+ * Disable interrupts
+ *                                     smp_call_function()
+ *                                     Take call_lock
+ *                                     Send IPIs
+ *                                     Wait for all cpus to acknowledge IPI
+ *                                     CPU A has not responded, spin waiting
+ *                                     for cpu A to respond, holding call_lock
+ * smp_call_function()
+ * Spin waiting for call_lock
+ * Deadlock                            Deadlock
+ */
+int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
+	void *info, int retry, int wait)
 {
+	struct call_data_struct data;
+	int cpu = smp_processor_id();
+	int cpus;
+
+	/*
+	 * Can die spectacularly if this CPU isn't yet marked online
+	 */
+	BUG_ON(!cpu_online(cpu));
+
+	cpu_clear(cpu, mask);
+	cpus = cpus_weight(mask);
+	if (!cpus)
+		return 0;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	spin_lock(&smp_call_lock);
+	call_data = &data;
+	smp_mb();
+
+	/* Send a message to all other CPUs and wait for them to respond */
 	mp_ops->send_ipi_mask(mask, SMP_CALL_FUNCTION);
+
+	/* Wait for response */
+	/* FIXME: lock-up detection, backtrace on lock-up */
+	while (atomic_read(&data.started) != cpus)
+		barrier();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			barrier();
+	call_data = NULL;
+	spin_unlock(&smp_call_lock);
+
+	return 0;
 }
 
-/*
- * We reuse the same vector for the single IPI
- */
-void arch_send_call_function_single_ipi(int cpu)
+int smp_call_function(void (*func) (void *info), void *info, int retry,
+	int wait)
 {
-	mp_ops->send_ipi_mask(cpumask_of_cpu(cpu), SMP_CALL_FUNCTION);
+	return smp_call_function_mask(cpu_online_map, func, info, retry, wait);
 }
 
-/*
- * Call into both interrupt handlers, as we share the IPI for them
- */
 void smp_call_function_interrupt(void)
 {
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	int wait = call_data->wait;
+
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function.
+	 */
+	smp_mb();
+	atomic_inc(&call_data->started);
+
+	/*
+	 * At this point the info structure may be out of scope unless wait==1.
+	 */
 	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	generic_smp_call_function_interrupt();
+	(*func)(info);
 	irq_exit();
+
+	if (wait) {
+		smp_mb();
+		atomic_inc(&call_data->finished);
+	}
+}
+
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int retry, int wait)
+{
+	int ret, me;
+
+	/*
+	 * Can die spectacularly if this CPU isn't yet marked online
+	 */
+	if (!cpu_online(cpu))
+		return 0;
+
+	me = get_cpu();
+	BUG_ON(!cpu_online(me));
+
+	if (cpu == me) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+		put_cpu();
+		return 0;
+	}
+
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, retry,
+				     wait);
+
+	put_cpu();
+	return 0;
 }
 
 static void stop_this_cpu(void *dummy)
diff -puN arch/mips/kernel/smtc.c~revert-git-block arch/mips/kernel/smtc.c
--- a/arch/mips/kernel/smtc.c~revert-git-block
+++ a/arch/mips/kernel/smtc.c
@@ -877,6 +877,7 @@ static void ipi_resched_interrupt(void)
 	/* Return from interrupt should be enough to cause scheduler check */
 }
 
+
 static void ipi_call_interrupt(void)
 {
 	/* Invoke generic function invocation code in smp.c */
diff -puN arch/parisc/Kconfig~revert-git-block arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~revert-git-block
+++ a/arch/parisc/Kconfig
@@ -199,7 +199,6 @@ endchoice
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/parisc/kernel/smp.c~revert-git-block arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c~revert-git-block
+++ a/arch/parisc/kernel/smp.c
@@ -84,11 +84,19 @@ EXPORT_SYMBOL(cpu_possible_map);
 
 DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
 
+struct smp_call_struct {
+	void (*func) (void *info);
+	void *info;
+	long wait;
+	atomic_t unstarted_count;
+	atomic_t unfinished_count;
+};
+static volatile struct smp_call_struct *smp_call_function_data;
+
 enum ipi_message_type {
 	IPI_NOP=0,
 	IPI_RESCHEDULE=1,
 	IPI_CALL_FUNC,
-	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_START,
 	IPI_CPU_STOP,
 	IPI_CPU_TEST
@@ -179,12 +187,33 @@ ipi_interrupt(int irq, void *dev_id) 
 
 			case IPI_CALL_FUNC:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC\n", this_cpu);
-				generic_smp_call_function_interrupt();
-				break;
-
-			case IPI_CALL_FUNC_SINGLE:
-				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC_SINGLE\n", this_cpu);
-				generic_smp_call_function_single_interrupt();
+				{
+					volatile struct smp_call_struct *data;
+					void (*func)(void *info);
+					void *info;
+					int wait;
+
+					data = smp_call_function_data;
+					func = data->func;
+					info = data->info;
+					wait = data->wait;
+
+					mb();
+					atomic_dec ((atomic_t *)&data->unstarted_count);
+
+					/* At this point, *data can't
+					 * be relied upon.
+					 */
+
+					(*func)(info);
+
+					/* Notify the sending CPU that the
+					 * task is done.
+					 */
+					mb();
+					if (wait)
+						atomic_dec ((atomic_t *)&data->unfinished_count);
+				}
 				break;
 
 			case IPI_CPU_START:
@@ -227,14 +256,6 @@ ipi_send(int cpu, enum ipi_message_type 
 	spin_unlock_irqrestore(lock, flags);
 }
 
-static void
-send_IPI_mask(cpumask_t mask, enum ipi_message_type op)
-{
-	int cpu;
-
-	for_each_cpu_mask(cpu, mask)
-		ipi_send(cpu, op);
-}
 
 static inline void
 send_IPI_single(int dest_cpu, enum ipi_message_type op)
@@ -274,16 +295,87 @@ smp_send_all_nop(void)
 	send_IPI_allbutself(IPI_NOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
-{
-	send_IPI_mask(mask, IPI_CALL_FUNC);
-}
 
-void arch_send_call_function_single_ipi(int cpu)
+/**
+ * Run a function on all other CPUs.
+ *  <func>	The function to run. This must be fast and non-blocking.
+ *  <info>	An arbitrary pointer to pass to the function.
+ *  <retry>	If true, keep retrying until ready.
+ *  <wait>	If true, wait until function has completed on other CPUs.
+ *  [RETURNS]   0 on success, else a negative status code.
+ *
+ * Does not return until remote CPUs are nearly ready to execute <func>
+ * or have executed.
+ */
+
+int
+smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
 {
-	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+	struct smp_call_struct data;
+	unsigned long timeout;
+	static DEFINE_SPINLOCK(lock);
+	int retries = 0;
+
+	if (num_online_cpus() < 2)
+		return 0;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	/* can also deadlock if IPIs are disabled */
+	WARN_ON((get_eiem() & (1UL<<(CPU_IRQ_MAX - IPI_IRQ))) == 0);
+
+	
+	data.func = func;
+	data.info = info;
+	data.wait = wait;
+	atomic_set(&data.unstarted_count, num_online_cpus() - 1);
+	atomic_set(&data.unfinished_count, num_online_cpus() - 1);
+
+	if (retry) {
+		spin_lock (&lock);
+		while (smp_call_function_data != 0)
+			barrier();
+	}
+	else {
+		spin_lock (&lock);
+		if (smp_call_function_data) {
+			spin_unlock (&lock);
+			return -EBUSY;
+		}
+	}
+
+	smp_call_function_data = &data;
+	spin_unlock (&lock);
+	
+	/*  Send a message to all other CPUs and wait for them to respond  */
+	send_IPI_allbutself(IPI_CALL_FUNC);
+
+ retry:
+	/*  Wait for response  */
+	timeout = jiffies + HZ;
+	while ( (atomic_read (&data.unstarted_count) > 0) &&
+		time_before (jiffies, timeout) )
+		barrier ();
+
+	if (atomic_read (&data.unstarted_count) > 0) {
+		printk(KERN_CRIT "SMP CALL FUNCTION TIMED OUT! (cpu=%d), try %d\n",
+		      smp_processor_id(), ++retries);
+		goto retry;
+	}
+	/* We either got one or timed out. Release the lock */
+
+	mb();
+	smp_call_function_data = NULL;
+
+	while (wait && atomic_read (&data.unfinished_count) > 0)
+			barrier ();
+
+	return 0;
 }
 
+EXPORT_SYMBOL(smp_call_function);
+
 /*
  * Flush all other CPU's tlb and then mine.  Do this with on_each_cpu()
  * as we want to ensure all TLB's flushed before proceeding.
diff -puN arch/powerpc/Kconfig~revert-git-block arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~revert-git-block
+++ a/arch/powerpc/Kconfig
@@ -110,7 +110,6 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
-	select USE_GENERIC_SMP_HELPERS if SMP
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/kernel/smp.c~revert-git-block arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~revert-git-block
+++ a/arch/powerpc/kernel/smp.c
@@ -72,8 +72,12 @@ struct smp_ops_t *smp_ops;
 
 static volatile unsigned int cpu_callin_map[NR_CPUS];
 
+void smp_call_function_interrupt(void);
+
 int smt_enabled_at_boot = 1;
 
+static int ipi_fail_ok;
+
 static void (*crash_ipi_function_ptr)(struct pt_regs *) = NULL;
 
 #ifdef CONFIG_PPC64
@@ -95,15 +99,12 @@ void smp_message_recv(int msg)
 {
 	switch(msg) {
 	case PPC_MSG_CALL_FUNCTION:
-		generic_smp_call_function_interrupt();
+		smp_call_function_interrupt();
 		break;
 	case PPC_MSG_RESCHEDULE:
 		/* XXX Do we have to do this? */
 		set_need_resched();
 		break;
-	case PPC_MSG_CALL_FUNC_SINGLE:
-		generic_smp_call_function_single_interrupt();
-		break;
 	case PPC_MSG_DEBUGGER_BREAK:
 		if (crash_ipi_function_ptr) {
 			crash_ipi_function_ptr(get_irq_regs());
@@ -153,22 +154,215 @@ static void stop_this_cpu(void *dummy)
 		;
 }
 
-void arch_send_call_function_single_ipi(int cpu)
+/*
+ * Structure and data for smp_call_function(). This is designed to minimise
+ * static memory requirements. It also looks cleaner.
+ * Stolen from the i386 version.
+ */
+static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_lock);
+
+static struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	atomic_t started;
+	atomic_t finished;
+	int wait;
+} *call_data;
+
+/* delay of at least 8 seconds */
+#define SMP_CALL_TIMEOUT	8
+
+/*
+ * These functions send a 'generic call function' IPI to other online
+ * CPUS in the system.
+ *
+ * [SUMMARY] Run a function on other CPUs.
+ * <func> The function to run. This must be fast and non-blocking.
+ * <info> An arbitrary pointer to pass to the function.
+ * <nonatomic> currently unused.
+ * <wait> If true, wait (atomically) until function has completed on other CPUs.
+ * [RETURNS] 0 on success, else a negative status code. Does not return until
+ * remote CPUs are nearly ready to execute <<func>> or are or have executed.
+ * <map> is a cpu map of the cpus to send IPI to.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+static int __smp_call_function_map(void (*func) (void *info), void *info,
+				   int nonatomic, int wait, cpumask_t map)
+{
+	struct call_data_struct data;
+	int ret = -1, num_cpus;
+	int cpu;
+	u64 timeout;
+
+	if (unlikely(smp_ops == NULL))
+		return ret;
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	/* remove 'self' from the map */
+	if (cpu_isset(smp_processor_id(), map))
+		cpu_clear(smp_processor_id(), map);
+
+	/* sanity check the map, remove any non-online processors. */
+	cpus_and(map, map, cpu_online_map);
+
+	num_cpus = cpus_weight(map);
+	if (!num_cpus)
+		goto done;
+
+	call_data = &data;
+	smp_wmb();
+	/* Send a message to all CPUs in the map */
+	for_each_cpu_mask(cpu, map)
+		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
+
+	timeout = get_tb() + (u64) SMP_CALL_TIMEOUT * tb_ticks_per_sec;
+
+	/* Wait for indication that they have received the message */
+	while (atomic_read(&data.started) != num_cpus) {
+		HMT_low();
+		if (get_tb() >= timeout) {
+			printk("smp_call_function on cpu %d: other cpus not "
+				"responding (%d)\n", smp_processor_id(),
+				atomic_read(&data.started));
+			if (!ipi_fail_ok)
+				debugger(NULL);
+			goto out;
+		}
+	}
+
+	/* optionally wait for the CPUs to complete */
+	if (wait) {
+		while (atomic_read(&data.finished) != num_cpus) {
+			HMT_low();
+			if (get_tb() >= timeout) {
+				printk("smp_call_function on cpu %d: other "
+					"cpus not finishing (%d/%d)\n",
+					smp_processor_id(),
+					atomic_read(&data.finished),
+					atomic_read(&data.started));
+				debugger(NULL);
+				goto out;
+			}
+		}
+	}
+
+ done:
+	ret = 0;
+
+ out:
+	call_data = NULL;
+	HMT_medium();
+	return ret;
+}
+
+static int __smp_call_function(void (*func)(void *info), void *info,
+			       int nonatomic, int wait)
 {
-	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
+	int ret;
+	spin_lock(&call_lock);
+	ret =__smp_call_function_map(func, info, nonatomic, wait,
+				       cpu_online_map);
+	spin_unlock(&call_lock);
+	return ret;
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+			int wait)
 {
-	unsigned int cpu;
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
 
-	for_each_cpu_mask(cpu, mask)
-		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
+	return __smp_call_function(func, info, nonatomic, wait);
 }
+EXPORT_SYMBOL(smp_call_function);
+
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int nonatomic, int wait)
+{
+	cpumask_t map = CPU_MASK_NONE;
+	int ret = 0;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	if (!cpu_online(cpu))
+		return -EINVAL;
+
+	cpu_set(cpu, map);
+	if (cpu != get_cpu()) {
+		spin_lock(&call_lock);
+		ret = __smp_call_function_map(func, info, nonatomic, wait, map);
+		spin_unlock(&call_lock);
+	} else {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 0, 0);
+	int nolock;
+
+	/* It's OK to fail sending the IPI, since the alternative is to
+	 * be stuck forever waiting on the other CPU to take the interrupt.
+	 *
+	 * It's better to at least continue and go through reboot, since this
+	 * function is usually called at panic or reboot time in the first
+	 * place.
+	 */
+	ipi_fail_ok = 1;
+
+	/* Don't deadlock in case we got called through panic */
+	nolock = !spin_trylock(&call_lock);
+	__smp_call_function_map(stop_this_cpu, NULL, 1, 0, cpu_online_map);
+	if (!nolock)
+		spin_unlock(&call_lock);
+}
+
+void smp_call_function_interrupt(void)
+{
+	void (*func) (void *info);
+	void *info;
+	int wait;
+
+	/* call_data will be NULL if the sender timed out while
+	 * waiting on us to receive the call.
+	 */
+	if (!call_data)
+		return;
+
+	func = call_data->func;
+	info = call_data->info;
+	wait = call_data->wait;
+
+	if (!wait)
+		smp_mb__before_atomic_inc();
+
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	atomic_inc(&call_data->started);
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
+	(*func)(info);
+	if (wait) {
+		smp_mb__before_atomic_inc();
+		atomic_inc(&call_data->finished);
+	}
 }
 
 extern struct gettimeofday_struct do_gtod;
@@ -402,9 +596,9 @@ int __devinit start_secondary(void *unus
 
 	secondary_cpu_time_init();
 
-	spin_lock(&call_function_lock);
+	spin_lock(&call_lock);
 	cpu_set(cpu, cpu_online_map);
-	spin_unlock(&call_function_lock);
+	spin_unlock(&call_lock);
 
 	local_irq_enable();
 
diff -puN arch/powerpc/platforms/cell/interrupt.c~revert-git-block arch/powerpc/platforms/cell/interrupt.c
--- a/arch/powerpc/platforms/cell/interrupt.c~revert-git-block
+++ a/arch/powerpc/platforms/cell/interrupt.c
@@ -217,7 +217,6 @@ void iic_request_IPIs(void)
 {
 	iic_request_ipi(PPC_MSG_CALL_FUNCTION, "IPI-call");
 	iic_request_ipi(PPC_MSG_RESCHEDULE, "IPI-resched");
-	iic_request_ipi(PPC_MSG_CALL_FUNC_SINGLE, "IPI-call-single");
 #ifdef CONFIG_DEBUGGER
 	iic_request_ipi(PPC_MSG_DEBUGGER_BREAK, "IPI-debug");
 #endif /* CONFIG_DEBUGGER */
diff -puN arch/powerpc/platforms/ps3/smp.c~revert-git-block arch/powerpc/platforms/ps3/smp.c
--- a/arch/powerpc/platforms/ps3/smp.c~revert-git-block
+++ a/arch/powerpc/platforms/ps3/smp.c
@@ -105,10 +105,9 @@ static void __init ps3_smp_setup_cpu(int
 	 * to index needs to be setup.
 	 */
 
-	BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION    != 0);
-	BUILD_BUG_ON(PPC_MSG_RESCHEDULE       != 1);
-	BUILD_BUG_ON(PPC_MSG_CALL_FUNC_SINGLE != 2);
-	BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK   != 3);
+	BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION  != 0);
+	BUILD_BUG_ON(PPC_MSG_RESCHEDULE     != 1);
+	BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK != 3);
 
 	for (i = 0; i < MSG_COUNT; i++) {
 		result = ps3_event_receive_port_setup(cpu, &virqs[i]);
diff -puN arch/powerpc/platforms/pseries/xics.c~revert-git-block arch/powerpc/platforms/pseries/xics.c
--- a/arch/powerpc/platforms/pseries/xics.c~revert-git-block
+++ a/arch/powerpc/platforms/pseries/xics.c
@@ -383,11 +383,13 @@ static irqreturn_t xics_ipi_dispatch(int
 			mb();
 			smp_message_recv(PPC_MSG_RESCHEDULE);
 		}
-		if (test_and_clear_bit(PPC_MSG_CALL_FUNC_SINGLE,
+#if 0
+		if (test_and_clear_bit(PPC_MSG_MIGRATE_TASK,
 				       &xics_ipi_message[cpu].value)) {
 			mb();
-			smp_message_recv(PPC_MSG_CALL_FUNC_SINGLE);
+			smp_message_recv(PPC_MSG_MIGRATE_TASK);
 		}
+#endif
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 		if (test_and_clear_bit(PPC_MSG_DEBUGGER_BREAK,
 				       &xics_ipi_message[cpu].value)) {
diff -puN arch/powerpc/sysdev/mpic.c~revert-git-block arch/powerpc/sysdev/mpic.c
--- a/arch/powerpc/sysdev/mpic.c~revert-git-block
+++ a/arch/powerpc/sysdev/mpic.c
@@ -1508,7 +1508,7 @@ void mpic_request_ipis(void)
 	static char *ipi_names[] = {
 		"IPI0 (call function)",
 		"IPI1 (reschedule)",
-		"IPI2 (call function single)",
+		"IPI2 (unused)",
 		"IPI3 (debugger break)",
 	};
 	BUG_ON(mpic == NULL);
diff -puN arch/sh/Kconfig~revert-git-block arch/sh/Kconfig
--- a/arch/sh/Kconfig~revert-git-block
+++ a/arch/sh/Kconfig
@@ -689,7 +689,6 @@ config CRASH_DUMP
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/sh/kernel/smp.c~revert-git-block arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c~revert-git-block
+++ a/arch/sh/kernel/smp.c
@@ -36,6 +36,13 @@ EXPORT_SYMBOL(cpu_possible_map);
 cpumask_t cpu_online_map;
 EXPORT_SYMBOL(cpu_online_map);
 
+static atomic_t cpus_booted = ATOMIC_INIT(0);
+
+/*
+ * Run specified function on a particular processor.
+ */
+void __smp_call_function(unsigned int cpu);
+
 static inline void __init smp_store_cpu_info(unsigned int cpu)
 {
 	struct sh_cpuinfo *c = cpu_data + cpu;
@@ -171,17 +178,42 @@ void smp_send_stop(void)
 	smp_call_function(stop_this_cpu, 0, 1, 0);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+struct smp_fn_call_struct smp_fn_call = {
+	.lock		= __SPIN_LOCK_UNLOCKED(smp_fn_call.lock),
+	.finished	= ATOMIC_INIT(0),
+};
+
+/*
+ * The caller of this wants the passed function to run on every cpu.  If wait
+ * is set, wait until all cpus have finished the function before returning.
+ * The lock is here to protect the call structure.
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function(void (*func)(void *info), void *info, int retry, int wait)
 {
-	int cpu;
+	unsigned int nr_cpus = atomic_read(&cpus_booted);
+	int i;
 
-	for_each_cpu_mask(cpu, mask)
-		plat_send_ipi(cpu, SMP_MSG_FUNCTION);
-}
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
 
-void arch_send_call_function_single_ipi(int cpu)
-{
-	plat_send_ipi(cpu, SMP_MSG_FUNCTION_SINGLE);
+	spin_lock(&smp_fn_call.lock);
+
+	atomic_set(&smp_fn_call.finished, 0);
+	smp_fn_call.fn = func;
+	smp_fn_call.data = info;
+
+	for (i = 0; i < nr_cpus; i++)
+		if (i != smp_processor_id())
+			plat_send_ipi(i, SMP_MSG_FUNCTION);
+
+	if (wait)
+		while (atomic_read(&smp_fn_call.finished) != (nr_cpus - 1));
+
+	spin_unlock(&smp_fn_call.lock);
+
+	return 0;
 }
 
 /* Not really SMP stuff ... */
diff -puN arch/x86/Kconfig~revert-git-block arch/x86/Kconfig
--- a/arch/x86/Kconfig~revert-git-block
+++ a/arch/x86/Kconfig
@@ -176,7 +176,6 @@ config GENERIC_PENDING_IRQ
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
-	select USE_GENERIC_SMP_HELPERS
 	default y
 
 config X86_32_SMP
diff -puN arch/x86/kernel/apic_32.c~revert-git-block arch/x86/kernel/apic_32.c
--- a/arch/x86/kernel/apic_32.c~revert-git-block
+++ a/arch/x86/kernel/apic_32.c
@@ -1358,10 +1358,6 @@ void __init smp_intr_init(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for single call function */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				call_function_single_interrupt);
 }
 #endif
 
diff -puN arch/x86/kernel/entry_64.S~revert-git-block arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~revert-git-block
+++ a/arch/x86/kernel/entry_64.S
@@ -813,9 +813,6 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
-ENTRY(call_function_single_interrupt)
-	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_single_interrupt
-END(call_function_single_interrupt)
 ENTRY(irq_move_cleanup_interrupt)
 	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
 END(irq_move_cleanup_interrupt)
diff -puN arch/x86/kernel/i8259_64.c~revert-git-block arch/x86/kernel/i8259_64.c
--- a/arch/x86/kernel/i8259_64.c~revert-git-block
+++ a/arch/x86/kernel/i8259_64.c
@@ -494,10 +494,6 @@ void __init native_init_IRQ(void)
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
-	/* IPI for generic single function call */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				call_function_single_interrupt);
-
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
diff -puN arch/x86/kernel/smp.c~revert-git-block arch/x86/kernel/smp.c
--- a/arch/x86/kernel/smp.c~revert-git-block
+++ a/arch/x86/kernel/smp.c
@@ -121,32 +121,131 @@ static void native_smp_send_reschedule(i
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
+/*
+ * Structure and data for smp_call_function(). This is designed to minimise
+ * static memory requirements. It also looks cleaner.
+ */
+static DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	atomic_t started;
+	atomic_t finished;
+	int wait;
+};
+
 void lock_ipi_call_lock(void)
 {
-	spin_lock_irq(&call_function_lock);
+	spin_lock_irq(&call_lock);
 }
 
 void unlock_ipi_call_lock(void)
 {
-	spin_unlock_irq(&call_function_lock);
+	spin_unlock_irq(&call_lock);
 }
 
-void native_send_call_func_single_ipi(int cpu)
+static struct call_data_struct *call_data;
+
+static void __smp_call_function(void (*func) (void *info), void *info,
+				int nonatomic, int wait)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	struct call_data_struct data;
+	int cpus = num_online_cpus() - 1;
+
+	if (!cpus)
+		return;
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();
+
+	/* Send a message to all other CPUs and wait for them to respond */
+	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
 }
 
-void native_send_call_func_ipi(cpumask_t mask)
+
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on.  Must not include the current cpu.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+  * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+static int
+native_smp_call_function_mask(cpumask_t mask,
+			      void (*func)(void *), void *info,
+			      int wait)
 {
+	struct call_data_struct data;
 	cpumask_t allbutself;
+	int cpus;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	wmb();
+
+	/* Send a message to other CPUs */
 	if (cpus_equal(mask, allbutself))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	spin_unlock(&call_lock);
+
+	return 0;
 }
 
 static void stop_this_cpu(void *dummy)
@@ -168,13 +267,18 @@ static void stop_this_cpu(void *dummy)
 
 static void native_smp_send_stop(void)
 {
+	int nolock;
 	unsigned long flags;
 
 	if (reboot_force)
 		return;
 
+	/* Don't deadlock on the call lock in panic */
+	nolock = !spin_trylock(&call_lock);
 	local_irq_save(flags);
-	smp_call_function(stop_this_cpu, NULL, 0, 0);
+	__smp_call_function(stop_this_cpu, NULL, 0, 0);
+	if (!nolock)
+		spin_unlock(&call_lock);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -196,28 +300,33 @@ void smp_reschedule_interrupt(struct pt_
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	ack_APIC_irq();
-	irq_enter();
-	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
-	irq_exit();
-}
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	int wait = call_data->wait;
 
-void smp_call_function_single_interrupt(void)
-{
 	ack_APIC_irq();
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	mb();
+	atomic_inc(&call_data->started);
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
 	irq_enter();
-	generic_smp_call_function_single_interrupt();
+	(*func)(info);
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
 	add_pda(irq_call_count, 1);
 #endif
 	irq_exit();
+
+	if (wait) {
+		mb();
+		atomic_inc(&call_data->finished);
+	}
 }
 
 struct smp_ops smp_ops = {
@@ -228,8 +337,7 @@ struct smp_ops smp_ops = {
 
 	.smp_send_stop = native_smp_send_stop,
 	.smp_send_reschedule = native_smp_send_reschedule,
-
-	.send_call_func_ipi = native_send_call_func_ipi,
-	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.smp_call_function_mask = native_smp_call_function_mask,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
+
diff -puN arch/x86/kernel/smpcommon.c~revert-git-block arch/x86/kernel/smpcommon.c
--- a/arch/x86/kernel/smpcommon.c~revert-git-block
+++ a/arch/x86/kernel/smpcommon.c
@@ -25,3 +25,59 @@ __cpuinit void init_gdt(int cpu)
 	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
+
+/**
+ * smp_call_function(): Run a function on all other CPUs.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Unused.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+		      int wait)
+{
+	return smp_call_function_mask(cpu_online_map, func, info, wait);
+}
+EXPORT_SYMBOL(smp_call_function);
+
+/**
+ * smp_call_function_single - Run a function on a specific CPU
+ * @cpu: The target CPU.  Cannot be the calling CPU.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Unused.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int nonatomic, int wait)
+{
+	/* prevent preemption and reschedule on another processor */
+	int ret;
+	int me = get_cpu();
+	if (cpu == me) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+		put_cpu();
+		return 0;
+	}
+
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
diff -puN arch/x86/mach-voyager/voyager_smp.c~revert-git-block arch/x86/mach-voyager/voyager_smp.c
--- a/arch/x86/mach-voyager/voyager_smp.c~revert-git-block
+++ a/arch/x86/mach-voyager/voyager_smp.c
@@ -955,24 +955,94 @@ static void smp_stop_cpu_function(void *
 		halt();
 }
 
+static DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	volatile unsigned long started;
+	volatile unsigned long finished;
+	int wait;
+};
+
+static struct call_data_struct *call_data;
+
 /* execute a thread on a new CPU.  The function to be called must be
  * previously set up.  This is used to schedule a function for
  * execution on all CPUs - set up the function then broadcast a
  * function_interrupt CPI to come here on each CPU */
 static void smp_call_function_interrupt(void)
 {
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	/* must take copy of wait because call_data may be replaced
+	 * unless the function is waiting for us to finish */
+	int wait = call_data->wait;
+	__u8 cpu = smp_processor_id();
+
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	mb();
+	if (!test_and_clear_bit(cpu, &call_data->started)) {
+		/* If the bit wasn't set, this could be a replay */
+		printk(KERN_WARNING "VOYAGER SMP: CPU %d received call funtion"
+		       " with no call pending\n", cpu);
+		return;
+	}
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
 	irq_enter();
-	generic_smp_call_function_interrupt();
+	(*func) (info);
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
+	if (wait) {
+		mb();
+		clear_bit(cpu, &call_data->finished);
+	}
 }
 
-static void smp_call_function_single_interrupt(void)
+static int
+voyager_smp_call_function_mask(cpumask_t cpumask,
+			       void (*func) (void *info), void *info, int wait)
 {
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	__get_cpu_var(irq_stat).irq_call_count++;
-	irq_exit();
+	struct call_data_struct data;
+	u32 mask = cpus_addr(cpumask)[0];
+
+	mask &= ~(1 << smp_processor_id());
+
+	if (!mask)
+		return 0;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	data.started = mask;
+	data.wait = wait;
+	if (wait)
+		data.finished = mask;
+
+	spin_lock(&call_lock);
+	call_data = &data;
+	wmb();
+	/* Send a message to all other CPUs and wait for them to respond */
+	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
+
+	/* Wait for response */
+	while (data.started)
+		barrier();
+
+	if (wait)
+		while (data.finished)
+			barrier();
+
+	spin_unlock(&call_lock);
+
+	return 0;
 }
 
 /* Sorry about the name.  In an APIC based system, the APICs
@@ -1029,12 +1099,6 @@ void smp_qic_call_function_interrupt(str
 	smp_call_function_interrupt();
 }
 
-void smp_qic_call_function_single_interrupt(struct pt_regs *regs)
-{
-	ack_QIC_CPI(QIC_CALL_FUNCTION_SINGLE_CPI);
-	smp_call_function_single_interrupt();
-}
-
 void smp_vic_cpi_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
@@ -1055,8 +1119,6 @@ void smp_vic_cpi_interrupt(struct pt_reg
 		smp_enable_irq_interrupt();
 	if (test_and_clear_bit(VIC_CALL_FUNCTION_CPI, &vic_cpi_mailbox[cpu]))
 		smp_call_function_interrupt();
-	if (test_and_clear_bit(VIC_CALL_FUNCTION_SINGLE_CPI, &vic_cpi_mailbox[cpu]))
-		smp_call_function_single_interrupt();
 	set_irq_regs(old_regs);
 }
 
@@ -1800,7 +1862,5 @@ struct smp_ops smp_ops = {
 
 	.smp_send_stop = voyager_smp_send_stop,
 	.smp_send_reschedule = voyager_smp_send_reschedule,
-
-	.send_call_func_ipi = native_send_call_func_ipi,
-	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.smp_call_function_mask = voyager_smp_call_function_mask,
 };
diff -puN arch/x86/xen/enlighten.c~revert-git-block arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~revert-git-block
+++ a/arch/x86/xen/enlighten.c
@@ -1123,9 +1123,7 @@ static const struct smp_ops xen_smp_ops 
 
 	.smp_send_stop = xen_smp_send_stop,
 	.smp_send_reschedule = xen_smp_send_reschedule,
-
-	.send_call_func_ipi = xen_smp_send_call_function_ipi,
-	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
+	.smp_call_function_mask = xen_smp_call_function_mask,
 };
 #endif	/* CONFIG_SMP */
 
diff -puN arch/x86/xen/mmu.c~revert-git-block arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~revert-git-block
+++ a/arch/x86/xen/mmu.c
@@ -569,7 +569,7 @@ static void drop_mm_ref(struct mm_struct
 	}
 
 	if (!cpus_empty(mask))
-		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
+		xen_smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
 static void drop_mm_ref(struct mm_struct *mm)
diff -puN arch/x86/xen/smp.c~revert-git-block arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~revert-git-block
+++ a/arch/x86/xen/smp.c
@@ -36,12 +36,24 @@
 #include "mmu.h"
 
 static cpumask_t xen_cpu_initialized_map;
-
-static DEFINE_PER_CPU(int, resched_irq);
-static DEFINE_PER_CPU(int, callfunc_irq);
-static DEFINE_PER_CPU(int, callfuncsingle_irq);
+static DEFINE_PER_CPU(int, resched_irq) = -1;
+static DEFINE_PER_CPU(int, callfunc_irq) = -1;
 static DEFINE_PER_CPU(int, debug_irq) = -1;
 
+/*
+ * Structure and data for smp_call_function(). This is designed to minimise
+ * static memory requirements. It also looks cleaner.
+ */
+static DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	atomic_t started;
+	atomic_t finished;
+	int wait;
+};
+
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 
 static struct call_data_struct *call_data;
@@ -110,17 +122,6 @@ static int xen_smp_intr_init(unsigned in
 		goto fail;
 	per_cpu(debug_irq, cpu) = rc;
 
-	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
-	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
-				    cpu,
-				    xen_call_function_single_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
-				    callfunc_name,
-				    NULL);
-	if (rc < 0)
-		goto fail;
-	per_cpu(callfuncsingle_irq, cpu) = rc;
-
 	return 0;
 
  fail:
@@ -130,9 +131,6 @@ static int xen_smp_intr_init(unsigned in
 		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
 	if (per_cpu(debug_irq, cpu) >= 0)
 		unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
-	if (per_cpu(callfuncsingle_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
-
 	return rc;
 }
 
@@ -340,6 +338,7 @@ void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
+
 static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 {
 	unsigned cpu;
@@ -350,42 +349,83 @@ static void xen_send_IPI_mask(cpumask_t 
 		xen_send_IPI_one(cpu, vector);
 }
 
-void xen_smp_send_call_function_ipi(cpumask_t mask)
-{
-	int cpu;
-
-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
-
-	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask(cpu, mask) {
-		if (xen_vcpu_stolen(cpu)) {
-			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
-			break;
-		}
-	}
-}
-
-void xen_smp_send_call_function_single_ipi(int cpu)
-{
-	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
-}
-
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	int wait = call_data->wait;
+
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	mb();
+	atomic_inc(&call_data->started);
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
 	irq_enter();
-	generic_smp_call_function_interrupt();
+	(*func)(info);
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
 
+	if (wait) {
+		mb();		/* commit everything before setting finished */
+		atomic_inc(&call_data->finished);
+	}
+
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
+int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+			       void *info, int wait)
 {
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	__get_cpu_var(irq_stat).irq_call_count++;
-	irq_exit();
+	struct call_data_struct data;
+	int cpus, cpu;
+	bool yield;
 
-	return IRQ_HANDLED;
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+
+	cpu_clear(smp_processor_id(), mask);
+
+	cpus = cpus_weight(mask);
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();			/* write everything before IPI */
+
+	/* Send a message to other CPUs and wait for them to respond */
+	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+
+	/* Make sure other vcpus get a chance to run if they need to. */
+	yield = false;
+	for_each_cpu_mask(cpu, mask)
+		if (xen_vcpu_stolen(cpu))
+			yield = true;
+
+	if (yield)
+		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus ||
+	       (wait && atomic_read(&data.finished) != cpus))
+		cpu_relax();
+
+	spin_unlock(&call_lock);
+
+	return 0;
 }
diff -puN arch/x86/xen/xen-ops.h~revert-git-block arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h~revert-git-block
+++ a/arch/x86/xen/xen-ops.h
@@ -46,8 +46,13 @@ void xen_smp_cpus_done(unsigned int max_
 
 void xen_smp_send_stop(void);
 void xen_smp_send_reschedule(int cpu);
-void xen_smp_send_call_function_ipi(cpumask_t mask);
-void xen_smp_send_call_function_single_ipi(int cpu);
+int xen_smp_call_function (void (*func) (void *info), void *info, int nonatomic,
+			   int wait);
+int xen_smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+				 int nonatomic, int wait);
+
+int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+			       void *info, int wait);
 
 
 /* Declare an asm function, along with symbols needed to make it
diff -puN block/Kconfig.iosched~revert-git-block block/Kconfig.iosched
--- a/block/Kconfig.iosched~revert-git-block
+++ a/block/Kconfig.iosched
@@ -40,14 +40,6 @@ config IOSCHED_CFQ
 	  working environment, suitable for desktop systems.
 	  This is the default I/O scheduler.
 
-config IOSCHED_BFQ
-	tristate "BFQ I/O scheduler"
-	default y
-	---help---
-	  The BFQ I/O scheduler tries to distribute bandwidth among
-	  all processes in the system, according to their weights,
-	  giving deterministic guarantees on the service provided.
-
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
@@ -64,9 +56,6 @@ choice
 	config DEFAULT_CFQ
 		bool "CFQ" if IOSCHED_CFQ=y
 
-	config DEFAULT_BFQ
-		bool "BFQ" if IOSCHED_CFQ=y
-
 	config DEFAULT_NOOP
 		bool "No-op"
 
@@ -77,7 +66,6 @@ config DEFAULT_IOSCHED
 	default "anticipatory" if DEFAULT_AS
 	default "deadline" if DEFAULT_DEADLINE
 	default "cfq" if DEFAULT_CFQ
-	default "bfq" if DEFAULT_BFQ
 	default "noop" if DEFAULT_NOOP
 
 endmenu
diff -puN block/Makefile~revert-git-block block/Makefile
--- a/block/Makefile~revert-git-block
+++ a/block/Makefile
@@ -4,15 +4,13 @@
 
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
-			blk-exec.o blk-merge.o blk-softirq.o ioctl.o genhd.o \
-			scsi_ioctl.o
+			blk-exec.o blk-merge.o ioctl.o genhd.o scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
-obj-$(CONFIG_IOSCHED_BFQ)	+= bfq-iosched.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
diff -puN block/as-iosched.c~revert-git-block block/as-iosched.c
--- a/block/as-iosched.c~revert-git-block
+++ a/block/as-iosched.c
@@ -450,7 +450,7 @@ static void as_antic_stop(struct as_data
 			del_timer(&ad->antic_timer);
 		ad->antic_status = ANTIC_FINISHED;
 		/* see as_work_handler */
-		kblockd_schedule_work(ad->q, &ad->antic_work);
+		kblockd_schedule_work(&ad->antic_work);
 	}
 }
 
@@ -471,7 +471,7 @@ static void as_antic_timeout(unsigned lo
 		aic = ad->io_context->aic;
 
 		ad->antic_status = ANTIC_FINISHED;
-		kblockd_schedule_work(q, &ad->antic_work);
+		kblockd_schedule_work(&ad->antic_work);
 
 		if (aic->ttime_samples == 0) {
 			/* process anticipated on has exited or timed out*/
@@ -831,7 +831,7 @@ static void as_completed_request(struct 
 	}
 
 	if (ad->changed_batch && ad->nr_dispatched == 1) {
-		kblockd_schedule_work(q, &ad->antic_work);
+		kblockd_schedule_work(&ad->antic_work);
 		ad->changed_batch = 0;
 
 		if (ad->batch_data_dir == REQ_SYNC)
diff -puN block/bfq-iosched.c~revert-git-block /dev/null
--- a/block/bfq-iosched.c
+++ /dev/null
@@ -1,2748 +0,0 @@
-/*
- * BFQ, or Budget Fair Queueing, disk scheduler.
- *
- * Based on ideas and code from CFQ:
- * Copyright (C) 2003 Jens Axboe <axboe@kernel.dk>
- *
- * Copyright (C) 2008 Fabio Checconi <fabio@gandalf.sssup.it>
- *		      Paolo Valente <paolo.valente@unimore.it>
- */
-#include <linux/module.h>
-#include <linux/blkdev.h>
-#include <linux/elevator.h>
-#include <linux/rbtree.h>
-#include <linux/ioprio.h>
-
-/*
- * tunables
- */
-/* max queue in one round of service */
-static const int bfq_quantum = 4;
-static const int bfq_fifo_expire[2] = { HZ / 4, HZ / 8 };
-/* maximum backwards seek, in KiB */
-static const int bfq_back_max = 16 * 1024;
-/* penalty of a backwards seek */
-static const int bfq_back_penalty = 2;
-static const int bfq_slice_async_rq = 2;
-static int bfq_slice_idle = HZ / 125;
-static const int bfq_max_budget = 4096;
-
-/*
- * below this threshold, we consider thinktime immediate
- */
-#define BFQ_MIN_TT		(2)
-
-#define RQ_CIC(rq)		\
-	((struct cfq_io_context *) (rq)->elevator_private)
-#define RQ_BFQQ(rq)		((rq)->elevator_private2)
-
-static struct kmem_cache *bfq_pool;
-static struct kmem_cache *bfq_ioc_pool;
-
-static DEFINE_PER_CPU(unsigned long, ioc_count);
-static struct completion *ioc_gone;
-
-#define BFQ_PRIO_LISTS		IOPRIO_BE_NR
-#define bfq_class_idle(bfqq)	((bfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
-
-#define ASYNC			(0)
-#define SYNC			(1)
-
-#define sample_valid(samples)	((samples) > 80)
-
-#define BFQ_IOPRIO_CLASSES	3
-
-#define BFQ_BUDGET_STEP		128
-
-typedef u64 bfq_timestamp_t;
-typedef unsigned long bfq_weight_t;
-typedef unsigned long bfq_service_t;
-
-struct bfq_wfqdata {
-	struct rb_root active;
-	struct rb_root idle;
-
-	struct bfq_queue *first_idle;
-	struct bfq_queue *last_idle;
-
-	bfq_timestamp_t vtime;
-	bfq_weight_t wsum;
-};
-
-#define BFQ_WFQDATA_INIT	((struct bfq_wfqdata)			\
-				{ RB_ROOT, RB_ROOT, NULL, NULL, 0, 0 })
-
-/*
- * Per block device queue structure
- */
-struct bfq_data {
-	struct request_queue *queue;
-
-	struct bfq_wfqdata service_tree[BFQ_IOPRIO_CLASSES];
-	unsigned int busy_queues;
-
-	int queued;
-	int rq_in_driver;
-	int sync_flight;
-	int hw_tag;
-
-	/*
-	 * idle window management
-	 */
-	struct timer_list idle_slice_timer;
-	struct work_struct unplug_work;
-
-	struct bfq_queue *active_queue;
-	struct cfq_io_context *active_cic;
-
-	/*
-	 * async queue for each priority case
-	 */
-	struct bfq_queue *async_bfqq[2][IOPRIO_BE_NR];
-	struct bfq_queue *async_idle_bfqq;
-
-	sector_t last_position;
-
-	/*
-	 * tunables, see top of file
-	 */
-	unsigned int bfq_quantum;
-	unsigned int bfq_fifo_expire[2];
-	unsigned int bfq_back_penalty;
-	unsigned int bfq_back_max;
-	unsigned int bfq_slice_async_rq;
-	unsigned int bfq_slice_idle;
-	unsigned int bfq_max_budget;
-
-	struct list_head cic_list;
-};
-
-/*
- * Per process-grouping structure
- */
-struct bfq_queue {
-	/* reference count */
-	atomic_t ref;
-	/* parent bfq_data */
-	struct bfq_data *bfqd;
-	/* service_tree member */
-	struct rb_node rb_node;
-
-	/* sorted list of pending requests */
-	struct rb_root sort_list;
-	/* if fifo isn't expired, next request to serve */
-	struct request *next_rq;
-	/* requests queued in sort_list */
-	int queued[2];
-	/* currently allocated requests */
-	int allocated[2];
-	/* pending metadata requests */
-	int meta_pending;
-	/* fifo list of requests in sort_list */
-	struct list_head fifo;
-
-	/* wfq timestamps */
-	bfq_timestamp_t finish;
-	bfq_timestamp_t start;
-
-	/* wfq tree the queue belongs to */
-	struct rb_root *tree;
-
-	/* minimum start time of the subtree rooted at this queue */
-	bfq_timestamp_t min_start;
-
-	/* service received and budget for the current run */
-	bfq_service_t service, budget, act_budget;
-	/* effective weight of the queue */
-	bfq_weight_t weight;
-
-	/* number of requests that are on the dispatch list or inside driver */
-	int dispatched;
-
-	/* io prio of this group */
-	unsigned short ioprio, org_ioprio, act_ioprio;
-	unsigned short ioprio_class, org_ioprio_class, act_ioprio_class;
-
-	/* various state flags, see below */
-	unsigned int flags;
-};
-
-static inline unsigned int bfq_bfqq_tree_index(struct bfq_queue *bfqq)
-{
-	unsigned int idx = bfqq->act_ioprio_class - 1;
-
-	BUG_ON(idx >= BFQ_IOPRIO_CLASSES);
-
-	return idx;
-}
-
-static inline struct bfq_wfqdata *bfq_bfqq_wfqdata(struct bfq_data *bfqd,
-						   struct bfq_queue *bfqq)
-{
-	return &bfqd->service_tree[bfq_bfqq_tree_index(bfqq)];
-}
-
-enum bfqq_state_flags {
-	BFQ_BFQQ_FLAG_busy = 0,		/* has requests or is under service */
-	BFQ_BFQQ_FLAG_wait_request,	/* waiting for a request */
-	BFQ_BFQQ_FLAG_must_alloc,	/* must be allowed rq alloc */
-	BFQ_BFQQ_FLAG_fifo_expire,	/* FIFO checked in this slice */
-	BFQ_BFQQ_FLAG_idle_window,	/* slice idling enabled */
-	BFQ_BFQQ_FLAG_prio_changed,	/* task priority has changed */
-	BFQ_BFQQ_FLAG_sync,		/* synchronous queue */
-};
-
-#define BFQ_BFQQ_FNS(name)						\
-static inline void bfq_mark_bfqq_##name(struct bfq_queue *bfqq)		\
-{									\
-	(bfqq)->flags |= (1 << BFQ_BFQQ_FLAG_##name);			\
-}									\
-static inline void bfq_clear_bfqq_##name(struct bfq_queue *bfqq)	\
-{									\
-	(bfqq)->flags &= ~(1 << BFQ_BFQQ_FLAG_##name);			\
-}									\
-static inline int bfq_bfqq_##name(const struct bfq_queue *bfqq)		\
-{									\
-	return ((bfqq)->flags & (1 << BFQ_BFQQ_FLAG_##name)) != 0;	\
-}
-
-BFQ_BFQQ_FNS(busy);
-BFQ_BFQQ_FNS(wait_request);
-BFQ_BFQQ_FNS(must_alloc);
-BFQ_BFQQ_FNS(fifo_expire);
-BFQ_BFQQ_FNS(idle_window);
-BFQ_BFQQ_FNS(prio_changed);
-BFQ_BFQQ_FNS(sync);
-#undef BFQ_BFQQ_FNS
-
-static void bfq_dispatch_insert(struct request_queue *, struct request *);
-static struct bfq_queue *bfq_get_queue(struct bfq_data *, int,
-				       struct io_context *, gfp_t);
-static void bfq_put_queue(struct bfq_queue *bfqq);
-static void bfq_forget_idle(struct bfq_wfqdata *wfqd);
-
-static struct cfq_io_context *bfq_cic_lookup(struct bfq_data *,
-					     struct io_context *);
-
-static inline struct bfq_queue *cic_to_bfqq(struct cfq_io_context *cic,
-					    int is_sync)
-{
-	return cic->cfqq[!!is_sync];
-}
-
-static inline void cic_set_bfqq(struct cfq_io_context *cic,
-				struct bfq_queue *bfqq, int is_sync)
-{
-	cic->cfqq[!!is_sync] = bfqq;
-}
-
-/*
- * We regard a request as SYNC, if it's either a read or has the SYNC bit
- * set (in which case it could also be direct WRITE).
- */
-static inline int bfq_bio_sync(struct bio *bio)
-{
-	if (bio_data_dir(bio) == READ || bio_sync(bio))
-		return 1;
-
-	return 0;
-}
-
-/*
- * Scheduler run of queue, if there are requests pending and no one in the
- * driver that will restart queueing.
- */
-static inline void bfq_schedule_dispatch(struct bfq_data *bfqd)
-{
-	if (bfqd->queued != 0)
-		kblockd_schedule_work(&bfqd->unplug_work);
-}
-
-static int bfq_queue_empty(struct request_queue *q)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-
-	return bfqd->queued == 0;
-}
-
-/*
- * Lifted from AS - choose which of rq1 and rq2 that is best served now.
- * We choose the request that is closest to the head right now.  Distance
- * behind the head is penalized and only allowed to a certain extent.
- */
-static struct request *
-bfq_choose_req(struct bfq_data *bfqd, struct request *rq1, struct request *rq2)
-{
-	sector_t last, s1, s2, d1 = 0, d2 = 0;
-	unsigned long back_max;
-#define BFQ_RQ1_WRAP	0x01 /* request 1 wraps */
-#define BFQ_RQ2_WRAP	0x02 /* request 2 wraps */
-	unsigned wrap = 0; /* bit mask: requests behind the disk head? */
-
-	if (rq1 == NULL || rq1 == rq2)
-		return rq2;
-	if (rq2 == NULL)
-		return rq1;
-
-	if (rq_is_sync(rq1) && !rq_is_sync(rq2))
-		return rq1;
-	else if (rq_is_sync(rq2) && !rq_is_sync(rq1))
-		return rq2;
-	if (rq_is_meta(rq1) && !rq_is_meta(rq2))
-		return rq1;
-	else if (rq_is_meta(rq2) && !rq_is_meta(rq1))
-		return rq2;
-
-	s1 = rq1->sector;
-	s2 = rq2->sector;
-
-	last = bfqd->last_position;
-
-	/*
-	 * by definition, 1KiB is 2 sectors
-	 */
-	back_max = bfqd->bfq_back_max * 2;
-
-	/*
-	 * Strict one way elevator _except_ in the case where we allow
-	 * short backward seeks which are biased as twice the cost of a
-	 * similar forward seek.
-	 */
-	if (s1 >= last)
-		d1 = s1 - last;
-	else if (s1 + back_max >= last)
-		d1 = (last - s1) * bfqd->bfq_back_penalty;
-	else
-		wrap |= BFQ_RQ1_WRAP;
-
-	if (s2 >= last)
-		d2 = s2 - last;
-	else if (s2 + back_max >= last)
-		d2 = (last - s2) * bfqd->bfq_back_penalty;
-	else
-		wrap |= BFQ_RQ2_WRAP;
-
-	/* Found required data */
-
-	/*
-	 * By doing switch() on the bit mask "wrap" we avoid having to
-	 * check two variables for all permutations: --> faster!
-	 */
-	switch (wrap) {
-	case 0: /* common case for CFQ: rq1 and rq2 not wrapped */
-		if (d1 < d2)
-			return rq1;
-		else if (d2 < d1)
-			return rq2;
-		else {
-			if (s1 >= s2)
-				return rq1;
-			else
-				return rq2;
-		}
-
-	case BFQ_RQ2_WRAP:
-		return rq1;
-	case BFQ_RQ1_WRAP:
-		return rq2;
-	case (BFQ_RQ1_WRAP|BFQ_RQ2_WRAP): /* both rqs wrapped */
-	default:
-		/*
-		 * Since both rqs are wrapped,
-		 * start with the one that's further behind head
-		 * (--> only *one* back seek required),
-		 * since back seek takes more time than forward.
-		 */
-		if (s1 <= s2)
-			return rq1;
-		else
-			return rq2;
-	}
-}
-
-/*
- * would be nice to take fifo expire time into account as well
- */
-static struct request *
-bfq_find_next_rq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-		  struct request *last)
-{
-	struct rb_node *rbnext = rb_next(&last->rb_node);
-	struct rb_node *rbprev = rb_prev(&last->rb_node);
-	struct request *next = NULL, *prev = NULL;
-
-	BUG_ON(RB_EMPTY_NODE(&last->rb_node));
-
-	if (rbprev != NULL)
-		prev = rb_entry_rq(rbprev);
-
-	if (rbnext != NULL)
-		next = rb_entry_rq(rbnext);
-	else {
-		rbnext = rb_first(&bfqq->sort_list);
-		if (rbnext && rbnext != &last->rb_node)
-			next = rb_entry_rq(rbnext);
-	}
-
-	return bfq_choose_req(bfqd, next, prev);
-}
-
-/*
- * Shift for timestamp calculations.  This actually limits the maximum
- * service allowed in one go (small shift values increase it), and the
- * maximum total weight of a queue (big shift values increase it), and
- * the period of virtual time wraparounds.
- */
-#define WFQ_SERVICE_SHIFT	22
-
-/**
- * bfq_gt - compare two timestamps.
- * @a: first ts.
- * @b: second ts.
- *
- * Return @a > @b, dealing with wrapping correctly.
- */
-static inline int bfq_gt(bfq_timestamp_t a, bfq_timestamp_t b)
-{
-	return (s64)(a - b) > 0;
-}
-
-/**
- * bfq_delta - map service into the virtual time domain.
- * @service: amount of service.
- * @weight: scale factor.
- */
-static inline bfq_timestamp_t bfq_delta(bfq_service_t service,
-					bfq_weight_t weight)
-{
-	bfq_timestamp_t d = (bfq_timestamp_t)service << WFQ_SERVICE_SHIFT;
-
-	do_div(d, weight);
-	return d;
-}
-
-/**
- * bfq_calc_finish - assign the finish time to a queue.
- * @bfqq: the queue to act upon.
- */
-static inline void bfq_calc_finish(struct bfq_queue *bfqq)
-{
-	BUG_ON(bfqq->budget == 0);
-
-	bfqq->finish = bfqq->start + bfq_delta(bfqq->act_budget, bfqq->weight);
-}
-
-/**
- * bfq_bfqq_of - get a bfqq from a node.
- * @node: the node field of the bfqq.
- *
- * Convert a node pointer to the relative queue.  This is used only
- * to simplify the logic of some functions and not as the generic
- * conversion mechanism because, e.g., in the tree walking functions,
- * the check for a %NULL value would be redundant.
- */
-static inline struct bfq_queue *bfq_bfqq_of(struct rb_node *node)
-{
-	struct bfq_queue *bfqq = NULL;
-
-	if (node != NULL)
-		bfqq = rb_entry(node, struct bfq_queue, rb_node);
-
-	return bfqq;
-}
-
-/**
- * bfq_extract - remove a queue from a tree.
- * @root: the tree root.
- * @bfqq: the queue to remove.
- */
-static inline void bfq_extract(struct rb_root *root,
-			       struct bfq_queue *bfqq)
-{
-	BUG_ON(bfqq->tree != root);
-
-	bfqq->tree = NULL;
-	rb_erase(&bfqq->rb_node, root);
-}
-
-/**
- * bfq_idle_extract - extract a queue from the idle tree.
- * @wfqd: the wfqdata of the device owning @bfqq.
- * @bfqq: the queue being removed.
- */
-static void bfq_idle_extract(struct bfq_wfqdata *wfqd,
-			     struct bfq_queue *bfqq)
-{
-	struct rb_node *next;
-
-	BUG_ON(bfqq->tree != &wfqd->idle);
-
-	if (bfqq == wfqd->first_idle) {
-		next = rb_next(&bfqq->rb_node);
-		wfqd->first_idle = bfq_bfqq_of(next);
-	}
-
-	if (bfqq == wfqd->last_idle) {
-		next = rb_prev(&bfqq->rb_node);
-		wfqd->last_idle = bfq_bfqq_of(next);
-	}
-
-	bfq_extract(&wfqd->idle, bfqq);
-}
-
-/**
- * bfq_update_finish - resync the finish time with the service received
- * @bfqq: the queue to update.
- *
- * The queue may have received less service than allocated, decrease its
- * finish time.  This is called only for the queue under service.
- */
-static inline void bfq_update_finish(struct bfq_queue *bfqq)
-{
-	BUG_ON(bfqq->finish < bfqq->start +
-	       bfq_delta(bfqq->service, bfqq->weight));
-
-	bfqq->finish = bfqq->start + bfq_delta(bfqq->service, bfqq->weight);
-}
-
-/**
- * bfq_insert - generic tree insertion.
- * @root: tree root.
- * @bfqq: queue to insert.
- *
- * This is used for the idle and the active tree, since they are both
- * ordered by finish time.
- */
-static void bfq_insert(struct rb_root *root, struct bfq_queue *bfqq)
-{
-	struct bfq_queue *entry;
-	struct rb_node **node = &root->rb_node;
-	struct rb_node *parent = NULL;
-
-	while (*node != NULL) {
-		parent = *node;
-		entry = rb_entry(parent, struct bfq_queue, rb_node);
-
-		if (bfq_gt(entry->finish, bfqq->finish))
-			node = &parent->rb_left;
-		else
-			node = &parent->rb_right;
-	}
-
-	rb_link_node(&bfqq->rb_node, parent, node);
-	rb_insert_color(&bfqq->rb_node, root);
-
-	bfqq->tree = root;
-}
-
-/**
- * bfq_update_min - update the min_start field of a queue.
- * @bfqq: the queue to update.
- * @node: one of its children.
- *
- * This function is called when @bfqq may store an invalid value for
- * min_start due to updates to the active tree.  It assumes that the subtree
- * rooted at @node (that may be its left or its right child) has a valid
- * min_start value.
- */
-static inline void bfq_update_min(struct bfq_queue *bfqq,
-				  struct rb_node *node)
-{
-	struct bfq_queue *child;
-
-	if (node != NULL) {
-		child = rb_entry(node, struct bfq_queue, rb_node);
-		if (bfq_gt(bfqq->min_start, child->min_start))
-			bfqq->min_start = child->min_start;
-	}
-}
-
-/**
- * bfq_update_active_node - recalculate min_start.
- * @node: the node to update.
- *
- * @node may have changed position or one of its children can have moved,
- * this function updates its min_start value.  The left and right subtrees
- * are assumed to hold a correct min_start value.
- */
-static inline void bfq_update_active_node(struct rb_node *node)
-{
-	struct bfq_queue *bfqq = rb_entry(node, struct bfq_queue, rb_node);
-
-	bfqq->min_start = bfqq->start;
-	bfq_update_min(bfqq, node->rb_right);
-	bfq_update_min(bfqq, node->rb_left);
-}
-
-/**
- * bfq_update_active_tree - update min_start for the whole active tree.
- * @node: the starting node.
- *
- * @node must be the deepest modified node after an update.  This function
- * updates its min_start using the values held by its children, assuming
- * that they did not change, and then updates all the nodes that may have
- * changed in the path to the root.  The only nodes that may have changed
- * are those in the path or their siblings.
- */
-static void bfq_update_active_tree(struct rb_node *node)
-{
-	struct rb_node *parent;
-
-up:
-	bfq_update_active_node(node);
-
-	parent = rb_parent(node);
-	if (parent == NULL)
-		return;
-
-	if (node == parent->rb_left && parent->rb_right != NULL)
-		bfq_update_active_node(parent->rb_right);
-	else if (parent->rb_left != NULL)
-		bfq_update_active_node(parent->rb_left);
-
-	node = parent;
-	goto up;
-}
-
-/**
- * bfq_active_insert - insert a queue in the active tree of its device.
- * @wfqd: the wfqdata of the device data containing the tree.
- * @bfqq: the queue being inserted.
- *
- * The active tree is ordered by finish time, but an extra key is kept
- * per each node, containing the minimum value for the start times of
- * its children (and the node itself), so it's possible to search for
- * the eligible node with the lowest finish time in logarithmic time.
- */
-static void bfq_active_insert(struct bfq_wfqdata *wfqd,
-			      struct bfq_queue *bfqq)
-{
-	struct rb_node *node = &bfqq->rb_node;
-
-	bfq_insert(&wfqd->active, bfqq);
-
-	if (node->rb_left != NULL)
-		node = node->rb_left;
-	else if (node->rb_right != NULL)
-		node = node->rb_right;
-
-	bfq_update_active_tree(node);
-}
-
-/**
- * bfq_ioprio_to_weight - calc the weight for a queue.
- * @bfqq: the queue to act upon.
- */
-static bfq_weight_t bfq_ioprio_to_weight(struct bfq_queue *bfqq)
-{
-	WARN_ON(bfqq->act_ioprio >= IOPRIO_BE_NR);
-	return IOPRIO_BE_NR - bfqq->act_ioprio;
-}
-
-/**
- * bfq_update_weight - update the weight of a queue.
- * @wfqd: wfqdata for the device.
- * @bfqq: queue to act upon.
- * @old_weight: weight @bfqq had on @wfqdata.
- */
-static void bfq_update_weight(struct bfq_wfqdata **wfqd,
-			      struct bfq_queue *bfqq,
-			      bfq_weight_t old_weight)
-{
-	struct bfq_data *bfqd = bfqq->bfqd;
-	struct bfq_wfqdata *new_wfqd = *wfqd;
-
-	if (bfqq->act_ioprio != bfqq->ioprio ||
-	    bfqq->act_ioprio_class != bfqq->ioprio_class) {
-		bfqq->act_ioprio = bfqq->ioprio;
-		bfqq->act_ioprio_class = bfqq->ioprio_class;
-		bfqq->weight = bfq_ioprio_to_weight(bfqq);
-		new_wfqd = &bfqd->service_tree[bfq_bfqq_tree_index(bfqq)];
-		if (new_wfqd != *wfqd)
-			bfqq->start = new_wfqd->vtime;
-	} else if (old_weight != 0)
-		/* Already enqueued with the same weight. */
-		return;
-
-	(*wfqd)->wsum -= old_weight;
-	new_wfqd->wsum += bfqq->weight;
-	*wfqd = new_wfqd;
-}
-
-/**
- * bfq_activate_bfqq - activate a queue.
- * @bfqd: the device data.
- * @bfqq: the queue being activated.
- *
- * Called whenever a queue is activated, i.e., it is not active and
- * receives a new request, or has to be reactivated due to budget
- * exhaustion.  It uses the current budget of the queue (and the service
- * received if @bfqq is active) of the queue to calculate its timestamps.
- */
-static void bfq_activate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	struct bfq_wfqdata *wfqd = bfq_bfqq_wfqdata(bfqd, bfqq);
-	bfq_weight_t old_weight;
-
-	if (bfqq == bfqd->active_queue) {
-		BUG_ON(bfqq->tree != NULL);
-		/*
-		 * If we are requeueing the current queue we have
-		 * to take care of not charging to it service it has
-		 * not received.
-		 */
-		bfq_update_finish(bfqq);
-		bfqq->start = bfqq->finish;
-		old_weight = bfqq->weight;
-	} else if (bfqq->tree != NULL) {
-		/*
-		 * Must be on the idle tree, bfq_idle_extract() will
-		 * check for that.
-		 */
-		bfq_idle_extract(wfqd, bfqq);
-		bfqq->start = bfq_gt(wfqd->vtime, bfqq->finish) ?
-			      wfqd->vtime : bfqq->finish;
-		old_weight = bfqq->weight;
-	} else {
-		/*
-		 * The finish time of the queue can be invalid, and
-		 * it is in the past for sure, otherwise the queue
-		 * would have been on the idle tree.
-		 */
-		bfqq->start = wfqd->vtime;
-		atomic_inc(&bfqq->ref);
-		old_weight = 0;
-	}
-
-	bfq_update_weight(&wfqd, bfqq, old_weight);
-	bfq_calc_finish(bfqq);
-	bfq_active_insert(wfqd, bfqq);
-}
-
-/**
- * bfq_find_deepest - find the deepest node that an extraction can modify.
- * @node: the node being removed.
- *
- * Do the first step of an extraction in an rb tree, looking for the
- * node that will replace @node, and returning the deepest node that
- * the following modifications to the tree can touch.  If @node is the
- * last node in the tree return %NULL.
- */
-static struct rb_node *bfq_find_deepest(struct rb_node *node)
-{
-	struct rb_node *deepest;
-
-	if (node->rb_right == NULL && node->rb_left == NULL)
-		deepest = rb_parent(node);
-	else if (node->rb_right == NULL)
-		deepest = node->rb_left;
-	else if (node->rb_left == NULL)
-		deepest = node->rb_right;
-	else {
-		deepest = rb_next(node);
-		if (deepest->rb_right != NULL)
-			deepest = deepest->rb_right;
-		else if (rb_parent(deepest) != node)
-			deepest = rb_parent(deepest);
-	}
-
-	return deepest;
-}
-
-/**
- * bfq_active_extract - remove an entity from the active tree.
- * @wfqd: the wfqdata containing the tree.
- * @bfqq: the queue being removed.
- */
-static void bfq_active_extract(struct bfq_wfqdata *wfqd,
-			       struct bfq_queue *bfqq)
-{
-	struct rb_node *node;
-
-	node = bfq_find_deepest(&bfqq->rb_node);
-	bfq_extract(&wfqd->active, bfqq);
-
-	if (node != NULL)
-		bfq_update_active_tree(node);
-}
-
-/**
- * bfq_idle_insert - insert an entity into the idle tree.
- * @wfqd: the queue containing the tree.
- * @bfqq: the queue to insert.
- */
-static void bfq_idle_insert(struct bfq_wfqdata *wfqd,
-			    struct bfq_queue *bfqq)
-{
-	struct bfq_queue *first_idle = wfqd->first_idle;
-	struct bfq_queue *last_idle = wfqd->last_idle;
-
-	if (first_idle == NULL || bfq_gt(first_idle->finish, bfqq->finish))
-		wfqd->first_idle = bfqq;
-	if (last_idle == NULL || bfq_gt(bfqq->finish, last_idle->finish))
-		wfqd->last_idle = bfqq;
-
-	bfq_insert(&wfqd->idle, bfqq);
-}
-
-/**
- * bfq_forget_queue - remove a queue from the wfq trees.
- * @wfqd: the wfqdata.
- * @bfqq: the queue being removed.
- *
- * Update the device status and forget everything about @bfqq, putting
- * the device reference to it.
- */
-static void bfq_forget_queue(struct bfq_wfqdata *wfqd,
-			     struct bfq_queue *bfqq)
-{
-	wfqd->wsum -= bfqq->weight;
-	bfq_put_queue(bfqq);
-}
-
-static void bfq_deactivate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	struct bfq_wfqdata *wfqd = bfq_bfqq_wfqdata(bfqd, bfqq);
-
-	if (bfqq == bfqd->active_queue) {
-		BUG_ON(bfqq->tree != NULL);
-		bfq_update_finish(bfqq);
-		bfqd->active_queue = NULL;
-	} else
-		bfq_active_extract(wfqd, bfqq);
-
-	if (bfq_gt(bfqq->finish, wfqd->vtime))
-		bfq_idle_insert(wfqd, bfqq);
-	else
-		bfq_forget_queue(wfqd, bfqq);
-}
-
-/**
- * bfq_put_idle_queue - release the idle tree ref of a queue.
- * @wfqd: wfqdata of the device.
- * @bfqq: the queue being released.
- */
-static void bfq_put_idle_queue(struct bfq_wfqdata *wfqd,
-			       struct bfq_queue *bfqq)
-{
-	bfq_idle_extract(wfqd, bfqq);
-	bfq_forget_queue(wfqd, bfqq);
-}
-
-/**
- * bfq_bfqq_served - update the scheduler status after service.
- * @bfqd: the device data.
- * @bfqq: the queue being served.
- * @served: bytes transfered/to transfer.
- */
-static void bfq_bfqq_served(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-			    bfq_service_t served)
-{
-	struct bfq_wfqdata *wfqd = bfq_bfqq_wfqdata(bfqd, bfqq);
-
-	WARN_ON_ONCE(bfqq->service > bfqq->act_budget);
-
-	bfqq->service += served;
-	WARN_ON_ONCE(bfqq->service > bfqq->act_budget);
-	wfqd->vtime += bfq_delta(served, wfqd->wsum);
-
-	bfq_forget_idle(wfqd);
-}
-
-/*
- * Called when an inactive queue receives a new request.
- */
-static void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	BUG_ON(bfq_bfqq_busy(bfqq));
-	BUG_ON(bfqq == bfqd->active_queue);
-	bfq_mark_bfqq_busy(bfqq);
-	bfqd->busy_queues++;
-
-	bfq_activate_bfqq(bfqd, bfqq);
-}
-
-/*
- * Called when the bfqq no longer has requests pending, remove it from
- * the service tree.
- */
-static void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	BUG_ON(!bfq_bfqq_busy(bfqq));
-	BUG_ON(!RB_EMPTY_ROOT(&bfqq->sort_list));
-
-	bfq_clear_bfqq_busy(bfqq);
-	bfq_deactivate_bfqq(bfqd, bfqq);
-
-	BUG_ON(bfqd->busy_queues == 0);
-	bfqd->busy_queues--;
-}
-
-/*
- * rb tree support functions
- */
-static void bfq_del_rq_rb(struct request *rq)
-{
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-	struct bfq_data *bfqd = bfqq->bfqd;
-	const int sync = rq_is_sync(rq);
-
-	BUG_ON(bfqq->queued[sync] == 0);
-	bfqq->queued[sync]--;
-	bfqd->queued--;
-
-	elv_rb_del(&bfqq->sort_list, rq);
-
-	if (bfq_bfqq_busy(bfqq) && bfqq != bfqd->active_queue &&
-	    RB_EMPTY_ROOT(&bfqq->sort_list))
-		bfq_del_bfqq_busy(bfqd, bfqq);
-}
-
-/**
- * bfq_updated_next_req - update the queue after a new next_rq selection.
- * @bfqd: the device data the queue belongs to.
- * @bfqq: the queue to update.
- *
- * Whenever the first request of a queue changes we try to allocate it
- * enough service (if it has grown), or to anticipate its finish time
- * (if it has shrinked), to reduce the time it has to wait, still taking
- * into account the queue budget.  We try to avoid the queue having not
- * enough service allocated for its first request, thus having to go
- * through two dispatch rounds to actually dispatch the request.
- */
-static void bfq_updated_next_req(struct bfq_data *bfqd,
-				 struct bfq_queue *bfqq)
-{
-	struct bfq_wfqdata *wfqd = bfq_bfqq_wfqdata(bfqd, bfqq);
-	struct request *next_rq = bfqq->next_rq;
-	bfq_service_t new_budget;
-
-	if (next_rq == NULL)
-		return;
-
-	if (bfqq == bfqd->active_queue)
-		/*
-		 * In order not to break guarantees, budgets cannot be
-		 * changed after an activity has been selected.
-		 */
-		return;
-
-	BUG_ON(bfqq->tree != &wfqd->active);
-
-	new_budget = max(bfqq->budget, next_rq->hard_nr_sectors);
-	if (new_budget <= bfqq->act_budget)
-		/*
-		 * Finish times cannot be decreased while the queue
-		 * is either schedulable or not eligible, as it would
-		 * invalidate previous scheduling decisions.  The
-		 * current budget is enough to satisfy the first req
-		 * anyway.
-		 */
-		return;
-
-	bfqq->act_budget = new_budget;
-	bfq_active_extract(wfqd, bfqq);
-	bfq_calc_finish(bfqq);
-	bfq_active_insert(wfqd, bfqq);
-}
-
-static void bfq_add_rq_rb(struct request *rq)
-{
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-	struct bfq_data *bfqd = bfqq->bfqd;
-	struct request *__alias, *next_rq;
-
-	bfqq->queued[rq_is_sync(rq)]++;
-	bfqd->queued++;
-
-	/*
-	 * looks a little odd, but the first insert might return an alias.
-	 * if that happens, put the alias on the dispatch list
-	 */
-	while ((__alias = elv_rb_add(&bfqq->sort_list, rq)) != NULL)
-		bfq_dispatch_insert(bfqd->queue, __alias);
-
-	/*
-	 * check if this request is a better next-serve candidate
-	 */
-	next_rq = bfq_choose_req(bfqd, bfqq->next_rq, rq);
-	BUG_ON(next_rq == NULL);
-	bfqq->next_rq = next_rq;
-
-	if (!bfq_bfqq_busy(bfqq)) {
-		bfqq->act_budget = max(bfqq->budget, next_rq->hard_nr_sectors);
-		bfq_add_bfqq_busy(bfqd, bfqq);
-	} else
-		bfq_updated_next_req(bfqd, bfqq);
-}
-
-static void bfq_reposition_rq_rb(struct bfq_queue *bfqq, struct request *rq)
-{
-	elv_rb_del(&bfqq->sort_list, rq);
-	bfqq->queued[rq_is_sync(rq)]--;
-	bfqq->bfqd->queued--;
-	bfq_add_rq_rb(rq);
-}
-
-static struct request *
-bfq_find_rq_fmerge(struct bfq_data *bfqd, struct bio *bio)
-{
-	struct task_struct *tsk = current;
-	struct cfq_io_context *cic;
-	struct bfq_queue *bfqq;
-
-	cic = bfq_cic_lookup(bfqd, tsk->io_context);
-	if (cic == NULL)
-		return NULL;
-
-	bfqq = cic_to_bfqq(cic, bfq_bio_sync(bio));
-	if (bfqq != NULL) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
-
-		return elv_rb_find(&bfqq->sort_list, sector);
-	}
-
-	return NULL;
-}
-
-static void bfq_activate_request(struct request_queue *q, struct request *rq)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-
-	bfqd->rq_in_driver++;
-
-	/*
-	 * If the depth is larger 1, it really could be queueing. But lets
-	 * make the mark a little higher - idling could still be good for
-	 * low queueing, and a low queueing number could also just indicate
-	 * a SCSI mid layer like behaviour where limit+1 is often seen.
-	 */
-	if (!bfqd->hw_tag && bfqd->rq_in_driver > 4)
-		bfqd->hw_tag = 1;
-
-	bfqd->last_position = rq->hard_sector + rq->hard_nr_sectors;
-}
-
-static void bfq_deactivate_request(struct request_queue *q, struct request *rq)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-
-	WARN_ON(bfqd->rq_in_driver == 0);
-	bfqd->rq_in_driver--;
-}
-
-static void bfq_remove_request(struct request *rq)
-{
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-	struct bfq_data *bfqd = bfqq->bfqd;
-
-	if (bfqq->next_rq == rq) {
-		bfqq->next_rq = bfq_find_next_rq(bfqd, bfqq, rq);
-		bfq_updated_next_req(bfqd, bfqq);
-	}
-
-	list_del_init(&rq->queuelist);
-	bfq_del_rq_rb(rq);
-
-	if (rq_is_meta(rq)) {
-		WARN_ON(bfqq->meta_pending == 0);
-		bfqq->meta_pending--;
-	}
-}
-
-static int bfq_merge(struct request_queue *q, struct request **req,
-		     struct bio *bio)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct request *__rq;
-
-	__rq = bfq_find_rq_fmerge(bfqd, bio);
-	if (__rq != NULL && elv_rq_merge_ok(__rq, bio)) {
-		*req = __rq;
-		return ELEVATOR_FRONT_MERGE;
-	}
-
-	return ELEVATOR_NO_MERGE;
-}
-
-static void bfq_merged_request(struct request_queue *q, struct request *req,
-			       int type)
-{
-	if (type == ELEVATOR_FRONT_MERGE) {
-		struct bfq_queue *bfqq = RQ_BFQQ(req);
-
-		bfq_reposition_rq_rb(bfqq, req);
-	}
-}
-
-static void
-bfq_merged_requests(struct request_queue *q, struct request *rq,
-		    struct request *next)
-{
-	/*
-	 * reposition in fifo if next is older than rq
-	 */
-	if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
-	    time_before(next->start_time, rq->start_time))
-		list_move(&rq->queuelist, &next->queuelist);
-
-	bfq_remove_request(next);
-}
-
-static int bfq_allow_merge(struct request_queue *q, struct request *rq,
-			   struct bio *bio)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct cfq_io_context *cic;
-	struct bfq_queue *bfqq;
-
-	/*
-	 * Disallow merge of a sync bio into an async request.
-	 */
-	if (bfq_bio_sync(bio) && !rq_is_sync(rq))
-		return 0;
-
-	/*
-	 * Lookup the bfqq that this bio will be queued with. Allow
-	 * merge only if rq is queued there.
-	 */
-	cic = bfq_cic_lookup(bfqd, current->io_context);
-	if (cic == NULL)
-		return 0;
-
-	bfqq = cic_to_bfqq(cic, bfq_bio_sync(bio));
-	if (bfqq == RQ_BFQQ(rq))
-		return 1;
-
-	return 0;
-}
-
-static void __bfq_set_active_queue(struct bfq_data *bfqd,
-				   struct bfq_queue *bfqq)
-{
-	if (bfqq != NULL) {
-		bfq_mark_bfqq_must_alloc(bfqq);
-		bfq_clear_bfqq_fifo_expire(bfqq);
-		bfqq->service = 0;
-	}
-
-	bfqd->active_queue = bfqq;
-}
-
-/**
- * bfq_forget_idle - update the idle tree if necessary.
- * @wfqd: the wfqdata to act upon.
- *
- * To preserve the global O(log N) complexity we only remove one entry here;
- * as the idle tree will not grow indefinitely this can be done safely.
- */
-static void bfq_forget_idle(struct bfq_wfqdata *wfqd)
-{
-	struct bfq_queue *first_idle = wfqd->first_idle;
-	struct bfq_queue *last_idle = wfqd->last_idle;
-
-	if (RB_EMPTY_ROOT(&wfqd->active) && last_idle != NULL) {
-		/*
-		 * Forget the whole idle tree, increasing the vtime past
-		 * the last finish time of idle entities.
-		 */
-		wfqd->vtime = last_idle->finish;
-	}
-
-	if (first_idle != NULL && !bfq_gt(first_idle->finish, wfqd->vtime))
-		bfq_put_idle_queue(wfqd, first_idle);
-}
-
-/**
- * bfq_update_vtime - update vtime if necessary.
- * @queue: the wfqdata to act upon.
- *
- * If necessary update the device vtime to have at least one eligible
- * entity, skipping to its start time.  Assumes that the active tree
- * of the device is not empty.
- */
-static void bfq_update_vtime(struct bfq_wfqdata *wfqd)
-{
-	struct bfq_queue *entry;
-	struct rb_node *node = wfqd->active.rb_node;
-
-	entry = rb_entry(node, struct bfq_queue, rb_node);
-	if (bfq_gt(entry->min_start, wfqd->vtime)) {
-		wfqd->vtime = entry->min_start;
-		bfq_forget_idle(wfqd);
-	}
-}
-
-/**
- * bfq_first_active - find the eligible entity with the smallest finish time
- * @wfqd: the wfqdata to select from.
- *
- * This function searches the first schedulable queue, starting from the
- * root of the tree and going on the left every time on this side there is
- * a subtree with at least one eligible (start >= vtime) entity.  The path
- * on the right is followed only if a) the left subtree contains no eligible
- * queue and b) no eligible queue has been found yet.
- */
-static struct bfq_queue *bfq_first_active(struct bfq_wfqdata *wfqd)
-{
-	struct bfq_queue *entry, *first = NULL;
-	struct rb_node *node = wfqd->active.rb_node;
-
-	while (node != NULL) {
-		entry = rb_entry(node, struct bfq_queue, rb_node);
-left:
-		if (!bfq_gt(entry->start, wfqd->vtime))
-			first = entry;
-
-		BUG_ON(bfq_gt(entry->min_start, wfqd->vtime));
-
-		if (node->rb_left != NULL) {
-			entry = rb_entry(node->rb_left,
-					 struct bfq_queue, rb_node);
-			if (!bfq_gt(entry->min_start, wfqd->vtime)) {
-				node = node->rb_left;
-				goto left;
-			}
-		}
-		if (first != NULL)
-			break;
-		node = node->rb_right;
-	}
-
-	return first;
-}
-
-static struct bfq_queue *bfq_wfqnext(struct bfq_wfqdata *wfqd)
-{
-	struct bfq_queue *bfqq;
-
-	if (RB_EMPTY_ROOT(&wfqd->active))
-		return NULL;
-
-	bfq_update_vtime(wfqd);
-	bfqq = bfq_first_active(wfqd);
-	bfq_active_extract(wfqd, bfqq);
-
-	BUG_ON(bfq_gt(bfqq->start, wfqd->vtime));
-
-	return bfqq;
-}
-
-/*
- * Get next queue for service.
- */
-static struct bfq_queue *bfq_get_next_queue(struct bfq_data *bfqd)
-{
-	struct bfq_queue *bfqq;
-	int i;
-
-	BUG_ON(bfqd->active_queue != NULL);
-
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++) {
-		bfqq = bfq_wfqnext(&bfqd->service_tree[i]);
-		if (bfqq != NULL)
-			break;
-	}
-
-	return bfqq;
-}
-
-/*
- * Get and set a new active queue for service.
- */
-static struct bfq_queue *bfq_set_active_queue(struct bfq_data *bfqd)
-{
-	struct bfq_queue *bfqq;
-
-	bfqq = bfq_get_next_queue(bfqd);
-	__bfq_set_active_queue(bfqd, bfqq);
-	return bfqq;
-}
-
-static inline sector_t bfq_dist_from_last(struct bfq_data *bfqd,
-					  struct request *rq)
-{
-	if (rq->sector >= bfqd->last_position)
-		return rq->sector - bfqd->last_position;
-	else
-		return bfqd->last_position - rq->sector;
-}
-
-static inline int bfq_rq_close(struct bfq_data *bfqd, struct request *rq)
-{
-	struct cfq_io_context *cic = bfqd->active_cic;
-
-	if (!sample_valid(cic->seek_samples))
-		return 0;
-
-	return bfq_dist_from_last(bfqd, rq) <= cic->seek_mean;
-}
-
-static int bfq_close_cooperator(struct bfq_data *bfq_data,
-				struct bfq_queue *bfqq)
-{
-	/*
-	 * We should notice if some of the queues are cooperating, eg
-	 * working closely on the same area of the disk. In that case,
-	 * we can group them together and don't waste time idling.
-	 */
-	return 0;
-}
-
-#define CIC_SEEKY(cic) ((cic)->seek_mean > (8 * 1024))
-
-static void bfq_arm_slice_timer(struct bfq_data *bfqd)
-{
-	struct bfq_queue *bfqq = bfqd->active_queue;
-	struct cfq_io_context *cic;
-	unsigned long sl;
-
-	WARN_ON(!RB_EMPTY_ROOT(&bfqq->sort_list));
-
-	/*
-	 * idle is disabled, either manually or by past process history
-	 */
-	if (bfqd->bfq_slice_idle == 0 || !bfq_bfqq_idle_window(bfqq))
-		return;
-
-	/*
-	 * task has exited, don't wait
-	 */
-	cic = bfqd->active_cic;
-	if (cic == NULL || atomic_read(&cic->ioc->nr_tasks) == 0)
-		return;
-
-	/*
-	 * See if this prio level has a good candidate
-	 */
-	if (bfq_close_cooperator(bfqd, bfqq) &&
-	    (sample_valid(cic->ttime_samples) && cic->ttime_mean > 2))
-		return;
-
-	bfq_mark_bfqq_wait_request(bfqq);
-
-	/*
-	 * we don't want to idle for seeks, but we do want to allow
-	 * fair distribution of slice time for a process doing back-to-back
-	 * seeks. so allow a little bit of time for him to submit a new rq
-	 */
-	sl = bfqd->bfq_slice_idle;
-	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
-		sl = min(sl, msecs_to_jiffies(BFQ_MIN_TT));
-
-	mod_timer(&bfqd->idle_slice_timer, jiffies + sl);
-}
-
-/*
- * Move request from internal lists to the request queue dispatch list.
- */
-static void bfq_dispatch_insert(struct request_queue *q, struct request *rq)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-
-	bfq_remove_request(rq);
-	bfqq->dispatched++;
-	elv_dispatch_sort(q, rq);
-
-	if (bfq_bfqq_sync(bfqq))
-		bfqd->sync_flight++;
-}
-
-/*
- * return expired entry, or NULL to just start from scratch in rbtree
- */
-static struct request *bfq_check_fifo(struct bfq_queue *bfqq)
-{
-	struct bfq_data *bfqd = bfqq->bfqd;
-	struct request *rq;
-	int fifo;
-
-	if (bfq_bfqq_fifo_expire(bfqq))
-		return NULL;
-
-	bfq_mark_bfqq_fifo_expire(bfqq);
-
-	if (list_empty(&bfqq->fifo))
-		return NULL;
-
-	fifo = bfq_bfqq_sync(bfqq);
-	rq = rq_entry_fifo(bfqq->fifo.next);
-
-	if (time_before(jiffies, rq->start_time + bfqd->bfq_fifo_expire[fifo]))
-		return NULL;
-
-	return rq;
-}
-
-static inline int
-bfq_prio_to_maxrq(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	const int base_rq = bfqd->bfq_slice_async_rq;
-
-	WARN_ON(bfqq->ioprio >= IOPRIO_BE_NR);
-
-	return 2 * (base_rq + base_rq * (BFQ_PRIO_LISTS - 1 - bfqq->ioprio));
-}
-
-static inline bfq_service_t bfq_bfqq_budget_left(struct bfq_queue *bfqq)
-{
-	return bfqq->act_budget - bfqq->service;
-}
-
-static void __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	BUG_ON(bfqq != bfqd->active_queue);
-
-	if (bfqd->active_cic != NULL) {
-		put_io_context(bfqd->active_cic->ioc);
-		bfqd->active_cic = NULL;
-	}
-
-	if (RB_EMPTY_ROOT(&bfqq->sort_list))
-		bfq_del_bfqq_busy(bfqd, bfqq);
-	else
-		bfq_activate_bfqq(bfqd, bfqq);
-
-	bfqd->active_queue = NULL;
-	del_timer(&bfqd->idle_slice_timer);
-}
-
-static void __bfq_bfqq_recalc_budget(struct bfq_data *bfqd,
-				     struct bfq_queue *bfqq,
-				     int timed_out)
-{
-	struct request *next_rq;
-
-	BUG_ON(bfqq != bfqd->active_queue);
-
-	if (timed_out == 0) {
-		bfqq->budget = min(bfqq->budget + BFQ_BUDGET_STEP,
-				   (bfq_service_t)bfqd->bfq_max_budget);
-
-		/*
-		 * This is to be sure that we have enough budget for the
-		 * next request, and is correct only because we are sure
-		 * that the the active queue will be requeued immediately,
-		 * since the queue may not be the one to serve (its finish
-		 * timestamp needs to be updated to the new budget.)
-		 * IOW __bfq_bfqq_recalc_budget() must be followed by
-		 * __bfq_bfqq_expire().
-		 */
-		next_rq = bfqq->next_rq;
-		bfqq->act_budget = max(bfqq->budget, next_rq->hard_nr_sectors);
-	} else
-		bfqq->budget = max(bfqq->service, (bfq_service_t)4);
-}
-
-static void bfq_bfqq_expire(struct bfq_data *bfqd,
-			    struct bfq_queue *bfqq,
-			    int timed_out)
-{
-	__bfq_bfqq_recalc_budget(bfqd, bfqq, timed_out);
-	__bfq_bfqq_expire(bfqd, bfqq);
-}
-
-/*
- * Select a queue for service. If we have a current active queue,
- * check whether to continue servicing it, or retrieve and set a new one.
- */
-static struct bfq_queue *bfq_select_queue(struct bfq_data *bfqd)
-{
-	struct bfq_queue *bfqq;
-	struct request *next_rq;
-
-	bfqq = bfqd->active_queue;
-	if (bfqq == NULL)
-		goto new_queue;
-
-	next_rq = bfqq->next_rq;
-	/*
-	 * If bfqq has requests queued and it has enough budget left to
-	 * serve it keep the queue, otherwise expire it.
-	 */
-	if (next_rq != NULL) {
-		if (next_rq->hard_nr_sectors > bfq_bfqq_budget_left(bfqq)) {
-			__bfq_bfqq_recalc_budget(bfqd, bfqq, 0);
-			goto expire;
-		} else
-			goto keep_queue;
-	}
-
-	/*
-	 * No requests pending. If the active queue still has requests in
-	 * flight or is idling for a new request, allow either of these
-	 * conditions to happen (or time out) before selecting a new queue.
-	 */
-	if (timer_pending(&bfqd->idle_slice_timer) ||
-	    (bfqq->dispatched != 0 && bfq_bfqq_idle_window(bfqq))) {
-		bfqq = NULL;
-		goto keep_queue;
-	}
-
-expire:
-	__bfq_bfqq_expire(bfqd, bfqq);
-new_queue:
-	bfqq = bfq_set_active_queue(bfqd);
-keep_queue:
-	return bfqq;
-}
-
-/*
- * Dispatch some requests from bfqq, moving them to the request queue
- * dispatch list.
- */
-static int
-__bfq_dispatch_requests(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-			int max_dispatch)
-{
-	int dispatched = 0;
-
-	BUG_ON(RB_EMPTY_ROOT(&bfqq->sort_list));
-
-	do {
-		struct request *rq;
-
-		/*
-		 * follow expired path, else get first next available
-		 */
-		rq = bfq_check_fifo(bfqq);
-		if (rq == NULL)
-			rq = bfqq->next_rq;
-
-		if (rq->hard_nr_sectors > bfq_bfqq_budget_left(bfqq)) {
-			/*
-			 * Expire the queue for budget exhaustion, and
-			 * make sure that the next act_budget is enough
-			 * to serve the next request, even if it comes
-			 * from the fifo expired path.
-			 */
-			bfqq->next_rq = rq;
-			bfq_bfqq_expire(bfqd, bfqq, 0);
-			goto out;
-		}
-
-		/*
-		 * finally, insert request into driver dispatch list
-		 */
-		bfq_bfqq_served(bfqd, bfqq, rq->hard_nr_sectors);
-		bfq_dispatch_insert(bfqd->queue, rq);
-
-		dispatched++;
-
-		if (bfqd->active_cic == NULL) {
-			atomic_inc(&RQ_CIC(rq)->ioc->refcount);
-			bfqd->active_cic = RQ_CIC(rq);
-		}
-
-		if (RB_EMPTY_ROOT(&bfqq->sort_list))
-			break;
-	} while (dispatched < max_dispatch);
-
-	/*
-	 * Expire an async queue immediately if it has used up its slice.
-	 * Idle queues always expire after 1 dispatch round.  A better
-	 * approach to handle async queues would be to use a max_async_budget
-	 * instead of slice_asyn_rq.
-	 */
-	if (bfqd->busy_queues > 1 && ((!bfq_bfqq_sync(bfqq) &&
-	    dispatched >= bfq_prio_to_maxrq(bfqd, bfqq)) ||
-	    bfq_class_idle(bfqq)))
-		__bfq_bfqq_expire(bfqd, bfqq);
-
-out:
-	return dispatched;
-}
-
-static int __bfq_forced_dispatch_bfqq(struct bfq_queue *bfqq)
-{
-	int dispatched = 0;
-
-	while (bfqq->next_rq != NULL) {
-		bfq_dispatch_insert(bfqq->bfqd->queue, bfqq->next_rq);
-		dispatched++;
-	}
-
-	BUG_ON(!list_empty(&bfqq->fifo));
-	return dispatched;
-}
-
-/*
- * Drain our current requests.  Used for barriers and when switching
- * io schedulers on-the-fly.
- */
-static int bfq_forced_dispatch(struct bfq_data *bfqd)
-{
-	struct bfq_wfqdata *wfqd;
-	struct bfq_queue *bfqq;
-	int dispatched = 0, i;
-	struct rb_node *n;
-
-	bfqq = bfqd->active_queue;
-	if (bfqq != NULL)
-		__bfq_bfqq_expire(bfqd, bfqq);
-
-	/*
-	 * Loop through classes, and be careful to leave the scheduler
-	 * in a consistent state, as feedback mechanisms and vtime
-	 * updates cannot be disabled during the process.
-	 */
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++) {
-		wfqd = &bfqd->service_tree[i];
-		while ((n = rb_first(&wfqd->active)) != NULL) {
-			bfqq = rb_entry(n, struct bfq_queue, rb_node);
-			dispatched += __bfq_forced_dispatch_bfqq(bfqq);
-			bfqq->budget = bfqd->bfq_max_budget;
-		}
-		bfq_forget_idle(wfqd);
-	}
-
-	BUG_ON(bfqd->busy_queues != 0);
-
-	return dispatched;
-}
-
-static int bfq_dispatch_requests(struct request_queue *q, int force)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct bfq_queue *bfqq;
-	int dispatched;
-
-	if (bfqd->busy_queues == 0)
-		return 0;
-
-	if (unlikely(force))
-		return bfq_forced_dispatch(bfqd);
-
-	dispatched = 0;
-	while ((bfqq = bfq_select_queue(bfqd)) != NULL) {
-		int max_dispatch;
-
-		max_dispatch = bfqd->bfq_quantum;
-		if (bfq_class_idle(bfqq))
-			max_dispatch = 1;
-
-		if (bfqq->dispatched >= max_dispatch) {
-			if (bfqd->busy_queues > 1)
-				break;
-			if (bfqq->dispatched >= 4 * max_dispatch)
-				break;
-		}
-
-		if (bfqd->sync_flight != 0 && !bfq_bfqq_sync(bfqq))
-			break;
-
-		bfq_clear_bfqq_wait_request(bfqq);
-		BUG_ON(timer_pending(&bfqd->idle_slice_timer));
-
-		dispatched += __bfq_dispatch_requests(bfqd, bfqq, max_dispatch);
-	}
-
-	return dispatched;
-}
-
-/*
- * task holds one reference to the queue, dropped when task exits. each rq
- * in-flight on this queue also holds a reference, dropped when rq is freed.
- *
- * queue lock must be held here.
- */
-static void bfq_put_queue(struct bfq_queue *bfqq)
-{
-	struct bfq_data *bfqd = bfqq->bfqd;
-
-	BUG_ON(atomic_read(&bfqq->ref) <= 0);
-
-	if (!atomic_dec_and_test(&bfqq->ref))
-		return;
-
-	BUG_ON(rb_first(&bfqq->sort_list) != NULL);
-	BUG_ON(bfqq->allocated[READ] + bfqq->allocated[WRITE] != 0);
-	BUG_ON(bfq_bfqq_busy(bfqq));
-	BUG_ON(bfqd->active_queue == bfqq);
-
-	kmem_cache_free(bfq_pool, bfqq);
-}
-
-static void
-__call_for_each_cic(struct io_context *ioc,
-		    void (*func)(struct io_context *, struct cfq_io_context *))
-{
-	struct cfq_io_context *cic;
-	struct hlist_node *n;
-
-	hlist_for_each_entry_rcu(cic, n, &ioc->bfq_cic_list, cic_list)
-		func(ioc, cic);
-}
-/*
- * Call func for each cic attached to this ioc.
- */
-static void
-call_for_each_cic(struct io_context *ioc,
-		  void (*func)(struct io_context *, struct cfq_io_context *))
-{
-	rcu_read_lock();
-	__call_for_each_cic(ioc, func);
-	rcu_read_unlock();
-}
-
-static void bfq_cic_free_rcu(struct rcu_head *head)
-{
-	struct cfq_io_context *cic;
-
-	cic = container_of(head, struct cfq_io_context, rcu_head);
-
-	kmem_cache_free(bfq_ioc_pool, cic);
-	elv_ioc_count_dec(ioc_count);
-
-	if (ioc_gone && !elv_ioc_count_read(ioc_count))
-		complete(ioc_gone);
-}
-
-static void bfq_cic_free(struct cfq_io_context *cic)
-{
-	call_rcu(&cic->rcu_head, bfq_cic_free_rcu);
-}
-
-static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
-{
-	unsigned long flags;
-
-	BUG_ON(cic->dead_key == 0);
-
-	spin_lock_irqsave(&ioc->lock, flags);
-	radix_tree_delete(&ioc->radix_root, cic->dead_key);
-	hlist_del_rcu(&cic->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	bfq_cic_free(cic);
-}
-
-static void bfq_free_io_context(struct io_context *ioc)
-{
-	/*
-	 * ioc->refcount is zero here, or we are called from elv_unregister(),
-	 * so no more cic's are allowed to be linked into this ioc.  So it
-	 * should be ok to iterate over the known list, we will see all cic's
-	 * since no new ones are added.
-	 */
-	__call_for_each_cic(ioc, cic_free_func);
-}
-
-static void bfq_exit_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq)
-{
-	if (bfqq == bfqd->active_queue) {
-		__bfq_bfqq_expire(bfqd, bfqq);
-		bfq_schedule_dispatch(bfqd);
-	}
-
-	bfq_put_queue(bfqq);
-}
-
-static void __bfq_exit_single_io_context(struct bfq_data *bfqd,
-					 struct cfq_io_context *cic)
-{
-	struct io_context *ioc = cic->ioc;
-
-	list_del_init(&cic->queue_list);
-
-	/*
-	 * Make sure key == NULL is seen for dead queues
-	 */
-	smp_wmb();
-	cic->dead_key = (unsigned long)cic->key;
-	cic->key = NULL;
-
-	if (ioc->ioc_data == cic)
-		rcu_assign_pointer(ioc->ioc_data, NULL);
-
-	if (cic->cfqq[ASYNC] != NULL) {
-		bfq_exit_bfqq(bfqd, cic->cfqq[ASYNC]);
-		cic->cfqq[ASYNC] = NULL;
-	}
-
-	if (cic->cfqq[SYNC] != NULL) {
-		bfq_exit_bfqq(bfqd, cic->cfqq[SYNC]);
-		cic->cfqq[SYNC] = NULL;
-	}
-}
-
-static void bfq_exit_single_io_context(struct io_context *ioc,
-				       struct cfq_io_context *cic)
-{
-	struct bfq_data *bfqd = cic->key;
-
-	if (bfqd != NULL) {
-		struct request_queue *q = bfqd->queue;
-		unsigned long flags;
-
-		spin_lock_irqsave(q->queue_lock, flags);
-		__bfq_exit_single_io_context(bfqd, cic);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
-}
-
-/*
- * The process that ioc belongs to has exited, we need to clean up
- * and put the internal structures we have that belongs to that process.
- */
-static void bfq_exit_io_context(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, bfq_exit_single_io_context);
-}
-
-static struct cfq_io_context *
-bfq_alloc_io_context(struct bfq_data *bfqd, gfp_t gfp_mask)
-{
-	struct cfq_io_context *cic;
-
-	cic = kmem_cache_alloc_node(bfq_ioc_pool, gfp_mask | __GFP_ZERO,
-							bfqd->queue->node);
-	if (cic != NULL) {
-		cic->last_end_request = jiffies;
-		INIT_LIST_HEAD(&cic->queue_list);
-		INIT_HLIST_NODE(&cic->cic_list);
-		cic->dtor = bfq_free_io_context;
-		cic->exit = bfq_exit_io_context;
-		elv_ioc_count_inc(ioc_count);
-	}
-
-	return cic;
-}
-
-/*
- * With BFQ priorities cannot change anywhere, so the values used to store
- * the actual ioprio/class of a queue are old_ioprio and old_ioprio_class,
- * that are synced with the ones assigned here (and by the boosting code)
- * only when the queue can change its priority.  This function must be
- * called in the context of the task owning ioc so we cannot delay it to
- * the next (re-)activation of the queue.
- */
-static void bfq_init_prio_data(struct bfq_queue *bfqq, struct io_context *ioc)
-{
-	struct task_struct *tsk = current;
-	int ioprio_class;
-
-	if (!bfq_bfqq_prio_changed(bfqq))
-		return;
-
-	ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
-	switch (ioprio_class) {
-	default:
-		printk(KERN_ERR "bfq: bad prio %x\n", ioprio_class);
-	case IOPRIO_CLASS_NONE:
-		/*
-		 * no prio set, place us in the middle of the BE classes
-		 */
-		bfqq->ioprio = task_nice_ioprio(tsk);
-		bfqq->ioprio_class = IOPRIO_CLASS_BE;
-		break;
-	case IOPRIO_CLASS_RT:
-		bfqq->ioprio = task_ioprio(ioc);
-		bfqq->ioprio_class = IOPRIO_CLASS_RT;
-		break;
-	case IOPRIO_CLASS_BE:
-		bfqq->ioprio = task_ioprio(ioc);
-		bfqq->ioprio_class = IOPRIO_CLASS_BE;
-		break;
-	case IOPRIO_CLASS_IDLE:
-		bfqq->ioprio_class = IOPRIO_CLASS_IDLE;
-		bfqq->ioprio = 7;
-		bfq_clear_bfqq_idle_window(bfqq);
-		break;
-	}
-
-	/*
-	 * keep track of original prio settings in case we have to temporarily
-	 * elevate the priority of this queue
-	 */
-	bfqq->org_ioprio = bfqq->ioprio;
-	bfqq->org_ioprio_class = bfqq->ioprio_class;
-	bfq_clear_bfqq_prio_changed(bfqq);
-}
-
-static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
-{
-	struct bfq_data *bfqd = cic->key;
-	struct bfq_queue *bfqq;
-	unsigned long flags;
-
-	if (unlikely(bfqd == NULL))
-		return;
-
-	spin_lock_irqsave(bfqd->queue->queue_lock, flags);
-
-	bfqq = cic->cfqq[ASYNC];
-	if (bfqq != NULL) {
-		struct bfq_queue *new_bfqq;
-		new_bfqq = bfq_get_queue(bfqd, ASYNC, cic->ioc, GFP_ATOMIC);
-		if (new_bfqq != NULL) {
-			cic->cfqq[ASYNC] = new_bfqq;
-			bfq_put_queue(bfqq);
-		}
-	}
-
-	bfqq = cic->cfqq[SYNC];
-	if (bfqq != NULL)
-		bfq_mark_bfqq_prio_changed(bfqq);
-
-	spin_unlock_irqrestore(bfqd->queue->queue_lock, flags);
-}
-
-static void bfq_ioc_set_ioprio(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, changed_ioprio);
-	ioc->ioprio_changed = 0;
-}
-
-static struct bfq_queue *
-bfq_find_alloc_queue(struct bfq_data *bfqd, int is_sync,
-		     struct io_context *ioc, gfp_t gfp_mask)
-{
-	struct bfq_queue *bfqq, *new_bfqq = NULL;
-	struct cfq_io_context *cic;
-
-retry:
-	cic = bfq_cic_lookup(bfqd, ioc);
-	/* cic always exists here */
-	bfqq = cic_to_bfqq(cic, is_sync);
-
-	if (bfqq == NULL) {
-		if (new_bfqq != NULL) {
-			bfqq = new_bfqq;
-			new_bfqq = NULL;
-		} else if (gfp_mask & __GFP_WAIT) {
-			/*
-			 * Inform the allocator of the fact that we will
-			 * just repeat this allocation if it fails, to allow
-			 * the allocator to do whatever it needs to attempt to
-			 * free memory.
-			 */
-			spin_unlock_irq(bfqd->queue->queue_lock);
-			new_bfqq = kmem_cache_alloc_node(bfq_pool,
-					gfp_mask | __GFP_NOFAIL | __GFP_ZERO,
-					bfqd->queue->node);
-			spin_lock_irq(bfqd->queue->queue_lock);
-			goto retry;
-		} else {
-			bfqq = kmem_cache_alloc_node(bfq_pool,
-					gfp_mask | __GFP_ZERO,
-					bfqd->queue->node);
-			if (bfqq == NULL)
-				goto out;
-		}
-
-		RB_CLEAR_NODE(&bfqq->rb_node);
-		INIT_LIST_HEAD(&bfqq->fifo);
-
-		atomic_set(&bfqq->ref, 0);
-		bfqq->bfqd = bfqd;
-		bfqq->budget = bfqd->bfq_max_budget;
-
-		bfq_mark_bfqq_prio_changed(bfqq);
-
-		bfq_init_prio_data(bfqq, ioc);
-		bfqq->act_ioprio = bfqq->ioprio;
-		bfqq->act_ioprio_class = bfqq->ioprio_class;
-		bfqq->weight = bfq_ioprio_to_weight(bfqq);
-
-		if (is_sync) {
-			if (!bfq_class_idle(bfqq))
-				bfq_mark_bfqq_idle_window(bfqq);
-			bfq_mark_bfqq_sync(bfqq);
-		}
-	}
-
-	if (new_bfqq != NULL)
-		kmem_cache_free(bfq_pool, new_bfqq);
-
-out:
-	WARN_ON((gfp_mask & __GFP_WAIT) && bfqq == NULL);
-	return bfqq;
-}
-
-static struct bfq_queue **
-bfq_async_queue_prio(struct bfq_data *bfqd, int ioprio_class, int ioprio)
-{
-	switch (ioprio_class) {
-	case IOPRIO_CLASS_RT:
-		return &bfqd->async_bfqq[0][ioprio];
-	case IOPRIO_CLASS_BE:
-		return &bfqd->async_bfqq[1][ioprio];
-	case IOPRIO_CLASS_IDLE:
-		return &bfqd->async_idle_bfqq;
-	default:
-		BUG();
-	}
-}
-
-static struct bfq_queue *
-bfq_get_queue(struct bfq_data *bfqd, int is_sync, struct io_context *ioc,
-	      gfp_t gfp_mask)
-{
-	const int ioprio = task_ioprio(ioc);
-	const int ioprio_class = task_ioprio_class(ioc);
-	struct bfq_queue **async_bfqq = NULL;
-	struct bfq_queue *bfqq = NULL;
-
-	if (!is_sync) {
-		async_bfqq = bfq_async_queue_prio(bfqd, ioprio_class, ioprio);
-		bfqq = *async_bfqq;
-	}
-
-	if (bfqq == NULL) {
-		bfqq = bfq_find_alloc_queue(bfqd, is_sync, ioc, gfp_mask);
-		if (bfqq == NULL)
-			return NULL;
-	}
-
-	/*
-	 * pin the queue now that it's allocated, scheduler exit will prune it
-	 */
-	if (!is_sync && *async_bfqq == NULL) {
-		atomic_inc(&bfqq->ref);
-		*async_bfqq = bfqq;
-	}
-
-	atomic_inc(&bfqq->ref);
-	return bfqq;
-}
-
-/*
- * We drop cfq io contexts lazily, so we may find a dead one.
- */
-static void
-bfq_drop_dead_cic(struct bfq_data *bfqd, struct io_context *ioc,
-		  struct cfq_io_context *cic)
-{
-	unsigned long flags;
-
-	WARN_ON(!list_empty(&cic->queue_list));
-
-	spin_lock_irqsave(&ioc->lock, flags);
-
-	BUG_ON(ioc->ioc_data == cic);
-
-	radix_tree_delete(&ioc->radix_root, (unsigned long)bfqd);
-	hlist_del_rcu(&cic->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	bfq_cic_free(cic);
-}
-
-static struct cfq_io_context *
-bfq_cic_lookup(struct bfq_data *bfqd, struct io_context *ioc)
-{
-	struct cfq_io_context *cic;
-	void *k;
-
-	if (unlikely(ioc == NULL))
-		return NULL;
-
-	/*
-	 * we maintain a last-hit cache, to avoid browsing over the tree
-	 */
-	cic = rcu_dereference(ioc->ioc_data);
-	if (cic != NULL && cic->key == bfqd)
-		return cic;
-
-	do {
-		rcu_read_lock();
-		cic = radix_tree_lookup(&ioc->radix_root, (unsigned long)bfqd);
-		rcu_read_unlock();
-		if (cic == NULL)
-			break;
-		/* ->key must be copied to avoid race with bfq_exit_queue() */
-		k = cic->key;
-		if (unlikely(k == NULL)) {
-			bfq_drop_dead_cic(bfqd, ioc, cic);
-			continue;
-		}
-
-		rcu_assign_pointer(ioc->ioc_data, cic);
-		break;
-	} while (1);
-
-	return cic;
-}
-
-/*
- * Add cic into ioc, using bfqd as the search key. This enables us to lookup
- * the process specific cfq io context when entered from the block layer.
- * Also adds the cic to a per-bfqd list, used when this queue is removed.
- */
-static int bfq_cic_link(struct bfq_data *bfqd, struct io_context *ioc,
-			struct cfq_io_context *cic, gfp_t gfp_mask)
-{
-	unsigned long flags;
-	int ret;
-
-	ret = radix_tree_preload(gfp_mask);
-	if (ret == 0) {
-		cic->ioc = ioc;
-		cic->key = bfqd;
-
-		spin_lock_irqsave(&ioc->lock, flags);
-		ret = radix_tree_insert(&ioc->radix_root,
-					(unsigned long)bfqd, cic);
-		if (ret == 0)
-			hlist_add_head_rcu(&cic->cic_list, &ioc->bfq_cic_list);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-
-		radix_tree_preload_end();
-
-		if (ret == 0) {
-			spin_lock_irqsave(bfqd->queue->queue_lock, flags);
-			list_add(&cic->queue_list, &bfqd->cic_list);
-			spin_unlock_irqrestore(bfqd->queue->queue_lock, flags);
-		}
-	}
-
-	if (ret != 0)
-		printk(KERN_ERR "bfq: cic link failed!\n");
-
-	return ret;
-}
-
-/*
- * Setup general io context and cfq io context. There can be several cfq
- * io contexts per general io context, if this process is doing io to more
- * than one device managed by cfq.
- * Since bfq uses the same io contexts as cfq, we use the same tree to store
- * either cfq and bfq contexts; the lookup is done using a bfqd/bfqd key, so
- * we cannot have clashes and the key identifies the scheduler type too.
- */
-static struct cfq_io_context *
-bfq_get_io_context(struct bfq_data *bfqd, gfp_t gfp_mask)
-{
-	struct io_context *ioc = NULL;
-	struct cfq_io_context *cic;
-
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
-	ioc = get_io_context(gfp_mask, bfqd->queue->node);
-	if (ioc == NULL)
-		return NULL;
-
-	cic = bfq_cic_lookup(bfqd, ioc);
-	if (cic != NULL)
-		goto out;
-
-	cic = bfq_alloc_io_context(bfqd, gfp_mask);
-	if (cic == NULL)
-		goto err;
-
-	if (bfq_cic_link(bfqd, ioc, cic, gfp_mask) != 0)
-		goto err_free;
-
-out:
-	if (unlikely(ioc->ioprio_changed)) {
-		/* pairs with wmb() in set_task_ioprio() in fs/ioprio.c */
-		rmb();
-		bfq_ioc_set_ioprio(ioc);
-	}
-
-	return cic;
-err_free:
-	bfq_cic_free(cic);
-err:
-	put_io_context(ioc);
-	return NULL;
-}
-
-static void
-bfq_update_io_thinktime(struct bfq_data *bfqd, struct cfq_io_context *cic)
-{
-	unsigned long elapsed = jiffies - cic->last_end_request;
-	unsigned long ttime = min(elapsed, 2UL * bfqd->bfq_slice_idle);
-
-	cic->ttime_samples = (7*cic->ttime_samples + 256) / 8;
-	cic->ttime_total = (7*cic->ttime_total + 256*ttime) / 8;
-	cic->ttime_mean = (cic->ttime_total + 128) / cic->ttime_samples;
-}
-
-static void
-bfq_update_io_seektime(struct bfq_data *bfqd, struct cfq_io_context *cic,
-		       struct request *rq)
-{
-	sector_t sdist;
-	u64 total;
-
-	if (cic->last_request_pos < rq->sector)
-		sdist = rq->sector - cic->last_request_pos;
-	else
-		sdist = cic->last_request_pos - rq->sector;
-
-	/*
-	 * Don't allow the seek distance to get too large from the
-	 * odd fragment, pagein, etc
-	 */
-	if (cic->seek_samples <= 60) /* second&third seek */
-		sdist = min(sdist, (cic->seek_mean * 4) + 2*1024*1024);
-	else
-		sdist = min(sdist, (cic->seek_mean * 4)	+ 2*1024*64);
-
-	cic->seek_samples = (7*cic->seek_samples + 256) / 8;
-	cic->seek_total = (7*cic->seek_total + (u64)256*sdist) / 8;
-	total = cic->seek_total + (cic->seek_samples/2);
-	do_div(total, cic->seek_samples);
-	cic->seek_mean = (sector_t)total;
-}
-
-/*
- * Disable idle window if the process thinks too long or seeks so much that
- * it doesn't matter
- */
-static void
-bfq_update_idle_window(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-		       struct cfq_io_context *cic)
-{
-	int enable_idle;
-
-	/*
-	 * Don't idle for async or idle io prio class
-	 */
-	if (!bfq_bfqq_sync(bfqq) || bfq_class_idle(bfqq))
-		return;
-
-	enable_idle = bfq_bfqq_idle_window(bfqq);
-
-	if (atomic_read(&cic->ioc->nr_tasks) == 0 ||
-	    bfqd->bfq_slice_idle == 0 || (bfqd->hw_tag && CIC_SEEKY(cic)))
-		enable_idle = 0;
-	else if (sample_valid(cic->ttime_samples)) {
-		if (cic->ttime_mean > bfqd->bfq_slice_idle)
-			enable_idle = 0;
-		else
-			enable_idle = 1;
-	}
-
-	if (enable_idle)
-		bfq_mark_bfqq_idle_window(bfqq);
-	else
-		bfq_clear_bfqq_idle_window(bfqq);
-}
-
-/*
- * Called when a new fs request (rq) is added (to bfqq). Check if there's
- * something we should do about it
- */
-static void
-bfq_rq_enqueued(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-		struct request *rq)
-{
-	struct cfq_io_context *cic = RQ_CIC(rq);
-
-	if (rq_is_meta(rq))
-		bfqq->meta_pending++;
-
-	bfq_update_io_thinktime(bfqd, cic);
-	bfq_update_io_seektime(bfqd, cic, rq);
-	bfq_update_idle_window(bfqd, bfqq, cic);
-
-	cic->last_request_pos = rq->sector + rq->nr_sectors;
-
-	if (bfqq == bfqd->active_queue && bfq_bfqq_wait_request(bfqq)) {
-		/*
-		 * If we are waiting for a request for this queue, let it rip
-		 * immediately and flag that we must not expire this queue
-		 * just now.
-		 */
-		bfq_clear_bfqq_wait_request(bfqq);
-		del_timer(&bfqd->idle_slice_timer);
-		blk_start_queueing(bfqd->queue);
-	}
-}
-
-static void bfq_insert_request(struct request_queue *q, struct request *rq)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-
-	bfq_init_prio_data(bfqq, RQ_CIC(rq)->ioc);
-
-	bfq_add_rq_rb(rq);
-
-	list_add_tail(&rq->queuelist, &bfqq->fifo);
-
-	bfq_rq_enqueued(bfqd, bfqq, rq);
-}
-
-static void bfq_completed_request(struct request_queue *q, struct request *rq)
-{
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-	struct bfq_data *bfqd = bfqq->bfqd;
-	const int sync = rq_is_sync(rq);
-	unsigned long now;
-
-	now = jiffies;
-
-	WARN_ON(!bfqd->rq_in_driver);
-	WARN_ON(!bfqq->dispatched);
-	bfqd->rq_in_driver--;
-	bfqq->dispatched--;
-
-	if (bfq_bfqq_sync(bfqq))
-		bfqd->sync_flight--;
-
-	if (sync)
-		RQ_CIC(rq)->last_end_request = now;
-
-	/*
-	 * If this is the active queue, check if it needs to be expired,
-	 * or if we want to idle in case it has no pending requests.
-	 */
-	if (bfqd->active_queue == bfqq && sync &&
-	    RB_EMPTY_ROOT(&bfqq->sort_list))
-		bfq_arm_slice_timer(bfqd);
-
-	if (!bfqd->rq_in_driver)
-		bfq_schedule_dispatch(bfqd);
-}
-
-/*
- * we temporarily boost lower priority queues if they are holding fs exclusive
- * resources. they are boosted to normal prio (CLASS_BE/4)
- */
-static void bfq_prio_boost(struct bfq_queue *bfqq)
-{
-	if (has_fs_excl()) {
-		/*
-		 * boost idle prio on transactions that would lock out other
-		 * users of the filesystem
-		 */
-		if (bfq_class_idle(bfqq))
-			bfqq->ioprio_class = IOPRIO_CLASS_BE;
-		if (bfqq->ioprio > IOPRIO_NORM)
-			bfqq->ioprio = IOPRIO_NORM;
-	} else {
-		/*
-		 * check if we need to unboost the queue
-		 */
-		if (bfqq->ioprio_class != bfqq->org_ioprio_class)
-			bfqq->ioprio_class = bfqq->org_ioprio_class;
-		if (bfqq->ioprio != bfqq->org_ioprio)
-			bfqq->ioprio = bfqq->org_ioprio;
-	}
-}
-
-static inline int __bfq_may_queue(struct bfq_queue *bfqq)
-{
-	if (bfq_bfqq_wait_request(bfqq) && bfq_bfqq_must_alloc(bfqq)) {
-		bfq_clear_bfqq_must_alloc(bfqq);
-		return ELV_MQUEUE_MUST;
-	}
-
-	return ELV_MQUEUE_MAY;
-}
-
-static int bfq_may_queue(struct request_queue *q, int rw)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct task_struct *tsk = current;
-	struct cfq_io_context *cic;
-	struct bfq_queue *bfqq;
-
-	/*
-	 * don't force setup of a queue from here, as a call to may_queue
-	 * does not necessarily imply that a request actually will be queued.
-	 * so just lookup a possibly existing queue, or return 'may queue'
-	 * if that fails
-	 */
-	cic = bfq_cic_lookup(bfqd, tsk->io_context);
-	if (cic == NULL)
-		return ELV_MQUEUE_MAY;
-
-	bfqq = cic_to_bfqq(cic, rw & REQ_RW_SYNC);
-	if (bfqq != NULL) {
-		bfq_init_prio_data(bfqq, cic->ioc);
-		bfq_prio_boost(bfqq);
-
-		return __bfq_may_queue(bfqq);
-	}
-
-	return ELV_MQUEUE_MAY;
-}
-
-/*
- * queue lock held here
- */
-static void bfq_put_request(struct request *rq)
-{
-	struct bfq_queue *bfqq = RQ_BFQQ(rq);
-
-	if (bfqq != NULL) {
-		const int rw = rq_data_dir(rq);
-
-		BUG_ON(!bfqq->allocated[rw]);
-		bfqq->allocated[rw]--;
-
-		put_io_context(RQ_CIC(rq)->ioc);
-
-		rq->elevator_private = NULL;
-		rq->elevator_private2 = NULL;
-
-		bfq_put_queue(bfqq);
-	}
-}
-
-/*
- * Allocate cfq data structures associated with this request.
- */
-static int
-bfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-	struct cfq_io_context *cic;
-	const int rw = rq_data_dir(rq);
-	const int is_sync = rq_is_sync(rq);
-	struct bfq_queue *bfqq;
-	unsigned long flags;
-
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
-	cic = bfq_get_io_context(bfqd, gfp_mask);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-
-	if (cic == NULL)
-		goto queue_fail;
-
-	bfqq = cic_to_bfqq(cic, is_sync);
-	if (bfqq == NULL) {
-		bfqq = bfq_get_queue(bfqd, is_sync, cic->ioc, gfp_mask);
-
-		if (bfqq == NULL)
-			goto queue_fail;
-
-		cic_set_bfqq(cic, bfqq, is_sync);
-	}
-
-	bfqq->allocated[rw]++;
-	atomic_inc(&bfqq->ref);
-
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	rq->elevator_private = cic;
-	rq->elevator_private2 = bfqq;
-
-	return 0;
-
-queue_fail:
-	if (cic != NULL)
-		put_io_context(cic->ioc);
-
-	bfq_schedule_dispatch(bfqd);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	return 1;
-}
-
-static void bfq_kick_queue(struct work_struct *work)
-{
-	struct bfq_data *bfqd =
-		container_of(work, struct bfq_data, unplug_work);
-	struct request_queue *q = bfqd->queue;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_start_queueing(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-
-/*
- * Timer running if the active_queue is currently idling inside its time slice
- */
-static void bfq_idle_slice_timer(unsigned long data)
-{
-	struct bfq_data *bfqd = (struct bfq_data *)data;
-	struct bfq_queue *bfqq;
-	unsigned long flags;
-
-	spin_lock_irqsave(bfqd->queue->queue_lock, flags);
-
-	bfqq = bfqd->active_queue;
-	/*
-	 * Theoretical race here: active_queue can be NULL or different
-	 * from the queue that was idling if the timer handler spins on
-	 * the queue_lock and a new request arrives for the current
-	 * queue and there is a full dispatch cycle that changes the
-	 * active_queue.  This can hardly happen, but in the worst case
-	 * we just expire a queue too early.
-	 */
-	if (bfqq != NULL && bfq_bfqq_wait_request(bfqq)) {
-		BUG_ON(!RB_EMPTY_ROOT(&bfqq->sort_list));
-
-		bfq_bfqq_expire(bfqd, bfqq, 1);
-		bfq_schedule_dispatch(bfqd);
-	}
-
-	BUG_ON(bfqq == NULL && bfqd->busy_queues != 0);
-
-	spin_unlock_irqrestore(bfqd->queue->queue_lock, flags);
-}
-
-static void bfq_shutdown_timer_wq(struct bfq_data *bfqd)
-{
-	del_timer_sync(&bfqd->idle_slice_timer);
-	kblockd_flush_work(&bfqd->unplug_work);
-}
-
-static void bfq_put_async_queues(struct bfq_data *bfqd)
-{
-	int i;
-
-	for (i = 0; i < IOPRIO_BE_NR; i++) {
-		if (bfqd->async_bfqq[0][i] != NULL)
-			bfq_put_queue(bfqd->async_bfqq[0][i]);
-		if (bfqd->async_bfqq[1][i] != NULL)
-			bfq_put_queue(bfqd->async_bfqq[1][i]);
-	}
-
-	if (bfqd->async_idle_bfqq != NULL)
-		bfq_put_queue(bfqd->async_idle_bfqq);
-}
-
-static void bfq_exit_queue(elevator_t *e)
-{
-	struct bfq_data *bfqd = e->elevator_data;
-	struct request_queue *q = bfqd->queue;
-	struct bfq_wfqdata *wfqd;
-	struct bfq_queue *bfqq, *next;
-	int i;
-
-	bfq_shutdown_timer_wq(bfqd);
-
-	spin_lock_irq(q->queue_lock);
-
-	while (!list_empty(&bfqd->cic_list)) {
-		struct cfq_io_context *cic = list_entry(bfqd->cic_list.next,
-							struct cfq_io_context,
-							queue_list);
-
-		__bfq_exit_single_io_context(bfqd, cic);
-	}
-
-	bfq_put_async_queues(bfqd);
-
-	BUG_ON(bfqd->active_queue != NULL);
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++) {
-		wfqd = &bfqd->service_tree[i];
-		BUG_ON(!RB_EMPTY_ROOT(&wfqd->active));
-		bfqq = wfqd->first_idle;
-		while (bfqq != NULL) {
-			next = bfq_bfqq_of(rb_next(&bfqq->rb_node));
-			bfq_put_idle_queue(wfqd, bfqq);
-			bfqq = next;
-		}
-	}
-	spin_unlock_irq(q->queue_lock);
-
-	bfq_shutdown_timer_wq(bfqd);
-
-	kfree(bfqd);
-}
-
-static void *bfq_init_queue(struct request_queue *q)
-{
-	struct bfq_data *bfqd;
-	int i;
-
-	bfqd = kmalloc_node(sizeof(*bfqd), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (bfqd == NULL)
-		return NULL;
-
-	INIT_LIST_HEAD(&bfqd->cic_list);
-
-	bfqd->queue = q;
-
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++)
-		bfqd->service_tree[i] = BFQ_WFQDATA_INIT;
-
-	init_timer(&bfqd->idle_slice_timer);
-	bfqd->idle_slice_timer.function = bfq_idle_slice_timer;
-	bfqd->idle_slice_timer.data = (unsigned long)bfqd;
-
-	INIT_WORK(&bfqd->unplug_work, bfq_kick_queue);
-
-	bfqd->bfq_quantum = bfq_quantum;
-	bfqd->bfq_fifo_expire[0] = bfq_fifo_expire[0];
-	bfqd->bfq_fifo_expire[1] = bfq_fifo_expire[1];
-	bfqd->bfq_back_max = bfq_back_max;
-	bfqd->bfq_back_penalty = bfq_back_penalty;
-	bfqd->bfq_slice_async_rq = bfq_slice_async_rq;
-	bfqd->bfq_slice_idle = bfq_slice_idle;
-	bfqd->bfq_max_budget = bfq_max_budget;
-
-	return bfqd;
-}
-
-static void bfq_slab_kill(void)
-{
-	if (bfq_pool != NULL)
-		kmem_cache_destroy(bfq_pool);
-	if (bfq_ioc_pool != NULL)
-		kmem_cache_destroy(bfq_ioc_pool);
-}
-
-static int __init bfq_slab_setup(void)
-{
-	bfq_pool = KMEM_CACHE(bfq_queue, 0);
-	if (bfq_pool == NULL)
-		goto fail;
-
-	bfq_ioc_pool = kmem_cache_create("bfq_io_context",
-					 sizeof(struct cfq_io_context),
-					 __alignof__(struct cfq_io_context),
-					 0, NULL);
-	if (bfq_ioc_pool == NULL)
-		goto fail;
-
-	return 0;
-fail:
-	bfq_slab_kill();
-	return -ENOMEM;
-}
-
-/*
- * sysfs parts below -->
- */
-static ssize_t
-bfq_var_show(unsigned int var, char *page)
-{
-	return sprintf(page, "%d\n", var);
-}
-
-static ssize_t
-bfq_var_store(unsigned int *var, const char *page, size_t count)
-{
-	char *p = (char *)page;
-
-	*var = simple_strtoul(p, &p, 10);
-	return count;
-}
-
-#define SHOW_FUNCTION(__FUNC, __VAR, __CONV)				\
-static ssize_t __FUNC(elevator_t *e, char *page)			\
-{									\
-	struct bfq_data *bfqd = e->elevator_data;			\
-	unsigned int __data = __VAR;					\
-	if (__CONV)							\
-		__data = jiffies_to_msecs(__data);			\
-	return bfq_var_show(__data, (page));				\
-}
-SHOW_FUNCTION(bfq_quantum_show, bfqd->bfq_quantum, 0);
-SHOW_FUNCTION(bfq_fifo_expire_sync_show, bfqd->bfq_fifo_expire[1], 1);
-SHOW_FUNCTION(bfq_fifo_expire_async_show, bfqd->bfq_fifo_expire[0], 1);
-SHOW_FUNCTION(bfq_back_seek_max_show, bfqd->bfq_back_max, 0);
-SHOW_FUNCTION(bfq_back_seek_penalty_show, bfqd->bfq_back_penalty, 0);
-SHOW_FUNCTION(bfq_slice_idle_show, bfqd->bfq_slice_idle, 1);
-SHOW_FUNCTION(bfq_slice_async_rq_show, bfqd->bfq_slice_async_rq, 0);
-SHOW_FUNCTION(bfq_max_budget_show, bfqd->bfq_max_budget, 0);
-#undef SHOW_FUNCTION
-
-#define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
-static ssize_t __FUNC(elevator_t *e, const char *page, size_t count)	\
-{									\
-	struct bfq_data *bfqd = e->elevator_data;			\
-	unsigned int __data;						\
-	int ret = bfq_var_store(&__data, (page), count);		\
-	if (__data < (MIN))						\
-		__data = (MIN);						\
-	else if (__data > (MAX))					\
-		__data = (MAX);						\
-	if (__CONV)							\
-		*(__PTR) = msecs_to_jiffies(__data);			\
-	else								\
-		*(__PTR) = __data;					\
-	return ret;							\
-}
-STORE_FUNCTION(bfq_quantum_store, &bfqd->bfq_quantum, 1, UINT_MAX, 0);
-STORE_FUNCTION(bfq_fifo_expire_sync_store, &bfqd->bfq_fifo_expire[1], 1,
-		UINT_MAX, 1);
-STORE_FUNCTION(bfq_fifo_expire_async_store, &bfqd->bfq_fifo_expire[0], 1,
-		UINT_MAX, 1);
-STORE_FUNCTION(bfq_back_seek_max_store, &bfqd->bfq_back_max, 0, UINT_MAX, 0);
-STORE_FUNCTION(bfq_back_seek_penalty_store, &bfqd->bfq_back_penalty, 1,
-		UINT_MAX, 0);
-STORE_FUNCTION(bfq_slice_idle_store, &bfqd->bfq_slice_idle, 0, UINT_MAX, 1);
-STORE_FUNCTION(bfq_slice_async_rq_store, &bfqd->bfq_slice_async_rq, 1,
-		UINT_MAX, 0);
-STORE_FUNCTION(bfq_max_budget_store, &bfqd->bfq_max_budget, 0, UINT_MAX, 0);
-#undef STORE_FUNCTION
-
-#define BFQ_ATTR(name) \
-	__ATTR(name, S_IRUGO|S_IWUSR, bfq_##name##_show, bfq_##name##_store)
-
-static struct elv_fs_entry bfq_attrs[] = {
-	BFQ_ATTR(quantum),
-	BFQ_ATTR(fifo_expire_sync),
-	BFQ_ATTR(fifo_expire_async),
-	BFQ_ATTR(back_seek_max),
-	BFQ_ATTR(back_seek_penalty),
-	BFQ_ATTR(slice_async_rq),
-	BFQ_ATTR(slice_idle),
-	BFQ_ATTR(max_budget),
-	__ATTR_NULL
-};
-
-static struct elevator_type iosched_bfq = {
-	.ops = {
-		.elevator_merge_fn = 		bfq_merge,
-		.elevator_merged_fn =		bfq_merged_request,
-		.elevator_merge_req_fn =	bfq_merged_requests,
-		.elevator_allow_merge_fn =	bfq_allow_merge,
-		.elevator_dispatch_fn =		bfq_dispatch_requests,
-		.elevator_add_req_fn =		bfq_insert_request,
-		.elevator_activate_req_fn =	bfq_activate_request,
-		.elevator_deactivate_req_fn =	bfq_deactivate_request,
-		.elevator_queue_empty_fn =	bfq_queue_empty,
-		.elevator_completed_req_fn =	bfq_completed_request,
-		.elevator_former_req_fn =	elv_rb_former_request,
-		.elevator_latter_req_fn =	elv_rb_latter_request,
-		.elevator_set_req_fn =		bfq_set_request,
-		.elevator_put_req_fn =		bfq_put_request,
-		.elevator_may_queue_fn =	bfq_may_queue,
-		.elevator_init_fn =		bfq_init_queue,
-		.elevator_exit_fn =		bfq_exit_queue,
-		.trim =				bfq_free_io_context,
-	},
-	.elevator_attrs =	bfq_attrs,
-	.elevator_name =	"bfq",
-	.elevator_owner =	THIS_MODULE,
-};
-
-static int __init bfq_init(void)
-{
-	/*
-	 * could be 0 on HZ < 1000 setups
-	 */
-	if (bfq_slice_idle == 0)
-		bfq_slice_idle = 1;
-
-	if (bfq_slab_setup())
-		return -ENOMEM;
-
-	elv_register(&iosched_bfq);
-
-	return 0;
-}
-
-static void __exit bfq_exit(void)
-{
-	DECLARE_COMPLETION_ONSTACK(all_gone);
-	elv_unregister(&iosched_bfq);
-	ioc_gone = &all_gone;
-	/* ioc_gone's update must be visible before reading ioc_count */
-	smp_wmb();
-	if (elv_ioc_count_read(ioc_count) != 0)
-		wait_for_completion(ioc_gone);
-	bfq_slab_kill();
-}
-
-module_init(bfq_init);
-module_exit(bfq_exit);
-
-MODULE_AUTHOR("Fabio Checconi, Paolo Valente");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Budget Fair Queueing IO scheduler");
diff -puN block/blk-core.c~revert-git-block block/blk-core.c
--- a/block/blk-core.c~revert-git-block
+++ a/block/blk-core.c
@@ -26,6 +26,8 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 
@@ -48,18 +50,19 @@ struct kmem_cache *blk_requestq_cachep;
  */
 static struct workqueue_struct *kblockd_workqueue;
 
+static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
+
 static void drive_stat_acct(struct request *rq, int new_io)
 {
-	struct hd_struct *part;
 	int rw = rq_data_dir(rq);
 
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
 
-	part = get_part(rq->rq_disk, rq->sector);
-	if (!new_io)
-		__all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
-	else {
+	if (!new_io) {
+		__all_stat_inc(rq->rq_disk, merges[rw], rq->sector);
+	} else {
+		struct hd_struct *part = get_part(rq->rq_disk, rq->sector);
 		disk_round_stats(rq->rq_disk);
 		rq->rq_disk->in_flight++;
 		if (part) {
@@ -109,7 +112,7 @@ void blk_rq_init(struct request_queue *q
 	memset(rq, 0, sizeof(*rq));
 
 	INIT_LIST_HEAD(&rq->queuelist);
-	rq->cpu = -1;
+	INIT_LIST_HEAD(&rq->donelist);
 	rq->q = q;
 	rq->sector = rq->hard_sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
@@ -178,11 +181,6 @@ void blk_dump_rq_flags(struct request *r
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
-static inline int blk_is_io_cpu(struct request_queue *q)
-{
-	return cpu_isset(smp_processor_id(), q->queue_cpu);
-}
-
 /*
  * "plug" the device if there are no outstanding requests: this will
  * force the transfer to start only after we have put all the requests
@@ -255,11 +253,9 @@ EXPORT_SYMBOL(__generic_unplug_device);
  **/
 void generic_unplug_device(struct request_queue *q)
 {
-	if (blk_queue_plugged(q)) {
-		spin_lock_irq(q->queue_lock);
-		__generic_unplug_device(q);
-		spin_unlock_irq(q->queue_lock);
-	}
+	spin_lock_irq(q->queue_lock);
+	__generic_unplug_device(q);
+	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL(generic_unplug_device);
 
@@ -289,7 +285,7 @@ void blk_unplug_timeout(unsigned long da
 	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
-	kblockd_schedule_work(q, &q->unplug_work);
+	kblockd_schedule_work(&q->unplug_work);
 }
 
 void blk_unplug(struct request_queue *q)
@@ -306,22 +302,6 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
-static void blk_invoke_request_fn(struct request_queue *q)
-{
-	/*
-	 * one level of recursion is ok and is much faster than kicking
-	 * the unplug handling
-	 */
-	if (blk_is_io_cpu(q) &&
-	    !test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
-		q->request_fn(q);
-		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else {
-		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
-		kblockd_schedule_work(q, &q->unplug_work);
-	}
-}
-
 /**
  * blk_start_queue - restart a previously stopped queue
  * @q:    The &struct request_queue in question
@@ -336,7 +316,19 @@ void blk_start_queue(struct request_queu
 	WARN_ON(!irqs_disabled());
 
 	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
-	blk_invoke_request_fn(q);
+
+	/*
+	 * one level of recursion is ok and is much faster than kicking
+	 * the unplug handling
+	 */
+	if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		queue_flag_set(QUEUE_FLAG_REENTER, q);
+		q->request_fn(q);
+		queue_flag_clear(QUEUE_FLAG_REENTER, q);
+	} else {
+		blk_plug_device(q);
+		kblockd_schedule_work(&q->unplug_work);
+	}
 }
 EXPORT_SYMBOL(blk_start_queue);
 
@@ -390,8 +382,20 @@ void __blk_run_queue(struct request_queu
 {
 	blk_remove_plug(q);
 
-	if (!elv_queue_empty(q))
-		blk_invoke_request_fn(q);
+	/*
+	 * Only recurse once to avoid overrunning the stack, let the unplug
+	 * handling reinvoke the handler shortly if we already got there.
+	 */
+	if (!elv_queue_empty(q)) {
+		if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+			queue_flag_set(QUEUE_FLAG_REENTER, q);
+			q->request_fn(q);
+			queue_flag_clear(QUEUE_FLAG_REENTER, q);
+		} else {
+			blk_plug_device(q);
+			kblockd_schedule_work(&q->unplug_work);
+		}
+	}
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -462,8 +466,6 @@ struct request_queue *blk_alloc_queue_no
 	if (!q)
 		return NULL;
 
-	cpus_setall(q->queue_cpu);
-	cpus_setall(q->complete_cpu);
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 	err = bdi_init(&q->backing_dev_info);
@@ -867,10 +869,7 @@ EXPORT_SYMBOL(blk_get_request);
  */
 void blk_start_queueing(struct request_queue *q)
 {
-	if (!blk_is_io_cpu(q)) {
-		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
-		kblockd_schedule_work(q, &q->unplug_work);
-	} else if (!blk_queue_plugged(q))
+	if (!blk_queue_plugged(q))
 		q->request_fn(q);
 	else
 		__generic_unplug_device(q);
@@ -1182,15 +1181,13 @@ get_rq:
 	init_request_from_bio(req, bio);
 
 	spin_lock_irq(q->queue_lock);
-	if (q->queue_flags & (1 << QUEUE_FLAG_SAME_COMP) ||
-	    bio_flagged(bio, BIO_CPU_AFFINE))
-		req->cpu = blk_cpu_to_group(smp_processor_id());
 	if (elv_queue_empty(q))
 		blk_plug_device(q);
 	add_request(q, req);
 out:
 	if (sync)
 		__generic_unplug_device(q);
+
 	spin_unlock_irq(q->queue_lock);
 	return 0;
 
@@ -1533,11 +1530,10 @@ static int __end_that_request_first(stru
 	}
 
 	if (blk_fs_request(req) && req->rq_disk) {
-		struct hd_struct *part = get_part(req->rq_disk, req->sector);
 		const int rw = rq_data_dir(req);
 
-		all_stat_add(req->rq_disk, part, sectors[rw],
-				nr_bytes >> 9, req->sector);
+		all_stat_add(req->rq_disk, sectors[rw],
+			     nr_bytes >> 9, req->sector);
 	}
 
 	total_bytes = bio_nbytes = 0;
@@ -1622,6 +1618,82 @@ static int __end_that_request_first(stru
 }
 
 /*
+ * splice the completion data to a local structure and hand off to
+ * process_completion_queue() to complete the requests
+ */
+static void blk_done_softirq(struct softirq_action *h)
+{
+	struct list_head *cpu_list, local_list;
+
+	local_irq_disable();
+	cpu_list = &__get_cpu_var(blk_cpu_done);
+	list_replace_init(cpu_list, &local_list);
+	local_irq_enable();
+
+	while (!list_empty(&local_list)) {
+		struct request *rq;
+
+		rq = list_entry(local_list.next, struct request, donelist);
+		list_del_init(&rq->donelist);
+		rq->q->softirq_done_fn(rq);
+	}
+}
+
+static int __cpuinit blk_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	/*
+	 * If a CPU goes away, splice its entries to the current CPU
+	 * and trigger a run of the softirq
+	 */
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		int cpu = (unsigned long) hcpu;
+
+		local_irq_disable();
+		list_splice_init(&per_cpu(blk_cpu_done, cpu),
+				 &__get_cpu_var(blk_cpu_done));
+		raise_softirq_irqoff(BLOCK_SOFTIRQ);
+		local_irq_enable();
+	}
+
+	return NOTIFY_OK;
+}
+
+
+static struct notifier_block blk_cpu_notifier __cpuinitdata = {
+	.notifier_call	= blk_cpu_notify,
+};
+
+/**
+ * blk_complete_request - end I/O on a request
+ * @req:      the request being processed
+ *
+ * Description:
+ *     Ends all I/O on a request. It does not handle partial completions,
+ *     unless the driver actually implements this in its completion callback
+ *     through requeueing. The actual completion happens out-of-order,
+ *     through a softirq handler. The user must have registered a completion
+ *     callback through blk_queue_softirq_done().
+ **/
+
+void blk_complete_request(struct request *req)
+{
+	struct list_head *cpu_list;
+	unsigned long flags;
+
+	BUG_ON(!req->q->softirq_done_fn);
+
+	local_irq_save(flags);
+
+	cpu_list = &__get_cpu_var(blk_cpu_done);
+	list_add_tail(&req->donelist, cpu_list);
+	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(blk_complete_request);
+
+/*
  * queue lock must be held
  */
 static void end_that_request_last(struct request *req, int error)
@@ -1647,8 +1719,8 @@ static void end_that_request_last(struct
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part = get_part(disk, req->sector);
 
-		__all_stat_inc(disk, part, ios[rw], req->sector);
-		__all_stat_add(disk, part, ticks[rw], duration, req->sector);
+		__all_stat_inc(disk, ios[rw], req->sector);
+		__all_stat_add(disk, ticks[rw], duration, req->sector);
 		disk_round_stats(disk);
 		disk->in_flight--;
 		if (part) {
@@ -1938,18 +2010,9 @@ void blk_rq_bio_prep(struct request_queu
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
-int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
+int kblockd_schedule_work(struct work_struct *work)
 {
-	int cpu;
-
-	if (blk_is_io_cpu(q))
-		return queue_work(kblockd_workqueue, work);
-
-	/*
-	 * would need to be improved, of course...
-	 */
-	cpu = first_cpu(q->queue_cpu);
-	return queue_work_on_cpu(kblockd_workqueue, work, cpu);
+	return queue_work(kblockd_workqueue, work);
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
@@ -1961,6 +2024,8 @@ EXPORT_SYMBOL(kblockd_flush_work);
 
 int __init blk_dev_init(void)
 {
+	int i;
+
 	kblockd_workqueue = create_workqueue("kblockd");
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
@@ -1971,6 +2036,12 @@ int __init blk_dev_init(void)
 	blk_requestq_cachep = kmem_cache_create("blkdev_queue",
 			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);
 
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
+
+	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
+	register_hotcpu_notifier(&blk_cpu_notifier);
+
 	return 0;
 }
 
diff -puN block/blk-ioc.c~revert-git-block block/blk-ioc.c
--- a/block/blk-ioc.c~revert-git-block
+++ a/block/blk-ioc.c
@@ -15,12 +15,13 @@
  */
 static struct kmem_cache *iocontext_cachep;
 
-static void hlist_sched_dtor(struct io_context *ioc, struct hlist_head *list)
+static void cfq_dtor(struct io_context *ioc)
 {
-	if (!hlist_empty(list)) {
+	if (!hlist_empty(&ioc->cic_list)) {
 		struct cfq_io_context *cic;
 
-		cic = list_entry(list->first, struct cfq_io_context, cic_list);
+		cic = list_entry(ioc->cic_list.first, struct cfq_io_context,
+								cic_list);
 		cic->dtor(ioc);
 	}
 }
@@ -40,9 +41,8 @@ int put_io_context(struct io_context *io
 		rcu_read_lock();
 		if (ioc->aic && ioc->aic->dtor)
 			ioc->aic->dtor(ioc->aic);
-		hlist_sched_dtor(ioc, &ioc->cic_list);
-		hlist_sched_dtor(ioc, &ioc->bfq_cic_list);
 		rcu_read_unlock();
+		cfq_dtor(ioc);
 
 		kmem_cache_free(iocontext_cachep, ioc);
 		return 1;
@@ -51,18 +51,18 @@ int put_io_context(struct io_context *io
 }
 EXPORT_SYMBOL(put_io_context);
 
-static void hlist_sched_exit(struct io_context *ioc, struct hlist_head *list)
+static void cfq_exit(struct io_context *ioc)
 {
 	rcu_read_lock();
 
-	if (!hlist_empty(list)) {
+	if (!hlist_empty(&ioc->cic_list)) {
 		struct cfq_io_context *cic;
 
-		cic = list_entry(list->first, struct cfq_io_context, cic_list);
+		cic = list_entry(ioc->cic_list.first, struct cfq_io_context,
+								cic_list);
 		cic->exit(ioc);
 	}
 	rcu_read_unlock();
-
 }
 
 /* Called by the exitting task */
@@ -78,8 +78,7 @@ void exit_io_context(void)
 	if (atomic_dec_and_test(&ioc->nr_tasks)) {
 		if (ioc->aic && ioc->aic->exit)
 			ioc->aic->exit(ioc->aic);
-		hlist_sched_exit(ioc, &ioc->cic_list);
-		hlist_sched_exit(ioc, &ioc->bfq_cic_list);
+		cfq_exit(ioc);
 
 		put_io_context(ioc);
 	}
@@ -101,7 +100,6 @@ struct io_context *alloc_io_context(gfp_
 		ret->aic = NULL;
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_list);
-		INIT_HLIST_HEAD(&ret->bfq_cic_list);
 		ret->ioc_data = NULL;
 	}
 
diff -puN block/blk-merge.c~revert-git-block block/blk-merge.c
--- a/block/blk-merge.c~revert-git-block
+++ a/block/blk-merge.c
@@ -149,9 +149,9 @@ static int blk_phys_contig_segment(struc
 static int blk_hw_contig_segment(struct request_queue *q, struct bio *bio,
 				 struct bio *nxt)
 {
-	if (!bio_flagged(bio, BIO_SEG_VALID))
+	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
-	if (!bio_flagged(nxt, BIO_SEG_VALID))
+	if (unlikely(!bio_flagged(nxt, BIO_SEG_VALID)))
 		blk_recount_segments(q, nxt);
 	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)) ||
 	    BIOVEC_VIRT_OVERSIZE(bio->bi_hw_back_size + nxt->bi_hw_front_size))
@@ -312,9 +312,9 @@ int ll_back_merge_fn(struct request_queu
 			q->last_merge = NULL;
 		return 0;
 	}
-	if (!bio_flagged(req->biotail, BIO_SEG_VALID))
+	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
 		blk_recount_segments(q, req->biotail);
-	if (!bio_flagged(bio, BIO_SEG_VALID))
+	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
 	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))
@@ -352,9 +352,9 @@ int ll_front_merge_fn(struct request_que
 		return 0;
 	}
 	len = bio->bi_hw_back_size + req->bio->bi_hw_front_size;
-	if (!bio_flagged(bio, BIO_SEG_VALID))
+	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
-	if (!bio_flagged(req->bio, BIO_SEG_VALID))
+	if (unlikely(!bio_flagged(req->bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, req->bio);
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(req->bio)) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
diff -puN block/blk-settings.c~revert-git-block block/blk-settings.c
--- a/block/blk-settings.c~revert-git-block
+++ a/block/blk-settings.c
@@ -404,43 +404,7 @@ void blk_queue_update_dma_alignment(stru
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
-/**
- * blk_queue_set_completion_cpu - Set IO CPU for completions
- * @q:     the request queue for the device
- * @mask:  mask of allowed CPUs
- *
- * Description:
- *    This function allows a driver to set a CPU that should handle completions
- *    for this device.
- *
- **/
-int blk_queue_set_completion_cpu(struct request_queue *q, cpumask_t mask)
-{
-	cpus_setall(q->complete_cpu);
-	cpus_and(q->complete_cpu, q->complete_cpu, mask);
-	return 0;
-}
-EXPORT_SYMBOL(blk_queue_set_completion_cpu);
-
-/**
- * blk_queue_set_queue_cpu - Set IO CPU for queuing
- * @q:     the request queue for the device
- * @mask:  mask of allowed CPUs
- *
- * Description:
- *    This function allows a driver to set a CPU that should handle queuing
- *    for this device.
- *
- **/
-int blk_queue_set_queue_cpu(struct request_queue *q, cpumask_t mask)
-{
-	cpus_setall(q->queue_cpu);
-	cpus_and(q->queue_cpu, q->queue_cpu, mask);
-	return 0;
-}
-EXPORT_SYMBOL(blk_queue_set_queue_cpu);
-
-int __init blk_settings_init(void)
+static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
 	blk_max_pfn = max_pfn - 1;
diff -puN block/blk-softirq.c~revert-git-block /dev/null
--- a/block/blk-softirq.c
+++ /dev/null
@@ -1,173 +0,0 @@
-/*
- * Functions related to softirq rq completions
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/bio.h>
-#include <linux/blkdev.h>
-#include <linux/interrupt.h>
-#include <linux/cpu.h>
-
-#include "blk.h"
-
-static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
-
-/*
- * Softirq action handler - move entries to local list and loop over them
- * while passing them to the queue registered handler.
- */
-static void blk_done_softirq(struct softirq_action *h)
-{
-	struct list_head *cpu_list, local_list;
-
-	local_irq_disable();
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_replace_init(cpu_list, &local_list);
-	local_irq_enable();
-
-	while (!list_empty(&local_list)) {
-		struct request *rq;
-
-		rq = list_entry(local_list.next, struct request, csd.list);
-		list_del_init(&rq->csd.list);
-		rq->q->softirq_done_fn(rq);
-	}
-}
-
-#ifdef CONFIG_SMP
-static void trigger_softirq(void *data)
-{
-	struct request *rq = data;
-	unsigned long flags;
-	struct list_head *list;
-
-	local_irq_save(flags);
-	list = &__get_cpu_var(blk_cpu_done);
-	list_add_tail(&rq->csd.list, list);
-
-	if (list->next == &rq->csd.list)
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
-
-	local_irq_restore(flags);
-}
-
-/*
- * Setup and invoke a run of 'trigger_softirq' on the given cpu.
- */
-static int raise_blk_irq(int cpu, struct request *rq)
-{
-	if (cpu_online(cpu)) {
-		struct call_single_data *data = &rq->csd;
-
-		data->func = trigger_softirq;
-		data->info = rq;
-		data->flags = 0;
-
-		__smp_call_function_single(cpu, data);
-		return 0;
-	}
-
-	return 1;
-}
-#else /* CONFIG_SMP */
-static int raise_blk_irq(int cpu, struct request *rq)
-{
-	/*
-	 * We can never get here on UP
-	 */
-	BUG();
-	return 1;
-}
-#endif
-
-static int __cpuinit blk_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
-{
-	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
-	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		int cpu = (unsigned long) hcpu;
-
-		local_irq_disable();
-		list_splice_init(&per_cpu(blk_cpu_done, cpu),
-				 &__get_cpu_var(blk_cpu_done));
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
-		local_irq_enable();
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata blk_cpu_notifier = {
-	.notifier_call	= blk_cpu_notify,
-};
-
-/**
- * blk_complete_request - end I/O on a request
- * @req:      the request being processed
- *
- * Description:
- *     Ends all I/O on a request. It does not handle partial completions,
- *     unless the driver actually implements this in its completion callback
- *     through requeueing. The actual completion happens out-of-order,
- *     through a softirq handler. The user must have registered a completion
- *     callback through blk_queue_softirq_done().
- **/
-void blk_complete_request(struct request *req)
-{
-	struct request_queue *q = req->q;
-	unsigned long flags;
-	int ccpu, cpu, group_cpu;
-
-	BUG_ON(!q->softirq_done_fn);
-
-	local_irq_save(flags);
-	cpu = smp_processor_id();
-	group_cpu = blk_cpu_to_group(cpu);
-
-	/*
-	 * Select completion CPU
-	 */
-	if ((q->queue_flags & (1 << QUEUE_FLAG_SAME_COMP)) && req->cpu != -1)
-		ccpu = req->cpu;
-	else if (cpu_isset(cpu, q->complete_cpu))
-		ccpu = cpu;
-	else
-		ccpu = first_cpu(q->complete_cpu);
-
-	if (ccpu == cpu || ccpu == group_cpu) {
-		struct list_head *list;
-do_local:
-		list = &__get_cpu_var(blk_cpu_done);
-		list_add_tail(&req->csd.list, list);
-
-		/*
-		 * if the list only contains our just added request,
-		 * signal a raise of the softirq. If there are already
-		 * entries there, someone already raised the irq but it
-		 * hasn't run yet.
-		 */
-		if (list->next == &req->csd.list)
-			raise_softirq_irqoff(BLOCK_SOFTIRQ);
-	} else if (raise_blk_irq(ccpu, req))
-		goto do_local;
-
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(blk_complete_request);
-
-__init int blk_softirq_init(void)
-{
-	int i;
-
-	for_each_possible_cpu(i)
-		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
-
-	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
-	register_hotcpu_notifier(&blk_cpu_notifier);
-	return 0;
-}
-subsys_initcall(blk_softirq_init);
diff -puN block/blk-sysfs.c~revert-git-block block/blk-sysfs.c
--- a/block/blk-sysfs.c~revert-git-block
+++ a/block/blk-sysfs.c
@@ -146,93 +146,14 @@ static ssize_t queue_nomerges_store(stru
 	unsigned long nm;
 	ssize_t ret = queue_var_store(&nm, page, count);
 
-	spin_lock_irq(q->queue_lock);
 	if (nm)
-		queue_flag_set(QUEUE_FLAG_NOMERGES, q);
+	       set_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
 	else
-		queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
+	       clear_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
 
-	spin_unlock_irq(q->queue_lock);
 	return ret;
 }
 
-static ssize_t queue_complete_affinity_show(struct request_queue *q, char *page)
-{
-	ssize_t len = cpumask_scnprintf(page, PAGE_SIZE, q->complete_cpu);
-
-	len += sprintf(page + len, "\n");
-	return len;
-}
-
-/*
- * Pass in multiple CPUs with:
- * # echo 0,1,2 > completion_affinity
- */
-static ssize_t queue_complete_affinity_store(struct request_queue *q,
-					     const char *page, size_t count)
-{
-	cpumask_t mask;
-	int ret;
-
-	cpus_clear(mask);
-	ret = cpulist_parse(page, mask);
-	if (ret < 0)
-		return ret;
-
-	spin_lock_irq(q->queue_lock);
-	blk_queue_set_completion_cpu(q, mask);
-	spin_unlock_irq(q->queue_lock);
-	return count;
-}
-
-static ssize_t queue_queue_affinity_show(struct request_queue *q, char *page)
-{
-	ssize_t len = cpumask_scnprintf(page, PAGE_SIZE, q->queue_cpu);
-
-	len += sprintf(page + len, "\n");
-	return len;
-}
-
-static ssize_t queue_queue_affinity_store(struct request_queue *q,
-					  const char *page, size_t count)
-{
-	cpumask_t mask;
-	int ret;
-
-	cpus_clear(mask);
-	ret = cpulist_parse(page, mask);
-	if (ret < 0)
-		return ret;
-
-	spin_lock_irq(q->queue_lock);
-	blk_queue_set_queue_cpu(q, mask);
-	spin_unlock_irq(q->queue_lock);
-	return count;
-}
-
-static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
-{
-	unsigned int same = (q->queue_flags & 1 << (QUEUE_FLAG_SAME_COMP)) != 0;
-
-	return queue_var_show(same, page);
-}
-
-static ssize_t
-queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
-{
-	unsigned long val;
-	ssize_t ret;
-
-	ret = queue_var_store(&val, page, count);
-	spin_lock_irq(q->queue_lock);
-	if (val)
-		q->queue_flags |= (1 << QUEUE_FLAG_SAME_COMP);
-	else
-		q->queue_flags &= ~(1 << QUEUE_FLAG_SAME_COMP);
-	spin_unlock_irq(q->queue_lock);
-
-	return ret;
-}
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -274,24 +195,6 @@ static struct queue_sysfs_entry queue_no
 	.store = queue_nomerges_store,
 };
 
-static struct queue_sysfs_entry queue_complete_affinity_entry = {
-	.attr = {.name = "completion_affinity", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_complete_affinity_show,
-	.store = queue_complete_affinity_store,
-};
-
-static struct queue_sysfs_entry queue_queue_affinity_entry = {
-	.attr = {.name = "queue_affinity", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_queue_affinity_show,
-	.store = queue_queue_affinity_store,
-};
-
-static struct queue_sysfs_entry queue_rq_affinity_entry = {
-	.attr = {.name = "rq_affinity", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_rq_affinity_show,
-	.store = queue_rq_affinity_store,
-};
-
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -300,9 +203,6 @@ static struct attribute *default_attrs[]
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_nomerges_entry.attr,
-	&queue_complete_affinity_entry.attr,
-	&queue_queue_affinity_entry.attr,
-	&queue_rq_affinity_entry.attr,
 	NULL,
 };
 
diff -puN block/blk-tag.c~revert-git-block block/blk-tag.c
--- a/block/blk-tag.c~revert-git-block
+++ a/block/blk-tag.c
@@ -70,7 +70,7 @@ void __blk_queue_free_tags(struct reques
 	__blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
-	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
+	queue_flag_clear(QUEUE_FLAG_QUEUED, q);
 }
 
 /**
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(blk_free_tags);
  **/
 void blk_queue_free_tags(struct request_queue *q)
 {
-	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
+	queue_flag_clear(QUEUE_FLAG_QUEUED, q);
 }
 EXPORT_SYMBOL(blk_queue_free_tags);
 
@@ -171,9 +171,6 @@ EXPORT_SYMBOL(blk_init_tags);
  * @q:  the request queue for the device
  * @depth:  the maximum queue depth supported
  * @tags: the tag to use
- *
- * Queue lock must be held here if the function is called to resize an
- * existing map.
  **/
 int blk_queue_init_tags(struct request_queue *q, int depth,
 			struct blk_queue_tag *tags)
@@ -200,7 +197,7 @@ int blk_queue_init_tags(struct request_q
 	 * assign it, all done
 	 */
 	q->queue_tags = tags;
-	queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, q);
+	queue_flag_set(QUEUE_FLAG_QUEUED, q);
 	INIT_LIST_HEAD(&q->tag_busy_list);
 	return 0;
 fail:
diff -puN block/blk.h~revert-git-block block/blk.h
--- a/block/blk.h~revert-git-block
+++ a/block/blk.h
@@ -51,16 +51,4 @@ static inline int queue_congestion_off_t
 	return q->nr_congestion_off;
 }
 
-static inline int blk_cpu_to_group(int cpu)
-{
-#ifdef CONFIG_SCHED_MC
-	cpumask_t mask = cpu_coregroup_map(cpu);
-	return first_cpu(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	return first_cpu(per_cpu(cpu_sibling_map, cpu));
-#else
-	return cpu;
-#endif
-}
-
 #endif
diff -puN block/cfq-iosched.c~revert-git-block block/cfq-iosched.c
--- a/block/cfq-iosched.c~revert-git-block
+++ a/block/cfq-iosched.c
@@ -235,7 +235,7 @@ static inline int cfq_bio_sync(struct bi
 static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
 {
 	if (cfqd->busy_queues)
-		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
+		kblockd_schedule_work(&cfqd->unplug_work);
 }
 
 static int cfq_queue_empty(struct request_queue *q)
@@ -1142,17 +1142,6 @@ static void cfq_put_queue(struct cfq_que
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
-static void
-__call_for_each_cic(struct io_context *ioc,
-		    void (*func)(struct io_context *, struct cfq_io_context *))
-{
-	struct cfq_io_context *cic;
-	struct hlist_node *n;
-
-	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
-		func(ioc, cic);
-}
-
 /*
  * Call func for each cic attached to this ioc.
  */
@@ -1160,8 +1149,12 @@ static void
 call_for_each_cic(struct io_context *ioc,
 		  void (*func)(struct io_context *, struct cfq_io_context *))
 {
+	struct cfq_io_context *cic;
+	struct hlist_node *n;
+
 	rcu_read_lock();
-	__call_for_each_cic(ioc, func);
+	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
+		func(ioc, cic);
 	rcu_read_unlock();
 }
 
@@ -1205,7 +1198,7 @@ static void cfq_free_io_context(struct i
 	 * should be ok to iterate over the known list, we will see all cic's
 	 * since no new ones are added.
 	 */
-	__call_for_each_cic(ioc, cic_free_func);
+	call_for_each_cic(ioc, cic_free_func);
 }
 
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
@@ -1303,10 +1296,10 @@ static void cfq_init_prio_data(struct cf
 		printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
 	case IOPRIO_CLASS_NONE:
 		/*
-		 * no prio set, inherit CPU scheduling settings
+		 * no prio set, place us in the middle of the BE classes
 		 */
 		cfqq->ioprio = task_nice_ioprio(tsk);
-		cfqq->ioprio_class = task_nice_ioclass(tsk);
+		cfqq->ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_RT:
 		cfqq->ioprio = task_ioprio(ioc);
diff -puN drivers/block/aoe/aoecmd.c~revert-git-block drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~revert-git-block
+++ a/drivers/block/aoe/aoecmd.c
@@ -755,13 +755,11 @@ diskstats(struct gendisk *disk, struct b
 {
 	unsigned long n_sect = bio->bi_size >> 9;
 	const int rw = bio_data_dir(bio);
-	struct hd_struct *part;
 
-	part = get_part(disk, sector);
-	all_stat_inc(disk, part, ios[rw], sector);
-	all_stat_add(disk, part, ticks[rw], duration, sector);
-	all_stat_add(disk, part, sectors[rw], n_sect, sector);
-	all_stat_add(disk, part, io_ticks, duration, sector);
+	all_stat_inc(disk, ios[rw], sector);
+	all_stat_add(disk, ticks[rw], duration, sector);
+	all_stat_add(disk, sectors[rw], n_sect, sector);
+	all_stat_add(disk, io_ticks, duration, sector);
 }
 
 void
diff -puN fs/bio.c~revert-git-block fs/bio.c
--- a/fs/bio.c~revert-git-block
+++ a/fs/bio.c
@@ -158,7 +158,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 
 		bio_init(bio);
 		if (likely(nr_iovecs)) {
-			unsigned long uninitialized_var(idx);
+			unsigned long idx = 0; /* shut up gcc */
 
 			bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 			if (unlikely(!bvl)) {
@@ -963,7 +963,6 @@ static void bio_copy_kern_endio(struct b
  *	@data: pointer to buffer to copy
  *	@len: length in bytes
  *	@gfp_mask: allocation flags for bio and page allocation
- *	@reading: data direction is READ
  *
  *	copy the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
diff -puN fs/ioprio.c~revert-git-block fs/ioprio.c
--- a/fs/ioprio.c~revert-git-block
+++ a/fs/ioprio.c
@@ -58,8 +58,6 @@ static int set_task_ioprio(struct task_s
 
 	if (!err) {
 		ioc->ioprio = ioprio;
-		/* make sure schedulers see the new ioprio value */
-		wmb();
 		ioc->ioprio_changed = 1;
 	}
 
diff -puN fs/splice.c~revert-git-block fs/splice.c
--- a/fs/splice.c~revert-git-block
+++ a/fs/splice.c
@@ -29,7 +29,6 @@
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 #include <linux/security.h>
-#include <linux/mman.h>
 
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
@@ -812,19 +811,24 @@ generic_file_splice_write(struct pipe_in
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
+	int killsuid, killpriv;
 	ssize_t ret;
+	int err = 0;
 
-	inode_double_lock(inode, pipe->inode);
-	ret = remove_suid(out->f_path.dentry);
-	if (likely(!ret))
-		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-	inode_double_unlock(inode, pipe->inode);
+	killpriv = security_inode_need_killpriv(out->f_path.dentry);
+	killsuid = should_remove_suid(out->f_path.dentry);
+	if (unlikely(killsuid || killpriv)) {
+		mutex_lock(&inode->i_mutex);
+		if (killpriv)
+			err = security_inode_killpriv(out->f_path.dentry);
+		if (!err && killsuid)
+			err = __remove_suid(out->f_path.dentry, killsuid);
+		mutex_unlock(&inode->i_mutex);
+		if (err)
+			return err;
+	}
+
+	ret = splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_file);
 	if (ret > 0) {
 		unsigned long nr_pages;
 
@@ -836,8 +840,6 @@ generic_file_splice_write(struct pipe_in
 		 * sync it.
 		 */
 		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			int err;
-
 			mutex_lock(&inode->i_mutex);
 			err = generic_osync_inode(inode, mapping,
 						  OSYNC_METADATA|OSYNC_DATA);
@@ -1178,223 +1180,6 @@ static int copy_from_user_mmap_sem(void 
 }
 
 /*
- * Just copy the data to user space
- */
-static int pipe_to_user_copy(struct pipe_inode_info *pipe,
-			     struct pipe_buffer *buf, struct splice_desc *sd)
-{
-	char *src;
-	int ret;
-
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * See if we can use the atomic maps, by prefaulting in the
-	 * pages and doing an atomic copy
-	 */
-	if (!fault_in_pages_writeable(sd->u.userptr, sd->len)) {
-		src = buf->ops->map(pipe, buf, 1);
-		ret = __copy_to_user_inatomic(sd->u.userptr, src + buf->offset,
-							sd->len);
-		buf->ops->unmap(pipe, buf, src);
-		if (!ret) {
-			ret = sd->len;
-			goto out;
-		}
-	}
-
-	/*
-	 * No dice, use slow non-atomic map and copy
-	 */
-	src = buf->ops->map(pipe, buf, 0);
-
-	ret = sd->len;
-	if (copy_to_user(sd->u.userptr, src + buf->offset, sd->len))
-		ret = -EFAULT;
-
-	buf->ops->unmap(pipe, buf, src);
-out:
-	if (ret > 0)
-		sd->u.userptr += ret;
-	return ret;
-}
-
-/*
- * This actor doesn't really do anything interesting, it merely settles
- * the pipe page and adds it to the work list for insertion when the entire
- * pipe has been processed.
- */
-static int pipe_to_user_map(struct pipe_inode_info *pipe,
-			    struct pipe_buffer *buf, struct splice_desc *sd)
-{
-	struct splice_pipe_desc *spd = sd->u.data;
-	int error;
-
-	if (buf->len & ~PAGE_MASK)
-		return -EINVAL;
-
-	error = buf->ops->confirm(pipe, buf);
-	if (!error) {
-		spd->pages[spd->nr_pages++] = buf->page;
-		return buf->len;
-	}
-
-	return error;
-}
-
-/*
- * Setup a vma for this address range, and let pipe_to_user_map() insert
- * pages into that.
- */
-static int vmsplice_pipe_map(struct pipe_inode_info *pipe,
-			     struct splice_desc *sd)
-{
-	struct mm_struct *mm = current->mm;
-	struct page *pages[PIPE_BUFFERS];
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-	};
-	struct vm_area_struct *vma;
-	unsigned long addr;
-	int ret, i, err;
-
-	if (sd->total_len & ~PAGE_MASK)
-		return -EINVAL;
-
-	/*
-	 * Run through the pipe buffers and settle the contents. The number
-	 * of processed pages will be put in spd.nr_pages.
-	 */
-	addr = (unsigned long) sd->u.userptr;
-	sd->pos = 0;
-	sd->u.data = &spd;
-	err = __splice_from_pipe(pipe, sd, pipe_to_user_map);
-	if (unlikely(err <= 0))
-		return err;
-	else if (unlikely(!spd.nr_pages))
-		return 0;
-
-	/*
-	 * We have a non-zero number of pages available. Now find the
-	 * associated vma so we can establish pages mappings there.
-	 */
-	ret = -EINVAL;
-	down_read(&mm->mmap_sem);
-
-	vma = find_vma(mm, addr);
-	if (unlikely(!vma))
-		goto out;
-
-	for (i = ret = err = 0; i < spd.nr_pages; i++) {
-		err = vm_insert_page(vma, addr, spd.pages[i]);
-		if (unlikely(err))
-			break;
-
-		addr += PAGE_SIZE;
-		ret += PAGE_SIZE;
-	}
-
-out:
-	up_read(&mm->mmap_sem);
-
-	if (err && !ret)
-		ret = err;
-
-	return ret;
-}
-
-/*
- * vmsplice a pipe to user memory. If SPLICE_F_MOVE is set, we will attempt
- * to move the pipe pages to the user address space. Otherwise a simple
- * copy is done.
- */
-static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
-			     unsigned long nr_segs, unsigned int flags)
-{
-	struct pipe_inode_info *pipe;
-	struct splice_desc sd;
-	long spliced, ret;
-
-	pipe = pipe_info(file->f_path.dentry->d_inode);
-	if (!pipe)
-		return -EBADF;
-
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
-
-	spliced = ret = 0;
-	while (nr_segs) {
-		void __user *base;
-		size_t len;
-
-		/*
-		 * Get user address base and length for this iovec.
-		 */
-		ret = get_user(base, &iov->iov_base);
-		if (unlikely(ret))
-			break;
-		ret = get_user(len, &iov->iov_len);
-		if (unlikely(ret))
-			break;
-
-		/*
-		 * Sanity check this iovec. 0 read succeeds.
-		 */
-		if (unlikely(!len))
-			break;
-		if (unlikely(!base)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
-			ret = -EFAULT;
-			break;
-		}
-
-		sd.len = 0;
-		sd.total_len = len;
-		sd.flags = flags;
-		sd.u.userptr = base;
-		sd.pos = 0;
-
-		/*
-		 * SPLICE_F_MOVE is set, don't copy the data but attempt
-		 * to map it into the app address space.
-		 */
-		if (flags & SPLICE_F_MOVE)
-			ret = vmsplice_pipe_map(pipe, &sd);
-		else
-			ret = __splice_from_pipe(pipe, &sd, pipe_to_user_copy);
-
-		if (ret < 0)
-			break;
-
-		spliced += ret;
-
-		/*
-		 * If we transferred less than a pipe buffer length, break
-		 * out of the loop and let the caller retry.
-		 */
-		if (ret < len)
-			break;
-
-		nr_segs--;
-		iov++;
-	}
-
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
-
-	if (!spliced)
-		spliced = ret;
-
-	return spliced;
-}
-
-/*
  * Map an iov into an array of pages and offset/length tupples. With the
  * partial_page structure, we can map several non-contiguous ranges into
  * our ones pages[] map instead of splitting that operation into pieces.
@@ -1500,6 +1285,129 @@ static int get_iovec_page_array(const st
 	return error;
 }
 
+static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	char *src;
+	int ret;
+
+	ret = buf->ops->confirm(pipe, buf);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * See if we can use the atomic maps, by prefaulting in the
+	 * pages and doing an atomic copy
+	 */
+	if (!fault_in_pages_writeable(sd->u.userptr, sd->len)) {
+		src = buf->ops->map(pipe, buf, 1);
+		ret = __copy_to_user_inatomic(sd->u.userptr, src + buf->offset,
+							sd->len);
+		buf->ops->unmap(pipe, buf, src);
+		if (!ret) {
+			ret = sd->len;
+			goto out;
+		}
+	}
+
+	/*
+	 * No dice, use slow non-atomic map and copy
+ 	 */
+	src = buf->ops->map(pipe, buf, 0);
+
+	ret = sd->len;
+	if (copy_to_user(sd->u.userptr, src + buf->offset, sd->len))
+		ret = -EFAULT;
+
+	buf->ops->unmap(pipe, buf, src);
+out:
+	if (ret > 0)
+		sd->u.userptr += ret;
+	return ret;
+}
+
+/*
+ * For lack of a better implementation, implement vmsplice() to userspace
+ * as a simple copy of the pipes pages to the user iov.
+ */
+static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
+			     unsigned long nr_segs, unsigned int flags)
+{
+	struct pipe_inode_info *pipe;
+	struct splice_desc sd;
+	ssize_t size;
+	int error;
+	long ret;
+
+	pipe = pipe_info(file->f_path.dentry->d_inode);
+	if (!pipe)
+		return -EBADF;
+
+	if (pipe->inode)
+		mutex_lock(&pipe->inode->i_mutex);
+
+	error = ret = 0;
+	while (nr_segs) {
+		void __user *base;
+		size_t len;
+
+		/*
+		 * Get user address base and length for this iovec.
+		 */
+		error = get_user(base, &iov->iov_base);
+		if (unlikely(error))
+			break;
+		error = get_user(len, &iov->iov_len);
+		if (unlikely(error))
+			break;
+
+		/*
+		 * Sanity check this iovec. 0 read succeeds.
+		 */
+		if (unlikely(!len))
+			break;
+		if (unlikely(!base)) {
+			error = -EFAULT;
+			break;
+		}
+
+		if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
+			error = -EFAULT;
+			break;
+		}
+
+		sd.len = 0;
+		sd.total_len = len;
+		sd.flags = flags;
+		sd.u.userptr = base;
+		sd.pos = 0;
+
+		size = __splice_from_pipe(pipe, &sd, pipe_to_user);
+		if (size < 0) {
+			if (!ret)
+				ret = size;
+
+			break;
+		}
+
+		ret += size;
+
+		if (size < len)
+			break;
+
+		nr_segs--;
+		iov++;
+	}
+
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+
+	if (!ret)
+		ret = error;
+
+	return ret;
+}
+
 /*
  * vmsplice splices a user address range into a pipe. It can be thought of
  * as splice-from-memory, where the regular splice is splice-from-file (or
diff -puN include/asm-alpha/smp.h~revert-git-block include/asm-alpha/smp.h
--- a/include/asm-alpha/smp.h~revert-git-block
+++ a/include/asm-alpha/smp.h
@@ -47,6 +47,8 @@ extern struct cpuinfo_alpha cpu_data[NR_
 extern int smp_num_cpus;
 #define cpu_possible_map	cpu_present_map
 
+int smp_call_function_on_cpu(void (*func) (void *info), void *info,int retry, int wait, cpumask_t cpu);
+
 #else /* CONFIG_SMP */
 
 #define hard_smp_processor_id()		0
diff -puN include/asm-ia64/smp.h~revert-git-block include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~revert-git-block
+++ a/include/asm-ia64/smp.h
@@ -38,6 +38,9 @@ ia64_get_lid (void)
 	return lid.f.id << 8 | lid.f.eid;
 }
 
+extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+				  void *info, int wait);
+
 #define hard_smp_processor_id()		ia64_get_lid()
 
 #ifdef CONFIG_SMP
diff -puN include/asm-m32r/smp.h~revert-git-block include/asm-m32r/smp.h
--- a/include/asm-m32r/smp.h~revert-git-block
+++ a/include/asm-m32r/smp.h
@@ -104,7 +104,6 @@ extern unsigned long send_IPI_mask_phys(
 #define LOCAL_TIMER_IPI		(M32R_IRQ_IPI3-M32R_IRQ_IPI0)
 #define INVALIDATE_CACHE_IPI	(M32R_IRQ_IPI4-M32R_IRQ_IPI0)
 #define CPU_BOOT_IPI		(M32R_IRQ_IPI5-M32R_IRQ_IPI0)
-#define CALL_FUNC_SINGLE_IPI	(M32R_IRQ_IPI6-M32R_IRQ_IPI0)
 
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
diff -puN include/asm-mips/smp.h~revert-git-block include/asm-mips/smp.h
--- a/include/asm-mips/smp.h~revert-git-block
+++ a/include/asm-mips/smp.h
@@ -35,6 +35,16 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define NO_PROC_ID	(-1)
 
+struct call_data_struct {
+	void		(*func)(void *);
+	void		*info;
+	atomic_t	started;
+	atomic_t	finished;
+	int		wait;
+};
+
+extern struct call_data_struct *call_data;
+
 #define SMP_RESCHEDULE_YOURSELF	0x1	/* XXX braindead */
 #define SMP_CALL_FUNCTION	0x2
 
diff -puN include/asm-powerpc/smp.h~revert-git-block include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~revert-git-block
+++ a/include/asm-powerpc/smp.h
@@ -67,7 +67,10 @@ DECLARE_PER_CPU(cpumask_t, cpu_sibling_m
  * in /proc/interrupts will be wrong!!! --Troy */
 #define PPC_MSG_CALL_FUNCTION   0
 #define PPC_MSG_RESCHEDULE      1
-#define PPC_MSG_CALL_FUNC_SINGLE	2
+/* This is unused now */
+#if 0
+#define PPC_MSG_MIGRATE_TASK    2
+#endif
 #define PPC_MSG_DEBUGGER_BREAK  3
 
 void smp_init_iSeries(void);
diff -puN include/asm-sh/smp.h~revert-git-block include/asm-sh/smp.h
--- a/include/asm-sh/smp.h~revert-git-block
+++ a/include/asm-sh/smp.h
@@ -26,10 +26,18 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define NO_PROC_ID	(-1)
 
+struct smp_fn_call_struct {
+	spinlock_t lock;
+	atomic_t   finished;
+	void (*fn)(void *);
+	void *data;
+};
+
+extern struct smp_fn_call_struct smp_fn_call;
+
 #define SMP_MSG_FUNCTION	0
 #define SMP_MSG_RESCHEDULE	1
-#define SMP_MSG_FUNCTION_SINGLE	2
-#define SMP_MSG_NR		3
+#define SMP_MSG_NR		2
 
 void plat_smp_setup(void);
 void plat_prepare_cpus(unsigned int max_cpus);
diff -puN include/asm-x86/hw_irq_32.h~revert-git-block include/asm-x86/hw_irq_32.h
--- a/include/asm-x86/hw_irq_32.h~revert-git-block
+++ a/include/asm-x86/hw_irq_32.h
@@ -32,7 +32,6 @@ extern void (*const interrupt[NR_IRQS])(
 void reschedule_interrupt(void);
 void invalidate_interrupt(void);
 void call_function_interrupt(void);
-void call_function_single_interrupt(void);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff -puN include/asm-x86/hw_irq_64.h~revert-git-block include/asm-x86/hw_irq_64.h
--- a/include/asm-x86/hw_irq_64.h~revert-git-block
+++ a/include/asm-x86/hw_irq_64.h
@@ -68,7 +68,6 @@
 #define ERROR_APIC_VECTOR	0xfe
 #define RESCHEDULE_VECTOR	0xfd
 #define CALL_FUNCTION_VECTOR	0xfc
-#define	CALL_FUNCTION_SINGLE_VECTOR	0xfb
 /* fb free - please don't readd KDB here because it's useless
    (hint - think what a NMI bit does to a vector) */
 #define THERMAL_APIC_VECTOR	0xfa
@@ -103,7 +102,6 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
-void call_function_single_interrupt(void);
 void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
diff -puN include/asm-x86/mach-default/entry_arch.h~revert-git-block include/asm-x86/mach-default/entry_arch.h
--- a/include/asm-x86/mach-default/entry_arch.h~revert-git-block
+++ a/include/asm-x86/mach-default/entry_arch.h
@@ -13,7 +13,6 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
-BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 #endif
 
 /*
diff -puN include/asm-x86/mach-default/irq_vectors.h~revert-git-block include/asm-x86/mach-default/irq_vectors.h
--- a/include/asm-x86/mach-default/irq_vectors.h~revert-git-block
+++ a/include/asm-x86/mach-default/irq_vectors.h
@@ -48,7 +48,6 @@
 #define INVALIDATE_TLB_VECTOR	0xfd
 #define RESCHEDULE_VECTOR	0xfc
 #define CALL_FUNCTION_VECTOR	0xfb
-#define CALL_FUNCTION_SINGLE_VECTOR	0xfa
 
 #define THERMAL_APIC_VECTOR	0xf0
 /*
diff -puN include/asm-x86/mach-voyager/entry_arch.h~revert-git-block include/asm-x86/mach-voyager/entry_arch.h
--- a/include/asm-x86/mach-voyager/entry_arch.h~revert-git-block
+++ a/include/asm-x86/mach-voyager/entry_arch.h
@@ -23,4 +23,4 @@ BUILD_INTERRUPT(qic_invalidate_interrupt
 BUILD_INTERRUPT(qic_reschedule_interrupt, QIC_RESCHEDULE_CPI);
 BUILD_INTERRUPT(qic_enable_irq_interrupt, QIC_ENABLE_IRQ_CPI);
 BUILD_INTERRUPT(qic_call_function_interrupt, QIC_CALL_FUNCTION_CPI);
-BUILD_INTERRUPT(qic_call_function_single_interrupt, QIC_CALL_FUNCTION_SINGLE_CPI);
+
diff -puN include/asm-x86/mach-voyager/irq_vectors.h~revert-git-block include/asm-x86/mach-voyager/irq_vectors.h
--- a/include/asm-x86/mach-voyager/irq_vectors.h~revert-git-block
+++ a/include/asm-x86/mach-voyager/irq_vectors.h
@@ -33,7 +33,6 @@
 #define VIC_RESCHEDULE_CPI		4
 #define VIC_ENABLE_IRQ_CPI		5
 #define VIC_CALL_FUNCTION_CPI		6
-#define VIC_CALL_FUNCTION_SINGLE_CPI	7
 
 /* Now the QIC CPIs:  Since we don't need the two initial levels,
  * these are 2 less than the VIC CPIs */
@@ -43,10 +42,9 @@
 #define QIC_RESCHEDULE_CPI		(VIC_RESCHEDULE_CPI - QIC_CPI_OFFSET)
 #define QIC_ENABLE_IRQ_CPI		(VIC_ENABLE_IRQ_CPI - QIC_CPI_OFFSET)
 #define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_CPI - QIC_CPI_OFFSET)
-#define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_SINGLE_CPI - QIC_CPI_OFFSET)
 
 #define VIC_START_FAKE_CPI		VIC_TIMER_CPI
-#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_SINGLE_CPI
+#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_CPI
 
 /* this is the SYS_INT CPI. */
 #define VIC_SYS_INT			8
diff -puN include/asm-x86/smp.h~revert-git-block include/asm-x86/smp.h
--- a/include/asm-x86/smp.h~revert-git-block
+++ a/include/asm-x86/smp.h
@@ -59,9 +59,9 @@ struct smp_ops {
 
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
-
-	void (*send_call_func_ipi)(cpumask_t mask);
-	void (*send_call_func_single_ipi)(int cpu);
+	int (*smp_call_function_mask)(cpumask_t mask,
+				      void (*func)(void *info), void *info,
+				      int wait);
 };
 
 /* Globals due to paravirt */
@@ -103,22 +103,17 @@ static inline void smp_send_reschedule(i
 	smp_ops.smp_send_reschedule(cpu);
 }
 
-static inline void arch_send_call_function_single_ipi(int cpu)
-{
-	smp_ops.send_call_func_single_ipi(cpu);
-}
-
-static inline void arch_send_call_function_ipi(cpumask_t mask)
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info), void *info,
+					 int wait)
 {
-	smp_ops.send_call_func_ipi(mask);
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
 }
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
-void native_send_call_func_ipi(cpumask_t mask);
-void native_send_call_func_single_ipi(int cpu);
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
diff -puN include/linux/bio.h~revert-git-block include/linux/bio.h
--- a/include/linux/bio.h~revert-git-block
+++ a/include/linux/bio.h
@@ -127,7 +127,6 @@ struct bio {
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
-#define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
diff -puN include/linux/blkdev.h~revert-git-block include/linux/blkdev.h
--- a/include/linux/blkdev.h~revert-git-block
+++ a/include/linux/blkdev.h
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include <linux/bsg.h>
-#include <linux/smp.h>
 
 #include <asm/scatterlist.h>
 
@@ -146,8 +145,7 @@ enum rq_flag_bits {
  */
 struct request {
 	struct list_head queuelist;
-	struct call_single_data csd;
-	int cpu;
+	struct list_head donelist;
 
 	struct request_queue *q;
 
@@ -300,11 +298,8 @@ struct request_queue
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
-	dma_drain_needed_fn	*dma_drain_needed;
-
 	softirq_done_fn		*softirq_done_fn;
-	cpumask_t		queue_cpu;
-	cpumask_t		complete_cpu;
+	dma_drain_needed_fn	*dma_drain_needed;
 
 	/*
 	 * Dispatch queue sorting
@@ -414,7 +409,6 @@ struct request_queue
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
-#define QUEUE_FLAG_SAME_COMP   11	/* force complete on same CPU */
 
 static inline int queue_is_locked(struct request_queue *q)
 {
@@ -761,8 +755,6 @@ extern void blk_queue_segment_boundary(s
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
-extern int blk_queue_set_queue_cpu(struct request_queue *, cpumask_t);
-extern int blk_queue_set_completion_cpu(struct request_queue *, cpumask_t);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
@@ -864,7 +856,7 @@ static inline void put_dev_sector(Sector
 }
 
 struct work_struct;
-int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
+int kblockd_schedule_work(struct work_struct *work);
 void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
diff -puN include/linux/elevator.h~revert-git-block include/linux/elevator.h
--- a/include/linux/elevator.h~revert-git-block
+++ a/include/linux/elevator.h
@@ -173,15 +173,15 @@ enum {
 #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
 
 /*
- * Hack to reuse the csd.list list_head as the fifo time holder while
+ * Hack to reuse the donelist list_head as the fifo time holder while
  * the request is in the io scheduler. Saves an unsigned long in rq.
  */
-#define rq_fifo_time(rq)	((unsigned long) (rq)->csd.list.next)
-#define rq_set_fifo_time(rq,exp)	((rq)->csd.list.next = (void *) (exp))
+#define rq_fifo_time(rq)	((unsigned long) (rq)->donelist.next)
+#define rq_set_fifo_time(rq,exp)	((rq)->donelist.next = (void *) (exp))
 #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
 #define rq_fifo_clear(rq)	do {		\
 	list_del_init(&(rq)->queuelist);	\
-	INIT_LIST_HEAD(&(rq)->csd.list);	\
+	INIT_LIST_HEAD(&(rq)->donelist);	\
 	} while (0)
 
 /*
diff -puN include/linux/fs.h~revert-git-block include/linux/fs.h
--- a/include/linux/fs.h~revert-git-block
+++ a/include/linux/fs.h
@@ -1818,6 +1818,7 @@ extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
+extern int __remove_suid(struct dentry *, int);
 extern int should_remove_suid(struct dentry *);
 extern int remove_suid(struct dentry *);
 
diff -puN include/linux/genhd.h~revert-git-block include/linux/genhd.h
--- a/include/linux/genhd.h~revert-git-block
+++ a/include/linux/genhd.h
@@ -178,17 +178,17 @@ static inline struct hd_struct *get_part
 
 static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
 	int i;
-
 	for_each_possible_cpu(i)
 		memset(per_cpu_ptr(gendiskp->dkstats, i), value,
-				sizeof(struct disk_stats));
+				sizeof (struct disk_stats));
 }		
 
 #define __part_stat_add(part, field, addnd)				\
 	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
 
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
+#define __all_stat_add(gendiskp, field, addnd, sector)		\
 ({								\
+	struct hd_struct *part = get_part(gendiskp, sector);	\
 	if (part)						\
 		__part_stat_add(part, field, addnd);		\
 	__disk_stat_add(gendiskp, field, addnd);		\
@@ -203,13 +203,11 @@ static inline void disk_stat_set_all(str
 	res;								\
 })
 
-static inline void part_stat_set_all(struct hd_struct *part, int value)
-{
+static inline void part_stat_set_all(struct hd_struct *part, int value)	{
 	int i;
-
 	for_each_possible_cpu(i)
 		memset(per_cpu_ptr(part->dkstats, i), value,
-				sizeof(struct disk_stats));
+		       sizeof(struct disk_stats));
 }
 				
 #else /* !CONFIG_SMP */
@@ -225,8 +223,9 @@ static inline void disk_stat_set_all(str
 #define __part_stat_add(part, field, addnd) \
 	(part->dkstats.field += addnd)
 
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
+#define __all_stat_add(gendiskp, field, addnd, sector)		\
 ({								\
+	struct hd_struct *part = get_part(gendiskp, sector);	\
 	if (part)						\
 		part->dkstats.field += addnd;			\
 	__disk_stat_add(gendiskp, field, addnd);		\
@@ -277,10 +276,10 @@ static inline void part_stat_set_all(str
 #define part_stat_sub(gendiskp, field, subnd) \
 		part_stat_add(gendiskp, field, -subnd)
 
-#define all_stat_add(gendiskp, part, field, addnd, sector)	\
+#define all_stat_add(gendiskp, field, addnd, sector)		\
 	do {							\
 		preempt_disable();				\
-		__all_stat_add(gendiskp, part, field, addnd, sector);	\
+		__all_stat_add(gendiskp, field, addnd, sector);	\
 		preempt_enable();				\
 	} while (0)
 
@@ -289,15 +288,15 @@ static inline void part_stat_set_all(str
 #define all_stat_dec(gendiskp, field, sector) \
 		all_stat_add(gendiskp, field, -1, sector)
 
-#define __all_stat_inc(gendiskp, part, field, sector) \
-		__all_stat_add(gendiskp, part, field, 1, sector)
-#define all_stat_inc(gendiskp, part, field, sector) \
-		all_stat_add(gendiskp, part, field, 1, sector)
-
-#define __all_stat_sub(gendiskp, part, field, subnd, sector) \
-		__all_stat_add(gendiskp, part, field, -subnd, sector)
-#define all_stat_sub(gendiskp, part, field, subnd, sector) \
-		all_stat_add(gendiskp, part, field, -subnd, sector)
+#define __all_stat_inc(gendiskp, field, sector) \
+		__all_stat_add(gendiskp, field, 1, sector)
+#define all_stat_inc(gendiskp, field, sector) \
+		all_stat_add(gendiskp, field, 1, sector)
+
+#define __all_stat_sub(gendiskp, field, subnd, sector) \
+		__all_stat_add(gendiskp, field, -subnd, sector)
+#define all_stat_sub(gendiskp, field, subnd, sector) \
+		all_stat_add(gendiskp, field, -subnd, sector)
 
 /* Inlines to alloc and free disk stats in struct gendisk */
 #ifdef  CONFIG_SMP
diff -puN include/linux/iocontext.h~revert-git-block include/linux/iocontext.h
--- a/include/linux/iocontext.h~revert-git-block
+++ a/include/linux/iocontext.h
@@ -30,11 +30,12 @@ struct as_io_context {
 	sector_t seek_mean;
 };
 
+struct cfq_queue;
 struct cfq_io_context {
 	void *key;
 	unsigned long dead_key;
 
-	void *cfqq[2];
+	struct cfq_queue *cfqq[2];
 
 	struct io_context *ioc;
 
@@ -81,7 +82,6 @@ struct io_context {
 	struct as_io_context *aic;
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
-	struct hlist_head bfq_cic_list;
 	void *ioc_data;
 };
 
diff -puN include/linux/ioprio.h~revert-git-block include/linux/ioprio.h
--- a/include/linux/ioprio.h~revert-git-block
+++ a/include/linux/ioprio.h
@@ -68,20 +68,6 @@ static inline int task_nice_ioprio(struc
 }
 
 /*
- * This is for the case where the task hasn't asked for a specific IO class.
- * Check for idle and rt task process, and return appropriate IO class.
- */
-static inline int task_nice_ioclass(struct task_struct *task)
-{
-	if (task->policy == SCHED_IDLE)
-		return IOPRIO_CLASS_IDLE;
-	else if (task->policy == SCHED_FIFO || task->policy == SCHED_RR)
-		return IOPRIO_CLASS_RT;
-	else
-		return IOPRIO_CLASS_BE;
-}
-
-/*
  * For inheritance, return the highest of the two given priorities
  */
 extern int ioprio_best(unsigned short aprio, unsigned short bprio);
diff -puN include/linux/smp.h~revert-git-block include/linux/smp.h
--- a/include/linux/smp.h~revert-git-block
+++ a/include/linux/smp.h
@@ -7,19 +7,9 @@
  */
 
 #include <linux/errno.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/cpumask.h>
 
 extern void cpu_idle(void);
 
-struct call_single_data {
-	struct list_head list;
-	void (*func) (void *info);
-	void *info;
-	unsigned int flags;
-};
-
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -63,27 +53,9 @@ extern void smp_cpus_done(unsigned int m
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
-int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
-				int wait);
+
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int retry, int wait);
-void __smp_call_function_single(int cpuid, struct call_single_data *data);
-
-/*
- * Generic and arch helpers
- */
-#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
-void generic_smp_call_function_single_interrupt(void);
-void generic_smp_call_function_interrupt(void);
-void init_call_single_data(void);
-void arch_send_call_function_single_ipi(int cpu);
-void arch_send_call_function_ipi(cpumask_t mask);
-extern spinlock_t call_function_lock;
-#else
-static inline void init_call_single_data(void)
-{
-}
-#endif
 
 /*
  * Call a function on all processors
@@ -140,6 +112,7 @@ static inline void smp_send_reschedule(i
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
+
 #endif /* !SMP */
 
 /*
diff -puN include/linux/workqueue.h~revert-git-block include/linux/workqueue.h
--- a/include/linux/workqueue.h~revert-git-block
+++ a/include/linux/workqueue.h
@@ -181,8 +181,6 @@ extern void destroy_workqueue(struct wor
 extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
 extern int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
-extern int queue_work_on_cpu(struct workqueue_struct *wq,
-			struct work_struct *work, int cpu);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 
diff -puN init/main.c~revert-git-block init/main.c
--- a/init/main.c~revert-git-block
+++ a/init/main.c
@@ -777,7 +777,6 @@ static void __init do_pre_smp_initcalls(
 {
 	extern int spawn_ksoftirqd(void);
 
-	init_call_single_data();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff -puN kernel/Makefile~revert-git-block kernel/Makefile
--- a/kernel/Makefile~revert-git-block
+++ a/kernel/Makefile
@@ -35,7 +35,6 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += cpu.o spinlock.o
-obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
diff -puN kernel/smp.c~revert-git-block /dev/null
--- a/kernel/smp.c
+++ /dev/null
@@ -1,362 +0,0 @@
-/*
- * Generic helpers for smp ipi calls
- *
- * (C) Jens Axboe <jens.axboe@oracle.com> 2008
- *
- */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/percpu.h>
-#include <linux/rcupdate.h>
-#include <linux/smp.h>
-
-static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-static LIST_HEAD(call_function_queue);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
-
-enum {
-	CSD_FLAG_WAIT		= 0x01,
-	CSD_FLAG_ALLOC		= 0x02,
-};
-
-struct call_function_data {
-	struct call_single_data csd;
-	spinlock_t lock;
-	unsigned int refs;
-	cpumask_t cpumask;
-	struct rcu_head rcu_head;
-};
-
-struct call_single_queue {
-	struct list_head list;
-	spinlock_t lock;
-};
-
-void __cpuinit init_call_single_data(void)
-{
-	int i;
-
-	for_each_possible_cpu(i) {
-		struct call_single_queue *q = &per_cpu(call_single_queue, i);
-
-		spin_lock_init(&q->lock);
-		INIT_LIST_HEAD(&q->list);
-	}
-}
-
-static void csd_flag_wait(struct call_single_data *data)
-{
-	/* Wait for response */
-	do {
-		/*
-		 * We need to see the flags store in the IPI handler
-		 */
-		smp_mb();
-		if (!(data->flags & CSD_FLAG_WAIT))
-			break;
-		cpu_relax();
-	} while (1);
-}
-
-/*
- * Insert a previously allocated call_single_data element for execution
- * on the given CPU. data must already have ->func, ->info, and ->flags set.
- */
-static void generic_exec_single(int cpu, struct call_single_data *data)
-{
-	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
-	int wait = data->flags & CSD_FLAG_WAIT, ipi;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dst->lock, flags);
-	ipi = list_empty(&dst->list);
-	list_add_tail(&data->list, &dst->list);
-	spin_unlock_irqrestore(&dst->lock, flags);
-
-	if (ipi)
-		arch_send_call_function_single_ipi(cpu);
-
-	if (wait)
-		csd_flag_wait(data);
-}
-
-static void rcu_free_call_data(struct rcu_head *head)
-{
-	struct call_function_data *data;
-
-	data = container_of(head, struct call_function_data, rcu_head);
-
-	kfree(data);
-}
-
-/*
- * Invoked by arch to handle an IPI for call function. Must be called with
- * interrupts disabled.
- */
-void generic_smp_call_function_interrupt(void)
-{
-	struct call_function_data *data;
-	int cpu = get_cpu();
-
-	/*
-	 * It's ok to use list_for_each_rcu() here even though we may delete
-	 * 'pos', since list_del_rcu() doesn't clear ->next
-	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
-		int refs;
-
-		if (!cpu_isset(cpu, data->cpumask))
-			continue;
-
-		data->csd.func(data->csd.info);
-
-		spin_lock(&data->lock);
-		cpu_clear(cpu, data->cpumask);
-		WARN_ON(data->refs == 0);
-		data->refs--;
-		refs = data->refs;
-		spin_unlock(&data->lock);
-
-		if (refs)
-			continue;
-
-		spin_lock(&call_function_lock);
-		list_del_rcu(&data->csd.list);
-		spin_unlock(&call_function_lock);
-
-		if (data->csd.flags & CSD_FLAG_WAIT) {
-			/*
-			 * serialize stores to data with the flag clear
-			 * and wakeup
-			 */
-			smp_wmb();
-			data->csd.flags &= ~CSD_FLAG_WAIT;
-		} else
-			call_rcu(&data->rcu_head, rcu_free_call_data);
-	}
-	rcu_read_unlock();
-
-	put_cpu();
-}
-
-/*
- * Invoked by arch to handle an IPI for call function single. Must be called
- * from the arch with interrupts disabled.
- */
-void generic_smp_call_function_single_interrupt(void)
-{
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
-	LIST_HEAD(list);
-
-	/*
-	 * Need to see other stores to list head for checking whether
-	 * list is empty without holding q->lock
-	 */
-	smp_mb();
-	while (!list_empty(&q->list)) {
-		unsigned int data_flags;
-
-		spin_lock(&q->lock);
-		list_replace_init(&q->list, &list);
-		spin_unlock(&q->lock);
-
-		while (!list_empty(&list)) {
-			struct call_single_data *data;
-
-			data = list_entry(list.next, struct call_single_data,
-						list);
-			list_del(&data->list);
-
-			/*
-			 * 'data' can be invalid after this call if
-			 * flags == 0 (when called through
-			 * generic_exec_single(), so save them away before
-			 * making the call.
-			 */
-			data_flags = data->flags;
-
-			data->func(data->info);
-
-			if (data_flags & CSD_FLAG_WAIT) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_WAIT;
-			} else if (data_flags & CSD_FLAG_ALLOC)
-				kfree(data);
-		}
-		/*
-		 * See comment on outer loop
-		 */
-		smp_mb();
-	}
-}
-
-/*
- * smp_call_function_single - Run a function on a specific CPU
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @retry: Unused
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int retry, int wait)
-{
-	struct call_single_data d;
-	unsigned long flags;
-	/* prevent preemption and reschedule on another processor */
-	int me = get_cpu();
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	if (cpu == me) {
-		local_irq_save(flags);
-		func(info);
-		local_irq_restore(flags);
-	} else {
-		struct call_single_data *data = NULL;
-
-		if (!wait) {
-			data = kmalloc(sizeof(*data), GFP_ATOMIC);
-			if (data)
-				data->flags = CSD_FLAG_ALLOC;
-		}
-		if (!data) {
-			data = &d;
-			data->flags = CSD_FLAG_WAIT;
-		}
-
-		data->func = func;
-		data->info = info;
-		generic_exec_single(cpu, data);
-	}
-
-	put_cpu();
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
-/**
- * __smp_call_function_single(): Run a function on another CPU
- * @cpu: The CPU to run on.
- * @data: Pre-allocated and setup data structure
- *
- * Like smp_call_function_single(), but allow caller to pass in a pre-allocated
- * data structure. Useful for embedding @data inside other structures, for
- * instance.
- *
- */
-void __smp_call_function_single(int cpu, struct call_single_data *data)
-{
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
-
-	generic_exec_single(cpu, data);
-}
-
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * @mask: The set of cpus to run on.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
-			   int wait)
-{
-	struct call_function_data d;
-	struct call_function_data *data = NULL;
-	cpumask_t allbutself;
-	unsigned long flags;
-	int cpu, num_cpus;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	cpu = smp_processor_id();
-	allbutself = cpu_online_map;
-	cpu_clear(cpu, allbutself);
-	cpus_and(mask, mask, allbutself);
-	num_cpus = cpus_weight(mask);
-
-	/*
-	 * If zero CPUs, return. If just a single CPU, turn this request
-	 * into a targetted single call instead since it's faster.
-	 */
-	if (!num_cpus)
-		return 0;
-	else if (num_cpus == 1) {
-		cpu = first_cpu(mask);
-		return smp_call_function_single(cpu, func, info, 0, wait);
-	}
-
-	if (!wait) {
-		data = kmalloc(sizeof(*data), GFP_ATOMIC);
-		if (data)
-			data->csd.flags = CSD_FLAG_ALLOC;
-	}
-	if (!data) {
-		data = &d;
-		data->csd.flags = CSD_FLAG_WAIT;
-	}
-
-	spin_lock_init(&data->lock);
-	data->csd.func = func;
-	data->csd.info = info;
-	data->refs = num_cpus;
-
-	/*
-	 * need to see above stores before the cpumask is valid for the CPU
-	 */
-	smp_wmb();
-	data->cpumask = mask;
-
-	spin_lock_irqsave(&call_function_lock, flags);
-	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-	spin_unlock_irqrestore(&call_function_lock, flags);
-
-	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi(mask);
-
-	/* optionally wait for the CPUs to complete */
-	if (wait)
-		csd_flag_wait(&data->csd);
-
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function_mask);
-
-/**
- * smp_call_function(): Run a function on all other CPUs.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @natomic: Unused
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function(void (*func)(void *), void *info, int natomic, int wait)
-{
-	int ret;
-
-	preempt_disable();
-	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
-	preempt_enable();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function);
diff -puN kernel/workqueue.c~revert-git-block kernel/workqueue.c
--- a/kernel/workqueue.c~revert-git-block
+++ a/kernel/workqueue.c
@@ -155,41 +155,22 @@ static void __queue_work(struct cpu_work
  * queue_work - queue work on a workqueue
  * @wq: workqueue to use
  * @work: work to queue
- * @cpu: cpu to queue the work on
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to the CPU on which it was submitted, but if the CPU dies
+ * it can be processed by another CPU.
  */
-int queue_work_on_cpu(struct workqueue_struct *wq, struct work_struct *work,
-		      int cpu)
+int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, cpu), work);
+		__queue_work(wq_per_cpu(wq, get_cpu()), work);
+		put_cpu();
 		ret = 1;
 	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(queue_work_on_cpu);
-
-/**
- * queue_work - queue work on a workqueue
- * @wq: workqueue to use
- * @work: work to queue
- *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
- *
- * We queue the work to the CPU it was submitted, but there is no
- * guarantee that it will be processed by that CPU.
- */
-int queue_work(struct workqueue_struct *wq, struct work_struct *work)
-{
-	int ret;
-
-	ret = queue_work_on_cpu(wq, work, get_cpu());
-	put_cpu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
diff -puN mm/filemap.c~revert-git-block mm/filemap.c
--- a/mm/filemap.c~revert-git-block
+++ a/mm/filemap.c
@@ -1655,7 +1655,7 @@ int should_remove_suid(struct dentry *de
 }
 EXPORT_SYMBOL(should_remove_suid);
 
-static int __remove_suid(struct dentry *dentry, int kill)
+int __remove_suid(struct dentry *dentry, int kill)
 {
 	struct iattr newattrs;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
fix-hfsplus-oops-on-image-without-extents-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-kernel-setupc-printk-warning-fix.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
git-mmc.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
revert-git-block.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
logfs-unbork.patch
logfs-is-busted.patch
drivers-usb-core-sysfsc-fix-types.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
git-v9fs.patch
revert-git-v9fs.patch
git-vfs-cleanups-unbork.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
mm-define-default-cpu_to_node-checkpatch-fixes.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

