From: akpm@linux-foundation.org
Subject: [merged] omapfb-add-fb-manual-update-option-to-kconfig.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:00:55 -0700
Message-ID: <200909232000.n8NK0tCl014111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbZIWUKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@nokia.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     omapfb: add FB manual update option to Kconfig
has been removed from the -mm tree.  Its filename was
     omapfb-add-fb-manual-update-option-to-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
