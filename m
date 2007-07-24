From: akpm@linux-foundation.org
Subject: + lguest-documentation-v-host.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:18:22 -0700
Message-ID: <200707240318.l6O3IMek025678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756187AbXGXDSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: documentation V: Host
has been added to the -mm tree.  Its filename is
     lguest-documentation-v-host.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: documentation V: Host
From: Rusty Russell <rusty@rustcorp.com.au>

Documentation: The Host

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c                 |  273 +++++++++++++++++++-
 drivers/lguest/hypercalls.c           |  120 ++++++++-
 drivers/lguest/interrupts_and_traps.c |  176 ++++++++++++-
 drivers/lguest/lg.h                   |   19 +
 drivers/lguest/page_tables.c          |  314 +++++++++++++++++++++---
 drivers/lguest/segments.c             |  109 +++++++-
 6 files changed, 925 insertions(+), 86 deletions(-)

diff -puN drivers/lguest/core.c~lguest-documentation-v-host drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-documentation-v-host
+++ a/drivers/lguest/core.c
@@ -64,11 +64,33 @@ static struct lguest_pages *lguest_pages
 		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
 }
 
+/*H:010 We need to set up the Switcher at a high virtual address.  Remember the
+ * Switcher is a few hundred bytes of assembler code which actually changes the
+ * CPU to run the Guest, and then changes back to the Host when a trap or
+ * interrupt happens.
+ *
+ * The Switcher code must be at the same virtual address in the Guest as the
+ * Host since it will be running as the switchover occurs.
+ *
+ * Trying to map memory at a particular address is an unusual thing to do, so
+ * it's not a simple one-liner.  We also set up the per-cpu parts of the
+ * Switcher here.
+ */
 static __init int map_switcher(void)
 {
 	int i, err;
 	struct page **pagep;
 
+	/*
+	 * Map the Switcher in to high memory.
+	 *
+	 * It turns out that if we choose the address 0xFFC00000 (4MB under the
+	 * top virtual address), it makes setting up the page tables really
+	 * easy.
+	 */
+
+	/* We allocate an array of "struct page"s.  map_vm_area() wants the
+	 * pages in this form, rather than just an array of pointers. */
 	switcher_page = kmalloc(sizeof(switcher_page[0])*TOTAL_SWITCHER_PAGES,
 				GFP_KERNEL);
 	if (!switcher_page) {
@@ -76,6 +98,8 @@ static __init int map_switcher(void)
 		goto out;
 	}
 
+	/* Now we actually allocate the pages.  The Guest will see these pages,
+	 * so we make sure they're zeroed. */
 	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++) {
 		unsigned long addr = get_zeroed_page(GFP_KERNEL);
 		if (!addr) {
@@ -85,6 +109,9 @@ static __init int map_switcher(void)
 		switcher_page[i] = virt_to_page(addr);
 	}
 
+	/* Now we reserve the "virtual memory area" we want: 0xFFC00000
+	 * (SWITCHER_ADDR).  We might not get it in theory, but in practice
+	 * it's worked so far. */
 	switcher_vma = __get_vm_area(TOTAL_SWITCHER_PAGES * PAGE_SIZE,
 				       VM_ALLOC, SWITCHER_ADDR, VMALLOC_END);
 	if (!switcher_vma) {
@@ -93,49 +120,105 @@ static __init int map_switcher(void)
 		goto free_pages;
 	}
 
+	/* This code actually sets up the pages we've allocated to appear at
+	 * SWITCHER_ADDR.  map_vm_area() takes the vma we allocated above, the
+	 * kind of pages we're mapping (kernel pages), and a pointer to our
+	 * array of struct pages.  It increments that pointer, but we don't
+	 * care. */
 	pagep = switcher_page;
 	err = map_vm_area(switcher_vma, PAGE_KERNEL, &pagep);
 	if (err) {
 		printk("lguest: map_vm_area failed: %i\n", err);
 		goto free_vma;
 	}
+
+	/* Now the switcher is mapped at the right address, we can't fail!
+	 * Copy in the compiled-in Switcher code (from switcher.S). */
 	memcpy(switcher_vma->addr, start_switcher_text,
 	       end_switcher_text - start_switcher_text);
 
-	/* Fix up IDT entries to point into copied text. */
+	/* Most of the switcher.S doesn't care that it's been moved; on Intel,
+	 * jumps are relative, and it doesn't access any references to external
+	 * code or data.
+	 *
+	 * The only exception is the interrupt handlers in switcher.S: their
+	 * addresses are placed in a table (default_idt_entries), so we need to
+	 * update the table with the new addresses.  switcher_offset() is a
+	 * convenience function which returns the distance between the builtin
+	 * switcher code and the high-mapped copy we just made. */
 	for (i = 0; i < IDT_ENTRIES; i++)
 		default_idt_entries[i] += switcher_offset();
 
+	/*
+	 * Set up the Switcher's per-cpu areas.
+	 *
+	 * Each CPU gets two pages of its own within the high-mapped region
+	 * (aka. "struct lguest_pages").  Much of this can be initialized now,
+	 * but some depends on what Guest we are running (which is set up in
+	 * copy_in_guest_info()).
+	 */
 	for_each_possible_cpu(i) {
+		/* lguest_pages() returns this CPU's two pages. */
 		struct lguest_pages *pages = lguest_pages(i);
+		/* This is a convenience pointer to make the code fit one
+		 * statement to a line. */
 		struct lguest_ro_state *state = &pages->state;
 
-		/* These fields are static: rest done in copy_in_guest_info */
+		/* The Global Descriptor Table: the Host has a different one
+		 * for each CPU.  We keep a descriptor for the GDT which says
+		 * where it is and how big it is (the size is actually the last
+		 * byte, not the size, hence the "-1"). */
 		state->host_gdt_desc.size = GDT_SIZE-1;
 		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
+
+		/* All CPUs on the Host use the same Interrupt Descriptor
+		 * Table, so we just use store_idt(), which gets this CPU's IDT
+		 * descriptor. */
 		store_idt(&state->host_idt_desc);
+
+		/* The descriptors for the Guest's GDT and IDT can be filled
+		 * out now, too.  We copy the GDT & IDT into ->guest_gdt and
+		 * ->guest_idt before actually running the Guest. */
 		state->guest_idt_desc.size = sizeof(state->guest_idt)-1;
 		state->guest_idt_desc.address = (long)&state->guest_idt;
 		state->guest_gdt_desc.size = sizeof(state->guest_gdt)-1;
 		state->guest_gdt_desc.address = (long)&state->guest_gdt;
+
+		/* We know where we want the stack to be when the Guest enters
+		 * the switcher: in pages->regs.  The stack grows upwards, so
+		 * we start it at the end of that structure. */
 		state->guest_tss.esp0 = (long)(&pages->regs + 1);
+		/* And this is the GDT entry to use for the stack: we keep a
+		 * couple of special LGUEST entries. */
 		state->guest_tss.ss0 = LGUEST_DS;
-		/* No I/O for you! */
+
+		/* x86 can have a finegrained bitmap which indicates what I/O
+		 * ports the process can use.  We set it to the end of our
+		 * structure, meaning "none". */
 		state->guest_tss.io_bitmap_base = sizeof(state->guest_tss);
+
+		/* Some GDT entries are the same across all Guests, so we can
+		 * set them up now. */
 		setup_default_gdt_entries(state);
+		/* Most IDT entries are the same for all Guests, too.*/
 		setup_default_idt_entries(state, default_idt_entries);
 
-		/* Setup LGUEST segments on all cpus */
+		/* The Host needs to be able to use the LGUEST segments on this
+		 * CPU, too, so put them in the Host GDT. */
 		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
 		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
 	}
 
-	/* Initialize entry point into switcher. */
+	/* In the Switcher, we want the %cs segment register to use the
+	 * LGUEST_CS GDT entry: we've put that in the Host and Guest GDTs, so
+	 * it will be undisturbed when we switch.  To change %cs and jump we
+	 * need this structure to feed to Intel's "lcall" instruction. */
 	lguest_entry.offset = (long)switch_to_guest + switcher_offset();
 	lguest_entry.segment = LGUEST_CS;
 
 	printk(KERN_INFO "lguest: mapped switcher at %p\n",
 	       switcher_vma->addr);
+	/* And we succeeded... */
 	return 0;
 
 free_vma:
@@ -149,35 +232,58 @@ free_some_pages:
 out:
 	return err;
 }
+/*:*/
 
+/* Cleaning up the mapping when the module is unloaded is almost...
+ * too easy. */
 static void unmap_switcher(void)
 {
 	unsigned int i;
 
+	/* vunmap() undoes *both* map_vm_area() and __get_vm_area(). */
 	vunmap(switcher_vma->addr);
+	/* Now we just need to free the pages we copied the switcher into */
 	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++)
 		__free_pages(switcher_page[i], 0);
 }
 
