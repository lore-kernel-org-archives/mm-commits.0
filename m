From: akpm@linux-foundation.org
Subject: - fbdev-kconfig-update.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:55 -0700
Message-ID: <200810182316.m9INGtio028907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYJRXRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: kconfig update
has been removed from the -mm tree.  Its filename was
     fbdev-kconfig-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: kconfig update
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Update Kconfig for Permedia 2, Trident and 3Dfx frame buffer drivers.

[akpm@linux-foundation.org: fix Kconfig text]
Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |   43 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-kconfig-update drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-kconfig-update
+++ a/drivers/video/Kconfig
@@ -254,16 +254,24 @@ config FB_PM2
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	help
-	  This is the frame buffer device driver for the Permedia2 AGP frame
-	  buffer card from ASK, aka `Graphic Blaster Exxtreme'.  There is a
-	  product page at
-	  <http://www.ask.com.hk/product/Permedia%202/permedia2.htm>.
+	  This is the frame buffer device driver for cards based on
+	  the 3D Labs Permedia, Permedia 2 and Permedia 2V chips.
+	  The driver was tested on the following cards:
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
@@ -1539,25 +1547,25 @@ config FB_KYRO
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
@@ -1622,17 +1630,16 @@ config FB_TRIDENT
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
 
