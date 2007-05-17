From: akpm@linux-foundation.org
Subject: + fbdev-cleanup-of-sparc-fb-options.patch added to -mm tree
Date: Thu, 17 May 2007 12:00:23 -0700
Message-ID: <200705171900.l4HJ0NBg030582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634AbXEQTCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     fbdev: cleanup of sparc FB options
has been added to the -mm tree.  Its filename is
     fbdev-cleanup-of-sparc-fb-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: cleanup of sparc FB options
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch puts all SBUS/UPA selection under one option "SBUS/UPA
framebuffers" and moves all sparc specific drivers next to them in one group.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |  176 +++++++++++++++++++---------------------
 1 files changed, 86 insertions(+), 90 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-cleanup-of-sparc-fb-options drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-cleanup-of-sparc-fb-options
+++ a/drivers/video/Kconfig
@@ -711,6 +711,91 @@ config FB_CG6
 	  This is the frame buffer device driver for the CGsix (GX, TurboGX)
 	  frame buffer.
 
+config FB_FFB
+	bool "Creator/Creator3D/Elite3D support"
+	depends on FB_SBUS && SPARC64
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Creator, Creator3D,
+	  and Elite3D graphics boards.
+
+config FB_TCX
+	bool "TCX (SS4/SS5 only) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the TCX 24/8bit frame
+	  buffer.
+
+config FB_CG14
+	bool "CGfourteen (SX) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the CGfourteen frame
+	  buffer on Desktop SPARCsystems with the SX graphics option.
+
+config FB_P9100
+	bool "P9100 (Sparcbook 3 only) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the P9100 card
+	  supported on Sparcbook 3 machines.
+
+config FB_LEO
+	bool "Leo (ZX) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the SBUS-based Sun ZX
+	  (leo) frame buffer cards.
+
+config FB_IGA
+	bool "IGA 168x display support"
+	depends on FB && SPARC32
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the INTERGRAPHICS 1680 and
+	  successor frame buffer cards.
+
+config FB_XVR500
+	bool "Sun XVR-500 3DLABS Wildcat support"
+	depends on FB && PCI && SPARC64
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the Sun XVR-500 and similar
+	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
+	  only works on sparc64 systems where the system firwmare has
+	  mostly initialized the card already.  It is treated as a
+	  completely dumb framebuffer device.
+
+config FB_XVR2500
+	bool "Sun XVR-2500 3DLABS Wildcat support"
+	depends on FB && PCI && SPARC64
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the Sun XVR-2500 and similar
+	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
+	  only works on sparc64 systems where the system firwmare has
+	  mostly initialized the card already.  It is treated as a
+	  completely dumb framebuffer device.
+
 config FB_PVR2
 	tristate "NEC PowerVR 2 display support"
 	depends on FB && SH_DREAMCAST
@@ -1202,7 +1287,7 @@ config FB_ATY
 config FB_ATY_CT
 	bool "Mach64 CT/VT/GT/LT (incl. 3D RAGE) support"
 	depends on PCI && FB_ATY
-	default y if SPARC64 && FB_PCI
+	default y if SPARC64 && PCI
 	help
 	  Say Y here to support use of ATI's 64-bit Rage boards (or other
 	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
@@ -1491,95 +1576,6 @@ config FB_AU1200
 
 source "drivers/video/geode/Kconfig"
 
-config FB_FFB
-	bool "Creator/Creator3D/Elite3D support"
-	depends on FB_SBUS && SPARC64
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Creator, Creator3D,
-	  and Elite3D graphics boards.
-
-config FB_TCX
-	bool "TCX (SS4/SS5 only) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the TCX 24/8bit frame
-	  buffer.
-
-config FB_CG14
-	bool "CGfourteen (SX) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the CGfourteen frame
-	  buffer on Desktop SPARCsystems with the SX graphics option.
-
-config FB_P9100
-	bool "P9100 (Sparcbook 3 only) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the P9100 card
-	  supported on Sparcbook 3 machines.
-
-config FB_LEO
-	bool "Leo (ZX) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the SBUS-based Sun ZX
-	  (leo) frame buffer cards.
-
-config FB_XVR500
-	bool "Sun XVR-500 3DLABS Wildcat support"
-	depends on (FB = y) && PCI && SPARC64
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the Sun XVR-500 and similar
-	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
-	  only works on sparc64 systems where the system firwmare has
-	  mostly initialized the card already.  It is treated as a
-	  completely dumb framebuffer device.
-
-config FB_XVR2500
-	bool "Sun XVR-2500 3DLABS Wildcat support"
-	depends on (FB = y) && PCI && SPARC64
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the Sun XVR-2500 and similar
-	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
-	  only works on sparc64 systems where the system firwmare has
-	  mostly initialized the card already.  It is treated as a
-	  completely dumb framebuffer device.
-
-config FB_PCI
-	bool "PCI framebuffers"
-	depends on (FB = y) && PCI && SPARC
-
-config FB_IGA
-	bool "IGA 168x display support"
-	depends on SPARC32 && FB_PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the INTERGRAPHICS 1680 and
-	  successor frame buffer cards.
-
 config FB_HIT
 	tristate "HD64461 Frame Buffer support"
 	depends on FB && HD64461
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

fbdev-cleanup-of-sparc-fb-options.patch
pm2fb-rdac_wr-barriers-clean-up.patch
pm3fb-various-fixes.patch
fbcon-smart-blitter-usage-for-scrolling.patch
