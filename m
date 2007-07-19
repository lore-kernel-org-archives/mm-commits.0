From: akpm@linux-foundation.org
Subject: - lguest-the-guest-code.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:51 -0700
Message-ID: <200707192004.l6JK4plM019985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932224AbXGSU1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     lguest: the guest code
has been removed from the -mm tree.  Its filename was
     lguest-the-guest-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: the guest code
From: Rusty Russell <rusty@rustcorp.com.au>

lguest is a simple hypervisor for Linux on Linux.  Unlike kvm it doesn't need
VT/SVM hardware.  Unlike Xen it's simply "modprobe and go".  Unlike both, it's
5000 lines and self-contained.

Performance is ok, but not great (-30% on kernel compile).  But given its
hackability, I expect this to improve, along with the paravirt_ops code which
it supplies a complete example for.  There's also a 64-bit version being
worked on and other craziness.

But most of all, lguest is awesome fun!  Too much of the kernel is a big ball
of hair.  lguest is simple enough to dive into and hack, plus has some warts
which scream "fork me!".


This patch:

This is the code and headers required to make an i386 kernel an lguest guest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c     |  544 ++++++++++++++++++++++++++++++++++
 drivers/lguest/lguest_asm.S |   53 +++
 drivers/lguest/lguest_bus.c |  148 +++++++++
 include/linux/lguest.h      |   85 +++++
 include/linux/lguest_bus.h  |   48 +++
 5 files changed, 878 insertions(+)

diff -puN /dev/null drivers/lguest/lguest.c
--- /dev/null
+++ a/drivers/lguest/lguest.c
@@ -0,0 +1,544 @@
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
+#include <linux/lguest.h>
+#include <linux/lguest_launcher.h>
+#include <linux/lguest_bus.h>
+#include <asm/paravirt.h>
+#include <asm/param.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/desc.h>
+#include <asm/setup.h>
+#include <asm/e820.h>
+#include <asm/mce.h>
+#include <asm/io.h>
+
+/* Declarations for definitions in lguest_guest.S */
+extern char lguest_noirq_start[], lguest_noirq_end[];
+extern const char lgstart_cli[], lgend_cli[];
+extern const char lgstart_sti[], lgend_sti[];
+extern const char lgstart_popf[], lgend_popf[];
+extern const char lgstart_pushf[], lgend_pushf[];
+extern const char lgstart_iret[], lgend_iret[];
+extern void lguest_iret(void);
+
+struct lguest_data lguest_data = {
+	.hcall_status = { [0 ... LHCALL_RING_SIZE-1] = 0xFF },
+	.noirq_start = (u32)lguest_noirq_start,
+	.noirq_end = (u32)lguest_noirq_end,
+	.blocked_interrupts = { 1 }, /* Block timer interrupts */
+};
+struct lguest_device_desc *lguest_devices;
+static __initdata const struct lguest_boot_info *boot = __va(0);
+
+static enum paravirt_lazy_mode lazy_mode;
+static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
+{
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		if (unlikely(lazy_mode != PARAVIRT_LAZY_NONE))
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	} else {
+		lazy_mode = mode;
+		if (mode == PARAVIRT_LAZY_NONE)
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	}
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
+		/* Make sure host sees arguments before "valid" flag. */
+		wmb();
+		lguest_data.hcall_status[next_call] = 0;
+		if (++next_call == LHCALL_RING_SIZE)
+			next_call = 0;
+	}
+	local_irq_restore(flags);
+}
+
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma)
+{
+	dma->used_len = 0;
+	hcall(LHCALL_SEND_DMA, key, __pa(dma), 0);
+}
+
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq)
+{
+	if (!hcall(LHCALL_BIND_DMA, key, __pa(dmas), (num << 8) | irq))
+		return -ENOMEM;
+	return 0;
+}
+
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas)
+{
+	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
+}
+
+/* For guests, device memory can be used as normal memory, so we cast away the
+ * __iomem to quieten sparse. */
+void *lguest_map(unsigned long phys_addr, unsigned long pages)
+{
+	return (__force void *)ioremap(phys_addr, PAGE_SIZE*pages);
+}
+
+void lguest_unmap(void *addr)
+{
+	iounmap((__force void __iomem *)addr);
+}
+
+static unsigned long save_fl(void)
+{
+	return lguest_data.irq_enabled;
+}
+
+static void restore_fl(unsigned long flags)
+{
+	/* FIXME: Check if interrupt pending... */
+	lguest_data.irq_enabled = flags;
+}
+
+static void irq_disable(void)
+{
+	lguest_data.irq_enabled = 0;
+}
+
+static void irq_enable(void)
+{
+	/* FIXME: Check if interrupt pending... */
+	lguest_data.irq_enabled = X86_EFLAGS_IF;
+}
+
+static void lguest_write_idt_entry(struct desc_struct *dt,
+				   int entrynum, u32 low, u32 high)
+{
+	write_dt_entry(dt, entrynum, low, high);
+	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
+}
+
+static void lguest_load_idt(const struct Xgt_desc_struct *desc)
+{
+	unsigned int i;
+	struct desc_struct *idt = (void *)desc->address;
+
+	for (i = 0; i < (desc->size+1)/8; i++)
+		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+}
+
+static void lguest_load_gdt(const struct Xgt_desc_struct *desc)
+{
+	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
+	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
+}
+
+static void lguest_write_gdt_entry(struct desc_struct *dt,
+				   int entrynum, u32 low, u32 high)
+{
+	write_dt_entry(dt, entrynum, low, high);
+	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
+}
+
+static void lguest_load_tls(struct thread_struct *t, unsigned int cpu)
+{
+	lazy_hcall(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu, 0);
+}
+
+static void lguest_set_ldt(const void *addr, unsigned entries)
+{
+}
+
+static void lguest_load_tr_desc(void)
+{
+}
+
+static void lguest_cpuid(unsigned int *eax, unsigned int *ebx,
+			 unsigned int *ecx, unsigned int *edx)
+{
+	int function = *eax;
+
+	native_cpuid(eax, ebx, ecx, edx);
+	switch (function) {
+	case 1:	/* Basic feature request. */
+		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
+		*ecx &= 0x00002201;
+		/* Similarly: SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
+		*edx &= 0x07808101;
+		/* Host wants to know when we flush kernel pages: set PGE. */
+		*edx |= 0x00002000;
+		break;
+	case 0x80000000:
+		/* Futureproof this a little: if they ask how much extended
+		 * processor information, limit it to known fields. */
+		if (*eax > 0x80000008)
+			*eax = 0x80000008;
+		break;
+	}
+}
+
+static unsigned long current_cr0, current_cr3;
+static void lguest_write_cr0(unsigned long val)
+{
+	lazy_hcall(LHCALL_TS, val & 8, 0, 0);
+	current_cr0 = val;
+}
+
+static unsigned long lguest_read_cr0(void)
+{
+	return current_cr0;
+}
+
+static void lguest_clts(void)
+{
+	lazy_hcall(LHCALL_TS, 0, 0, 0);
+	current_cr0 &= ~8U;
+}
+
+static unsigned long lguest_read_cr2(void)
+{
+	return lguest_data.cr2;
+}
+
+static void lguest_write_cr3(unsigned long cr3)
+{
+	lazy_hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
+	current_cr3 = cr3;
+}
+
+static unsigned long lguest_read_cr3(void)
+{
+	return current_cr3;
+}
+
+/* Used to enable/disable PGE, but we don't care. */
+static unsigned long lguest_read_cr4(void)
+{
+	return 0;
+}
+
+static void lguest_write_cr4(unsigned long val)
+{
+}
+
+static void lguest_set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, pteval.pte_low);
+}
+
+/* We only support two-level pagetables at the moment. */
+static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	*pmdp = pmdval;
+	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
+		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
+}
+
+/* FIXME: Eliminate all callers of this. */
+static void lguest_set_pte(pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+	/* Don't bother with hypercall before initial setup. */
+	if (current_cr3)
+		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+}
+
+static void lguest_flush_tlb_single(unsigned long addr)
+{
+	/* Simply set it to zero, and it will fault back in. */
+	lazy_hcall(LHCALL_SET_PTE, current_cr3, addr, 0);
+}
+
+static void lguest_flush_tlb_user(void)
+{
+	lazy_hcall(LHCALL_FLUSH_TLB, 0, 0, 0);
+}
+
+static void lguest_flush_tlb_kernel(void)
+{
+	lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+}
+
+static void disable_lguest_irq(unsigned int irq)
+{
+	set_bit(irq, lguest_data.blocked_interrupts);
+}
+
+static void enable_lguest_irq(unsigned int irq)
+{
+	clear_bit(irq, lguest_data.blocked_interrupts);
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
+static void __init lguest_init_IRQ(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_IRQS; i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != SYSCALL_VECTOR) {
+			set_intr_gate(vector, interrupt[i]);
+			set_irq_chip_and_handler(i, &lguest_irq_controller,
+						 handle_level_irq);
+		}
+	}
+	irq_ctx_init(smp_processor_id());
+}
+
+static unsigned long lguest_get_wallclock(void)
+{
+	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
+}
+
+static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
+{
+	do_timer(hcall(LHCALL_TIMER_READ, 0, 0, 0));
+	update_process_times(user_mode_vm(get_irq_regs()));
+}
+
+static u64 sched_clock_base;
+static void lguest_time_init(void)
+{
+	set_irq_handler(0, lguest_time_irq);
+	hcall(LHCALL_TIMER_READ, 0, 0, 0);
+	sched_clock_base = jiffies_64;
+	enable_lguest_irq(0);
+}
+
+static unsigned long long lguest_sched_clock(void)
+{
+	return (jiffies_64 - sched_clock_base) * (1000000000 / HZ);
+}
+
+static void lguest_load_esp0(struct tss_struct *tss,
+				     struct thread_struct *thread)
+{
+	lazy_hcall(LHCALL_SET_STACK, __KERNEL_DS|0x1, thread->esp0,
+		   THREAD_SIZE/PAGE_SIZE);
+}
+
+static void lguest_set_debugreg(int regno, unsigned long value)
+{
+	/* FIXME: Implement */
+}
+
+static void lguest_wbinvd(void)
+{
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+static void lguest_apic_write(unsigned long reg, unsigned long v)
+{
+}
+
+static unsigned long lguest_apic_read(unsigned long reg)
+{
+	return 0;
+}
+#endif
+
+static void lguest_safe_halt(void)
+{
+	hcall(LHCALL_HALT, 0, 0, 0);
+}
+
+static void lguest_power_off(void)
+{
+	hcall(LHCALL_CRASH, __pa("Power down"), 0, 0);
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
+static __init char *lguest_memory_setup(void)
+{
+	/* We do this here because lockcheck barfs if before start_kernel */
+	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+
+	e820.nr_map = 0;
+	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
+	return "LGUEST";
+}
+
+static const struct lguest_insns
+{
+	const char *start, *end;
+} lguest_insns[] = {
+	[PARAVIRT_PATCH(irq_disable)] = { lgstart_cli, lgend_cli },
+	[PARAVIRT_PATCH(irq_enable)] = { lgstart_sti, lgend_sti },
+	[PARAVIRT_PATCH(restore_fl)] = { lgstart_popf, lgend_popf },
+	[PARAVIRT_PATCH(save_fl)] = { lgstart_pushf, lgend_pushf },
+};
+static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
+{
+	unsigned int insn_len;
+
+	/* Don't touch it if we don't have a replacement */
+	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
+		return paravirt_patch_default(type, clobber, insns, len);
+
+	insn_len = lguest_insns[type].end - lguest_insns[type].start;
+
+	/* Similarly if we can't fit replacement. */
+	if (len < insn_len)
+		return paravirt_patch_default(type, clobber, insns, len);
+
+	memcpy(insns, lguest_insns[type].start, insn_len);
+	return insn_len;
+}
+
+__init void lguest_init(void)
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
+	paravirt_ops.flush_tlb_user = lguest_flush_tlb_user;
+	paravirt_ops.flush_tlb_single = lguest_flush_tlb_single;
+	paravirt_ops.flush_tlb_kernel = lguest_flush_tlb_kernel;
+	paravirt_ops.set_pte = lguest_set_pte;
+	paravirt_ops.set_pte_at = lguest_set_pte_at;
+	paravirt_ops.set_pmd = lguest_set_pmd;
+#ifdef CONFIG_X86_LOCAL_APIC
+	paravirt_ops.apic_write = lguest_apic_write;
+	paravirt_ops.apic_write_atomic = lguest_apic_write;
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
+	paravirt_ops.write_gdt_entry = lguest_write_gdt_entry;
+	paravirt_ops.write_idt_entry = lguest_write_idt_entry;
+	paravirt_ops.patch = lguest_patch;
+	paravirt_ops.safe_halt = lguest_safe_halt;
+	paravirt_ops.get_wallclock = lguest_get_wallclock;
+	paravirt_ops.time_init = lguest_time_init;
+	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
+	paravirt_ops.wbinvd = lguest_wbinvd;
+	paravirt_ops.sched_clock = lguest_sched_clock;
+
+	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
+	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
+
+	/* We use top of mem for initial pagetables. */
+	init_pg_tables_end = __pa(pg0);
+
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
+
+	reserve_top_address(lguest_data.reserve_mem);
+
+	lockdep_init();
+
+	paravirt_disable_iospace();
+
+	cpu_detect(&new_cpu_data);
+	/* head.S usually sets up the first capability word, so do it here. */
+	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+
+	/* Math is always hard! */
+	new_cpu_data.hard_math = 1;
+
+#ifdef CONFIG_X86_MCE
+	mce_disabled = 1;
+#endif
+
+#ifdef CONFIG_ACPI
+	acpi_disabled = 1;
+	acpi_ht = 0;
+#endif
+
+	add_preferred_console("hvc", 0, NULL);
+
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
diff -puN /dev/null drivers/lguest/lguest_asm.S
--- /dev/null
+++ a/drivers/lguest/lguest_asm.S
@@ -0,0 +1,53 @@
+#include <linux/linkage.h>
+#include <linux/lguest.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+
+/* FIXME: Once asm/processor-flags.h goes in, include that */
+#define X86_EFLAGS_IF 0x00000200
+
+/*
+ * This is where we begin: we have a magic signature which the launcher looks
+ * for.  The plan is that the Linux boot protocol will be extended with a
+ * "platform type" field which will guide us here from the normal entry point,
+ * but for the moment this suffices.
+ *
+ * We put it in .init.text will be discarded after boot.
+ */
+.section .init.text, "ax", @progbits
+.ascii "GenuineLguest"
+	/* Set up initial stack. */
+ 	movl $(init_thread_union+THREAD_SIZE),%esp
+	jmp lguest_init
+
+/* The templates for inline patching. */
+#define LGUEST_PATCH(name, insns...)			\
+	lgstart_##name:	insns; lgend_##name:;		\
+	.globl lgstart_##name; .globl lgend_##name
+
+LGUEST_PATCH(cli, movl $0, lguest_data+LGUEST_DATA_irq_enabled)
+LGUEST_PATCH(sti, movl $X86_EFLAGS_IF, lguest_data+LGUEST_DATA_irq_enabled)
+LGUEST_PATCH(popf, movl %eax, lguest_data+LGUEST_DATA_irq_enabled)
+LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
+
+.text
+/* These demark the EIP range where host should never deliver interrupts. */
+.global lguest_noirq_start
+.global lguest_noirq_end
+
+/*
+ * We move eflags word to lguest_data.irq_enabled to restore interrupt state.
+ * For page faults, gpfs and virtual interrupts, the hypervisor has saved
+ * eflags manually, otherwise it was delivered directly and so eflags reflects
+ * the real machine IF state, ie. interrupts on.  Since the kernel always dies
+ * if it takes such a trap with interrupts disabled anyway, turning interrupts
+ * back on unconditionally here is OK.
+ */
+ENTRY(lguest_iret)
+	pushl	%eax
+	movl	12(%esp), %eax
+lguest_noirq_start:
+	movl	%eax,%ss:lguest_data+LGUEST_DATA_irq_enabled
+	popl	%eax
+	iret
+lguest_noirq_end:
diff -puN /dev/null drivers/lguest/lguest_bus.c
--- /dev/null
+++ a/drivers/lguest/lguest_bus.c
@@ -0,0 +1,148 @@
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/lguest_bus.h>
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
+int register_lguest_driver(struct lguest_driver *drv)
+{
+	if (!lguest_devices)
+		return 0;
+
+	drv->drv.bus = &lguest_bus.bus;
+	drv->drv.name = drv->name;
+	drv->drv.owner = drv->owner;
+	drv->drv.probe = lguest_dev_probe;
+
+	return driver_register(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(register_lguest_driver);
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
+	lguest_devices = lguest_map(max_pfn<<PAGE_SHIFT, 1);
+
+	if (bus_register(&lguest_bus.bus) != 0
+	    || device_register(&lguest_bus.dev) != 0)
+		panic("lguest bus registration failed");
+
+	scan_devices();
+	return 0;
+}
+postcore_initcall(lguest_bus_init);
diff -puN /dev/null include/linux/lguest.h
--- /dev/null
+++ a/include/linux/lguest.h
@@ -0,0 +1,85 @@
+/* Things the lguest guest needs to know.  Note: like all lguest interfaces,
+ * this is subject to wild and random change between versions. */
+#ifndef _ASM_LGUEST_H
+#define _ASM_LGUEST_H
+
+/* These are randomly chosen numbers which indicate we're an lguest at boot */
+#define LGUEST_MAGIC_EBP 0x4C687970
+#define LGUEST_MAGIC_EDI 0x652D4D65
+#define LGUEST_MAGIC_ESI 0xFFFFFFFF
+
+#ifndef __ASSEMBLY__
+#include <asm/irq.h>
+
+#define LHCALL_FLUSH_ASYNC	0
+#define LHCALL_LGUEST_INIT	1
+#define LHCALL_CRASH		2
+#define LHCALL_LOAD_GDT		3
+#define LHCALL_NEW_PGTABLE	4
+#define LHCALL_FLUSH_TLB	5
+#define LHCALL_LOAD_IDT_ENTRY	6
+#define LHCALL_SET_STACK	7
+#define LHCALL_TS		8
+#define LHCALL_TIMER_READ	9
+#define LHCALL_HALT		10
+#define LHCALL_GET_WALLCLOCK	11
+#define LHCALL_BIND_DMA		12
+#define LHCALL_SEND_DMA		13
+#define LHCALL_SET_PTE		14
+#define LHCALL_SET_PMD		15
+#define LHCALL_LOAD_TLS		16
+
+#define LGUEST_TRAP_ENTRY 0x1F
+
+static inline unsigned long
+hcall(unsigned long call,
+      unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	asm volatile("int $" __stringify(LGUEST_TRAP_ENTRY)
+		     : "=a"(call)
+		     : "a"(call), "d"(arg1), "b"(arg2), "c"(arg3)
+		     : "memory");
+	return call;
+}
+
+void async_hcall(unsigned long call,
+		 unsigned long arg1, unsigned long arg2, unsigned long arg3);
+
+/* Can't use our min() macro here: needs to be a constant */
+#define LGUEST_IRQS (NR_IRQS < 32 ? NR_IRQS: 32)
+
+#define LHCALL_RING_SIZE 64
+struct hcall_ring
+{
+	u32 eax, edx, ebx, ecx;
+};
+
+/* All the good stuff happens here: guest registers it with LGUEST_INIT */
+struct lguest_data
+{
+/* Fields which change during running: */
+	/* 512 == enabled (same as eflags) */
+	unsigned int irq_enabled;
+	/* Interrupts blocked by guest. */
+	DECLARE_BITMAP(blocked_interrupts, LGUEST_IRQS);
+
+	/* Virtual address of page fault. */
+	unsigned long cr2;
+
+	/* Async hypercall ring.  0xFF == done, 0 == pending. */
+	u8 hcall_status[LHCALL_RING_SIZE];
+	struct hcall_ring hcalls[LHCALL_RING_SIZE];
+
+/* Fields initialized by the hypervisor at boot: */
+	/* Memory not to try to access */
+	unsigned long reserve_mem;
+	/* ID of this guest (used by network driver to set ethernet address) */
+	u16 guestid;
+
+/* Fields initialized by the guest at boot: */
+	/* Instruction range to suppress interrupts even if enabled */
+	unsigned long noirq_start, noirq_end;
+};
+extern struct lguest_data lguest_data;
+#endif /* __ASSEMBLY__ */
+#endif	/* _ASM_LGUEST_H */
diff -puN /dev/null include/linux/lguest_bus.h
--- /dev/null
+++ a/include/linux/lguest_bus.h
@@ -0,0 +1,48 @@
+#ifndef _ASM_LGUEST_DEVICE_H
+#define _ASM_LGUEST_DEVICE_H
+/* Everything you need to know about lguest devices. */
+#include <linux/device.h>
+#include <linux/lguest.h>
+#include <linux/lguest_launcher.h>
+
+struct lguest_device {
+	/* Unique busid, and index into lguest_page->devices[] */
+	unsigned int index;
+
+	struct device dev;
+
+	/* Driver can hang data off here. */
+	void *private;
+};
+
+/* By convention, each device can use irq index+1 if it wants to. */
+static inline int lgdev_irq(const struct lguest_device *dev)
+{
+	return dev->index + 1;
+}
+
+/* dma args must not be vmalloced! */
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma);
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq);
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas);
+
+/* Map the virtual device space */
+void *lguest_map(unsigned long phys_addr, unsigned long pages);
+void lguest_unmap(void *);
+
+struct lguest_driver {
+	const char *name;
+	struct module *owner;
+	u16 device_type;
+	int (*probe)(struct lguest_device *dev);
+	void (*remove)(struct lguest_device *dev);
+
+	struct device_driver drv;
+};
+
+extern int register_lguest_driver(struct lguest_driver *drv);
+extern void unregister_lguest_driver(struct lguest_driver *drv);
+
+extern struct lguest_device_desc *lguest_devices; /* Just past max_pfn */
+#endif /* _ASM_LGUEST_DEVICE_H */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