-/* IN/OUT insns: enough to get us past boot-time probing. */
+/*H:130 Our Guest is usually so well behaved; it never tries to do things it
+ * isn't allowed to.  Unfortunately, "struct paravirt_ops" isn't quite
+ * complete, because it doesn't contain replacements for the Intel I/O
+ * instructions.  As a result, the Guest sometimes fumbles across one during
+ * the boot process as it probes for various things which are usually attached
+ * to a PC.
+ *
+ * When the Guest uses one of these instructions, we get trap #13 (General
+ * Protection Fault) and come here.  We see if it's one of those troublesome
+ * instructions and skip over it.  We return true if we did. */
 static int emulate_insn(struct lguest *lg)
 {
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
+	/* The eip contains the *virtual* address of the Guest's instruction:
+	 * guest_pa just subtracts the Guest's page_offset. */
 	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
 
-	/* This only works for addresses in linear mapping... */
+	/* The guest_pa() function only works for Guest kernel addresses, but
+	 * that's all we're trying to do anyway. */
 	if (lg->regs->eip < lg->page_offset)
 		return 0;
+
+	/* Decoding x86 instructions is icky. */
 	lgread(lg, &insn, physaddr, 1);
 
-	/* Operand size prefix means it's actually for ax. */
+	/* 0x66 is an "operand prefix".  It means it's using the upper 16 bits
+	   of the eax register. */
 	if (insn == 0x66) {
 		shift = 16;
+		/* The instruction is 1 byte so far, read the next byte. */
 		insnlen = 1;
 		lgread(lg, &insn, physaddr + insnlen, 1);
 	}
 
+	/* We can ignore the lower bit for the moment and decode the 4 opcodes
+	 * we need to emulate. */
 	switch (insn & 0xFE) {
 	case 0xE4: /* in     <next byte>,%al */
 		insnlen += 2;
@@ -194,9 +300,13 @@ static int emulate_insn(struct lguest *l
 		insnlen += 1;
 		break;
 	default:
+		/* OK, we don't know what this is, can't emulate. */
 		return 0;
 	}
 
+	/* If it was an "IN" instruction, they expect the result to be read
+	 * into %eax, so we change %eax.  We always return all-ones, which
+	 * traditionally means "there's nothing there". */
 	if (in) {
 		/* Lower bit tells is whether it's a 16 or 32 bit access */
 		if (insn & 0x1)
@@ -204,9 +314,12 @@ static int emulate_insn(struct lguest *l
 		else
 			lg->regs->eax |= (0xFFFF << shift);
 	}
+	/* Finally, we've "done" the instruction, so move past it. */
 	lg->regs->eip += insnlen;
+	/* Success! */
 	return 1;
 }
+/*:*/
 
 /*L:305
  * Dealing With Guest Memory.
@@ -321,13 +434,24 @@ static void run_guest_once(struct lguest
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
 
+/*H:030 Let's jump straight to the the main loop which runs the Guest.
+ * Remember, this is called by the Launcher reading /dev/lguest, and we keep
+ * going around and around until something interesting happens. */
 int run_guest(struct lguest *lg, unsigned long __user *user)
 {
+	/* We stop running once the Guest is dead. */
 	while (!lg->dead) {
+		/* We need to initialize this, otherwise gcc complains.  It's
+		 * not (yet) clever enough to see that it's initialized when we
+		 * need it. */
 		unsigned int cr2 = 0; /* Damn gcc */
 
-		/* Hypercalls first: we might have been out to userspace */
+		/* First we run any hypercalls the Guest wants done: either in
+		 * the hypercall ring in "struct lguest_data", or directly by
+		 * using int 31 (LGUEST_TRAP_ENTRY). */
 		do_hypercalls(lg);
+		/* It's possible the Guest did a SEND_DMA hypercall to the
+		 * Launcher, in which case we return from the read() now. */
 		if (lg->dma_is_pending) {
 			if (put_user(lg->pending_dma, user) ||
 			    put_user(lg->pending_key, user+1))
@@ -335,6 +459,7 @@ int run_guest(struct lguest *lg, unsigne
 			return sizeof(unsigned long)*2;
 		}
 
+		/* Check for signals */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
@@ -342,77 +467,154 @@ int run_guest(struct lguest *lg, unsigne
 		if (lg->break_out)
 			return -EAGAIN;
 
+		/* Check if there are any interrupts which can be delivered
+		 * now: if so, this sets up the hander to be executed when we
+		 * next run the Guest. */
 		maybe_do_interrupt(lg);
 
+		/* All long-lived kernel loops need to check with this horrible
+		 * thing called the freezer.  If the Host is trying to suspend,
+		 * it stops us. */
 		try_to_freeze();
 
+		/* Just make absolutely sure the Guest is still alive.  One of
+		 * those hypercalls could have been fatal, for example. */
 		if (lg->dead)
 			break;
 
+		/* If the Guest asked to be stopped, we sleep.  The Guest's
+		 * clock timer or LHCALL_BREAK from the Waker will wake us. */
 		if (lg->halted) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			continue;
 		}
 
+		/* OK, now we're ready to jump into the Guest.  First we put up
+		 * the "Do Not Disturb" sign: */
 		local_irq_disable();
 
-		/* Even if *we* don't want FPU trap, guest might... */
+		/* Remember the awfully-named TS bit?  If the Guest has asked
+		 * to set it we set it now, so we can trap and pass that trap
+		 * to the Guest if it uses the FPU. */
 		if (lg->ts)
 			set_ts();
 
-		/* Don't let Guest do SYSENTER: we can't handle it. */
+		/* SYSENTER is an optimized way of doing system calls.  We
+		 * can't allow it because it always jumps to privilege level 0.
+		 * A normal Guest won't try it because we don't advertise it in
+		 * CPUID, but a malicious Guest (or malicious Guest userspace
+		 * program) could, so we tell the CPU to disable it before
+		 * running the Guest. */
 		if (boot_cpu_has(X86_FEATURE_SEP))
 			wrmsr(MSR_IA32_SYSENTER_CS, 0, 0);
 
+		/* Now we actually run the Guest.  It will pop back out when
+		 * something interesting happens, and we can examine its
+		 * registers to see what it was doing. */
 		run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
 
-		/* Save cr2 now if we page-faulted. */
+		/* The "regs" pointer contains two extra entries which are not
+		 * really registers: a trap number which says what interrupt or
+		 * trap made the switcher code come back, and an error code
+		 * which some traps set.  */
+
+		/* If the Guest page faulted, then the cr2 register will tell
+		 * us the bad virtual address.  We have to grab this now,
+		 * because once we re-enable interrupts an interrupt could
+		 * fault and thus overwrite cr2, or we could even move off to a
+		 * different CPU. */
 		if (lg->regs->trapnum == 14)
 			cr2 = read_cr2();
+		/* Similarly, if we took a trap because the Guest used the FPU,
+		 * we have to restore the FPU it expects to see. */
 		else if (lg->regs->trapnum == 7)
 			math_state_restore();
 
+		/* Restore SYSENTER if it's supposed to be on. */
 		if (boot_cpu_has(X86_FEATURE_SEP))
 			wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+
+		/* Now we're ready to be interrupted or moved to other CPUs */
 		local_irq_enable();
 
+		/* OK, so what happened? */
 		switch (lg->regs->trapnum) {
 		case 13: /* We've intercepted a GPF. */
+			/* Check if this was one of those annoying IN or OUT
+			 * instructions which we need to emulate.  If so, we
+			 * just go back into the Guest after we've done it. */
 			if (lg->regs->errcode == 0) {
 				if (emulate_insn(lg))
 					continue;
 			}
 			break;
 		case 14: /* We've intercepted a page fault. */
+			/* The Guest accessed a virtual address that wasn't
+			 * mapped.  This happens a lot: we don't actually set
+			 * up most of the page tables for the Guest at all when
+			 * we start: as it runs it asks for more and more, and
+			 * we set them up as required. In this case, we don't
+			 * even tell the Guest that the fault happened.
+			 *
+			 * The errcode tells whether this was a read or a
+			 * write, and whether kernel or userspace code. */
 			if (demand_page(lg, cr2, lg->regs->errcode))
 				continue;
 
-			/* If lguest_data is NULL, this won't hurt. */
+			/* OK, it's really not there (or not OK): the Guest
+			 * needs to know.  We write out the cr2 value so it
+			 * knows where the fault occurred.
+			 *
+			 * Note that if the Guest were really messed up, this
+			 * could happen before it's done the INITIALIZE
+			 * hypercall, so lg->lguest_data will be NULL, so
+			 * &lg->lguest_data->cr2 will be address 8.  Writing
+			 * into that address won't hurt the Host at all,
+			 * though. */
 			if (put_user(cr2, &lg->lguest_data->cr2))
 				kill_guest(lg, "Writing cr2");
 			break;
 		case 7: /* We've intercepted a Device Not Available fault. */
-			/* If they don't want to know, just absorb it. */
+			/* If the Guest doesn't want to know, we already
+			 * restored the Floating Point Unit, so we just
+			 * continue without telling it. */
 			if (!lg->ts)
 				continue;
 			break;
-		case 32 ... 255: /* Real interrupt, fall thru */
+		case 32 ... 255:
+			/* These values mean a real interrupt occurred, in
+			 * which case the Host handler has already been run.
+			 * We just do a friendly check if another process
+			 * should now be run, then fall through to loop
+			 * around: */
 			cond_resched();
 		case LGUEST_TRAP_ENTRY: /* Handled at top of loop */
 			continue;
 		}
 
+		/* If we get here, it's a trap the Guest wants to know
+		 * about. */
 		if (deliver_trap(lg, lg->regs->trapnum))
 			continue;
 
+		/* If the Guest doesn't have a handler (either it hasn't
+		 * registered any yet, or it's one of the faults we don't let
+		 * it handle), it dies with a cryptic error message. */
 		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
 			   lg->regs->trapnum, lg->regs->eip,
 			   lg->regs->trapnum == 14 ? cr2 : lg->regs->errcode);
 	}
+	/* The Guest is dead => "No such file or directory" */
 	return -ENOENT;
 }
 
+/* Now we can look at each of the routines this calls, in increasing order of
+ * complexity: do_hypercalls(), emulate_insn(), maybe_do_interrupt(),
+ * deliver_trap() and demand_page().  After all those, we'll be ready to
+ * examine the Switcher, and our philosophical understanding of the Host/Guest
+ * duality will be complete. :*/
+
 int find_free_guest(void)
 {
 	unsigned int i;
@@ -430,55 +632,96 @@ static void adjust_pge(void *on)
 		write_cr4(read_cr4() & ~X86_CR4_PGE);
 }
 
+/*H:000
+ * Welcome to the Host!
+ *
+ * By this point your brain has been tickled by the Guest code and numbed by
+ * the Launcher code; prepare for it to be stretched by the Host code.  This is
+ * the heart.  Let's begin at the initialization routine for the Host's lg
+ * module.
+ */
 static int __init init(void)
 {
 	int err;
 
+	/* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
 	if (paravirt_enabled()) {
 		printk("lguest is afraid of %s\n", paravirt_ops.name);
 		return -EPERM;
 	}
 
+	/* First we put the Switcher up in very high virtual memory. */
 	err = map_switcher();
 	if (err)
 		return err;
 
+	/* Now we set up the pagetable implementation for the Guests. */
 	err = init_pagetables(switcher_page, SHARED_SWITCHER_PAGES);
 	if (err) {
 		unmap_switcher();
 		return err;
 	}
+
+	/* The I/O subsystem needs some things initialized. */
 	lguest_io_init();
 
+	/* /dev/lguest needs to be registered. */
 	err = lguest_device_init();
 	if (err) {
 		free_pagetables();
 		unmap_switcher();
 		return err;
 	}
+
+	/* Finally, we need to turn off "Page Global Enable".  PGE is an
+	 * optimization where page table entries are specially marked to show
+	 * they never change.  The Host kernel marks all the kernel pages this
+	 * way because it's always present, even when userspace is running.
+	 *
+	 * Lguest breaks this: unbeknownst to the rest of the Host kernel, we
+	 * switch to the Guest kernel.  If you don't disable this on all CPUs,
+	 * you'll get really weird bugs that you'll chase for two days.
+	 *
+	 * I used to turn PGE off every time we switched to the Guest and back
+	 * on when we return, but that slowed the Switcher down noticibly. */
+
+	/* We don't need the complexity of CPUs coming and going while we're
+	 * doing this. */
 	lock_cpu_hotplug();
 	if (cpu_has_pge) { /* We have a broader idea of "global". */
+		/* Remember that this was originally set (for cleanup). */
 		cpu_had_pge = 1;
+		/* adjust_pge is a helper function which sets or unsets the PGE
+		 * bit on its CPU, depending on the argument (0 == unset). */
 		on_each_cpu(adjust_pge, (void *)0, 0, 1);
+		/* Turn off the feature in the global feature set. */
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
 	unlock_cpu_hotplug();
+
+	/* All good! */
 	return 0;
 }
 
+/* Cleaning up is just the same code, backwards.  With a little French. */
 static void __exit fini(void)
 {
 	lguest_device_remove();
 	free_pagetables();
 	unmap_switcher();
+
+	/* If we had PGE before we started, turn it back on now. */
 	lock_cpu_hotplug();
 	if (cpu_had_pge) {
 		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
+		/* adjust_pge's argument "1" means set PGE. */
 		on_each_cpu(adjust_pge, (void *)1, 0, 1);
 	}
 	unlock_cpu_hotplug();
 }
 
+/* The Host side of lguest can be a module.  This is a nice way for people to
+ * play with it.  */
 module_init(init);
 module_exit(fini);
 MODULE_LICENSE("GPL");
diff -puN drivers/lguest/hypercalls.c~lguest-documentation-v-host drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-documentation-v-host
+++ a/drivers/lguest/hypercalls.c
@@ -28,37 +28,63 @@
 #include <irq_vectors.h>
 #include "lg.h"
 
+/*H:120 This is the core hypercall routine: where the Guest gets what it
+ * wants.  Or gets killed.  Or, in the case of LHCALL_CRASH, both.
+ *
+ * Remember from the Guest: %eax == which call to make, and the arguments are
+ * packed into %edx, %ebx and %ecx if needed. */
 static void do_hcall(struct lguest *lg, struct lguest_regs *regs)
 {
 	switch (regs->eax) {
 	case LHCALL_FLUSH_ASYNC:
+		/* This call does nothing, except by breaking out of the Guest
+		 * it makes us process all the asynchronous hypercalls. */
 		break;
 	case LHCALL_LGUEST_INIT:
+		/* You can't get here unless you're already initialized.  Don't
+		 * do that. */
 		kill_guest(lg, "already have lguest_data");
 		break;
 	case LHCALL_CRASH: {
+		/* Crash is such a trivial hypercall that we do it in four
+		 * lines right here. */
 		char msg[128];
+		/* If the lgread fails, it will call kill_guest() itself; the
+		 * kill_guest() with the message will be ignored. */
 		lgread(lg, msg, regs->edx, sizeof(msg));
 		msg[sizeof(msg)-1] = '\0';
 		kill_guest(lg, "CRASH: %s", msg);
 		break;
 	}
 	case LHCALL_FLUSH_TLB:
+		/* FLUSH_TLB comes in two flavors, depending on the
+		 * argument: */
 		if (regs->edx)
 			guest_pagetable_clear_all(lg);
 		else
 			guest_pagetable_flush_user(lg);
 		break;
 	case LHCALL_GET_WALLCLOCK: {
+		/* The Guest wants to know the real time in seconds since 1970,
+		 * in good Unix tradition. */
 		struct timespec ts;
 		ktime_get_real_ts(&ts);
 		regs->eax = ts.tv_sec;
 		break;
 	}
 	case LHCALL_BIND_DMA:
+		/* BIND_DMA really wants four arguments, but it's the only call
+		 * which does.  So the Guest packs the number of buffers and
+		 * the interrupt number into the final argument, and we decode
+		 * it here.  This can legitimately fail, since we currently
+		 * place a limit on the number of DMA pools a Guest can have.
+		 * So we return true or false from this call. */
 		regs->eax = bind_dma(lg, regs->edx, regs->ebx,
 				     regs->ecx >> 8, regs->ecx & 0xFF);
 		break;
+
+	/* All these calls simply pass the arguments through to the right
+	 * routines. */
 	case LHCALL_SEND_DMA:
 		send_dma(lg, regs->edx, regs->ebx);
 		break;
@@ -86,10 +112,13 @@ static void do_hcall(struct lguest *lg, 
 	case LHCALL_SET_CLOCKEVENT:
 		guest_set_clockevent(lg, regs->edx);
 		break;
+
 	case LHCALL_TS:
+		/* This sets the TS flag, as we saw used in run_guest(). */
 		lg->ts = regs->edx;
 		break;
 	case LHCALL_HALT:
+		/* Similarly, this sets the halted flag for run_guest(). */
 		lg->halted = 1;
 		break;
 	default:
@@ -97,25 +126,42 @@ static void do_hcall(struct lguest *lg, 
 	}
 }
 
-/* We always do queued calls before actual hypercall. */
+/* Asynchronous hypercalls are easy: we just look in the array in the Guest's
+ * "struct lguest_data" and see if there are any new ones marked "ready".
+ *
+ * We are careful to do these in order: obviously we respect the order the
+ * Guest put them in the ring, but we also promise the Guest that they will
+ * happen before any normal hypercall (which is why we check this before
+ * checking for a normal hcall). */
 static void do_async_hcalls(struct lguest *lg)
 {
 	unsigned int i;
 	u8 st[LHCALL_RING_SIZE];
 
+	/* For simplicity, we copy the entire call status array in at once. */
 	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
 		return;
 
+
+	/* We process "struct lguest_data"s hcalls[] ring once. */
 	for (i = 0; i < ARRAY_SIZE(st); i++) {
 		struct lguest_regs regs;
+		/* We remember where we were up to from last time.  This makes
+		 * sure that the hypercalls are done in the order the Guest
+		 * places them in the ring. */
 		unsigned int n = lg->next_hcall;
 
+		/* 0xFF means there's no call here (yet). */
 		if (st[n] == 0xFF)
 			break;
 
+		/* OK, we have hypercall.  Increment the "next_hcall" cursor,
+		 * and wrap back to 0 if we reach the end. */
 		if (++lg->next_hcall == LHCALL_RING_SIZE)
 			lg->next_hcall = 0;
 
+		/* We copy the hypercall arguments into a fake register
+		 * structure.  This makes life simple for do_hcall(). */
 		if (get_user(regs.eax, &lg->lguest_data->hcalls[n].eax)
 		    || get_user(regs.edx, &lg->lguest_data->hcalls[n].edx)
 		    || get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx)
@@ -124,74 +170,126 @@ static void do_async_hcalls(struct lgues
 			break;
 		}
 
+		/* Do the hypercall, same as a normal one. */
 		do_hcall(lg, &regs);
+
+		/* Mark the hypercall done. */
 		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
 			kill_guest(lg, "Writing result for async hypercall");
 			break;
 		}
 
+ 		/* Stop doing hypercalls if we've just done a DMA to the
+		 * Launcher: it needs to service this first. */
 		if (lg->dma_is_pending)
 			break;
 	}
 }
 
+/* Last of all, we look at what happens first of all.  The very first time the
+ * Guest makes a hypercall, we end up here to set things up: */
 static void initialize(struct lguest *lg)
 {
 	u32 tsc_speed;
 
+	/* You can't do anything until you're initialized.  The Guest knows the
+	 * rules, so we're unforgiving here. */
 	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
 		kill_guest(lg, "hypercall %li before LGUEST_INIT",
 			   lg->regs->eax);
 		return;
 	}
 
-	/* We only tell the guest to use the TSC if it's reliable. */
+	/* We insist that the Time Stamp Counter exist and doesn't change with
+	 * cpu frequency.  Some devious chip manufacturers decided that TSC
+	 * changes could be handled in software.  I decided that time going
+	 * backwards might be good for benchmarks, but it's bad for users.
+	 *
+	 * We also insist that the TSC be stable: the kernel detects unreliable
+	 * TSCs for its own purposes, and we use that here. */
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) && !check_tsc_unstable())
 		tsc_speed = tsc_khz;
 	else
 		tsc_speed = 0;
 
+	/* The pointer to the Guest's "struct lguest_data" is the only
+	 * argument. */
 	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
-	/* We check here so we can simply copy_to_user/from_user */
+	/* If we check the address they gave is OK now, we can simply
+	 * copy_to_user/from_user from now on rather than using lgread/lgwrite.
+	 * I put this in to show that I'm not immune to writing stupid
+	 * optimizations. */
 	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 		return;
 	}
+	/* The Guest tells us where we're not to deliver interrupts by putting
+	 * the range of addresses into "struct lguest_data". */
 	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
 	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
-	    /* We reserve the top pgd entry. */
+	    /* We tell the Guest that it can't use the top 4MB of virtual
+	     * addresses used by the Switcher. */
 	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
 	    || put_user(tsc_speed, &lg->lguest_data->tsc_khz)
+	    /* We also give the Guest a unique id, as used in lguest_net.c. */
 	    || put_user(lg->guestid, &lg->lguest_data->guestid))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
-	/* This is the one case where the above accesses might have
-	 * been the first write to a Guest page.  This may have caused
-	 * a copy-on-write fault, but the Guest might be referring to
-	 * the old (read-only) page. */
+	/* This is the one case where the above accesses might have been the
+	 * first write to a Guest page.  This may have caused a copy-on-write
+	 * fault, but the Guest might be referring to the old (read-only)
+	 * page. */
 	guest_pagetable_clear_all(lg);
 }
-
-/* Even if we go out to userspace and come back, we don't want to do
- * the hypercall again. */
+/* Now we've examined the hypercall code; our Guest can make requests.  There
+ * is one other way we can do things for the Guest, as we see in
+ * emulate_insn(). */
+
+/*H:110 Tricky point: we mark the hypercall as "done" once we've done it.
+ * Normally we don't need to do this: the Guest will run again and update the
+ * trap number before we come back around the run_guest() loop to
+ * do_hypercalls().
+ *
+ * However, if we are signalled or the Guest sends DMA to the Launcher, that
+ * loop will exit without running the Guest.  When it comes back it would try
+ * to re-run the hypercall. */
 static void clear_hcall(struct lguest *lg)
 {
 	lg->regs->trapnum = 255;
 }
 
+/*H:100
+ * Hypercalls
+ *
+ * Remember from the Guest, hypercalls come in two flavors: normal and
+ * asynchronous.  This file handles both of types.
+ */
 void do_hypercalls(struct lguest *lg)
 {
+	/* Not initialized yet? */
 	if (unlikely(!lg->lguest_data)) {
+		/* Did the Guest make a hypercall?  We might have come back for
+		 * some other reason (an interrupt, a different trap). */
 		if (lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
+			/* Set up the "struct lguest_data" */
 			initialize(lg);
+			/* The hypercall is done. */
 			clear_hcall(lg);
 		}
 		return;
 	}
 
+	/* The Guest has initialized.
+	 *
+	 * Look in the hypercall ring for the async hypercalls: */
 	do_async_hcalls(lg);
+
+	/* If we stopped reading the hypercall ring because the Guest did a
+	 * SEND_DMA to the Launcher, we want to return now.  Otherwise if the
+	 * Guest asked us to do a hypercall, we do it. */
 	if (!lg->dma_is_pending && lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
 		do_hcall(lg, lg->regs);
+		/* The hypercall is done. */
 		clear_hcall(lg);
 	}
 }
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-documentation-v-host drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-documentation-v-host
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -14,100 +14,147 @@
 #include <linux/uaccess.h>
 #include "lg.h"
 
+/* The address of the interrupt handler is split into two bits: */
 static unsigned long idt_address(u32 lo, u32 hi)
 {
 	return (lo & 0x0000FFFF) | (hi & 0xFFFF0000);
 }
 
+/* The "type" of the interrupt handler is a 4 bit field: we only support a
+ * couple of types. */
 static int idt_type(u32 lo, u32 hi)
 {
 	return (hi >> 8) & 0xF;
 }
 
