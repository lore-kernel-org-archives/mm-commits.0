From: akpm@linux-foundation.org
Subject: - lguest-the-host-code.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:54 -0700
Message-ID: <200707192004.l6JK4sZP019989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759560AbXGSUfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, dada1@cosmosbay.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     lguest: the host code
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: the host code
From: Rusty Russell <rusty@rustcorp.com.au>

This is the code for the "lg.ko" module, which allows lguest guests to
be launched.

[akpm@linux-foundation.org: update for futex-new-private-futexes]
[akpm@linux-foundation.org: build fix]
[jmorris@namei.org: lguest: use hrtimers]
[akpm@linux-foundation.org: x86_64 build fix]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c                |    4 
 arch/x86_64/kernel/tsc.c              |    2 
 drivers/lguest/core.c                 |  462 ++++++++++++++++++++++++
 drivers/lguest/hypercalls.c           |  192 +++++++++
 drivers/lguest/interrupts_and_traps.c |  268 +++++++++++++
 drivers/lguest/io.c                   |  399 ++++++++++++++++++++
 drivers/lguest/lg.h                   |  261 +++++++++++++
 drivers/lguest/lguest.c               |  125 +++++-
 drivers/lguest/lguest_asm.S           |    5 
 drivers/lguest/lguest_user.c          |  236 ++++++++++++
 drivers/lguest/page_tables.c          |  411 +++++++++++++++++++++
 drivers/lguest/segments.c             |  125 ++++++
 drivers/lguest/switcher.S             |  159 ++++++++
 include/asm-i386/tsc.h                |    1 
 include/linux/lguest.h                |   12 
 include/linux/lguest_launcher.h       |   73 +++
 kernel/fork.c                         |    1 
 17 files changed, 2702 insertions(+), 34 deletions(-)

diff -puN arch/i386/kernel/tsc.c~lguest-the-host-code arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~lguest-the-host-code
+++ a/arch/i386/kernel/tsc.c
@@ -27,6 +27,7 @@ static int tsc_enabled;
  * an extra value to store the TSC freq
  */
 unsigned int tsc_khz;
+EXPORT_SYMBOL_GPL(tsc_khz);
 
 int tsc_disable;
 
@@ -58,10 +59,11 @@ __setup("notsc", tsc_setup);
  */
 static int tsc_unstable;
 
-static inline int check_tsc_unstable(void)
+int check_tsc_unstable(void)
 {
 	return tsc_unstable;
 }
+EXPORT_SYMBOL_GPL(check_tsc_unstable);
 
 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
diff -puN arch/x86_64/kernel/tsc.c~lguest-the-host-code arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~lguest-the-host-code
+++ a/arch/x86_64/kernel/tsc.c
@@ -44,7 +44,7 @@ unsigned long long sched_clock(void)
 
 static int tsc_unstable;
 
-static inline int check_tsc_unstable(void)
+inline int check_tsc_unstable(void)
 {
 	return tsc_unstable;
 }
