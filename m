From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:01:24 -0800
Message-ID: <200703270601.l2R61O8W008860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbXC0GBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: cleanup: clean up regs save/restore
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch

This patch was dropped because it was folded into lguest-the-host-code-lgko.patch

------------------------------------------------------
Subject: lguest: cleanup: clean up regs save/restore
From: Rusty Russell <rusty@rustcorp.com.au>

We previously put "cr3" in the guest regs restored and saved: the guest cannot
change cr3, so saving it it silly.  Hand it across to the host<->guest
switcher in ebx.

While we're there, only save the host registers we need to; tell GCC we
clobber everything we can.

Finally, and trap 2 (NMI) doesn't supply a error code (we don't handle NMI
yet, but the test is wrong, so fix it before I get confused).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/core.c        |    8 +--
 arch/i386/lguest/hypervisor.S  |   68 +++++++++++++------------------
 arch/i386/lguest/lg.h          |    2 
 arch/i386/lguest/lguest_user.c |    5 --
 arch/i386/lguest/page_tables.c |    3 -
 5 files changed, 39 insertions(+), 47 deletions(-)

diff -puN arch/i386/lguest/core.c~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore
+++ a/arch/i386/lguest/core.c
@@ -260,11 +260,11 @@ static void run_guest_once(struct lguest
 {
 	unsigned int clobber;
 
-	/* Put eflags on stack, lcall does rest. */
+	/* Put eflags on stack, lcall does rest: suitable for iret return. */
 	asm volatile("pushf; lcall *lguest_entry"
-		     : "=a"(clobber), "=d"(clobber)
-		     : "0"(lg->state), "1"(get_idt_table())
-		     : "memory");
+		     : "=a"(clobber), "=d"(clobber), "=b"(clobber)
+		     : "0"(lg->state), "1"(get_idt_table()), "2"(lg->cr3)
+		     : "memory", "%ecx", "%edi", "%esi");
 }
 
 int run_guest(struct lguest *lg, char *__user user)
diff -puN arch/i386/lguest/hypervisor.S~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore
+++ a/arch/i386/lguest/hypervisor.S
@@ -4,26 +4,17 @@
 #include <asm/asm-offsets.h>
 #include "lg.h"
 
-#define SAVE_REGS				\
-	/* Save old guest/host state */		\
-	pushl	%es;				\
-	pushl	%ds;				\
-	pushl	%fs;				\
-	pushl	%eax;				\
-	pushl	%gs;				\
-	pushl	%ebp;				\
-	pushl	%edi;				\
-	pushl	%esi;				\
-	pushl	%edx;				\
-	pushl	%ecx;				\
-	pushl	%ebx;				\
-
 .text
 ENTRY(_start) /* ld complains unless _start is defined. */
-/* %eax contains ptr to target guest state, %edx contains host idt. */
+/* %eax contains ptr to target guest state, %edx contains host idt.
+   %ebx contains cr3 value.  All normal registers can be clobbered! */
 switch_to_guest:
-	pushl	%ss
-	SAVE_REGS
+	pushl	%es
+	pushl	%ds
+	pushl	%fs
+	pushl	%gs
+	pushl	%edx
+	pushl	%ebp
 	/* Save old stack, switch to guest's stack. */
 	movl	%esp, LGUEST_STATE_host_stackptr(%eax)
 	movl	%eax, %esp
@@ -33,17 +24,16 @@ switch_to_guest:
 	lgdt	LGUEST_STATE_gdt(%eax)
 	lidt	LGUEST_STATE_idt(%eax)
 	/* Save page table top. */
-	movl	%cr3, %ebx
-	movl	%ebx, LGUEST_STATE_host_pgdir(%eax)
+	movl	%cr3, %ecx
+	movl	%ecx, LGUEST_STATE_host_pgdir(%eax)
 	/* Set host's TSS to available (clear byte 5 bit 2). */
-	movl	(LGUEST_STATE_host_gdt+2)(%eax), %ebx
-	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%ebx)
+	movl	(LGUEST_STATE_host_gdt+2)(%eax), %ecx
+	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%ecx)
 	/* Switch to guest page tables */
-	popl	%ebx
 	movl	%ebx, %cr3
 	/* Switch to guest's TSS. */
-	movl	$(GDT_ENTRY_TSS*8), %ebx
-	ltr	%bx
+	movl	$(GDT_ENTRY_TSS*8), %edx
+	ltr	%dx
 	/* Restore guest regs */
 	popl	%ebx
 	popl	%ecx
@@ -66,10 +56,18 @@ switch_to_guest:
 	iret
 
 #define SWITCH_TO_HOST							\
