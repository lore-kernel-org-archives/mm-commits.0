From: akpm@linux-foundation.org
Subject: - pci-follow-lspci-device-vendor-style.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:51 -0700
Message-ID: <200809022041.m82Kfpl1011667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYIBUly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: follow lspci device/vendor style
has been removed from the -mm tree.  Its filename was
     pci-follow-lspci-device-vendor-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: follow lspci device/vendor style
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format used by
lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_pci.c |    2 +-
 drivers/pci/probe.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/pcie/portdrv_pci.c~pci-follow-lspci-device-vendor-style drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pci-follow-lspci-device-vendor-style
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -91,7 +91,7 @@ static int __devinit pcie_portdrv_probe 
 	
 	pci_set_master(dev);
         if (!dev->irq && dev->pin) {
-		dev_warn(&dev->dev, "device [%04x/%04x] has invalid IRQ; "
+		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
 	if (pcie_port_device_register(dev)) {
diff -puN drivers/pci/probe.c~pci-follow-lspci-device-vendor-style drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-follow-lspci-device-vendor-style
+++ a/drivers/pci/probe.c
@@ -757,7 +757,7 @@ static int pci_setup_device(struct pci_d
 	dev->class = class;
 	class >>= 8;
 
-	dev_dbg(&dev->dev, "found [%04x/%04x] class %06x header type %02x\n",
+	dev_dbg(&dev->dev, "found [%04x:%04x] class %06x header type %02x\n",
 		 dev->vendor, dev->device, class, dev->hdr_type);
 
 	/* "Unknown power state" */
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-use-dev_printk-in-quirk-message.patch
agp-follow-lspci-device-vendor-style.patch
irda-follow-lspci-device-vendor-style.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
pnp-remove-printk-with-outdated-version.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