diff -puN /dev/null drivers/lguest/core.c
--- /dev/null
+++ a/drivers/lguest/core.c
@@ -0,0 +1,462 @@
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
+/* Found in switcher.S */
+extern char start_switcher_text[], end_switcher_text[], switch_to_guest[];
+extern unsigned long default_idt_entries[];
+
+/* Every guest maps the core switcher code. */
+#define SHARED_SWITCHER_PAGES \
+	DIV_ROUND_UP(end_switcher_text - start_switcher_text, PAGE_SIZE)
+/* Pages for switcher itself, then two pages per cpu */
+#define TOTAL_SWITCHER_PAGES (SHARED_SWITCHER_PAGES + 2 * NR_CPUS)
+
+/* We map at -4M for ease of mapping into the guest (one PTE page). */
+#define SWITCHER_ADDR 0xFFC00000
+
+static struct vm_struct *switcher_vma;
+static struct page **switcher_page;
+
+static int cpu_had_pge;
+static struct {
+	unsigned long offset;
+	unsigned short segment;
+} lguest_entry;
+
+/* This One Big lock protects all inter-guest data structures. */
+DEFINE_MUTEX(lguest_lock);
+static DEFINE_PER_CPU(struct lguest *, last_guest);
+
+/* FIXME: Make dynamic. */
+#define MAX_LGUEST_GUESTS 16
+struct lguest lguests[MAX_LGUEST_GUESTS];
+
+/* Offset from where switcher.S was compiled to where we've copied it */
+static unsigned long switcher_offset(void)
+{
+	return SWITCHER_ADDR - (unsigned long)start_switcher_text;
+}
+
+/* This cpu's struct lguest_pages. */
+static struct lguest_pages *lguest_pages(unsigned int cpu)
+{
+	return &(((struct lguest_pages *)
+		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
+}
+
+static __init int map_switcher(void)
+{
+	int i, err;
+	struct page **pagep;
+
+	switcher_page = kmalloc(sizeof(switcher_page[0])*TOTAL_SWITCHER_PAGES,
+				GFP_KERNEL);
+	if (!switcher_page) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++) {
+		unsigned long addr = get_zeroed_page(GFP_KERNEL);
+		if (!addr) {
+			err = -ENOMEM;
+			goto free_some_pages;
+		}
+		switcher_page[i] = virt_to_page(addr);
+	}
+
+	switcher_vma = __get_vm_area(TOTAL_SWITCHER_PAGES * PAGE_SIZE,
+				       VM_ALLOC, SWITCHER_ADDR, VMALLOC_END);
+	if (!switcher_vma) {
+		err = -ENOMEM;
+		printk("lguest: could not map switcher pages high\n");
+		goto free_pages;
+	}
+
+	pagep = switcher_page;
+	err = map_vm_area(switcher_vma, PAGE_KERNEL, &pagep);
+	if (err) {
+		printk("lguest: map_vm_area failed: %i\n", err);
+		goto free_vma;
+	}
+	memcpy(switcher_vma->addr, start_switcher_text,
+	       end_switcher_text - start_switcher_text);
+
+	/* Fix up IDT entries to point into copied text. */
+	for (i = 0; i < IDT_ENTRIES; i++)
+		default_idt_entries[i] += switcher_offset();
+
+	for_each_possible_cpu(i) {
+		struct lguest_pages *pages = lguest_pages(i);
+		struct lguest_ro_state *state = &pages->state;
+
+		/* These fields are static: rest done in copy_in_guest_info */
+		state->host_gdt_desc.size = GDT_SIZE-1;
+		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
+		store_idt(&state->host_idt_desc);
+		state->guest_idt_desc.size = sizeof(state->guest_idt)-1;
+		state->guest_idt_desc.address = (long)&state->guest_idt;
+		state->guest_gdt_desc.size = sizeof(state->guest_gdt)-1;
+		state->guest_gdt_desc.address = (long)&state->guest_gdt;
+		state->guest_tss.esp0 = (long)(&pages->regs + 1);
+		state->guest_tss.ss0 = LGUEST_DS;
+		/* No I/O for you! */
+		state->guest_tss.io_bitmap_base = sizeof(state->guest_tss);
+		setup_default_gdt_entries(state);
+		setup_default_idt_entries(state, default_idt_entries);
+
+		/* Setup LGUEST segments on all cpus */
+		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+	}
+
+	/* Initialize entry point into switcher. */
+	lguest_entry.offset = (long)switch_to_guest + switcher_offset();
+	lguest_entry.segment = LGUEST_CS;
+
+	printk(KERN_INFO "lguest: mapped switcher at %p\n",
+	       switcher_vma->addr);
+	return 0;
+
+free_vma:
+	vunmap(switcher_vma->addr);
+free_pages:
+	i = TOTAL_SWITCHER_PAGES;
+free_some_pages:
+	for (--i; i >= 0; i--)
+		__free_pages(switcher_page[i], 0);
+	kfree(switcher_page);
+out:
+	return err;
+}
+
+static void unmap_switcher(void)
+{
+	unsigned int i;
+
+	vunmap(switcher_vma->addr);
+	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++)
+		__free_pages(switcher_page[i], 0);
+}
+
+/* IN/OUT insns: enough to get us past boot-time probing. */
+static int emulate_insn(struct lguest *lg)
+{
+	u8 insn;
+	unsigned int insnlen = 0, in = 0, shift = 0;
+	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
+
+	/* This only works for addresses in linear mapping... */
+	if (lg->regs->eip < lg->page_offset)
+		return 0;
+	lgread(lg, &insn, physaddr, 1);
+
+	/* Operand size prefix means it's actually for ax. */
+	if (insn == 0x66) {
+		shift = 16;
+		insnlen = 1;
+		lgread(lg, &insn, physaddr + insnlen, 1);
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
+			lg->regs->eax = 0xFFFFFFFF;
+		else
+			lg->regs->eax |= (0xFFFF << shift);
+	}
+	lg->regs->eip += insnlen;
+	return 1;
+}
+
+int lguest_address_ok(const struct lguest *lg,
+		      unsigned long addr, unsigned long len)
+{
+	return (addr+len) / PAGE_SIZE < lg->pfn_limit && (addr+len >= addr);
+}
+
+/* Just like get_user, but don't let guest access lguest binary. */
+u32 lgread_u32(struct lguest *lg, unsigned long addr)
+{
+	u32 val = 0;
+
+	/* Don't let them access lguest binary */
+	if (!lguest_address_ok(lg, addr, sizeof(val))
+	    || get_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad read address %#lx", addr);
+	return val;
+}
+
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val)
+{
+	if (!lguest_address_ok(lg, addr, sizeof(val))
+	    || put_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad write address %#lx", addr);
+}
+
+void lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
+{
+	if (!lguest_address_ok(lg, addr, bytes)
+	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
+		/* copy_from_user should do this, but as we rely on it... */
+		memset(b, 0, bytes);
+		kill_guest(lg, "bad read address %#lx len %u", addr, bytes);
+	}
+}
+
+void lgwrite(struct lguest *lg, unsigned long addr, const void *b,
+	     unsigned bytes)
+{
+	if (!lguest_address_ok(lg, addr, bytes)
+	    || copy_to_user((void __user *)addr, b, bytes) != 0)
+		kill_guest(lg, "bad write address %#lx len %u", addr, bytes);
+}
+
+static void set_ts(void)
+{
+	u32 cr0;
+
+	cr0 = read_cr0();
+	if (!(cr0 & 8))
+		write_cr0(cr0|8);
+}
+
+static void copy_in_guest_info(struct lguest *lg, struct lguest_pages *pages)
+{
+	if (__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
+		__get_cpu_var(last_guest) = lg;
+		lg->last_pages = pages;
+		lg->changed = CHANGED_ALL;
+	}
+
+	/* These are pretty cheap, so we do them unconditionally. */
+	pages->state.host_cr3 = __pa(current->mm->pgd);
+	map_switcher_in_guest(lg, pages);
+	pages->state.guest_tss.esp1 = lg->esp1;
+	pages->state.guest_tss.ss1 = lg->ss1;
+
+	/* Copy direct trap entries. */
+	if (lg->changed & CHANGED_IDT)
+		copy_traps(lg, pages->state.guest_idt, default_idt_entries);
+
+	/* Copy all GDT entries but the TSS. */
+	if (lg->changed & CHANGED_GDT)
+		copy_gdt(lg, pages->state.guest_gdt);
+	/* If only the TLS entries have changed, copy them. */
+	else if (lg->changed & CHANGED_GDT_TLS)
+		copy_gdt_tls(lg, pages->state.guest_gdt);
+
+	lg->changed = 0;
+}
+
+static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
+{
+	unsigned int clobber;
+
+	copy_in_guest_info(lg, pages);
+
+	/* Put eflags on stack, lcall does rest: suitable for iret return. */
+	asm volatile("pushf; lcall *lguest_entry"
+		     : "=a"(clobber), "=b"(clobber)
+		     : "0"(pages), "1"(__pa(lg->pgdirs[lg->pgdidx].pgdir))
+		     : "memory", "%edx", "%ecx", "%edi", "%esi");
+}
+
+int run_guest(struct lguest *lg, unsigned long __user *user)
+{
+	while (!lg->dead) {
+		unsigned int cr2 = 0; /* Damn gcc */
+
+		/* Hypercalls first: we might have been out to userspace */
+		do_hypercalls(lg);
+		if (lg->dma_is_pending) {
+			if (put_user(lg->pending_dma, user) ||
+			    put_user(lg->pending_key, user+1))
+				return -EFAULT;
+			return sizeof(unsigned long)*2;
+		}
+
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		/* If Waker set break_out, return to Launcher. */
+		if (lg->break_out)
+			return -EAGAIN;
+
+		maybe_do_interrupt(lg);
+
+		try_to_freeze();
+
+		if (lg->dead)
+			break;
+
+		if (lg->halted) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+			continue;
+		}
+
+		local_irq_disable();
+
+		/* Even if *we* don't want FPU trap, guest might... */
+		if (lg->ts)
+			set_ts();
+
+		/* Don't let Guest do SYSENTER: we can't handle it. */
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, 0, 0);
+
+		run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
+
+		/* Save cr2 now if we page-faulted. */
+		if (lg->regs->trapnum == 14)
+			cr2 = read_cr2();
+		else if (lg->regs->trapnum == 7)
+			math_state_restore();
+
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+		local_irq_enable();
+
+		switch (lg->regs->trapnum) {
+		case 13: /* We've intercepted a GPF. */
+			if (lg->regs->errcode == 0) {
+				if (emulate_insn(lg))
+					continue;
+			}
+			break;
+		case 14: /* We've intercepted a page fault. */
+			if (demand_page(lg, cr2, lg->regs->errcode))
+				continue;
+
+			/* If lguest_data is NULL, this won't hurt. */
+			if (put_user(cr2, &lg->lguest_data->cr2))
+				kill_guest(lg, "Writing cr2");
+			break;
+		case 7: /* We've intercepted a Device Not Available fault. */
+			/* If they don't want to know, just absorb it. */
+			if (!lg->ts)
+				continue;
+			break;
+		case 32 ... 255: /* Real interrupt, fall thru */
+			cond_resched();
+		case LGUEST_TRAP_ENTRY: /* Handled at top of loop */
+			continue;
+		}
+
+		if (deliver_trap(lg, lg->regs->trapnum))
+			continue;
+
+		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
+			   lg->regs->trapnum, lg->regs->eip,
+			   lg->regs->trapnum == 14 ? cr2 : lg->regs->errcode);
+	}
+	return -ENOENT;
+}
+
+int find_free_guest(void)
+{
+	unsigned int i;
+	for (i = 0; i < MAX_LGUEST_GUESTS; i++)
+		if (!lguests[i].tsk)
+			return i;
+	return -1;
+}
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
+	if (paravirt_enabled()) {
+		printk("lguest is afraid of %s\n", paravirt_ops.name);
+		return -EPERM;
+	}
+
+	err = map_switcher();
+	if (err)
+		return err;
+
+	err = init_pagetables(switcher_page, SHARED_SWITCHER_PAGES);
+	if (err) {
+		unmap_switcher();
+		return err;
+	}
+	lguest_io_init();
+
+	err = lguest_device_init();
+	if (err) {
+		free_pagetables();
+		unmap_switcher();
+		return err;
+	}
+	lock_cpu_hotplug();
+	if (cpu_has_pge) { /* We have a broader idea of "global". */
+		cpu_had_pge = 1;
+		on_each_cpu(adjust_pge, (void *)0, 0, 1);
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
+	unmap_switcher();
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
diff -puN /dev/null drivers/lguest/hypercalls.c
--- /dev/null
+++ a/drivers/lguest/hypercalls.c
@@ -0,0 +1,192 @@
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
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <irq_vectors.h>
+#include "lg.h"
+
+static void do_hcall(struct lguest *lg, struct lguest_regs *regs)
+{
+	switch (regs->eax) {
+	case LHCALL_FLUSH_ASYNC:
+		break;
+	case LHCALL_LGUEST_INIT:
+		kill_guest(lg, "already have lguest_data");
+		break;
+	case LHCALL_CRASH: {
+		char msg[128];
+		lgread(lg, msg, regs->edx, sizeof(msg));
+		msg[sizeof(msg)-1] = '\0';
+		kill_guest(lg, "CRASH: %s", msg);
+		break;
+	}
+	case LHCALL_FLUSH_TLB:
+		if (regs->edx)
+			guest_pagetable_clear_all(lg);
+		else
+			guest_pagetable_flush_user(lg);
+		break;
+	case LHCALL_GET_WALLCLOCK: {
+		struct timespec ts;
+		ktime_get_real_ts(&ts);
+		regs->eax = ts.tv_sec;
+		break;
+	}
+	case LHCALL_BIND_DMA:
+		regs->eax = bind_dma(lg, regs->edx, regs->ebx,
+				     regs->ecx >> 8, regs->ecx & 0xFF);
+		break;
+	case LHCALL_SEND_DMA:
+		send_dma(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_GDT:
+		load_guest_gdt(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_IDT_ENTRY:
+		load_guest_idt_entry(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_NEW_PGTABLE:
+		guest_new_pagetable(lg, regs->edx);
+		break;
+	case LHCALL_SET_STACK:
+		guest_set_stack(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_SET_PTE:
+		guest_set_pte(lg, regs->edx, regs->ebx, mkgpte(regs->ecx));
+		break;
+	case LHCALL_SET_PMD:
+		guest_set_pmd(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_TLS:
+		guest_load_tls(lg, regs->edx);
+		break;
+	case LHCALL_SET_CLOCKEVENT:
+		guest_set_clockevent(lg, regs->edx);
+		break;
+	case LHCALL_TS:
+		lg->ts = regs->edx;
+		break;
+	case LHCALL_HALT:
+		lg->halted = 1;
+		break;
+	default:
+		kill_guest(lg, "Bad hypercall %li\n", regs->eax);
+	}
+}
+
+/* We always do queued calls before actual hypercall. */
+static void do_async_hcalls(struct lguest *lg)
+{
+	unsigned int i;
+	u8 st[LHCALL_RING_SIZE];
+
+	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
+		return;
+
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
+		if (get_user(regs.eax, &lg->lguest_data->hcalls[n].eax)
+		    || get_user(regs.edx, &lg->lguest_data->hcalls[n].edx)
+		    || get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx)
+		    || get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx)) {
+			kill_guest(lg, "Fetching async hypercalls");
+			break;
+		}
+
+		do_hcall(lg, &regs);
+		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
+			kill_guest(lg, "Writing result for async hypercall");
+			break;
+		}
+
+		if (lg->dma_is_pending)
+			break;
+	}
+}
+
+static void initialize(struct lguest *lg)
+{
+	u32 tsc_speed;
+
+	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
+		kill_guest(lg, "hypercall %li before LGUEST_INIT",
+			   lg->regs->eax);
+		return;
+	}
+
+	/* We only tell the guest to use the TSC if it's reliable. */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) && !check_tsc_unstable())
+		tsc_speed = tsc_khz;
+	else
+		tsc_speed = 0;
+
+	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
+	/* We check here so we can simply copy_to_user/from_user */
+	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+		return;
+	}
+	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
+	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
+	    /* We reserve the top pgd entry. */
+	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
+	    || put_user(tsc_speed, &lg->lguest_data->tsc_khz)
+	    || put_user(lg->guestid, &lg->lguest_data->guestid))
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+
+	/* This is the one case where the above accesses might have
+	 * been the first write to a Guest page.  This may have caused
+	 * a copy-on-write fault, but the Guest might be referring to
+	 * the old (read-only) page. */
+	guest_pagetable_clear_all(lg);
+}
+
+/* Even if we go out to userspace and come back, we don't want to do
+ * the hypercall again. */
+static void clear_hcall(struct lguest *lg)
+{
+	lg->regs->trapnum = 255;
+}
+
+void do_hypercalls(struct lguest *lg)
+{
+	if (unlikely(!lg->lguest_data)) {
+		if (lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
+			initialize(lg);
+			clear_hcall(lg);
+		}
+		return;
+	}
+
+	do_async_hcalls(lg);
+	if (!lg->dma_is_pending && lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
+		do_hcall(lg, lg->regs);
+		clear_hcall(lg);
+	}
+}
diff -puN /dev/null drivers/lguest/interrupts_and_traps.c
--- /dev/null
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -0,0 +1,268 @@
+#include <linux/uaccess.h>
+#include "lg.h"
+
+static unsigned long idt_address(u32 lo, u32 hi)
+{
+	return (lo & 0x0000FFFF) | (hi & 0xFFFF0000);
+}
+
+static int idt_type(u32 lo, u32 hi)
+{
+	return (hi >> 8) & 0xF;
+}
+
+static int idt_present(u32 lo, u32 hi)
+{
+	return (hi & 0x8000);
+}
+
+static void push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
+{
+	*gstack -= 4;
+	lgwrite_u32(lg, *gstack, val);
+}
+
+static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
+{
+	unsigned long gstack;
+	u32 eflags, ss, irq_enable;
+
+	/* If they want a ring change, we use new stack and push old ss/esp */
+	if ((lg->regs->ss&0x3) != GUEST_PL) {
+		gstack = guest_pa(lg, lg->esp1);
+		ss = lg->ss1;
+		push_guest_stack(lg, &gstack, lg->regs->ss);
+		push_guest_stack(lg, &gstack, lg->regs->esp);
+	} else {
+		gstack = guest_pa(lg, lg->regs->esp);
+		ss = lg->regs->ss;
+	}
+
+	/* We use IF bit in eflags to indicate whether irqs were disabled
+	   (it's always 0, since irqs are enabled when guest is running). */
+	eflags = lg->regs->eflags;
+	if (get_user(irq_enable, &lg->lguest_data->irq_enabled))
+		irq_enable = 0;
+	eflags |= (irq_enable & X86_EFLAGS_IF);
+
+	push_guest_stack(lg, &gstack, eflags);
+	push_guest_stack(lg, &gstack, lg->regs->cs);
+	push_guest_stack(lg, &gstack, lg->regs->eip);
+
+	if (has_err)
+		push_guest_stack(lg, &gstack, lg->regs->errcode);
+
+	/* Change the real stack so switcher returns to trap handler */
+	lg->regs->ss = ss;
+	lg->regs->esp = gstack + lg->page_offset;
+	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
+	lg->regs->eip = idt_address(lo, hi);
+
+	/* Disable interrupts for an interrupt gate. */
+	if (idt_type(lo, hi) == 0xE)
+		if (put_user(0, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Disabling interrupts");
+}
+
+void maybe_do_interrupt(struct lguest *lg)
+{
+	unsigned int irq;
+	DECLARE_BITMAP(blk, LGUEST_IRQS);
+	struct desc_struct *idt;
+
+	if (!lg->lguest_data)
+		return;
+
+	/* Mask out any interrupts they have blocked. */
+	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
+			   sizeof(blk)))
+		return;
+
+	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
+
+	irq = find_first_bit(blk, LGUEST_IRQS);
+	if (irq >= LGUEST_IRQS)
+		return;
+
+	if (lg->regs->eip >= lg->noirq_start && lg->regs->eip < lg->noirq_end)
+		return;
+
+	/* If they're halted, we re-enable interrupts. */
+	if (lg->halted) {
+		/* Re-enable interrupts. */
+		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Re-enabling interrupts");
+		lg->halted = 0;
+	} else {
+		/* Maybe they have interrupts disabled? */
+		u32 irq_enabled;
+		if (get_user(irq_enabled, &lg->lguest_data->irq_enabled))
+			irq_enabled = 0;
+		if (!irq_enabled)
+			return;
+	}
+
+	idt = &lg->idt[FIRST_EXTERNAL_VECTOR+irq];
+	if (idt_present(idt->a, idt->b)) {
+		clear_bit(irq, lg->irqs_pending);
+		set_guest_interrupt(lg, idt->a, idt->b, 0);
+	}
+}
+
+static int has_err(unsigned int trap)
+{
+	return (trap == 8 || (trap >= 10 && trap <= 14) || trap == 17);
+}
+
+int deliver_trap(struct lguest *lg, unsigned int num)
+{
+	u32 lo = lg->idt[num].a, hi = lg->idt[num].b;
+
+	if (!idt_present(lo, hi))
+		return 0;
+	set_guest_interrupt(lg, lo, hi, has_err(num));
+	return 1;
+}
+
+static int direct_trap(const struct lguest *lg,
+		       const struct desc_struct *trap,
+		       unsigned int num)
+{
+	/* Hardware interrupts don't go to guest (except syscall). */
+	if (num >= FIRST_EXTERNAL_VECTOR && num != SYSCALL_VECTOR)
+		return 0;
+
+	/* We intercept page fault (demand shadow paging & cr2 saving)
+	   protection fault (in/out emulation) and device not
+	   available (TS handling), and hypercall */
+	if (num == 14 || num == 13 || num == 7 || num == LGUEST_TRAP_ENTRY)
+		return 0;
+
+	/* Interrupt gates (0xE) or not present (0x0) can't go direct. */
+	return idt_type(trap->a, trap->b) == 0xF;
+}
+
+void pin_stack_pages(struct lguest *lg)
+{
+	unsigned int i;
+
+	for (i = 0; i < lg->stack_pages; i++)
+		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
+}
+
+void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages)
+{
+	/* You cannot have a stack segment with priv level 0. */
+	if ((seg & 0x3) != GUEST_PL)
+		kill_guest(lg, "bad stack segment %i", seg);
+	if (pages > 2)
+		kill_guest(lg, "bad stack pages %u", pages);
+	lg->ss1 = seg;
+	lg->esp1 = esp;
+	lg->stack_pages = pages;
+	pin_stack_pages(lg);
+}
+
+/* Set up trap in IDT. */
+static void set_trap(struct lguest *lg, struct desc_struct *trap,
+		     unsigned int num, u32 lo, u32 hi)
+{
+	u8 type = idt_type(lo, hi);
+
+	if (!idt_present(lo, hi)) {
+		trap->a = trap->b = 0;
+		return;
+	}
+
+	if (type != 0xE && type != 0xF)
+		kill_guest(lg, "bad IDT type %i", type);
+
+	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
+	trap->b = (hi&0xFFFFEF00);
+}
+
+void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
+{
+	/* Guest never handles: NMI, doublefault, hypercall, spurious irq. */
+	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
+		return;
+
+	lg->changed |= CHANGED_IDT;
+	if (num < ARRAY_SIZE(lg->idt))
+		set_trap(lg, &lg->idt[num], num, lo, hi);
+	else if (num == SYSCALL_VECTOR)
+		set_trap(lg, &lg->syscall_idt, num, lo, hi);
+}
+
+static void default_idt_entry(struct desc_struct *idt,
+			      int trap,
+			      const unsigned long handler)
+{
+	u32 flags = 0x8e00;
+
+	/* They can't "int" into any of them except hypercall. */
+	if (trap == LGUEST_TRAP_ENTRY)
+		flags |= (GUEST_PL << 13);
+
+	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
+	idt->b = (handler&0xFFFF0000) | flags;
+}
+
+void setup_default_idt_entries(struct lguest_ro_state *state,
+			       const unsigned long *def)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(state->guest_idt); i++)
+		default_idt_entry(&state->guest_idt[i], i, def[i]);
+}
+
+void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+		const unsigned long *def)
+{
+	unsigned int i;
+
+	/* All hardware interrupts are same whatever the guest: only the
+	 * traps might be different. */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
+		if (direct_trap(lg, &lg->idt[i], i))
+			idt[i] = lg->idt[i];
+		else
+			default_idt_entry(&idt[i], i, def[i]);
+	}
+	i = SYSCALL_VECTOR;
+	if (direct_trap(lg, &lg->syscall_idt, i))
+		idt[i] = lg->syscall_idt;
+	else
+		default_idt_entry(&idt[i], i, def[i]);
+}
+
+void guest_set_clockevent(struct lguest *lg, unsigned long delta)
+{
+	ktime_t expires;
+
+	if (unlikely(delta == 0)) {
+		/* Clock event device is shutting down. */
+		hrtimer_cancel(&lg->hrt);
+		return;
+	}
+
+	expires = ktime_add_ns(ktime_get_real(), delta);
+	hrtimer_start(&lg->hrt, expires, HRTIMER_MODE_ABS);
+}
+
+static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
+{
+	struct lguest *lg = container_of(timer, struct lguest, hrt);
+
+	set_bit(0, lg->irqs_pending);
+	if (lg->halted)
+		wake_up_process(lg->tsk);
+	return HRTIMER_NORESTART;
+}
+
+void init_clockdev(struct lguest *lg)
+{
+	hrtimer_init(&lg->hrt, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	lg->hrt.function = clockdev_fn;
+}
diff -puN /dev/null drivers/lguest/io.c
--- /dev/null
+++ a/drivers/lguest/io.c
@@ -0,0 +1,399 @@
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
+static struct list_head dma_hash[61];
+
+void lguest_io_init(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dma_hash); i++)
+		INIT_LIST_HEAD(&dma_hash[i]);
+}
+
+/* FIXME: allow multi-page lengths. */
+static int check_dma_list(struct lguest *lg, const struct lguest_dma *dma)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_MAX_DMA_SECTIONS; i++) {
+		if (!dma->len[i])
+			return 1;
+		if (!lguest_address_ok(lg, dma->addr[i], dma->len[i]))
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
+	kill_guest(lg, "bad DMA entry: %u@%#lx", dma->len[i], dma->addr[i]);
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
+static inline int key_eq(const union futex_key *a, const union futex_key *b)
+{
+	return (a->both.word == b->both.word
+		&& a->both.ptr == b->both.ptr
+		&& a->both.offset == b->both.offset);
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
+static int unbind_dma(struct lguest *lg,
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
+int bind_dma(struct lguest *lg,
+	     unsigned long ukey, unsigned long dmas, u16 numdmas, u8 interrupt)
+{
+	unsigned int i;
+	int ret = 0;
+	union futex_key key;
+	struct rw_semaphore *fshared = &current->mm->mmap_sem;
+
+	if (interrupt >= LGUEST_IRQS)
+		return 0;
+
+	mutex_lock(&lguest_lock);
+	down_read(fshared);
+	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
+		kill_guest(lg, "bad dma key %#lx", ukey);
+		goto unlock;
+	}
+	get_futex_key_refs(&key);
+
+	if (interrupt == 0)
+		ret = unbind_dma(lg, &key, dmas);
+	else {
+		for (i = 0; i < LGUEST_MAX_DMA; i++) {
+			if (lg->dma[i].interrupt)
+				continue;
+
+			lg->dma[i].dmas = dmas;
+			lg->dma[i].num_dmas = numdmas;
+			lg->dma[i].next_dma = 0;
+			lg->dma[i].key = key;
+			lg->dma[i].guestid = lg->guestid;
+			lg->dma[i].interrupt = interrupt;
+			list_add(&lg->dma[i].list, &dma_hash[hash(&key)]);
+			ret = 1;
+			goto unlock;
+		}
+	}
+	drop_futex_key_refs(&key);
+unlock:
+ 	up_read(fshared);
+	mutex_unlock(&lguest_lock);
+	return ret;
+}
+
+/* lgread from another guest */
+static int lgread_other(struct lguest *lg,
+			void *buf, u32 addr, unsigned bytes)
+{
+	if (!lguest_address_ok(lg, addr, bytes)
+	    || access_process_vm(lg->tsk, addr, buf, bytes, 0) != bytes) {
+		memset(buf, 0, bytes);
+		kill_guest(lg, "bad address in registered DMA struct");
+		return 0;
+	}
+	return 1;
+}
+
+/* lgwrite to another guest */
+static int lgwrite_other(struct lguest *lg, u32 addr,
+			 const void *buf, unsigned bytes)
+{
+	if (!lguest_address_ok(lg, addr, bytes)
+	    || (access_process_vm(lg->tsk, addr, (void *)buf, bytes, 1)
+		!= bytes)) {
+		kill_guest(lg, "bad address writing to registered DMA");
+		return 0;
+	}
+	return 1;
+}
+
+static u32 copy_data(struct lguest *srclg,
+		     const struct lguest_dma *src,
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
+			kill_guest(srclg, "bad address in sending DMA");
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
+			kill_guest(dstlg, "Error mapping DMA pages");
+			ret = 0;
+			goto drop_pages;
+		}
+	}
+
+	/* Now copy until we run out of src or dst. */
+	ret = copy_data(srclg, src, dst, pages);
+
+drop_pages:
+	while (--i >= 0)
+		put_page(pages[i]);
+	return ret;
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
+	lgread(srclg, &src_dma, udma, sizeof(src_dma));
+
+	/* We can't deadlock against them dmaing to us, because this
+	 * is all under the lguest_lock. */
+	down_read(&dstlg->mm->mmap_sem);
+
+	for (i = 0; i < dst->num_dmas; i++) {
+		dma = (dst->next_dma + i) % dst->num_dmas;
+		if (!lgread_other(dstlg, &dst_dma,
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
+		lgwrite_u32(srclg,
+			    udma+offsetof(struct lguest_dma, used_len), ret);
+		if (ret == 0 && src_dma.len[0] != 0)
+			goto fail;
+
+		/* Make sure destination sees contents before length. */
+		wmb();
+		used_lenp = dst->dmas
+			+ dma * sizeof(struct lguest_dma)
+			+ offsetof(struct lguest_dma, used_len);
+		lgwrite_other(dstlg, used_lenp, &ret, sizeof(ret));
+		dst->next_dma++;
+	}
+ 	up_read(&dstlg->mm->mmap_sem);
+
+	/* Do this last so dst doesn't simply sleep on lock. */
+	set_bit(dst->interrupt, dstlg->irqs_pending);
+	wake_up_process(dstlg->tsk);
+	return i == dst->num_dmas;
+
+fail:
+	up_read(&dstlg->mm->mmap_sem);
+	return 0;
+}
+
+void send_dma(struct lguest *lg, unsigned long ukey, unsigned long udma)
+{
+	union futex_key key;
+	int empty = 0;
+	struct rw_semaphore *fshared = &current->mm->mmap_sem;
+
+again:
+	mutex_lock(&lguest_lock);
+	down_read(fshared);
+	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
+		kill_guest(lg, "bad sending DMA key");
+		goto unlock;
+	}
+	/* Shared mapping?  Look for other guests... */
+	if (key.shared.offset & 1) {
+		struct lguest_dma_info *i;
+		list_for_each_entry(i, &dma_hash[hash(&key)], list) {
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
+			empty++;
+			goto again;
+		}
+	} else {
+		/* Private mapping: tell our userspace. */
+		lg->dma_is_pending = 1;
+		lg->pending_dma = udma;
+		lg->pending_key = ukey;
+	}
+unlock:
+	up_read(fshared);
+	mutex_unlock(&lguest_lock);
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
+			     unsigned long ukey, unsigned long *interrupt)
+{
+	unsigned long ret = 0;
+	union futex_key key;
+	struct lguest_dma_info *i;
+	struct rw_semaphore *fshared = &current->mm->mmap_sem;
+
+	mutex_lock(&lguest_lock);
+	down_read(fshared);
+	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
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
+				lgread(lg, &dma, ret, sizeof(dma));
+				if (dma.used_len == 0)
+					break;
+			}
+			*interrupt = i->interrupt;
+			break;
+		}
+	}
+unlock:
+	up_read(fshared);
+	mutex_unlock(&lguest_lock);
+	return ret;
+}
+
diff -puN /dev/null drivers/lguest/lg.h
--- /dev/null
+++ a/drivers/lguest/lg.h
@@ -0,0 +1,261 @@
+#ifndef _LGUEST_H
+#define _LGUEST_H
+
+#include <asm/desc.h>
+
+#define GDT_ENTRY_LGUEST_CS	10
+#define GDT_ENTRY_LGUEST_DS	11
+#define LGUEST_CS		(GDT_ENTRY_LGUEST_CS * 8)
+#define LGUEST_DS		(GDT_ENTRY_LGUEST_DS * 8)
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/stringify.h>
+#include <linux/binfmts.h>
+#include <linux/futex.h>
+#include <linux/lguest.h>
+#include <linux/lguest_launcher.h>
+#include <linux/wait.h>
+#include <linux/err.h>
+#include <asm/semaphore.h>
+#include "irq_vectors.h"
+
+#define GUEST_PL 1
+
+struct lguest_regs
+{
+	/* Manually saved part. */
+	unsigned long ebx, ecx, edx;
+	unsigned long esi, edi, ebp;
+	unsigned long gs;
+	unsigned long eax;
+	unsigned long fs, ds, es;
+	unsigned long trapnum, errcode;
+	/* Trap pushed part */
+	unsigned long eip;
+	unsigned long cs;
+	unsigned long eflags;
+	unsigned long esp;
+	unsigned long ss;
+};
+
+void free_pagetables(void);
+int init_pagetables(struct page **switcher_page, unsigned int pages);
+
+/* Full 4G segment descriptors, suitable for CS and DS. */
+#define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
+#define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
+
+struct lguest_dma_info
+{
+	struct list_head list;
+	union futex_key key;
+	unsigned long dmas;
+	u16 next_dma;
+	u16 num_dmas;
+	u16 guestid;
+	u8 interrupt; 	/* 0 when not registered */
+};
+
+/* We have separate types for the guest's ptes & pgds and the shadow ptes &
+ * pgds.  Since this host might use three-level pagetables and the guest and
+ * shadow pagetables don't, we can't use the normal pte_t/pgd_t. */
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} spgd_t;
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} spte_t;
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} gpgd_t;
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} gpte_t;
+#define mkgpte(_val) ((gpte_t){.raw.val = _val})
+#define mkgpgd(_val) ((gpgd_t){.raw.val = _val})
+
+struct pgdir
+{
+	unsigned long cr3;
+	spgd_t *pgdir;
+};
+
+/* This is a guest-specific page (mapped ro) into the guest. */
+struct lguest_ro_state
+{
+	/* Host information we need to restore when we switch back. */
+	u32 host_cr3;
+	struct Xgt_desc_struct host_idt_desc;
+	struct Xgt_desc_struct host_gdt_desc;
+	u32 host_sp;
+
+	/* Fields which are used when guest is running. */
+	struct Xgt_desc_struct guest_idt_desc;
+	struct Xgt_desc_struct guest_gdt_desc;
+	struct i386_hw_tss guest_tss;
+	struct desc_struct guest_idt[IDT_ENTRIES];
+	struct desc_struct guest_gdt[GDT_ENTRIES];
+};
+
+/* We have two pages shared with guests, per cpu.  */
+struct lguest_pages
+{
+	/* This is the stack page mapped rw in guest */
+	char spare[PAGE_SIZE - sizeof(struct lguest_regs)];
+	struct lguest_regs regs;
+
+	/* This is the host state & guest descriptor page, ro in guest */
+	struct lguest_ro_state state;
+} __attribute__((aligned(PAGE_SIZE)));
+
+#define CHANGED_IDT		1
+#define CHANGED_GDT		2
+#define CHANGED_GDT_TLS		4 /* Actually a subset of CHANGED_GDT */
+#define CHANGED_ALL	        3
+
+/* The private info the thread maintains about the guest. */
+struct lguest
+{
+	/* At end of a page shared mapped over lguest_pages in guest.  */
+	unsigned long regs_page;
+	struct lguest_regs *regs;
+	struct lguest_data __user *lguest_data;
+	struct task_struct *tsk;
+	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
+	u16 guestid;
+	u32 pfn_limit;
+	u32 page_offset;
+	u32 cr2;
+	int halted;
+	int ts;
+	u32 next_hcall;
+	u32 esp1;
+	u8 ss1;
+
+	/* Do we need to stop what we're doing and return to userspace? */
+	int break_out;
+	wait_queue_head_t break_wq;
+
+	/* Bitmap of what has changed: see CHANGED_* above. */
+	int changed;
+	struct lguest_pages *last_pages;
+
+	/* We keep a small number of these. */
+	u32 pgdidx;
+	struct pgdir pgdirs[4];
+
+	/* Cached wakeup: we hold a reference to this task. */
+	struct task_struct *wake;
+
+	unsigned long noirq_start, noirq_end;
+	int dma_is_pending;
+	unsigned long pending_dma; /* struct lguest_dma */
+	unsigned long pending_key; /* address they're sending to */
+
+	unsigned int stack_pages;
+	u32 tsc_khz;
+
+	struct lguest_dma_info dma[LGUEST_MAX_DMA];
+
+	/* Dead? */
+	const char *dead;
+
+	/* The GDT entries copied into lguest_ro_state when running. */
+	struct desc_struct gdt[GDT_ENTRIES];
+
+	/* The IDT entries: some copied into lguest_ro_state when running. */
+	struct desc_struct idt[FIRST_EXTERNAL_VECTOR+LGUEST_IRQS];
+	struct desc_struct syscall_idt;
+
+	/* Virtual clock device */
+	struct hrtimer hrt;
+
+	/* Pending virtual interrupts */
+	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
+};
+
+extern struct lguest lguests[];
+extern struct mutex lguest_lock;
+
+/* core.c: */
+u32 lgread_u32(struct lguest *lg, unsigned long addr);
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val);
+void lgread(struct lguest *lg, void *buf, unsigned long addr, unsigned len);
+void lgwrite(struct lguest *lg, unsigned long, const void *buf, unsigned len);
+int find_free_guest(void);
+int lguest_address_ok(const struct lguest *lg,
+		      unsigned long addr, unsigned long len);
+int run_guest(struct lguest *lg, unsigned long __user *user);
+
+
+/* interrupts_and_traps.c: */
+void maybe_do_interrupt(struct lguest *lg);
+int deliver_trap(struct lguest *lg, unsigned int num);
+void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
+void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
+void pin_stack_pages(struct lguest *lg);
+void setup_default_idt_entries(struct lguest_ro_state *state,
+			       const unsigned long *def);
+void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+		const unsigned long *def);
+void guest_set_clockevent(struct lguest *lg, unsigned long delta);
+void init_clockdev(struct lguest *lg);
+
+/* segments.c: */
+void setup_default_gdt_entries(struct lguest_ro_state *state);
+void setup_guest_gdt(struct lguest *lg);
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
+void guest_load_tls(struct lguest *lg, unsigned long tls_array);
+void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt);
+
+/* page_tables.c: */
+int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
+void free_guest_pagetable(struct lguest *lg);
+void guest_new_pagetable(struct lguest *lg, unsigned long pgtable);
+void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 i);
+void guest_pagetable_clear_all(struct lguest *lg);
+void guest_pagetable_flush_user(struct lguest *lg);
+void guest_set_pte(struct lguest *lg, unsigned long cr3,
+		   unsigned long vaddr, gpte_t val);
+void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
+int demand_page(struct lguest *info, unsigned long cr2, int errcode);
+void pin_page(struct lguest *lg, unsigned long vaddr);
+
+/* lguest_user.c: */
+int lguest_device_init(void);
+void lguest_device_remove(void);
+
+/* io.c: */
+void lguest_io_init(void);
+int bind_dma(struct lguest *lg,
+	     unsigned long key, unsigned long udma, u16 numdmas, u8 interrupt);
+void send_dma(struct lguest *info, unsigned long key, unsigned long udma);
+void release_all_dma(struct lguest *lg);
+unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
+			     unsigned long *interrupt);
+
+/* hypercalls.c: */
+void do_hypercalls(struct lguest *lg);
+
+#define kill_guest(lg, fmt...)					\
+do {								\
+	if (!(lg)->dead) {					\
+		(lg)->dead = kasprintf(GFP_ATOMIC, fmt);	\
+		if (!(lg)->dead)				\
+			(lg)->dead = ERR_PTR(-ENOMEM);		\
+	}							\
+} while(0)
+
+static inline unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
+{
+	return vaddr - lg->page_offset;
+}
+#endif	/* __ASSEMBLY__ */
+#endif	/* _LGUEST_H */
diff -puN drivers/lguest/lguest.c~lguest-the-host-code drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code
+++ a/drivers/lguest/lguest.c
@@ -25,6 +25,8 @@
 #include <linux/screen_info.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/lguest_bus.h>
