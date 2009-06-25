From: akpm@linux-foundation.org
Subject: + omapfb-add-fb-manual-update-option-to-kconfig.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:22 -0700
Message-ID: <200906250008.n5P08MEM005261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756445AbZFYAIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@nokia.com, krzysztof.h1@wp.pl


The patch titled
     omapfb: add FB manual update option to Kconfig
has been added to the -mm tree.  Its filename is
     omapfb-add-fb-manual-update-option-to-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omapfb: add FB manual update option to Kconfig
From: Imre Deak <imre.deak@nokia.com>

Also move the controller specific options up in the menu, to a more
logical spot.

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Kconfig |   49 +++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff -puN drivers/video/omap/Kconfig~omapfb-add-fb-manual-update-option-to-kconfig drivers/video/omap/Kconfig
--- a/drivers/video/omap/Kconfig~omapfb-add-fb-manual-update-option-to-kconfig
+++ a/drivers/video/omap/Kconfig
@@ -32,6 +32,36 @@ config FB_OMAP_092M9R
 
 endchoice
 
+config FB_OMAP_LCDC_EXTERNAL
+	bool "External LCD controller support"
+	depends on FB_OMAP
+	help
+	  Say Y here, if you want to have support for boards with an
+	  external LCD controller connected to the SoSSI/RFBI interface.
+
+config FB_OMAP_LCDC_HWA742
+	bool "Epson HWA742 LCD controller support"
+	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
+	help
+	  Say Y here if you want to have support for the external
+	  Epson HWA742 LCD controller.
+
+config FB_OMAP_LCDC_BLIZZARD
+	bool "Epson Blizzard LCD controller support"
+	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
+	help
+	  Say Y here if you want to have support for the external
+	  Epson Blizzard LCD controller.
+
+config FB_OMAP_MANUAL_UPDATE
+	bool "Default to manual update mode"
+	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
+	help
+	  Say Y here, if your user-space applications are capable of
+	  notifying the frame buffer driver when a change has occured in
+	  the frame buffer content and thus a reload of the image data to
+	  the external frame buffer is required. If unsure, say N.
+
 config FB_OMAP_LCD_MIPID
 	bool "MIPI DBI-C/DCS compatible LCD support"
 	depends on FB_OMAP && SPI_MASTER
@@ -69,23 +99,4 @@ config FB_OMAP_DMA_TUNE
           answer yes. Answer no if you have a dedicated video
           memory, or don't use any of the accelerated features.
 
-config FB_OMAP_LCDC_EXTERNAL
-	bool "External LCD controller support"
-	depends on FB_OMAP
-	help
-	  Say Y here, if you want to have support for boards with an
-	  external LCD controller connected to the SoSSI/RFBI interface.
 
-config FB_OMAP_LCDC_HWA742
-	bool "Epson HWA742 LCD controller support"
-	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
-	help
-	  Say Y here if you want to have support for the external
-	  Epson HWA742 LCD controller.
-
-config FB_OMAP_LCDC_BLIZZARD
-	bool "Epson Blizzard LCD controller support"
-	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
-	help
-	  Say Y here if you want to have support for the external
-	  Epson Blizzard LCD controller.
_

Patches currently in -mm which might be from imre.deak@nokia.com are

origin.patch
linux-next.patch
omapfb-add-support-for-the-apollon-lcd.patch
omapfb-add-support-for-mipi-dcs-compatible-lcds.patch
omapfb-add-support-for-the-amstrad-delta-lcd.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-3430sdp-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
omapfb-add-support-for-the-gumstix-overo-lcd.patch
omapfb-add-support-for-the-zoom-mdk-lcd.patch
omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch
n770-enable-lcd-mipi-dcs-in-kconfig.patch
omapfb-dispc-various-typo-fixes.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-dispc-allow-multiple-external-irq-handlers.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch
omapfb-fix-coding-style-remove-dead-line.patch
omapfb-add-fb-manual-update-option-to-kconfig.patch
omapfb-hwa742-fix-pointer-to-be-const.patch

