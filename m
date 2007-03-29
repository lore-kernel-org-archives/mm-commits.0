From: akpm@linux-foundation.org
Subject: - lguest-clean-up-some-references-inittext-warnings.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:37 -0700
Message-ID: <200703292314.l2TNEb6r014710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42328 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934360AbXC2XOn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: clean up some "references .init.text" warnings
has been removed from the -mm tree.  Its filename was
     lguest-clean-up-some-references-inittext-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: clean up some "references .init.text" warnings
From: Rusty Russell <rusty@rustcorp.com.au>

Thanks to Andrew for pointing these out.

This patch moves the parvirtprobe section into .init.data: it's only used in
very very early boot, and for similar reasons, puts lguest_maybe_init and
lguest_memory_setup in init.text.

As well as fixing some warnings, this frees up a tiny bit more memory.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmlinux.lds.S |   11 +++++------
 arch/i386/lguest/core.c        |    2 +-
 arch/i386/lguest/lg.h          |    2 +-
 arch/i386/lguest/lguest.c      |    8 +++++---
 arch/i386/lguest/page_tables.c |    2 +-
 5 files changed, 13 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~lguest-clean-up-some-references-inittext-warnings arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~lguest-clean-up-some-references-inittext-warnings
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -81,12 +81,6 @@ SECTIONS
 	CONSTRUCTORS
 	} :data
 
-  .paravirtprobe : AT(ADDR(.paravirtprobe) - LOAD_OFFSET) {
-  	__start_paravirtprobe = .;
-	*(.paravirtprobe)
-  	__stop_paravirtprobe = .;
-  }
-
   . = ALIGN(4096);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
@@ -179,6 +173,11 @@ SECTIONS
 	*(.altinstr_replacement)
   }
   . = ALIGN(4);
+  .paravirtprobe : AT(ADDR(.paravirtprobe) - LOAD_OFFSET) {
+ 	__start_paravirtprobe = .;
+	*(.paravirtprobe)
+  	__stop_paravirtprobe = .;
+  }
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
   	__start_parainstructions = .;
 	*(.parainstructions)
diff -puN arch/i386/lguest/core.c~lguest-clean-up-some-references-inittext-warnings arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-clean-up-some-references-inittext-warnings
+++ a/arch/i386/lguest/core.c
@@ -112,7 +112,7 @@ free_some_pages:
 	return err;
 }
 
-static __exit void unmap_hypervisor(void)
+static void unmap_hypervisor(void)
 {
 	unsigned int i;
 
diff -puN arch/i386/lguest/lg.h~lguest-clean-up-some-references-inittext-warnings arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-clean-up-some-references-inittext-warnings
+++ a/arch/i386/lguest/lg.h
@@ -38,7 +38,7 @@ struct lguest_regs
 	u32 ss;
 };
 
-__exit void free_pagetables(void);
+void free_pagetables(void);
 __init int init_pagetables(struct page **hype_page, int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
diff -puN arch/i386/lguest/lguest.c~lguest-clean-up-some-references-inittext-warnings arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c~lguest-clean-up-some-references-inittext-warnings
+++ a/arch/i386/lguest/lguest.c
@@ -137,7 +137,7 @@ static struct notifier_block paniced = {
 	.notifier_call = lguest_panic
 };
 
-static char *lguest_memory_setup(void)
+static __init char *lguest_memory_setup(void)
 {
 	/* We do this here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
@@ -550,13 +550,15 @@ static __attribute_used__ __init void lg
 	start_kernel();
 }
 
-asm("lguest_maybe_init:\n"
+asm(".pushsection .init.text,\"ax\",@progbits\n"
+    "lguest_maybe_init:\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EBP)", %ebp\n"
     "	jne 1f\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EDI)", %edi\n"
     "	jne 1f\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_ESI)", %esi\n"
     "	je lguest_init\n"
-    "1: ret");
+    "1: ret\n"
+    ".popsection");
 extern void asmlinkage lguest_maybe_init(void);
 paravirt_probe(lguest_maybe_init);
diff -puN arch/i386/lguest/page_tables.c~lguest-clean-up-some-references-inittext-warnings arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-clean-up-some-references-inittext-warnings
+++ a/arch/i386/lguest/page_tables.c
@@ -377,7 +377,7 @@ __init int init_pagetables(struct page *
 	return 0;
 }
 
-__exit void free_pagetables(void)
+void free_pagetables(void)
 {
 	free_hypervisor_pte_pages();
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
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
