From: akpm@linux-foundation.org
Subject: + i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch added to -mm tree
Date: Wed, 21 Mar 2007 17:05:25 -0800
Message-ID: <200703220105.l2M15P73008842@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXCVBFe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 21:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot fix
has been added to the -mm tree.  Its filename is
     i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot fix
From: Rusty Russell <rusty@rustcorp.com.au>

I'll just leave the comment, and try to pretend this never happened 8)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/i386/kernel/head.S~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix
+++ a/arch/i386/kernel/head.S
@@ -601,6 +601,10 @@ ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
 	.long per_cpu__cpu_gdt		/* Overwritten for secondary CPUs */
 
+/*
+ * The boot_gdt_table must mirror the equivalent in setup.S and is
+ * used only for booting.
+ */
 	.align L1_CACHE_BYTES
 ENTRY(boot_gdt_table)
 	.fill GDT_ENTRY_BOOT_CS,8,0
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
