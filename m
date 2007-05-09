From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch removed from -mm tree
Date: Wed, 09 May 2007 02:42:52 -0700
Message-ID: <200705090942.l499gqaf020187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887AbXEIJnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest simplification: don't pin guest trap handlers
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

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

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
