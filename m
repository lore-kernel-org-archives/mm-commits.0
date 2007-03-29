From: akpm@linux-foundation.org
Subject: - i386-gdt-cleanups-cleanup-gdt-access.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:17:44 -0700
Message-ID: <200703292317.l2TNHiwI014782@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934372AbXC2XRw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 GDT cleanups: cleanup GDT Access
has been removed from the -mm tree.  Its filename was
     i386-gdt-cleanups-cleanup-gdt-access.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: i386 GDT cleanups: cleanup GDT Access
From: Rusty Russell <rusty@rustcorp.com.au>

Now we have an explicit per-cpu GDT variable, we don't need to keep the
descriptors around to use them to find the GDT: expose cpu_gdt directly.

We could go further and make load_gdt() pack the descriptor for us, or even
assume it means "load the current cpu's GDT" which is what it always does.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c |    4 +---
 arch/i386/kernel/efi.c        |   16 ++++++++--------
 arch/i386/kernel/entry.S      |    3 +--
 arch/i386/kernel/smpboot.c    |   12 ++++++------
 arch/i386/kernel/traps.c      |    4 +---
 arch/i386/lguest/core.c       |    3 ++-
 arch/i386/lguest/lguest.c     |    1 +
 include/asm-i386/desc.h       |    7 ++-----
 8 files changed, 22 insertions(+), 28 deletions(-)

diff -puN arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-cleanup-gdt-access arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/kernel/cpu/common.c
@@ -22,9 +22,6 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-EXPORT_PER_CPU_SYMBOL(cpu_gdt_descr);
-
 DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]) = {
 	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
 	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
@@ -52,6 +49,7 @@ DEFINE_PER_CPU(struct desc_struct, cpu_g
 	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
 	[GDT_ENTRY_PDA] = { 0x00000000, 0x00c09200 }, /* set in setup_pda */
 };
+EXPORT_PER_CPU_SYMBOL_GPL(cpu_gdt);
 
 DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
 EXPORT_PER_CPU_SYMBOL(_cpu_pda);
diff -puN arch/i386/kernel/efi.c~i386-gdt-cleanups-cleanup-gdt-access arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/kernel/efi.c
@@ -69,13 +69,11 @@ static void efi_call_phys_prelog(void) _
 {
 	unsigned long cr4;
 	unsigned long temp;
-	struct Xgt_desc_struct *cpu_gdt_descr;
+	struct Xgt_desc_struct gdt_descr;
 
 	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
 
-	cpu_gdt_descr = &per_cpu(cpu_gdt_descr, 0);
-
 	/*
 	 * If I don't have PSE, I should just duplicate two entries in page
 	 * directory. If I have PSE, I just need to duplicate one entry in
@@ -105,17 +103,19 @@ static void efi_call_phys_prelog(void) _
 	 */
 	local_flush_tlb();
 
-	cpu_gdt_descr->address = __pa(cpu_gdt_descr->address);
-	load_gdt(cpu_gdt_descr);
+	gdt_descr.address = __pa(get_cpu_gdt_table(0));
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 }
 
 static void efi_call_phys_epilog(void) __releases(efi_rt_lock)
 {
 	unsigned long cr4;
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, 0);
+	struct Xgt_desc_struct gdt_descr;
 
-	cpu_gdt_descr->address = (unsigned long)__va(cpu_gdt_descr->address);
-	load_gdt(cpu_gdt_descr);
+	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 
 	cr4 = read_cr4();
 
diff -puN arch/i386/kernel/entry.S~i386-gdt-cleanups-cleanup-gdt-access arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/kernel/entry.S
@@ -561,8 +561,7 @@ END(syscall_badsys)
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
 	movl %fs:PDA_cpu, %ebx; \
-	PER_CPU(cpu_gdt_descr, %ebx); \
-	movl GDS_address(%ebx), %ebx; \
+	PER_CPU(cpu_gdt, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
 	pushl $__KERNEL_DS; \
diff -puN arch/i386/kernel/smpboot.c~i386-gdt-cleanups-cleanup-gdt-access arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/kernel/smpboot.c
@@ -786,13 +786,9 @@ static inline struct task_struct * alloc
    secondary which will soon come up. */
 static __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
 
- 	cpu_gdt_descr->address = (unsigned long)gdt;
-	cpu_gdt_descr->size = GDT_SIZE - 1;
-
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
 			(u32 *)&gdt[GDT_ENTRY_PDA].b,
 			(unsigned long)pda, sizeof(*pda) - 1,
@@ -1187,7 +1183,11 @@ void __init smp_prepare_cpus(unsigned in
  * it's on the real one. */
 static inline void switch_to_new_gdt(void)
 {
-	load_gdt(&per_cpu(cpu_gdt_descr, smp_processor_id()));
+	struct Xgt_desc_struct gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
 }
 
diff -puN arch/i386/kernel/traps.c~i386-gdt-cleanups-cleanup-gdt-access arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/kernel/traps.c
@@ -1031,9 +1031,7 @@ fastcall void do_spurious_interrupt_bug(
 fastcall unsigned long patch_espfix_desc(unsigned long uesp,
 					  unsigned long kesp)
 {
-	int cpu = smp_processor_id();
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt = (struct desc_struct *)cpu_gdt_descr->address;
+	struct desc_struct *gdt = __get_cpu_var(cpu_gdt);
 	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
 	unsigned long new_kesp = kesp - base;
 	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
diff -puN arch/i386/lguest/core.c~i386-gdt-cleanups-cleanup-gdt-access arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/lguest/core.c
@@ -106,7 +106,8 @@ static __init int map_hypervisor(void)
 		struct lguest_ro_state *state = &pages->state;
 
 		/* These fields are static: rest done in copy_in_guest_info */
-		state->host_gdt_desc = per_cpu(cpu_gdt_descr, i);
+		state->host_gdt_desc.size = GDT_SIZE-1;
+		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
 		store_idt(&state->host_idt_desc);
 		state->guest_idt_desc.size = sizeof(state->guest_idt)-1;
 		state->guest_idt_desc.address = (long)&state->guest_idt;
diff -puN arch/i386/lguest/lguest.c~i386-gdt-cleanups-cleanup-gdt-access arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c~i386-gdt-cleanups-cleanup-gdt-access
+++ a/arch/i386/lguest/lguest.c
@@ -451,6 +451,7 @@ static void lguest_power_off(void)
 
 /* From head.S */
 extern void setup_pda(void);
+extern struct Xgt_desc_struct early_gdt_descr;
 
 static __attribute_used__ __init void lguest_init(void)
 {
diff -puN include/asm-i386/desc.h~i386-gdt-cleanups-cleanup-gdt-access include/asm-i386/desc.h
--- a/include/asm-i386/desc.h~i386-gdt-cleanups-cleanup-gdt-access
+++ a/include/asm-i386/desc.h
@@ -18,16 +18,13 @@ struct Xgt_desc_struct {
 	unsigned short pad;
 } __attribute__ ((packed));
 
-extern struct Xgt_desc_struct idt_descr;
-DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
 DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
-	return (struct desc_struct *)per_cpu(cpu_gdt_descr, cpu).address;
+	return per_cpu(cpu_gdt, cpu);
 }
 
+extern struct Xgt_desc_struct idt_descr;
 extern struct desc_struct idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
i386-account-for-module-percpu-space-separately-from-kernel.patch
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
ignore-vgacon-if-hardware-not-present.patch
