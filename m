From: akpm@linux-foundation.org
Subject: + lguest-the-asm-offsets.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:03:53 -0700
Message-ID: <200704102203.l3AM3r8g018735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbXDJWED (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: the asm offsets
has been added to the -mm tree.  Its filename is
     lguest-the-asm-offsets.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: the asm offsets
From: Rusty Russell <rusty@rustcorp.com.au>

This is the structure offsets required by lg.ko's switcher.S.

Unfortunately we don't have infrastructure for private asm-offsets
creation.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+)

diff -puN arch/i386/kernel/asm-offsets.c~lguest-the-asm-offsets arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~lguest-the-asm-offsets
+++ a/arch/i386/kernel/asm-offsets.c
@@ -16,6 +16,10 @@
 #include <asm/thread_info.h>
 #include <asm/elf.h>
 #include <asm/pda.h>
+#ifdef CONFIG_LGUEST_GUEST
+#include <linux/lguest.h>
+#include "../../../drivers/lguest/lg.h"
+#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -114,4 +118,19 @@ void foo(void)
 	OFFSET(PARAVIRT_iret, paravirt_ops, iret);
 	OFFSET(PARAVIRT_read_cr0, paravirt_ops, read_cr0);
 #endif
+
+#ifdef CONFIG_LGUEST_GUEST
+	BLANK();
+	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
+	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
+	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
+	OFFSET(LGUEST_PAGES_host_sp, lguest_pages, state.host_sp);
+	OFFSET(LGUEST_PAGES_guest_gdt_desc, lguest_pages,state.guest_gdt_desc);
+	OFFSET(LGUEST_PAGES_guest_idt_desc, lguest_pages,state.guest_idt_desc);
+	OFFSET(LGUEST_PAGES_guest_gdt, lguest_pages, state.guest_gdt);
+	OFFSET(LGUEST_PAGES_regs_trapnum, lguest_pages, regs.trapnum);
+	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
+	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
+#endif
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

fix-kernel-oops-with-badly-formatted-module-option.patch
git-kbuild.patch
git-net.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
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
____call_usermodehelper-dont-flush_signals.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
