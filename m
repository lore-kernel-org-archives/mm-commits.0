From: akpm@linux-foundation.org
Subject: + pci-pcie-portdrv-remove-unnecessary-function.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:17:19 -0800
Message-ID: <200901152317.n0FNHJnW020785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763655AbZAOXRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org


The patch titled
     PCI PCIe portdrv: remove unnecessary function
has been added to the -mm tree.  Its filename is
     pci-pcie-portdrv-remove-unnecessary-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI PCIe portdrv: remove unnecessary function
From: Rafael J. Wysocki <rjw@sisk.pl>

The function pcie_portdrv_save_config() in portdrv_pci.c is not necessary.
 Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_pci.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-remove-unnecessary-function drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-remove-unnecessary-function
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -32,11 +32,6 @@ MODULE_LICENSE("GPL");
 /* global data */
 static const char device_name[] = "pcieport-driver";
 
-static int pcie_portdrv_save_config(struct pci_dev *dev)
-{
-	return pci_save_state(dev);
-}
-
 static int pcie_portdrv_restore_config(struct pci_dev *dev)
 {
 	int retval;
@@ -102,7 +97,7 @@ static int __devinit pcie_portdrv_probe 
 	if (status)
 		return status;
 
-	pcie_portdrv_save_config(dev);
+	pci_save_state(dev);
 
 	pci_enable_pcie_error_reporting(dev);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

maintainers-add-entry-for-freezer.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
pci-pcie-portdrv-use-driver-data-to-simplify-code.patch
pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2.patch
pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2.patch
pci-pcie-portdrv-remove-unnecessary-function.patch
pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2.patch
pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3.patch
pci-pcie-portdrv-implement-pm-object.patch
pci-pcie-portdrv-fix-allocation-of-interrupts-rev-3.patch
shrink_slab-handle-bad-shrinkers.patch