@@ -37,6 +39,7 @@
 #include <asm/e820.h>
 #include <asm/mce.h>
 #include <asm/io.h>
+//#include <asm/sched-clock.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
@@ -54,7 +57,6 @@ struct lguest_data lguest_data = {
 	.blocked_interrupts = { 1 }, /* Block timer interrupts */
 };
 struct lguest_device_desc *lguest_devices;
-static __initdata const struct lguest_boot_info *boot = __va(0);
 
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
@@ -210,7 +212,7 @@ static void lguest_cpuid(unsigned int *e
 	case 1:	/* Basic feature request. */
 		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
 		*ecx &= 0x00002201;
-		/* Similarly: SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
+		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
 		*edx &= 0x07808101;
 		/* Host wants to know when we flush kernel pages: set PGE. */
 		*edx |= 0x00002000;
@@ -346,24 +348,104 @@ static unsigned long lguest_get_wallcloc
 	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
 }
 
+static cycle_t lguest_clock_read(void)
+{
+	if (lguest_data.tsc_khz)
+		return native_read_tsc();
+	else
+		return jiffies;
+}
+
+/* This is what we tell the kernel is our clocksource.  */
+static struct clocksource lguest_clock = {
+	.name		= "lguest",
+	.rating		= 400,
+	.read		= lguest_clock_read,
+};
+
+/* We also need a "struct clock_event_device": Linux asks us to set it to go
+ * off some time in the future.  Actually, James Morris figured all this out, I
+ * just applied the patch. */
+static int lguest_clockevent_set_next_event(unsigned long delta,
+                                           struct clock_event_device *evt)
+{
+	if (delta < LG_CLOCK_MIN_DELTA) {
+		if (printk_ratelimit())
+			printk(KERN_DEBUG "%s: small delta %lu ns\n",
+			       __FUNCTION__, delta);
+		return -ETIME;
+	}
+	hcall(LHCALL_SET_CLOCKEVENT, delta, 0, 0);
+	return 0;
+}
+
+static void lguest_clockevent_set_mode(enum clock_event_mode mode,
+                                      struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* A 0 argument shuts the clock down. */
+		hcall(LHCALL_SET_CLOCKEVENT, 0, 0, 0);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* This is what we expect. */
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		BUG();
+	}
+}
+
+/* This describes our primitive timer chip. */
+static struct clock_event_device lguest_clockevent = {
+	.name                   = "lguest",
+	.features               = CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event         = lguest_clockevent_set_next_event,
+	.set_mode               = lguest_clockevent_set_mode,
+	.rating                 = INT_MAX,
+	.mult                   = 1,
+	.shift                  = 0,
+	.min_delta_ns           = LG_CLOCK_MIN_DELTA,
+	.max_delta_ns           = LG_CLOCK_MAX_DELTA,
+};
+
+/* This is the Guest timer interrupt handler (hardware interrupt 0).  We just
+ * call the clockevent infrastructure and it does whatever needs doing. */
 static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
 {
-	do_timer(hcall(LHCALL_TIMER_READ, 0, 0, 0));
-	update_process_times(user_mode_vm(get_irq_regs()));
+	unsigned long flags;
+
+	/* Don't interrupt us while this is running. */
+	local_irq_save(flags);
+	lguest_clockevent.event_handler(&lguest_clockevent);
+	local_irq_restore(flags);
 }
 
