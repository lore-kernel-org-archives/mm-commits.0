From: akpm@linux-foundation.org
Subject: - i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:12 -0700
Message-ID: <200703292339.l2TNdCTk015413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43189 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945940AbXC2XjV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 GDT cleanups: Use per-cpu GDT immediately upon boot
has been removed from the -mm tree.  Its filename was
     i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 GDT cleanups: Use per-cpu GDT immediately upon boot
From: Rusty Russell <rusty@rustcorp.com.au>

Now we are no longer dynamically allocating the GDT, we don't need the
"cpu_gdt_table" at all: we can switch straight from "boot_gdt_table" to the
per-cpu GDT.  This means initializing the cpu_gdt array in C.

The boot CPU uses the per-cpu var directly, then in smp_prepare_cpus() it
switches to the per-cpu copy just allocated.  For secondary CPUs, the
early_gdt_descr is set to point directly to their per-cpu copy.

For UP the code is very simple: it keeps using the "per-cpu" GDT as per SMP,
but we never have to move.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c        |   72 +++++++++----------------
 arch/i386/kernel/head.S              |   55 -------------------
 arch/i386/kernel/smpboot.c           |   59 ++++++++++++++++----
 arch/i386/lguest/lguest.c            |    8 +-
 arch/i386/mach-voyager/voyager_smp.c |    6 --
 include/asm-i386/desc.h              |    2 
 include/asm-i386/processor.h         |    1 
 7 files changed, 79 insertions(+), 124 deletions(-)

diff -puN arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/arch/i386/kernel/cpu/common.c
@@ -25,7 +25,33 @@
 DEFINE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
 EXPORT_PER_CPU_SYMBOL(cpu_gdt_descr);
 
-DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
+DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]) = {
+	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
+	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { 0x0000ffff, 0x00cffa00 },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { 0x0000ffff, 0x00cff200 },
+	/*
+	 * Segments used for calling PnP BIOS have byte granularity.
+	 * They code segments and data segments have fixed 64k limits,
+	 * the transfer segment sizes are set at run time.
+	 */
+	[GDT_ENTRY_PNPBIOS_CS32] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
+	[GDT_ENTRY_PNPBIOS_CS16] = { 0x0000ffff, 0x00009a00 },/* 16-bit code */
+	[GDT_ENTRY_PNPBIOS_DS] = { 0x0000ffff, 0x00009200 }, /* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS1] = { 0x00000000, 0x00009200 },/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS2] = { 0x00000000, 0x00009200 },/* 16-bit data */
+	/*
+	 * The APM segments have byte granularity and their bases
+	 * are set at run time.  All have 64k limits.
+	 */
+	[GDT_ENTRY_APMBIOS_BASE] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
+	/* 16-bit code */
+	[GDT_ENTRY_APMBIOS_BASE+1] = { 0x0000ffff, 0x00009a00 },
+	[GDT_ENTRY_APMBIOS_BASE+2] = { 0x0000ffff, 0x00409200 }, /* data */
+
+	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
+	[GDT_ENTRY_PDA] = { 0x00000000, 0x00c09200 }, /* set in setup_pda */
+};
 
 DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
 EXPORT_PER_CPU_SYMBOL(_cpu_pda);
@@ -618,46 +644,6 @@ struct i386_pda boot_pda = {
 	.pcurrent = &init_task,
 };
 
-static inline void set_kernel_fs(void)
-{
-	/* Set %fs for this CPU's PDA.  Memory clobber is to create a
-	   barrier with respect to any PDA operations, so the compiler
-	   doesn't move any before here. */
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
-}
-
-/* Initialize the CPU's GDT and PDA.  This is either the boot CPU doing itself
-   (still using cpu_gdt_table), or a CPU doing it for a secondary which
-   will soon come up. */
-__cpuinit void init_gdt(int cpu, struct task_struct *idle)
-{
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
-	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
-
- 	memcpy(gdt, cpu_gdt_table, GDT_SIZE);
- 	cpu_gdt_descr->address = (unsigned long)gdt;
-	cpu_gdt_descr->size = GDT_SIZE - 1;
-
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
-			(u32 *)&gdt[GDT_ENTRY_PDA].b,
-			(unsigned long)pda, sizeof(*pda) - 1,
-			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
-
-	memset(pda, 0, sizeof(*pda));
-	pda->_pda = pda;
-	pda->cpu_number = cpu;
-	pda->pcurrent = idle;
-}
-
-void __cpuinit cpu_set_gdt(int cpu)
-{
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-
-	load_gdt(cpu_gdt_descr);
-	set_kernel_fs();
-}
-
 /* Common CPU init for both boot and secondary CPUs */
 static void __cpuinit _cpu_init(int cpu, struct task_struct *curr)
 {
@@ -740,10 +726,6 @@ void __cpuinit cpu_init(void)
 	int cpu = smp_processor_id();
 	struct task_struct *curr = current;
 
-	/* Set up the real GDT and PDA, so we can transition from the
-	   boot_gdt_table & boot_pda. */
-	init_gdt(cpu, curr);
-	cpu_set_gdt(cpu);
 	_cpu_init(cpu, curr);
 }
 
diff -puN arch/i386/kernel/head.S~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/arch/i386/kernel/head.S
@@ -599,7 +599,7 @@ idt_descr:
 	.word 0				# 32 bit align gdt_desc.address
 ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
-	.long cpu_gdt_table
+	.long per_cpu__cpu_gdt		/* Overwritten for secondary CPUs */
 
 /*
  * The boot_gdt_table must mirror the equivalent in setup.S and is
@@ -610,56 +610,3 @@ ENTRY(boot_gdt_table)
 	.fill GDT_ENTRY_BOOT_CS,8,0
 	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
 	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
-
-/*
- * The Global Descriptor Table contains 32 quadwords, per-CPU.
- */
-	.align L1_CACHE_BYTES
-ENTRY(cpu_gdt_table)
-	.quad 0x0000000000000000	/* NULL descriptor */
-	.quad 0x0000000000000000	/* 0x0b reserved */
-	.quad 0x0000000000000000	/* 0x13 reserved */
-	.quad 0x0000000000000000	/* 0x1b reserved */
-	.quad 0x0000000000000000	/* 0x20 unused */
-	.quad 0x0000000000000000	/* 0x28 unused */
-	.quad 0x0000000000000000	/* 0x33 TLS entry 1 */
-	.quad 0x0000000000000000	/* 0x3b TLS entry 2 */
-	.quad 0x0000000000000000	/* 0x43 TLS entry 3 */
-	.quad 0x0000000000000000	/* 0x4b reserved */
-	.quad 0x0000000000000000	/* 0x53 reserved */
-	.quad 0x0000000000000000	/* 0x5b reserved */
-
-	.quad 0x00cf9a000000ffff	/* 0x60 kernel 4GB code at 0x00000000 */
-	.quad 0x00cf92000000ffff	/* 0x68 kernel 4GB data at 0x00000000 */
-	.quad 0x00cffa000000ffff	/* 0x73 user 4GB code at 0x00000000 */
-	.quad 0x00cff2000000ffff	/* 0x7b user 4GB data at 0x00000000 */
-
-	.quad 0x0000000000000000	/* 0x80 TSS descriptor */
-	.quad 0x0000000000000000	/* 0x88 LDT descriptor */
-
-	/*
-	 * Segments used for calling PnP BIOS have byte granularity.
-	 * The code segments and data segments have fixed 64k limits,
-	 * the transfer segment sizes are set at run time.
-	 */
-	.quad 0x00409a000000ffff	/* 0x90 32-bit code */
-	.quad 0x00009a000000ffff	/* 0x98 16-bit code */
-	.quad 0x000092000000ffff	/* 0xa0 16-bit data */
-	.quad 0x0000920000000000	/* 0xa8 16-bit data */
-	.quad 0x0000920000000000	/* 0xb0 16-bit data */
-
-	/*
-	 * The APM segments have byte granularity and their bases
-	 * are set at run time.  All have 64k limits.
-	 */
-	.quad 0x00409a000000ffff	/* 0xb8 APM CS    code */
-	.quad 0x00009a000000ffff	/* 0xc0 APM CS 16 code (16 bit) */
-	.quad 0x004092000000ffff	/* 0xc8 APM DS    data */
-
-	.quad 0x00c0920000000000	/* 0xd0 - ESPFIX SS */
-	.quad 0x00cf92000000ffff	/* 0xd8 - PDA */
-	.quad 0x0000000000000000	/* 0xe0 - unused */
-	.quad 0x0000000000000000	/* 0xe8 - unused */
-	.quad 0x0000000000000000	/* 0xf0 - unused */
-	.quad 0x0000000000000000	/* 0xf8 - GDT entry 31: double-fault TSS */
-
diff -puN arch/i386/kernel/smpboot.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/arch/i386/kernel/smpboot.c
@@ -440,12 +440,6 @@ static void __cpuinit start_secondary(vo
 void __devinit initialize_secondary(void)
 {
 	/*
-	 * switch to the per CPU GDT we already set up
-	 * in do_boot_cpu()
-	 */
-	cpu_set_gdt(current_thread_info()->cpu);
-
-	/*
 	 * We don't actually need to load the full TSS,
 	 * basically just the stack pointer and the eip.
 	 */
@@ -787,6 +781,32 @@ static inline struct task_struct * alloc
 #define alloc_idle_task(cpu) fork_idle(cpu)
 #endif
 
+/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
+   (still using the master per-cpu area), or a CPU doing it for a
+   secondary which will soon come up. */
+static __cpuinit void init_gdt(int cpu, struct task_struct *idle)
+{
+	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
+	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
+	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
+
+ 	cpu_gdt_descr->address = (unsigned long)gdt;
+	cpu_gdt_descr->size = GDT_SIZE - 1;
+
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
+			(u32 *)&gdt[GDT_ENTRY_PDA].b,
+			(unsigned long)pda, sizeof(*pda) - 1,
+			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
+
+	memset(pda, 0, sizeof(*pda));
+	pda->_pda = pda;
+	pda->cpu_number = cpu;
+	pda->pcurrent = idle;
+}
+
+/* Defined in head.S */
+extern struct Xgt_desc_struct early_gdt_descr;
+
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -809,6 +829,8 @@ static int __cpuinit do_boot_cpu(int api
 		panic("failed fork for CPU %d", cpu);
 
 	init_gdt(cpu, idle);
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	start_pda = cpu_pda(cpu);
 
 	idle->thread.eip = (unsigned long) start_secondary;
 	/* start_eip had better be page-aligned! */
@@ -1161,13 +1183,26 @@ void __init smp_prepare_cpus(unsigned in
 	smp_boot_cpus(max_cpus);
 }
 
-void __devinit smp_prepare_boot_cpu(void)
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+static inline void switch_to_new_gdt(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
-	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+	load_gdt(&per_cpu(cpu_gdt_descr, smp_processor_id()));
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
+}
+
+void __init smp_prepare_boot_cpu(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	init_gdt(cpu, current);
+	switch_to_new_gdt();
+
+	cpu_set(cpu, cpu_online_map);
+	cpu_set(cpu, cpu_callout_map);
+	cpu_set(cpu, cpu_present_map);
+	cpu_set(cpu, cpu_possible_map);
+	__get_cpu_var(cpu_state) = CPU_ONLINE;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN arch/i386/lguest/lguest.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/arch/i386/lguest/lguest.c
@@ -449,6 +449,9 @@ static void lguest_power_off(void)
 	hcall(LHCALL_CRASH, __pa("Power down"), 0, 0);
 }
 
+/* From head.S */
+extern void setup_pda(void);
+
 static __attribute_used__ __init void lguest_init(void)
 {
 	paravirt_ops.name = "lguest";
@@ -510,10 +513,7 @@ static __attribute_used__ __init void lg
 	init_pg_tables_end = __pa(pg0);
 
 	/* set up PDA descriptor */
-	pack_descriptor((u32 *)&cpu_gdt_table[GDT_ENTRY_PDA].a,
-			(u32 *)&cpu_gdt_table[GDT_ENTRY_PDA].b,
-			(unsigned)&boot_pda, sizeof(boot_pda)-1,
-			0x80 | DESCTYPE_S | 0x02, 0);
+	setup_pda();
 	load_gdt(&early_gdt_descr);
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
 
diff -puN arch/i386/mach-voyager/voyager_smp.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -765,12 +765,6 @@ initialize_secondary(void)
 #endif
 
 	/*
-	 * switch to the per CPU GDT we already set up
-	 * in do_boot_cpu()
-	 */
-	cpu_set_gdt(current_thread_info()->cpu);
-
-	/*
 	 * We don't actually need to load the full TSS,
 	 * basically just the stack pointer and the eip.
 	 */
diff -puN include/asm-i386/desc.h~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot include/asm-i386/desc.h
--- a/include/asm-i386/desc.h~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/include/asm-i386/desc.h
@@ -12,8 +12,6 @@
 
 #include <asm/mmu.h>
 
-extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
-
 struct Xgt_desc_struct {
 	unsigned short size;
 	unsigned long address __attribute__((packed));
diff -puN include/asm-i386/processor.h~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot
+++ a/include/asm-i386/processor.h
@@ -743,7 +743,6 @@ extern unsigned long boot_option_idle_ov
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
-extern void init_gdt(int cpu, struct task_struct *idle);
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
