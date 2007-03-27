From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-lgko-pin-stack-page-optimization.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:01:26 -0800
Message-ID: <200703270601.l2R61QMh008863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbXC0GBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: pin stack page optimization
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-lgko-pin-stack-page-optimization.patch

This patch was dropped because it was folded into lguest-the-host-code-lgko.patch

------------------------------------------------------
Subject: lguest: pin stack page optimization
From: Rusty Russell <rusty@rustcorp.com.au>

We make sure that the stack is always mapped in pin_stack_pages by simply
calling demand_page, but that calls get_user_pages() to find the pfn, which is
way overkill since the page is almost certainly already mapped.  So don't call
pin_stack_pages every context switch (unless genuinely a completely clean
context, all the kernel mappings are kept in sync), and when we do call it,
have it check if it needs to call demand_page().

This speeds guest context switch by 25%:

Before:
Time for one context switch via pipe: 10606 nsec
After:
Time for one context switch via pipe: 7805 nsec
Native:
Time for one context switch via pipe: 4701 nsec

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/page_tables.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff -puN arch/i386/lguest/page_tables.c~lguest-the-host-code-lgko-pin-stack-page-optimization arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-the-host-code-lgko-pin-stack-page-optimization
+++ a/arch/i386/lguest/page_tables.c
@@ -155,14 +155,29 @@ int demand_page(struct lguest *lg, u32 v
 	return page_in(lg, vaddr, (write ? _PAGE_DIRTY : 0)|_PAGE_ACCESSED);
 }
 
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
 void pin_stack_pages(struct lguest *lg)
 {
 	unsigned int i;
 	u32 stack = lg->state->tss.esp1;
 
-	for (i = 0; i < lg->stack_pages; i++)
-		if (!demand_page(lg, stack - i*PAGE_SIZE, 1))
+	for (i = 0; i < lg->stack_pages; i++) {
+		if (!page_writable(lg, stack - i * PAGE_SIZE)
+		    && !demand_page(lg, stack - i * PAGE_SIZE, 1))
 			kill_guest(lg, "bad stack page %i@%#x", i, stack);
+	}
 }
 
 static unsigned int find_pgdir(struct lguest *lg, u32 pgtable)
@@ -198,7 +213,7 @@ void guest_pagetable_flush_user(struct l
 	flush_user_mappings(lg, lg->pgdidx);
 }
 
-static unsigned int new_pgdir(struct lguest *lg, u32 cr3)
+static unsigned int new_pgdir(struct lguest *lg, u32 cr3, int *blank_pgdir)
 {
 	unsigned int next;
 
@@ -207,6 +222,9 @@ static unsigned int new_pgdir(struct lgu
 		lg->pgdirs[next].pgdir = (u32 *)get_zeroed_page(GFP_KERNEL);
 		if (!lg->pgdirs[next].pgdir)
 			next = lg->pgdidx;
+		else
+			/* There are no mappings: you'll need to re-pin */
+			*blank_pgdir = 1;
 	}
 	lg->pgdirs[next].cr3 = cr3;
 	/* Release all the non-kernel mappings. */
@@ -217,14 +235,15 @@ static unsigned int new_pgdir(struct lgu
 
 void guest_new_pagetable(struct lguest *lg, u32 pgtable)
 {
-	int newpgdir;
+	int newpgdir, repin = 0;
 
 	newpgdir = find_pgdir(lg, pgtable);
 	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
-		newpgdir = new_pgdir(lg, pgtable);
+		newpgdir = new_pgdir(lg, pgtable, &repin);
 	lg->pgdidx = newpgdir;
 	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
-	pin_stack_pages(lg);
+	if (repin)
+		pin_stack_pages(lg);
 }
 
 static void release_all_pagetables(struct lguest *lg)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
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