+/* An IDT entry can't be used unless the "present" bit is set. */
 static int idt_present(u32 lo, u32 hi)
 {
 	return (hi & 0x8000);
 }
 
+/* We need a helper to "push" a value onto the Guest's stack, since that's a
+ * big part of what delivering an interrupt does. */
 static void push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
 {
+	/* Stack grows upwards: move stack then write value. */
 	*gstack -= 4;
 	lgwrite_u32(lg, *gstack, val);
 }
 
+/*H:210 The set_guest_interrupt() routine actually delivers the interrupt or
+ * trap.  The mechanics of delivering traps and interrupts to the Guest are the
+ * same, except some traps have an "error code" which gets pushed onto the
+ * stack as well: the caller tells us if this is one.
+ *
+ * "lo" and "hi" are the two parts of the Interrupt Descriptor Table for this
+ * interrupt or trap.  It's split into two parts for traditional reasons: gcc
+ * on i386 used to be frightened by 64 bit numbers.
+ *
+ * We set up the stack just like the CPU does for a real interrupt, so it's
+ * identical for the Guest (and the standard "iret" instruction will undo
+ * it). */
 static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
 {
 	unsigned long gstack;
 	u32 eflags, ss, irq_enable;
 
-	/* If they want a ring change, we use new stack and push old ss/esp */
+	/* There are two cases for interrupts: one where the Guest is already
+	 * in the kernel, and a more complex one where the Guest is in
+	 * userspace.  We check the privilege level to find out. */
 	if ((lg->regs->ss&0x3) != GUEST_PL) {
+		/* The Guest told us their kernel stack with the SET_STACK
+		 * hypercall: both the virtual address and the segment */
 		gstack = guest_pa(lg, lg->esp1);
 		ss = lg->ss1;
+		/* We push the old stack segment and pointer onto the new
+		 * stack: when the Guest does an "iret" back from the interrupt
+		 * handler the CPU will notice they're dropping privilege
+		 * levels and expect these here. */
 		push_guest_stack(lg, &gstack, lg->regs->ss);
 		push_guest_stack(lg, &gstack, lg->regs->esp);
 	} else {
+		/* We're staying on the same Guest (kernel) stack. */
 		gstack = guest_pa(lg, lg->regs->esp);
 		ss = lg->regs->ss;
 	}
 
-	/* We use IF bit in eflags to indicate whether irqs were enabled
-	   (it's always 1, since irqs are enabled when guest is running). */
+	/* Remember that we never let the Guest actually disable interrupts, so
+	 * the "Interrupt Flag" bit is always set.  We copy that bit from the
+	 * Guest's "irq_enabled" field into the eflags word: the Guest copies
+	 * it back in "lguest_iret". */
 	eflags = lg->regs->eflags;
 	if (get_user(irq_enable, &lg->lguest_data->irq_enabled) == 0
 	    && !(irq_enable & X86_EFLAGS_IF))
 		eflags &= ~X86_EFLAGS_IF;
 
+	/* An interrupt is expected to push three things on the stack: the old
+	 * "eflags" word, the old code segment, and the old instruction
+	 * pointer. */
 	push_guest_stack(lg, &gstack, eflags);
 	push_guest_stack(lg, &gstack, lg->regs->cs);
 	push_guest_stack(lg, &gstack, lg->regs->eip);
 
+	/* For the six traps which supply an error code, we push that, too. */
 	if (has_err)
 		push_guest_stack(lg, &gstack, lg->regs->errcode);
 
-	/* Change the real stack so switcher returns to trap handler */
+	/* Now we've pushed all the old state, we change the stack, the code
+	 * segment and the address to execute. */
 	lg->regs->ss = ss;
 	lg->regs->esp = gstack + lg->page_offset;
 	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
 	lg->regs->eip = idt_address(lo, hi);
 
-	/* Disable interrupts for an interrupt gate. */
+	/* There are two kinds of interrupt handlers: 0xE is an "interrupt
+	 * gate" which expects interrupts to be disabled on entry. */
 	if (idt_type(lo, hi) == 0xE)
 		if (put_user(0, &lg->lguest_data->irq_enabled))
 			kill_guest(lg, "Disabling interrupts");
 }
 
+/*H:200
+ * Virtual Interrupts.
+ *
+ * maybe_do_interrupt() gets called before every entry to the Guest, to see if
+ * we should divert the Guest to running an interrupt handler. */
 void maybe_do_interrupt(struct lguest *lg)
 {
 	unsigned int irq;
 	DECLARE_BITMAP(blk, LGUEST_IRQS);
 	struct desc_struct *idt;
 
+	/* If the Guest hasn't even initialized yet, we can do nothing. */
 	if (!lg->lguest_data)
 		return;
 
-	/* Mask out any interrupts they have blocked. */
+	/* Take our "irqs_pending" array and remove any interrupts the Guest
+	 * wants blocked: the result ends up in "blk". */
 	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
 			   sizeof(blk)))
 		return;
 
 	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
 
+	/* Find the first interrupt. */
 	irq = find_first_bit(blk, LGUEST_IRQS);
+	/* None?  Nothing to do */
 	if (irq >= LGUEST_IRQS)
 		return;
 
+	/* They may be in the middle of an iret, where they asked us never to
+	 * deliver interrupts. */
 	if (lg->regs->eip >= lg->noirq_start && lg->regs->eip < lg->noirq_end)
 		return;
 
-	/* If they're halted, we re-enable interrupts. */
+	/* If they're halted, interrupts restart them. */
 	if (lg->halted) {
 		/* Re-enable interrupts. */
 		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
 			kill_guest(lg, "Re-enabling interrupts");
 		lg->halted = 0;
 	} else {
-		/* Maybe they have interrupts disabled? */
+		/* Otherwise we check if they have interrupts disabled. */
 		u32 irq_enabled;
 		if (get_user(irq_enabled, &lg->lguest_data->irq_enabled))
 			irq_enabled = 0;
@@ -115,112 +162,197 @@ void maybe_do_interrupt(struct lguest *l
 			return;
 	}
 
+	/* Look at the IDT entry the Guest gave us for this interrupt.  The
+	 * first 32 (FIRST_EXTERNAL_VECTOR) entries are for traps, so we skip
+	 * over them. */
 	idt = &lg->idt[FIRST_EXTERNAL_VECTOR+irq];
+	/* If they don't have a handler (yet?), we just ignore it */
 	if (idt_present(idt->a, idt->b)) {
+		/* OK, mark it no longer pending and deliver it. */
 		clear_bit(irq, lg->irqs_pending);
+		/* set_guest_interrupt() takes the interrupt descriptor and a
+		 * flag to say whether this interrupt pushes an error code onto
+		 * the stack as well: virtual interrupts never do. */
 		set_guest_interrupt(lg, idt->a, idt->b, 0);
 	}
 }
 
+/*H:220 Now we've got the routines to deliver interrupts, delivering traps
+ * like page fault is easy.  The only trick is that Intel decided that some
+ * traps should have error codes: */
 static int has_err(unsigned int trap)
 {
 	return (trap == 8 || (trap >= 10 && trap <= 14) || trap == 17);
 }
 
+/* deliver_trap() returns true if it could deliver the trap. */
 int deliver_trap(struct lguest *lg, unsigned int num)
 {
 	u32 lo = lg->idt[num].a, hi = lg->idt[num].b;
 
+	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
+	 * bogus one in): if we fail here, the Guest will be killed. */
 	if (!idt_present(lo, hi))
 		return 0;
 	set_guest_interrupt(lg, lo, hi, has_err(num));
 	return 1;
 }
 
+/*H:250 Here's the hard part: returning to the Host every time a trap happens
+ * and then calling deliver_trap() and re-entering the Guest is slow.
+ * Particularly because Guest userspace system calls are traps (trap 128).
+ *
+ * So we'd like to set up the IDT to tell the CPU to deliver traps directly
+ * into the Guest.  This is possible, but the complexities cause the size of
+ * this file to double!  However, 150 lines of code is worth writing for taking
+ * system calls down from 1750ns to 270ns.  Plus, if lguest didn't do it, all
+ * the other hypervisors would tease it.
+ *
+ * This routine determines if a trap can be delivered directly. */
 static int direct_trap(const struct lguest *lg,
 		       const struct desc_struct *trap,
 		       unsigned int num)
 {
-	/* Hardware interrupts don't go to guest (except syscall). */
+	/* Hardware interrupts don't go to the Guest at all (except system
+	 * call). */
 	if (num >= FIRST_EXTERNAL_VECTOR && num != SYSCALL_VECTOR)
 		return 0;
 
-	/* We intercept page fault (demand shadow paging & cr2 saving)
-	   protection fault (in/out emulation) and device not
-	   available (TS handling), and hypercall */
+	/* The Host needs to see page faults (for shadow paging and to save the
+	 * fault address), general protection faults (in/out emulation) and
+	 * device not available (TS handling), and of course, the hypercall
+	 * trap. */
 	if (num == 14 || num == 13 || num == 7 || num == LGUEST_TRAP_ENTRY)
 		return 0;
 
-	/* Interrupt gates (0xE) or not present (0x0) can't go direct. */
+	/* Only trap gates (type 15) can go direct to the Guest.  Interrupt
+	 * gates (type 14) disable interrupts as they are entered, which we
+	 * never let the Guest do.  Not present entries (type 0x0) also can't
+	 * go direct, of course 8) */
 	return idt_type(trap->a, trap->b) == 0xF;
 }
 
+/*H:260 When we make traps go directly into the Guest, we need to make sure
+ * the kernel stack is valid (ie. mapped in the page tables).  Otherwise, the
+ * CPU trying to deliver the trap will fault while trying to push the interrupt
+ * words on the stack: this is called a double fault, and it forces us to kill
+ * the Guest.
+ *
+ * Which is deeply unfair, because (literally!) it wasn't the Guests' fault. */
 void pin_stack_pages(struct lguest *lg)
 {
 	unsigned int i;
 
+	/* Depending on the CONFIG_4KSTACKS option, the Guest can have one or
+	 * two pages of stack space. */
 	for (i = 0; i < lg->stack_pages; i++)
+		/* The stack grows *upwards*, hence the subtraction */
 		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
 }
 
+/* Direct traps also mean that we need to know whenever the Guest wants to use
+ * a different kernel stack, so we can change the IDT entries to use that
+ * stack.  The IDT entries expect a virtual address, so unlike most addresses
+ * the Guest gives us, the "esp" (stack pointer) value here is virtual, not
+ * physical.
+ *
+ * In Linux each process has its own kernel stack, so this happens a lot: we
+ * change stacks on each context switch. */
 void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages)
 {
-	/* You cannot have a stack segment with priv level 0. */
+	/* You are not allowd have a stack segment with privilege level 0: bad
+	 * Guest! */
 	if ((seg & 0x3) != GUEST_PL)
 		kill_guest(lg, "bad stack segment %i", seg);
+	/* We only expect one or two stack pages. */
 	if (pages > 2)
 		kill_guest(lg, "bad stack pages %u", pages);
+	/* Save where the stack is, and how many pages */
 	lg->ss1 = seg;
 	lg->esp1 = esp;
 	lg->stack_pages = pages;
+	/* Make sure the new stack pages are mapped */
 	pin_stack_pages(lg);
 }
 
