From: akpm@linux-foundation.org
Subject: - lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch removed from -mm tree
Date: Wed, 09 May 2007 02:41:53 -0700
Message-ID: <200705090941.l499fr5E020167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbXEIJmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: 2.6.21-mm1 update: lguest-remove-unnecessary-gdt-load.patch
has been removed from the -mm tree.  Its filename was
     lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: lguest: 2.6.21-mm1 update: lguest-remove-unnecessary-gdt-load.patch
From: Rusty Russell <rusty@rustcorp.com.au>

Andrew did a great job of merging in the PDA->percpu changes and
lguest code for 2.6.21-mm1, but the load_gdt is now unnecessary.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update
+++ a/drivers/lguest/lguest.c
@@ -412,9 +412,6 @@ static unsigned lguest_patch(u8 type, u1
 	return insn_len;
 }
 
-/* From head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
-
 __init void lguest_init(void)
 {
 	paravirt_ops.name = "lguest";
@@ -470,7 +467,6 @@ __init void lguest_init(void)
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
 
-	load_gdt(&early_gdt_descr);
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
 
 	reserve_top_address(lguest_data.reserve_mem);
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
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
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
