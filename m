From: akpm@linux-foundation.org
Subject: [withdrawn] pci-pm-read-device-power-state-from-register-after-updating-it-update.patch removed from -mm tree
Date: Tue, 09 Jun 2009 14:38:06 -0700
Message-ID: <200906092138.n59Lc7QP023785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760534AbZFIV5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 17:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci-pm-read-device-power-state-from-register-after-updating-it-update
has been removed from the -mm tree.  Its filename was
     pci-pm-read-device-power-state-from-register-after-updating-it-update.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-pm-read-device-power-state-from-register-after-updating-it-update
From: Rafael J. Wysocki <rjw@sisk.pl>

After attempting to change the power state of a PCI device
pci_raw_set_power_state() doesn't check if the value it wrote into the
device's PCI_PM_CTRL register has been stored in there.  Still, it
modifies the device's current_state field as though that's the case.  This
may cause the driver of the device to think that its power state has been
changed while in fact it hasn't.

To prevent such situations from happening modify pci_raw_set_power_state()
so that it reads the device's PCI_PM_CTRL register after writing into it
and uses the value read from the register to update the device's
current_state field.  Also make it return -EIO if the new state of the
device is not equal to the state requested by the called.

To distinguish this error condition from the other ones make
pci_raw_set_power_state() return -ENODEV instead of -EIO when it is
impossible to change the power state of the device, because it doesn't
support the native PCI PM at all or the requested target state is not
supported by it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/pci.c~pci-pm-read-device-power-state-from-register-after-updating-it-update drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-pm-read-device-power-state-from-register-after-updating-it-update
+++ a/drivers/pci/pci.c
@@ -451,7 +451,7 @@ static int pci_raw_set_power_state(struc
 		return 0;
 
 	if (!dev->pm_cap)
-		return -ENOSYS;
+		return -ENODEV;
 
 	if (state < PCI_D0 || state > PCI_D3hot)
 		return -EINVAL;
@@ -470,7 +470,7 @@ static int pci_raw_set_power_state(struc
 	/* check if this device supports the desired state */
 	if ((state == PCI_D1 && !dev->d1_support)
 	   || (state == PCI_D2 && !dev->d2_support))
-		return -ENOSYS;
+		return -ENODEV;
 
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-net-macvlanc-fix-cloning-of-tagged-vlan-interfaces.patch
pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3.patch
pci-pm-read-device-power-state-from-register-after-updating-it-update.patch
floppy-fix-hibernation.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
shrink_slab-handle-bad-shrinkers.patch

