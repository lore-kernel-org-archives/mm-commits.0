From: akpm@linux-foundation.org
Subject: + tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch added to -mm tree
Date: Sun, 20 Jul 2008 19:03:26 -0700
Message-ID: <200807210203.m6L23QMF012040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758016AbYGUCEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 22:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org, jeff@garzik.org, shemminger@linux-foundation.org


The patch titled
     tg3: adapt tg3 to use reworked PCI PM code
has been added to the -mm tree.  Its filename is
     tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch

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
Subject: tg3: adapt tg3 to use reworked PCI PM code
From: Rafael J. Wysocki <rjw@sisk.pl>

Adapt the tg3 driver to use the reworked PCI PM and make it use the
exported PCI PM core functions instead of accessing the PCI PM registers
directly by itself.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tg3.c |   67 ++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 39 deletions(-)

diff -puN drivers/net/tg3.c~tg3-adapt-tg3-to-use-reworked-pci-pm-code drivers/net/tg3.c
--- a/drivers/net/tg3.c~tg3-adapt-tg3-to-use-reworked-pci-pm-code
+++ a/drivers/net/tg3.c
@@ -1986,8 +1986,6 @@ static void tg3_power_down_phy(struct tg
 static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 {
 	u32 misc_host_ctrl;
-	u16 power_control, power_caps;
-	int pm = tp->pm_cap;
 
 	/* Make sure register accesses (indirect or otherwise)
 	 * will function correctly.
@@ -1996,18 +1994,10 @@ static int tg3_set_power_state(struct tg
 			       TG3PCI_MISC_HOST_CTRL,
 			       tp->misc_host_ctrl);
 
-	pci_read_config_word(tp->pdev,
-			     pm + PCI_PM_CTRL,
-			     &power_control);
-	power_control |= PCI_PM_CTRL_PME_STATUS;
-	power_control &= ~(PCI_PM_CTRL_STATE_MASK);
 	switch (state) {
 	case PCI_D0:
-		power_control |= 0;
-		pci_write_config_word(tp->pdev,
-				      pm + PCI_PM_CTRL,
-				      power_control);
-		udelay(100);	/* Delay after power state change */
+		pci_enable_wake(tp->pdev, state, false);
+		pci_set_power_state(tp->pdev, PCI_D0);
 
 		/* Switch out of Vaux if it is a NIC */
 		if (tp->tg3_flags2 & TG3_FLG2_IS_NIC)
@@ -2016,26 +2006,15 @@ static int tg3_set_power_state(struct tg
 		return 0;
 
 	case PCI_D1:
-		power_control |= 1;
-		break;
-
 	case PCI_D2:
-		power_control |= 2;
-		break;
-
 	case PCI_D3hot:
-		power_control |= 3;
 		break;
 
 	default:
-		printk(KERN_WARNING PFX "%s: Invalid power state (%d) "
-		       "requested.\n",
-		       tp->dev->name, state);
+		printk(KERN_ERR PFX "%s: Invalid power state (D%d) requested\n",
+			tp->dev->name, state);
 		return -EINVAL;
 	}
-
-	power_control |= PCI_PM_CTRL_PME_ENABLE;
-
 	misc_host_ctrl = tr32(TG3PCI_MISC_HOST_CTRL);
 	tw32(TG3PCI_MISC_HOST_CTRL,
 	     misc_host_ctrl | MISC_HOST_CTRL_MASK_PCI_INT);
@@ -2113,8 +2092,6 @@ static int tg3_set_power_state(struct tg
 						     WOL_DRV_WOL |
 						     WOL_SET_MAGIC_PKT);
 
-	pci_read_config_word(tp->pdev, pm + PCI_PM_PMC, &power_caps);
-
 	if (tp->tg3_flags & TG3_FLAG_WOL_ENABLE) {
 		u32 mac_mode;
 
@@ -2147,8 +2124,8 @@ static int tg3_set_power_state(struct tg
 		if (!(tp->tg3_flags2 & TG3_FLG2_5750_PLUS))
 			tw32(MAC_LED_CTRL, tp->led_ctrl);
 
-		if (((power_caps & PCI_PM_CAP_PME_D3cold) &&
-		     (tp->tg3_flags & TG3_FLAG_WOL_ENABLE)))
+		if (pci_pme_capable(tp->pdev, state) &&
+		     (tp->tg3_flags & TG3_FLAG_WOL_ENABLE))
 			mac_mode |= MAC_MODE_MAGIC_PKT_ENABLE;
 
 		tw32_f(MAC_MODE, mac_mode);
@@ -2240,9 +2217,11 @@ static int tg3_set_power_state(struct tg
 
 	tg3_write_sig_post_reset(tp, RESET_KIND_SHUTDOWN);
 
+	if (tp->tg3_flags & TG3_FLAG_WOL_ENABLE)
+		pci_enable_wake(tp->pdev, state, true);
+
 	/* Finally, set the new power state. */
-	pci_write_config_word(tp->pdev, pm + PCI_PM_CTRL, power_control);
-	udelay(100);	/* Delay after power state change */
+	pci_set_power_state(tp->pdev, state);
 
 	return 0;
 }
@@ -8414,7 +8393,8 @@ static void tg3_get_wol(struct net_devic
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	if (tp->tg3_flags & TG3_FLAG_WOL_CAP)
+	if ((tp->tg3_flags & TG3_FLAG_WOL_CAP) &&
+	    device_can_wakeup(&tp->pdev->dev))
 		wol->supported = WAKE_MAGIC;
 	else
 		wol->supported = 0;
@@ -8427,18 +8407,22 @@ static void tg3_get_wol(struct net_devic
 static int tg3_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct tg3 *tp = netdev_priv(dev);
+	struct device *dp = &tp->pdev->dev;
 
 	if (wol->wolopts & ~WAKE_MAGIC)
 		return -EINVAL;
 	if ((wol->wolopts & WAKE_MAGIC) &&
-	    !(tp->tg3_flags & TG3_FLAG_WOL_CAP))
+	    !((tp->tg3_flags & TG3_FLAG_WOL_CAP) && device_can_wakeup(dp)))
 		return -EINVAL;
 
 	spin_lock_bh(&tp->lock);
-	if (wol->wolopts & WAKE_MAGIC)
+	if (wol->wolopts & WAKE_MAGIC) {
 		tp->tg3_flags |= TG3_FLAG_WOL_ENABLE;
-	else
+		device_set_wakeup_enable(dp, true);
+	} else {
 		tp->tg3_flags &= ~TG3_FLAG_WOL_ENABLE;
+		device_set_wakeup_enable(dp, false);
+	}
 	spin_unlock_bh(&tp->lock);
 
 	return 0;
@@ -10645,7 +10629,8 @@ static void __devinit tg3_get_eeprom_hw_
 		if (val & VCPU_CFGSHDW_ASPM_DBNC)
 			tp->tg3_flags |= TG3_FLAG_ASPM_WORKAROUND;
 		if ((val & VCPU_CFGSHDW_WOL_ENABLE) &&
-		    (val & VCPU_CFGSHDW_WOL_MAGPKT))
+		    (val & VCPU_CFGSHDW_WOL_MAGPKT) &&
+		    device_may_wakeup(&tp->pdev->dev))
 			tp->tg3_flags |= TG3_FLAG_WOL_ENABLE;
 		return;
 	}
@@ -10775,8 +10760,9 @@ static void __devinit tg3_get_eeprom_hw_
 		    !(nic_cfg & NIC_SRAM_DATA_CFG_FIBER_WOL))
 			tp->tg3_flags &= ~TG3_FLAG_WOL_CAP;
 
-		if (tp->tg3_flags & TG3_FLAG_WOL_CAP &&
-		    nic_cfg & NIC_SRAM_DATA_CFG_WOL_ENABLE)
+		if ((tp->tg3_flags & TG3_FLAG_WOL_CAP) &&
+		    (nic_cfg & NIC_SRAM_DATA_CFG_WOL_ENABLE) &&
+		    device_may_wakeup(&tp->pdev->dev))
 			tp->tg3_flags |= TG3_FLAG_WOL_ENABLE;
 
 		if (cfg2 & (1 << 17))
@@ -13004,6 +12990,7 @@ static int tg3_suspend(struct pci_dev *p
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct tg3 *tp = netdev_priv(dev);
+	pci_power_t target_state;
 	int err;
 
 	/* PCI register 4 needs to be saved whether netif_running() or not.
@@ -13032,7 +13019,9 @@ static int tg3_suspend(struct pci_dev *p
 	tp->tg3_flags &= ~TG3_FLAG_INIT_COMPLETE;
 	tg3_full_unlock(tp);
 
-	err = tg3_set_power_state(tp, pci_choose_state(pdev, state));
+	target_state = pdev->pm_cap ? pci_target_state(pdev) : PCI_D3hot;
+
+	err = tg3_set_power_state(tp, target_state);
 	if (err) {
 		int err2;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
pci-pm-make-more-pci-pm-core-functionality-available-to-drivers.patch
tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch
sky2-adapt-sky2-to-use-reworked-pci-pm.patch
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