-static u64 sched_clock_base;
 static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
-	hcall(LHCALL_TIMER_READ, 0, 0, 0);
-	sched_clock_base = jiffies_64;
-	enable_lguest_irq(0);
-}
 
-static unsigned long long lguest_sched_clock(void)
-{
-	return (jiffies_64 - sched_clock_base) * (1000000000 / HZ);
+	/* We use the TSC if the Host tells us we can, otherwise a dumb
+	 * jiffies-based clock. */
+	if (lguest_data.tsc_khz) {
+		lguest_clock.shift = 22;
+		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
+							 lguest_clock.shift);
+		lguest_clock.mask = CLOCKSOURCE_MASK(64);
+		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
+	} else {
+		/* To understand this, start at kernel/time/jiffies.c... */
+		lguest_clock.shift = 8;
+		lguest_clock.mult = (((u64)NSEC_PER_SEC<<8)/ACTHZ) << 8;
+		lguest_clock.mask = CLOCKSOURCE_MASK(32);
+	}
+	clocksource_register(&lguest_clock);
+
+	/* We can't set cpumask in the initializer: damn C limitations! */
+	lguest_clockevent.cpumask = cpumask_of_cpu(0);
+	clockevents_register_device(&lguest_clockevent);
+
+	enable_lguest_irq(0);
 }
 
 static void lguest_load_esp0(struct tss_struct *tss,
@@ -418,8 +500,7 @@ static __init char *lguest_memory_setup(
 	/* We do this here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
 
-	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
+	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
 	return "LGUEST";
 }
 
@@ -450,8 +531,13 @@ static unsigned lguest_patch(u8 type, u1
 	return insn_len;
 }
 
-__init void lguest_init(void)
+__init void lguest_init(void *boot)
 {
+	/* Copy boot parameters first. */
+	memcpy(&boot_params, boot, PARAM_SIZE);
+	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
+	       COMMAND_LINE_SIZE);
+
 	paravirt_ops.name = "lguest";
 	paravirt_ops.paravirt_enabled = 1;
 	paravirt_ops.kernel_rpl = 1;
@@ -498,10 +584,8 @@ __init void lguest_init(void)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
-	paravirt_ops.sched_clock = lguest_sched_clock;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
-	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
 
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
@@ -532,13 +616,6 @@ __init void lguest_init(void)
 
 	add_preferred_console("hvc", 0, NULL);
 
-	if (boot->initrd_size) {
-		/* We stash this at top of memory. */
-		INITRD_START = boot->max_pfn*PAGE_SIZE - boot->initrd_size;
-		INITRD_SIZE = boot->initrd_size;
-		LOADER_TYPE = 0xFF;
-	}
-
 	pm_power_off = lguest_power_off;
 	start_kernel();
 }
