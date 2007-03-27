From: akpm@linux-foundation.org
Subject: - i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:04:44 -0800
Message-ID: <200703270604.l2R64ilV008967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41100 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbXC0GEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot fix
has been removed from the -mm tree.  Its filename was
     i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch

This patch was dropped because it was folded into i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch

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

git-kbuild.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
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
