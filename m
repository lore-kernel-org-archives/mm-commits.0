From: akpm@linux-foundation.org
Subject: - uml-mark-both-consoles-as-con_anytime.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:05 -0800
Message-ID: <200703152156.l2FLu5uG027519@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbXCOV4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: mark both consoles as CON_ANYTIME
has been removed from the -mm tree.  Its filename was
     uml-mark-both-consoles-as-con_anytime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: um: mark both consoles as CON_ANYTIME
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Since both UML consoles do not use percpu variables, they may be called when
the cpu is still offline, and they may be marked CON_ANYTIME (this is
documented in kernel/printk.c, grep for CON_ANYTIME to find mentions of this).

Works well in testing done with lock debug enabled, should be safe but is not
needed for next release.

This would probably help also stderr_console.c, but this is yet to test.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ssl.c           |    2 +-
 arch/um/drivers/stdio_console.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/ssl.c~uml-mark-both-consoles-as-con_anytime arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-mark-both-consoles-as-con_anytime
+++ a/arch/um/drivers/ssl.c
@@ -179,7 +179,7 @@ static struct console ssl_cons = {
 	.write		= ssl_console_write,
 	.device		= ssl_console_device,
 	.setup		= ssl_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER|CON_ANYTIME,
 	.index		= -1,
 };
 
diff -puN arch/um/drivers/stdio_console.c~uml-mark-both-consoles-as-con_anytime arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-mark-both-consoles-as-con_anytime
+++ a/arch/um/drivers/stdio_console.c
@@ -153,7 +153,7 @@ static struct console stdiocons = {
 	.write		= uml_console_write,
 	.device		= uml_console_device,
 	.setup		= uml_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER|CON_ANYTIME,
 	.index		= -1,
 };
 
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
