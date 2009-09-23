From: akpm@linux-foundation.org
Subject: [merged] spi-omap2_mcspi-use-bitn.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:37 -0700
Message-ID: <200909231957.n8NJvbE4007300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834AbZIWUAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jouni.hogander@nokia.com, dbrownell@users.sourceforge.net, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     spi: omap2_mcspi use BIT(n)
has been removed from the -mm tree.  Its filename was
     spi-omap2_mcspi-use-bitn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: omap2_mcspi use BIT(n)
From: Jouni Hogander <jouni.hogander@nokia.com>

Convert bit shifted values into BIT format

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |   56 ++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-use-bitn drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-use-bitn
+++ a/drivers/spi/omap2_mcspi.c
@@ -59,40 +59,40 @@
 
 /* per-register bitmasks: */
 
-#define OMAP2_MCSPI_SYSCONFIG_SMARTIDLE	(2 << 3)
-#define OMAP2_MCSPI_SYSCONFIG_ENAWAKEUP	(1 << 2)
-#define OMAP2_MCSPI_SYSCONFIG_AUTOIDLE	(1 << 0)
-#define OMAP2_MCSPI_SYSCONFIG_SOFTRESET	(1 << 1)
-
-#define OMAP2_MCSPI_SYSSTATUS_RESETDONE	(1 << 0)
-
-#define OMAP2_MCSPI_MODULCTRL_SINGLE	(1 << 0)
-#define OMAP2_MCSPI_MODULCTRL_MS	(1 << 2)
-#define OMAP2_MCSPI_MODULCTRL_STEST	(1 << 3)
+#define OMAP2_MCSPI_SYSCONFIG_SMARTIDLE	BIT(4)
+#define OMAP2_MCSPI_SYSCONFIG_ENAWAKEUP	BIT(2)
+#define OMAP2_MCSPI_SYSCONFIG_AUTOIDLE	BIT(0)
+#define OMAP2_MCSPI_SYSCONFIG_SOFTRESET	BIT(1)
+
+#define OMAP2_MCSPI_SYSSTATUS_RESETDONE	BIT(0)
+
+#define OMAP2_MCSPI_MODULCTRL_SINGLE	BIT(0)
+#define OMAP2_MCSPI_MODULCTRL_MS	BIT(2)
+#define OMAP2_MCSPI_MODULCTRL_STEST	BIT(3)
 
-#define OMAP2_MCSPI_CHCONF_PHA		(1 << 0)
-#define OMAP2_MCSPI_CHCONF_POL		(1 << 1)
+#define OMAP2_MCSPI_CHCONF_PHA		BIT(0)
+#define OMAP2_MCSPI_CHCONF_POL		BIT(1)
 #define OMAP2_MCSPI_CHCONF_CLKD_MASK	(0x0f << 2)
-#define OMAP2_MCSPI_CHCONF_EPOL		(1 << 6)
+#define OMAP2_MCSPI_CHCONF_EPOL		BIT(6)
 #define OMAP2_MCSPI_CHCONF_WL_MASK	(0x1f << 7)
-#define OMAP2_MCSPI_CHCONF_TRM_RX_ONLY	(0x01 << 12)
-#define OMAP2_MCSPI_CHCONF_TRM_TX_ONLY	(0x02 << 12)
+#define OMAP2_MCSPI_CHCONF_TRM_RX_ONLY	BIT(12)
+#define OMAP2_MCSPI_CHCONF_TRM_TX_ONLY	BIT(13)
 #define OMAP2_MCSPI_CHCONF_TRM_MASK	(0x03 << 12)
-#define OMAP2_MCSPI_CHCONF_DMAW		(1 << 14)
-#define OMAP2_MCSPI_CHCONF_DMAR		(1 << 15)
-#define OMAP2_MCSPI_CHCONF_DPE0		(1 << 16)
-#define OMAP2_MCSPI_CHCONF_DPE1		(1 << 17)
-#define OMAP2_MCSPI_CHCONF_IS		(1 << 18)
-#define OMAP2_MCSPI_CHCONF_TURBO	(1 << 19)
-#define OMAP2_MCSPI_CHCONF_FORCE	(1 << 20)
-
-#define OMAP2_MCSPI_CHSTAT_RXS		(1 << 0)
-#define OMAP2_MCSPI_CHSTAT_TXS		(1 << 1)
-#define OMAP2_MCSPI_CHSTAT_EOT		(1 << 2)
+#define OMAP2_MCSPI_CHCONF_DMAW		BIT(14)
+#define OMAP2_MCSPI_CHCONF_DMAR		BIT(15)
+#define OMAP2_MCSPI_CHCONF_DPE0		BIT(16)
+#define OMAP2_MCSPI_CHCONF_DPE1		BIT(17)
+#define OMAP2_MCSPI_CHCONF_IS		BIT(18)
+#define OMAP2_MCSPI_CHCONF_TURBO	BIT(19)
+#define OMAP2_MCSPI_CHCONF_FORCE	BIT(20)
+
+#define OMAP2_MCSPI_CHSTAT_RXS		BIT(0)
+#define OMAP2_MCSPI_CHSTAT_TXS		BIT(1)
+#define OMAP2_MCSPI_CHSTAT_EOT		BIT(2)
 
-#define OMAP2_MCSPI_CHCTRL_EN		(1 << 0)
+#define OMAP2_MCSPI_CHCTRL_EN		BIT(0)
 
-#define OMAP2_MCSPI_WAKEUPENABLE_WKEN	(1 << 0)
+#define OMAP2_MCSPI_WAKEUPENABLE_WKEN	BIT(0)
 
 /* We have 2 DMA channels per CS, one for RX and one for TX */
 struct omap2_mcspi_dma {
_

Patches currently in -mm which might be from jouni.hogander@nokia.com are

origin.patch