diff -puN drivers/lguest/lguest_asm.S~lguest-the-host-code drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S~lguest-the-host-code
+++ a/drivers/lguest/lguest_asm.S
@@ -10,7 +10,8 @@
  * This is where we begin: we have a magic signature which the launcher looks
  * for.  The plan is that the Linux boot protocol will be extended with a
  * "platform type" field which will guide us here from the normal entry point,
- * but for the moment this suffices.
+ * but for the moment this suffices.  We pass the virtual address of the boot
+ * info to lguest_init().
  *
  * We put it in .init.text will be discarded after boot.
  */
@@ -18,6 +19,8 @@
 .ascii "GenuineLguest"
 	/* Set up initial stack. */
  	movl $(init_thread_union+THREAD_SIZE),%esp
+	movl %esi, %eax
+	addl $__PAGE_OFFSET, %eax
 	jmp lguest_init
 
 /* The templates for inline patching. */
diff -puN /dev/null drivers/lguest/lguest_user.c
--- /dev/null
+++ a/drivers/lguest/lguest_user.c
@@ -0,0 +1,236 @@
+/* Userspace control of the guest, via /dev/lguest. */
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include "lg.h"
+
+static void setup_regs(struct lguest_regs *regs, unsigned long start)
+{
+	/* Write out stack in format lguest expects, so we can switch to it. */
+	regs->ds = regs->es = regs->ss = __KERNEL_DS|GUEST_PL;
+	regs->cs = __KERNEL_CS|GUEST_PL;
+	regs->eflags = 0x202; 	/* Interrupts enabled. */
+	regs->eip = start;
+	/* esi points to our boot information (physical address 0) */
+}
+
+/* + addr */
+static long user_get_dma(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long key, udma, irq;
+
+	if (get_user(key, input) != 0)
+		return -EFAULT;
+	udma = get_dma_buffer(lg, key, &irq);
+	if (!udma)
+		return -ENOENT;
+
+	/* We put irq number in udma->used_len. */
+	lgwrite_u32(lg, udma + offsetof(struct lguest_dma, used_len), irq);
+	return udma;
+}
+
+/* To force the Guest to stop running and return to the Launcher, the
+ * Waker sets writes LHREQ_BREAK and the value "1" to /dev/lguest.  The
+ * Launcher then writes LHREQ_BREAK and "0" to release the Waker. */
+static int break_guest_out(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long on;
+
+	/* Fetch whether they're turning break on or off.. */
+	if (get_user(on, input) != 0)
+		return -EFAULT;
+
+	if (on) {
+		lg->break_out = 1;
+		/* Pop it out (may be running on different CPU) */
+		wake_up_process(lg->tsk);
+		/* Wait for them to reset it */
+		return wait_event_interruptible(lg->break_wq, !lg->break_out);
+	} else {
+		lg->break_out = 0;
+		wake_up(&lg->break_wq);
+		return 0;
+	}
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
+	/* If you're not the task which owns the guest, go away. */
+	if (current != lg->tsk)
+		return -EPERM;
+
+	if (lg->dead) {
+		size_t len;
+
+		if (IS_ERR(lg->dead))
+			return PTR_ERR(lg->dead);
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
+	return run_guest(lg, (unsigned long __user *)user);
+}
+
+/* Take: pfnlimit, pgdir, start, pageoffset. */
+static int initialize(struct file *file, const u32 __user *input)
+{
+	struct lguest *lg;
+	int err, i;
+	u32 args[4];
+
+	/* We grab the Big Lguest lock, which protects the global array
+	 * "lguests" and multiple simultaneous initializations. */
+	mutex_lock(&lguest_lock);
+
+	if (file->private_data) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	if (copy_from_user(args, input, sizeof(args)) != 0) {
+		err = -EFAULT;
+		goto unlock;
+	}
+
+	i = find_free_guest();
+	if (i < 0) {
+		err = -ENOSPC;
+		goto unlock;
+	}
+	lg = &lguests[i];
+	lg->guestid = i;
+	lg->pfn_limit = args[0];
+	lg->page_offset = args[3];
+	lg->regs_page = get_zeroed_page(GFP_KERNEL);
+	if (!lg->regs_page) {
+		err = -ENOMEM;
+		goto release_guest;
+	}
+	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
+
+	err = init_guest_pagetable(lg, args[1]);
+	if (err)
+		goto free_regs;
+
+	setup_regs(lg->regs, args[2]);
+	setup_guest_gdt(lg);
+	init_clockdev(lg);
+	lg->tsk = current;
+	lg->mm = get_task_mm(lg->tsk);
+	init_waitqueue_head(&lg->break_wq);
+	lg->last_pages = NULL;
+	file->private_data = lg;
+
+	mutex_unlock(&lguest_lock);
+
+	return sizeof(args);
+
+free_regs:
+	free_page(lg->regs_page);
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
+	/* If you're not the task which owns the Guest, you can only break */
+	if (lg && current != lg->tsk && req != LHREQ_BREAK)
+		return -EPERM;
+
+	switch (req) {
+	case LHREQ_INITIALIZE:
+		return initialize(file, (const u32 __user *)input);
+	case LHREQ_GETDMA:
+		return user_get_dma(lg, (const u32 __user *)input);
+	case LHREQ_IRQ:
+		return user_send_irq(lg, (const u32 __user *)input);
+	case LHREQ_BREAK:
+		return break_guest_out(lg, (const u32 __user *)input);
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
+	/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
+	hrtimer_cancel(&lg->hrt);
+	release_all_dma(lg);
+	free_guest_pagetable(lg);
+	mmput(lg->mm);
+	if (!IS_ERR(lg->dead))
+		kfree(lg->dead);
+	free_page(lg->regs_page);
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
diff -puN /dev/null drivers/lguest/page_tables.c
--- /dev/null
+++ a/drivers/lguest/page_tables.c
@@ -0,0 +1,411 @@
+/* Shadow page table operations.
+ * Copyright (C) Rusty Russell IBM Corporation 2006.
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
+#define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
+
+static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
+#define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
+
+static unsigned vaddr_to_pgd_index(unsigned long vaddr)
+{
+	return vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
+}
+
+/* These access the shadow versions (ie. the ones used by the CPU). */
+static spgd_t *spgd_addr(struct lguest *lg, u32 i, unsigned long vaddr)
+{
+	unsigned int index = vaddr_to_pgd_index(vaddr);
+
+	if (index >= SWITCHER_PGD_INDEX) {
+		kill_guest(lg, "attempt to access switcher pages");
+		index = 0;
+	}
+	return &lg->pgdirs[i].pgdir[index];
+}
+
+static spte_t *spte_addr(struct lguest *lg, spgd_t spgd, unsigned long vaddr)
+{
+	spte_t *page = __va(spgd.pfn << PAGE_SHIFT);
+	BUG_ON(!(spgd.flags & _PAGE_PRESENT));
+	return &page[(vaddr >> PAGE_SHIFT) % PTES_PER_PAGE];
+}
+
+/* These access the guest versions. */
+static unsigned long gpgd_addr(struct lguest *lg, unsigned long vaddr)
+{
+	unsigned int index = vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
+	return lg->pgdirs[lg->pgdidx].cr3 + index * sizeof(gpgd_t);
+}
+
+static unsigned long gpte_addr(struct lguest *lg,
+			       gpgd_t gpgd, unsigned long vaddr)
+{
+	unsigned long gpage = gpgd.pfn << PAGE_SHIFT;
+	BUG_ON(!(gpgd.flags & _PAGE_PRESENT));
+	return gpage + ((vaddr>>PAGE_SHIFT) % PTES_PER_PAGE) * sizeof(gpte_t);
+}
+
+/* Do a virtual -> physical mapping on a user page. */
+static unsigned long get_pfn(unsigned long virtpfn, int write)
+{
+	struct page *page;
+	unsigned long ret = -1UL;
+
+	down_read(&current->mm->mmap_sem);
+	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
+			   1, write, 1, &page, NULL) == 1)
+		ret = page_to_pfn(page);
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
+static spte_t gpte_to_spte(struct lguest *lg, gpte_t gpte, int write)
+{
+	spte_t spte;
+	unsigned long pfn;
+
+	/* We ignore the global flag. */
+	spte.flags = (gpte.flags & ~_PAGE_GLOBAL);
+	pfn = get_pfn(gpte.pfn, write);
+	if (pfn == -1UL) {
+		kill_guest(lg, "failed to get page %u", gpte.pfn);
+		/* Must not put_page() bogus page on cleanup. */
+		spte.flags = 0;
+	}
+	spte.pfn = pfn;
+	return spte;
+}
+
+static void release_pte(spte_t pte)
+{
+	if (pte.flags & _PAGE_PRESENT)
+		put_page(pfn_to_page(pte.pfn));
+}
+
+static void check_gpte(struct lguest *lg, gpte_t gpte)
+{
+	if ((gpte.flags & (_PAGE_PWT|_PAGE_PSE)) || gpte.pfn >= lg->pfn_limit)
+		kill_guest(lg, "bad page table entry");
+}
+
+static void check_gpgd(struct lguest *lg, gpgd_t gpgd)
+{
+	if ((gpgd.flags & ~_PAGE_TABLE) || gpgd.pfn >= lg->pfn_limit)
+		kill_guest(lg, "bad page directory entry");
+}
+
+/* FIXME: We hold reference to pages, which prevents them from being
+   swapped.  It'd be nice to have a callback when Linux wants to swap out. */
+
+/* We fault pages in, which allows us to update accessed/dirty bits.
+ * Return true if we got page. */
+int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
+{
+	gpgd_t gpgd;
+	spgd_t *spgd;
+	unsigned long gpte_ptr;
+	gpte_t gpte;
+	spte_t *spte;
+
+	gpgd = mkgpgd(lgread_u32(lg, gpgd_addr(lg, vaddr)));
+	if (!(gpgd.flags & _PAGE_PRESENT))
+		return 0;
+
+	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
+	if (!(spgd->flags & _PAGE_PRESENT)) {
+		/* Get a page of PTEs for them. */
+		unsigned long ptepage = get_zeroed_page(GFP_KERNEL);
+		/* FIXME: Steal from self in this case? */
+		if (!ptepage) {
+			kill_guest(lg, "out of memory allocating pte page");
+			return 0;
+		}
+		check_gpgd(lg, gpgd);
+		spgd->raw.val = (__pa(ptepage) | gpgd.flags);
+	}
+
+	gpte_ptr = gpte_addr(lg, gpgd, vaddr);
+	gpte = mkgpte(lgread_u32(lg, gpte_ptr));
+
+	/* No page? */
+	if (!(gpte.flags & _PAGE_PRESENT))
+		return 0;
+
+	/* Write to read-only page? */
+	if ((errcode & 2) && !(gpte.flags & _PAGE_RW))
+		return 0;
+
+	/* User access to a non-user page? */
+	if ((errcode & 4) && !(gpte.flags & _PAGE_USER))
+		return 0;
+
+	check_gpte(lg, gpte);
+	gpte.flags |= _PAGE_ACCESSED;
+	if (errcode & 2)
+		gpte.flags |= _PAGE_DIRTY;
+
+	/* We're done with the old pte. */
+	spte = spte_addr(lg, *spgd, vaddr);
+	release_pte(*spte);
+
+	/* We don't make it writable if this isn't a write: later
+	 * write will fault so we can set dirty bit in guest. */
+	if (gpte.flags & _PAGE_DIRTY)
+		*spte = gpte_to_spte(lg, gpte, 1);
+	else {
+		gpte_t ro_gpte = gpte;
+		ro_gpte.flags &= ~_PAGE_RW;
+		*spte = gpte_to_spte(lg, ro_gpte, 0);
+	}
+
+	/* Now we update dirty/accessed on guest. */
+	lgwrite_u32(lg, gpte_ptr, gpte.raw.val);
+	return 1;
+}
+
+/* This is much faster than the full demand_page logic. */
+static int page_writable(struct lguest *lg, unsigned long vaddr)
+{
+	spgd_t *spgd;
+	unsigned long flags;
+
+	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
+	if (!(spgd->flags & _PAGE_PRESENT))
+		return 0;
+
+	flags = spte_addr(lg, *spgd, vaddr)->flags;
+	return (flags & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
+}
+
+void pin_page(struct lguest *lg, unsigned long vaddr)
+{
+	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
+		kill_guest(lg, "bad stack page %#lx", vaddr);
+}
+
+static void release_pgd(struct lguest *lg, spgd_t *spgd)
+{
+	if (spgd->flags & _PAGE_PRESENT) {
+		unsigned int i;
+		spte_t *ptepage = __va(spgd->pfn << PAGE_SHIFT);
+		for (i = 0; i < PTES_PER_PAGE; i++)
+			release_pte(ptepage[i]);
+		free_page((long)ptepage);
+		spgd->raw.val = 0;
+	}
+}
+
+static void flush_user_mappings(struct lguest *lg, int idx)
+{
+	unsigned int i;
+	for (i = 0; i < vaddr_to_pgd_index(lg->page_offset); i++)
+		release_pgd(lg, lg->pgdirs[idx].pgdir + i);
+}
+
+void guest_pagetable_flush_user(struct lguest *lg)
+{
+	flush_user_mappings(lg, lg->pgdidx);
+}
+
+static unsigned int find_pgdir(struct lguest *lg, unsigned long pgtable)
+{
+	unsigned int i;
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		if (lg->pgdirs[i].cr3 == pgtable)
+			break;
+	return i;
+}
+
+static unsigned int new_pgdir(struct lguest *lg,
+			      unsigned long cr3,
+			      int *blank_pgdir)
+{
+	unsigned int next;
+
+	next = random32() % ARRAY_SIZE(lg->pgdirs);
+	if (!lg->pgdirs[next].pgdir) {
+		lg->pgdirs[next].pgdir = (spgd_t *)get_zeroed_page(GFP_KERNEL);
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
+void guest_new_pagetable(struct lguest *lg, unsigned long pgtable)
+{
+	int newpgdir, repin = 0;
+
+	newpgdir = find_pgdir(lg, pgtable);
+	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
+		newpgdir = new_pgdir(lg, pgtable, &repin);
+	lg->pgdidx = newpgdir;
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
+			for (j = 0; j < SWITCHER_PGD_INDEX; j++)
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
+		       unsigned long vaddr, gpte_t gpte)
+{
+	spgd_t *spgd = spgd_addr(lg, idx, vaddr);
+	if (spgd->flags & _PAGE_PRESENT) {
+		spte_t *spte = spte_addr(lg, *spgd, vaddr);
+		release_pte(*spte);
+		if (gpte.flags & (_PAGE_DIRTY | _PAGE_ACCESSED)) {
+			check_gpte(lg, gpte);
+			*spte = gpte_to_spte(lg, gpte, gpte.flags&_PAGE_DIRTY);
+		} else
+			spte->raw.val = 0;
+	}
+}
+
+void guest_set_pte(struct lguest *lg,
+		   unsigned long cr3, unsigned long vaddr, gpte_t gpte)
+{
+	/* Kernel mappings must be changed on all top levels. */
+	if (vaddr >= lg->page_offset) {
+		unsigned int i;
+		for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+			if (lg->pgdirs[i].pgdir)
+				do_set_pte(lg, i, vaddr, gpte);
+	} else {
+		int pgdir = find_pgdir(lg, cr3);
+		if (pgdir != ARRAY_SIZE(lg->pgdirs))
+			do_set_pte(lg, pgdir, vaddr, gpte);
+	}
+}
+
+void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 idx)
+{
+	int pgdir;
+
+	if (idx >= SWITCHER_PGD_INDEX)
+		return;
+
+	pgdir = find_pgdir(lg, cr3);
+	if (pgdir < ARRAY_SIZE(lg->pgdirs))
+		release_pgd(lg, lg->pgdirs[pgdir].pgdir + idx);
+}
+
+int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
+{
+	/* We assume this in flush_user_mappings, so check now */
+	if (vaddr_to_pgd_index(lg->page_offset) >= SWITCHER_PGD_INDEX)
+		return -EINVAL;
+	lg->pgdidx = 0;
+	lg->pgdirs[lg->pgdidx].cr3 = pgtable;
+	lg->pgdirs[lg->pgdidx].pgdir = (spgd_t*)get_zeroed_page(GFP_KERNEL);
+	if (!lg->pgdirs[lg->pgdidx].pgdir)
+		return -ENOMEM;
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
+void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages)
+{
+	spte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
+	spgd_t switcher_pgd;
+	spte_t regs_pte;
+
+	/* Since switcher less that 4MB, we simply mug top pte page. */
+	switcher_pgd.pfn = __pa(switcher_pte_page) >> PAGE_SHIFT;
+	switcher_pgd.flags = _PAGE_KERNEL;
+	lg->pgdirs[lg->pgdidx].pgdir[SWITCHER_PGD_INDEX] = switcher_pgd;
+
+	/* Map our regs page over stack page. */
+	regs_pte.pfn = __pa(lg->regs_page) >> PAGE_SHIFT;
+	regs_pte.flags = _PAGE_KERNEL;
+	switcher_pte_page[(unsigned long)pages/PAGE_SIZE%PTES_PER_PAGE]
+		= regs_pte;
+}
+
+static void free_switcher_pte_pages(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		free_page((long)switcher_pte_page(i));
+}
+
+static __init void populate_switcher_pte_page(unsigned int cpu,
+					      struct page *switcher_page[],
+					      unsigned int pages)
+{
+	unsigned int i;
+	spte_t *pte = switcher_pte_page(cpu);
+
+	for (i = 0; i < pages; i++) {
+		pte[i].pfn = page_to_pfn(switcher_page[i]);
+		pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
+	}
+
+	/* We only map this CPU's pages, so guest can't see others. */
+	i = pages + cpu*2;
+
+	/* First page (regs) is rw, second (state) is ro. */
+	pte[i].pfn = page_to_pfn(switcher_page[i]);
+	pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED|_PAGE_RW;
+	pte[i+1].pfn = page_to_pfn(switcher_page[i+1]);
+	pte[i+1].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
+}
+
+__init int init_pagetables(struct page **switcher_page, unsigned int pages)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i) {
+		switcher_pte_page(i) = (spte_t *)get_zeroed_page(GFP_KERNEL);
+		if (!switcher_pte_page(i)) {
+			free_switcher_pte_pages();
+			return -ENOMEM;
+		}
+		populate_switcher_pte_page(i, switcher_page, pages);
+	}
+	return 0;
+}
+
+void free_pagetables(void)
+{
+	free_switcher_pte_pages();
+}
diff -puN /dev/null drivers/lguest/segments.c
--- /dev/null
+++ a/drivers/lguest/segments.c
@@ -0,0 +1,125 @@
+#include "lg.h"
+
+static int desc_ok(const struct desc_struct *gdt)
+{
+	/* MBZ=0, P=1, DT=1  */
+	return ((gdt->b & 0x00209000) == 0x00009000);
+}
+
+static int segment_present(const struct desc_struct *gdt)
+{
+	return gdt->b & 0x8000;
+}
+
+static int ignored_gdt(unsigned int num)
+{
+	return (num == GDT_ENTRY_TSS
+		|| num == GDT_ENTRY_LGUEST_CS
+		|| num == GDT_ENTRY_LGUEST_DS
+		|| num == GDT_ENTRY_DOUBLEFAULT_TSS);
+}
+
+/* We don't allow removal of CS, DS or SS; it doesn't make sense. */
+static void check_segment_use(struct lguest *lg, unsigned int desc)
+{
+	if (lg->regs->gs / 8 == desc)
+		lg->regs->gs = 0;
+	if (lg->regs->fs / 8 == desc)
+		lg->regs->fs = 0;
+	if (lg->regs->es / 8 == desc)
+		lg->regs->es = 0;
+	if (lg->regs->ds / 8 == desc
+	    || lg->regs->cs / 8 == desc
+	    || lg->regs->ss / 8 == desc)
+		kill_guest(lg, "Removed live GDT entry %u", desc);
+}
+
+static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
+{
+	unsigned int i;
+
+	for (i = start; i < end; i++) {
+		/* We never copy these ones to real gdt */
+		if (ignored_gdt(i))
+			continue;
+
+		/* We could fault in switch_to_guest if they are using
+		 * a removed segment. */
+		if (!segment_present(&lg->gdt[i])) {
+			check_segment_use(lg, i);
+			continue;
+		}
+
+		if (!desc_ok(&lg->gdt[i]))
+			kill_guest(lg, "Bad GDT descriptor %i", i);
+
+		/* DPL 0 presumably means "for use by guest". */
+		if ((lg->gdt[i].b & 0x00006000) == 0)
+			lg->gdt[i].b |= (GUEST_PL << 13);
+
+		/* Set accessed bit, since gdt isn't writable. */
+		lg->gdt[i].b |= 0x00000100;
+	}
+}
+
+void setup_default_gdt_entries(struct lguest_ro_state *state)
+{
+	struct desc_struct *gdt = state->guest_gdt;
+	unsigned long tss = (unsigned long)&state->guest_tss;
+
+	/* Hypervisor segments. */
+	gdt[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+	gdt[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+
+	/* This is the one which we *cannot* copy from guest, since tss
+	   is depended on this lguest_ro_state, ie. this cpu. */
+	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
+	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
+		| ((tss >> 16) & 0x000000FF);
+}
+
+void setup_guest_gdt(struct lguest *lg)
+{
+	lg->gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
+	lg->gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
+	lg->gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
+	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
+}
+
+/* This is a fast version for the common case where only the three TLS entries
+ * have changed. */
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
+
+	for (i = GDT_ENTRY_TLS_MIN; i <= GDT_ENTRY_TLS_MAX; i++)
+		gdt[i] = lg->gdt[i];
+}
+
+void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
+
+	for (i = 0; i < GDT_ENTRIES; i++)
+		if (!ignored_gdt(i))
+			gdt[i] = lg->gdt[i];
+}
+
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
+{
+	if (num > ARRAY_SIZE(lg->gdt))
+		kill_guest(lg, "too many gdt entries %i", num);
+
+	lgread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
+	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->gdt));
+	lg->changed |= CHANGED_GDT;
+}
+
+void guest_load_tls(struct lguest *lg, unsigned long gtls)
+{
+	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
+
+	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
+	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
+	lg->changed |= CHANGED_GDT_TLS;
+}
diff -puN /dev/null drivers/lguest/switcher.S
--- /dev/null
+++ a/drivers/lguest/switcher.S
@@ -0,0 +1,159 @@
+/* This code sits at 0xFFC00000 to do the low-level guest<->host switch.
+
+   There is are two pages above us for this CPU (struct lguest_pages).
+   The second page (struct lguest_ro_state) becomes read-only after the
+   context switch.  The first page (the stack for traps) remains writable,
+   but while we're in here, the guest cannot be running.
+*/
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include "lg.h"
+
+.text
+ENTRY(start_switcher_text)
+
+/* %eax points to lguest pages for this CPU.  %ebx contains cr3 value.
+   All normal registers can be clobbered! */
+ENTRY(switch_to_guest)
+	/* Save host segments on host stack. */
+	pushl	%es
+	pushl	%ds
+	pushl	%gs
+	pushl	%fs
+	/* With CONFIG_FRAME_POINTER, gcc doesn't let us clobber this! */
+	pushl	%ebp
+	/* Save host stack. */
+	movl	%esp, LGUEST_PAGES_host_sp(%eax)
+	/* Switch to guest stack: if we get NMI we expect to be there. */
+	movl	%eax, %edx
+	addl	$LGUEST_PAGES_regs, %edx
+	movl	%edx, %esp
+	/* Switch to guest's GDT, IDT. */
+	lgdt	LGUEST_PAGES_guest_gdt_desc(%eax)
+	lidt	LGUEST_PAGES_guest_idt_desc(%eax)
+	/* Switch to guest's TSS while GDT still writable. */
+	movl	$(GDT_ENTRY_TSS*8), %edx
+	ltr	%dx
+	/* Set host's TSS GDT entry to available (clear byte 5 bit 2). */
+	movl	(LGUEST_PAGES_host_gdt_desc+2)(%eax), %edx
+	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%edx)
+	/* Switch to guest page tables:	lguest_pages->state now read-only. */
+	movl	%ebx, %cr3
+	/* Restore guest regs */
+	popl	%ebx
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+	popl	%edi
+	popl	%ebp
+	popl	%gs
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
+	/* Figure out where we are, based on stack (at top of regs). */	\
+	movl	%esp, %eax;						\
+	subl	$LGUEST_PAGES_regs, %eax;				\
+	/* Put trap number in %ebx before we switch cr3 and lose it. */ \
+	movl	LGUEST_PAGES_regs_trapnum(%eax), %ebx;			\
+	/* Switch to host page tables (host GDT, IDT and stack are in host   \
+	   mem, so need this first) */					\
+	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
+	movl	%edx, %cr3;						\
+	/* Set guest's TSS to available (clear byte 5 bit 2). */	\
+	andb	$0xFD, (LGUEST_PAGES_guest_gdt+GDT_ENTRY_TSS*8+5)(%eax); \
+	/* Switch to host's GDT & IDT. */				\
+	lgdt	LGUEST_PAGES_host_gdt_desc(%eax);			\
+	lidt	LGUEST_PAGES_host_idt_desc(%eax);			\
+	/* Switch to host's stack. */					\
+	movl	LGUEST_PAGES_host_sp(%eax), %esp;			\
+	/* Switch to host's TSS */					\
+	movl	$(GDT_ENTRY_TSS*8), %edx;				\
+	ltr	%dx;							\
+	popl	%ebp;							\
+	popl	%fs;							\
+	popl	%gs;							\
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
+	/* Decode IDT and jump to hosts' irq handler.  When that does iret, it
+	 * will return to run_guest_once.  This is a feature. */
+	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
+	leal	(%edx,%ebx,8), %eax
+	movzwl	(%eax),%edx
+	movl	4(%eax), %eax
+	xorw	%ax, %ax
+	orl	%eax, %edx
+	jmp	*%edx
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
+.data
+.global default_idt_entries
+default_idt_entries:
+.text
+	IRQ_STUBS 0 1 return_to_host		/* First two traps */
+	IRQ_STUB 2 handle_nmi			/* NMI */
+	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
+	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
+	IRQ_STUB 128 return_to_host		/* System call (overridden) */
+	IRQ_STUBS 129 255 deliver_to_host	/* Other real interrupts */
+
+/* We ignore NMI and return. */
+handle_nmi:
+	addl	$8, %esp
+	iret
+
+ENTRY(end_switcher_text)
diff -puN include/asm-i386/tsc.h~lguest-the-host-code include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~lguest-the-host-code
+++ a/include/asm-i386/tsc.h
@@ -63,6 +63,7 @@ extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);
+int check_tsc_unstable(void);
 
 /*
  * Boot-time check whether the TSCs are synchronized across
diff -puN include/linux/lguest.h~lguest-the-host-code include/linux/lguest.h
--- a/include/linux/lguest.h~lguest-the-host-code
+++ a/include/linux/lguest.h
@@ -3,11 +3,6 @@
 #ifndef _ASM_LGUEST_H
 #define _ASM_LGUEST_H
 
-/* These are randomly chosen numbers which indicate we're an lguest at boot */
-#define LGUEST_MAGIC_EBP 0x4C687970
-#define LGUEST_MAGIC_EDI 0x652D4D65
-#define LGUEST_MAGIC_ESI 0xFFFFFFFF
-
 #ifndef __ASSEMBLY__
 #include <asm/irq.h>
 
