From: akpm@linux-foundation.org
Subject: - x86-use-dev_printk-in-quirk-message.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:05:24 -0700
Message-ID: <200810222005.m9MK5Ocu013259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbYJVUF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     x86: use dev_printk in quirk message
has been removed from the -mm tree.  Its filename was
     x86-use-dev_printk-in-quirk-message.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: use dev_printk in quirk message
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Change a VIA PCI quirk to use dev_info() rather than printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/pci-dma.c~x86-use-dev_printk-in-quirk-message arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-use-dev_printk-in-quirk-message
+++ a/arch/x86/kernel/pci-dma.c
@@ -269,8 +269,7 @@ fs_initcall(pci_iommu_init);
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO "PCI: VIA PCI bridge detected."
-				 "Disabling DAC.\n");
+		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
 		forbid_dac = 1;
 	}
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-use-dev_printk-in-quirk-message.patch
agp-follow-lspci-device-vendor-style.patch
git-ia64.patch