-	SAVE_REGS;							\
-	/* Save old pgdir */						\
-	movl	%cr3, %eax;						\
+	/* Save guest state */						\
+	pushl	%es;							\
+	pushl	%ds;							\
+	pushl	%fs;							\
 	pushl	%eax;							\
+	pushl	%gs;							\
+	pushl	%ebp;							\
+	pushl	%edi;							\
+	pushl	%esi;							\
+	pushl	%edx;							\
+	pushl	%ecx;							\
+	pushl	%ebx;							\
 	/* Load lguest ds segment for convenience. */			\
 	movl	$(LGUEST_DS), %eax;					\
 	movl	%eax, %ds;						\
@@ -88,21 +86,15 @@ switch_to_guest:
 	/* Switch to host's stack. */					\
 	movl	LGUEST_STATE_host_stackptr(%eax), %esp;			\
 	/* Switch to host's TSS */					\
-	movl	$(GDT_ENTRY_TSS*8), %eax;				\
-	ltr	%ax;							\
+	movl	$(GDT_ENTRY_TSS*8), %ebx;				\
+	ltr	%bx;							\
 	/* Restore host regs */						\
-	popl	%ebx;							\
-	popl	%ecx;							\
-	popl	%edx;							\
-	popl	%esi;							\
-	popl	%edi;							\
 	popl	%ebp;							\
+	popl	%edx;							\
 	popl	%gs;							\
-	popl	%eax;							\
 	popl	%fs;							\
 	popl	%ds;							\
-	popl	%es;							\
-	popl	%ss
+	popl	%es
 
 /* Return to run_guest_once. */
 return_to_host:
@@ -135,7 +127,7 @@ deliver_to_host_with_errcode:
 .macro IRQ_STUB N TARGET
 	.data; .long 1f; .text; 1:
  /* Make an error number for most traps, which don't have one. */
- .if (\N <> 2) && (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
+ .if (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
 	pushl	$0
  .endif
 	pushl	$\N
diff -puN arch/i386/lguest/lg.h~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore
+++ a/arch/i386/lguest/lg.h
@@ -24,7 +24,6 @@
 struct lguest_regs
 {
 	/* Manually saved part. */
-	u32 cr3;
 	u32 ebx, ecx, edx;
 	u32 esi, edi, ebp;
 	u32 gs;
@@ -81,6 +80,7 @@ struct lguest
 	u32 pfn_limit;
 	u32 page_offset;
 	u32 cr2;
+	u32 cr3;
 	int timer_on;
 	int halted;
 	int ts;
diff -puN arch/i386/lguest/lguest_user.c~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore arch/i386/lguest/lguest_user.c
--- a/arch/i386/lguest/lguest_user.c~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore
+++ a/arch/i386/lguest/lguest_user.c
@@ -4,7 +4,7 @@
 #include <linux/fs.h>
 #include "lg.h"
 
-static struct lguest_state *setup_guest_state(unsigned int num, void *pgdir,
+static struct lguest_state *setup_guest_state(unsigned int num,
 					      unsigned long start)
 {
 	struct lguest_state *guest = &__lguest_states()[num];
@@ -38,7 +38,6 @@ static struct lguest_state *setup_guest_
 
 	/* Write out stack in format lguest expects, so we can switch to it. */
 	regs = &guest->regs;
-	regs->cr3 = __pa(pgdir);
 	regs->eax = regs->ebx = regs->ecx = regs->edx = regs->esp = 0;
 	regs->edi = LGUEST_MAGIC_EDI;
 	regs->ebp = LGUEST_MAGIC_EBP;
@@ -149,7 +148,7 @@ static int initialize(struct file *file,
 	if (err)
 		goto free_trap_page;
 
-	lg->state = setup_guest_state(i, lg->pgdirs[lg->pgdidx].pgdir,args[2]);
+	lg->state = setup_guest_state(i, args[2]);
 	if (!lg->state) {
 		err = -ENOEXEC;
 		goto release_pgtable;
diff -puN arch/i386/lguest/page_tables.c~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore
+++ a/arch/i386/lguest/page_tables.c
@@ -223,7 +223,7 @@ void guest_new_pagetable(struct lguest *
 	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
 		newpgdir = new_pgdir(lg, pgtable);
 	lg->pgdidx = newpgdir;
-	lg->state->regs.cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
+	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
 	pin_stack_pages(lg);
 }
 
@@ -296,6 +296,7 @@ int init_guest_pagetable(struct lguest *
 	lg->pgdirs[lg->pgdidx].pgdir = (u32*)get_zeroed_page(GFP_KERNEL);
 	if (!lg->pgdirs[lg->pgdidx].pgdir)
 		return -ENOMEM;
+	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
 	return 0;
 }
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-clean-up-some-references-inittext-warnings-2.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
cleanup-rationalize-paravirt-wrappers.patch
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
