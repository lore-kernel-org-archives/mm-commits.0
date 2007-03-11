From: akpm@linux-foundation.org
Subject: + lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:16:09 -0800
Message-ID: <200703110916.l2B9G937008553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40911 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbXCKJQY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: use read-only pages rather than segments to protect high-mapped switcher
has been added to the -mm tree.  Its filename is
     lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: use read-only pages rather than segments to protect high-mapped switcher
From: Rusty Russell <rusty@rustcorp.com.au>

The current lguest uses segment limits to ensure that the guest cannot reach
the switcher code at the top of virtual memory.  This is bad for two reasons:

1) It introduces complexity when the guest wants to use 4G segments
(ie. glibc's __thread support).
2) It doesn't work on x86-64 boxes.

The alternative is used here: in the host we map the actual switcher code, two
per-cpu pages.  The switcher code and one per-cpu page are read-only: the
read-only page contains the saved host state and the GDT, IDT and TSS the
guest is using.  The other per-cpu page is the stack page for the hypervisor,
which is writable by the guest.  This is where we save the guest registers:
it's safe because while we're doing this we know the (UP) guest isn't running.

Switching into the guest involves copying in the registers, GDT and IDT to
this cpu's pages, the copying the registers out on the way back.  This is
optimized in another patch.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c          |   20 -
 arch/i386/lguest/Makefile               |    4 
 arch/i386/lguest/core.c                 |  171 ++++++--------
 arch/i386/lguest/hypercalls.c           |    4 
 arch/i386/lguest/hypervisor.S           |   90 +++----
 arch/i386/lguest/interrupts_and_traps.c |  265 ++++++++++++----------
 arch/i386/lguest/lg.h                   |  165 ++++++-------
 arch/i386/lguest/lguest_user.c          |   63 -----
 arch/i386/lguest/page_tables.c          |   34 +-
 arch/i386/lguest/segments.c             |  201 +++++-----------
 include/asm-i386/lguest.h               |    3 
 11 files changed, 473 insertions(+), 547 deletions(-)

diff -puN arch/i386/kernel/asm-offsets.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/kernel/asm-offsets.c
@@ -122,15 +122,15 @@ void foo(void)
 #ifdef CONFIG_LGUEST_GUEST
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
-	OFFSET(LGUEST_STATE_host_stackptr, lguest_state, host.stackptr);
-	OFFSET(LGUEST_STATE_host_pgdir, lguest_state, host.pgdir);
-	OFFSET(LGUEST_STATE_host_gdt, lguest_state, host.gdt);
-	OFFSET(LGUEST_STATE_host_idt, lguest_state, host.idt);
-	OFFSET(LGUEST_STATE_regs, lguest_state, regs);
-	OFFSET(LGUEST_STATE_gdt, lguest_state, gdt);
-	OFFSET(LGUEST_STATE_idt, lguest_state, idt);
-	OFFSET(LGUEST_STATE_gdt_table, lguest_state, gdt_table);
-	OFFSET(LGUEST_STATE_trapnum, lguest_state, regs.trapnum);
-	OFFSET(LGUEST_STATE_errcode, lguest_state, regs.errcode);
+	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
+	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
+	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
+	OFFSET(LGUEST_PAGES_host_sp, lguest_pages, state.host_sp);
+	OFFSET(LGUEST_PAGES_guest_gdt_desc, lguest_pages,state.guest_gdt_desc);
+	OFFSET(LGUEST_PAGES_guest_idt_desc, lguest_pages,state.guest_idt_desc);
+	OFFSET(LGUEST_PAGES_guest_gdt, lguest_pages, state.guest_gdt);
+	OFFSET(LGUEST_PAGES_regs_trapnum, lguest_pages, regs.trapnum);
+	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
+	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
 }
diff -puN arch/i386/lguest/core.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/core.c
@@ -24,26 +24,26 @@ static char __initdata hypervisor_blob[]
 #include "hypervisor-blob.c"
 };
 
-/* 64k ought to be enough for anybody! */
-#define HYPERVISOR_PAGES (65536 / PAGE_SIZE)
-
-#define MAX_LGUEST_GUESTS						\
-	(((HYPERVISOR_PAGES * PAGE_SIZE) - sizeof(hypervisor_blob))	\
-	 / sizeof(struct lguest_state))
+/* Every guest maps the core hypervisor blob. */
+#define SHARED_HYPERVISOR_PAGES DIV_ROUND_UP(sizeof(hypervisor_blob),PAGE_SIZE)
 
 static struct vm_struct *hypervisor_vma;
-/* Pages for hypervisor itself */
-static struct page *hype_page[HYPERVISOR_PAGES];
+/* Pages for hypervisor itself, then two pages per cpu */
+static struct page *hype_page[SHARED_HYPERVISOR_PAGES+2*NR_CPUS];
+
 static int cpu_had_pge;
 static struct {
 	unsigned long offset;
 	unsigned short segment;
 } lguest_entry __attribute_used__;
-struct lguest lguests[MAX_LGUEST_GUESTS];
 DEFINE_MUTEX(lguest_lock);
 
+/* FIXME: Make dynamic. */
+#define MAX_LGUEST_GUESTS 16
+struct lguest lguests[MAX_LGUEST_GUESTS];
+
 /* IDT entries are at start of hypervisor. */
-const unsigned long *__lguest_default_idt_entries(void)
+static const unsigned long *lguest_default_idt_entries(void)
 {
 	return (void *)HYPE_ADDR;
 }
@@ -54,10 +54,11 @@ static void *__lguest_switch_to_guest(vo
 	return (void *)HYPE_ADDR + HYPE_DATA_SIZE;
 }
 
-/* Then we use everything else to hold guest state. */
-struct lguest_state *__lguest_states(void)
+/* This cpu's struct lguest_pages. */
+static struct lguest_pages *lguest_pages(unsigned int cpu)
 {
-	return (void *)HYPE_ADDR + sizeof(hypervisor_blob);
+	return &(((struct lguest_pages *)
+		  (HYPE_ADDR + SHARED_HYPERVISOR_PAGES*PAGE_SIZE))[cpu]);
 }
 
 static __init int map_hypervisor(void)
@@ -89,8 +90,25 @@ static __init int map_hypervisor(void)
 	}
 	memcpy(hypervisor_vma->addr, hypervisor_blob, sizeof(hypervisor_blob));
 
-	/* Setup LGUEST segments on all cpus */
 	for_each_possible_cpu(i) {
+		struct lguest_pages *pages = lguest_pages(i);
+		struct lguest_ro_state *state = &pages->state;
+
+		/* These fields are static: rest done in copy_in_guest_info */
+		state->host_gdt_desc = per_cpu(cpu_gdt_descr, i);
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
+		setup_default_idt_entries(state, lguest_default_idt_entries());
+
+		/* Setup LGUEST segments on all cpus */
 		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
 		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
 	}
