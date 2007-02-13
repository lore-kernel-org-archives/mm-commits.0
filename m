From: akpm@linux-foundation.org
Subject: + cleanup-paravirt-unhandled-fallthrough.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:04 -0800
Message-ID: <200702130703.l1D734Pq024505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56966 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbXBMHDN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     cleanup: paravirt unhandled fallthrough
has been added to the -mm tree.  Its filename is
     cleanup-paravirt-unhandled-fallthrough.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup: paravirt unhandled fallthrough
From: Rusty Russell <rusty@rustcorp.com.au>

The current code simply calls "start_kernel" directly if we're under a
hypervisor and no paravirt_ops backend wants us, because paravirt.c registers
that as a backend.

This was always a vain hope; start_kernel won't get far without setup.  It's
also impossible for paravirt_ops backends which don't sit in the
arch/i386/kernel directory: they can't link before paravirt.o anyway.

Keep it simple: if we pass all the registered paravirt probes, BUG().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile   |    2 --
 arch/i386/kernel/head.S     |    7 ++++++-
 arch/i386/kernel/paravirt.c |    3 ---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/Makefile~cleanup-paravirt-unhandled-fallthrough arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~cleanup-paravirt-unhandled-fallthrough
+++ a/arch/i386/kernel/Makefile
@@ -41,8 +41,6 @@ obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
-
-# Make sure this is linked after any other paravirt_ops structs: see head.S
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 EXTRA_AFLAGS   := -traditional
diff -puN arch/i386/kernel/head.S~cleanup-paravirt-unhandled-fallthrough arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~cleanup-paravirt-unhandled-fallthrough
+++ a/arch/i386/kernel/head.S
@@ -513,10 +513,11 @@ startup_paravirt:
 	pushl	%ecx
 	pushl	%eax
 
-	/* paravirt.o is last in link, and that probe fn never returns */
 	pushl	$__start_paravirtprobe
 1:
 	movl	0(%esp), %eax
+	cmpl	$__stop_paravirtprobe, %eax
+	je	unhandled_paravirt
 	pushl	(%eax)
 	movl	8(%esp), %eax
 	call	*(%esp)
@@ -528,6 +529,10 @@ startup_paravirt:
 
 	addl	$4, (%esp)
 	jmp	1b
+
+unhandled_paravirt:
+	/* Nothing wanted us: we're screwed. */
+	ud2
 #endif
 
 /*
diff -puN arch/i386/kernel/paravirt.c~cleanup-paravirt-unhandled-fallthrough arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~cleanup-paravirt-unhandled-fallthrough
+++ a/arch/i386/kernel/paravirt.c
@@ -482,9 +482,6 @@ static int __init print_banner(void)
 }
 core_initcall(print_banner);
 
-/* We simply declare start_kernel to be the paravirt probe of last resort. */
-paravirt_probe(start_kernel);
-
 struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
