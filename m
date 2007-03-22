From: akpm@linux-foundation.org
Subject: + lguest-clean-up-some-references-inittext-warnings-2.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:32:28 -0700
Message-ID: <200703222132.l2MLWSJ6030857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965414AbXCVVcd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: clean rest of linkage warnings (bar one)
has been added to the -mm tree.  Its filename is
     lguest-clean-up-some-references-inittext-warnings-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: clean rest of linkage warnings (bar one)
From: Rusty Russell <rusty@rustcorp.com.au>

My previous warning fix broke lguest if your text size wasn't correct to
make the __start_paravirtprobe aligned correctly.  Put the separate
paravirtprobe section back, but inside the init section so it gets
discarded.

It also fixes the remaining warnings, except one.  The code in modpost.c
which needs to be taught that it's legal to link from .paravirtprobe to
.init.text is horrible, and I'm pretty sure I'd just make it worse.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmlinux.lds.S |   12 ++++++------
 arch/i386/lguest/core.c        |    2 +-
 arch/i386/lguest/lg.h          |    2 +-
 arch/i386/lguest/lguest.c      |    5 +++--
 arch/i386/lguest/page_tables.c |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~lguest-clean-up-some-references-inittext-warnings-2 arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~lguest-clean-up-some-references-inittext-warnings-2
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -145,12 +145,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-	*(.init.data)
-  	__start_paravirtprobe = .;
-	*(.paravirtprobe)
-  	__stop_paravirtprobe = .;
-  }
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
   	__setup_start = .;
@@ -178,6 +173,11 @@ SECTIONS
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
diff -puN arch/i386/lguest/core.c~lguest-clean-up-some-references-inittext-warnings-2 arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-clean-up-some-references-inittext-warnings-2
+++ a/arch/i386/lguest/core.c
@@ -112,7 +112,7 @@ free_some_pages:
 	return err;
 }
 
-static __exit void unmap_hypervisor(void)
+static void unmap_hypervisor(void)
 {
 	unsigned int i;
 
diff -puN arch/i386/lguest/lg.h~lguest-clean-up-some-references-inittext-warnings-2 arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-clean-up-some-references-inittext-warnings-2
+++ a/arch/i386/lguest/lg.h
@@ -38,7 +38,7 @@ struct lguest_regs
 	u32 ss;
 };
 
-__exit void free_pagetables(void);
+void free_pagetables(void);
 __init int init_pagetables(struct page **hype_page, int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
diff -puN arch/i386/lguest/lguest.c~lguest-clean-up-some-references-inittext-warnings-2 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c~lguest-clean-up-some-references-inittext-warnings-2
+++ a/arch/i386/lguest/lguest.c
@@ -550,7 +550,7 @@ static __attribute_used__ __init void lg
 	start_kernel();
 }
 
-asm(".section .init.text\n"
+asm(".pushsection .init.text,\"ax\",@progbits\n"
     "lguest_maybe_init:\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EBP)", %ebp\n"
     "	jne 1f\n"
@@ -558,6 +558,7 @@ asm(".section .init.text\n"
     "	jne 1f\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_ESI)", %esi\n"
     "	je lguest_init\n"
-    "1: ret");
+    "1: ret\n"
+    ".popsection");
 extern void asmlinkage lguest_maybe_init(void);
 paravirt_probe(lguest_maybe_init);
diff -puN arch/i386/lguest/page_tables.c~lguest-clean-up-some-references-inittext-warnings-2 arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-clean-up-some-references-inittext-warnings-2
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
lguest-clean-up-some-references-inittext-warnings.patch
lguest-clean-up-some-references-inittext-warnings-2.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
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
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
