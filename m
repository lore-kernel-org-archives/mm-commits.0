From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-video-logo.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:42 -0700
Message-ID: <200705090302.l4932ggF010869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033321AbXEIDCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@gmx.de, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II: video/logo
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-video-logo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II: video/logo
From: Jan Engelhardt <jengelh@gmx.de>

Change Kconfig objects from "menu, config" into "menuconfig" so that the user
can disable the whole feature without having to enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Kconfig |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff -puN drivers/video/logo/Kconfig~use-menuconfig-objects-ii-video-logo drivers/video/logo/Kconfig
--- a/drivers/video/logo/Kconfig~use-menuconfig-objects-ii-video-logo
+++ a/drivers/video/logo/Kconfig
@@ -2,73 +2,69 @@
 # Logo configuration
 #
 
-menu "Logo configuration"
-
-config LOGO
+menuconfig LOGO
 	bool "Bootup logo"
 	depends on FB || SGI_NEWPORT_CONSOLE
 	help
 	  Enable and select frame buffer bootup logos.
 
+if LOGO
+
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
-	depends on LOGO
 	default y
 
 config LOGO_LINUX_VGA16
 	bool "Standard 16-color Linux logo"
-	depends on LOGO
 	default y
 
 config LOGO_LINUX_CLUT224
 	bool "Standard 224-color Linux logo"
-	depends on LOGO
 	default y
 
 config LOGO_DEC_CLUT224
 	bool "224-color Digital Equipment Corporation Linux logo"
-	depends on LOGO && (MACH_DECSTATION || ALPHA)
+	depends on MACH_DECSTATION || ALPHA
 	default y
 
 config LOGO_MAC_CLUT224
 	bool "224-color Macintosh Linux logo"
-	depends on LOGO && MAC
+	depends on MAC
 	default y
 
 config LOGO_PARISC_CLUT224
 	bool "224-color PA-RISC Linux logo"
-	depends on LOGO && PARISC
+	depends on PARISC
 	default y
 
 config LOGO_SGI_CLUT224
 	bool "224-color SGI Linux logo"
-	depends on LOGO && (SGI_IP22 || SGI_IP27 || SGI_IP32 || X86_VISWS)
+	depends on SGI_IP22 || SGI_IP27 || SGI_IP32 || X86_VISWS
 	default y
 
 config LOGO_SUN_CLUT224
 	bool "224-color Sun Linux logo"
-	depends on LOGO && SPARC
+	depends on SPARC
 	default y
 
 config LOGO_SUPERH_MONO
 	bool "Black and white SuperH Linux logo"
-	depends on LOGO && SUPERH
+	depends on SUPERH
 	default y
 
 config LOGO_SUPERH_VGA16
 	bool "16-color SuperH Linux logo"
-	depends on LOGO && SUPERH
+	depends on SUPERH
 	default y
 
 config LOGO_SUPERH_CLUT224
 	bool "224-color SuperH Linux logo"
-	depends on LOGO && SUPERH
+	depends on SUPERH
 	default y
 
 config LOGO_M32R_CLUT224
 	bool "224-color M32R Linux logo"
-	depends on LOGO && M32R
+	depends on M32R
 	default y
 
-endmenu
-
+endif # LOGO
_

Patches currently in -mm which might be from jengelh@gmx.de are

origin.patch
git-dvb.patch
git-watchdog.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
