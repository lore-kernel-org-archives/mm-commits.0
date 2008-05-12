From: akpm@linux-foundation.org
Subject: + atl1-fix-broken-suspend-and-resume.patch added to -mm tree
Date: Mon, 12 May 2008 15:23:31 -0700
Message-ID: <200805122223.m4CMNVeM012123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340AbYELWYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: fix broken suspend and resume
has been added to the -mm tree.  Its filename is
     atl1-fix-broken-suspend-and-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atl1: fix broken suspend and resume
From: Jay Cliburn <jacliburn@bellsouth.net>

Fix atl1_suspend() and atl1_resume() so they actually work.  We'll use the
suspend function for wake-on-lan in addition to just suspending.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atlx/atl1.c |  123 ++++++++++++++++++++++++--------------
 1 file changed, 79 insertions(+), 44 deletions(-)

diff -puN drivers/net/atlx/atl1.c~atl1-fix-broken-suspend-and-resume drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atl1-fix-broken-suspend-and-resume
+++ a/drivers/net/atlx/atl1.c
@@ -2781,64 +2781,93 @@ static int atl1_suspend(struct pci_dev *
 	struct atl1_hw *hw = &adapter->hw;
 	u32 ctrl = 0;
 	u32 wufc = adapter->wol;
+	u32 val;
+	int retval;
+	u16 speed;
+	u16 duplex;
 
 	netif_device_detach(netdev);
 	if (netif_running(netdev))
 		atl1_down(adapter);
 
+	retval = pci_save_state(pdev);
+	if (retval)
+		return retval;
+
 	atl1_read_phy_reg(hw, MII_BMSR, (u16 *) & ctrl);
 	atl1_read_phy_reg(hw, MII_BMSR, (u16 *) & ctrl);
-	if (ctrl & BMSR_LSTATUS)
+	val = ctrl & BMSR_LSTATUS;
+	if (val)
 		wufc &= ~ATLX_WUFC_LNKC;
 
-	/* reduce speed to 10/100M */
-	if (wufc) {
-		atl1_phy_enter_power_saving(hw);
-		/* if resume, let driver to re- setup link */
-		hw->phy_configured = false;
-		atl1_set_mac_addr(hw);
-		atlx_set_multi(netdev);
+	if (val && wufc) {
+		val = atl1_get_speed_and_duplex(hw, &speed, &duplex);
+		if (val) {
+			if (netif_msg_ifdown(adapter))
+				dev_printk(KERN_DEBUG, &pdev->dev,
+					"error getting speed/duplex\n");
+			goto disable_wol;
+		}
 
 		ctrl = 0;
-		/* turn on magic packet wol */
-		if (wufc & ATLX_WUFC_MAG)
-			ctrl = WOL_MAGIC_EN | WOL_MAGIC_PME_EN;
 
-		/* turn on Link change WOL */
-		if (wufc & ATLX_WUFC_LNKC)
-			ctrl |= (WOL_LINK_CHG_EN | WOL_LINK_CHG_PME_EN);
+		/* enable magic packet WOL */
+		if (wufc & ATLX_WUFC_MAG)
+			ctrl |= (WOL_MAGIC_EN | WOL_MAGIC_PME_EN);
 		iowrite32(ctrl, hw->hw_addr + REG_WOL_CTRL);
+		ioread32(hw->hw_addr + REG_WOL_CTRL);
 
-		/* turn on all-multi mode if wake on multicast is enabled */
-		ctrl = ioread32(hw->hw_addr + REG_MAC_CTRL);
-		ctrl &= ~MAC_CTRL_DBG;
-		ctrl &= ~MAC_CTRL_PROMIS_EN;
-		if (wufc & ATLX_WUFC_MC)
-			ctrl |= MAC_CTRL_MC_ALL_EN;
-		else
-			ctrl &= ~MAC_CTRL_MC_ALL_EN;
-
-		/* turn on broadcast mode if wake on-BC is enabled */
-		if (wufc & ATLX_WUFC_BC)
+		/* configure the mac */
+		ctrl = MAC_CTRL_RX_EN;
+		ctrl |= ((u32)((speed == SPEED_1000) ? MAC_CTRL_SPEED_1000 :
+			MAC_CTRL_SPEED_10_100) << MAC_CTRL_SPEED_SHIFT);
+		if (duplex == FULL_DUPLEX)
+			ctrl |= MAC_CTRL_DUPLX;
+		ctrl |= (((u32)adapter->hw.preamble_len &
+			MAC_CTRL_PRMLEN_MASK) << MAC_CTRL_PRMLEN_SHIFT);
+		if (adapter->vlgrp)
+			ctrl |= MAC_CTRL_RMV_VLAN;
+		if (wufc & ATLX_WUFC_MAG)
 			ctrl |= MAC_CTRL_BC_EN;
-		else
-			ctrl &= ~MAC_CTRL_BC_EN;
-
-		/* enable RX */
-		ctrl |= MAC_CTRL_RX_EN;
 		iowrite32(ctrl, hw->hw_addr + REG_MAC_CTRL);
-		pci_enable_wake(pdev, PCI_D3hot, 1);
-		pci_enable_wake(pdev, PCI_D3cold, 1);
-	} else {
-		iowrite32(0, hw->hw_addr + REG_WOL_CTRL);
-		pci_enable_wake(pdev, PCI_D3hot, 0);
-		pci_enable_wake(pdev, PCI_D3cold, 0);
+		ioread32(hw->hw_addr + REG_MAC_CTRL);
+
+		/* poke the PHY */
+		ctrl = ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
+		ctrl |= PCIE_PHYMISC_FORCE_RCV_DET;
+		iowrite32(ctrl, hw->hw_addr + REG_PCIE_PHYMISC);
+		ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
+
+		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
+		goto exit;
 	}
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
+	if (!val && wufc) {
+		ctrl |= (WOL_LINK_CHG_EN | WOL_LINK_CHG_PME_EN);
+		iowrite32(ctrl, hw->hw_addr + REG_WOL_CTRL);
+		ioread32(hw->hw_addr + REG_WOL_CTRL);
+		iowrite32(0, hw->hw_addr + REG_MAC_CTRL);
+		ioread32(hw->hw_addr + REG_MAC_CTRL);
+		hw->phy_configured = false;
+		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
+		goto exit;
+	}
 
-	pci_set_power_state(pdev, PCI_D3hot);
+disable_wol:
+	iowrite32(0, hw->hw_addr + REG_WOL_CTRL);
+	ioread32(hw->hw_addr + REG_WOL_CTRL);
+	ctrl = ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
+	ctrl |= PCIE_PHYMISC_FORCE_RCV_DET;
+	iowrite32(ctrl, hw->hw_addr + REG_PCIE_PHYMISC);
+	ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
+	atl1_phy_enter_power_saving(hw);
+	hw->phy_configured = false;
+	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
+exit:
+	if (netif_running(netdev))
+		pci_disable_msi(adapter->pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
@@ -2852,20 +2881,26 @@ static int atl1_resume(struct pci_dev *p
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	/* FIXME: check and handle */
 	err = pci_enable_device(pdev);
+	if (err) {
+		if (netif_msg_ifup(adapter))
+			dev_printk(KERN_DEBUG, &pdev->dev,
+				"error enabling pci device\n");
+		return err;
+	}
+
+	pci_set_master(pdev);
+	iowrite32(0, adapter->hw.hw_addr + REG_WOL_CTRL);
 	pci_enable_wake(pdev, PCI_D3hot, 0);
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
-	iowrite32(0, adapter->hw.hw_addr + REG_WOL_CTRL);
-	atl1_reset(adapter);
+	atl1_reset_hw(&adapter->hw);
+	adapter->cmb.cmb->int_stats = 0;
 
 	if (netif_running(netdev))
 		atl1_up(adapter);
 	netif_device_attach(netdev);
 
-	atl1_via_workaround(adapter);
