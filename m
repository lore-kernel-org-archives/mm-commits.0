From: akpm@linux-foundation.org
Subject: + skge-adapt-skge-to-use-reworked-pci-pm.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:49:40 -0700
Message-ID: <200808182149.m7ILnfoV014604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335AbYHRVuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org, jeff@garzik.org, shemminger@linux-foundation.org


The patch titled
     skge: adapt skge to use reworked PCI PM
has been added to the -mm tree.  Its filename is
     skge-adapt-skge-to-use-reworked-pci-pm.patch

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
Subject: skge: adapt skge to use reworked PCI PM
From: Rafael J. Wysocki <rjw@sisk.pl>

Adapt the skge driver to the reworked PCI PM

* Use device_set_wakeup_enable() and friends as needed
* Remove an open-coded reference to the standard PCI PM registers
* Use pci_prepare_to_sleep() and pci_back_from_sleep() in the
  ->suspend() and ->resume() callbacks
* Use the observation that it is sufficient to call pci_enable_wake()
  once, unless it fails

Tested on Asus L5D (Yukon-Lite rev 7).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |   38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff -puN drivers/net/skge.c~skge-adapt-skge-to-use-reworked-pci-pm drivers/net/skge.c
--- a/drivers/net/skge.c~skge-adapt-skge-to-use-reworked-pci-pm
+++ a/drivers/net/skge.c
@@ -149,24 +149,6 @@ static u32 wol_supported(const struct sk
 	return WAKE_MAGIC | WAKE_PHY;
 }
 
-static u32 pci_wake_enabled(struct pci_dev *dev)
-{
-	int pm = pci_find_capability(dev, PCI_CAP_ID_PM);
-	u16 value;
-
-	/* If device doesn't support PM Capabilities, but request is to disable
-	 * wake events, it's a nop; otherwise fail */
-	if (!pm)
-		return 0;
-
-	pci_read_config_word(dev, pm + PCI_PM_PMC, &value);
-
-	value &= PCI_PM_CAP_PME_MASK;
-	value >>= ffs(PCI_PM_CAP_PME_MASK) - 1;   /* First bit of mask */
-
-	return value != 0;
-}
-
 static void skge_wol_init(struct skge_port *skge)
 {
 	struct skge_hw *hw = skge->hw;
@@ -254,10 +236,14 @@ static int skge_set_wol(struct net_devic
 	struct skge_port *skge = netdev_priv(dev);
 	struct skge_hw *hw = skge->hw;
 
-	if (wol->wolopts & ~wol_supported(hw))
+	if ((wol->wolopts & ~wol_supported(hw))
+	    || !device_can_wakeup(&hw->pdev->dev))
 		return -EOPNOTSUPP;
 
 	skge->wol = wol->wolopts;
+
+	device_set_wakeup_enable(&hw->pdev->dev, skge->wol);
+
 	return 0;
 }
 
@@ -3842,7 +3828,7 @@ static struct net_device *skge_devinit(s
 	skge->speed = -1;
 	skge->advertising = skge_supported_modes(hw);
 
-	if (pci_wake_enabled(hw->pdev))
+	if (device_may_wakeup(&hw->pdev->dev))
 		skge->wol = wol_supported(hw) & WAKE_MAGIC;
 
 	hw->dev[port] = dev;
@@ -4068,8 +4054,8 @@ static int skge_suspend(struct pci_dev *
 	}
 
 	skge_write32(hw, B0_IMSK, 0);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), wol);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	pci_prepare_to_sleep(pdev);
 
 	return 0;
 }
@@ -4082,7 +4068,7 @@ static int skge_resume(struct pci_dev *p
 	if (!hw)
 		return 0;
 
-	err = pci_set_power_state(pdev, PCI_D0);
+	err = pci_back_from_sleep(pdev);
 	if (err)
 		goto out;
 
@@ -4090,8 +4076,6 @@ static int skge_resume(struct pci_dev *p
 	if (err)
 		goto out;
 
-	pci_enable_wake(pdev, PCI_D0, 0);
-
 	err = skge_reset(hw);
 	if (err)
 		goto out;
@@ -4132,8 +4116,8 @@ static void skge_shutdown(struct pci_dev
 		wol |= skge->wol;
 	}
 
-	pci_enable_wake(pdev, PCI_D3hot, wol);
-	pci_enable_wake(pdev, PCI_D3cold, wol);
+	if (pci_enable_wake(pdev, PCI_D3cold, wol))
+		pci_enable_wake(pdev, PCI_D3hot, wol);
 
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
shrink_slab-handle-bad-shrinkers.patch

