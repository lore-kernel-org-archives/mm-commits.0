From: akpm@linux-foundation.org
Subject: - lguest-dont-crash-host-on-nmi.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:49 -0700
Message-ID: <200703292314.l2TNEnwr014725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934367AbXC2XO4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: don't crash host on NMI
has been removed from the -mm tree.  Its filename was
     lguest-dont-crash-host-on-nmi.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: don't crash host on NMI
From: Rusty Russell <rusty@rustcorp.com.au>

"handle" NMI by ignoring it.  Can't have been important, right?  As the
lguest64 hackers explained, handling NMI is a PITA.  Now oprofile does
not crash machine.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/hypervisor.S |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/i386/lguest/hypervisor.S~lguest-dont-crash-host-on-nmi arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S~lguest-dont-crash-host-on-nmi
+++ a/arch/i386/lguest/hypervisor.S
@@ -116,6 +116,11 @@ deliver_to_host:
 	orl	%eax, %edx
 	jmp	*%edx
 
+/* We ignore NMI and return. */
+handle_nmi:
+	addl	$8, %esp
+	iret
+
 /* Real hardware interrupts are delivered straight to the host.  Others
    cause us to return to run_guest_once so it can decide what to do.  Note
    that some of these are overridden by the guest to deliver directly, and
@@ -148,8 +153,7 @@ deliver_to_host:
 default_idt_entries:
 .text
 	IRQ_STUBS 0 1 return_to_host		/* First two traps */
-/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
-	IRQ_STUB 2 deliver_to_host		/* NMI */
+	IRQ_STUB 2 handle_nmi			/* NMI */
 	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
 	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
 	IRQ_STUB 128 return_to_host		/* System call (overridden) */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
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