@@ -20,7 +15,7 @@
 #define LHCALL_LOAD_IDT_ENTRY	6
 #define LHCALL_SET_STACK	7
 #define LHCALL_TS		8
-#define LHCALL_TIMER_READ	9
+#define LHCALL_SET_CLOCKEVENT	9
 #define LHCALL_HALT		10
 #define LHCALL_GET_WALLCLOCK	11
 #define LHCALL_BIND_DMA		12
@@ -29,6 +24,9 @@
 #define LHCALL_SET_PMD		15
 #define LHCALL_LOAD_TLS		16
 
+#define LG_CLOCK_MIN_DELTA	100UL
+#define LG_CLOCK_MAX_DELTA	ULONG_MAX
+
 #define LGUEST_TRAP_ENTRY 0x1F
 
 static inline unsigned long
@@ -75,6 +73,8 @@ struct lguest_data
 	unsigned long reserve_mem;
 	/* ID of this guest (used by network driver to set ethernet address) */
 	u16 guestid;
+	/* KHz for the TSC clock. */
+	u32 tsc_khz;
 
 /* Fields initialized by the guest at boot: */
 	/* Instruction range to suppress interrupts even if enabled */
diff -puN /dev/null include/linux/lguest_launcher.h
--- /dev/null
+++ a/include/linux/lguest_launcher.h
@@ -0,0 +1,73 @@
+#ifndef _ASM_LGUEST_USER
+#define _ASM_LGUEST_USER
+/* Everything the "lguest" userspace program needs to know. */
+/* They can register up to 32 arrays of lguest_dma. */
+#define LGUEST_MAX_DMA		32
+/* At most we can dma 16 lguest_dma in one op. */
+#define LGUEST_MAX_DMA_SECTIONS	16
+
+/* How many devices?  Assume each one wants up to two dma arrays per device. */
+#define LGUEST_MAX_DEVICES (LGUEST_MAX_DMA/2)
+
+struct lguest_dma
+{
+	/* 0 if free to be used, filled by hypervisor. */
+ 	u32 used_len;
+	unsigned long addr[LGUEST_MAX_DMA_SECTIONS];
+	u16 len[LGUEST_MAX_DMA_SECTIONS];
+};
+
+struct lguest_block_page
+{
+	/* 0 is a read, 1 is a write. */
+	int type;
+	u32 sector; 	/* Offset in device = sector * 512. */
+	u32 bytes;	/* Length expected to be read/written in bytes */
+	/* 0 = pending, 1 = done, 2 = done, error */
+	int result;
+	u32 num_sectors; /* Disk length = num_sectors * 512 */
+};
+
+/* There is a shared page of these. */
+struct lguest_net
+{
+	/* Simply the mac address (with multicast bit meaning promisc). */
+	unsigned char mac[6];
+};
+
+/* Where the Host expects the Guest to SEND_DMA console output to. */
+#define LGUEST_CONSOLE_DMA_KEY 0
+
+/* We have a page of these descriptors in the lguest_device page. */
+struct lguest_device_desc {
+	u16 type;
+#define LGUEST_DEVICE_T_CONSOLE	1
+#define LGUEST_DEVICE_T_NET	2
+#define LGUEST_DEVICE_T_BLOCK	3
+
+	u16 features;
+#define LGUEST_NET_F_NOCSUM		0x4000 /* Don't bother checksumming */
+#define LGUEST_DEVICE_F_RANDOMNESS	0x8000 /* IRQ is fairly random */
+
+	u16 status;
+/* 256 and above are device specific. */
+#define LGUEST_DEVICE_S_ACKNOWLEDGE	1 /* We have seen device. */
+#define LGUEST_DEVICE_S_DRIVER		2 /* We have found a driver */
+#define LGUEST_DEVICE_S_DRIVER_OK	4 /* Driver says OK! */
+#define LGUEST_DEVICE_S_REMOVED		8 /* Device has gone away. */
+#define LGUEST_DEVICE_S_REMOVED_ACK	16 /* Driver has been told. */
+#define LGUEST_DEVICE_S_FAILED		128 /* Something actually failed */
+
+	u16 num_pages;
+	u32 pfn;
+};
+
+/* Write command first word is a request. */
+enum lguest_req
+{
+	LHREQ_INITIALIZE, /* + pfnlimit, pgdir, start, pageoffset */
+	LHREQ_GETDMA, /* + addr (returns &lguest_dma, irq in ->used_len) */
+	LHREQ_IRQ, /* + irq */
+	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
+};
+#endif /* _ASM_LGUEST_USER */
diff -puN kernel/fork.c~lguest-the-host-code kernel/fork.c
--- a/kernel/fork.c~lguest-the-host-code
+++ a/kernel/fork.c
@@ -127,7 +127,6 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
-EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
