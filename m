From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-lgko.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:30 -0700
Message-ID: <200703292314.l2TNEUwE014701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42332 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934364AbXC2XOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: the host code (lg.ko).
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-lgko.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: the host code (lg.ko).
From: Rusty Russell <rusty@rustcorp.com.au>

This is the host module (lg.ko) which supports lguest:

arch/i386/lguest/hypervisor.S:
	The actual guest <-> host switching code.  This is compiled into
	a C array, which is mapped to 0xFFC01000 in host and guests.

arch/i386/lguest/core.c:
	The core of the hypervisor, which calls into the assembler
	code which does this actual switch.  Also contains helper
	routines.

arch/i386/lguest/hypercalls.c:
	The entry point for the 19 hypercalls.

arch/i386/lguest/interrupts_and_traps.c:
	Handling of interrupts and traps, except page faults.

arch/i386/lguest/io.c:
	I/O from guest to host, and between guests.

arch/i386/lguest/lguest_user.c:
	/dev/lguest interface for lguest program to launch/control guests.

arch/i386/lguest/page_tables.c:
	Shadow Page table handling: generally we build up the shadow
	page tables by converting from guest page tables when a fault occurs.

arch/i386/lguest/segments.c:
	Segmentation (GDT) handling: we have to ensure they're trimmed
	to avoid guest access to the switching code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/core.c                 |  443 ++++++++++++++++++++++
 arch/i386/lguest/hypercalls.c           |  186 +++++++++
 arch/i386/lguest/hypervisor.S           |  162 ++++++++
 arch/i386/lguest/interrupts_and_traps.c |  230 +++++++++++
 arch/i386/lguest/io.c                   |  413 ++++++++++++++++++++
 arch/i386/lguest/lg.h                   |    8 
 arch/i386/lguest/lguest_user.c          |  241 +++++++++++
 arch/i386/lguest/page_tables.c          |  383 +++++++++++++++++++
 arch/i386/lguest/segments.c             |  171 ++++++++
 9 files changed, 2231 insertions(+), 6 deletions(-)

