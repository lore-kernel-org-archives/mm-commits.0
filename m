From: akpm@linux-foundation.org
Subject: + lguest-dont-crash-host-on-nmi.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:17:21 -0800
Message-ID: <200703110917.l2B9HLE4008572@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40955 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXCKJR3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: don't crash host on NMI
has been added to the -mm tree.  Its filename is
     lguest-dont-crash-host-on-nmi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -148,8 +153,7 @@ irq_stubs:
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

futex-restartable-futex_wait.patch
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
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
