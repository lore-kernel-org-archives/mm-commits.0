From: akpm@linux-foundation.org
Subject: - lguest-guest-code.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:33 -0700
Message-ID: <200703292314.l2TNEXij014704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934361AbXC2XOo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: Guest code
has been removed from the -mm tree.  Its filename was
     lguest-guest-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: Guest code
From: Rusty Russell <rusty@rustcorp.com.au>

This is the guest code which replaces the parts of paravirt_ops with
hypercalls.  It's fairly trivial.  This patch also includes trivial bus driver
for lguest devices, and an extern declarations for boot_pda (previously
frobbed only from head.S).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/lguest.c     |  562 ++++++++++++++++++++++++++++++++
 arch/i386/lguest/lguest_bus.c |  180 ++++++++++
 include/asm-i386/pda.h        |    1 
 3 files changed, 743 insertions(+)

diff -puN /dev/null arch/i386/lguest/lguest.c
--- /dev/null
+++ a/arch/i386/lguest/lguest.c
@@ -0,0 +1,562 @@
+/*
+ * Lguest specific paravirt-ops implementation
+ *
+ * Copyright (C) 2006, Rusty Russell <rusty@rustcorp.com.au> IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/start_kernel.h>
+#include <linux/string.h>
+#include <linux/console.h>
+#include <linux/screen_info.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <asm/paravirt.h>
+#include <asm/lguest.h>
+#include <asm/lguest_user.h>
+#include <asm/param.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/desc.h>
+#include <asm/setup.h>
+#include <asm/e820.h>
+#include <asm/pda.h>
+#include <asm/asm-offsets.h>
+#include <asm/mce.h>
+
+struct lguest_data lguest_data;
+struct lguest_device_desc *lguest_devices;
+static __initdata const struct lguest_boot_info *boot = __va(0);
+
+void async_hcall(unsigned long call,
+		 unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	/* Note: This code assumes we're uniprocessor. */
+	static unsigned int next_call;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (lguest_data.hcall_status[next_call] != 0xFF) {
+		/* Table full, so do normal hcall which will flush table. */
+		hcall(call, arg1, arg2, arg3);
+	} else {
+		lguest_data.hcalls[next_call].eax = call;
+		lguest_data.hcalls[next_call].edx = arg1;
+		lguest_data.hcalls[next_call].ebx = arg2;
+		lguest_data.hcalls[next_call].ecx = arg3;
+		wmb();
+		lguest_data.hcall_status[next_call] = 0;
+		if (++next_call == LHCALL_RING_SIZE)
+			next_call = 0;
+	}
+	local_irq_restore(flags);
+}
+
+#ifdef PARAVIRT_LAZY_NONE 	/* Not in 2.6.20. */
+static int lazy_mode;
+static void fastcall lguest_lazy_mode(int mode)
+{
+	lazy_mode = mode;
+	if (mode == PARAVIRT_LAZY_NONE)
+		hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+}
+
+static void lazy_hcall(unsigned long call,
+		       unsigned long arg1,
+		       unsigned long arg2,
+		       unsigned long arg3)
+{
+	if (lazy_mode == PARAVIRT_LAZY_NONE)
+		hcall(call, arg1, arg2, arg3);
+	else
+		async_hcall(call, arg1, arg2, arg3);
+}
+#else
+#define lazy_hcall hcall
+#endif
+
+static unsigned long fastcall save_fl(void)
+{
+	return lguest_data.irq_enabled;
+}
+
+static void fastcall restore_fl(unsigned long flags)
+{
+	/* FIXME: Check if interrupt pending... */
+	lguest_data.irq_enabled = flags;
+}
+
+static void fastcall irq_disable(void)
+{
+	lguest_data.irq_enabled = 0;
+}
+
+static void fastcall irq_enable(void)
+{
+	/* Linux i386 code expects bit 9 set. */
+	/* FIXME: Check if interrupt pending... */
+	lguest_data.irq_enabled = 512;
+}
+
+static void fastcall lguest_load_gdt(const struct Xgt_desc_struct *desc)
+{
+	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
+	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
+}
+
+static void fastcall lguest_load_idt(const struct Xgt_desc_struct *desc)
+{
+	unsigned int i;
+	struct desc_struct *idt = (void *)desc->address;
+
+	for (i = 0; i < (desc->size+1)/8; i++)
+		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+}
+
+static int lguest_panic(struct notifier_block *nb, unsigned long l, void *p)
+{
+	hcall(LHCALL_CRASH, __pa(p), 0, 0);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block paniced = {
+	.notifier_call = lguest_panic
+};
+
+static char *lguest_memory_setup(void)
+{
+	/* We do this here because lockcheck barfs if before start_kernel */
+	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+
+	e820.nr_map = 0;
+	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
+	return "LGUEST";
+}
+
+static fastcall void lguest_cpuid(unsigned int *eax, unsigned int *ebx,
+				 unsigned int *ecx, unsigned int *edx)
+{
+	int is_feature = (*eax == 1);
+
+	native_cpuid(eax, ebx, ecx, edx);
+	if (is_feature) {
+		unsigned long *excap = (unsigned long *)ecx,
+			*features = (unsigned long *)edx;
+		/* Hypervisor needs to know when we flush kernel pages. */
+		set_bit(X86_FEATURE_PGE, features);
+		/* We don't have any features! */
+		clear_bit(X86_FEATURE_VME, features);
+		clear_bit(X86_FEATURE_DE, features);
+		clear_bit(X86_FEATURE_PSE, features);
+		clear_bit(X86_FEATURE_PAE, features);
+		clear_bit(X86_FEATURE_SEP, features);
+		clear_bit(X86_FEATURE_APIC, features);
+		clear_bit(X86_FEATURE_MTRR, features);
+		/* No MWAIT, either */
+		clear_bit(3, excap);
+	}
+}
+
+static unsigned long current_cr3;
+static void fastcall lguest_write_cr3(unsigned long cr3)
+{
+	hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
+	current_cr3 = cr3;
+}
+
+static void fastcall lguest_flush_tlb(void)
+{
+	lazy_hcall(LHCALL_FLUSH_TLB, 0, 0, 0);
+}
+
+static void fastcall lguest_flush_tlb_kernel(void)
+{
+	lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+}
+
+static void fastcall lguest_flush_tlb_single(u32 addr)
+{
+	/* Simply set it to zero, and it will fault back in. */
+	lazy_hcall(LHCALL_SET_PTE, current_cr3, addr, 0);
+}
+
+/* FIXME: Eliminate all callers of this. */
+static fastcall void lguest_set_pte(pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+	/* Don't bother with hypercall before initial setup. */
+	if (current_cr3)
+		hcall(LHCALL_SET_UNKNOWN_PTE, 0, 0, 0);
+}
+
+static fastcall void lguest_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, pteval.pte_low);
+}
+
+/* We only support two-level pagetables at the moment. */
+static fastcall void lguest_set_pud(pmd_t *pmdp, pmd_t pmdval)
+{
+	*pmdp = pmdval;
+	lazy_hcall(LHCALL_SET_PUD, __pa(pmdp)&PAGE_MASK,
+		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+static fastcall void lguest_apic_write(unsigned long reg, unsigned long v)
+{
+}
+
+static fastcall void lguest_apic_write_atomic(unsigned long reg, unsigned long v)
+{
+}
+
+static fastcall unsigned long lguest_apic_read(unsigned long reg)
+{
+	return 0;
+}
+#endif
+
+/* We move eflags word to lguest_data.irq_enabled to restore interrupt
+   state.  For page faults, gpfs and virtual interrupts, the
+   hypervisor has saved eflags manually, otherwise it was delivered
+   directly and so eflags reflects the real machine IF state,
+   ie. interrupts on.  Since the kernel always dies if it takes such a
+   trap with interrupts disabled anyway, turning interrupts back on
+   unconditionally here is OK. */
+asm("lguest_iret:"
+    " pushl	%eax;"
+    " movl	12(%esp), %eax;"
+    "lguest_noirq_start:;"
+    " movl	%eax,%ss:lguest_data+"__stringify(LGUEST_DATA_irq_enabled)";"
+    " popl	%eax;"
+    " iret;"
+    "lguest_noirq_end:");
+extern void fastcall lguest_iret(void);
+extern char lguest_noirq_start[], lguest_noirq_end[];
+
+static void fastcall lguest_load_esp0(struct tss_struct *tss,
+				     struct thread_struct *thread)
+{
+	lazy_hcall(LHCALL_SET_STACK, __KERNEL_DS|0x1, thread->esp0,
+		   THREAD_SIZE/PAGE_SIZE);
+}
+
+static fastcall void lguest_load_tr_desc(void)
+{
+}
+
+static fastcall void lguest_set_ldt(const void *addr, unsigned entries)
+{
+	/* FIXME: Implement. */
+	BUG_ON(entries);
+}
+
+static fastcall void lguest_load_tls(struct thread_struct *t, unsigned int cpu)
+{
+	lazy_hcall(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu, 0);
+}
+
+static fastcall void lguest_set_debugreg(int regno, unsigned long value)
+{
+	/* FIXME: Implement */
+}
+
+static unsigned int lguest_cr0;
+static fastcall void lguest_clts(void)
+{
+	lazy_hcall(LHCALL_TS, 0, 0, 0);
+	lguest_cr0 &= ~8U;
+}
+
+static fastcall unsigned long lguest_read_cr0(void)
+{
+	return lguest_cr0;
+}
+
+static fastcall void lguest_write_cr0(unsigned long val)
+{
+	hcall(LHCALL_TS, val & 8, 0, 0);
+	lguest_cr0 = val;
+}
+
+static fastcall unsigned long lguest_read_cr2(void)
+{
+	return lguest_data.cr2;
+}
+
+static fastcall unsigned long lguest_read_cr3(void)
+{
+	return current_cr3;
+}
+
+/* Used to enable/disable PGE, but we don't care. */
+static fastcall unsigned long lguest_read_cr4(void)
+{
+	return 0;
+}
+
+static fastcall void lguest_write_cr4(unsigned long val)
+{
+}
+
+static void fastcall lguest_time_irq(unsigned int irq, struct irq_desc *desc)
+{
+	do_timer(hcall(LHCALL_TIMER_READ, 0, 0, 0));
+	update_process_times(user_mode_vm(get_irq_regs()));
+}
+
+static void disable_lguest_irq(unsigned int irq)
+{
+	set_bit(irq, lguest_data.interrupts);
+}
+
+static void enable_lguest_irq(unsigned int irq)
+{
+	clear_bit(irq, lguest_data.interrupts);
+	/* FIXME: If it's pending? */
+}
+
+static struct irq_chip lguest_irq_controller = {
+	.name		= "lguest",
+	.mask		= disable_lguest_irq,
+	.mask_ack	= disable_lguest_irq,
+	.unmask		= enable_lguest_irq,
+};
+
+static void lguest_time_init(void)
+{
+	set_irq_handler(0, lguest_time_irq);
+	hcall(LHCALL_TIMER_START,HZ,0,0);
+}
+
+static void __init lguest_init_IRQ(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_IRQS; i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (i >= NR_IRQS)
+			break;
+		if (vector != SYSCALL_VECTOR) {
+			set_intr_gate(vector, interrupt[i]);
+			set_irq_chip_and_handler(i, &lguest_irq_controller,
+						 handle_level_irq);
+		}
+	}
+	irq_ctx_init(smp_processor_id());
+}
+
+static inline void native_write_dt_entry(void *dt, int entry, u32 entry_low, u32 entry_high)
+{
+	u32 *lp = (u32 *)((char *)dt + entry*8);
+	lp[0] = entry_low;
+	lp[1] = entry_high;
+}
+
+static fastcall void lguest_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
+{
+	/* FIXME: Allow this. */
+	BUG();
+}
+
+static fastcall void lguest_write_gdt_entry(void *dt, int entrynum,
+					   u32 low, u32 high)
+{
+	native_write_dt_entry(dt, entrynum, low, high);
+	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
+}
+
+static fastcall void lguest_write_idt_entry(void *dt, int entrynum,
+					   u32 low, u32 high)
+{
+	native_write_dt_entry(dt, entrynum, low, high);
+	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
+}
+
+#define LGUEST_IRQ "lguest_data+"__stringify(LGUEST_DATA_irq_enabled)
+#define DEF_LGUEST(name, code)				\
+	extern const char start_##name[], end_##name[];		\
+	asm("start_" #name ": " code "; end_" #name ":")
+DEF_LGUEST(cli, "movl $0," LGUEST_IRQ);
+DEF_LGUEST(sti, "movl $512," LGUEST_IRQ);
+DEF_LGUEST(popf, "movl %eax," LGUEST_IRQ);
+DEF_LGUEST(pushf, "movl " LGUEST_IRQ ",%eax");
+DEF_LGUEST(pushf_cli, "movl " LGUEST_IRQ ",%eax; movl $0," LGUEST_IRQ);
+DEF_LGUEST(iret, ".byte 0xE9,0,0,0,0"); /* jmp ... */
+
+static const struct lguest_insns
+{
+	const char *start, *end;
+} lguest_insns[] = {
+	[PARAVIRT_IRQ_DISABLE] = { start_cli, end_cli },
+	[PARAVIRT_IRQ_ENABLE] = { start_sti, end_sti },
+	[PARAVIRT_RESTORE_FLAGS] = { start_popf, end_popf },
+	[PARAVIRT_SAVE_FLAGS] = { start_pushf, end_pushf },
+	[PARAVIRT_SAVE_FLAGS_IRQ_DISABLE] = { start_pushf_cli, end_pushf_cli },
+	[PARAVIRT_INTERRUPT_RETURN] = { start_iret, end_iret },
+};
+static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
+{
+	unsigned int insn_len;
+
+	/* Don't touch it if we don't have a replacement */
+	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
+		return len;
+
+	insn_len = lguest_insns[type].end - lguest_insns[type].start;
+
+	/* Similarly if we can't fit replacement. */
+	if (len < insn_len)
+		return len;
+
+	memcpy(insns, lguest_insns[type].start, insn_len);
+	if (type == PARAVIRT_INTERRUPT_RETURN) {
+		/* Jumps are relative. */
+		u32 off = (u32)lguest_iret - ((u32)insns + insn_len);
+		memcpy(insns+1, &off, sizeof(off));
+	}
+	return insn_len;
+}
+
+static void fastcall lguest_safe_halt(void)
+{
+	hcall(LHCALL_HALT, 0, 0, 0);
+}
+
+static unsigned long lguest_get_wallclock(void)
+{
+	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
+}
+
+static void lguest_power_off(void)
+{
+	hcall(LHCALL_CRASH, __pa("Power down"), 0, 0);
+}
+
+static __attribute_used__ __init void lguest_init(void)
+{
+	paravirt_ops.name = "lguest";
+	paravirt_ops.paravirt_enabled = 1;
+	paravirt_ops.kernel_rpl = 1;
+
+	paravirt_ops.save_fl = save_fl;
+	paravirt_ops.restore_fl = restore_fl;
+	paravirt_ops.irq_disable = irq_disable;
+	paravirt_ops.irq_enable = irq_enable;
+	paravirt_ops.load_gdt = lguest_load_gdt;
+	paravirt_ops.memory_setup = lguest_memory_setup;
+	paravirt_ops.cpuid = lguest_cpuid;
+	paravirt_ops.write_cr3 = lguest_write_cr3;
+	paravirt_ops.flush_tlb_user = lguest_flush_tlb;
+	paravirt_ops.flush_tlb_single = lguest_flush_tlb_single;
+	paravirt_ops.flush_tlb_kernel = lguest_flush_tlb_kernel;
+	paravirt_ops.set_pte = lguest_set_pte;
+	paravirt_ops.set_pte_at = lguest_set_pte_at;
+	paravirt_ops.set_pmd = lguest_set_pud;
+#ifdef CONFIG_X86_LOCAL_APIC
+	paravirt_ops.apic_write = lguest_apic_write;
+	paravirt_ops.apic_write_atomic = lguest_apic_write_atomic;
+	paravirt_ops.apic_read = lguest_apic_read;
+#endif
+	paravirt_ops.load_idt = lguest_load_idt;
+	paravirt_ops.iret = lguest_iret;
+	paravirt_ops.load_esp0 = lguest_load_esp0;
+	paravirt_ops.load_tr_desc = lguest_load_tr_desc;
+	paravirt_ops.set_ldt = lguest_set_ldt;
+	paravirt_ops.load_tls = lguest_load_tls;
+	paravirt_ops.set_debugreg = lguest_set_debugreg;
+	paravirt_ops.clts = lguest_clts;
+	paravirt_ops.read_cr0 = lguest_read_cr0;
+	paravirt_ops.write_cr0 = lguest_write_cr0;
+	paravirt_ops.init_IRQ = lguest_init_IRQ;
+	paravirt_ops.read_cr2 = lguest_read_cr2;
+	paravirt_ops.read_cr3 = lguest_read_cr3;
+	paravirt_ops.read_cr4 = lguest_read_cr4;
+	paravirt_ops.write_cr4 = lguest_write_cr4;
+	paravirt_ops.write_ldt_entry = lguest_write_ldt_entry;
+	paravirt_ops.write_gdt_entry = lguest_write_gdt_entry;
+	paravirt_ops.write_idt_entry = lguest_write_idt_entry;
+	paravirt_ops.patch = lguest_patch;
+	paravirt_ops.safe_halt = lguest_safe_halt;
+	paravirt_ops.get_wallclock = lguest_get_wallclock;
+	paravirt_ops.time_init = lguest_time_init;
+#ifdef PARAVIRT_LAZY_NONE
+	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
+#endif
+
+	memset(lguest_data.hcall_status,0xFF,sizeof(lguest_data.hcall_status));
+	lguest_data.noirq_start = (u32)lguest_noirq_start;
+	lguest_data.noirq_end = (u32)lguest_noirq_end;
+	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
+	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
+
+	/* We use top of mem for initial pagetables. */
+	init_pg_tables_end = __pa(pg0);
+
+	/* set up PDA descriptor */
+	pack_descriptor((u32 *)&cpu_gdt_table[GDT_ENTRY_PDA].a,
+			(u32 *)&cpu_gdt_table[GDT_ENTRY_PDA].b,
+			(unsigned)&boot_pda, sizeof(boot_pda)-1,
+			0x80 | DESCTYPE_S | 0x02, 0);
+	load_gdt(&early_gdt_descr);
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
+
+	reserve_top_address(lguest_data.reserve_mem);
+
+	cpu_detect(&new_cpu_data);
+	/* Need this before paging_init. */
+	set_bit(X86_FEATURE_PGE, new_cpu_data.x86_capability);
+	/* Math is always hard! */
+	new_cpu_data.hard_math = 1;
+
+	/* FIXME: Better way? */
+	/* Suppress vgacon startup code */
+	SCREEN_INFO.orig_video_isVGA = VIDEO_TYPE_VLFB;
+
+	add_preferred_console("hvc", 0, NULL);
+
+#ifdef CONFIG_X86_MCE
+	mce_disabled = 1;
+#endif
+
+#ifdef CONFIG_ACPI
+	acpi_disabled = 1;
+	acpi_ht = 0;
+#endif
+	if (boot->initrd_size) {
+		/* We stash this at top of memory. */
+		INITRD_START = boot->max_pfn*PAGE_SIZE - boot->initrd_size;
+		INITRD_SIZE = boot->initrd_size;
+		LOADER_TYPE = 0xFF;
+	}
+
+	pm_power_off = lguest_power_off;
+	start_kernel();
+}
+
+asm("lguest_maybe_init:\n"
+    "	cmpl $"__stringify(LGUEST_MAGIC_EBP)", %ebp\n"
+    "	jne 1f\n"
+    "	cmpl $"__stringify(LGUEST_MAGIC_EDI)", %edi\n"
+    "	jne 1f\n"
+    "	cmpl $"__stringify(LGUEST_MAGIC_ESI)", %esi\n"
+    "	je lguest_init\n"
+    "1: ret");
+extern void asmlinkage lguest_maybe_init(void);
+paravirt_probe(lguest_maybe_init);
diff -puN /dev/null arch/i386/lguest/lguest_bus.c
--- /dev/null
+++ a/arch/i386/lguest/lguest_bus.c
@@ -0,0 +1,180 @@
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <asm/lguest_device.h>
+#include <asm/lguest.h>
+#include <asm/io.h>
+
+static ssize_t type_show(struct device *_dev,
+                         struct device_attribute *attr, char *buf)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	return sprintf(buf, "%hu", lguest_devices[dev->index].type);
+}
+static ssize_t features_show(struct device *_dev,
+                             struct device_attribute *attr, char *buf)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	return sprintf(buf, "%hx", lguest_devices[dev->index].features);
+}
+static ssize_t pfn_show(struct device *_dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	return sprintf(buf, "%u", lguest_devices[dev->index].pfn);
+}
+static ssize_t status_show(struct device *_dev,
+                           struct device_attribute *attr, char *buf)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	return sprintf(buf, "%hx", lguest_devices[dev->index].status);
+}
+static ssize_t status_store(struct device *_dev, struct device_attribute *attr,
+                            const char *buf, size_t count)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	if (sscanf(buf, "%hi", &lguest_devices[dev->index].status) != 1)
+		return -EINVAL;
+	return count;
+}
+static struct device_attribute lguest_dev_attrs[] = {
+	__ATTR_RO(type),
+	__ATTR_RO(features),
+	__ATTR_RO(pfn),
+	__ATTR(status, 0644, status_show, status_store),
+	__ATTR_NULL
+};
+
+static int lguest_dev_match(struct device *_dev, struct device_driver *_drv)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	struct lguest_driver *drv = container_of(_drv,struct lguest_driver,drv);
+
+	return (drv->device_type == lguest_devices[dev->index].type);
+}
+
+struct lguest_bus {
+	struct bus_type bus;
+	struct device dev;
+};
+
+static struct lguest_bus lguest_bus = {
+	.bus = {
+		.name  = "lguest",
+		.match = lguest_dev_match,
+		.dev_attrs = lguest_dev_attrs,
+	},
+	.dev = {
+		.parent = NULL,
+		.bus_id = "lguest",
+	}
+};
+
+static int lguest_dev_probe(struct device *_dev)
+{
+	int ret;
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	struct lguest_driver *drv = container_of(dev->dev.driver,
+						struct lguest_driver, drv);
+
+	lguest_devices[dev->index].status |= LGUEST_DEVICE_S_DRIVER;
+	ret = drv->probe(dev);
+	if (ret == 0)
+		lguest_devices[dev->index].status |= LGUEST_DEVICE_S_DRIVER_OK;
+	return ret;
+}
+
+static int lguest_dev_remove(struct device *_dev)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+	struct lguest_driver *drv = container_of(dev->dev.driver,
+						struct lguest_driver, drv);
+
+	if (dev->dev.driver && drv->remove)
+		drv->remove(dev);
+	put_device(&dev->dev);
+	return 0;
+}
+
+int register_lguest_driver(struct lguest_driver *drv)
+{
+	if (!lguest_devices)
+		return 0;
+
+	drv->drv.bus = &lguest_bus.bus;
+	drv->drv.name = drv->name;
+	drv->drv.owner = drv->owner;
+	drv->drv.probe = lguest_dev_probe;
+	drv->drv.remove = lguest_dev_remove;
+
+	return driver_register(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(register_lguest_driver);
+
+void unregister_lguest_driver(struct lguest_driver *drv)
+{
+	if (!lguest_devices)
+		return;
+
+	driver_unregister(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(unregister_lguest_driver);
+
+static void release_lguest_device(struct device *_dev)
+{
+	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
+
+	lguest_devices[dev->index].status |= LGUEST_DEVICE_S_REMOVED_ACK;
+	kfree(dev);
+}
+
+static void add_lguest_device(unsigned int index)
+{
+	struct lguest_device *new;
+
+	lguest_devices[index].status |= LGUEST_DEVICE_S_ACKNOWLEDGE;
+	new = kmalloc(sizeof(struct lguest_device), GFP_KERNEL);
+	if (!new) {
+		printk(KERN_EMERG "Cannot allocate lguest device %u\n", index);
+		lguest_devices[index].status |= LGUEST_DEVICE_S_FAILED;
+		return;
+	}
+
+	new->index = index;
+	new->private = NULL;
+	memset(&new->dev, 0, sizeof(new->dev));
+	new->dev.parent = &lguest_bus.dev;
+	new->dev.bus = &lguest_bus.bus;
+	new->dev.release = release_lguest_device;
+	sprintf(new->dev.bus_id, "%u", index);
+	if (device_register(&new->dev) != 0) {
+		printk(KERN_EMERG "Cannot register lguest device %u\n", index);
+		lguest_devices[index].status |= LGUEST_DEVICE_S_FAILED;
+		kfree(new);
+	}
+}
+
+static void scan_devices(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_MAX_DEVICES; i++)
+		if (lguest_devices[i].type)
+			add_lguest_device(i);
+}
+
+static int __init lguest_bus_init(void)
+{
+	if (strcmp(paravirt_ops.name, "lguest") != 0)
+		return 0;
+
+	/* Devices are in page above top of "normal" mem. */
+	lguest_devices = ioremap(max_pfn << PAGE_SHIFT, PAGE_SIZE);
+
+	if (bus_register(&lguest_bus.bus) != 0
+	    || device_register(&lguest_bus.dev) != 0)
+		panic("lguest bus registration failed");
+
+	scan_devices();
+	return 0;
+}
+postcore_initcall(lguest_bus_init);
diff -puN include/asm-i386/pda.h~lguest-guest-code include/asm-i386/pda.h
--- a/include/asm-i386/pda.h~lguest-guest-code
+++ a/include/asm-i386/pda.h
@@ -97,4 +97,5 @@ extern struct i386_pda _proxy_pda;
 #define sub_pda(field,val) pda_to_op("sub",field,val)
 #define or_pda(field,val) pda_to_op("or",field,val)
 
+extern struct i386_pda boot_pda;
 #endif	/* _I386_PDA_H */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-guest-code.patch
lguest-guest-code-warning-fixes.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
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
