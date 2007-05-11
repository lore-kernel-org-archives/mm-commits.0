From: akpm@linux-foundation.org
Subject: + i386-move-common-parts-of-smp-into-their-own-file.patch added to -mm tree
Date: Fri, 11 May 2007 12:22:11 -0700
Message-ID: <200705111922.l4BJMBFk024385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965714AbXEKTXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, James.Bottomley@HansenPartnership.com, chrisw@sous-sol.org, ebiederm@xmission.com, jeremy@xensource.com


The patch titled
     i386: move common parts of smp into their own file
has been added to the -mm tree.  Its filename is
     i386-move-common-parts-of-smp-into-their-own-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: move common parts of smp into their own file
From: Jeremy Fitzhardinge <jeremy@goop.org>

Several parts of kernel/smp.c and smpboot.c are generally useful for other
subarchitectures and paravirt_ops implementations, so make them available for
reuse.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile    |    1 
 arch/i386/kernel/smp.c       |   65 ++-------------------------
 arch/i386/kernel/smpboot.c   |   22 ---------
 arch/i386/kernel/smpcommon.c |   79 +++++++++++++++++++++++++++++++++
 include/asm-i386/processor.h |    4 +
 5 files changed, 90 insertions(+), 81 deletions(-)

diff -puN arch/i386/kernel/Makefile~i386-move-common-parts-of-smp-into-their-own-file arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~i386-move-common-parts-of-smp-into-their-own-file
+++ a/arch/i386/kernel/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
diff -puN arch/i386/kernel/smp.c~i386-move-common-parts-of-smp-into-their-own-file arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~i386-move-common-parts-of-smp-into-their-own-file
+++ a/arch/i386/kernel/smp.c
@@ -467,7 +467,7 @@ void flush_tlb_all(void)
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
  */
-void native_smp_send_reschedule(int cpu)
+static void native_smp_send_reschedule(int cpu)
 {
 	WARN_ON(cpu_is_offline(cpu));
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
@@ -546,9 +546,10 @@ static void __smp_call_function(void (*f
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int native_smp_call_function_mask(cpumask_t mask,
-				  void (*func)(void *), void *info,
-				  int wait)
+static int
+native_smp_call_function_mask(cpumask_t mask,
+			      void (*func)(void *), void *info,
+			      int wait)
 {
 	struct call_data_struct data;
 	cpumask_t allbutself;
@@ -599,60 +600,6 @@ int native_smp_call_function_mask(cpumas
 	return 0;
 }
 
-/**
- * smp_call_function(): Run a function on all other CPUs.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
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
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
-{
-	return smp_call_function_mask(cpu_online_map, func, info, wait);
-}
-EXPORT_SYMBOL(smp_call_function);
-
-/**
- * smp_call_function_single - Run a function on another CPU
- * @cpu: The target CPU.  Cannot be the calling CPU.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
-{
-	/* prevent preemption and reschedule on another processor */
-	int ret;
-	int me = get_cpu();
-	if (cpu == me) {
-		WARN_ON(1);
-		put_cpu();
-		return -EBUSY;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
-
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
 static void stop_this_cpu (void * dummy)
 {
 	local_irq_disable();
@@ -670,7 +617,7 @@ static void stop_this_cpu (void * dummy)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
-void native_smp_send_stop(void)
+static void native_smp_send_stop(void)
 {
 	/* Don't deadlock on the call lock in panic */
 	int nolock = !spin_trylock(&call_lock);
diff -puN arch/i386/kernel/smpboot.c~i386-move-common-parts-of-smp-into-their-own-file arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-move-common-parts-of-smp-into-their-own-file
+++ a/arch/i386/kernel/smpboot.c
@@ -98,9 +98,6 @@ EXPORT_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off);
-EXPORT_PER_CPU_SYMBOL(this_cpu_off);
-
 /*
  * Trampoline 80x86 program as an array.
  */
@@ -763,25 +760,6 @@ static inline struct task_struct * alloc
 #define alloc_idle_task(cpu) fork_idle(cpu)
 #endif
 
-/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
-   (still using the master per-cpu area), or a CPU doing it for a
-   secondary which will soon come up. */
-static __cpuinit void init_gdt(int cpu)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
-			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
-			__per_cpu_offset[cpu], 0xFFFFF,
-			0x80 | DESCTYPE_S | 0x2, 0x8);
-
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
-	per_cpu(cpu_number, cpu) = cpu;
-}
-
-/* Defined in head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
diff -puN /dev/null arch/i386/kernel/smpcommon.c
--- /dev/null
+++ a/arch/i386/kernel/smpcommon.c
@@ -0,0 +1,79 @@
+/*
+ * SMP stuff which is common to all sub-architectures.
+ */
+#include <linux/module.h>
+#include <asm/smp.h>
+
+DEFINE_PER_CPU(unsigned long, this_cpu_off);
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
+
+/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
+   (still using the master per-cpu area), or a CPU doing it for a
+   secondary which will soon come up. */
+__cpuinit void init_gdt(int cpu)
+{
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
+			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+			__per_cpu_offset[cpu], 0xFFFFF,
+			0x80 | DESCTYPE_S | 0x2, 0x8);
+
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
+}
+
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
+ * smp_call_function_single - Run a function on another CPU
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
+		WARN_ON(1);
+		put_cpu();
+		return -EBUSY;
+	}
+
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
diff -puN include/asm-i386/processor.h~i386-move-common-parts-of-smp-into-their-own-file include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-move-common-parts-of-smp-into-their-own-file
+++ a/include/asm-i386/processor.h
@@ -749,9 +749,13 @@ extern unsigned long boot_option_idle_ov
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
+/* Defined in head.S */
+extern struct Xgt_desc_struct early_gdt_descr;
+
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
 extern void cpu_init(void);
+extern void init_gdt(int cpu);
 
 extern int force_mwait;
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
loop_probe-fix-return-value.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
use-elfnoteh-to-generate-vsyscall-notes.patch
add-kstrndup.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
lguest-the-guest-code.patch
