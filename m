From: akpm@linux-foundation.org
Subject: - dz-rename-the-serial-console-structure.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:23 -0800
Message-ID: <200802080806.m18864Lo014402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761168AbYBHITg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: rename the serial console structure
has been removed from the -mm tree.  Its filename was
     dz-rename-the-serial-console-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
