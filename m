From: akpm@linux-foundation.org
Subject: [merged] spi-omap2_mcspi-supports-wake-events.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:35:06 -0700
Message-ID: <200907302035.n6UKZ6Os007541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbZG3Uf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jouni.hogander@nokia.com, dbrownell@users.sourceforge.net, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     spi: omap2_mcspi supports wake events
has been removed from the -mm tree.  Its filename was
     spi-omap2_mcspi-supports-wake-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: omap2_mcspi supports wake events
From: Jouni Hogander <jouni.hogander@nokia.com>

Currently mcspi wake-ups are not enabled.  This might cause cases where
OMAP is not waking up on mcspi events.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-supports-wake-events drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-supports-wake-events
+++ a/drivers/spi/omap2_mcspi.c
@@ -59,6 +59,8 @@
 
 /* per-register bitmasks: */
 
+#define OMAP2_MCSPI_SYSCONFIG_SMARTIDLE	(2 << 3)
+#define OMAP2_MCSPI_SYSCONFIG_ENAWAKEUP	(1 << 2)
 #define OMAP2_MCSPI_SYSCONFIG_AUTOIDLE	(1 << 0)
 #define OMAP2_MCSPI_SYSCONFIG_SOFTRESET	(1 << 1)
 
@@ -90,6 +92,7 @@
 
 #define OMAP2_MCSPI_CHCTRL_EN		(1 << 0)
 
+#define OMAP2_MCSPI_WAKEUPENABLE_WKEN	(1 << 0)
 
 /* We have 2 DMA channels per CS, one for RX and one for TX */
 struct omap2_mcspi_dma {
@@ -873,8 +876,12 @@ static int __init omap2_mcspi_reset(stru
 	} while (!(tmp & OMAP2_MCSPI_SYSSTATUS_RESETDONE));
 
 	mcspi_write_reg(master, OMAP2_MCSPI_SYSCONFIG,
-			/* (3 << 8) | (2 << 3) | */
-			OMAP2_MCSPI_SYSCONFIG_AUTOIDLE);
+			OMAP2_MCSPI_SYSCONFIG_AUTOIDLE |
+			OMAP2_MCSPI_SYSCONFIG_ENAWAKEUP |
+			OMAP2_MCSPI_SYSCONFIG_SMARTIDLE);
+
+	mcspi_write_reg(master, OMAP2_MCSPI_WAKEUPENABLE,
+			OMAP2_MCSPI_WAKEUPENABLE_WKEN);
 
 	omap2_mcspi_set_master_mode(master);
 
_

Patches currently in -mm which might be from jouni.hogander@nokia.com are

origin.patch
spi-omap2_mcspi-use-bitn.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch

