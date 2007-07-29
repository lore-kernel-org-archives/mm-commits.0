From: akpm@linux-foundation.org
Subject: - lguest-documentation-vi-switcher.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:41 -0700
Message-ID: <200707290611.l6T6Bfdq010998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757104AbXG2GLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: documentation VI: Switcher
has been removed from the -mm tree.  Its filename was
     lguest-documentation-vi-switcher.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: documentation VI: Switcher
From: Rusty Russell <rusty@rustcorp.com.au>

Documentation: The Switcher

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c     |   51 ++++++
 drivers/lguest/switcher.S |  271 ++++++++++++++++++++++++++++++------
 2 files changed, 276 insertions(+), 46 deletions(-)

diff -puN drivers/lguest/core.c~lguest-documentation-vi-switcher drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-documentation-vi-switcher
+++ a/drivers/lguest/core.c
@@ -393,46 +393,89 @@ static void set_ts(void)
 		write_cr0(cr0|8);
 }
 
+/*S:010
+ * We are getting close to the Switcher.
+ *
+ * Remember that each CPU has two pages which are visible to the Guest when it
+ * runs on that CPU.  This has to contain the state for that Guest: we copy the
+ * state in just before we run the Guest.
+ *
+ * Each Guest has "changed" flags which indicate what has changed in the Guest
+ * since it last ran.  We saw this set in interrupts_and_traps.c and
+ * segments.c.
+ */
 static void copy_in_guest_info(struct lguest *lg, struct lguest_pages *pages)
 {
+	/* Copying all this data can be quite expensive.  We usually run the
+	 * same Guest we ran last time (and that Guest hasn't run anywhere else
+	 * meanwhile).  If that's not the case, we pretend everything in the
+	 * Guest has changed. */
 	if (__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
 		__get_cpu_var(last_guest) = lg;
 		lg->last_pages = pages;
 		lg->changed = CHANGED_ALL;
 	}
 
-	/* These are pretty cheap, so we do them unconditionally. */
+	/* These copies are pretty cheap, so we do them unconditionally: */
+	/* Save the current Host top-level page directory. */
 	pages->state.host_cr3 = __pa(current->mm->pgd);
+	/* Set up the Guest's page tables to see this CPU's pages (and no
+	 * other CPU's pages). */
 	map_switcher_in_guest(lg, pages);
+	/* Set up the two "TSS" members which tell the CPU what stack to use
+	 * for traps which do directly into the Guest (ie. traps at privilege
+	 * level 1). */
 	pages->state.guest_tss.esp1 = lg->esp1;
 	pages->state.guest_tss.ss1 = lg->ss1;
 
-	/* Copy direct trap entries. */
+	/* Copy direct-to-Guest trap entries. */
 	if (lg->changed & CHANGED_IDT)
 		copy_traps(lg, pages->state.guest_idt, default_idt_entries);
 
-	/* Copy all GDT entries but the TSS. */
+	/* Copy all GDT entries which the Guest can change. */
 	if (lg->changed & CHANGED_GDT)
 		copy_gdt(lg, pages->state.guest_gdt);
 	/* If only the TLS entries have changed, copy them. */
 	else if (lg->changed & CHANGED_GDT_TLS)
 		copy_gdt_tls(lg, pages->state.guest_gdt);
 
+	/* Mark the Guest as unchanged for next time. */
 	lg->changed = 0;
 }
 
