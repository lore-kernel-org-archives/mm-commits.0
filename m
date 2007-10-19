From: akpm@linux-foundation.org
Subject: + dz-rename-the-serial-console-structure.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:26:04 -0700
Message-ID: <200710192126.l9JLQ486020946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934052AbXJSV0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz: rename the serial console structure
has been added to the -mm tree.  Its filename is
     dz-rename-the-serial-console-structure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dz: rename the serial console structure
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Rename the serial console structure so that `modpost' does not complain about
a reference to an "init" section -- "_console" is magic.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/serial/dz.c~dz-rename-the-serial-console-structure drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-rename-the-serial-console-structure
+++ a/drivers/serial/dz.c
@@ -744,7 +744,7 @@ static int __init dz_console_setup(struc
 }
 
 static struct uart_driver dz_reg;
-static struct console dz_sercons = {
+static struct console dz_console = {
 	.name	= "ttyS",
 	.write	= dz_console_print,
 	.device	= uart_console_device,
@@ -758,7 +758,7 @@ static int __init dz_serial_console_init
 {
 	if (!IOASIC) {
 		dz_init_ports();
-		register_console(&dz_sercons);
+		register_console(&dz_console);
 		return 0;
 	} else
 		return -ENXIO;
@@ -766,7 +766,7 @@ static int __init dz_serial_console_init
 
 console_initcall(dz_serial_console_init);
 
-#define SERIAL_DZ_CONSOLE	&dz_sercons
+#define SERIAL_DZ_CONSOLE	&dz_console
 #else
 #define SERIAL_DZ_CONSOLE	NULL
 #endif /* CONFIG_SERIAL_DZ_CONSOLE */
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
