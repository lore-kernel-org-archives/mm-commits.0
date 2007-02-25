From: akpm@linux-foundation.org
Subject: + pci-allow-multiple-calls-to-pcim_pin_device.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:36:01 -0800
Message-ID: <200702251236.l1PCa3G6029387@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35011 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbXBYMgJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, greg@kroah.com, ian.mcdonald@jandi.co.nz


The patch titled
     pci: allow multiple calls to pcim_pin_device()
has been added to the -mm tree.  Its filename is
     pci-allow-multiple-calls-to-pcim_pin_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: allow multiple calls to pcim_pin_device()
From: Tejun Heo <htejun@gmail.com>

Sanity check in pcim_pin_device() was too restrictive in that it didn't
allow multiple calls to the function, which is against the devres
philosohpy of fire-and-forget.  Track pinned status separately and allow
pinning multiple times.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/pci/pci.c~pci-allow-multiple-calls-to-pcim_pin_device drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-allow-multiple-calls-to-pcim_pin_device
+++ a/drivers/pci/pci.c
@@ -757,7 +757,8 @@ int pci_enable_device(struct pci_dev *de
  * when a device is enabled using managed PCI device enable interface.
  */
 struct pci_devres {
-	unsigned int disable:1;
+	unsigned int enabled:1;
+	unsigned int pinned:1;
 	unsigned int orig_intx:1;
 	unsigned int restore_intx:1;
 	u32 region_mask;
@@ -781,7 +782,7 @@ static void pcim_release(struct device *
 	if (this->restore_intx)
 		pci_intx(dev, this->orig_intx);
 
-	if (this->disable)
+	if (this->enabled && !this->pinned)
 		pci_disable_device(dev);
 }
 
@@ -820,12 +821,12 @@ int pcim_enable_device(struct pci_dev *p
 	dr = get_pci_dr(pdev);
 	if (unlikely(!dr))
 		return -ENOMEM;
-	WARN_ON(!!dr->disable);
+	WARN_ON(!!dr->enabled);
 
 	rc = pci_enable_device(pdev);
 	if (!rc) {
 		pdev->is_managed = 1;
-		dr->disable = 1;
+		dr->enabled = 1;
 	}
 	return rc;
 }
@@ -843,9 +844,9 @@ void pcim_pin_device(struct pci_dev *pde
 	struct pci_devres *dr;
 
 	dr = find_pci_dr(pdev);
-	WARN_ON(!dr || !dr->disable);
+	WARN_ON(!dr || !dr->enabled);
 	if (dr)
-		dr->disable = 0;
+		dr->pinned = 1;
 }
 
 /**
@@ -876,7 +877,7 @@ pci_disable_device(struct pci_dev *dev)
 
 	dr = find_pci_dr(dev);
 	if (dr)
-		dr->disable = 0;
+		dr->enabled = 0;
 
 	if (atomic_sub_return(1, &dev->enable_cnt) != 0)
 		return;
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
acpi-driver-support-for-pata-fix.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
pci-allow-multiple-calls-to-pcim_pin_device.patch
