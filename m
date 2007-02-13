From: akpm@linux-foundation.org
Subject: + cleanup-make-hvc_consolec-compile-on-non-powerpc.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:08 -0800
Message-ID: <200702130703.l1D738ea024511@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbXBMHDP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     cleanup: Make hvc_console.c compile on non-PowerPC
has been added to the -mm tree.  Its filename is
     cleanup-make-hvc_consolec-compile-on-non-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup: Make hvc_console.c compile on non-PowerPC
From: Rusty Russell <rusty@rustcorp.com.au>

There's a really nice console helper (esp.  for virtual console drivers) in
drivers/char/hvc_console.c.  It has only ever been used for PowerPC, though,
so it uses NO_IRQ which is only defined there.

Let's fix that so it's more widely useful.  By, say, lguest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/hvc_console.c~cleanup-make-hvc_consolec-compile-on-non-powerpc drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~cleanup-make-hvc_consolec-compile-on-non-powerpc
+++ a/drivers/char/hvc_console.c
@@ -49,6 +49,10 @@
 
 #define TIMEOUT		(10)
 
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
+
 /*
  * Wait this long per iteration while trying to push buffered data to the
  * hypervisor before allowing the tty to complete a close operation.
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
