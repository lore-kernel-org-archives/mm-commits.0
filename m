From: akpm@linux-foundation.org
Subject: - sky2-document-gphy_ctrl-bits.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:39 -0700
Message-ID: <200709070042.l870gdxp016053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964843AbXIGAml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:42:41 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l870gdwH026235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 6 Sep 2007 17:42:40 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: document GPHY_CTRL bits
has been removed from the -mm tree.  Its filename was
     sky2-document-gphy_ctrl-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sky2: document GPHY_CTRL bits
From: Stephen Hemminger <shemminger@linux-foundation.org>

Add documentation of GPHY_CTRL register bits even if driver
is not using them (yet).

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+)

diff -puN drivers/net/sky2.h~sky2-document-gphy_ctrl-bits drivers/net/sky2.h
--- a/drivers/net/sky2.h~sky2-document-gphy_ctrl-bits
+++ a/drivers/net/sky2.h
@@ -1846,6 +1846,28 @@ enum {
 
 /*	GPHY_CTRL		32 bit	GPHY Control Reg (YUKON only) */
 enum {
+	GPC_TX_PAUSE	= 1<<30, /* Tx pause enabled (ro) */
+	GPC_RX_PAUSE	= 1<<29, /* Rx pause enabled (ro) */
+	GPC_SPEED	= 3<<27, /* PHY speed (ro) */
+	GPC_LINK	= 1<<26, /* Link up (ro) */
+	GPC_DUPLEX	= 1<<25, /* Duplex (ro) */
+	GPC_CLOCK	= 1<<24, /* 125Mhz clock stable (ro) */
+
+	GPC_PDOWN	= 1<<23, /* Internal regulator 2.5 power down */
+	GPC_TSTMODE	= 1<<22, /* Test mode */
+	GPC_REG18	= 1<<21, /* Reg18 Power down */
+	GPC_REG12SEL	= 3<<19, /* Reg12 power setting */
+	GPC_REG18SEL	= 3<<17, /* Reg18 power setting */
+	GPC_SPILOCK	= 1<<16, /* SPI lock (ASF) */
+
+	GPC_LEDMUX	= 3<<14, /* LED Mux */
+	GPC_INTPOL	= 1<<13, /* Interrupt polarity */
+	GPC_DETECT	= 1<<12, /* Energy detect */
+	GPC_1000HD	= 1<<11, /* Enable 1000Mbit HD */
+	GPC_SLAVE	= 1<<10, /* Slave mode */
+	GPC_PAUSE	= 1<<9, /* Pause enable */
+	GPC_LEDCTL	= 3<<6, /* GPHY Leds */
+
 	GPC_RST_CLR	= 1<<1,	/* Clear GPHY Reset */
 	GPC_RST_SET	= 1<<0,	/* Set   GPHY Reset */
 };
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

pci-x-pci-express-read-control-interfaces-mthca.patch
git-netdev-all.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-use-net_device-internal-stats.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
