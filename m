From: akpm@linux-foundation.org
Subject: - dz-update-kconfig-description.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:21 -0800
Message-ID: <200802080806.m18862sK014399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759624AbYBHITk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: update kconfig description
has been removed from the -mm tree.  Its filename was
     dz-update-kconfig-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
