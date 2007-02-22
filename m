From: akpm@linux-foundation.org
Subject: - cleanup-make-hvc_consolec-compile-on-non-powerpc.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:42:17 -0800
Message-ID: <200702220242.l1M2gHsd002179@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXBVCmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     cleanup: Make hvc_console.c compile on non-PowerPC
has been removed from the -mm tree.  Its filename was
     cleanup-make-hvc_consolec-compile-on-non-powerpc.patch

This patch was dropped because it's reappeared in the Xen patches too

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

cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
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
