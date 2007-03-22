From: akpm@linux-foundation.org
Subject: + lguest-clean-up-some-references-inittext-warnings.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:24:31 -0800
Message-ID: <200703220624.l2M6OVvW013873@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXCVGYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: clean up some "references .init.text" warnings
has been added to the -mm tree.  Its filename is
     lguest-clean-up-some-references-inittext-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/i386/kernel/vmlinux.lds.S |   13 ++++++-------
 arch/i386/lguest/lguest.c      |    5 +++--
 2 files changed, 9 insertions(+), 9 deletions(-)

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
@@ -151,7 +145,12 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+	*(.init.data)
+  	__start_paravirtprobe = .;
+	*(.paravirtprobe)
+  	__stop_paravirtprobe = .;
+  }
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
   	__setup_start = .;
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
@@ -550,7 +550,8 @@ static __attribute_used__ __init void lg
 	start_kernel();
 }
 
-asm("lguest_maybe_init:\n"
+asm(".section .init.text\n"
+    "lguest_maybe_init:\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EBP)", %ebp\n"
     "	jne 1f\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EDI)", %edi\n"
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

make-kvm-conform-to-sucky-rdmsr-interface.patch
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
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
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
cleanup-rationalize-paravirt-wrappers.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
use-x86_eflags_if-in-irqflagsh-lguest.patch
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
