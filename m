From: akpm@linux-foundation.org
Subject: + serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:01:18 -0800
Message-ID: <200712032301.lB3N1ICP022007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXLCXBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, ralf@linux-mips.org


The patch titled
     serial: use SGI_HAS_ZILOG for IP22_ZILOG depends
has been added to the -mm tree.  Its filename is
     serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-mips.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
