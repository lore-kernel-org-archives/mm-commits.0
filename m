From: akpm@linux-foundation.org
Subject: + spi-use-menuconfig-for-config_spi.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:53:35 -0800
Message-ID: <200802132353.m1DNrZSI020621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763459AbYBMXxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.guido@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi: use menuconfig for CONFIG_SPI
has been added to the -mm tree.  Its filename is
     spi-use-menuconfig-for-config_spi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: use menuconfig for CONFIG_SPI
From: Alessandro Guido <alessandro.guido@gmail.com>

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/spi/Kconfig~spi-use-menuconfig-for-config_spi drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-use-menuconfig-for-config_spi
+++ a/drivers/spi/Kconfig
@@ -5,11 +5,9 @@
 # nobody's needed a slave side API yet.  The master-role API is not
 # fully appropriate there, so it'd need some thought to do well.
 #
-menu "SPI support"
-	depends on HAS_IOMEM
-
-config SPI
+menuconfig SPI
 	bool "SPI support"
+	depends on HAS_IOMEM
 	help
 	  The "Serial Peripheral Interface" is a low level synchronous
 	  protocol.  Chips that support SPI can have data transfer rates
@@ -28,9 +26,11 @@ config SPI
 	  (half duplex), SSP, SSI, and PSP.  This driver framework should
 	  work with most such devices and controllers.
 
+if SPI
+
 config SPI_DEBUG
 	boolean "Debug support for SPI drivers"
-	depends on SPI && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	help
 	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
 	  sysfs, and debugfs support in SPI controller and protocol drivers.
@@ -245,5 +245,4 @@ config SPI_TLE62X0
 
 # (slave support would go here)
 
-endmenu # "SPI support"
-
+endif # SPI
_

Patches currently in -mm which might be from alessandro.guido@gmail.com are

spi-use-menuconfig-for-config_spi.patch
