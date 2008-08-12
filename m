From: akpm@linux-foundation.org
Subject: + fbdev-kconfig-update.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:02:17 -0700
Message-ID: <200808120002.m7C02HEK029117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYHLACr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, geert@linux-m68k.org


The patch titled
     fbdev: kconfig update
has been added to the -mm tree.  Its filename is
     fbdev-kconfig-update.patch

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
Subject: fbdev: kconfig update
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Update Kconfig for Permedia 2, Trident and 3Dfx frame buffer drivers.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |   43 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-kconfig-update drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-kconfig-update
+++ a/drivers/video/Kconfig
@@ -259,16 +259,24 @@ config FB_PM2
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	help
-	  This is the frame buffer device driver for the Permedia2 AGP frame
-	  buffer card from ASK, aka `Graphic Blaster Exxtreme'.  There is a
-	  product page at
-	  <http://www.ask.com.hk/product/Permedia%202/permedia2.htm>.
+	  This is the frame buffer device driver for cards based on
+	  the 3D Labs Permedia, Permedia 2 and Permedia 2V chips.
+	  The driver was tested on following cards are:
+		Diamond FireGL 1000 PRO AGP
+		ELSA Gloria Synergy PCI
+		Appian Jeronimo PRO (both heads) PCI
+		3DLabs Oxygen ACX aka EONtronics Picasso P2 PCI
+		Techsource Raptor GFX-8P (aka Sun PGX-32) on SPARC
+		ASK Graphic Blaster Exxtreme AGP
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pm2fb.
 
 config FB_PM2_FIFO_DISCONNECT
 	bool "enable FIFO disconnect feature"
 	depends on FB_PM2 && PCI
 	help
-	  Support the Permedia2 FIFO disconnect feature (see CONFIG_FB_PM2).
+	  Support the Permedia2 FIFO disconnect feature.
 
 config FB_ARMCLCD
 	tristate "ARM PrimeCell PL110 support"
@@ -1545,25 +1553,25 @@ config FB_KYRO
 	  module will be called kyrofb.
 
 config FB_3DFX
-	tristate "3Dfx Banshee/Voodoo3 display support"
+	tristate "3Dfx Banshee/Voodoo3/Voodoo5 display support"
 	depends on FB && PCI
 	select FB_CFB_IMAGEBLIT
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	help
-	  This driver supports graphics boards with the 3Dfx Banshee/Voodoo3
-	  chips. Say Y if you have such a graphics board.
+	  This driver supports graphics boards with the 3Dfx Banshee,
+	  Voodoo3 or VSA-100 (aka Voodoo4/5) chips. Say Y if you have
+	  such a graphics board.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called tdfxfb.
 
 config FB_3DFX_ACCEL
-	bool "3Dfx Banshee/Voodoo3 Acceleration functions (EXPERIMENTAL)"
+	bool "3Dfx Acceleration functions (EXPERIMENTAL)"
 	depends on FB_3DFX && EXPERIMENTAL
 	---help---
-	This will compile the 3Dfx Banshee/Voodoo3 frame buffer device
-	with acceleration functions.
-
+	This will compile the 3Dfx Banshee/Voodoo3/VSA-100 frame buffer
+	device driver with acceleration functions.
 
 config FB_VOODOO1
 	tristate "3Dfx Voodoo Graphics (sst1) support"
@@ -1629,17 +1637,16 @@ config FB_TRIDENT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	---help---
-	  This driver is supposed to support graphics boards with the
-	  Trident CyberXXXX/Image/CyberBlade chips mostly found in laptops
+	  This is the frame buffer device driver for Trident PCI/AGP chipsets.
+	  Supported chipset families are TGUI 9440/96XX, 3DImage, Blade3D
+	  and Blade XP.
+	  There are also integrated versions of these chips called CyberXXXX,
+	  CyberImage or CyberBlade. These chips are mostly found in laptops
 	  but also on some motherboards. For more information, read
 	  <file:Documentation/fb/tridentfb.txt>
 
-	  Cyberblade/i1 support will be removed soon, use the cyblafb driver
-	  instead.
-
 	  Say Y if you have such a graphics board.
 
