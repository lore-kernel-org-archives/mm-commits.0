From: akpm@linux-foundation.org
Subject: - skty2-adapt-to-the-reworked-pci-pm.patch removed from -mm tree
Date: Thu, 09 Oct 2008 14:54:43 -0700
Message-ID: <200810092154.m99LshTk003892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725AbYJIVzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 17:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, jeff@garzik.org, stephen.hemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     sky2: adapt to the reworked PCI PM
has been removed from the -mm tree.  Its filename was
     skty2-adapt-to-the-reworked-pci-pm.patch

This patch was dropped because other changes broke it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sky2: adapt to the reworked PCI PM
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Adapt the sky2 driver to the reworked PCI PM

* Use device_set_wakeup_enable() and friends as needed
* Remove an open-coded reference to the standard PCI PM registers
* Use pci_prepare_to_sleep() and pci_back_from_sleep() in the
  ->suspend() and ->resume() callbacks
* Use the observation that it is sufficient to call pci_enable_wake()
  once, unless it fails

Tested on Asus M3A32-MVP (Yukon-2 EC Ultra rev 3).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff -puN drivers/net/sky2.c~skty2-adapt-to-the-reworked-pci-pm drivers/net/sky2.c
--- a/drivers/net/sky2.c~skty2-adapt-to-the-reworked-pci-pm
+++ a/drivers/net/sky2.c
@@ -3034,7 +3034,8 @@ static int sky2_set_wol(struct net_devic
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
 
-	if (wol->wolopts & ~sky2_wol_supported(sky2->hw))
+	if ((wol->wolopts & ~sky2_wol_supported(sky2->hw))
+	    || !device_can_wakeup(&hw->pdev->dev))
 		return -EOPNOTSUPP;
 
 	sky2->wol = wol->wolopts;
@@ -3045,6 +3046,8 @@ static int sky2_set_wol(struct net_devic
 		sky2_write32(hw, B0_CTST, sky2->wol
 			     ? Y2_HW_WOL_ON : Y2_HW_WOL_OFF);
 
+	device_set_wakeup_enable(&hw->pdev->dev, sky2->wol);
+
 	if (!netif_running(dev))
 		sky2_wol_init(sky2);
 	return 0;
@@ -4179,18 +4182,6 @@ static int __devinit sky2_test_msi(struc
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
 /*
  * Read and parse the first part of Vital Product Data
  */
@@ -4314,7 +4305,7 @@ static int __devinit sky2_probe(struct p
 		}
 	}
 
-	wol_default = pci_wake_enabled(pdev) ? WAKE_MAGIC : 0;
+	wol_default = device_may_wakeup(&pdev->dev) ? WAKE_MAGIC : 0;
 
 	err = -ENOMEM;
 	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
@@ -4479,7 +4470,7 @@ static void __devexit sky2_remove(struct
 static int sky2_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct sky2_hw *hw = pci_get_drvdata(pdev);
-	int i, wol = 0;
+	int i;
 
 	if (!hw)
 		return 0;
@@ -4497,8 +4488,6 @@ static int sky2_suspend(struct pci_dev *
 
 		if (sky2->wol)
 			sky2_wol_init(sky2);
-
-		wol |= sky2->wol;
 	}
 
 	sky2_write32(hw, B0_IMSK, 0);
@@ -4506,8 +4495,7 @@ static int sky2_suspend(struct pci_dev *
 	sky2_power_aux(hw);
 
 	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), wol);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	pci_prepare_to_sleep(pdev);
 
 	return 0;
 }
@@ -4520,7 +4508,7 @@ static int sky2_resume(struct pci_dev *p
 	if (!hw)
 		return 0;
 
-	err = pci_set_power_state(pdev, PCI_D0);
+	err = pci_back_from_sleep(pdev);
 	if (err)
 		goto out;
 
@@ -4528,8 +4516,6 @@ static int sky2_resume(struct pci_dev *p
 	if (err)
 		goto out;
 
-	pci_enable_wake(pdev, PCI_D0, 0);
-
 	/* Re-enable all clocks */
 	if (hw->chip_id == CHIP_ID_YUKON_EX ||
 	    hw->chip_id == CHIP_ID_YUKON_EC_U ||
@@ -4588,8 +4574,8 @@ static void sky2_shutdown(struct pci_dev
 	if (wol)
 		sky2_power_aux(hw);
 
-	pci_enable_wake(pdev, PCI_D3hot, wol);
-	pci_enable_wake(pdev, PCI_D3cold, wol);
+	if (pci_enable_wake(pdev, PCI_D3cold, wol))
+		pci_enable_wake(pdev, PCI_D3hot, wol);
 
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-tip.patch
git-net-current.patch
git-pci.patch
git-acpi.patch
git-net.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
shrink_slab-handle-bad-shrinkers.patch