diff -puN /dev/null arch/i386/lguest/core.c
--- /dev/null
+++ a/arch/i386/lguest/core.c
@@ -0,0 +1,443 @@
+/* World's simplest hypervisor, to test paravirt_ops and show
+ * unbelievers that virtualization is the future.  Plus, it's fun! */
+#include <linux/module.h>
+#include <linux/stringify.h>
+#include <linux/stddef.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/cpu.h>
+#include <linux/freezer.h>
+#include <asm/lguest.h>
+#include <asm/paravirt.h>
+#include <asm/desc.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/poll.h>
+#include <asm/highmem.h>
+#include <asm/asm-offsets.h>
+#include <asm/i387.h>
+#include "lg.h"
+
+/* This is our hypervisor, compiled from hypervisor.S. */
+static char __initdata hypervisor_blob[] = {
+#include "hypervisor-blob.c"
+};
+
+/* 64k ought to be enough for anybody! */
+#define HYPERVISOR_PAGES (65536 / PAGE_SIZE)
+
+#define MAX_LGUEST_GUESTS						\
+	(((HYPERVISOR_PAGES * PAGE_SIZE) - sizeof(hypervisor_blob))	\
+	 / sizeof(struct lguest_state))
+
+static struct vm_struct *hypervisor_vma;
+/* Pages for hypervisor itself */
+static struct page *hype_page[HYPERVISOR_PAGES];
+static int cpu_had_pge;
+static struct {
+	unsigned long offset;
+	unsigned short segment;
+} lguest_entry __attribute_used__;
+struct lguest lguests[MAX_LGUEST_GUESTS];
+DEFINE_MUTEX(lguest_lock);
+
+/* IDT entries are at start of hypervisor. */
+const unsigned long *__lguest_default_idt_entries(void)
+{
+	return (void *)HYPE_ADDR;
+}
+
+/* Next is switch_to_guest */
+static void *__lguest_switch_to_guest(void)
+{
+	return (void *)HYPE_ADDR + HYPE_DATA_SIZE;
+}
+
+/* Then we use everything else to hold guest state. */
+struct lguest_state *__lguest_states(void)
+{
+	return (void *)HYPE_ADDR + sizeof(hypervisor_blob);
+}
+
+static __init int map_hypervisor(void)
+{
+	int i, err;
+	struct page **pagep = hype_page;
+
+	for (i = 0; i < ARRAY_SIZE(hype_page); i++) {
+		unsigned long addr = get_zeroed_page(GFP_KERNEL);
+		if (!addr) {
+			err = -ENOMEM;
+			goto free_some_pages;
+		}
+		hype_page[i] = virt_to_page(addr);
+	}
+
+	hypervisor_vma = __get_vm_area(ARRAY_SIZE(hype_page) * PAGE_SIZE,
+				       VM_ALLOC, HYPE_ADDR, VMALLOC_END);
+	if (!hypervisor_vma) {
+		err = -ENOMEM;
+		printk("lguest: could not map hypervisor pages high\n");
+		goto free_pages;
+	}
+
+	err = map_vm_area(hypervisor_vma, PAGE_KERNEL, &pagep);
+	if (err) {
+		printk("lguest: map_vm_area failed: %i\n", err);
+		goto free_vma;
+	}
+	memcpy(hypervisor_vma->addr, hypervisor_blob, sizeof(hypervisor_blob));
+
+	/* Setup LGUEST segments on all cpus */
+	for_each_possible_cpu(i) {
+		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+	}
+
+	/* Initialize entry point into hypervisor. */
+	lguest_entry.offset = (long)__lguest_switch_to_guest();
+	lguest_entry.segment = LGUEST_CS;
+
+	printk("lguest: mapped hypervisor at %p\n", hypervisor_vma->addr);
+	return 0;
+
+free_vma:
+	vunmap(hypervisor_vma->addr);
+free_pages:
+	i = ARRAY_SIZE(hype_page);
+free_some_pages:
+	for (--i; i >= 0; i--)
+		__free_pages(hype_page[i], 0);
+	return err;
+}
+
+static __exit void unmap_hypervisor(void)
+{
+	unsigned int i;
+
+	vunmap(hypervisor_vma->addr);
+	for (i = 0; i < ARRAY_SIZE(hype_page); i++)
+		__free_pages(hype_page[i], 0);
+}
+
+/* IN/OUT insns: enough to get us past boot-time probing. */
+static int emulate_insn(struct lguest *lg)
+{
+	u8 insn;
+	unsigned int insnlen = 0, in = 0, shift = 0;
+	unsigned long physaddr = guest_pa(lg, lg->state->regs.eip);
+
+	/* This only works for addresses in linear mapping... */
+	if (lg->state->regs.eip < lg->page_offset)
+		return 0;
+	lhread(lg, &insn, physaddr, 1);
+
+	/* Operand size prefix means it's actually for ax. */
+	if (insn == 0x66) {
+		shift = 16;
+		insnlen = 1;
+		lhread(lg, &insn, physaddr + insnlen, 1);
+	}
+
+	switch (insn & 0xFE) {
+	case 0xE4: /* in     <next byte>,%al */
+		insnlen += 2;
+		in = 1;
+		break;
+	case 0xEC: /* in     (%dx),%al */
+		insnlen += 1;
+		in = 1;
+		break;
+	case 0xE6: /* out    %al,<next byte> */
+		insnlen += 2;
+		break;
+	case 0xEE: /* out    %al,(%dx) */
+		insnlen += 1;
+		break;
+	default:
+		return 0;
+	}
+
+	if (in) {
+		/* Lower bit tells is whether it's a 16 or 32 bit access */
+		if (insn & 0x1)
+			lg->state->regs.eax = 0xFFFFFFFF;
+		else
+			lg->state->regs.eax |= (0xFFFF << shift);
+	}
+	lg->state->regs.eip += insnlen;
+	return 1;
+}
+
+int find_free_guest(void)
+{
+	unsigned int i;
+	for (i = 0; i < MAX_LGUEST_GUESTS; i++)
+		if (!lguests[i].state)
+			return i;
+	return -1;
+}
+
+int lguest_address_ok(const struct lguest *lg, unsigned long addr)
+{
+	return addr / PAGE_SIZE < lg->pfn_limit;
+}
+
+/* Just like get_user, but don't let guest access lguest binary. */
+u32 lhread_u32(struct lguest *lg, u32 addr)
+{
+	u32 val = 0;
+
+	/* Don't let them access lguest_add */
+	if (!lguest_address_ok(lg, addr)
+	    || get_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad read address %u", addr);
+	return val;
+}
+
+void lhwrite_u32(struct lguest *lg, u32 addr, u32 val)
+{
+	if (!lguest_address_ok(lg, addr)
+	    || put_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad write address %u", addr);
+}
+
+void lhread(struct lguest *lg, void *b, u32 addr, unsigned bytes)
+{
+	if (addr + bytes < addr || !lguest_address_ok(lg, addr+bytes)
+	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
+		/* copy_from_user should do this, but as we rely on it... */
+		memset(b, 0, bytes);
+		kill_guest(lg, "bad read address %u len %u", addr, bytes);
+	}
+}
+
+void lhwrite(struct lguest *lg, u32 addr, const void *b, unsigned bytes)
+{
+	if (addr + bytes < addr
+	    || !lguest_address_ok(lg, addr+bytes)
+	    || copy_to_user((void __user *)addr, b, bytes) != 0)
+		kill_guest(lg, "bad write address %u len %u", addr, bytes);
+}
+
+/* Saves exporting idt_table from kernel */
+static struct desc_struct *get_idt_table(void)
+{
+	struct Xgt_desc_struct idt;
+
+	asm("sidt %0":"=m" (idt));
+	return (void *)idt.address;
+}
+
+static int usermode(struct lguest_regs *regs)
+{
+	return (regs->cs & SEGMENT_RPL_MASK) == USER_RPL;
+}
+
+/* Trap page resets this when it reloads gs. */
+static int new_gfp_eip(struct lguest *lg, struct lguest_regs *regs)
+{
+	u32 eip;
+	get_user(eip, &lg->lguest_data->gs_gpf_eip);
+	if (eip == regs->eip)
+		return 0;
+	put_user(regs->eip, &lg->lguest_data->gs_gpf_eip);
+	return 1;
+}
+
+static void set_ts(unsigned int guest_ts)
+{
+	u32 cr0;
+	if (guest_ts) {
+		asm("movl %%cr0,%0":"=r" (cr0));
+		if (!(cr0 & 8))
+			asm("movl %0,%%cr0": :"r" (cr0|8));
+	}
+}
+
+static void run_guest_once(struct lguest *lg)
+{
+	unsigned int clobber;
+
+	/* Put eflags on stack, lcall does rest: suitable for iret return. */
+	asm volatile("pushf; lcall *lguest_entry"
+		     : "=a"(clobber), "=d"(clobber), "=b"(clobber)
+		     : "0"(lg->state), "1"(get_idt_table()), "2"(lg->cr3)
+		     : "memory", "%ecx", "%edi", "%esi");
+}
+
+int run_guest(struct lguest *lg, char *__user user)
+{
+	struct lguest_regs *regs = &lg->state->regs;
+
+	while (!lg->dead) {
+		unsigned int cr2 = 0; /* Damn gcc */
+
+		/* Hypercalls first: we might have been out to userspace */
+		if (do_async_hcalls(lg))
+			goto pending_dma;
+
+		if (regs->trapnum == LGUEST_TRAP_ENTRY) {
+			/* Only do hypercall once. */
+			regs->trapnum = 255;
+			if (hypercall(lg, regs))
+				goto pending_dma;
+		}
+
+		if (signal_pending(current))
+			return -EINTR;
+		maybe_do_interrupt(lg);
+
+		try_to_freeze();
+
+		if (lg->dead)
+			break;
+
+		if (lg->halted) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(1);
+			continue;
+		}
+
+		/* Restore limits on TLS segments if in user mode. */
+		if (usermode(regs)) {
+			unsigned int i;
+			for (i = 0; i < ARRAY_SIZE(lg->tls_limits); i++)
+				lg->state->gdt_table[GDT_ENTRY_TLS_MIN+i].a
+					|= lg->tls_limits[i];
+		}
+
+		local_irq_disable();
+		map_trap_page(lg);
+
+		/* Host state to be restored after the guest returns. */
+		asm("sidt %0":"=m"(lg->state->host.idt));
+		lg->state->host.gdt = __get_cpu_var(cpu_gdt_descr);
+
+		/* Even if *we* don't want FPU trap, guest might... */
+		set_ts(lg->ts);
+
+		run_guest_once(lg);
+
+		/* Save cr2 now if we page-faulted. */
+		if (regs->trapnum == 14)
+			asm("movl %%cr2,%0" :"=r" (cr2));
+		else if (regs->trapnum == 7)
+			math_state_restore();
+		local_irq_enable();
+
+		switch (regs->trapnum) {
+		case 13: /* We've intercepted a GPF. */
+			if (regs->errcode == 0) {
+				if (emulate_insn(lg))
+					continue;
+
+				/* FIXME: If it's reloading %gs in a loop? */
+				if (usermode(regs) && new_gfp_eip(lg,regs))
+					continue;
+			}
+
+			if (reflect_trap(lg, &lg->gpf_trap, 1))
+				continue;
+			break;
+		case 14: /* We've intercepted a page fault. */
+			if (demand_page(lg, cr2, regs->errcode & 2))
+				continue;
+
+			/* If lguest_data is NULL, this won't hurt. */
+			put_user(cr2, &lg->lguest_data->cr2);
+			if (reflect_trap(lg, &lg->page_trap, 1))
+				continue;
+			kill_guest(lg, "unhandled page fault at %#x"
+				   " (eip=%#x, errcode=%#x)",
+				   cr2, regs->eip, regs->errcode);
+			break;
+		case 7: /* We've intercepted a Device Not Available fault. */
+			/* If they don't want to know, just absorb it. */
+			if (!lg->ts)
+				continue;
+			if (reflect_trap(lg, &lg->fpu_trap, 0))
+				continue;
+			kill_guest(lg, "unhandled FPU fault at %#x",
+				   regs->eip);
+			break;
+		case 32 ... 255: /* Real interrupt, fall thru */
+			cond_resched();
+		case LGUEST_TRAP_ENTRY: /* Handled at top of loop */
+			continue;
+		case 6: /* Invalid opcode before they installed handler */
+			check_bug_kill(lg);
+		}
+		kill_guest(lg,"unhandled trap %i at %#x (err=%i)",
+			   regs->trapnum, regs->eip, regs->errcode);
+	}
+	return -ENOENT;
+
+pending_dma:
+	put_user(lg->pending_dma, (unsigned long *)user);
+	put_user(lg->pending_addr, (unsigned long *)user+1);
+	return sizeof(unsigned long)*2;
+}
+
+#define STRUCT_LGUEST_ELEM_SIZE(elem) sizeof(((struct lguest_state *)0)->elem)
+
+static void adjust_pge(void *on)
+{
+	if (on)
+		write_cr4(read_cr4() | X86_CR4_PGE);
+	else
+		write_cr4(read_cr4() & ~X86_CR4_PGE);
+}
+
+static int __init init(void)
+{
+	int err;
+
+	if (paravirt_enabled())
+		return -EPERM;
+
+	err = map_hypervisor();
+	if (err)
+		return err;
+
+	err = init_pagetables(hype_page, HYPERVISOR_PAGES);
+	if (err) {
+		unmap_hypervisor();
+		return err;
+	}
+	lguest_io_init();
+
+	err = lguest_device_init();
+	if (err) {
+		free_pagetables();
+		unmap_hypervisor();
+		return err;
+	}
+	lock_cpu_hotplug();
+	if (cpu_has_pge) { /* We have a broader idea of "global". */
+		cpu_had_pge = 1;
+		on_each_cpu(adjust_pge, 0, 0, 1);
+		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
+	}
+	unlock_cpu_hotplug();
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	lguest_device_remove();
+	free_pagetables();
+	unmap_hypervisor();
+	lock_cpu_hotplug();
+	if (cpu_had_pge) {
+		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
+		on_each_cpu(adjust_pge, (void *)1, 0, 1);
+	}
+	unlock_cpu_hotplug();
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
diff -puN /dev/null arch/i386/lguest/hypercalls.c
--- /dev/null
+++ a/arch/i386/lguest/hypercalls.c
@@ -0,0 +1,186 @@
+/*  Actual hypercalls, which allow guests to actually do something.
+    Copyright (C) 2006 Rusty Russell IBM Corporation
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+*/
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/mm.h>
+#include <asm/lguest.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <irq_vectors.h>
+#include "lg.h"
+
+static void guest_set_stack(struct lguest *lg,
+			    u32 seg, u32 esp, unsigned int pages)
+{
+	/* You cannot have a stack segment with priv level 0. */
+	if ((seg & 0x3) != GUEST_DPL)
+		kill_guest(lg, "bad stack segment %i", seg);
+	if (pages > 2)
+		kill_guest(lg, "bad stack pages %u", pages);
+	lg->state->tss.ss1 = seg;
+	lg->state->tss.esp1 = esp;
+	lg->stack_pages = pages;
+	pin_stack_pages(lg);
+}
+
+/* Return true if DMA to host userspace now pending. */
+static int do_hcall(struct lguest *lg, struct lguest_regs *regs)
+{
+	switch (regs->eax) {
+	case LHCALL_FLUSH_ASYNC:
+		break;
+	case LHCALL_LGUEST_INIT:
+		kill_guest(lg, "already have lguest_data");
+		break;
+	case LHCALL_CRASH: {
+		char msg[128];
+		lhread(lg, msg, regs->edx, sizeof(msg));
+		msg[sizeof(msg)-1] = '\0';
+		kill_guest(lg, "CRASH: %s", msg);
+		break;
+	}
+	case LHCALL_LOAD_GDT:
+		load_guest_gdt(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_NEW_PGTABLE:
+		guest_new_pagetable(lg, regs->edx);
+		break;
+	case LHCALL_FLUSH_TLB:
+		if (regs->edx)
+			guest_pagetable_clear_all(lg);
+		else
+			guest_pagetable_flush_user(lg);
+		break;
+	case LHCALL_LOAD_IDT_ENTRY:
+		load_guest_idt_entry(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_SET_STACK:
+		guest_set_stack(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_TS:
+		lg->ts = regs->edx;
+		break;
+	case LHCALL_TIMER_READ: {
+		u32 now = jiffies;
+		mb();
+		regs->eax = now - lg->last_timer;
+		lg->last_timer = now;
+		break;
+	}
+	case LHCALL_TIMER_START:
+		lg->timer_on = 1;
+		if (regs->edx != HZ)
+			kill_guest(lg, "Bad clock speed %i", regs->edx);
+		lg->last_timer = jiffies;
+		break;
+	case LHCALL_HALT:
+		lg->halted = 1;
+		break;
+	case LHCALL_GET_WALLCLOCK: {
+		struct timeval tv;
+		do_gettimeofday(&tv);
+		regs->eax = tv.tv_sec;
+		break;
+	}
+	case LHCALL_BIND_DMA:
+		regs->eax = bind_dma(lg, regs->edx, regs->ebx,
+				     regs->ecx >> 8, regs->ecx & 0xFF);
+		break;
+	case LHCALL_SEND_DMA:
+		return send_dma(lg, regs->edx, regs->ebx);
+	case LHCALL_SET_PTE:
+		guest_set_pte(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_SET_UNKNOWN_PTE:
+		guest_pagetable_clear_all(lg);
+		break;
+	case LHCALL_SET_PUD:
+		guest_set_pud(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_TLS:
+		guest_load_tls(lg, (struct desc_struct __user*)regs->edx);
+		break;
+	default:
+		kill_guest(lg, "Bad hypercall %i\n", regs->eax);
+	}
+	return 0;
+}
+
+/* We always do queued calls before actual hypercall. */
+int do_async_hcalls(struct lguest *lg)
+{
+	unsigned int i, pending;
+	u8 st[LHCALL_RING_SIZE];
+
+	if (!lg->lguest_data)
+		return 0;
+
+	copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st));
+	for (i = 0; i < ARRAY_SIZE(st); i++) {
+		struct lguest_regs regs;
+		unsigned int n = lg->next_hcall;
+
+		if (st[n] == 0xFF)
+			break;
+
+		if (++lg->next_hcall == LHCALL_RING_SIZE)
+			lg->next_hcall = 0;
+
+		get_user(regs.eax, &lg->lguest_data->hcalls[n].eax);
+		get_user(regs.edx, &lg->lguest_data->hcalls[n].edx);
+		get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx);
+		get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx);
+		pending = do_hcall(lg, &regs);
+		put_user(0xFF, &lg->lguest_data->hcall_status[n]);
+		if (pending)
+			return 1;
+	}
+
+	set_wakeup_process(lg, NULL);
+	return 0;
+}
+
+int hypercall(struct lguest *lg, struct lguest_regs *regs)
+{
+	int pending;
+
+	if (!lg->lguest_data) {
+		if (regs->eax != LHCALL_LGUEST_INIT) {
+			kill_guest(lg, "hypercall %i before LGUEST_INIT",
+				   regs->eax);
+			return 0;
+		}
+
+		lg->lguest_data = (struct lguest_data __user *)regs->edx;
+		/* We check here so we can simply copy_to_user/from_user */
+		if (!lguest_address_ok(lg, (long)lg->lguest_data)
+		    || !lguest_address_ok(lg, (long)(lg->lguest_data+1))){
+			kill_guest(lg, "bad guest page %p", lg->lguest_data);
+			return 0;
+		}
+		get_user(lg->noirq_start, &lg->lguest_data->noirq_start);
+		get_user(lg->noirq_end, &lg->lguest_data->noirq_end);
+		/* We reserve the top pgd entry. */
+		put_user(4U*1024*1024, &lg->lguest_data->reserve_mem);
+		put_user(lg->guestid, &lg->lguest_data->guestid);
+		return 0;
+	}
+	pending = do_hcall(lg, regs);
+	set_wakeup_process(lg, NULL);
+	return pending;
+}
diff -puN /dev/null arch/i386/lguest/hypervisor.S
--- /dev/null
+++ a/arch/i386/lguest/hypervisor.S
@@ -0,0 +1,162 @@
+/* This code sits at 0xFFFF1000 to do the low-level guest<->host switch.
+   Layout is: default_idt_entries (1k), then switch_to_guest entry point. */
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include "lg.h"
+
+.text
+ENTRY(_start) /* ld complains unless _start is defined. */
+/* %eax contains ptr to target guest state, %edx contains host idt.
+   %ebx contains cr3 value.  All normal registers can be clobbered! */
+switch_to_guest:
+	pushl	%es
+	pushl	%ds
+	pushl	%fs
+	pushl	%gs
+	pushl	%edx
+	pushl	%ebp
+	/* Save old stack, switch to guest's stack. */
+	movl	%esp, LGUEST_STATE_host_stackptr(%eax)
+	movl	%eax, %esp
+	/* Guest registers will be at: %esp-$LGUEST_STATE_regs */
+	addl	$LGUEST_STATE_regs, %esp
+	/* Switch to guest's GDT, IDT. */
+	lgdt	LGUEST_STATE_gdt(%eax)
+	lidt	LGUEST_STATE_idt(%eax)
+	/* Save page table top. */
+	movl	%cr3, %ecx
+	movl	%ecx, LGUEST_STATE_host_pgdir(%eax)
+	/* Set host's TSS to available (clear byte 5 bit 2). */
+	movl	(LGUEST_STATE_host_gdt+2)(%eax), %ecx
+	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%ecx)
+	/* Switch to guest page tables */
+	movl	%ebx, %cr3
+	/* Switch to guest's TSS. */
+	movl	$(GDT_ENTRY_TSS*8), %edx
+	ltr	%dx
+	/* Restore guest regs */
+	popl	%ebx
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+	popl	%edi
+	popl	%ebp
+	popl	%gs
+	/* Now we've loaded gs, neuter the TLS entries down to 1 byte/page */
+	addl	$(LGUEST_STATE_gdt_table+GDT_ENTRY_TLS_MIN*8), %eax
+	movw	$0,(%eax)
+	movw	$0,8(%eax)
+	movw	$0,16(%eax)
+	popl	%eax
+	popl	%fs
+	popl	%ds
+	popl	%es
+	/* Skip error code and trap number */
+	addl	$8, %esp
+	iret
+
+#define SWITCH_TO_HOST							\
+	/* Save guest state */						\
+	pushl	%es;							\
+	pushl	%ds;							\
+	pushl	%fs;							\
+	pushl	%eax;							\
+	pushl	%gs;							\
+	pushl	%ebp;							\
+	pushl	%edi;							\
+	pushl	%esi;							\
+	pushl	%edx;							\
+	pushl	%ecx;							\
+	pushl	%ebx;							\
+	/* Load lguest ds segment for convenience. */			\
+	movl	$(LGUEST_DS), %eax;					\
+	movl	%eax, %ds;						\
+	/* Now figure out who we are */					\
+	movl	%esp, %eax;						\
+	subl	$LGUEST_STATE_regs, %eax;				\
+	/* Switch to host page tables (GDT, IDT and stack are in host   \
+	   mem, so need this first) */					\
+	movl	LGUEST_STATE_host_pgdir(%eax), %ebx;			\
+	movl	%ebx, %cr3;						\
+	/* Set guest's TSS to available (clear byte 5 bit 2). */	\
+	andb	$0xFD, (LGUEST_STATE_gdt_table+GDT_ENTRY_TSS*8+5)(%eax);\
+	/* Switch to host's GDT & IDT. */				\
+	lgdt	LGUEST_STATE_host_gdt(%eax);				\
+	lidt	LGUEST_STATE_host_idt(%eax);				\
+	/* Switch to host's stack. */					\
+	movl	LGUEST_STATE_host_stackptr(%eax), %esp;			\
+	/* Switch to host's TSS */					\
+	movl	$(GDT_ENTRY_TSS*8), %ebx;				\
+	ltr	%bx;							\
+	/* Restore host regs */						\
+	popl	%ebp;							\
+	popl	%edx;							\
+	popl	%gs;							\
+	popl	%fs;							\
+	popl	%ds;							\
+	popl	%es
+
+/* Return to run_guest_once. */
+return_to_host:
+	SWITCH_TO_HOST
+	iret
+
+deliver_to_host:
+	SWITCH_TO_HOST
+decode_idt_and_jmp:
+	/* Decode IDT and jump to hosts' irq handler.  When that does iret, it
+	 * will return to run_guest_once.  This is a feature. */
+	/* We told gcc we'd clobber edx and eax... */
+	movl	LGUEST_STATE_trapnum(%eax), %eax
+	leal	(%edx,%eax,8), %eax
+	movzwl	(%eax),%edx
+	movl	4(%eax), %eax
+	xorw	%ax, %ax
+	orl	%eax, %edx
+	jmp	*%edx
+
+deliver_to_host_with_errcode:
+	SWITCH_TO_HOST
+	pushl	LGUEST_STATE_errcode(%eax)
+	jmp decode_idt_and_jmp
+
+/* Real hardware interrupts are delivered straight to the host.  Others
+   cause us to return to run_guest_once so it can decide what to do.  Note
+   that some of these are overridden by the guest to deliver directly, and
+   never enter here (see load_guest_idt_entry). */
+.macro IRQ_STUB N TARGET
+	.data; .long 1f; .text; 1:
+ /* Make an error number for most traps, which don't have one. */
+ .if (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
+	pushl	$0
+ .endif
+	pushl	$\N
+	jmp	\TARGET
+	ALIGN
+.endm
+
+.macro IRQ_STUBS FIRST LAST TARGET
+ irq=\FIRST
+ .rept \LAST-\FIRST+1
+	IRQ_STUB irq \TARGET
+  irq=irq+1
+ .endr
+.endm
+
+/* We intercept every interrupt, because we may need to switch back to
+ * host.  Unfortunately we can't tell them apart except by entry
+ * point, so we need 256 entry points.
+ */
+irq_stubs:
+.data
+default_idt_entries:
+.text
+	IRQ_STUBS 0 1 return_to_host		/* First two traps */
+	IRQ_STUB 2 deliver_to_host_with_errcode	/* NMI */
+	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
+	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
+	IRQ_STUB 128 return_to_host		/* System call (overridden) */
+	IRQ_STUBS 129 255 deliver_to_host	/* Other real interrupts */
+
+/* Everything after this is used for the lguest_state structs. */
+ALIGN
diff -puN /dev/null arch/i386/lguest/interrupts_and_traps.c
--- /dev/null
+++ a/arch/i386/lguest/interrupts_and_traps.c
@@ -0,0 +1,230 @@
+#include <linux/uaccess.h>
+#include "lg.h"
+
+static void push_guest_stack(struct lguest *lg, u32 __user **gstack, u32 val)
+{
+	lhwrite_u32(lg, (u32)--(*gstack), val);
+}
+
+int reflect_trap(struct lguest *lg, const struct host_trap *trap, int has_err)
+{
+	u32 __user *gstack;
+	u32 eflags, ss, irq_enable;
+	struct lguest_regs *regs = &lg->state->regs;
+
+	if (!trap->addr)
+		return 0;
+
+	/* If they want a ring change, we use new stack and push old ss/esp */
+	if ((regs->ss&0x3) != GUEST_DPL) {
+		gstack = (u32 __user *)guest_pa(lg, lg->state->tss.esp1);
+		ss = lg->state->tss.ss1;
+		push_guest_stack(lg, &gstack, regs->ss);
+		push_guest_stack(lg, &gstack, regs->esp);
+	} else {
+		gstack = (u32 __user *)guest_pa(lg, regs->esp);
+		ss = regs->ss;
+	}
+
+	/* We use IF bit in eflags to indicate whether irqs were disabled
+	   (it's always 0, since irqs are enabled when guest is running). */
+	eflags = regs->eflags;
+	get_user(irq_enable, &lg->lguest_data->irq_enabled);
+	eflags |= (irq_enable & 512);
+
+	push_guest_stack(lg, &gstack, eflags);
+	push_guest_stack(lg, &gstack, regs->cs);
+	push_guest_stack(lg, &gstack, regs->eip);
+
+	if (has_err)
+		push_guest_stack(lg, &gstack, regs->errcode);
+
+	/* Change the real stack so hypervisor returns to trap handler */
+	regs->ss = ss;
+	regs->esp = (u32)gstack + lg->page_offset;
+	regs->cs = (__KERNEL_CS|GUEST_DPL);
+	regs->eip = trap->addr;
+
+	/* GS will be neutered on way back to guest. */
+	put_user(0, &lg->lguest_data->gs_gpf_eip);
+
+	/* Disable interrupts for an interrupt gate. */
+	if (trap->disable_interrupts)
+		put_user(0, &lg->lguest_data->irq_enabled);
+	return 1;
+}
+
+void maybe_do_interrupt(struct lguest *lg)
+{
+	unsigned int irq;
+	DECLARE_BITMAP(irqs, LGUEST_IRQS);
+
+	if (!lg->lguest_data)
+		return;
+
+	/* If timer has changed, set timer interrupt. */
+	if (lg->timer_on && jiffies != lg->last_timer)
+		set_bit(0, lg->irqs_pending);
+
+	/* Mask out any interrupts they have blocked. */
+	copy_from_user(&irqs, lg->lguest_data->interrupts, sizeof(irqs));
+	bitmap_andnot(irqs, lg->irqs_pending, irqs, LGUEST_IRQS);
+
+	irq = find_first_bit(irqs, LGUEST_IRQS);
+	if (irq >= LGUEST_IRQS)
+		return;
+
+	/* If they're halted, we re-enable interrupts. */
+	if (lg->halted) {
+		/* Re-enable interrupts. */
+		put_user(512, &lg->lguest_data->irq_enabled);
+		lg->halted = 0;
+	} else {
+		/* Maybe they have interrupts disabled? */
+		u32 irq_enabled;
+		get_user(irq_enabled, &lg->lguest_data->irq_enabled);
+		if (!irq_enabled)
+			return;
+	}
+
+	if (lg->interrupt[irq].addr != 0) {
+		clear_bit(irq, lg->irqs_pending);
+		reflect_trap(lg, &lg->interrupt[irq], 0);
+	}
+}
+
+void check_bug_kill(struct lguest *lg)
+{
+#ifdef CONFIG_BUG
+	u32 eip = lg->state->regs.eip - PAGE_OFFSET;
+	u16 insn;
+
+	/* This only works for addresses in linear mapping... */
+	if (lg->state->regs.eip < PAGE_OFFSET)
+		return;
+	lhread(lg, &insn, eip, sizeof(insn));
+	if (insn == 0x0b0f) {
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+		u16 l;
+		u32 f;
+		char file[128];
+		lhread(lg, &l, eip+sizeof(insn), sizeof(l));
+		lhread(lg, &f, eip+sizeof(insn)+sizeof(l), sizeof(f));
+		lhread(lg, file, f - PAGE_OFFSET, sizeof(file));
+		file[sizeof(file)-1] = 0;
+		kill_guest(lg, "BUG() at %#x %s:%u", eip, file, l);
+#else
+		kill_guest(lg, "BUG() at %#x", eip);
+#endif	/* CONFIG_DEBUG_BUGVERBOSE */
+	}
+#endif	/* CONFIG_BUG */
+}
+
+static void copy_trap(struct lguest *lg,
+		      struct host_trap *trap,
+		      const struct desc_struct *desc)
+{
+	u8 type = ((desc->b >> 8) & 0xF);
+
+	/* Not present? */
+	if (!(desc->b & 0x8000)) {
+		trap->addr = 0;
+		return;
+	}
+	if (type != 0xE && type != 0xF)
+		kill_guest(lg, "bad IDT type %i", type);
+	trap->disable_interrupts = (type == 0xE);
+	trap->addr = ((desc->a & 0x0000FFFF) | (desc->b & 0xFFFF0000));
+}
+
+/* FIXME: Put this in hypervisor.S and do something clever with relocs? */
+static u8 tramp[]
+= { 0x0f, 0xa8, 0x0f, 0xa9, /* push %gs; pop %gs */
+    0x36, 0xc7, 0x05, 0x55, 0x55, 0x55, 0x55, 0x00, 0x00, 0x00, 0x00,
+    /* movl 0, %ss:lguest_data.gs_gpf_eip */
+    0xe9, 0x55, 0x55, 0x55, 0x55 /* jmp dstaddr */
+};
+#define TRAMP_MOVL_TARGET_OFF 7
+#define TRAMP_JMP_TARGET_OFF 16
+
+static u32 setup_trampoline(struct lguest *lg, unsigned int i, u32 dstaddr)
+{
+	u32 addr, off;
+
+	off = sizeof(tramp)*i;
+	memcpy(lg->trap_page + off, tramp, sizeof(tramp));
+
+	/* 0 is to be placed in lguest_data.gs_gpf_eip. */
+	addr = (u32)&lg->lguest_data->gs_gpf_eip + lg->page_offset;
+	memcpy(lg->trap_page + off + TRAMP_MOVL_TARGET_OFF, &addr, 4);
+
+	/* Address is relative to where end of jmp will be. */
+	addr = dstaddr - ((-4*1024*1024) + off + sizeof(tramp));
+	memcpy(lg->trap_page + off + TRAMP_JMP_TARGET_OFF, &addr, 4);
+	return (-4*1024*1024) + off;
+}
+
+/* We bounce through the trap page, for two reasons: firstly, we need
+   the interrupt destination always mapped, to avoid double faults,
+   secondly we want to reload %gs to make it innocuous on entering kernel.
+ */
+static void setup_idt(struct lguest *lg,
+		      unsigned int i,
+		      const struct desc_struct *desc)
+{
+	u8 type = ((desc->b >> 8) & 0xF);
+	u32 taddr;
+
+	/* Not present? */
+	if (!(desc->b & 0x8000)) {
+		/* FIXME: When we need this, we'll know... */
+		if (lg->state->idt_table[i].a & 0x8000)
+			kill_guest(lg, "removing interrupts not supported");
+		return;
+	}
+
+	/* We could reflect and disable interrupts, but guest can do itself. */
+	if (type != 0xF)
+		kill_guest(lg, "bad direct IDT %i type %i", i, type);
+
+	taddr = setup_trampoline(lg, i, (desc->a&0xFFFF)|(desc->b&0xFFFF0000));
+
+	lg->state->idt_table[i].a = (((__KERNEL_CS|GUEST_DPL)<<16)
+					| (taddr & 0x0000FFFF));
+	lg->state->idt_table[i].b = (desc->b&0xEF00)|(taddr&0xFFFF0000);
+}
+
+void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 high)
+{
+	struct desc_struct d = { low, high };
+
+	switch (i) {
+	/* Ignore NMI, doublefault, hypercall, spurious interrupt. */
+	case 2:
+	case 8:
+	case 15:
+	case LGUEST_TRAP_ENTRY:
+	/* FIXME: We should handle debug and int3 */
+	case 1:
+	case 3:
+		return;
+	/* We intercept page fault, general protection fault and fpu missing */
+	case 13:
+		copy_trap(lg, &lg->gpf_trap, &d);
+		return;
+	case 14:
+		copy_trap(lg, &lg->page_trap, &d);
+		return;
+	case 7:
+		copy_trap(lg, &lg->fpu_trap, &d);
+		return;
+	}
+
+	/* Other traps go straight to guest. */
+	if (i < FIRST_EXTERNAL_VECTOR || i == SYSCALL_VECTOR)
+		setup_idt(lg, i, &d);
+	/* A virtual interrupt */
+	else if (i < FIRST_EXTERNAL_VECTOR + LGUEST_IRQS)
+		copy_trap(lg, &lg->interrupt[i-FIRST_EXTERNAL_VECTOR], &d);
+}
+
diff -puN /dev/null arch/i386/lguest/io.c
--- /dev/null
+++ a/arch/i386/lguest/io.c
@@ -0,0 +1,413 @@
+/* Simple I/O model for guests, based on shared memory.
+ * Copyright (C) 2006 Rusty Russell IBM Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+#include <linux/types.h>
+#include <linux/futex.h>
+#include <linux/jhash.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/uaccess.h>
+#include "lg.h"
+
+static struct list_head dma_hash[64];
+
+/* FIXME: allow multi-page lengths. */
+static int check_dma_list(struct lguest *lg, const struct lguest_dma *dma)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_MAX_DMA_SECTIONS; i++) {
+		if (!dma->len[i])
+			return 1;
+		if (!lguest_address_ok(lg, dma->addr[i]))
+			goto kill;
+		if (dma->len[i] > PAGE_SIZE)
+			goto kill;
+		/* We could do over a page, but is it worth it? */
+		if ((dma->addr[i] % PAGE_SIZE) + dma->len[i] > PAGE_SIZE)
+			goto kill;
+	}
+	return 1;
+
+kill:
+	kill_guest(lg, "bad DMA entry: %u@%#x", dma->len[i], dma->addr[i]);
+	return 0;
+}
+
+static unsigned int hash(const union futex_key *key)
+{
+	return jhash2((u32*)&key->both.word,
+		      (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
+		      key->both.offset)
+		% ARRAY_SIZE(dma_hash);
+}
+
+/* Must hold read lock on dmainfo owner's current->mm->mmap_sem */
+static void unlink_dma(struct lguest_dma_info *dmainfo)
+{
+	BUG_ON(!mutex_is_locked(&lguest_lock));
+	dmainfo->interrupt = 0;
+	list_del(&dmainfo->list);
+	drop_futex_key_refs(&dmainfo->key);
+}
+
+static inline int key_eq(const union futex_key *a, const union futex_key *b)
+{
+	return (a->both.word == b->both.word
+		&& a->both.ptr == b->both.ptr
+		&& a->both.offset == b->both.offset);
+}
+
+static u32 unbind_dma(struct lguest *lg,
+		      const union futex_key *key,
+		      unsigned long dmas)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < LGUEST_MAX_DMA; i++) {
+		if (key_eq(key, &lg->dma[i].key) && dmas == lg->dma[i].dmas) {
+			unlink_dma(&lg->dma[i]);
+			ret = 1;
+			break;
+		}
+	}
+	return ret;
+}
+
+u32 bind_dma(struct lguest *lg,
+	     unsigned long addr, unsigned long dmas, u16 numdmas, u8 interrupt)
+{
+	unsigned int i;
+	u32 ret = 0;
+	union futex_key key;
+
+	if (interrupt >= LGUEST_IRQS)
+		return 0;
+
+	mutex_lock(&lguest_lock);
+	down_read(&current->mm->mmap_sem);
+	if (get_futex_key((u32 __user *)addr, &key) != 0) {
+		kill_guest(lg, "bad dma address %#lx", addr);
+		goto unlock;
+	}
+	get_futex_key_refs(&key);
+
+	if (interrupt == 0)
+		ret = unbind_dma(lg, &key, dmas);
+	else {
+		for (i = 0; i < LGUEST_MAX_DMA; i++) {
+			if (lg->dma[i].interrupt == 0) {
+				lg->dma[i].dmas = dmas;
+				lg->dma[i].num_dmas = numdmas;
+				lg->dma[i].next_dma = 0;
+				lg->dma[i].key = key;
+				lg->dma[i].guestid = lg->guestid;
+				lg->dma[i].interrupt = interrupt;
+				list_add(&lg->dma[i].list,
+					 &dma_hash[hash(&key)]);
+				ret = 1;
+				goto unlock;
+			}
+		}
+	}
+	drop_futex_key_refs(&key);
+unlock:
+ 	up_read(&current->mm->mmap_sem);
+	mutex_unlock(&lguest_lock);
+	return ret;
+}
+
+/* lhread from another guest */
+static int lhread_other(struct lguest *lg,
+			void *buf, u32 addr, unsigned bytes)
+{
+	if (addr + bytes < addr
+	    || !lguest_address_ok(lg, addr+bytes)
+	    || access_process_vm(lg->tsk, addr, buf, bytes, 0) != bytes) {
+		memset(buf, 0, bytes);
+		kill_guest(lg, "bad address in registered DMA struct");
+		return 0;
+	}
+	return 1;
+}
+
+/* lhwrite to another guest */
+static int lhwrite_other(struct lguest *lg, u32 addr,
+			 const void *buf, unsigned bytes)
+{
+	if (addr + bytes < addr
+	    || !lguest_address_ok(lg, addr+bytes)
+	    || (access_process_vm(lg->tsk, addr, (void *)buf, bytes, 1)
+		!= bytes)) {
+		kill_guest(lg, "bad address writing to registered DMA");
+		return 0;
+	}
+	return 1;
+}
+
+static u32 copy_data(const struct lguest_dma *src,
+		     const struct lguest_dma *dst,
+		     struct page *pages[])
+{
+	unsigned int totlen, si, di, srcoff, dstoff;
+	void *maddr = NULL;
+
+	totlen = 0;
+	si = di = 0;
+	srcoff = dstoff = 0;
+	while (si < LGUEST_MAX_DMA_SECTIONS && src->len[si]
+	       && di < LGUEST_MAX_DMA_SECTIONS && dst->len[di]) {
+		u32 len = min(src->len[si] - srcoff, dst->len[di] - dstoff);
+
+		if (!maddr)
+			maddr = kmap(pages[di]);
+
+		/* FIXME: This is not completely portable, since
+		   archs do different things for copy_to_user_page. */
+		if (copy_from_user(maddr + (dst->addr[di] + dstoff)%PAGE_SIZE,
+				   (void *__user)src->addr[si], len) != 0) {
+			totlen = 0;
+			break;
+		}
+
+		totlen += len;
+		srcoff += len;
+		dstoff += len;
+		if (srcoff == src->len[si]) {
+			si++;
+			srcoff = 0;
+		}
+		if (dstoff == dst->len[di]) {
+			kunmap(pages[di]);
+			maddr = NULL;
+			di++;
+			dstoff = 0;
+		}
+	}
+
+	if (maddr)
+		kunmap(pages[di]);
+
+	return totlen;
+}
+
+/* Src is us, ie. current. */
+static u32 do_dma(struct lguest *srclg, const struct lguest_dma *src,
+		  struct lguest *dstlg, const struct lguest_dma *dst)
+{
+	int i;
+	u32 ret;
+	struct page *pages[LGUEST_MAX_DMA_SECTIONS];
+
+	if (!check_dma_list(dstlg, dst) || !check_dma_list(srclg, src))
+		return 0;
+
+	/* First get the destination pages */
+	for (i = 0; i < LGUEST_MAX_DMA_SECTIONS; i++) {
+		if (dst->len[i] == 0)
+			break;
+		if (get_user_pages(dstlg->tsk, dstlg->mm,
+				   dst->addr[i], 1, 1, 1, pages+i, NULL)
+		    != 1) {
+			ret = 0;
+			goto drop_pages;
+		}
+	}
+
+	/* Now copy until we run out of src or dst. */
+	ret = copy_data(src, dst, pages);
+
+drop_pages:
+	while (--i >= 0)
+		put_page(pages[i]);
+	return ret;
+}
+
+/* We cache one process to wakeup: helps for batching & wakes outside locks. */
+void set_wakeup_process(struct lguest *lg, struct task_struct *p)
+{
+	if (p == lg->wake)
+		return;
+
+	if (lg->wake) {
+		wake_up_process(lg->wake);
+		put_task_struct(lg->wake);
+	}
+	lg->wake = p;
+	if (lg->wake)
+		get_task_struct(lg->wake);
+}
+
+static int dma_transfer(struct lguest *srclg,
+			unsigned long udma,
+			struct lguest_dma_info *dst)
+{
+	struct lguest_dma dst_dma, src_dma;
+	struct lguest *dstlg;
+	u32 i, dma = 0;
+
+	dstlg = &lguests[dst->guestid];
+	/* Get our dma list. */
+	lhread(srclg, &src_dma, udma, sizeof(src_dma));
+
+	/* We can't deadlock against them dmaing to us, because this
+	 * is all under the lguest_lock. */
+	down_read(&dstlg->mm->mmap_sem);
+
+	for (i = 0; i < dst->num_dmas; i++) {
+		dma = (dst->next_dma + i) % dst->num_dmas;
+		if (!lhread_other(dstlg, &dst_dma,
+				  dst->dmas + dma * sizeof(struct lguest_dma),
+				  sizeof(dst_dma))) {
+			goto fail;
+		}
+		if (!dst_dma.used_len)
+			break;
+	}
+	if (i != dst->num_dmas) {
+		unsigned long used_lenp;
+		unsigned int ret;
+
+		ret = do_dma(srclg, &src_dma, dstlg, &dst_dma);
+		/* Put used length in src. */
+		lhwrite_u32(srclg,
+			    udma+offsetof(struct lguest_dma, used_len), ret);
+		if (ret == 0 && src_dma.len[0] != 0)
+			goto fail;
+
+		/* Make sure destination sees contents before length. */
+		mb();
+		used_lenp = dst->dmas
+			+ dma * sizeof(struct lguest_dma)
+			+ offsetof(struct lguest_dma, used_len);
+		lhwrite_other(dstlg, used_lenp, &ret, sizeof(ret));
+		dst->next_dma++;
+	}
+ 	up_read(&dstlg->mm->mmap_sem);
+
+	/* Do this last so dst doesn't simply sleep on lock. */
+	set_bit(dst->interrupt, dstlg->irqs_pending);
+	set_wakeup_process(srclg, dstlg->tsk);
+	return i == dst->num_dmas;
+
+fail:
+	up_read(&dstlg->mm->mmap_sem);
+	return 0;
+}
+
+int send_dma(struct lguest *lg, unsigned long addr, unsigned long udma)
+{
+	union futex_key key;
+	int pending = 0, empty = 0;
+
+again:
+	mutex_lock(&lguest_lock);
+	down_read(&current->mm->mmap_sem);
+	if (get_futex_key((u32 __user *)addr, &key) != 0) {
+		kill_guest(lg, "bad sending DMA address");
+		goto unlock;
+	}
+	/* Shared mapping?  Look for other guests... */
+	if (key.shared.offset & 1) {
+		struct lguest_dma_info *i, *n;
+		list_for_each_entry_safe(i, n, &dma_hash[hash(&key)], list) {
+			if (i->guestid == lg->guestid)
+				continue;
+			if (!key_eq(&key, &i->key))
+				continue;
+
+			empty += dma_transfer(lg, udma, i);
+			break;
+		}
+		if (empty == 1) {
+			/* Give any recipients one chance to restock. */
+			up_read(&current->mm->mmap_sem);
+			mutex_unlock(&lguest_lock);
+			yield();
+			empty++;
+			goto again;
+		}
+		pending = 0;
+	} else {
+		/* Private mapping: tell our userspace. */
+		lg->dma_is_pending = 1;
+		lg->pending_dma = udma;
+		lg->pending_addr = addr;
+		pending = 1;
+	}
+unlock:
+	up_read(&current->mm->mmap_sem);
+	mutex_unlock(&lguest_lock);
+	return pending;
+}
+
+void release_all_dma(struct lguest *lg)
+{
+	unsigned int i;
+
+	BUG_ON(!mutex_is_locked(&lguest_lock));
+
+	down_read(&lg->mm->mmap_sem);
+	for (i = 0; i < LGUEST_MAX_DMA; i++) {
+		if (lg->dma[i].interrupt)
+			unlink_dma(&lg->dma[i]);
+	}
+	up_read(&lg->mm->mmap_sem);
+}
+
+/* Userspace wants a dma buffer from this guest. */
+unsigned long get_dma_buffer(struct lguest *lg,
+			     unsigned long addr, unsigned long *interrupt)
+{
+	unsigned long ret = 0;
+	union futex_key key;
+	struct lguest_dma_info *i;
+
+	mutex_lock(&lguest_lock);
+	down_read(&current->mm->mmap_sem);
+	if (get_futex_key((u32 __user *)addr, &key) != 0) {
+		kill_guest(lg, "bad registered DMA buffer");
+		goto unlock;
+	}
+	list_for_each_entry(i, &dma_hash[hash(&key)], list) {
+		if (key_eq(&key, &i->key) && i->guestid == lg->guestid) {
+			unsigned int j;
+			for (j = 0; j < i->num_dmas; j++) {
+				struct lguest_dma dma;
+
+				ret = i->dmas + j * sizeof(struct lguest_dma);
+				lhread(lg, &dma, ret, sizeof(dma));
+				if (dma.used_len == 0)
+					break;
+			}
+			*interrupt = i->interrupt;
+			break;
+		}
+	}
+unlock:
+	up_read(&current->mm->mmap_sem);
+	mutex_unlock(&lguest_lock);
+	return ret;
+}
+
+void lguest_io_init(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dma_hash); i++)
+		INIT_LIST_HEAD(&dma_hash[i]);
+}
diff -puN arch/i386/lguest/lg.h~lguest-the-host-code-lgko arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-the-host-code-lgko
+++ a/arch/i386/lguest/lg.h
@@ -2,9 +2,6 @@
 #define _LGUEST_H
 
 #include <asm/desc.h>
-/* 64k ought to be enough for anybody! */
-#define HYPERVISOR_MAP_ORDER 16
-#define HYPERVISOR_PAGES ((1 << HYPERVISOR_MAP_ORDER)/PAGE_SIZE)
 
 #define GDT_ENTRY_LGUEST_CS	10
 #define GDT_ENTRY_LGUEST_DS	11
@@ -27,7 +24,6 @@
 struct lguest_regs
 {
 	/* Manually saved part. */
-	u32 cr3;
 	u32 ebx, ecx, edx;
 	u32 esi, edi, ebp;
 	u32 gs;
@@ -43,7 +39,7 @@ struct lguest_regs
 };
 
 __exit void free_pagetables(void);
-__init int init_pagetables(struct page *hype_pages);
+__init int init_pagetables(struct page **hype_page, int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
 #define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
@@ -84,6 +80,7 @@ struct lguest
 	u32 pfn_limit;
 	u32 page_offset;
 	u32 cr2;
+	u32 cr3;
 	int timer_on;
 	int halted;
 	int ts;
@@ -122,7 +119,6 @@ struct lguest
 	struct host_trap interrupt[LGUEST_IRQS];
 };
 
-extern struct page *hype_pages; /* Contiguous pages. */
 extern struct lguest lguests[];
 extern struct mutex lguest_lock;
 
