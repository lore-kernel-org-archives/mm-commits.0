From: akpm@linux-foundation.org
Subject: + lguest-guest-code-warning-fixes.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:17:03 -0700
Message-ID: <200703272017.l2RKH4wm026797@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbXC0URK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest warning fixes
has been added to the -mm tree.  Its filename is
     lguest-guest-code-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest warning fixes
From: Rusty Russell <rusty@rustcorp.com.au>

The prototype for paravirt_ops write_lgt_entry, write_gdt_entry and
write_idt_entry was type-corrected, so change lguest to match.  We can
also use the "write_dt_entry" which was exported by that same cleanup
patch, rather than write our own.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/lguest.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff -puN arch/i386/lguest/lguest.c~lguest-guest-code-warning-fixes arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c~lguest-guest-code-warning-fixes
+++ a/arch/i386/lguest/lguest.c
@@ -362,30 +362,24 @@ static void __init lguest_init_IRQ(void)
 	irq_ctx_init(smp_processor_id());
 }
 
-static inline void native_write_dt_entry(void *dt, int entry, u32 entry_low, u32 entry_high)
-{
-	u32 *lp = (u32 *)((char *)dt + entry*8);
-	lp[0] = entry_low;
-	lp[1] = entry_high;
-}
-
-static fastcall void lguest_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
+static fastcall void lguest_write_ldt_entry(struct desc_struct *dt,
+					    int entrynum, u32 low, u32 high)
 {
 	/* FIXME: Allow this. */
 	BUG();
 }
 
-static fastcall void lguest_write_gdt_entry(void *dt, int entrynum,
-					   u32 low, u32 high)
+static fastcall void lguest_write_gdt_entry(struct desc_struct *dt,
+					    int entrynum, u32 low, u32 high)
 {
-	native_write_dt_entry(dt, entrynum, low, high);
+	write_dt_entry(dt, entrynum, low, high);
 	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
 }
 
-static fastcall void lguest_write_idt_entry(void *dt, int entrynum,
-					   u32 low, u32 high)
+static fastcall void lguest_write_idt_entry(struct desc_struct *dt,
+					    int entrynum, u32 low, u32 high)
 {
-	native_write_dt_entry(dt, entrynum, low, high);
+	write_dt_entry(dt, entrynum, low, high);
 	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
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
