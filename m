From: akpm@linux-foundation.org
Subject: + skge-adapt-skge-to-use-reworked-pci-pm.patch added to -mm tree
Date: Sun, 20 Jul 2008 18:59:43 -0700
Message-ID: <200807210159.m6L1xhwN011865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293AbYGUCBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 22:01:17 -0400
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

Adapt the skge driver to use the reworked PCI PM.

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
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
remove-include-linux-pm_legacyh.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-remaining-obsolete-definitions-from-pmh.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
pm-drop-unnecessary-includes-from-pmh.patch
pm-add-new-pm_event-codes-for-runtime-power-transitions.patch
pm-hibernation-simplify-memory-bitmap.patch
pm-serio-speed-up-resume.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
pm-acpi-hibernation-utilize-hardware-signature.patch
pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error.patch
pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
shrink_slab-handle-bad-shrinkers.patch
pci-pm-make-more-pci-pm-core-functionality-available-to-drivers.patch
tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch
sky2-adapt-sky2-to-use-reworked-pci-pm.patch