diff -puN /dev/null arch/i386/lguest/lguest_user.c
--- /dev/null
+++ a/arch/i386/lguest/lguest_user.c
@@ -0,0 +1,241 @@
+/* Userspace control of the guest, via /dev/lguest. */
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include "lg.h"
+
+static struct lguest_state *setup_guest_state(unsigned int num,
+					      unsigned long start)
+{
+	struct lguest_state *guest = &__lguest_states()[num];
+	unsigned int i;
+	const long *def = __lguest_default_idt_entries();
+	struct lguest_regs *regs;
+
+	guest->gdt_table[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
+	guest->gdt_table[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
+	guest->gdt.size = GDT_ENTRIES*8-1;
+	guest->gdt.address = (unsigned long)&guest->gdt_table;
+
+	/* Other guest's IDTs are initialized from default. */
+	guest->idt.size = 8 * IDT_ENTRIES;
+	guest->idt.address = (long)guest->idt_table;
+	for (i = 0; i < IDT_ENTRIES; i++) {
+		u32 flags = 0x8e00;
+
+		/* They can't "int" into any of them except hypercall. */
+		if (i == LGUEST_TRAP_ENTRY)
+			flags |= (GUEST_DPL << 13);
+
+		guest->idt_table[i].a = (LGUEST_CS<<16) | (def[i]&0x0000FFFF);
+		guest->idt_table[i].b = (def[i]&0xFFFF0000) | flags;
+	}
+
+	memset(&guest->tss, 0, sizeof(guest->tss));
+	guest->tss.ss0 = LGUEST_DS;
+	guest->tss.esp0 = (unsigned long)(guest+1);
+	guest->tss.io_bitmap_base = sizeof(guest->tss); /* No I/O for you! */
+
+	/* Write out stack in format lguest expects, so we can switch to it. */
+	regs = &guest->regs;
+	regs->eax = regs->ebx = regs->ecx = regs->edx = regs->esp = 0;
+	regs->edi = LGUEST_MAGIC_EDI;
+	regs->ebp = LGUEST_MAGIC_EBP;
+	regs->esi = LGUEST_MAGIC_ESI;
+	regs->gs = regs->fs = 0;
+	regs->ds = regs->es = __KERNEL_DS|GUEST_DPL;
+	regs->trapnum = regs->errcode = 0;
+	regs->eip = start;
+	regs->cs = __KERNEL_CS|GUEST_DPL;
+	regs->eflags = 0x202; 	/* Interrupts enabled. */
+	regs->ss = __KERNEL_DS|GUEST_DPL;
+
+	if (!fixup_gdt_table(guest->gdt_table, ARRAY_SIZE(guest->gdt_table),
+			     &guest->regs, &guest->tss))
+		return NULL;
+
+	return guest;
+}
+
+/* + addr */
+static long user_get_dma(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long addr, udma, irq;
+
+	if (get_user(addr, input) != 0)
+		return -EFAULT;
+	udma = get_dma_buffer(lg, addr, &irq);
+	if (!udma)
+		return -ENOENT;
+
+	/* We put irq number in udma->used_len. */
+	lhwrite_u32(lg, udma + offsetof(struct lguest_dma, used_len), irq);
+	return udma;
+}
+
+/* + irq */
+static int user_send_irq(struct lguest *lg, const u32 __user *input)
+{
+	u32 irq;
+
+	if (get_user(irq, input) != 0)
+		return -EFAULT;
+	if (irq >= LGUEST_IRQS)
+		return -EINVAL;
+	set_bit(irq, lg->irqs_pending);
+	return 0;
+}
+
+static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
+{
+	struct lguest *lg = file->private_data;
+
+	if (!lg)
+		return -EINVAL;
+
+	if (lg->dead) {
+		size_t len;
+
+		if (lg->dead == (void *)-1)
+			return -ENOMEM;
+
+		len = min(size, strlen(lg->dead)+1);
+		if (copy_to_user(user, lg->dead, len) != 0)
+			return -EFAULT;
+		return len;
+	}
+
+	if (lg->dma_is_pending)
+		lg->dma_is_pending = 0;
+
+	return run_guest(lg, user);
+}
+
+/* Take: pfnlimit, pgdir, start, pageoffset. */
+static int initialize(struct file *file, const u32 __user *input)
+{
+	struct lguest *lg;
+	int err, i;
+	u32 args[4];
+
+	if (file->private_data)
+		return -EBUSY;
+
+	if (copy_from_user(args, input, sizeof(args)) != 0)
+		return -EFAULT;
+
+	if (args[1] <= PAGE_SIZE)
+		return -EINVAL;
+
+	mutex_lock(&lguest_lock);
+	i = find_free_guest();
+	if (i < 0) {
+		err = -ENOSPC;
+		goto unlock;
+	}
+	lg = &lguests[i];
+	lg->guestid = i;
+	lg->pfn_limit = args[0];
+	lg->page_offset = args[3];
+
+	lg->trap_page = (u32 *)get_zeroed_page(GFP_KERNEL);
+	if (!lg->trap_page) {
+		err = -ENOMEM;
+		goto release_guest;
+	}
+
+	err = init_guest_pagetable(lg, args[1]);
+	if (err)
+		goto free_trap_page;
+
+	lg->state = setup_guest_state(i, args[2]);
+	if (!lg->state) {
+		err = -ENOEXEC;
+		goto release_pgtable;
+	}
+	mutex_unlock(&lguest_lock);
+
+	lg->tsk = current;
+	lg->mm = get_task_mm(current);
+	file->private_data = lg;
+	return sizeof(args);
+
+release_pgtable:
+	free_guest_pagetable(lg);
+free_trap_page:
+	free_page((long)lg->trap_page);
+release_guest:
+	memset(lg, 0, sizeof(*lg));
+unlock:
+	mutex_unlock(&lguest_lock);
+	return err;
+}
+
+static ssize_t write(struct file *file, const char __user *input,
+		     size_t size, loff_t *off)
+{
+	struct lguest *lg = file->private_data;
+	u32 req;
+
+	if (get_user(req, input) != 0)
+		return -EFAULT;
+	input += sizeof(req);
+
+	if (req != LHREQ_INITIALIZE && !lg)
+		return -EINVAL;
+	if (lg && lg->dead)
+		return -ENOENT;
+
+	switch (req) {
+	case LHREQ_INITIALIZE:
+		return initialize(file, (const u32 __user *)input);
+	case LHREQ_GETDMA:
+		return user_get_dma(lg, (const u32 __user *)input);
+	case LHREQ_IRQ:
+		return user_send_irq(lg, (const u32 __user *)input);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int close(struct inode *inode, struct file *file)
+{
+	struct lguest *lg = file->private_data;
+
+	if (!lg)
+		return 0;
+
+	mutex_lock(&lguest_lock);
+	release_all_dma(lg);
+	free_page((long)lg->trap_page);
+	free_guest_pagetable(lg);
+	mmput(lg->mm);
+	if (lg->dead != (void *)1)
+		kfree(lg->dead);
+	memset(lg->state, 0, sizeof(*lg->state));
+	memset(lg, 0, sizeof(*lg));
+	mutex_unlock(&lguest_lock);
+	return 0;
+}
+
+static struct file_operations lguest_fops = {
+	.owner	 = THIS_MODULE,
+	.release = close,
+	.write	 = write,
+	.read	 = read,
+};
+static struct miscdevice lguest_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "lguest",
+	.fops	= &lguest_fops,
+};
+
+int __init lguest_device_init(void)
+{
+	return misc_register(&lguest_dev);
+}
+
+void __exit lguest_device_remove(void)
+{
+	misc_deregister(&lguest_dev);
+}
diff -puN /dev/null arch/i386/lguest/page_tables.c
--- /dev/null
+++ a/arch/i386/lguest/page_tables.c
@@ -0,0 +1,383 @@
+/* Shadow page table operations.
+ * Copyright (C) Rusty Russell IBm Corporation 2006.
+ * GPL v2 and any later version */
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/random.h>
+#include <linux/percpu.h>
+#include <asm/tlbflush.h>
+#include "lg.h"
+
+#define PTES_PER_PAGE_SHIFT 10
+#define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
+#define HYPERVISOR_PGD_ENTRY (PTES_PER_PAGE - 1)
+
+static DEFINE_PER_CPU(u32 *, hypervisor_pte_pages) = { NULL };
+#define hypervisor_pte_page(cpu) per_cpu(hypervisor_pte_pages, cpu)
+
+static unsigned vaddr_to_pgd(unsigned long vaddr)
+{
+	return vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
+}
+
+/* These access the real versions. */
+static u32 *toplev(struct lguest *lg, u32 i, unsigned long vaddr)
+{
+	unsigned int index = vaddr_to_pgd(vaddr);
+
+	if (index >= HYPERVISOR_PGD_ENTRY) {
+		kill_guest(lg, "attempt to access hypervisor pages");
+		index = 0;
+	}
+	return &lg->pgdirs[i].pgdir[index];
+}
+
+static u32 *pteof(struct lguest *lg, u32 top, unsigned long vaddr)
+{
+	u32 *page = __va(top&PAGE_MASK);
+	BUG_ON(!(top & _PAGE_PRESENT));
+	return &page[(vaddr >> PAGE_SHIFT) % PTES_PER_PAGE];
+}
+
+/* These access the guest versions. */
+static u32 gtoplev(struct lguest *lg, unsigned long vaddr)
+{
+	unsigned int index = vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
+	return lg->pgdirs[lg->pgdidx].cr3 + index * sizeof(u32);
+}
+
+static u32 gpteof(struct lguest *lg, u32 gtop, unsigned long vaddr)
+{
+	u32 gpage = (gtop&PAGE_MASK);
+	BUG_ON(!(gtop & _PAGE_PRESENT));
+	return gpage + ((vaddr >> PAGE_SHIFT) % PTES_PER_PAGE) * sizeof(u32);
+}
+
+static void release_pte(u32 pte)
+{
+	if (pte & _PAGE_PRESENT)
+		put_page(pfn_to_page(pte >> PAGE_SHIFT));
+}
+
+/* Do a virtual -> physical mapping on a user page. */
+static unsigned long get_pfn(unsigned long virtpfn, int write)
+{
+	struct vm_area_struct *vma;
+	struct page *page;
+	unsigned long ret = -1UL;
+
+	down_read(&current->mm->mmap_sem);
+	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
+			   1, write, 1, &page, &vma) == 1)
+		ret = page_to_pfn(page);
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
+static u32 check_pgtable_entry(struct lguest *lg, u32 entry)
+{
+	if ((entry & (_PAGE_PWT|_PAGE_PSE))
+	    || (entry >> PAGE_SHIFT) >= lg->pfn_limit)
+		kill_guest(lg, "bad page table entry");
+	return entry & ~_PAGE_GLOBAL;
+}
+
+static u32 get_pte(struct lguest *lg, u32 entry, int write)
+{
+	u32 pfn;
+
+	pfn = get_pfn(entry >> PAGE_SHIFT, write);
+	if (pfn == -1UL) {
+		kill_guest(lg, "failed to get page %u", entry>>PAGE_SHIFT);
+		return 0;
+	}
+	return ((pfn << PAGE_SHIFT) | (entry & (PAGE_SIZE-1)));
+}
+
+/* FIXME: We hold reference to pages, which prevents them from being
+   swapped.  It'd be nice to have a callback when Linux wants to swap out. */
+
+/* We fault pages in, which allows us to update accessed/dirty bits.
+ * Return NULL or the pte page. */
+static int page_in(struct lguest *lg, u32 vaddr, unsigned flags)
+{
+	u32 gtop, gpte;
+	u32 *top, *pte, *ptepage;
+	u32 val;
+
+	gtop = gtoplev(lg, vaddr);
+	val = lhread_u32(lg, gtop);
+	if (!(val & _PAGE_PRESENT))
+		return 0;
+
+	top = toplev(lg, lg->pgdidx, vaddr);
+	if (!(*top & _PAGE_PRESENT)) {
+		/* Get a PTE page for them. */
+		ptepage = (void *)get_zeroed_page(GFP_KERNEL);
+		/* FIXME: Steal from self in this case? */
+		if (!ptepage) {
+			kill_guest(lg, "out of memory allocating pte page");
+			return 0;
+		}
+		val = check_pgtable_entry(lg, val);
+		*top = (__pa(ptepage) | (val & (PAGE_SIZE-1)));
+	} else
+		ptepage = __va(*top & PAGE_MASK);
+
+	gpte = gpteof(lg, val, vaddr);
+	val = lhread_u32(lg, gpte);
+
+	/* No page, or write to readonly page? */
+	if (!(val&_PAGE_PRESENT) || ((flags&_PAGE_DIRTY) && !(val&_PAGE_RW)))
+		return 0;
+
+	pte = pteof(lg, *top, vaddr);
+	val = check_pgtable_entry(lg, val) | flags;
+
+	/* We're done with the old pte. */
+	release_pte(*pte);
+
+	/* We don't make it writable if this isn't a write: later
+	 * write will fault so we can set dirty bit in guest. */
+	if (val & _PAGE_DIRTY)
+		*pte = get_pte(lg, val, 1);
+	else
+		*pte = get_pte(lg, val & ~_PAGE_RW, 0);
+
+	/* Now we update dirty/accessed on guest. */
+	lhwrite_u32(lg, gpte, val);
+	return 1;
+}
+
+int demand_page(struct lguest *lg, u32 vaddr, int write)
+{
+	return page_in(lg, vaddr, (write ? _PAGE_DIRTY : 0)|_PAGE_ACCESSED);
+}
+
+/* This is much faster than the full demand_page logic. */
+static int page_writable(struct lguest *lg, unsigned long vaddr)
+{
+	u32 *top, *pte;
+
+	top = toplev(lg, lg->pgdidx, vaddr);
+	if (!(*top & _PAGE_PRESENT))
+		return 0;
+
+	pte = pteof(lg, *top, vaddr);
+	return (*pte & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
+}
+
+void pin_stack_pages(struct lguest *lg)
+{
+	unsigned int i;
+	u32 stack = lg->state->tss.esp1;
+
+	for (i = 0; i < lg->stack_pages; i++) {
+		if (!page_writable(lg, stack - i * PAGE_SIZE)
+		    && !demand_page(lg, stack - i * PAGE_SIZE, 1))
+			kill_guest(lg, "bad stack page %i@%#x", i, stack);
+	}
+}
+
+static unsigned int find_pgdir(struct lguest *lg, u32 pgtable)
+{
+	unsigned int i;
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		if (lg->pgdirs[i].cr3 == pgtable)
+			break;
+	return i;
+}
+
+static void release_pgd(struct lguest *lg, u32 *pgd)
+{
+	if (*pgd & _PAGE_PRESENT) {
+		unsigned int i;
+		u32 *ptepage = __va(*pgd & ~(PAGE_SIZE-1));
+		for (i = 0; i < PTES_PER_PAGE; i++)
+			release_pte(ptepage[i]);
+		free_page((long)ptepage);
+		*pgd = 0;
+	}
+}
+
+static void flush_user_mappings(struct lguest *lg, int idx)
+{
+	unsigned int i;
+	for (i = 0; i < vaddr_to_pgd(lg->page_offset); i++)
+		release_pgd(lg, lg->pgdirs[idx].pgdir + i);
+}
+
+void guest_pagetable_flush_user(struct lguest *lg)
+{
+	flush_user_mappings(lg, lg->pgdidx);
+}
+
+static unsigned int new_pgdir(struct lguest *lg, u32 cr3, int *blank_pgdir)
+{
+	unsigned int next;
+
+	next = (lg->pgdidx + random32()) % ARRAY_SIZE(lg->pgdirs);
+	if (!lg->pgdirs[next].pgdir) {
+		lg->pgdirs[next].pgdir = (u32 *)get_zeroed_page(GFP_KERNEL);
+		if (!lg->pgdirs[next].pgdir)
+			next = lg->pgdidx;
+		else
+			/* There are no mappings: you'll need to re-pin */
+			*blank_pgdir = 1;
+	}
+	lg->pgdirs[next].cr3 = cr3;
+	/* Release all the non-kernel mappings. */
+	flush_user_mappings(lg, next);
+
+	return next;
+}
+
+void guest_new_pagetable(struct lguest *lg, u32 pgtable)
+{
+	int newpgdir, repin = 0;
+
+	newpgdir = find_pgdir(lg, pgtable);
+	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
+		newpgdir = new_pgdir(lg, pgtable, &repin);
+	lg->pgdidx = newpgdir;
+	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
+	if (repin)
+		pin_stack_pages(lg);
+}
+
+static void release_all_pagetables(struct lguest *lg)
+{
+	unsigned int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		if (lg->pgdirs[i].pgdir)
+			for (j = 0; j < HYPERVISOR_PGD_ENTRY; j++)
+				release_pgd(lg, lg->pgdirs[i].pgdir + j);
+}
+
+void guest_pagetable_clear_all(struct lguest *lg)
+{
+	release_all_pagetables(lg);
+	pin_stack_pages(lg);
+}
+
+static void do_set_pte(struct lguest *lg, int idx,
+		       unsigned long vaddr, u32 val)
+{
+	u32 *top = toplev(lg, idx, vaddr);
+	if (*top & _PAGE_PRESENT) {
+		u32 *pte = pteof(lg, *top, vaddr);
+		release_pte(*pte);
+		if (val & (_PAGE_DIRTY | _PAGE_ACCESSED)) {
+			val = check_pgtable_entry(lg, val);
+			*pte = get_pte(lg, val, val & _PAGE_DIRTY);
+		} else
+			*pte = 0;
+	}
+}
+
+void guest_set_pte(struct lguest *lg,
+		   unsigned long cr3, unsigned long vaddr, u32 val)
+{
+	/* Kernel mappings must be changed on all top levels. */
+	if (vaddr >= lg->page_offset) {
+		unsigned int i;
+		for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+			if (lg->pgdirs[i].pgdir)
+				do_set_pte(lg, i, vaddr, val);
+	} else {
+		int pgdir = find_pgdir(lg, cr3);
+		if (pgdir != ARRAY_SIZE(lg->pgdirs))
+			do_set_pte(lg, pgdir, vaddr, val);
+	}
+}
+
+void guest_set_pud(struct lguest *lg, unsigned long cr3, u32 idx)
+{
+	int pgdir;
+
+	if (idx >= HYPERVISOR_PGD_ENTRY)
+		return;
+
+	pgdir = find_pgdir(lg, cr3);
+	if (pgdir < ARRAY_SIZE(lg->pgdirs))
+		release_pgd(lg, lg->pgdirs[pgdir].pgdir + idx);
+}
+
+int init_guest_pagetable(struct lguest *lg, u32 pgtable)
+{
+	/* We assume this in flush_user_mappings, so check now */
+	if (vaddr_to_pgd(lg->page_offset) >= HYPERVISOR_PGD_ENTRY)
+		return -EINVAL;
+	lg->pgdidx = 0;
+	lg->pgdirs[lg->pgdidx].cr3 = pgtable;
+	lg->pgdirs[lg->pgdidx].pgdir = (u32*)get_zeroed_page(GFP_KERNEL);
+	if (!lg->pgdirs[lg->pgdidx].pgdir)
+		return -ENOMEM;
+	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
+	return 0;
+}
+
+void free_guest_pagetable(struct lguest *lg)
+{
+	unsigned int i;
+
+	release_all_pagetables(lg);
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		free_page((long)lg->pgdirs[i].pgdir);
+}
+
+/* Caller must be preempt-safe */
+void map_trap_page(struct lguest *lg)
+{
+	int cpu = smp_processor_id();
+
+	hypervisor_pte_page(cpu)[0] = (__pa(lg->trap_page)|_PAGE_PRESENT);
+
+	/* Since hypervisor less that 4MB, we simply mug top pte page. */
+	lg->pgdirs[lg->pgdidx].pgdir[HYPERVISOR_PGD_ENTRY] =
+		(__pa(hypervisor_pte_page(cpu))| _PAGE_KERNEL);
+}
+
+static void free_hypervisor_pte_pages(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		free_page((long)hypervisor_pte_page(i));
+}
+
+static __init void populate_hypervisor_pte_page(int cpu,
+						struct page *hype_page[],
+						int pages)
+{
+	int i;
+	u32 *pte = hypervisor_pte_page(cpu);
+
+	for (i = 0; i < pages; i++) {
+		/* First entry set dynamically in map_trap_page */
+		pte[i+1] = ((page_to_pfn(hype_page[i]) << PAGE_SHIFT)
+			    | _PAGE_KERNEL_EXEC);
+	}
+}
+
+__init int init_pagetables(struct page **hype_page, int pages)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i) {
+		hypervisor_pte_page(i) = (u32 *)get_zeroed_page(GFP_KERNEL);
+		if (!hypervisor_pte_page(i)) {
+			free_hypervisor_pte_pages();
+			return -ENOMEM;
+		}
+		populate_hypervisor_pte_page(i, hype_page, pages);
+	}
+	return 0;
+}
+
+__exit void free_pagetables(void)
+{
+	free_hypervisor_pte_pages();
+}
diff -puN /dev/null arch/i386/lguest/segments.c
--- /dev/null
+++ a/arch/i386/lguest/segments.c
@@ -0,0 +1,171 @@
+#include "lg.h"
+
+/* Dealing with GDT entries is such a horror, I convert to sanity and back */
+struct decoded_gdt_entry
+{
+	u32 base, limit;
+	union {
+		struct {
+			unsigned type:4;
+			unsigned dtype:1;
+			unsigned dpl:2;
+			unsigned present:1;
+			unsigned unused:4;
+			unsigned avl:1;
+			unsigned mbz:1;
+			unsigned def:1;
+			unsigned page_granularity:1;
+		};
+		u16 raw_attributes;
+	};
+};
+
+static struct decoded_gdt_entry decode_gdt_entry(const struct desc_struct *en)
+{
+	struct decoded_gdt_entry de;
+	de.base = ((en->a >> 16) | ((en->b & 0xff) << 16)
+		   | (en->b & 0xFF000000));
+	de.limit = ((en->a & 0xFFFF) | (en->b & 0xF0000));
+	de.raw_attributes = (en->b >> 8);
+	return de;
+}
+
+static struct desc_struct encode_gdt_entry(const struct decoded_gdt_entry *de)
+{
+	struct desc_struct en;
+	en.a = ((de->limit & 0xFFFF) | (de->base << 16));
+	en.b = (((de->base >> 16) & 0xFF)
+		 | ((((u32)de->raw_attributes) & 0xF0FF) << 8)
+		 | (de->limit & 0xF0000)
+		 | (de->base & 0xFF000000));
+	return en;
+}
+
+static int check_desc(const struct decoded_gdt_entry *dec)
+{
+	return (dec->mbz == 0 && dec->dtype == 1 && (dec->type & 4) == 0);
+}
+
+static void check_segment(const struct desc_struct *gdt, u32 *segreg)
+{
+	if (*segreg > 255 || !(gdt[*segreg >> 3].b & 0x8000))
+		*segreg = 0;
+}
+
+/* Ensure our manually-loaded segment regs don't fault in switch_to_guest. */
+static void check_live_segments(const struct desc_struct *gdt,
+				struct lguest_regs *regs)
+{
+	check_segment(gdt, &regs->es);
+	check_segment(gdt, &regs->ds);
+	check_segment(gdt, &regs->fs);
+	check_segment(gdt, &regs->gs);
+}
+
+int fixup_gdt_table(struct desc_struct *gdt, unsigned int num,
+		    struct lguest_regs *regs, struct x86_tss *tss)
+{
+	unsigned int i;
+	struct decoded_gdt_entry dec;
+
+	for (i = 0; i < num; i++) {
+		unsigned long base, length;
+
+		/* We override these ones, so we don't care what they give. */
+		if (i == GDT_ENTRY_TSS
+		    || i == GDT_ENTRY_LGUEST_CS
+		    || i == GDT_ENTRY_LGUEST_DS
+		    || i == GDT_ENTRY_DOUBLEFAULT_TSS)
+			continue;
+
+		dec = decode_gdt_entry(&gdt[i]);
+		if (!dec.present)
+			continue;
+
+		if (!check_desc(&dec))
+			return 0;
+
+		base = dec.base;
+		length = dec.limit + 1;
+		if (dec.page_granularity) {
+			base *= PAGE_SIZE;
+			length *= PAGE_SIZE;
+		}
+
+		/* Unacceptable base? */
+		if (base >= HYPE_ADDR)
+			return 0;
+
+		/* Wrap around or segment overlaps hypervisor mem? */
+		if (!length
+		    || base + length < base
+		    || base + length > HYPE_ADDR) {
+			/* Trim to edge of hypervisor. */
+			length = HYPE_ADDR - base;
+			if (dec.page_granularity)
+				dec.limit = (length / PAGE_SIZE) - 1;
+			else
+				dec.limit = length - 1;
+		}
+		if (dec.dpl == 0)
+			dec.dpl = GUEST_DPL;
+		gdt[i] = encode_gdt_entry(&dec);
+	}
+	check_live_segments(gdt, regs);
+
+	/* Now put in hypervisor data and code segments. */
+	gdt[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+	gdt[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+
+	/* Finally, TSS entry */
+	dec.base = (unsigned long)tss;
+	dec.limit = sizeof(*tss)-1;
+	dec.type = 0x9;
+	dec.dtype = 0;
+	dec.def = 0;
+	dec.present = 1;
+	dec.mbz = 0;
+	dec.page_granularity = 0;
+	gdt[GDT_ENTRY_TSS] = encode_gdt_entry(&dec);
+
+	return 1;
+}
+
+void load_guest_gdt(struct lguest *lg, u32 table, u32 num)
+{
+	if (num > GDT_ENTRIES)
+		kill_guest(lg, "too many gdt entries %i", num);
+
+	lhread(lg, lg->state->gdt_table, table,
+	       num * sizeof(lg->state->gdt_table[0]));
+	if (!fixup_gdt_table(lg->state->gdt_table, num,
+			     &lg->state->regs, &lg->state->tss))
+		kill_guest(lg, "bad gdt table");
+}
+
+/* We don't care about limit here, since we only let them use these in
+ * usermode (where lack of USER bit in pagetable protects hypervisor mem).
+ * However, we want to ensure it doesn't fault when loaded, since *we* are
+ * the ones who will load it in switch_to_guest.
+ */
+void guest_load_tls(struct lguest *lg, const struct desc_struct __user *gtls)
+{
+	unsigned int i;
+	struct desc_struct *tls = &lg->state->gdt_table[GDT_ENTRY_TLS_MIN];
+
+	lhread(lg, tls, (u32)gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
+	for (i = 0; i < ARRAY_SIZE(lg->tls_limits); i++) {
+		struct decoded_gdt_entry dec = decode_gdt_entry(&tls[i]);
+
+		if (!dec.present)
+			continue;
+
+		/* We truncate to one byte/page (depending on G bit) to neuter
+		   it, so ensure it's more than 1 page below trap page. */
+		tls[i].a &= 0xFFFF0000;
+		lg->tls_limits[i] = dec.limit;
+		if (!check_desc(&dec) || dec.base > HYPE_ADDR - PAGE_SIZE)
+			kill_guest(lg, "bad TLS descriptor %i", i);
+	}
+	check_live_segments(lg->state->gdt_table, &lg->state->regs);
+}
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-the-host-code-lgko.patch
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
