From: akpm@linux-foundation.org
Subject: - sky2-dont-restrict-config-space-access.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:41 -0700
Message-ID: <200709070042.l870gfJh016056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964843AbXIGAmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:42:43 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l870gfNK026240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 6 Sep 2007 17:42:42 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: dont restrict config space access
has been removed from the -mm tree.  Its filename was
     sky2-dont-restrict-config-space-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sky2: dont restrict config space access
From: Stephen Hemminger <shemminger@linux-foundation.org>

Take out the code that protects driver from accessing the PCI config space. 
We are old enough to run with scissors now.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   12 ------------
 1 files changed, 12 deletions(-)

diff -puN drivers/net/sky2.c~sky2-dont-restrict-config-space-access drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-dont-restrict-config-space-access
+++ a/drivers/net/sky2.c
@@ -603,7 +603,6 @@ static void sky2_phy_power(struct sky2_h
 	if (hw->chip_id == CHIP_ID_YUKON_XL && hw->chip_rev > 1)
 		onoff = !onoff;
 
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 	if (onoff)
 		/* Turn off phy power saving */
@@ -613,7 +612,6 @@ static void sky2_phy_power(struct sky2_h
 
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
 	sky2_pci_read32(hw, PCI_DEV_REG1);
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	udelay(100);
 }
 
@@ -681,11 +679,9 @@ static void sky2_wol_init(struct sky2_po
 	sky2_write16(hw, WOL_REGS(port, WOL_CTRL_STAT), ctrl);
 
 	/* Turn on legacy PCI-Express PME mode */
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 	reg1 |= PCI_Y2_PME_LEGACY;
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 
 	/* block receiver */
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
@@ -2386,10 +2382,8 @@ static void sky2_hw_intr(struct sky2_hw 
 			dev_err(&hw->pdev->dev, "PCI hardware error (0x%x)\n",
 			        pci_err);
 
-		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		sky2_pci_write16(hw, PCI_STATUS,
 				 pci_err | PCI_STATUS_ERROR_BITS);
-		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	}
 
 	if (status & Y2_IS_PCI_EXP) {
@@ -2403,11 +2397,8 @@ static void sky2_hw_intr(struct sky2_hw 
 				pex_err);
 
 		/* clear the interrupt */
-		sky2_write32(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		sky2_pci_write32(hw, PEX_UNC_ERR_STAT,
 				       0xffffffffUL);
-		sky2_write32(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
-
 		if (pex_err & PEX_FATAL_ERRORS) {
 			u32 hwmsk = sky2_read32(hw, B0_HWE_IMSK);
 			hwmsk &= ~Y2_IS_PCI_EXP;
@@ -2670,7 +2661,6 @@ static void sky2_reset(struct sky2_hw *h
 	/* clear PCI errors, if any */
 	status = sky2_pci_read16(hw, PCI_STATUS);
 
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	sky2_pci_write16(hw, PCI_STATUS, status | PCI_STATUS_ERROR_BITS);
 
 
@@ -2693,8 +2683,6 @@ static void sky2_reset(struct sky2_hw *h
 				     | GMC_BYP_RETR_ON);
 	}
 
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
-
 	/* Clear I2C IRQ noise */
 	sky2_write32(hw, B2_I2C_IRQ, 1);
 
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
