From: akpm@linux-foundation.org
Subject: - i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:10 -0700
Message-ID: <200703292339.l2TNdArT015410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945939AbXC2XjS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 GDT cleanups: Use per-cpu variables for GDT, PDA
has been removed from the -mm tree.  Its filename was
     i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 GDT cleanups: Use per-cpu variables for GDT, PDA
From: Rusty Russell <rusty@rustcorp.com.au>

Allocating PDA and GDT at boot is a pain.  Using simple per-cpu variables adds
happiness (although we need the GDT page-aligned for Xen, which we do in a
followup patch).

[akpm@linux-foundation.org: build fix]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c        |   94 +++----------------------
 arch/i386/kernel/smpboot.c           |   21 -----
 arch/i386/mach-voyager/voyager_smp.c |   10 --
 include/asm-generic/percpu.h         |    1 
 include/asm-i386/desc.h              |    1 
 include/asm-i386/pda.h               |    7 -
 include/asm-i386/processor.h         |    2 
 7 files changed, 21 insertions(+), 115 deletions(-)

diff -puN arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/arch/i386/kernel/cpu/common.c
@@ -25,8 +25,10 @@
 DEFINE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
 EXPORT_PER_CPU_SYMBOL(cpu_gdt_descr);
 
-struct i386_pda *_cpu_pda[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
+DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
+
+DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
+EXPORT_PER_CPU_SYMBOL(_cpu_pda);
 
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_fxsr __cpuinitdata;
@@ -609,52 +611,6 @@ struct pt_regs * __devinit idle_regs(str
 	return regs;
 }
 
-static __cpuinit int alloc_gdt(int cpu)
-{
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt;
-	struct i386_pda *pda;
-
-	gdt = (struct desc_struct *)cpu_gdt_descr->address;
-	pda = cpu_pda(cpu);
-
-	/*
-	 * This is a horrible hack to allocate the GDT.  The problem
-	 * is that cpu_init() is called really early for the boot CPU
-	 * (and hence needs bootmem) but much later for the secondary
-	 * CPUs, when bootmem will have gone away
-	 */
-	if (NODE_DATA(0)->bdata->node_bootmem_map) {
-		BUG_ON(gdt != NULL || pda != NULL);
-
-		gdt = alloc_bootmem_pages(PAGE_SIZE);
-		pda = alloc_bootmem(sizeof(*pda));
-		/* alloc_bootmem(_pages) panics on failure, so no check */
-
-		memset(gdt, 0, PAGE_SIZE);
-		memset(pda, 0, sizeof(*pda));
-	} else {
-		/* GDT and PDA might already have been allocated if
-		   this is a CPU hotplug re-insertion. */
-		if (gdt == NULL)
-			gdt = (struct desc_struct *)get_zeroed_page(GFP_KERNEL);
-
-		if (pda == NULL)
-			pda = kmalloc_node(sizeof(*pda), GFP_KERNEL, cpu_to_node(cpu));
-
-		if (unlikely(!gdt || !pda)) {
-			free_pages((unsigned long)gdt, 0);
-			kfree(pda);
-			return 0;
-		}
-	}
-
- 	cpu_gdt_descr->address = (unsigned long)gdt;
-	cpu_pda(cpu) = pda;
-
-	return 1;
-}
-
 /* Initial PDA used by boot CPU */
 struct i386_pda boot_pda = {
 	._pda = &boot_pda,
@@ -670,31 +626,17 @@ static inline void set_kernel_fs(void)
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
 }
 
-/* Initialize the CPU's GDT and PDA.  The boot CPU does this for
-   itself, but secondaries find this done for them. */
-__cpuinit int init_gdt(int cpu, struct task_struct *idle)
+/* Initialize the CPU's GDT and PDA.  This is either the boot CPU doing itself
+   (still using cpu_gdt_table), or a CPU doing it for a secondary which
+   will soon come up. */
+__cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
 	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt;
-	struct i386_pda *pda;
-
-	/* For non-boot CPUs, the GDT and PDA should already have been
-	   allocated. */
-	if (!alloc_gdt(cpu)) {
-		printk(KERN_CRIT "CPU%d failed to allocate GDT or PDA\n", cpu);
-		return 0;
-	}
-
-	gdt = (struct desc_struct *)cpu_gdt_descr->address;
-	pda = cpu_pda(cpu);
-
-	BUG_ON(gdt == NULL || pda == NULL);
+	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
+	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
 
-	/*
-	 * Initialize the per-CPU GDT with the boot GDT,
-	 * and set up the GDT descriptor:
-	 */
  	memcpy(gdt, cpu_gdt_table, GDT_SIZE);
+ 	cpu_gdt_descr->address = (unsigned long)gdt;
 	cpu_gdt_descr->size = GDT_SIZE - 1;
 
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
@@ -706,17 +648,12 @@ __cpuinit int init_gdt(int cpu, struct t
 	pda->_pda = pda;
 	pda->cpu_number = cpu;
 	pda->pcurrent = idle;
-
-	return 1;
 }
 
 void __cpuinit cpu_set_gdt(int cpu)
 {
 	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
 
-	/* Reinit these anyway, even if they've already been done (on
-	   the boot CPU, this will transition from the boot gdt+pda to
-	   the real ones). */
 	load_gdt(cpu_gdt_descr);
 	set_kernel_fs();
 }
@@ -804,13 +741,8 @@ void __cpuinit cpu_init(void)
 	struct task_struct *curr = current;
 
 	/* Set up the real GDT and PDA, so we can transition from the
-	   boot versions. */
-	if (!init_gdt(cpu, curr)) {
-		/* failed to allocate something; not much we can do... */
-		for (;;)
-			local_irq_enable();
-	}
-
+	   boot_gdt_table & boot_pda. */
+	init_gdt(cpu, curr);
 	cpu_set_gdt(cpu);
 	_cpu_init(cpu, curr);
 }
