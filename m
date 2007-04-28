From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch added to -mm tree
Date: Fri, 27 Apr 2007 23:16:17 -0700
Message-ID: <200704280616.l3S6GHEK016172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbXD1GQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 02:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest simplification: don't pin guest trap handlers
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest simplification: don't pin guest trap handlers
From: Rusty Russell <rusty@rustcorp.com.au>

We don't actually need the Guest handlers mapped to avoid double
fault, just the stack pages.  Thanks to Zach for confirming.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/interrupts_and_traps.c |   26 ------------------------
 drivers/lguest/lg.h                   |    2 -
 drivers/lguest/page_tables.c          |    6 ++---
 3 files changed, 5 insertions(+), 29 deletions(-)

diff -puN drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-simplification-dont-pin-guest-trap-handlers drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-simplification-dont-pin-guest-trap-handlers
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -138,7 +138,7 @@ static int direct_trap(const struct lgue
 	return idt_type(trap->a, trap->b) == 0xF;
 }
 
-static void pin_stack_pages(struct lguest *lg)
+void pin_stack_pages(struct lguest *lg)
 {
 	unsigned int i;
 
@@ -146,25 +146,6 @@ static void pin_stack_pages(struct lgues
 		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
 }
 
-/* We need to ensure all the direct trap pages are mapped after we
- * clear shadow mappings. */
-void pin_trap_pages(struct lguest *lg)
-{
-	unsigned int i;
-	struct desc_struct *trap;
-
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
-		trap = &lg->idt[i];
-		if (direct_trap(lg, trap, i))
-			pin_page(lg, idt_address(trap->a, trap->b));
-	}
-
-	trap = &lg->syscall_idt;
-	if (direct_trap(lg, trap, SYSCALL_VECTOR))
-		pin_page(lg, idt_address(trap->a, trap->b));
-	pin_stack_pages(lg);
-}
-
 void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages)
 {
 	/* You cannot have a stack segment with priv level 0. */
@@ -194,11 +175,6 @@ static void set_trap(struct lguest *lg, 
 
 	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
 	trap->b = (hi&0xFFFFEF00);
-
-	/* Make sure trap address is available so we don't fault.  In
-	 * theory, it could overlap two pages, in practice it's aligned. */
-	if (direct_trap(lg, trap, num))
-		pin_page(lg, idt_address(lo, hi));
 }
 
 void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
diff -puN drivers/lguest/lg.h~lguest-the-host-code-simplification-dont-pin-guest-trap-handlers drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-simplification-dont-pin-guest-trap-handlers
+++ a/drivers/lguest/lg.h
@@ -190,7 +190,7 @@ void maybe_do_interrupt(struct lguest *l
 int deliver_trap(struct lguest *lg, unsigned int num);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
 void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
-void pin_trap_pages(struct lguest *lg);
+void pin_stack_pages(struct lguest *lg);
 void setup_default_idt_entries(struct lguest_ro_state *state,
 			       const unsigned long *def);
 void copy_traps(const struct lguest *lg, struct desc_struct *idt,
diff -puN drivers/lguest/page_tables.c~lguest-the-host-code-simplification-dont-pin-guest-trap-handlers drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-the-host-code-simplification-dont-pin-guest-trap-handlers
+++ a/drivers/lguest/page_tables.c
@@ -186,7 +186,7 @@ static int page_writable(struct lguest *
 void pin_page(struct lguest *lg, unsigned long vaddr)
 {
 	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 0))
-		kill_guest(lg, "bad trap page %#lx", vaddr);
+		kill_guest(lg, "bad stack page %#lx", vaddr);
 }
 
 static void release_pgd(struct lguest *lg, spgd_t *spgd)
@@ -253,7 +253,7 @@ void guest_new_pagetable(struct lguest *
 		newpgdir = new_pgdir(lg, pgtable, &repin);
 	lg->pgdidx = newpgdir;
 	if (repin)
-		pin_trap_pages(lg);
+		pin_stack_pages(lg);
 }
 
 static void release_all_pagetables(struct lguest *lg)
@@ -269,7 +269,7 @@ static void release_all_pagetables(struc
 void guest_pagetable_clear_all(struct lguest *lg)
 {
 	release_all_pagetables(lg);
-	pin_trap_pages(lg);
+	pin_stack_pages(lg);
 }
 
 static void do_set_pte(struct lguest *lg, int idx,
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

extend-print_symbol-capability.patch
git-kbuild.patch
git-net.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