@@ -126,10 +144,10 @@ static int emulate_insn(struct lguest *l
 {
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
-	unsigned long physaddr = guest_pa(lg, lg->state->regs.eip);
+	unsigned long physaddr = guest_pa(lg, lg->regs.eip);
 
 	/* This only works for addresses in linear mapping... */
-	if (lg->state->regs.eip < lg->page_offset)
+	if (lg->regs.eip < lg->page_offset)
 		return 0;
 	lhread(lg, &insn, physaddr, 1);
 
@@ -162,11 +180,11 @@ static int emulate_insn(struct lguest *l
 	if (in) {
 		/* Lower bit tells is whether it's a 16 or 32 bit access */
 		if (insn & 0x1)
-			lg->state->regs.eax = 0xFFFFFFFF;
+			lg->regs.eax = 0xFFFFFFFF;
 		else
-			lg->state->regs.eax |= (0xFFFF << shift);
+			lg->regs.eax |= (0xFFFF << shift);
 	}
-	lg->state->regs.eip += insnlen;
+	lg->regs.eip += insnlen;
 	return 1;
 }
 
@@ -174,7 +192,7 @@ int find_free_guest(void)
 {
 	unsigned int i;
 	for (i = 0; i < MAX_LGUEST_GUESTS; i++)
-		if (!lguests[i].state)
+		if (!lguests[i].tsk)
 			return i;
 	return -1;
 }
@@ -221,31 +239,6 @@ void lhwrite(struct lguest *lg, u32 addr
 		kill_guest(lg, "bad write address %u len %u", addr, bytes);
 }
 
-/* Saves exporting idt_table from kernel */
-static struct desc_struct *get_idt_table(void)
-{
-	struct Xgt_desc_struct idt;
-
-	asm("sidt %0":"=m" (idt));
-	return (void *)idt.address;
-}
-
-static int usermode(struct lguest_regs *regs)
-{
-	return (regs->cs & SEGMENT_RPL_MASK) == USER_RPL;
-}
-
-/* Trap page resets this when it reloads gs. */
-static int new_gfp_eip(struct lguest *lg, struct lguest_regs *regs)
-{
-	u32 eip;
-	get_user(eip, &lg->lguest_data->gs_gpf_eip);
-	if (eip == regs->eip)
-		return 0;
-	put_user(regs->eip, &lg->lguest_data->gs_gpf_eip);
-	return 1;
-}
-
 static void set_ts(unsigned int guest_ts)
 {
 	u32 cr0;
@@ -256,23 +249,51 @@ static void set_ts(unsigned int guest_ts
 	}
 }
 
-static void run_guest_once(struct lguest *lg)
+static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
 {
 	unsigned int clobber;
 
 	/* Put eflags on stack, lcall does rest: suitable for iret return. */
 	asm volatile("pushf; lcall *lguest_entry"
-		     : "=a"(clobber), "=d"(clobber), "=b"(clobber)
-		     : "0"(lg->state), "1"(get_idt_table()), "2"(lg->cr3)
-		     : "memory", "%ecx", "%edi", "%esi");
+		     : "=a"(clobber), "=b"(clobber)
+		     : "0"(pages), "1"(lg->cr3)
+		     : "memory", "%edx", "%ecx", "%edi", "%esi");
+}
+
+static void copy_in_guest_info(struct lguest_pages *pages,
+			       struct lguest *lg)
+{
+	/* Copy in regs. */
+	pages->regs = lg->regs;
+
+	/* TSS entries for direct traps. */
+	pages->state.guest_tss.esp1 = lg->esp1;
+	pages->state.guest_tss.ss1 = lg->ss1;
+
+	/* CR3 */
+	pages->state.host_cr3 = __pa(current->mm->pgd);
+
+	/* Copy direct trap entries. */
+	copy_traps(lg, pages->state.guest_idt, lguest_default_idt_entries());
+
+	/* Copy all GDT entries but the TSS. */
+	copy_gdt(lg, pages->state.guest_gdt);
+}
+
+static void copy_out_guest_info(struct lguest *lg,
+				const struct lguest_pages *pages)
+{
+	/* We just want the regs back. */
+	lg->regs = pages->regs;
 }
 
 int run_guest(struct lguest *lg, char *__user user)
 {
-	struct lguest_regs *regs = &lg->state->regs;
+	struct lguest_regs *regs = &lg->regs;
 
 	while (!lg->dead) {
 		unsigned int cr2 = 0; /* Damn gcc */
+		struct lguest_pages *pages;
 
 		/* Hypercalls first: we might have been out to userspace */
 		if (do_async_hcalls(lg))
@@ -300,25 +321,16 @@ int run_guest(struct lguest *lg, char *_
 			continue;
 		}
 
-		/* Restore limits on TLS segments if in user mode. */
-		if (usermode(regs)) {
-			unsigned int i;
-			for (i = 0; i < ARRAY_SIZE(lg->tls_limits); i++)
-				lg->state->gdt_table[GDT_ENTRY_TLS_MIN+i].a
-					|= lg->tls_limits[i];
-		}
-
 		local_irq_disable();
-		map_trap_page(lg);
-
-		/* Host state to be restored after the guest returns. */
-		asm("sidt %0":"=m"(lg->state->host.idt));
-		lg->state->host.gdt = __get_cpu_var(cpu_gdt_descr);
 
 		/* Even if *we* don't want FPU trap, guest might... */
 		set_ts(lg->ts);
 
-		run_guest_once(lg);
+		pages = lguest_pages(raw_smp_processor_id());
+		map_hypervisor_in_guest(lg);
+		copy_in_guest_info(pages, lg);
+		run_guest_once(lg, pages);
+		copy_out_guest_info(lg, pages);
 
 		/* Save cr2 now if we page-faulted. */
 		if (regs->trapnum == 14)
@@ -332,14 +344,7 @@ int run_guest(struct lguest *lg, char *_
 			if (regs->errcode == 0) {
 				if (emulate_insn(lg))
 					continue;
-
-				/* FIXME: If it's reloading %gs in a loop? */
-				if (usermode(regs) && new_gfp_eip(lg,regs))
-					continue;
 			}
-
-			if (reflect_trap(lg, &lg->gpf_trap, 1))
-				continue;
 			break;
 		case 14: /* We've intercepted a page fault. */
 			if (demand_page(lg, cr2, regs->errcode & 2))
@@ -347,30 +352,24 @@ int run_guest(struct lguest *lg, char *_
 
 			/* If lguest_data is NULL, this won't hurt. */
 			put_user(cr2, &lg->lguest_data->cr2);
-			if (reflect_trap(lg, &lg->page_trap, 1))
-				continue;
-			kill_guest(lg, "unhandled page fault at %#x"
-				   " (eip=%#x, errcode=%#x)",
-				   cr2, regs->eip, regs->errcode);
 			break;
 		case 7: /* We've intercepted a Device Not Available fault. */
 			/* If they don't want to know, just absorb it. */
 			if (!lg->ts)
 				continue;
-			if (reflect_trap(lg, &lg->fpu_trap, 0))
-				continue;
-			kill_guest(lg, "unhandled FPU fault at %#x",
-				   regs->eip);
 			break;
 		case 32 ... 255: /* Real interrupt, fall thru */
 			cond_resched();
 		case LGUEST_TRAP_ENTRY: /* Handled at top of loop */
 			continue;
-		case 6: /* Invalid opcode before they installed handler */
-			check_bug_kill(lg);
 		}
-		kill_guest(lg,"unhandled trap %i at %#x (err=%i)",
-			   regs->trapnum, regs->eip, regs->errcode);
+
+		if (deliver_trap(lg, regs->trapnum))
+			continue;
+
+		kill_guest(lg, "unhandled trap %i at %#x (%#x)",
+			   regs->trapnum, regs->eip,
+			   regs->trapnum == 14 ? cr2 : regs->errcode);
 	}
 	return -ENOENT;
 
@@ -380,8 +379,6 @@ pending_dma:
 	return sizeof(unsigned long)*2;
 }
 
-#define STRUCT_LGUEST_ELEM_SIZE(elem) sizeof(((struct lguest_state *)0)->elem)
-
 static void adjust_pge(void *on)
 {
 	if (on)
@@ -401,7 +398,7 @@ static int __init init(void)
 	if (err)
 		return err;
 
-	err = init_pagetables(hype_page, HYPERVISOR_PAGES);
+	err = init_pagetables(hype_page, SHARED_HYPERVISOR_PAGES);
 	if (err) {
 		unmap_hypervisor();
 		return err;
diff -puN arch/i386/lguest/hypercalls.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/hypercalls.c
--- a/arch/i386/lguest/hypercalls.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/hypercalls.c
@@ -32,8 +32,8 @@ static void guest_set_stack(struct lgues
 		kill_guest(lg, "bad stack segment %i", seg);
 	if (pages > 2)
 		kill_guest(lg, "bad stack pages %u", pages);
-	lg->state->tss.ss1 = seg;
-	lg->state->tss.esp1 = esp;
+	lg->ss1 = seg;
+	lg->esp1 = esp;
 	lg->stack_pages = pages;
 	pin_stack_pages(lg);
 }
diff -puN arch/i386/lguest/hypervisor.S~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/hypervisor.S
@@ -1,39 +1,46 @@
-/* This code sits at 0xFFFF1000 to do the low-level guest<->host switch.
-   Layout is: default_idt_entries (1k), then switch_to_guest entry point. */
+/* This code sits at 0xFFC00000 to do the low-level guest<->host switch.
+
+   There is are two pages above us for this CPU (struct lguest_pages).
+   The second page (struct lguest_ro_state) becomes read-only after the
+   context switch.  The first page (the stack for traps) remains writable,
+   but while we're in here, the guest cannot be running.
+*/
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include "lg.h"
 
 .text
 ENTRY(_start) /* ld complains unless _start is defined. */
-/* %eax contains ptr to target guest state, %edx contains host idt.
-   %ebx contains cr3 value.  All normal registers can be clobbered! */
+
+/* %eax points to lguest pages for this CPU.  %ebx contains cr3 value.
+   All normal registers can be clobbered! */
 switch_to_guest:
+	/* Save host segments on host stack. */
 	pushl	%es
 	pushl	%ds
-	pushl	%fs
 	pushl	%gs
-	pushl	%edx
+	pushl	%fs
+	/* We want %eax in deliver_to_host */
+	pushl	%eax
+	/* With CONFIG_FRAME_POINTER, gcc doesn't let us clobber this! */
 	pushl	%ebp
-	/* Save old stack, switch to guest's stack. */
-	movl	%esp, LGUEST_STATE_host_stackptr(%eax)
-	movl	%eax, %esp
-	/* Guest registers will be at: %esp-$LGUEST_STATE_regs */
-	addl	$LGUEST_STATE_regs, %esp
+	/* Save host stack. */
+	movl	%esp, LGUEST_PAGES_host_sp(%eax)
+	/* Switch to guest stack: if we get NMI we expect to be there. */
+	movl	%eax, %edx
+	addl	$LGUEST_PAGES_regs, %edx
+	movl	%edx, %esp
 	/* Switch to guest's GDT, IDT. */
-	lgdt	LGUEST_STATE_gdt(%eax)
-	lidt	LGUEST_STATE_idt(%eax)
-	/* Save page table top. */
-	movl	%cr3, %ecx
-	movl	%ecx, LGUEST_STATE_host_pgdir(%eax)
-	/* Set host's TSS to available (clear byte 5 bit 2). */
-	movl	(LGUEST_STATE_host_gdt+2)(%eax), %ecx
-	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%ecx)
-	/* Switch to guest page tables */
-	movl	%ebx, %cr3
-	/* Switch to guest's TSS. */
+	lgdt	LGUEST_PAGES_guest_gdt_desc(%eax)
+	lidt	LGUEST_PAGES_guest_idt_desc(%eax)
+	/* Switch to guest's TSS while GDT still writable. */
 	movl	$(GDT_ENTRY_TSS*8), %edx
 	ltr	%dx
+	/* Set host's TSS GDT entry to available (clear byte 5 bit 2). */
+	movl	(LGUEST_PAGES_host_gdt_desc+2)(%eax), %edx
+	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%edx)
+	/* Switch to guest page tables:	lguest_pages->state now read-only. */
+	movl	%ebx, %cr3
 	/* Restore guest regs */
 	popl	%ebx
 	popl	%ecx
@@ -42,11 +49,6 @@ switch_to_guest:
 	popl	%edi
 	popl	%ebp
 	popl	%gs
-	/* Now we've loaded gs, neuter the TLS entries down to 1 byte/page */
-	addl	$(LGUEST_STATE_gdt_table+GDT_ENTRY_TLS_MIN*8), %eax
-	movw	$0,(%eax)
-	movw	$0,8(%eax)
-	movw	$0,16(%eax)
 	popl	%eax
 	popl	%fs
 	popl	%ds
@@ -71,28 +73,27 @@ switch_to_guest:
 	/* Load lguest ds segment for convenience. */			\
 	movl	$(LGUEST_DS), %eax;					\
 	movl	%eax, %ds;						\
-	/* Now figure out who we are */					\
+	/* Figure out where we are, based on stack (at top of regs). */	\
 	movl	%esp, %eax;						\
-	subl	$LGUEST_STATE_regs, %eax;				\
-	/* Switch to host page tables (GDT, IDT and stack are in host   \
+	subl	$LGUEST_PAGES_regs, %eax;				\
+	/* Switch to host page tables (host GDT, IDT and stack are in host   \
 	   mem, so need this first) */					\
-	movl	LGUEST_STATE_host_pgdir(%eax), %ebx;			\
-	movl	%ebx, %cr3;						\
+	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
+	movl	%edx, %cr3;						\
 	/* Set guest's TSS to available (clear byte 5 bit 2). */	\
-	andb	$0xFD, (LGUEST_STATE_gdt_table+GDT_ENTRY_TSS*8+5)(%eax);\
+	andb	$0xFD, (LGUEST_PAGES_guest_gdt+GDT_ENTRY_TSS*8+5)(%eax); \
 	/* Switch to host's GDT & IDT. */				\
-	lgdt	LGUEST_STATE_host_gdt(%eax);				\
-	lidt	LGUEST_STATE_host_idt(%eax);				\
+	lgdt	LGUEST_PAGES_host_gdt_desc(%eax);			\
+	lidt	LGUEST_PAGES_host_idt_desc(%eax);			\
 	/* Switch to host's stack. */					\
-	movl	LGUEST_STATE_host_stackptr(%eax), %esp;			\
+	movl	LGUEST_PAGES_host_sp(%eax), %esp;			\
 	/* Switch to host's TSS */					\
-	movl	$(GDT_ENTRY_TSS*8), %ebx;				\
-	ltr	%bx;							\
-	/* Restore host regs */						\
+	movl	$(GDT_ENTRY_TSS*8), %eax;				\
+	ltr	%ax;							\
 	popl	%ebp;							\
-	popl	%edx;							\
-	popl	%gs;							\
+	popl	%eax;							\
 	popl	%fs;							\
+	popl	%gs;							\
 	popl	%ds;							\
 	popl	%es
 
@@ -106,8 +107,8 @@ deliver_to_host:
 decode_idt_and_jmp:
 	/* Decode IDT and jump to hosts' irq handler.  When that does iret, it
 	 * will return to run_guest_once.  This is a feature. */
-	/* We told gcc we'd clobber edx and eax... */
-	movl	LGUEST_STATE_trapnum(%eax), %eax
+	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
+	movl	LGUEST_PAGES_regs_trapnum(%eax), %eax
 	leal	(%edx,%eax,8), %eax
 	movzwl	(%eax),%edx
 	movl	4(%eax), %eax
@@ -115,9 +116,10 @@ decode_idt_and_jmp:
 	orl	%eax, %edx
 	jmp	*%edx
 
+/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
 deliver_to_host_with_errcode:
 	SWITCH_TO_HOST
-	pushl	LGUEST_STATE_errcode(%eax)
+	pushl	LGUEST_PAGES_regs_errcode(%eax)
 	jmp decode_idt_and_jmp
 
 /* Real hardware interrupts are delivered straight to the host.  Others
diff -puN arch/i386/lguest/interrupts_and_traps.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/interrupts_and_traps.c
--- a/arch/i386/lguest/interrupts_and_traps.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/interrupts_and_traps.c
@@ -6,19 +6,31 @@ static void push_guest_stack(struct lgue
 	lhwrite_u32(lg, (u32)--(*gstack), val);
 }
 
-int reflect_trap(struct lguest *lg, const struct host_trap *trap, int has_err)
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
+static void reflect_trap(struct lguest *lg, u32 lo, u32 hi, int has_err)
 {
 	u32 __user *gstack;
 	u32 eflags, ss, irq_enable;
-	struct lguest_regs *regs = &lg->state->regs;
-
-	if (!trap->addr)
-		return 0;
+	struct lguest_regs *regs = &lg->regs;
 
 	/* If they want a ring change, we use new stack and push old ss/esp */
 	if ((regs->ss&0x3) != GUEST_DPL) {
-		gstack = (u32 __user *)guest_pa(lg, lg->state->tss.esp1);
-		ss = lg->state->tss.ss1;
+		gstack = (u32 __user *)guest_pa(lg, lg->esp1);
+		ss = lg->ss1;
 		push_guest_stack(lg, &gstack, regs->ss);
 		push_guest_stack(lg, &gstack, regs->esp);
 	} else {
@@ -43,21 +55,18 @@ int reflect_trap(struct lguest *lg, cons
 	regs->ss = ss;
 	regs->esp = (u32)gstack + lg->page_offset;
 	regs->cs = (__KERNEL_CS|GUEST_DPL);
-	regs->eip = trap->addr;
-
-	/* GS will be neutered on way back to guest. */
-	put_user(0, &lg->lguest_data->gs_gpf_eip);
+	regs->eip = idt_address(lo, hi);
 
 	/* Disable interrupts for an interrupt gate. */
-	if (trap->disable_interrupts)
+	if (idt_type(lo, hi) == 0xE)
 		put_user(0, &lg->lguest_data->irq_enabled);
-	return 1;
 }
 
 void maybe_do_interrupt(struct lguest *lg)
 {
 	unsigned int irq;
 	DECLARE_BITMAP(irqs, LGUEST_IRQS);
+	struct desc_struct *idt;
 
 	if (!lg->lguest_data)
 		return;
@@ -87,20 +96,36 @@ void maybe_do_interrupt(struct lguest *l
 			return;
 	}
 
-	if (lg->interrupt[irq].addr != 0) {
+	idt = &lg->idt[FIRST_EXTERNAL_VECTOR+irq];
+	if (idt_present(idt->a, idt->b)) {
 		clear_bit(irq, lg->irqs_pending);
-		reflect_trap(lg, &lg->interrupt[irq], 0);
+		reflect_trap(lg, idt->a, idt->b, 0);
 	}
 }
 
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
+	reflect_trap(lg, lo, hi, has_err(num));
+	return 1;
+}
+
 void check_bug_kill(struct lguest *lg)
 {
 #ifdef CONFIG_BUG
-	u32 eip = lg->state->regs.eip - PAGE_OFFSET;
+	u32 eip = lg->regs.eip - PAGE_OFFSET;
 	u16 insn;
 
 	/* This only works for addresses in linear mapping... */
-	if (lg->state->regs.eip < PAGE_OFFSET)
+	if (lg->regs.eip < PAGE_OFFSET)
 		return;
 	lhread(lg, &insn, eip, sizeof(insn));
 	if (insn == 0x0b0f) {
@@ -120,111 +145,125 @@ void check_bug_kill(struct lguest *lg)
 #endif	/* CONFIG_BUG */
 }
 
-static void copy_trap(struct lguest *lg,
-		      struct host_trap *trap,
-		      const struct desc_struct *desc)
-{
-	u8 type = ((desc->b >> 8) & 0xF);
-
-	/* Not present? */
-	if (!(desc->b & 0x8000)) {
-		trap->addr = 0;
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
+/* Set up trap in IDT. */
+static void set_trap(struct lguest *lg, struct desc_struct *trap,
+		     unsigned int num, u32 lo, u32 hi)
+{
+	u8 type = idt_type(lo, hi);
+
+	if (!idt_present(lo, hi)) {
+		trap->a = trap->b = 0;
 		return;
 	}
+
 	if (type != 0xE && type != 0xF)
 		kill_guest(lg, "bad IDT type %i", type);
-	trap->disable_interrupts = (type == 0xE);
-	trap->addr = ((desc->a & 0x0000FFFF) | (desc->b & 0xFFFF0000));
+
+	trap->a = ((__KERNEL_CS|GUEST_DPL)<<16) | (lo&0x0000FFFF);
+	trap->b = (hi&0xFFFFEF00);
+
+	/* Make sure trap address is available so we don't fault.  In
+	 * theory, it could overlap two pages, in practice it's aligned. */
+	if (direct_trap(lg, trap, num))
+		pin_page(lg, idt_address(lo, hi));
 }
 
-/* FIXME: Put this in hypervisor.S and do something clever with relocs? */
-static u8 tramp[]
-= { 0x0f, 0xa8, 0x0f, 0xa9, /* push %gs; pop %gs */
-    0x36, 0xc7, 0x05, 0x55, 0x55, 0x55, 0x55, 0x00, 0x00, 0x00, 0x00,
-    /* movl 0, %ss:lguest_data.gs_gpf_eip */
-    0xe9, 0x55, 0x55, 0x55, 0x55 /* jmp dstaddr */
-};
-#define TRAMP_MOVL_TARGET_OFF 7
-#define TRAMP_JMP_TARGET_OFF 16
-
-static u32 setup_trampoline(struct lguest *lg, unsigned int i, u32 dstaddr)
-{
-	u32 addr, off;
-
-	off = sizeof(tramp)*i;
-	memcpy(lg->trap_page + off, tramp, sizeof(tramp));
-
-	/* 0 is to be placed in lguest_data.gs_gpf_eip. */
-	addr = (u32)&lg->lguest_data->gs_gpf_eip + lg->page_offset;
-	memcpy(lg->trap_page + off + TRAMP_MOVL_TARGET_OFF, &addr, 4);
-
-	/* Address is relative to where end of jmp will be. */
-	addr = dstaddr - ((-4*1024*1024) + off + sizeof(tramp));
-	memcpy(lg->trap_page + off + TRAMP_JMP_TARGET_OFF, &addr, 4);
-	return (-4*1024*1024) + off;
-}
-
-/* We bounce through the trap page, for two reasons: firstly, we need
-   the interrupt destination always mapped, to avoid double faults,
-   secondly we want to reload %gs to make it innocuous on entering kernel.
- */
-static void setup_idt(struct lguest *lg,
-		      unsigned int i,
-		      const struct desc_struct *desc)
-{
-	u8 type = ((desc->b >> 8) & 0xF);
-	u32 taddr;
-
-	/* Not present? */
-	if (!(desc->b & 0x8000)) {
-		/* FIXME: When we need this, we'll know... */
-		if (lg->state->idt_table[i].a & 0x8000)
-			kill_guest(lg, "removing interrupts not supported");
-		return;
+void pin_stack_pages(struct lguest *lg)
+{
+	unsigned int i;
+
+	for (i = 0; i < lg->stack_pages; i++)
+		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
+}
+
+/* We need to ensure all the direct trap pages are mapped after we
+ * clear shadow mappings. */
+void pin_trap_pages(struct lguest *lg)
+{
+	unsigned int i;
+	struct desc_struct *trap;
+
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
+		trap = &lg->idt[i];
+		if (direct_trap(lg, trap, i))
+			pin_page(lg, idt_address(trap->a, trap->b));
 	}
 
-	/* We could reflect and disable interrupts, but guest can do itself. */
-	if (type != 0xF)
-		kill_guest(lg, "bad direct IDT %i type %i", i, type);
-
-	taddr = setup_trampoline(lg, i, (desc->a&0xFFFF)|(desc->b&0xFFFF0000));
-
-	lg->state->idt_table[i].a = (((__KERNEL_CS|GUEST_DPL)<<16)
-					| (taddr & 0x0000FFFF));
-	lg->state->idt_table[i].b = (desc->b&0xEF00)|(taddr&0xFFFF0000);
-}
-
-void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 high)
-{
-	struct desc_struct d = { low, high };
-
-	switch (i) {
-	/* Ignore NMI, doublefault, hypercall, spurious interrupt. */
-	case 2:
-	case 8:
-	case 15:
-	case LGUEST_TRAP_ENTRY:
-	/* FIXME: We should handle debug and int3 */
-	case 1:
-	case 3:
-		return;
-	/* We intercept page fault, general protection fault and fpu missing */
-	case 13:
-		copy_trap(lg, &lg->gpf_trap, &d);
-		return;
-	case 14:
-		copy_trap(lg, &lg->page_trap, &d);
-		return;
-	case 7:
-		copy_trap(lg, &lg->fpu_trap, &d);
+	trap = &lg->syscall_idt;
+	if (direct_trap(lg, trap, SYSCALL_VECTOR))
+		pin_page(lg, idt_address(trap->a, trap->b));
+	pin_stack_pages(lg);
+}
+
+void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
+{
+	/* Guest never handles: NMI, doublefault, hypercall, spurious irq. */
+	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
 		return;
-	}
 
-	/* Other traps go straight to guest. */
-	if (i < FIRST_EXTERNAL_VECTOR || i == SYSCALL_VECTOR)
-		setup_idt(lg, i, &d);
-	/* A virtual interrupt */
-	else if (i < FIRST_EXTERNAL_VECTOR + LGUEST_IRQS)
-		copy_trap(lg, &lg->interrupt[i-FIRST_EXTERNAL_VECTOR], &d);
+	if (num < ARRAY_SIZE(lg->idt))
+		set_trap(lg, &lg->idt[num], num, lo, hi);
+	else if (num == SYSCALL_VECTOR)
+		set_trap(lg, &lg->syscall_idt, num, lo, hi);
+}
+
+static void default_idt_entry(struct desc_struct *idt,
+			      int trap,
+			      const unsigned long def)
+{
+	u32 flags = 0x8e00;
+
+	/* They can't "int" into any of them except hypercall. */
+	if (trap == LGUEST_TRAP_ENTRY)
+		flags |= (GUEST_DPL << 13);
+
+	idt->a = (LGUEST_CS<<16) | (def&0x0000FFFF);
+	idt->b = (def&0xFFFF0000) | flags;
 }
 
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
diff -puN arch/i386/lguest/lg.h~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/lg.h
@@ -45,13 +45,6 @@ __init int init_pagetables(struct page *
 #define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
 #define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
 
-/* Simplified version of IDT. */
-struct host_trap
-{
-	unsigned long addr;
-	int disable_interrupts;
-};
-
 struct lguest_dma_info
 {
 	struct list_head list;
@@ -69,10 +62,66 @@ struct pgdir
 	u32 *pgdir;
 };
 
+/* Hardware-defined TSS structure. */
+struct x86_tss
+{
+	unsigned short	back_link,__blh;
+	unsigned long	esp0;
+	unsigned short	ss0,__ss0pad;
+	unsigned long	esp1;
+	unsigned short	ss1,__ss1pad;
+	unsigned long	esp2;
+	unsigned short	ss2,__ss2pad;
+	unsigned long	cr3;
+	unsigned long	eip;
+	unsigned long	eflags;
+	unsigned long	eax,ecx,edx,ebx;
+	unsigned long	esp;
+	unsigned long	ebp;
+	unsigned long	esi;
+	unsigned long	edi;
+	unsigned short	es, __espad;
+	unsigned short	cs, __cspad;
+	unsigned short	ss, __sspad;
+	unsigned short	ds, __dspad;
+	unsigned short	fs, __fspad;
+	unsigned short	gs, __gspad;
+	unsigned short	ldt, __ldtpad;
+	unsigned short	trace, io_bitmap_base;
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
+	struct x86_tss guest_tss;
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
 /* The private info the thread maintains about the guest. */
 struct lguest
 {
-	struct lguest_state *state;
+	struct lguest_regs regs;
 	struct lguest_data __user *lguest_data;
 	struct task_struct *tsk;
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
@@ -84,15 +133,14 @@ struct lguest
 	int timer_on;
 	int halted;
 	int ts;
-	u32 gpf_eip;
 	u32 last_timer;
 	u32 next_hcall;
-	u16 tls_limits[GDT_ENTRY_TLS_ENTRIES];
+	u32 esp1;
+	u8 ss1;
 
 	/* We keep a small number of these. */
 	u32 pgdidx;
 	struct pgdir pgdirs[4];
-	void *trap_page;
 
 	/* Cached wakeup: we hold a reference to this task. */
 	struct task_struct *wake;
@@ -109,14 +157,15 @@ struct lguest
 	/* Dead? */
 	const char *dead;
 
-	/* We intercept page fault (demand shadow paging & cr2 saving)
-	   protection fault (in/out emulation, TLS handling) and
-	   device not available (TS handling). */
-	struct host_trap page_trap, gpf_trap, fpu_trap;
+	/* The GDT entries copied into lguest_ro_state when running. */
+	struct desc_struct gdt[GDT_ENTRIES];
+
+	/* The IDT entries: some copied into lguest_ro_state when running. */
+	struct desc_struct idt[FIRST_EXTERNAL_VECTOR+LGUEST_IRQS];
+	struct desc_struct syscall_idt;
 
-	/* Virtual interrupts */
+	/* Pending virtual interrupts */
 	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
-	struct host_trap interrupt[LGUEST_IRQS];
 };
 
 extern struct lguest lguests[];
@@ -125,7 +174,6 @@ extern struct mutex lguest_lock;
 /* core.c: */
 /* Entry points in hypervisor */
 const unsigned long *__lguest_default_idt_entries(void);
-struct lguest_state *__lguest_states(void);
 u32 lhread_u32(struct lguest *lg, u32 addr);
 void lhwrite_u32(struct lguest *lg, u32 val, u32 addr);
 void lhread(struct lguest *lg, void *buf, u32 addr, unsigned bytes);
@@ -136,15 +184,24 @@ int find_free_guest(void);
 
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lguest *lg);
-int reflect_trap(struct lguest *lg, const struct host_trap *trap, int has_err);
+int deliver_trap(struct lguest *lg, unsigned int num);
 void check_bug_kill(struct lguest *lg);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
+void pin_stack_pages(struct lguest *lg);
+void pin_trap_pages(struct lguest *lg);
+void setup_default_idt_entries(struct lguest_ro_state *state,
+			       const unsigned long *def);
+void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+		const unsigned long *def);
 
 /* segments.c: */
+void setup_default_gdt_entries(struct lguest_ro_state *state);
 void load_guest_gdt(struct lguest *lg, u32 table, u32 num);
 void guest_load_tls(struct lguest *lg,
 		    const struct desc_struct __user *tls_array);
+void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
 
+/* page_tables.c: */
 int init_guest_pagetable(struct lguest *lg, u32 pgtable);
 void free_guest_pagetable(struct lguest *lg);
 void guest_new_pagetable(struct lguest *lg, u32 pgtable);
@@ -153,12 +210,15 @@ void guest_pagetable_clear_all(struct lg
 void guest_pagetable_flush_user(struct lguest *lg);
 void guest_set_pte(struct lguest *lg, unsigned long cr3,
 		   unsigned long vaddr, u32 val);
-void map_trap_page(struct lguest *info);
+void map_hypervisor_in_guest(struct lguest *lg);
 int demand_page(struct lguest *info, u32 cr2, int write);
-void pin_stack_pages(struct lguest *lg);
+void pin_page(struct lguest *lg, u32 addr);
 
+/* lguest_user.c: */
 int lguest_device_init(void);
 void lguest_device_remove(void);
+
+/* io.c: */
 void lguest_io_init(void);
 u32 bind_dma(struct lguest *lg,
 	     unsigned long addr, unsigned long udma, u16 numdmas,u8 interrupt);
@@ -167,8 +227,9 @@ int send_dma(struct lguest *info, unsign
 void release_all_dma(struct lguest *lg);
 unsigned long get_dma_buffer(struct lguest *lg, unsigned long addr,
 			     unsigned long *interrupt);
-
 void set_wakeup_process(struct lguest *lg, struct task_struct *p);
+
+/* hypercalls.c: */
 int do_async_hcalls(struct lguest *info);
 int hypercall(struct lguest *info, struct lguest_regs *regs);
 
@@ -185,65 +246,5 @@ static inline unsigned long guest_pa(str
 {
 	return vaddr - lg->page_offset;
 }
-
-/* Hardware-defined TSS structure. */
-struct x86_tss
-{
-	unsigned short	back_link,__blh;
-	unsigned long	esp0;
-	unsigned short	ss0,__ss0pad;
-	unsigned long	esp1;
-	unsigned short	ss1,__ss1pad;
-	unsigned long	esp2;
-	unsigned short	ss2,__ss2pad;
-	unsigned long	cr3;
-	unsigned long	eip;
-	unsigned long	eflags;
-	unsigned long	eax,ecx,edx,ebx;
-	unsigned long	esp; /* We actually use this one to save esp. */
-	unsigned long	ebp;
-	unsigned long	esi;
-	unsigned long	edi;
-	unsigned short	es, __espad;
-	unsigned short	cs, __cspad;
-	unsigned short	ss, __sspad;
-	unsigned short	ds, __dspad;
-	unsigned short	fs, __fspad;
-	unsigned short	gs, __gspad;
-	unsigned short	ldt, __ldtpad;
-	unsigned short	trace, io_bitmap_base;
-};
-
-int fixup_gdt_table(struct desc_struct *gdt, unsigned int num,
-		    struct lguest_regs *regs, struct x86_tss *tss);
-
-struct lguest_host_state
-{
-	struct Xgt_desc_struct	gdt;
-	struct Xgt_desc_struct	idt;
-	unsigned long		pgdir;
-	unsigned long		stackptr;
-};
-
-/* This sits in the high-mapped shim. */
-struct lguest_state
-{
-	/* Task struct. */
-	struct x86_tss tss;
-
-	/* Gate descriptor table. */
-	struct Xgt_desc_struct gdt;
-	struct desc_struct gdt_table[GDT_ENTRIES];
-
-	/* Interrupt descriptor table. */
-	struct Xgt_desc_struct idt;
-	struct desc_struct idt_table[IDT_ENTRIES];
-
-	/* Host state we store while the guest runs. */
-	struct lguest_host_state host;
-
-	/* This is the stack on which we push our regs. */
-	struct lguest_regs regs;
-};
 #endif	/* __ASSEMBLY__ */
 #endif	/* _LGUEST_H */
diff -puN arch/i386/lguest/lguest_user.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/lguest_user.c
--- a/arch/i386/lguest/lguest_user.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/lguest_user.c
@@ -4,40 +4,9 @@
 #include <linux/fs.h>
 #include "lg.h"
 
-static struct lguest_state *setup_guest_state(unsigned int num,
-					      unsigned long start)
+static void setup_regs(struct lguest_regs *regs, unsigned long start)
 {
-	struct lguest_state *guest = &__lguest_states()[num];
-	unsigned int i;
-	const long *def = __lguest_default_idt_entries();
-	struct lguest_regs *regs;
-
-	guest->gdt_table[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
-	guest->gdt_table[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
-	guest->gdt.size = GDT_ENTRIES*8-1;
-	guest->gdt.address = (unsigned long)&guest->gdt_table;
-
-	/* Other guest's IDTs are initialized from default. */
-	guest->idt.size = 8 * IDT_ENTRIES;
-	guest->idt.address = (long)guest->idt_table;
-	for (i = 0; i < IDT_ENTRIES; i++) {
-		u32 flags = 0x8e00;
-
-		/* They can't "int" into any of them except hypercall. */
-		if (i == LGUEST_TRAP_ENTRY)
-			flags |= (GUEST_DPL << 13);
-
-		guest->idt_table[i].a = (LGUEST_CS<<16) | (def[i]&0x0000FFFF);
-		guest->idt_table[i].b = (def[i]&0xFFFF0000) | flags;
-	}
-
-	memset(&guest->tss, 0, sizeof(guest->tss));
-	guest->tss.ss0 = LGUEST_DS;
-	guest->tss.esp0 = (unsigned long)(guest+1);
-	guest->tss.io_bitmap_base = sizeof(guest->tss); /* No I/O for you! */
-
 	/* Write out stack in format lguest expects, so we can switch to it. */
-	regs = &guest->regs;
 	regs->eax = regs->ebx = regs->ecx = regs->edx = regs->esp = 0;
 	regs->edi = LGUEST_MAGIC_EDI;
 	regs->ebp = LGUEST_MAGIC_EBP;
@@ -49,12 +18,6 @@ static struct lguest_state *setup_guest_
 	regs->cs = __KERNEL_CS|GUEST_DPL;
 	regs->eflags = 0x202; 	/* Interrupts enabled. */
 	regs->ss = __KERNEL_DS|GUEST_DPL;
-
-	if (!fixup_gdt_table(guest->gdt_table, ARRAY_SIZE(guest->gdt_table),
-			     &guest->regs, &guest->tss))
-		return NULL;
-
-	return guest;
 }
 
 /* + addr */
@@ -138,32 +101,18 @@ static int initialize(struct file *file,
 	lg->pfn_limit = args[0];
 	lg->page_offset = args[3];
 
-	lg->trap_page = (u32 *)get_zeroed_page(GFP_KERNEL);
-	if (!lg->trap_page) {
-		err = -ENOMEM;
-		goto release_guest;
-	}
-
 	err = init_guest_pagetable(lg, args[1]);
 	if (err)
-		goto free_trap_page;
-
-	lg->state = setup_guest_state(i, args[2]);
-	if (!lg->state) {
-		err = -ENOEXEC;
-		goto release_pgtable;
-	}
-	mutex_unlock(&lguest_lock);
+		goto release_guest;
 
+	setup_regs(&lg->regs, args[2]);
 	lg->tsk = current;
 	lg->mm = get_task_mm(current);
+	mutex_unlock(&lguest_lock);
+
 	file->private_data = lg;
 	return sizeof(args);
 
-release_pgtable:
-	free_guest_pagetable(lg);
-free_trap_page:
-	free_page((long)lg->trap_page);
 release_guest:
 	memset(lg, 0, sizeof(*lg));
 unlock:
@@ -207,12 +156,10 @@ static int close(struct inode *inode, st
 
 	mutex_lock(&lguest_lock);
 	release_all_dma(lg);
-	free_page((long)lg->trap_page);
 	free_guest_pagetable(lg);
 	mmput(lg->mm);
 	if (lg->dead != (void *)1)
 		kfree(lg->dead);
-	memset(lg->state, 0, sizeof(*lg->state));
 	memset(lg, 0, sizeof(*lg));
 	mutex_unlock(&lguest_lock);
 	return 0;
diff -puN arch/i386/lguest/Makefile~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/Makefile
--- a/arch/i386/lguest/Makefile~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/Makefile
@@ -6,8 +6,8 @@ obj-$(CONFIG_LGUEST)	+= lg.o
 lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
 	segments.o io.o lguest_user.o
 
-# We use top 4MB for guest traps page, then hypervisor. */
-HYPE_ADDR := (0xFFC00000+4096)
+# We use top 4MB for hypervisor. */
+HYPE_ADDR := 0xFFC00000
 # The data is only 1k (256 interrupt handler pointers)
 HYPE_DATA_SIZE := 1024
 CFLAGS += -DHYPE_ADDR="$(HYPE_ADDR)" -DHYPE_DATA_SIZE="$(HYPE_DATA_SIZE)"
diff -puN arch/i386/lguest/page_tables.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/page_tables.c
@@ -168,16 +168,10 @@ static int page_writable(struct lguest *
 	return (*pte & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
 }
 
-void pin_stack_pages(struct lguest *lg)
+void pin_page(struct lguest *lg, u32 addr)
 {
-	unsigned int i;
-	u32 stack = lg->state->tss.esp1;
-
-	for (i = 0; i < lg->stack_pages; i++) {
-		if (!page_writable(lg, stack - i * PAGE_SIZE)
-		    && !demand_page(lg, stack - i * PAGE_SIZE, 1))
-			kill_guest(lg, "bad stack page %i@%#x", i, stack);
-	}
+	if (!page_writable(lg, addr) && !demand_page(lg, addr, 0))
+		kill_guest(lg, "bad trap page %#x", addr);
 }
 
 static unsigned int find_pgdir(struct lguest *lg, u32 pgtable)
@@ -243,7 +237,7 @@ void guest_new_pagetable(struct lguest *
 	lg->pgdidx = newpgdir;
 	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
 	if (repin)
-		pin_stack_pages(lg);
+		pin_trap_pages(lg);
 }
 
 static void release_all_pagetables(struct lguest *lg)
@@ -259,7 +253,7 @@ static void release_all_pagetables(struc
 void guest_pagetable_clear_all(struct lguest *lg)
 {
 	release_all_pagetables(lg);
-	pin_stack_pages(lg);
+	pin_trap_pages(lg);
 }
 
 static void do_set_pte(struct lguest *lg, int idx,
@@ -329,12 +323,10 @@ void free_guest_pagetable(struct lguest 
 }
 
 /* Caller must be preempt-safe */
-void map_trap_page(struct lguest *lg)
+void map_hypervisor_in_guest(struct lguest *lg)
 {
 	int cpu = smp_processor_id();
 
-	hypervisor_pte_page(cpu)[0] = (__pa(lg->trap_page)|_PAGE_PRESENT);
-
 	/* Since hypervisor less that 4MB, we simply mug top pte page. */
 	lg->pgdirs[lg->pgdidx].pgdir[HYPERVISOR_PGD_ENTRY] =
 		(__pa(hypervisor_pte_page(cpu))| _PAGE_KERNEL);
@@ -356,10 +348,18 @@ static __init void populate_hypervisor_p
 	u32 *pte = hypervisor_pte_page(cpu);
 
 	for (i = 0; i < pages; i++) {
-		/* First entry set dynamically in map_trap_page */
-		pte[i+1] = ((page_to_pfn(hype_page[i]) << PAGE_SHIFT)
-			    | _PAGE_KERNEL_EXEC);
+		pte[i] = ((page_to_pfn(hype_page[i]) << PAGE_SHIFT)
+			    | _PAGE_PRESENT|_PAGE_ACCESSED);
 	}
+
+	/* We only map this CPU's pages, so guest can't see others. */
+	i = pages + cpu*2;
+
+	/* First page (regs) is rw, second (state) is ro. */
+	pte[i] = ((page_to_pfn(hype_page[i]) << PAGE_SHIFT)
+		  | _PAGE_PRESENT|_PAGE_ACCESSED|_PAGE_RW);
+	pte[i+1] = ((page_to_pfn(hype_page[i+1]) << PAGE_SHIFT)
+		    | _PAGE_PRESENT|_PAGE_ACCESSED);
 }
 
 __init int init_pagetables(struct page **hype_page, int pages)
diff -puN arch/i386/lguest/segments.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher arch/i386/lguest/segments.c
--- a/arch/i386/lguest/segments.c~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/arch/i386/lguest/segments.c
@@ -1,171 +1,114 @@
 #include "lg.h"
 
-/* Dealing with GDT entries is such a horror, I convert to sanity and back */
-struct decoded_gdt_entry
+static int desc_ok(const struct desc_struct *gdt)
 {
-	u32 base, limit;
-	union {
-		struct {
-			unsigned type:4;
-			unsigned dtype:1;
-			unsigned dpl:2;
-			unsigned present:1;
-			unsigned unused:4;
-			unsigned avl:1;
-			unsigned mbz:1;
-			unsigned def:1;
-			unsigned page_granularity:1;
-		};
-		u16 raw_attributes;
-	};
-};
-
-static struct decoded_gdt_entry decode_gdt_entry(const struct desc_struct *en)
-{
-	struct decoded_gdt_entry de;
-	de.base = ((en->a >> 16) | ((en->b & 0xff) << 16)
-		   | (en->b & 0xFF000000));
-	de.limit = ((en->a & 0xFFFF) | (en->b & 0xF0000));
-	de.raw_attributes = (en->b >> 8);
-	return de;
-}
-
-static struct desc_struct encode_gdt_entry(const struct decoded_gdt_entry *de)
-{
-	struct desc_struct en;
-	en.a = ((de->limit & 0xFFFF) | (de->base << 16));
-	en.b = (((de->base >> 16) & 0xFF)
-		 | ((((u32)de->raw_attributes) & 0xF0FF) << 8)
-		 | (de->limit & 0xF0000)
-		 | (de->base & 0xFF000000));
-	return en;
+	/* MBZ=0, P=1, DT=1  */
+	return ((gdt->b & 0x00209000) == 0x00009000);
 }
 
-static int check_desc(const struct decoded_gdt_entry *dec)
+static int segment_present(const struct desc_struct *gdt)
 {
-	return (dec->mbz == 0 && dec->dtype == 1 && (dec->type & 4) == 0);
+	return gdt->b & 0x8000;
 }
 
-static void check_segment(const struct desc_struct *gdt, u32 *segreg)
+static int ignored_gdt(unsigned int num)
 {
-	if (*segreg > 255 || !(gdt[*segreg >> 3].b & 0x8000))
-		*segreg = 0;
+	return (num == GDT_ENTRY_TSS
+		|| num == GDT_ENTRY_LGUEST_CS
+		|| num == GDT_ENTRY_LGUEST_DS
+		|| num == GDT_ENTRY_KERNEL_CS
+		|| num == GDT_ENTRY_KERNEL_DS
+		|| num == GDT_ENTRY_DOUBLEFAULT_TSS);
 }
 
-/* Ensure our manually-loaded segment regs don't fault in switch_to_guest. */
-static void check_live_segments(const struct desc_struct *gdt,
-				struct lguest_regs *regs)
+/* We don't allow removal of CS, DS or SS; it doesn't make sense. */
+static void check_segment_use(struct lguest *lg, unsigned int desc)
 {
-	check_segment(gdt, &regs->es);
-	check_segment(gdt, &regs->ds);
-	check_segment(gdt, &regs->fs);
-	check_segment(gdt, &regs->gs);
+	if (lg->regs.gs / 8 == desc)
+		lg->regs.gs = 0;
+	if (lg->regs.fs / 8 == desc)
+		lg->regs.fs = 0;
+	if (lg->regs.es / 8 == desc)
+		lg->regs.es = 0;
+	if (lg->regs.ds / 8 == desc
+	    || lg->regs.cs / 8 == desc
+	    || lg->regs.ss / 8 == desc)
+		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
 
-int fixup_gdt_table(struct desc_struct *gdt, unsigned int num,
-		    struct lguest_regs *regs, struct x86_tss *tss)
+static void fixup_gdt_table(struct lguest *lg)
 {
 	unsigned int i;
-	struct decoded_gdt_entry dec;
-
-	for (i = 0; i < num; i++) {
-		unsigned long base, length;
 
-		/* We override these ones, so we don't care what they give. */
-		if (i == GDT_ENTRY_TSS
-		    || i == GDT_ENTRY_LGUEST_CS
-		    || i == GDT_ENTRY_LGUEST_DS
-		    || i == GDT_ENTRY_DOUBLEFAULT_TSS)
+	for (i = 0; i < ARRAY_SIZE(lg->gdt); i++) {
+		/* We never copy these ones to real gdt */
+		if (ignored_gdt(i))
 			continue;
 
-		dec = decode_gdt_entry(&gdt[i]);
-		if (!dec.present)
+		/* We could fault in switch_to_guest if they are using
+		 * a removed segment. */
+		if (!segment_present(&lg->gdt[i])) {
+			check_segment_use(lg, i);
 			continue;
+		}
 
-		if (!check_desc(&dec))
-			return 0;
+		if (!desc_ok(&lg->gdt[i]))
+			kill_guest(lg, "Bad GDT descriptor %i", i);
 
-		base = dec.base;
-		length = dec.limit + 1;
-		if (dec.page_granularity) {
-			base *= PAGE_SIZE;
-			length *= PAGE_SIZE;
-		}
+		/* DPL 0 presumably means "for use by guest". */
+		if ((lg->gdt[i].b & 0x00006000) == 0)
+			lg->gdt[i].b |= (GUEST_DPL << 13);
 
-		/* Unacceptable base? */
-		if (base >= HYPE_ADDR)
-			return 0;
-
-		/* Wrap around or segment overlaps hypervisor mem? */
-		if (!length
-		    || base + length < base
-		    || base + length > HYPE_ADDR) {
-			/* Trim to edge of hypervisor. */
-			length = HYPE_ADDR - base;
-			if (dec.page_granularity)
-				dec.limit = (length / PAGE_SIZE) - 1;
-			else
-				dec.limit = length - 1;
-		}
-		if (dec.dpl == 0)
-			dec.dpl = GUEST_DPL;
-		gdt[i] = encode_gdt_entry(&dec);
+		/* Set accessed bit, since gdt isn't writable. */
+		lg->gdt[i].b |= 0x00000100;
 	}
-	check_live_segments(gdt, regs);
+}
 
-	/* Now put in hypervisor data and code segments. */
+void setup_default_gdt_entries(struct lguest_ro_state *state)
+{
+	struct desc_struct *gdt = state->guest_gdt;
+	unsigned long tss = (unsigned long)&state->guest_tss;
+
+	/* Hypervisor segments. */
 	gdt[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
 	gdt[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
 
-	/* Finally, TSS entry */
-	dec.base = (unsigned long)tss;
-	dec.limit = sizeof(*tss)-1;
-	dec.type = 0x9;
-	dec.dtype = 0;
-	dec.def = 0;
-	dec.present = 1;
-	dec.mbz = 0;
-	dec.page_granularity = 0;
-	gdt[GDT_ENTRY_TSS] = encode_gdt_entry(&dec);
+	/* Guest data and code segments: modified to DPL 1.
+	 * We don't copy these from host for easy of setup. */
+	gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
+	gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
+	gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_DPL << 13);
+	gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_DPL << 13);
+
+	/* This is the one which we *cannot* copy from guest, since tss
+	   is depended on this lguest_ro_state, ie. this cpu. */
+	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
+	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
+		| ((tss >> 16) & 0x000000FF);
+}
+
+void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
 
-	return 1;
+	for (i = 0; i < GDT_ENTRIES; i++)
+		if (!ignored_gdt(i))
+			gdt[i] = lg->gdt[i];
 }
 
 void load_guest_gdt(struct lguest *lg, u32 table, u32 num)
 {
-	if (num > GDT_ENTRIES)
+	if (num > ARRAY_SIZE(lg->gdt))
 		kill_guest(lg, "too many gdt entries %i", num);
 
-	lhread(lg, lg->state->gdt_table, table,
-	       num * sizeof(lg->state->gdt_table[0]));
-	if (!fixup_gdt_table(lg->state->gdt_table, num,
-			     &lg->state->regs, &lg->state->tss))
-		kill_guest(lg, "bad gdt table");
+	lhread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
+	fixup_gdt_table(lg);
 }
 
-/* We don't care about limit here, since we only let them use these in
- * usermode (where lack of USER bit in pagetable protects hypervisor mem).
- * However, we want to ensure it doesn't fault when loaded, since *we* are
- * the ones who will load it in switch_to_guest.
- */
 void guest_load_tls(struct lguest *lg, const struct desc_struct __user *gtls)
 {
-	unsigned int i;
-	struct desc_struct *tls = &lg->state->gdt_table[GDT_ENTRY_TLS_MIN];
+	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
 
 	lhread(lg, tls, (u32)gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
-	for (i = 0; i < ARRAY_SIZE(lg->tls_limits); i++) {
-		struct decoded_gdt_entry dec = decode_gdt_entry(&tls[i]);
-
-		if (!dec.present)
-			continue;
-
-		/* We truncate to one byte/page (depending on G bit) to neuter
-		   it, so ensure it's more than 1 page below trap page. */
-		tls[i].a &= 0xFFFF0000;
-		lg->tls_limits[i] = dec.limit;
-		if (!check_desc(&dec) || dec.base > HYPE_ADDR - PAGE_SIZE)
-			kill_guest(lg, "bad TLS descriptor %i", i);
-	}
-	check_live_segments(lg->state->gdt_table, &lg->state->regs);
+	fixup_gdt_table(lg);
 }
diff -puN include/asm-i386/lguest.h~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher include/asm-i386/lguest.h
--- a/include/asm-i386/lguest.h~lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher
+++ a/include/asm-i386/lguest.h
@@ -59,9 +59,6 @@ struct lguest_data
 	/* Blocked interrupts. */
 	DECLARE_BITMAP(interrupts, LGUEST_IRQS);
 
-	/* Last (userspace) address we got a GPF & reloaded gs. */
-	unsigned int gs_gpf_eip;
-
 	/* Virtual address of page fault. */
 	unsigned long cr2;
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

futex-restartable-futex_wait.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
