From: akpm@linux-foundation.org
Subject: + spi-omap2_mcspi-supports-wake-events.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:07:38 -0700
Message-ID: <200907172307.n6HN7ciJ006011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986AbZGQXIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jouni.hogander@nokia.com, dbrownell@users.sourceforge.net, tony@atomide.com


The patch titled
     spi: omap2_mcspi supports wake events
has been added to the -mm tree.  Its filename is
     spi-omap2_mcspi-supports-wake-events.patch

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

spi-omap2_mcspi-supports-wake-events.patch
spi-omap2_mcspi-use-bitn.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch

