From: akpm@linux-foundation.org
Subject: - serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:42 -0800
Message-ID: <200802070023.m170NNNl006518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934128AbYBGAom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: use SGI_HAS_ZILOG for IP22_ZILOG depends
has been removed from the -mm tree.  Its filename was
     serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: use SGI_HAS_ZILOG for IP22_ZILOG depends
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

- Use SGI_HAS_ZILOG for IP22_ZILOG depends
- remove IP22 from description, because the driver works on more than
  IP22 SGI machines

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/serial/Kconfig~serial-use-sgi_has_zilog-for-ip22_zilog-depends drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-use-sgi_has_zilog-for-ip22_zilog-depends
+++ a/drivers/serial/Kconfig
@@ -877,15 +877,15 @@ config SERIAL_SUNHV
 	  systems.  Say Y if you want to be able to use this device.
 
 config SERIAL_IP22_ZILOG
-	tristate "IP22 Zilog8530 serial support"
-	depends on SGI_IP22
+	tristate "SGI Zilog8530 serial support"
+	depends on SGI_HAS_ZILOG
 	select SERIAL_CORE
 	help
-	  This driver supports the Zilog8530 serial ports found on SGI IP22
+	  This driver supports the Zilog8530 serial ports found on SGI
 	  systems.  Say Y or M if you want to be able to these serial ports.
 
 config SERIAL_IP22_ZILOG_CONSOLE
-	bool "Console on IP22 Zilog8530 serial port"
+	bool "Console on SGI Zilog8530 serial port"
 	depends on SERIAL_IP22_ZILOG=y
 	select SERIAL_CORE_CONSOLE
 
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
git-scsi-misc.patch
git-watchdog.patch
