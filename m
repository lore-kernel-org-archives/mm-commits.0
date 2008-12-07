From: akpm@linux-foundation.org
Subject: - ricoh_mmc-handle-newer-models-of-ricoh-controllers.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:24 -0800
Message-ID: <200812070005.mB705OYZ021343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbYLGAFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipl@overt.org, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     ricoh_mmc: Handle newer models of Ricoh controllers
has been removed from the -mm tree.  Its filename was
     ricoh_mmc-handle-newer-models-of-ricoh-controllers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ricoh_mmc: Handle newer models of Ricoh controllers
From: Philip Langdale <philipl@overt.org>

The latest generation of laptops are shipping with a newer model of Ricoh
chip where the firewire controller is the primary PCI function but a
cardbus controller is also present.

The existing code assumes that if a cardbus controller is, present, then
it must be the one to manipulate - but the real rule is that you
manipulate PCI function 0.  This patch adds an additional constraint that
the target must be function 0.

Signed-off-by: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/ricoh_mmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-handle-newer-models-of-ricoh-controllers drivers/mmc/host/ricoh_mmc.c
--- a/drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-handle-newer-models-of-ricoh-controllers
+++ a/drivers/mmc/host/ricoh_mmc.c
@@ -146,6 +146,7 @@ static int __devinit ricoh_mmc_probe(str
 		pci_get_device(PCI_VENDOR_ID_RICOH,
 			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
 		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
+		    PCI_FUNC(fw_dev->devfn) == 0 &&
 		    pdev->bus == fw_dev->bus) {
 			if (ricoh_mmc_disable(fw_dev) != 0)
 				return -ENODEV;
@@ -163,6 +164,7 @@ static int __devinit ricoh_mmc_probe(str
 	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
 					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
 		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
+		    PCI_FUNC(fw_dev->devfn) == 0 &&
 		    pdev->bus == fw_dev->bus) {
 			if (ricoh_mmc_disable(fw_dev) != 0)
 				return -ENODEV;
@@ -175,7 +177,7 @@ static int __devinit ricoh_mmc_probe(str
 
 	if (!ctrlfound) {
 		printk(KERN_WARNING DRIVER_NAME
-		       ": Main firewire function not found. Cannot disable controller.\n");
+		       ": Main Ricoh function not found. Cannot disable controller.\n");
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from philipl@overt.org are

linux-next.patch
acpi-toshiba-only-register-rfkill-if-bt-is-enabled.patch

