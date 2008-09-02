From: akpm@linux-foundation.org
Subject: - pci-tidy-pme-support-messages.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:49 -0700
Message-ID: <200809022041.m82Kfnio011664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbYIBUlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: tidy PME support messages
has been removed from the -mm tree.  Its filename was
     pci-tidy-pme-support-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: tidy PME support messages
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This patch changes these two messages:

    pci 0000:00:03.0: supports D1
    pci 0000:00:03.0: supports D2

to this:

    pci 0000:00:03.0: supports D1 D2

It also trivially converts a "dev_printk(KERN_INFO, ...)" to
"dev_info(...)".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/pci/pci.c~pci-tidy-pme-support-messages drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-tidy-pme-support-messages
+++ a/drivers/pci/pci.c
@@ -1263,25 +1263,25 @@ void pci_pm_init(struct pci_dev *dev)
 	dev->d1_support = false;
 	dev->d2_support = false;
 	if (!pci_no_d1d2(dev)) {
-		if (pmc & PCI_PM_CAP_D1) {
-			dev_printk(KERN_DEBUG, &dev->dev, "supports D1\n");
+		if (pmc & PCI_PM_CAP_D1)
 			dev->d1_support = true;
-		}
-		if (pmc & PCI_PM_CAP_D2) {
-			dev_printk(KERN_DEBUG, &dev->dev, "supports D2\n");
+		if (pmc & PCI_PM_CAP_D2)
 			dev->d2_support = true;
-		}
+
+		if (dev->d1_support || dev->d2_support)
+			dev_printk(KERN_DEBUG, &dev->dev, "supports%s%s\n",
+				   dev->d1_support ? " D1": "",
+				   dev->d2_support ? " D2": "");
 	}
 
 	pmc &= PCI_PM_CAP_PME_MASK;
 	if (pmc) {
-		dev_printk(KERN_INFO, &dev->dev,
-			"PME# supported from%s%s%s%s%s\n",
-			(pmc & PCI_PM_CAP_PME_D0) ? " D0" : "",
-			(pmc & PCI_PM_CAP_PME_D1) ? " D1" : "",
-			(pmc & PCI_PM_CAP_PME_D2) ? " D2" : "",
-			(pmc & PCI_PM_CAP_PME_D3) ? " D3hot" : "",
-			(pmc & PCI_PM_CAP_PME_D3cold) ? " D3cold" : "");
+		dev_info(&dev->dev, "PME# supported from%s%s%s%s%s\n",
+			 (pmc & PCI_PM_CAP_PME_D0) ? " D0" : "",
+			 (pmc & PCI_PM_CAP_PME_D1) ? " D1" : "",
+			 (pmc & PCI_PM_CAP_PME_D2) ? " D2" : "",
+			 (pmc & PCI_PM_CAP_PME_D3) ? " D3hot" : "",
+			 (pmc & PCI_PM_CAP_PME_D3cold) ? " D3cold" : "");
 		dev->pme_support = pmc >> PCI_PM_CAP_PME_SHIFT;
 		/*
 		 * Make device's PM flags reflect the wake-up capability, but
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