diff -puN arch/i386/kernel/smpboot.c~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/arch/i386/kernel/smpboot.c
@@ -808,13 +808,7 @@ static int __cpuinit do_boot_cpu(int api
 	if (IS_ERR(idle))
 		panic("failed fork for CPU %d", cpu);
 
-	/* Pre-allocate and initialize the CPU's GDT and PDA so it
-	   doesn't have to do any memory allocation during the
-	   delicate CPU-bringup phase. */
-	if (!init_gdt(cpu, idle)) {
-		printk(KERN_INFO "Couldn't allocate GDT/PDA for CPU %d\n", cpu);
-		return -1;	/* ? */
-	}
+	init_gdt(cpu, idle);
 
 	idle->thread.eip = (unsigned long) start_secondary;
 	/* start_eip had better be page-aligned! */
@@ -940,7 +934,6 @@ static int __cpuinit __smp_prepare_cpu(i
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct warm_boot_cpu_info info;
 	int	apicid, ret;
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
 
 	apicid = x86_cpu_to_apicid[cpu];
 	if (apicid == BAD_APICID) {
@@ -948,18 +941,6 @@ static int __cpuinit __smp_prepare_cpu(i
 		goto exit;
 	}
 
-	/*
-	 * the CPU isn't initialized at boot time, allocate gdt table here.
-	 * cpu_init will initialize it
-	 */
-	if (!cpu_gdt_descr->address) {
-		cpu_gdt_descr->address = get_zeroed_page(GFP_KERNEL);
-		if (!cpu_gdt_descr->address)
-			printk(KERN_CRIT "CPU%d failed to allocate GDT\n", cpu);
-			ret = -ENOMEM;
-			goto exit;
-	}
-
 	info.complete = &done;
 	info.apicid = apicid;
 	info.cpu = cpu;
diff -puN arch/i386/mach-voyager/voyager_smp.c~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -580,15 +580,7 @@ do_boot_cpu(__u8 cpu)
 	/* init_tasks (in sched.c) is indexed logically */
 	stack_start.esp = (void *) idle->thread.esp;
 
-	/* Pre-allocate and initialize the CPU's GDT and PDA so it
-	   doesn't have to do any memory allocation during the
-	   delicate CPU-bringup phase. */
-	if (!init_gdt(cpu, idle)) {
-		printk(KERN_INFO "Couldn't allocate GDT/PDA for CPU %d\n", cpu);
-		cpucount--;
-		return;
-	}
-
+	init_gdt(cpu, idle);
 	irq_ctx_init(cpu);
 
 	/* Note: Don't modify initial ss override */
diff -puN include/asm-generic/percpu.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/include/asm-generic/percpu.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_GENERIC_PERCPU_H_
 #define _ASM_GENERIC_PERCPU_H_
 #include <linux/compiler.h>
+#include <linux/threads.h>
 
 #define __GENERIC_PER_CPU
 #ifdef CONFIG_SMP
diff -puN include/asm-i386/desc.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda include/asm-i386/desc.h
--- a/include/asm-i386/desc.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/include/asm-i386/desc.h
@@ -22,6 +22,7 @@ struct Xgt_desc_struct {
 
 extern struct Xgt_desc_struct idt_descr;
 DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
+DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
 extern struct Xgt_desc_struct early_gdt_descr;
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
diff -puN include/asm-i386/pda.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda include/asm-i386/pda.h
--- a/include/asm-i386/pda.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/include/asm-i386/pda.h
@@ -8,6 +8,7 @@
 
 #include <linux/stddef.h>
 #include <linux/types.h>
+#include <asm/percpu.h>
 
 struct i386_pda
 {
@@ -18,10 +19,8 @@ struct i386_pda
 	struct pt_regs *irq_regs;
 };
 
-extern struct i386_pda *_cpu_pda[];
-
-#define cpu_pda(i)	(_cpu_pda[i])
-
+DECLARE_PER_CPU(struct i386_pda, _cpu_pda);
+#define cpu_pda(i)	(&per_cpu(_cpu_pda, (i)))
 #define pda_offset(field) offsetof(struct i386_pda, field)
 
 extern void __bad_pda_field(void);
diff -puN include/asm-i386/processor.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda
+++ a/include/asm-i386/processor.h
@@ -743,7 +743,7 @@ extern unsigned long boot_option_idle_ov
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
-extern int init_gdt(int cpu, struct task_struct *idle);
+extern void init_gdt(int cpu, struct task_struct *idle);
 extern void cpu_set_gdt(int);
 extern void secondary_cpu_init(void);
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
