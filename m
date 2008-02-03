From: akpm@linux-foundation.org
Subject: - sky2-wake-on-lan-configuration-issues.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:41 -0800
Message-ID: <200802032022.m13KMMpZ030006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYBCUWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, supersud501@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     sky2: wake-on-lan configuration issues
has been removed from the -mm tree.  Its filename was
     sky2-wake-on-lan-configuration-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sky2: wake-on-lan configuration issues
From: Stephen Hemminger <shemminger@linux-foundation.org>

This patch disables config mode access after clearing PCI settings.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Tested-by: supersud501 <supersud501@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-wake-on-lan-configuration-issues drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-wake-on-lan-configuration-issues
+++ a/drivers/net/sky2.c
@@ -623,6 +623,7 @@ static void sky2_phy_power(struct sky2_h
 	static const u32 phy_power[] = { PCI_Y2_PHY1_POWD, PCI_Y2_PHY2_POWD };
 	static const u32 coma_mode[] = { PCI_Y2_PHY1_COMA, PCI_Y2_PHY2_COMA };
 
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 	/* Turn on/off phy power saving */
 	if (onoff)
@@ -634,7 +635,8 @@ static void sky2_phy_power(struct sky2_h
 		reg1 |= coma_mode[port];
 
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
-	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
+	sky2_pci_read32(hw, PCI_DEV_REG1);
 
 	udelay(100);
 }
@@ -2436,6 +2438,7 @@ static void sky2_hw_intr(struct sky2_hw 
 	if (status & (Y2_IS_MST_ERR | Y2_IS_IRQ_STAT)) {
 		u16 pci_err;
 
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		pci_err = sky2_pci_read16(hw, PCI_STATUS);
 		if (net_ratelimit())
 			dev_err(&pdev->dev, "PCI hardware error (0x%x)\n",
@@ -2443,12 +2446,14 @@ static void sky2_hw_intr(struct sky2_hw 
 
 		sky2_pci_write16(hw, PCI_STATUS,
 				      pci_err | PCI_STATUS_ERROR_BITS);
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	}
 
 	if (status & Y2_IS_PCI_EXP) {
 		/* PCI-Express uncorrectable Error occurred */
 		u32 err;
 
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		err = sky2_read32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS);
 		sky2_write32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS,
 			     0xfffffffful);
@@ -2456,6 +2461,7 @@ static void sky2_hw_intr(struct sky2_hw 
 			dev_err(&pdev->dev, "PCI Express error (0x%x)\n", err);
 
 		sky2_read32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS);
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	}
 
 	if (status & Y2_HWE_L1_MASK)
@@ -2831,6 +2837,7 @@ static void sky2_reset(struct sky2_hw *h
 	}
 
 	sky2_power_on(hw);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 
 	for (i = 0; i < hw->ports; i++) {
 		sky2_write8(hw, SK_REG(i, GMAC_LINK_CTRL), GMLC_RST_SET);
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-input.patch
git-net.patch
if-0-pci_cleanup_aer_correct_error_status.patch
