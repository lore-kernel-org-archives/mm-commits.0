From: akpm@linux-foundation.org
Subject: [merged] pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:39 -0700
Message-ID: <200906121822.n5CIMduq031399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759188AbZFLS0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci pm: follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3
has been removed from the -mm tree.  Its filename was
     pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci pm: follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3
From: Rafael J. Wysocki <rjw@sisk.pl>

According to the PCI PM specification (PCI Bus Power Management Interface
Specification, Rev.  1.2, Section 5.4.1) we are supposed to reinitialize
devices that have PCI_PM_CTRL_NO_SOFT_RESET clear during all transitions
from PCI_D3hot to PCI_D0, but we only do it if the device's current_state
field is equal to PCI_UNKNOWN.

This may lead to problems if a device with PCI_PM_CTRL_NO_SOFT_RESET unset
is put into PCI_D3hot at run time by its driver and pci_set_power_state()
is used to put it back into PCI_D0, because in that case the device will
remain uninitialized after pci_set_power_state() has returned.  Prevent
that from happening by modifying pci_raw_set_power_state() to reinitialize
devices with PCI_PM_CTRL_NO_SOFT_RESET unset during all transitions from
D3 to D0.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pci/pci.c~pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3 drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3
+++ a/drivers/pci/pci.c
@@ -485,6 +485,8 @@ static int pci_raw_set_power_state(struc
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= state;
 		break;
+	case PCI_D3hot:
+	case PCI_D3cold:
 	case PCI_UNKNOWN: /* Boot-up */
 		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) == PCI_D3hot
 		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET))
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
shrink_slab-handle-bad-shrinkers.patch