-/* Set up trap in IDT. */
+/* All this reference to mapping stacks leads us neatly into the other complex
+ * part of the Host: page table handling. */
+
+/*H:235 This is the routine which actually checks the Guest's IDT entry and
+ * transfers it into our entry in "struct lguest": */
 static void set_trap(struct lguest *lg, struct desc_struct *trap,
 		     unsigned int num, u32 lo, u32 hi)
 {
 	u8 type = idt_type(lo, hi);
 
+	/* We zero-out a not-present entry */
 	if (!idt_present(lo, hi)) {
 		trap->a = trap->b = 0;
 		return;
 	}
 
+	/* We only support interrupt and trap gates. */
 	if (type != 0xE && type != 0xF)
 		kill_guest(lg, "bad IDT type %i", type);
 
+	/* We only copy the handler address, present bit, privilege level and
+	 * type.  The privilege level controls where the trap can be triggered
+	 * manually with an "int" instruction.  This is usually GUEST_PL,
+	 * except for system calls which userspace can use. */
 	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
 	trap->b = (hi&0xFFFFEF00);
 }
 
+/*H:230 While we're here, dealing with delivering traps and interrupts to the
+ * Guest, we might as well complete the picture: how the Guest tells us where
+ * it wants them to go.  This would be simple, except making traps fast
+ * requires some tricks.
+ *
+ * We saw the Guest setting Interrupt Descriptor Table (IDT) entries with the
+ * LHCALL_LOAD_IDT_ENTRY hypercall before: that comes here. */
 void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
 {
-	/* Guest never handles: NMI, doublefault, hypercall, spurious irq. */
+	/* Guest never handles: NMI, doublefault, spurious interrupt or
+	 * hypercall.  We ignore when it tries to set them. */
 	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
 		return;
 
+	/* Mark the IDT as changed: next time the Guest runs we'll know we have
+	 * to copy this again. */
 	lg->changed |= CHANGED_IDT;
+
+	/* The IDT which we keep in "struct lguest" only contains 32 entries
+	 * for the traps and LGUEST_IRQS (32) entries for interrupts.  We
+	 * ignore attempts to set handlers for higher interrupt numbers, except
+	 * for the system call "interrupt" at 128: we have a special IDT entry
+	 * for that. */
 	if (num < ARRAY_SIZE(lg->idt))
 		set_trap(lg, &lg->idt[num], num, lo, hi);
 	else if (num == SYSCALL_VECTOR)
 		set_trap(lg, &lg->syscall_idt, num, lo, hi);
 }
 
+/* The default entry for each interrupt points into the Switcher routines which
+ * simply return to the Host.  The run_guest() loop will then call
+ * deliver_trap() to bounce it back into the Guest. */
 static void default_idt_entry(struct desc_struct *idt,
 			      int trap,
 			      const unsigned long handler)
 {
+	/* A present interrupt gate. */
 	u32 flags = 0x8e00;
 
-	/* They can't "int" into any of them except hypercall. */
+	/* Set the privilege level on the entry for the hypercall: this allows
+	 * the Guest to use the "int" instruction to trigger it. */
 	if (trap == LGUEST_TRAP_ENTRY)
 		flags |= (GUEST_PL << 13);
 
+	/* Now pack it into the IDT entry in its weird format. */
 	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
 	idt->b = (handler&0xFFFF0000) | flags;
 }
 
+/* When the Guest first starts, we put default entries into the IDT. */
 void setup_default_idt_entries(struct lguest_ro_state *state,
 			       const unsigned long *def)
 {
@@ -230,19 +362,25 @@ void setup_default_idt_entries(struct lg
 		default_idt_entry(&state->guest_idt[i], i, def[i]);
 }
 
+/*H:240 We don't use the IDT entries in the "struct lguest" directly, instead
+ * we copy them into the IDT which we've set up for Guests on this CPU, just
+ * before we run the Guest.  This routine does that copy. */
 void copy_traps(const struct lguest *lg, struct desc_struct *idt,
 		const unsigned long *def)
 {
 	unsigned int i;
 
-	/* All hardware interrupts are same whatever the guest: only the
-	 * traps might be different. */
+	/* We can simply copy the direct traps, otherwise we use the default
+	 * ones in the Switcher: they will return to the Host. */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
 		if (direct_trap(lg, &lg->idt[i], i))
 			idt[i] = lg->idt[i];
 		else
 			default_idt_entry(&idt[i], i, def[i]);
 	}
+
+	/* Don't forget the system call trap!  The IDT entries for other
+	 * interupts never change, so no need to copy them. */
 	i = SYSCALL_VECTOR;
 	if (direct_trap(lg, &lg->syscall_idt, i))
 		idt[i] = lg->syscall_idt;
diff -puN drivers/lguest/lg.h~lguest-documentation-v-host drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-documentation-v-host
+++ a/drivers/lguest/lg.h
@@ -58,9 +58,18 @@ struct lguest_dma_info
 	u8 interrupt; 	/* 0 when not registered */
 };
 