+/* Finally: the code to actually call into the Switcher to run the Guest. */
 static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
 {
+	/* This is a dummy value we need for GCC's sake. */
 	unsigned int clobber;
 
+	/* Copy the guest-specific information into this CPU's "struct
+	 * lguest_pages". */
 	copy_in_guest_info(lg, pages);
 
-	/* Put eflags on stack, lcall does rest: suitable for iret return. */
+	/* Now: we push the "eflags" register on the stack, then do an "lcall".
+	 * This is how we change from using the kernel code segment to using
+	 * the dedicated lguest code segment, as well as jumping into the
+	 * Switcher.
+	 *
+	 * The lcall also pushes the old code segment (KERNEL_CS) onto the
+	 * stack, then the address of this call.  This stack layout happens to
+	 * exactly match the stack of an interrupt... */
 	asm volatile("pushf; lcall *lguest_entry"
+		     /* This is how we tell GCC that %eax ("a") and %ebx ("b")
+		      * are changed by this routine.  The "=" means output. */
 		     : "=a"(clobber), "=b"(clobber)
+		     /* %eax contains the pages pointer.  ("0" refers to the
+		      * 0-th argument above, ie "a").  %ebx contains the
+		      * physical address of the Guest's top-level page
+		      * directory. */
 		     : "0"(pages), "1"(__pa(lg->pgdirs[lg->pgdidx].pgdir))
+		     /* We tell gcc that all these registers could change,
+		      * which means we don't have to save and restore them in
+		      * the Switcher. */
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
+/*:*/
 
 /*H:030 Let's jump straight to the the main loop which runs the Guest.
  * Remember, this is called by the Launcher reading /dev/lguest, and we keep
diff -puN drivers/lguest/switcher.S~lguest-documentation-vi-switcher drivers/lguest/switcher.S
--- a/drivers/lguest/switcher.S~lguest-documentation-vi-switcher
+++ a/drivers/lguest/switcher.S
@@ -6,41 +6,131 @@
  * are feeling invigorated and refreshed then the next, more challenging stage
  * can be found in "make Guest". :*/
 
+/*S:100
+ * Welcome to the Switcher itself!
+ *
+ * This file contains the low-level code which changes the CPU to run the Guest
+ * code, and returns to the Host when something happens.  Understand this, and
+ * you understand the heart of our journey.
+ *
+ * Because this is in assembler rather than C, our tale switches from prose to
+ * verse.  First I tried limericks:
+ *
+ *	There once was an eax reg,
+ *	To which our pointer was fed,
+ *	It needed an add,
+ *	Which asm-offsets.h had
+ *	But this limerick is hurting my head.
+ *
+ * Next I tried haikus, but fitting the required reference to the seasons in
+ * every stanza was quickly becoming tiresome:
+ *
+ *	The %eax reg
+ *	Holds "struct lguest_pages" now:
+ *	Cherry blossoms fall.
+ *
+ * Then I started with Heroic Verse, but the rhyming requirement leeched away
+ * the content density and led to some uniquely awful oblique rhymes:
+ *
+ *	These constants are coming from struct offsets
+ *	For use within the asm switcher text.
+ *
+ * Finally, I settled for something between heroic hexameter, and normal prose
+ * with inappropriate linebreaks.  Anyway, it aint no Shakespeare.
+ */
+
+// Not all kernel headers work from assembler
+// But these ones are needed: the ENTRY() define
+// And constants extracted from struct offsets
+// To avoid magic numbers and breakage:
+// Should they change the compiler can't save us
+// Down here in the depths of assembler code.
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include "lg.h"
 
+// We mark the start of the code to copy
+// It's placed in .text tho it's never run here
+// You'll see the trick macro at the end
+// Which interleaves data and text to effect.
 .text
 ENTRY(start_switcher_text)
 
-/* %eax points to lguest pages for this CPU.  %ebx contains cr3 value.
-   All normal registers can be clobbered! */
+// When we reach switch_to_guest we have just left
+// The safe and comforting shores of C code
+// %eax has the "struct lguest_pages" to use
+// Where we save state and still see it from the Guest
+// And %ebx holds the Guest shadow pagetable:
+// Once set we have truly left Host behind.
 ENTRY(switch_to_guest)
-	/* Save host segments on host stack. */
+	// We told gcc all its regs could fade,
+	// Clobbered by our journey into the Guest
+	// We could have saved them, if we tried
+	// But time is our master and cycles count.
+
+	// Segment registers must be saved for the Host
+	// We push them on the Host stack for later
 	pushl	%es
 	pushl	%ds
 	pushl	%gs
 	pushl	%fs
-	/* With CONFIG_FRAME_POINTER, gcc doesn't let us clobber this! */
+	// But the compiler is fickle, and heeds
+	// No warning of %ebp clobbers
+	// When frame pointers are used.  That register
+	// Must be saved and restored or chaos strikes.
 	pushl	%ebp
-	/* Save host stack. */
+	// The Host's stack is done, now save it away
+	// In our "struct lguest_pages" at offset
+	// Distilled into asm-offsets.h
 	movl	%esp, LGUEST_PAGES_host_sp(%eax)
-	/* Switch to guest stack: if we get NMI we expect to be there. */
+
+	// All saved and there's now five steps before us:
+	// Stack, GDT, IDT, TSS
+	// And last of all the page tables are flipped.
+
+	// Yet beware that our stack pointer must be
+	// Always valid lest an NMI hits
+	// %edx does the duty here as we juggle
+	// %eax is lguest_pages: our stack lies within.
 	movl	%eax, %edx
 	addl	$LGUEST_PAGES_regs, %edx
 	movl	%edx, %esp
-	/* Switch to guest's GDT, IDT. */
+
+	// The Guest's GDT we so carefully
+	// Placed in the "struct lguest_pages" before
 	lgdt	LGUEST_PAGES_guest_gdt_desc(%eax)
+
+	// The Guest's IDT we did partially
+	// Move to the "struct lguest_pages" as well.
 	lidt	LGUEST_PAGES_guest_idt_desc(%eax)
-	/* Switch to guest's TSS while GDT still writable. */
+
+	// The TSS entry which controls traps
+	// Must be loaded up with "ltr" now:
+	// For after we switch over our page tables
+	// It (as the rest) will be writable no more.
+	// (The GDT entry TSS needs
+	// Changes type when we load it: damn Intel!)
 	movl	$(GDT_ENTRY_TSS*8), %edx
 	ltr	%dx
-	/* Set host's TSS GDT entry to available (clear byte 5 bit 2). */
+
+	// Look back now, before we take this last step!
+	// The Host's TSS entry was also marked used;
+	// Let's clear it again, ere we return.
+	// The GDT descriptor of the Host
+	// Points to the table after two "size" bytes
 	movl	(LGUEST_PAGES_host_gdt_desc+2)(%eax), %edx
+	// Clear the type field of "used" (byte 5, bit 2)
 	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%edx)
-	/* Switch to guest page tables:	lguest_pages->state now read-only. */
+
+	// Once our page table's switched, the Guest is live!
+	// The Host fades as we run this final step.
+	// Our "struct lguest_pages" is now read-only.
 	movl	%ebx, %cr3
-	/* Restore guest regs */
+
+	// The page table change did one tricky thing:
+	// The Guest's register page has been mapped
+	// Writable onto our %esp (stack) --
+	// We can simply pop off all Guest regs.
 	popl	%ebx
 	popl	%ecx
 	popl	%edx
@@ -52,12 +142,27 @@ ENTRY(switch_to_guest)
 	popl	%fs
 	popl	%ds
 	popl	%es
-	/* Skip error code and trap number */
+
+	// Near the base of the stack lurk two strange fields
+	// Which we fill as we exit the Guest
+	// These are the trap number and its error
+	// We can simply step past them on our way.
 	addl	$8, %esp
+
+	// The last five stack slots hold return address
+	// And everything needed to change privilege
+	// Into the Guest privilege level of 1,
+	// And the stack where the Guest had last left it.
+	// Interrupts are turned back on: we are Guest.
 	iret
 
+// There are two paths where we switch to the Host
+// So we put the routine in a macro.
+// We are on our way home, back to the Host
+// Interrupted out of the Guest, we come here.
 #define SWITCH_TO_HOST							\
-	/* Save guest state */						\
+	/* We save the Guest state: all registers first			\
+	 * Laid out just as "struct lguest_regs" defines */		\
 	pushl	%es;							\
 	pushl	%ds;							\
 	pushl	%fs;							\
@@ -69,58 +174,119 @@ ENTRY(switch_to_guest)
 	pushl	%edx;							\
 	pushl	%ecx;							\
 	pushl	%ebx;							\
-	/* Load lguest ds segment for convenience. */			\
+	/* Our stack and our code are using segments			\
+	 * Set in the TSS and IDT					\
+	 * Yet if we were to touch data we'd use			\
+	 * Whatever data segment the Guest had.				\
+	 * Load the lguest ds segment for now. */			\
 	movl	$(LGUEST_DS), %eax;					\
 	movl	%eax, %ds;						\
-	/* Figure out where we are, based on stack (at top of regs). */	\
+	/* So where are we?  Which CPU, which struct?			\
+	 * The stack is our clue: our TSS sets				\
+	 * It at the end of "struct lguest_pages"			\
+	 * And we then pushed and pushed and pushed Guest regs:		\
+	 * Now stack points atop the "struct lguest_regs".   		\
+	 * Subtract that offset, and we find our struct. */		\
 	movl	%esp, %eax;						\
 	subl	$LGUEST_PAGES_regs, %eax;				\
-	/* Put trap number in %ebx before we switch cr3 and lose it. */ \
+	/* Save our trap number: the switch will obscure it		\
+	 * (The Guest regs are not mapped here in the Host)		\
+	 * %ebx holds it safe for deliver_to_host */			\
 	movl	LGUEST_PAGES_regs_trapnum(%eax), %ebx;			\
-	/* Switch to host page tables (host GDT, IDT and stack are in host   \
-	   mem, so need this first) */					\
+	/* The Host GDT, IDT and stack!					\
+	 * All these lie safely hidden from the Guest:			\
+	 * We must return to the Host page tables			\
+	 * (Hence that was saved in struct lguest_pages) */		\
 	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
 	movl	%edx, %cr3;						\
-	/* Set guest's TSS to available (clear byte 5 bit 2). */	\
+	/* As before, when we looked back at the Host			\
+	 * As we left and marked TSS unused				\
+	 * So must we now for the Guest left behind. */			\
 	andb	$0xFD, (LGUEST_PAGES_guest_gdt+GDT_ENTRY_TSS*8+5)(%eax); \
-	/* Switch to host's GDT & IDT. */				\
+	/* Switch to Host's GDT, IDT. */				\
 	lgdt	LGUEST_PAGES_host_gdt_desc(%eax);			\
 	lidt	LGUEST_PAGES_host_idt_desc(%eax);			\
-	/* Switch to host's stack. */					\
+	/* Restore the Host's stack where it's saved regs lie */	\
 	movl	LGUEST_PAGES_host_sp(%eax), %esp;			\
-	/* Switch to host's TSS */					\
+	/* Last the TSS: our Host is complete */			\
 	movl	$(GDT_ENTRY_TSS*8), %edx;				\
 	ltr	%dx;							\
+	/* Restore now the regs saved right at the first. */		\
 	popl	%ebp;							\
 	popl	%fs;							\
 	popl	%gs;							\
 	popl	%ds;							\
 	popl	%es
 
-/* Return to run_guest_once. */
+// Here's where we come when the Guest has just trapped:
+// (Which trap we'll see has been pushed on the stack).
+// We need only switch back, and the Host will decode
+// Why we came home, and what needs to be done.
 return_to_host:
 	SWITCH_TO_HOST
 	iret
 
+// An interrupt, with some cause external
+// Has ajerked us rudely from the Guest's code
+// Again we must return home to the Host
 deliver_to_host:
 	SWITCH_TO_HOST
-	/* Decode IDT and jump to hosts' irq handler.  When that does iret, it
-	 * will return to run_guest_once.  This is a feature. */
+	// But now we must go home via that place
+	// Where that interrupt was supposed to go
+	// Had we not been ensconced, running the Guest.
+	// Here we see the cleverness of our stack:
+	// The Host stack is formed like an interrupt
+	// With EIP, CS and EFLAGS layered.
+	// Interrupt handlers end with "iret"
+	// And that will take us home at long long last.
+
+	// But first we must find the handler to call!
+	// The IDT descriptor for the Host
+	// Has two bytes for size, and four for address:
+	// %edx will hold it for us for now.
 	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
+	// We now know the table address we need,
+	// And saved the trap's number inside %ebx.
+	// Yet the pointer to the handler is smeared
+	// Across the bits of the table entry.
+	// What oracle can tell us how to extract
+	// From such a convoluted encoding?
+	// I consulted gcc, and it gave
+	// These instructions, which I gladly credit:
 	leal	(%edx,%ebx,8), %eax
 	movzwl	(%eax),%edx
 	movl	4(%eax), %eax
 	xorw	%ax, %ax
 	orl	%eax, %edx
+	// Now the address of the handler's in %edx
+	// We call it now: its "iret" takes us home.
 	jmp	*%edx
 
-/* Real hardware interrupts are delivered straight to the host.  Others
-   cause us to return to run_guest_once so it can decide what to do.  Note
-   that some of these are overridden by the guest to deliver directly, and
-   never enter here (see load_guest_idt_entry). */
+// Every interrupt can come to us here
+// But we must truly tell each apart.
+// They number two hundred and fifty six
+// And each must land in a different spot,
+// Push its number on stack, and join the stream.
+
+// And worse, a mere six of the traps stand apart
+// And push on their stack an addition:
+// An error number, thirty two bits long
+// So we punish the other two fifty
+// And make them push a zero so they match.
+
+// Yet two fifty six entries is long
+// And all will look most the same as the last
+// So we create a macro which can make
+// As many entries as we need to fill.
+
+// Note the change to .data then .text:
+// We plant the address of each entry
+// Into a (data) table for the Host
+// To know where each Guest interrupt should go.
 .macro IRQ_STUB N TARGET
 	.data; .long 1f; .text; 1:
- /* Make an error number for most traps, which don't have one. */
+ // Trap eight, ten through fourteen and seventeen
+ // Supply an error number.  Else zero.
  .if (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
 	pushl	$0
  .endif
@@ -129,6 +295,8 @@ deliver_to_host:
 	ALIGN
 .endm
 
+// This macro creates numerous entries
+// Using GAS macros which out-power C's.
 .macro IRQ_STUBS FIRST LAST TARGET
  irq=\FIRST
  .rept \LAST-\FIRST+1
@@ -137,24 +305,43 @@ deliver_to_host:
  .endr
 .endm
 
-/* We intercept every interrupt, because we may need to switch back to
- * host.  Unfortunately we can't tell them apart except by entry
- * point, so we need 256 entry points.
- */
+// Here's the marker for our pointer table
+// Laid in the data section just before
+// Each macro places the address of code
+// Forming an array: each one points to text
+// Which handles interrupt in its turn.
 .data
 .global default_idt_entries
 default_idt_entries:
 .text
-	IRQ_STUBS 0 1 return_to_host		/* First two traps */
-	IRQ_STUB 2 handle_nmi			/* NMI */
-	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
-	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
-	IRQ_STUB 128 return_to_host		/* System call (overridden) */
-	IRQ_STUBS 129 255 deliver_to_host	/* Other real interrupts */
-
-/* We ignore NMI and return. */
+	// The first two traps go straight back to the Host
+	IRQ_STUBS 0 1 return_to_host
+	// We'll say nothing, yet, about NMI
+	IRQ_STUB 2 handle_nmi
+	// Other traps also return to the Host
+	IRQ_STUBS 3 31 return_to_host
+	// All interrupts go via their handlers
+	IRQ_STUBS 32 127 deliver_to_host
+	// 'Cept system calls coming from userspace
+	// Are to go to the Guest, never the Host.
+	IRQ_STUB 128 return_to_host
+	IRQ_STUBS 129 255 deliver_to_host
+
+// The NMI, what a fabulous beast
+// Which swoops in and stops us no matter that
+// We're suspended between heaven and hell,
+// (Or more likely between the Host and Guest)
+// When in it comes!  We are dazed and confused
+// So we do the simplest thing which one can.
+// Though we've pushed the trap number and zero
+// We discard them, return, and hope we live.
 handle_nmi:
 	addl	$8, %esp
 	iret
 
+// We are done; all that's left is Mastery
+// And "make Mastery" is a journey long
+// Designed to make your fingers itch to code.
+
+// Here ends the text, the file and poem.
 ENTRY(end_switcher_text)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-newsetup-fixup.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
