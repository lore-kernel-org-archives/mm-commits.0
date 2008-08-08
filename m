From: akpm@linux-foundation.org
Subject: - sky2-adapt-to-use-reworked-pci-pm-code.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:04:18 -0700
Message-ID: <200808082204.m78M4IJt031047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764351AbYHHWFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jeff@garzik.org, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: adapt to use reworked PCI PM code
has been removed from the -mm tree.  Its filename was
     sky2-adapt-to-use-reworked-pci-pm-code.patch

This patch was dropped because of lots of rejects

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sky2: adapt to use reworked PCI PM code
From: Rafael J. Wysocki <rjw@sisk.pl>

Adapt the sky2 driver to use the reworked PCI PM and make it use the
exported PCI PM core functions instead of accessing the PCI PM registers
directly by itself.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   55 ++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff -puN drivers/net/sky2.c~sky2-adapt-to-use-reworked-pci-pm-code drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-adapt-to-use-reworked-pci-pm-code
+++ a/drivers/net/sky2.c
@@ -277,7 +277,6 @@ static void sky2_power_aux(struct sky2_h
 
 static void sky2_power_state(struct sky2_hw *hw, pci_power_t state)
 {
-	u16 power_control = sky2_pci_read16(hw, hw->pm_cap + PCI_PM_CTRL);
 	int pex = pci_find_capability(hw->pdev, PCI_CAP_ID_EXP);
 	u32 reg;
 
@@ -285,19 +284,12 @@ static void sky2_power_state(struct sky2
 
 	switch (state) {
 	case PCI_D0:
-		break;
-
 	case PCI_D1:
-		power_control |= 1;
-		break;
-
 	case PCI_D2:
-		power_control |= 2;
 		break;
 
 	case PCI_D3hot:
 	case PCI_D3cold:
-		power_control |= 3;
 		if (hw->flags & SKY2_HW_ADV_POWER_CTL) {
 			/* additional power saving measurements */
 			reg = sky2_pci_read32(hw, PCI_DEV_REG4);
@@ -347,9 +339,8 @@ static void sky2_power_state(struct sky2
 		return;
 	}
 
-	power_control |= PCI_PM_CTRL_PME_ENABLE;
 	/* Finally, set the new power state. */
-	sky2_pci_write32(hw, hw->pm_cap + PCI_PM_CTRL, power_control);
+	pci_set_power_state(hw->pdev, state);
 
 	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	sky2_pci_read32(hw, B0_CTST);
@@ -3115,7 +3106,8 @@ static int sky2_set_wol(struct net_devic
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
 
-	if (wol->wolopts & ~sky2_wol_supported(sky2->hw))
+	if ((wol->wolopts & ~sky2_wol_supported(sky2->hw))
+	    || !device_can_wakeup(&hw->pdev->dev))
 		return -EOPNOTSUPP;
 
 	sky2->wol = wol->wolopts;
@@ -3126,8 +3118,8 @@ static int sky2_set_wol(struct net_devic
 		sky2_write32(hw, B0_CTST, sky2->wol
 			     ? Y2_HW_WOL_ON : Y2_HW_WOL_OFF);
 
-	if (!netif_running(dev))
-		sky2_wol_init(sky2);
+	device_set_wakeup_enable(&hw->pdev->dev, sky2->wol);
+
 	return 0;
 }
 
@@ -4247,18 +4239,6 @@ static int __devinit sky2_test_msi(struc
 	return err;
 }
 
-static int __devinit pci_wake_enabled(struct pci_dev *dev)
-{
-	int pm  = pci_find_capability(dev, PCI_CAP_ID_PM);
-	u16 value;
-
-	if (!pm)
-		return 0;
-	if (pci_read_config_word(dev, pm + PCI_PM_CTRL, &value))
-		return 0;
-	return value & PCI_PM_CTRL_PME_ENABLE;
-}
-
 /* This driver supports yukon2 chipset only */
 static const char *sky2_name(u8 chipid, char *buf, int sz)
 {
@@ -4319,7 +4299,7 @@ static int __devinit sky2_probe(struct p
 		}
 	}
 
-	wol_default = pci_wake_enabled(pdev) ? WAKE_MAGIC : 0;
+	wol_default = device_may_wakeup(&pdev->dev) ? WAKE_MAGIC : 0;
 
 	err = -ENOMEM;
 	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
@@ -4484,7 +4464,9 @@ static void __devexit sky2_remove(struct
 static int sky2_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct sky2_hw *hw = pci_get_drvdata(pdev);
-	int i, wol = 0;
+	pci_power_t target_state;
+	int i;
+	bool wol = false;
 
 	if (!hw)
 		return 0;
@@ -4500,10 +4482,10 @@ static int sky2_suspend(struct pci_dev *
 		if (netif_running(dev))
 			sky2_down(dev);
 
-		if (sky2->wol)
+		if (sky2->wol) {
+			wol = true;
 			sky2_wol_init(sky2);
-
-		wol |= sky2->wol;
+		}
 	}
 
 	sky2_write32(hw, B0_IMSK, 0);
@@ -4511,8 +4493,10 @@ static int sky2_suspend(struct pci_dev *
 	sky2_power_aux(hw);
 
 	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), wol);
-	sky2_power_state(hw, pci_choose_state(pdev, state));
+
+	target_state = pci_target_state(pdev);
+	pci_enable_wake(pdev, target_state, wol);
+	sky2_power_state(hw, target_state);
 
 	return 0;
 }
@@ -4525,14 +4509,13 @@ static int sky2_resume(struct pci_dev *p
 	if (!hw)
 		return 0;
 
+	pci_enable_wake(pdev, PCI_D0, false);
 	sky2_power_state(hw, PCI_D0);
 
 	err = pci_restore_state(pdev);
 	if (err)
 		goto out;
 
-	pci_enable_wake(pdev, PCI_D0, 0);