-/* We have separate types for the guest's ptes & pgds and the shadow ptes &
- * pgds.  Since this host might use three-level pagetables and the guest and
- * shadow pagetables don't, we can't use the normal pte_t/pgd_t. */
+/*H:310 The page-table code owes a great debt of gratitude to Andi Kleen.  He
+ * reviewed the original code which used "u32" for all page table entries, and
+ * insisted that it would be far clearer with explicit typing.  I thought it
+ * was overkill, but he was right: it is much clearer than it was before.
+ *
+ * We have separate types for the Guest's ptes & pgds and the shadow ptes &
+ * pgds.  There's already a Linux type for these (pte_t and pgd_t) but they
+ * change depending on kernel config options (PAE). */
+
+/* Each entry is identical: lower 12 bits of flags and upper 20 bits for the
+ * "page frame number" (0 == first physical page, etc).  They are different
+ * types so the compiler will warn us if we mix them improperly. */
 typedef union {
 	struct { unsigned flags:12, pfn:20; };
 	struct { unsigned long val; } raw;
@@ -77,8 +86,12 @@ typedef union {
 	struct { unsigned flags:12, pfn:20; };
 	struct { unsigned long val; } raw;
 } gpte_t;
+
+/* We have two convenient macros to convert a "raw" value as handed to us by
+ * the Guest into the correct Guest PGD or PTE type. */
 #define mkgpte(_val) ((gpte_t){.raw.val = _val})
 #define mkgpgd(_val) ((gpgd_t){.raw.val = _val})
+/*:*/
 
 struct pgdir
 {
diff -puN drivers/lguest/page_tables.c~lguest-documentation-v-host drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-documentation-v-host
+++ a/drivers/lguest/page_tables.c
@@ -15,38 +15,91 @@
 #include <asm/tlbflush.h>
 #include "lg.h"
 
+/*H:300
+ * The Page Table Code
+ *
+ * We use two-level page tables for the Guest.  If you're not entirely
+ * comfortable with virtual addresses, physical addresses and page tables then
+ * I recommend you review lguest.c's "Page Table Handling" (with diagrams!).
+ *
+ * The Guest keeps page tables, but we maintain the actual ones here: these are
+ * called "shadow" page tables.  Which is a very Guest-centric name: these are
+ * the real page tables the CPU uses, although we keep them up to date to
+ * reflect the Guest's.  (See what I mean about weird naming?  Since when do
+ * shadows reflect anything?)
+ *
+ * Anyway, this is the most complicated part of the Host code.  There are seven
+ * parts to this:
+ *  (i) Setting up a page table entry for the Guest when it faults,
+ *  (ii) Setting up the page table entry for the Guest stack,
+ *  (iii) Setting up a page table entry when the Guest tells us it has changed,
+ *  (iv) Switching page tables,
+ *  (v) Flushing (thowing away) page tables,
+ *  (vi) Mapping the Switcher when the Guest is about to run,
+ *  (vii) Setting up the page tables initially.
+ :*/
+
+/* Pages a 4k long, and each page table entry is 4 bytes long, giving us 1024
+ * (or 2^10) entries per page. */
 #define PTES_PER_PAGE_SHIFT 10
 #define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
+
+/* 1024 entries in a page table page maps 1024 pages: 4MB.  The Switcher is
+ * conveniently placed at the top 4MB, so it uses a separate, complete PTE
+ * page.  */
 #define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
 
+/* We actually need a separate PTE page for each CPU.  Remember that after the
+ * Switcher code itself comes two pages for each CPU, and we don't want this
+ * CPU's guest to see the pages of any other CPU. */
 static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
 #define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
 
+/*H:320 With our shadow and Guest types established, we need to deal with
+ * them: the page table code is curly enough to need helper functions to keep
+ * it clear and clean.
+ *
+ * The first helper takes a virtual address, and says which entry in the top
+ * level page table deals with that address.  Since each top level entry deals
+ * with 4M, this effectively divides by 4M. */
 static unsigned vaddr_to_pgd_index(unsigned long vaddr)
 {
 	return vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
 }
 
-/* These access the shadow versions (ie. the ones used by the CPU). */
+/* There are two functions which return pointers to the shadow (aka "real")
+ * page tables.
+ *
+ * spgd_addr() takes the virtual address and returns a pointer to the top-level
+ * page directory entry for that address.  Since we keep track of several page
+ * tables, the "i" argument tells us which one we're interested in (it's
+ * usually the current one). */
 static spgd_t *spgd_addr(struct lguest *lg, u32 i, unsigned long vaddr)
 {
 	unsigned int index = vaddr_to_pgd_index(vaddr);
 
+	/* We kill any Guest trying to touch the Switcher addresses. */
 	if (index >= SWITCHER_PGD_INDEX) {
 		kill_guest(lg, "attempt to access switcher pages");
 		index = 0;
 	}
+	/* Return a pointer index'th pgd entry for the i'th page table. */
 	return &lg->pgdirs[i].pgdir[index];
 }
 
+/* This routine then takes the PGD entry given above, which contains the
+ * address of the PTE page.  It then returns a pointer to the PTE entry for the
+ * given address. */
 static spte_t *spte_addr(struct lguest *lg, spgd_t spgd, unsigned long vaddr)
 {
 	spte_t *page = __va(spgd.pfn << PAGE_SHIFT);
+	/* You should never call this if the PGD entry wasn't valid */
 	BUG_ON(!(spgd.flags & _PAGE_PRESENT));
 	return &page[(vaddr >> PAGE_SHIFT) % PTES_PER_PAGE];
 }
 
-/* These access the guest versions. */
+/* These two functions just like the above two, except they access the Guest
+ * page tables.  Hence they return a Guest address. */
 static unsigned long gpgd_addr(struct lguest *lg, unsigned long vaddr)
 {
 	unsigned int index = vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
@@ -61,12 +114,24 @@ static unsigned long gpte_addr(struct lg
 	return gpage + ((vaddr>>PAGE_SHIFT) % PTES_PER_PAGE) * sizeof(gpte_t);
 }
 
-/* Do a virtual -> physical mapping on a user page. */
+/*H:350 This routine takes a page number given by the Guest and converts it to
+ * an actual, physical page number.  It can fail for several reasons: the
+ * virtual address might not be mapped by the Launcher, the write flag is set
+ * and the page is read-only, or the write flag was set and the page was
+ * shared so had to be copied, but we ran out of memory.
+ *
+ * This holds a reference to the page, so release_pte() is careful to
+ * put that back. */
 static unsigned long get_pfn(unsigned long virtpfn, int write)
 {
 	struct page *page;
+	/* This value indicates failure. */
 	unsigned long ret = -1UL;
 
+	/* get_user_pages() is a complex interface: it gets the "struct
+	 * vm_area_struct" and "struct page" assocated with a range of pages.
+	 * It also needs the task's mmap_sem held, and is not very quick.
+	 * It returns the number of pages it got. */
 	down_read(&current->mm->mmap_sem);
 	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
 			   1, write, 1, &page, NULL) == 1)
@@ -75,28 +140,47 @@ static unsigned long get_pfn(unsigned lo
 	return ret;
 }
 
+/*H:340 Converting a Guest page table entry to a shadow (ie. real) page table
+ * entry can be a little tricky.  The flags are (almost) the same, but the
+ * Guest PTE contains a virtual page number: the CPU needs the real page
+ * number. */
 static spte_t gpte_to_spte(struct lguest *lg, gpte_t gpte, int write)
 {
 	spte_t spte;
 	unsigned long pfn;
 
-	/* We ignore the global flag. */
+	/* The Guest sets the global flag, because it thinks that it is using
+	 * PGE.  We only told it to use PGE so it would tell us whether it was
+	 * flushing a kernel mapping or a userspace mapping.  We don't actually
+	 * use the global bit, so throw it away. */
 	spte.flags = (gpte.flags & ~_PAGE_GLOBAL);
+
+	/* We need a temporary "unsigned long" variable to hold the answer from
+	 * get_pfn(), because it returns 0xFFFFFFFF on failure, which wouldn't
+	 * fit in spte.pfn.  get_pfn() finds the real physical number of the
+	 * page, given the virtual number. */
 	pfn = get_pfn(gpte.pfn, write);
 	if (pfn == -1UL) {
 		kill_guest(lg, "failed to get page %u", gpte.pfn);
-		/* Must not put_page() bogus page on cleanup. */
+		/* When we destroy the Guest, we'll go through the shadow page
+		 * tables and release_pte() them.  Make sure we don't think
+		 * this one is valid! */
 		spte.flags = 0;
 	}
+	/* Now we assign the page number, and our shadow PTE is complete. */
 	spte.pfn = pfn;
 	return spte;
 }
 
+/*H:460 And to complete the chain, release_pte() looks like this: */
 static void release_pte(spte_t pte)
 {
+	/* Remember that get_user_pages() took a reference to the page, in
+	 * get_pfn()?  We have to put it back now. */
 	if (pte.flags & _PAGE_PRESENT)
 		put_page(pfn_to_page(pte.pfn));
 }
+/*:*/
 
 static void check_gpte(struct lguest *lg, gpte_t gpte)
 {
@@ -110,11 +194,16 @@ static void check_gpgd(struct lguest *lg
 		kill_guest(lg, "bad page directory entry");
 }
 
-/* FIXME: We hold reference to pages, which prevents them from being
-   swapped.  It'd be nice to have a callback when Linux wants to swap out. */
-
-/* We fault pages in, which allows us to update accessed/dirty bits.
- * Return true if we got page. */
+/*H:330
+ * (i) Setting up a page table entry for the Guest when it faults
+ *
+ * We saw this call in run_guest(): when we see a page fault in the Guest, we
+ * come here.  That's because we only set up the shadow page tables lazily as
+ * they're needed, so we get page faults all the time and quietly fix them up
+ * and return to the Guest without it knowing.
+ *
+ * If we fixed up the fault (ie. we mapped the address), this routine returns
+ * true. */
 int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
 {
 	gpgd_t gpgd;
@@ -123,106 +212,161 @@ int demand_page(struct lguest *lg, unsig
 	gpte_t gpte;
 	spte_t *spte;
 
+	/* First step: get the top-level Guest page table entry. */
 	gpgd = mkgpgd(lgread_u32(lg, gpgd_addr(lg, vaddr)));
+	/* Toplevel not present?  We can't map it in. */
 	if (!(gpgd.flags & _PAGE_PRESENT))
 		return 0;
 
+	/* Now look at the matching shadow entry. */
 	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
 	if (!(spgd->flags & _PAGE_PRESENT)) {
-		/* Get a page of PTEs for them. */
+		/* No shadow entry: allocate a new shadow PTE page. */
 		unsigned long ptepage = get_zeroed_page(GFP_KERNEL);
-		/* FIXME: Steal from self in this case? */
+		/* This is not really the Guest's fault, but killing it is
+		 * simple for this corner case. */
 		if (!ptepage) {
 			kill_guest(lg, "out of memory allocating pte page");
 			return 0;
 		}
+		/* We check that the Guest pgd is OK. */
 		check_gpgd(lg, gpgd);
+		/* And we copy the flags to the shadow PGD entry.  The page
+		 * number in the shadow PGD is the page we just allocated. */
 		spgd->raw.val = (__pa(ptepage) | gpgd.flags);
 	}
 
+	/* OK, now we look at the lower level in the Guest page table: keep its
+	 * address, because we might update it later. */
 	gpte_ptr = gpte_addr(lg, gpgd, vaddr);
 	gpte = mkgpte(lgread_u32(lg, gpte_ptr));
 
-	/* No page? */
+	/* If this page isn't in the Guest page tables, we can't page it in. */
 	if (!(gpte.flags & _PAGE_PRESENT))
 		return 0;
 
-	/* Write to read-only page? */
+	/* Check they're not trying to write to a page the Guest wants
+	 * read-only (bit 2 of errcode == write). */
 	if ((errcode & 2) && !(gpte.flags & _PAGE_RW))
 		return 0;
 
-	/* User access to a non-user page? */
+	/* User access to a kernel page? (bit 3 == user access) */
 	if ((errcode & 4) && !(gpte.flags & _PAGE_USER))
 		return 0;
 
+	/* Check that the Guest PTE flags are OK, and the page number is below
+	 * the pfn_limit (ie. not mapping the Launcher binary). */
 	check_gpte(lg, gpte);
+	/* Add the _PAGE_ACCESSED and (for a write) _PAGE_DIRTY flag */
 	gpte.flags |= _PAGE_ACCESSED;
 	if (errcode & 2)
 		gpte.flags |= _PAGE_DIRTY;
 
-	/* We're done with the old pte. */
+	/* Get the pointer to the shadow PTE entry we're going to set. */
 	spte = spte_addr(lg, *spgd, vaddr);
+	/* If there was a valid shadow PTE entry here before, we release it.
+	 * This can happen with a write to a previously read-only entry. */
 	release_pte(*spte);
 
-	/* We don't make it writable if this isn't a write: later
-	 * write will fault so we can set dirty bit in guest. */
+	/* If this is a write, we insist that the Guest page is writable (the
+	 * final arg to gpte_to_spte()). */
 	if (gpte.flags & _PAGE_DIRTY)
 		*spte = gpte_to_spte(lg, gpte, 1);
 	else {
+		/* If this is a read, don't set the "writable" bit in the page
+		 * table entry, even if the Guest says it's writable.  That way
+		 * we come back here when a write does actually ocur, so we can
+		 * update the Guest's _PAGE_DIRTY flag. */
 		gpte_t ro_gpte = gpte;
 		ro_gpte.flags &= ~_PAGE_RW;
 		*spte = gpte_to_spte(lg, ro_gpte, 0);
 	}
 
-	/* Now we update dirty/accessed on guest. */
+	/* Finally, we write the Guest PTE entry back: we've set the
+	 * _PAGE_ACCESSED and maybe the _PAGE_DIRTY flags. */
 	lgwrite_u32(lg, gpte_ptr, gpte.raw.val);
+
+	/* We succeeded in mapping the page! */
 	return 1;
 }
 
-/* This is much faster than the full demand_page logic. */
+/*H:360 (ii) Setting up the page table entry for the Guest stack.
+ *
+ * Remember pin_stack_pages() which makes sure the stack is mapped?  It could
+ * simply call demand_page(), but as we've seen that logic is quite long, and
+ * usually the stack pages are already mapped anyway, so it's not required.
+ *
+ * This is a quick version which answers the question: is this virtual address
+ * mapped by the shadow page tables, and is it writable? */
 static int page_writable(struct lguest *lg, unsigned long vaddr)
 {
 	spgd_t *spgd;
 	unsigned long flags;
 
+	/* Look at the top level entry: is it present? */
 	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
 	if (!(spgd->flags & _PAGE_PRESENT))
 		return 0;
 
+	/* Check the flags on the pte entry itself: it must be present and
+	 * writable. */
 	flags = spte_addr(lg, *spgd, vaddr)->flags;
 	return (flags & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
 }
 
+/* So, when pin_stack_pages() asks us to pin a page, we check if it's already
+ * in the page tables, and if not, we call demand_page() with error code 2
+ * (meaning "write"). */
 void pin_page(struct lguest *lg, unsigned long vaddr)
 {
 	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
 		kill_guest(lg, "bad stack page %#lx", vaddr);
 }
 
+/*H:450 If we chase down the release_pgd() code, it looks like this: */
 static void release_pgd(struct lguest *lg, spgd_t *spgd)
 {
+	/* If the entry's not present, there's nothing to release. */
 	if (spgd->flags & _PAGE_PRESENT) {
 		unsigned int i;
+		/* Converting the pfn to find the actual PTE page is easy: turn
+		 * the page number into a physical address, then convert to a
+		 * virtual address (easy for kernel pages like this one). */
 		spte_t *ptepage = __va(spgd->pfn << PAGE_SHIFT);
+		/* For each entry in the page, we might need to release it. */
 		for (i = 0; i < PTES_PER_PAGE; i++)
 			release_pte(ptepage[i]);
+		/* Now we can free the page of PTEs */
 		free_page((long)ptepage);
+		/* And zero out the PGD entry we we never release it twice. */
 		spgd->raw.val = 0;
 	}
 }
 
+/*H:440 (v) Flushing (thowing away) page tables,
+ *
+ * We saw flush_user_mappings() called when we re-used a top-level pgdir page.
+ * It simply releases every PTE page from 0 up to the kernel address. */
 static void flush_user_mappings(struct lguest *lg, int idx)
 {
 	unsigned int i;
+	/* Release every pgd entry up to the kernel's address. */
 	for (i = 0; i < vaddr_to_pgd_index(lg->page_offset); i++)
 		release_pgd(lg, lg->pgdirs[idx].pgdir + i);
 }
 
+/* The Guest also has a hypercall to do this manually: it's used when a large
+ * number of mappings have been changed. */
 void guest_pagetable_flush_user(struct lguest *lg)
 {
+	/* Drop the userspace part of the current page table. */
 	flush_user_mappings(lg, lg->pgdidx);
 }
+/*:*/
 
+/* We keep several page tables.  This is a simple routine to find the page
+ * table (if any) corresponding to this top-level address the Guest has given
+ * us. */
 static unsigned int find_pgdir(struct lguest *lg, unsigned long pgtable)
 {
 	unsigned int i;
@@ -232,21 +376,30 @@ static unsigned int find_pgdir(struct lg
 	return i;
 }
 
+/*H:435 And this is us, creating the new page directory.  If we really do
+ * allocate a new one (and so the kernel parts are not there), we set
+ * blank_pgdir. */
 static unsigned int new_pgdir(struct lguest *lg,
 			      unsigned long cr3,
 			      int *blank_pgdir)
 {
 	unsigned int next;
 
+	/* We pick one entry at random to throw out.  Choosing the Least
+	 * Recently Used might be better, but this is easy. */
 	next = random32() % ARRAY_SIZE(lg->pgdirs);
+	/* If it's never been allocated at all before, try now. */
 	if (!lg->pgdirs[next].pgdir) {
 		lg->pgdirs[next].pgdir = (spgd_t *)get_zeroed_page(GFP_KERNEL);
+		/* If the allocation fails, just keep using the one we have */
 		if (!lg->pgdirs[next].pgdir)
 			next = lg->pgdidx;
 		else
-			/* There are no mappings: you'll need to re-pin */
+			/* This is a blank page, so there are no kernel
+			 * mappings: caller must map the stack! */
 			*blank_pgdir = 1;
 	}
+	/* Record which Guest toplevel this shadows. */
 	lg->pgdirs[next].cr3 = cr3;
 	/* Release all the non-kernel mappings. */
 	flush_user_mappings(lg, next);
@@ -254,82 +407,161 @@ static unsigned int new_pgdir(struct lgu
 	return next;
 }
 
+/*H:430 (iv) Switching page tables
+ *
+ * This is what happens when the Guest changes page tables (ie. changes the
+ * top-level pgdir).  This happens on almost every context switch. */
 void guest_new_pagetable(struct lguest *lg, unsigned long pgtable)
 {
 	int newpgdir, repin = 0;
 
+	/* Look to see if we have this one already. */
 	newpgdir = find_pgdir(lg, pgtable);
+	/* If not, we allocate or mug an existing one: if it's a fresh one,
+	 * repin gets set to 1. */
 	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
 		newpgdir = new_pgdir(lg, pgtable, &repin);
+	/* Change the current pgd index to the new one. */
 	lg->pgdidx = newpgdir;
+	/* If it was completely blank, we map in the Guest kernel stack */
 	if (repin)
 		pin_stack_pages(lg);
 }
 
+/*H:470 Finally, a routine which throws away everything: all PGD entries in all
+ * the shadow page tables.  This is used when we destroy the Guest. */
 static void release_all_pagetables(struct lguest *lg)
 {
 	unsigned int i, j;
 
+	/* Every shadow pagetable this Guest has */
 	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
 		if (lg->pgdirs[i].pgdir)
+			/* Every PGD entry except the Switcher at the top */
 			for (j = 0; j < SWITCHER_PGD_INDEX; j++)
 				release_pgd(lg, lg->pgdirs[i].pgdir + j);
 }
 
+/* We also throw away everything when a Guest tells us it's changed a kernel
+ * mapping.  Since kernel mappings are in every page table, it's easiest to
+ * throw them all away.  This is amazingly slow, but thankfully rare. */
 void guest_pagetable_clear_all(struct lguest *lg)
 {
 	release_all_pagetables(lg);
+	/* We need the Guest kernel stack mapped again. */
 	pin_stack_pages(lg);
 }
 
+/*H:420 This is the routine which actually sets the page table entry for then
+ * "idx"'th shadow page table.
+ *
+ * Normally, we can just throw out the old entry and replace it with 0: if they
+ * use it demand_page() will put the new entry in.  We need to do this anyway:
+ * The Guest expects _PAGE_ACCESSED to be set on its PTE the first time a page
+ * is read from, and _PAGE_DIRTY when it's written to.
+ *
+ * But Avi Kivity pointed out that most Operating Systems (Linux included) set
+ * these bits on PTEs immediately anyway.  This is done to save the CPU from
+ * having to update them, but it helps us the same way: if they set
+ * _PAGE_ACCESSED then we can put a read-only PTE entry in immediately, and if
+ * they set _PAGE_DIRTY then we can put a writable PTE entry in immediately.
+ */
 static void do_set_pte(struct lguest *lg, int idx,
 		       unsigned long vaddr, gpte_t gpte)
 {
+	/* Look up the matching shadow page directot entry. */
 	spgd_t *spgd = spgd_addr(lg, idx, vaddr);
+
+	/* If the top level isn't present, there's no entry to update. */
 	if (spgd->flags & _PAGE_PRESENT) {
+		/* Otherwise, we start by releasing the existing entry. */
 		spte_t *spte = spte_addr(lg, *spgd, vaddr);
 		release_pte(*spte);
+
+		/* If they're setting this entry as dirty or accessed, we might
+		 * as well put that entry they've given us in now.  This shaves
+		 * 10% off a copy-on-write micro-benchmark. */
 		if (gpte.flags & (_PAGE_DIRTY | _PAGE_ACCESSED)) {
 			check_gpte(lg, gpte);
 			*spte = gpte_to_spte(lg, gpte, gpte.flags&_PAGE_DIRTY);
 		} else
+			/* Otherwise we can demand_page() it in later. */
 			spte->raw.val = 0;
 	}
 }
 
+/*H:410 Updating a PTE entry is a little trickier.
+ *
+ * We keep track of several different page tables (the Guest uses one for each
+ * process, so it makes sense to cache at least a few).  Each of these have
+ * identical kernel parts: ie. every mapping above PAGE_OFFSET is the same for
+ * all processes.  So when the page table above that address changes, we update
+ * all the page tables, not just the current one.  This is rare.
+ *
+ * The benefit is that when we have to track a new page table, we can copy keep
+ * all the kernel mappings.  This speeds up context switch immensely. */
 void guest_set_pte(struct lguest *lg,
 		   unsigned long cr3, unsigned long vaddr, gpte_t gpte)
 {
-	/* Kernel mappings must be changed on all top levels. */
+	/* Kernel mappings must be changed on all top levels.  Slow, but
+	 * doesn't happen often. */
 	if (vaddr >= lg->page_offset) {
 		unsigned int i;
 		for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
 			if (lg->pgdirs[i].pgdir)
 				do_set_pte(lg, i, vaddr, gpte);
 	} else {
+		/* Is this page table one we have a shadow for? */
 		int pgdir = find_pgdir(lg, cr3);
 		if (pgdir != ARRAY_SIZE(lg->pgdirs))
+			/* If so, do the update. */
 			do_set_pte(lg, pgdir, vaddr, gpte);
 	}
 }
 
+/*H:400
+ * (iii) Setting up a page table entry when the Guest tells us it has changed.
+ *
+ * Just like we did in interrupts_and_traps.c, it makes sense for us to deal
+ * with the other side of page tables while we're here: what happens when the
+ * Guest asks for a page table to be updated?
+ *
+ * We already saw that demand_page() will fill in the shadow page tables when
+ * needed, so we can simply remove shadow page table entries whenever the Guest
+ * tells us they've changed.  When the Guest tries to use the new entry it will
+ * fault and demand_page() will fix it up.
+ *
+ * So with that in mind here's our code to to update a (top-level) PGD entry:
+ */
 void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 idx)
 {
 	int pgdir;
 
+	/* The kernel seems to try to initialize this early on: we ignore its
+	 * attempts to map over the Switcher. */
 	if (idx >= SWITCHER_PGD_INDEX)
 		return;
 
+	/* If they're talking about a page table we have a shadow for... */
 	pgdir = find_pgdir(lg, cr3);
 	if (pgdir < ARRAY_SIZE(lg->pgdirs))
+		/* ... throw it away. */
 		release_pgd(lg, lg->pgdirs[pgdir].pgdir + idx);
 }
 
+/*H:500 (vii) Setting up the page tables initially.
+ *
+ * When a Guest is first created, the Launcher tells us where the toplevel of
+ * its first page table is.  We set some things up here: */
 int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
 {
-	/* We assume this in flush_user_mappings, so check now */
+	/* In flush_user_mappings() we loop from 0 to
+	 * "vaddr_to_pgd_index(lg->page_offset)".  This assumes it won't hit
+	 * the Switcher mappings, so check that now. */
 	if (vaddr_to_pgd_index(lg->page_offset) >= SWITCHER_PGD_INDEX)
 		return -EINVAL;
+	/* We start on the first shadow page table, and give it a blank PGD
+	 * page. */
 	lg->pgdidx = 0;
 	lg->pgdirs[lg->pgdidx].cr3 = pgtable;
 	lg->pgdirs[lg->pgdidx].pgdir = (spgd_t*)get_zeroed_page(GFP_KERNEL);
@@ -338,33 +570,48 @@ int init_guest_pagetable(struct lguest *
 	return 0;
 }
 
+/* When a Guest dies, our cleanup is fairly simple. */
 void free_guest_pagetable(struct lguest *lg)
 {
 	unsigned int i;
 
+	/* Throw away all page table pages. */
 	release_all_pagetables(lg);
+	/* Now free the top levels: free_page() can handle 0 just fine. */
 	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
 		free_page((long)lg->pgdirs[i].pgdir);
 }
 
-/* Caller must be preempt-safe */
+/*H:480 (vi) Mapping the Switcher when the Guest is about to run.
+ *
+ * The Switcher and the two pages for this CPU need to be available to the
+ * Guest (and not the pages for other CPUs).  We have the appropriate PTE pages
+ * for each CPU already set up, we just need to hook them in. */
 void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages)
 {
 	spte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
 	spgd_t switcher_pgd;
 	spte_t regs_pte;
 
-	/* Since switcher less that 4MB, we simply mug top pte page. */
+	/* Make the last PGD entry for this Guest point to the Switcher's PTE
+	 * page for this CPU (with appropriate flags). */
 	switcher_pgd.pfn = __pa(switcher_pte_page) >> PAGE_SHIFT;
 	switcher_pgd.flags = _PAGE_KERNEL;
 	lg->pgdirs[lg->pgdidx].pgdir[SWITCHER_PGD_INDEX] = switcher_pgd;
 
-	/* Map our regs page over stack page. */
+	/* We also change the Switcher PTE page.  When we're running the Guest,
+	 * we want the Guest's "regs" page to appear where the first Switcher
+	 * page for this CPU is.  This is an optimization: when the Switcher
+	 * saves the Guest registers, it saves them into the first page of this
+	 * CPU's "struct lguest_pages": if we make sure the Guest's register
+	 * page is already mapped there, we don't have to copy them out
+	 * again. */
 	regs_pte.pfn = __pa(lg->regs_page) >> PAGE_SHIFT;
 	regs_pte.flags = _PAGE_KERNEL;
 	switcher_pte_page[(unsigned long)pages/PAGE_SIZE%PTES_PER_PAGE]
 		= regs_pte;
 }
+/*:*/
 
 static void free_switcher_pte_pages(void)
 {
@@ -374,6 +621,10 @@ static void free_switcher_pte_pages(void
 		free_page((long)switcher_pte_page(i));
 }
 
+/*H:520 Setting up the Switcher PTE page for given CPU is fairly easy, given
+ * the CPU number and the "struct page"s for the Switcher code itself.
+ *
+ * Currently the Switcher is less than a page long, so "pages" is always 1. */
 static __init void populate_switcher_pte_page(unsigned int cpu,
 					      struct page *switcher_page[],
 					      unsigned int pages)
@@ -381,21 +632,26 @@ static __init void populate_switcher_pte
 	unsigned int i;
 	spte_t *pte = switcher_pte_page(cpu);
 
+	/* The first entries are easy: they map the Switcher code. */
 	for (i = 0; i < pages; i++) {
 		pte[i].pfn = page_to_pfn(switcher_page[i]);
 		pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
 	}
 
-	/* We only map this CPU's pages, so guest can't see others. */
+	/* The only other thing we map is this CPU's pair of pages. */
 	i = pages + cpu*2;
 
-	/* First page (regs) is rw, second (state) is ro. */
+	/* First page (Guest registers) is writable from the Guest */
 	pte[i].pfn = page_to_pfn(switcher_page[i]);
 	pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED|_PAGE_RW;
+	/* The second page contains the "struct lguest_ro_state", and is
+	 * read-only. */
 	pte[i+1].pfn = page_to_pfn(switcher_page[i+1]);
 	pte[i+1].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
 }
 
+/*H:510 At boot or module load time, init_pagetables() allocates and populates
+ * the Switcher PTE page for each CPU. */
 __init int init_pagetables(struct page **switcher_page, unsigned int pages)
 {
 	unsigned int i;
@@ -410,7 +666,9 @@ __init int init_pagetables(struct page *
 	}
 	return 0;
 }
+/*:*/
 
+/* Cleaning up simply involves freeing the PTE page for each CPU. */
 void free_pagetables(void)
 {
 	free_switcher_pte_pages();
diff -puN drivers/lguest/segments.c~lguest-documentation-v-host drivers/lguest/segments.c
--- a/drivers/lguest/segments.c~lguest-documentation-v-host
+++ a/drivers/lguest/segments.c
@@ -11,17 +11,58 @@
  * from frolicking through its parklike serenity. :*/
 #include "lg.h"
 
+/*H:600
+ * We've almost completed the Host; there's just one file to go!
+ *
+ * Segments & The Global Descriptor Table
+ *
+ * (That title sounds like a bad Nerdcore group.  Not to suggest that there are
+ * any good Nerdcore groups, but in high school a friend of mine had a band
+ * called Joe Fish and the Chips, so there are definitely worse band names).
+ *
+ * To refresh: the GDT is a table of 8-byte values describing segments.  Once
+ * set up, these segments can be loaded into one of the 6 "segment registers".
+ *
+ * GDT entries are passed around as "struct desc_struct"s, which like IDT
+ * entries are split into two 32-bit members, "a" and "b".  One day, someone
+ * will clean that up, and be declared a Hero.  (No pressure, I'm just saying).
+ *
+ * Anyway, the GDT entry contains a base (the start address of the segment), a
+ * limit (the size of the segment - 1), and some flags.  Sounds simple, and it
+ * would be, except those zany Intel engineers decided that it was too boring
+ * to put the base at one end, the limit at the other, and the flags in
+ * between.  They decided to shotgun the bits at random throughout the 8 bytes,
+ * like so:
+ *
+ * 0               16                     40       48  52  56     63
+ * [ limit part 1 ][     base part 1     ][ flags ][li][fl][base ]
+ *                                                  mit ags part 2
+ *                                                part 2
+ *
+ * As a result, this file contains a certain amount of magic numeracy.  Let's
+ * begin.
+ */
+
+/* Is the descriptor the Guest wants us to put in OK?
+ *
+ * The flag which Intel says must be zero: must be zero.  The descriptor must
+ * be present, (this is actually checked earlier but is here for thorougness),
+ * and the descriptor type must be 1 (a memory segment).  */
 static int desc_ok(const struct desc_struct *gdt)
 {
-	/* MBZ=0, P=1, DT=1  */
 	return ((gdt->b & 0x00209000) == 0x00009000);
 }
 
+/* Is the segment present?  (Otherwise it can't be used by the Guest). */
 static int segment_present(const struct desc_struct *gdt)
 {
 	return gdt->b & 0x8000;
 }
 
+/* There are several entries we don't let the Guest set.  The TSS entry is the
+ * "Task State Segment" which controls all kinds of delicate things.  The
+ * LGUEST_CS and LGUEST_DS entries are reserved for the Switcher, and the
+ * the Guest can't be trusted to deal with double faults. */
 static int ignored_gdt(unsigned int num)
 {
 	return (num == GDT_ENTRY_TSS
@@ -30,9 +71,18 @@ static int ignored_gdt(unsigned int num)
 		|| num == GDT_ENTRY_DOUBLEFAULT_TSS);
 }
 
-/* We don't allow removal of CS, DS or SS; it doesn't make sense. */
+/* If the Guest asks us to remove an entry from the GDT, we have to be careful.
+ * If one of the segment registers is pointing at that entry the Switcher will
+ * crash when it tries to reload the segment registers for the Guest.
+ *
+ * It doesn't make much sense for the Guest to try to remove its own code, data
+ * or stack segments while they're in use: assume that's a Guest bug.  If it's
+ * one of the lesser segment registers using the removed entry, we simply set
+ * that register to 0 (unusable). */
 static void check_segment_use(struct lguest *lg, unsigned int desc)
 {
+	/* GDT entries are 8 bytes long, so we divide to get the index and
+	 * ignore the bottom bits. */
 	if (lg->regs->gs / 8 == desc)
 		lg->regs->gs = 0;
 	if (lg->regs->fs / 8 == desc)
@@ -45,12 +95,16 @@ static void check_segment_use(struct lgu
 		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
 
+/*H:610 Once the GDT has been changed, we look through the changed entries and
+ * see if they're OK.  If not, we'll call kill_guest() and the Guest will never
+ * get to use the invalid entries. */
 static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
 {
 	unsigned int i;
 
 	for (i = start; i < end; i++) {
-		/* We never copy these ones to real gdt */
+		/* We never copy these ones to real GDT, so we don't care what
+		 * they say */
 		if (ignored_gdt(i))
 			continue;
 
@@ -64,41 +118,57 @@ static void fixup_gdt_table(struct lgues
 		if (!desc_ok(&lg->gdt[i]))
 			kill_guest(lg, "Bad GDT descriptor %i", i);
 
-		/* DPL 0 presumably means "for use by guest". */
+		/* Segment descriptors contain a privilege level: the Guest is
+		 * sometimes careless and leaves this as 0, even though it's
+		 * running at privilege level 1.  If so, we fix it here. */
 		if ((lg->gdt[i].b & 0x00006000) == 0)
 			lg->gdt[i].b |= (GUEST_PL << 13);
 
-		/* Set accessed bit, since gdt isn't writable. */
+		/* Each descriptor has an "accessed" bit.  If we don't set it
+		 * now, the CPU will try to set it when the Guest first loads
+		 * that entry into a segment register.  But the GDT isn't
+		 * writable by the Guest, so bad things can happen. */
 		lg->gdt[i].b |= 0x00000100;
 	}
 }
 
+/* This routine is called at boot or modprobe time for each CPU to set up the
+ * "constant" GDT entries for Guests running on that CPU. */
 void setup_default_gdt_entries(struct lguest_ro_state *state)
 {
 	struct desc_struct *gdt = state->guest_gdt;
 	unsigned long tss = (unsigned long)&state->guest_tss;
 
-	/* Hypervisor segments. */
+	/* The hypervisor segments are full 0-4G segments, privilege level 0 */
 	gdt[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
 	gdt[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
 
-	/* This is the one which we *cannot* copy from guest, since tss
-	   is depended on this lguest_ro_state, ie. this cpu. */
+	/* The TSS segment refers to the TSS entry for this CPU, so we cannot
+	 * copy it from the Guest.  Forgive the magic flags */
 	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
 	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
 		| ((tss >> 16) & 0x000000FF);
 }
 
+/* This routine is called before the Guest is run for the first time. */
 void setup_guest_gdt(struct lguest *lg)
 {
+	/* Start with full 0-4G segments... */
 	lg->gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
 	lg->gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
+	/* ...except the Guest is allowed to use them, so set the privilege
+	 * level appropriately in the flags. */
 	lg->gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
 	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
 }
 
-/* This is a fast version for the common case where only the three TLS entries
- * have changed. */
+/* Like the IDT, we never simply use the GDT the Guest gives us.  We set up the
+ * GDTs for each CPU, then we copy across the entries each time we want to run
+ * a different Guest on that CPU. */
+
+/* A partial GDT load, for the three "thead-local storage" entries.  Otherwise
+ * it's just like load_guest_gdt().  So much, in fact, it would probably be
+ * neater to have a single hypercall to cover both. */
 void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
 {
 	unsigned int i;
@@ -107,22 +177,31 @@ void copy_gdt_tls(const struct lguest *l
 		gdt[i] = lg->gdt[i];
 }
 
+/* This is the full version */
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
 {
 	unsigned int i;
 
+	/* The default entries from setup_default_gdt_entries() are not
+	 * replaced.  See ignored_gdt() above. */
 	for (i = 0; i < GDT_ENTRIES; i++)
 		if (!ignored_gdt(i))
 			gdt[i] = lg->gdt[i];
 }
 
+/* This is where the Guest asks us to load a new GDT (LHCALL_LOAD_GDT). */
 void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
 {
+	/* We assume the Guest has the same number of GDT entries as the
+	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
 	if (num > ARRAY_SIZE(lg->gdt))
 		kill_guest(lg, "too many gdt entries %i", num);
 
+	/* We read the whole thing in, then fix it up. */
 	lgread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
 	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->gdt));
+	/* Mark that the GDT changed so the core knows it has to copy it again,
+	 * even if the Guest is run on the same CPU. */
 	lg->changed |= CHANGED_GDT;
 }
 
@@ -134,3 +213,13 @@ void guest_load_tls(struct lguest *lg, u
 	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
 	lg->changed |= CHANGED_GDT_TLS;
 }
+
+/*
+ * With this, we have finished the Host.
+ *
+ * Five of the seven parts of our task are complete.  You have made it through
+ * the Bit of Despair (I think that's somewhere in the page table code,
+ * myself).
+ *
+ * Next, we examine "make Switcher".  It's short, but intense.
+ */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

resend-link-lguest-example-launcher-non-static.patch
lguest-documentation-i-preparation.patch
lguest-documentation-ii-guest.patch
lguest-documentation-iii-drivers.patch
lguest-documentation-iv-launcher.patch
lguest-documentation-v-host.patch
lguest-documentation-vi-switcher.patch
lguest-documentation-vii-fixmes.patch
git-kvm.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
