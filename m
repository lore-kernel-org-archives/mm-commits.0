From: akpm@linux-foundation.org
Subject: + dz-update-kconfig-description.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:26:01 -0700
Message-ID: <200710192126.l9JLQ1o7020943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966588AbXJSV0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz: update kconfig description
has been added to the -mm tree.  Its filename is
     dz-update-kconfig-description.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dz: update kconfig description
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Reformat the Kconfig entries and update descriptions for accuracy.  Select the
driver by default for configurations of interest.  For the curious: 32BIT
means only 32-bit DECstations support the device, not that the driver is not
64-bit clean; I have not checked that either though.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/serial/Kconfig~dz-update-kconfig-description drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~dz-update-kconfig-description
+++ a/drivers/serial/Kconfig
@@ -465,20 +465,24 @@ config SERIAL_DZ
 	bool "DECstation DZ serial driver"
 	depends on MACH_DECSTATION && 32BIT
 	select SERIAL_CORE
-	help
-	  DZ11-family serial controllers for VAXstations, including the
-	  DC7085, M7814, and M7819.
+	default y
+	---help---
+	  DZ11-family serial controllers for DECstations and VAXstations,
+	  including the DC7085, M7814, and M7819.
 
 config SERIAL_DZ_CONSOLE
 	bool "Support console on DECstation DZ serial driver"
 	depends on SERIAL_DZ=y
 	select SERIAL_CORE_CONSOLE
-	help
+	default y
+	---help---
 	  If you say Y here, it will be possible to use a serial port as the
 	  system console (the system console is the device which receives all
 	  kernel messages and warnings and which allows logins in single user
-	  mode).  Note that the firmware uses ttyS0 as the serial console on
-	  the Maxine and ttyS2 on the others.
+	  mode).
+
+	  Note that the firmware uses ttyS3 as the serial console on
+	  DECstations that use this driver.
 
 	  If unsure, say Y.
 
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
