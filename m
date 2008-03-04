From: akpm@linux-foundation.org
Subject: - pci-use-dev_printk-in-quirk-messages.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:32 -0800
Message-ID: <200803042009.m24K9WrI026761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763397AbYCDUJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:09:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci: use dev_printk in quirk messages
has been removed from the -mm tree.  Its filename was
     pci-use-dev_printk-in-quirk-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use dev_printk in quirk messages
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert quirk printks to dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/pci/quirks.c~pci-use-dev_printk-in-quirk-messages drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-use-dev_printk-in-quirk-messages
+++ a/drivers/pci/quirks.c
@@ -1652,9 +1652,8 @@ static void __devinit quirk_via_cx700_pc
 			pci_write_config_byte(dev, 0x75, 0x1);
 			pci_write_config_byte(dev, 0x77, 0x0);
 
-			printk(KERN_INFO
-				"PCI: VIA CX700 PCI parking/caching fixup on %s\n",
-				pci_name(dev));
+			dev_info(&dev->dev,
+				"Disabling VIA CX700 PCI parking/caching\n");
 		}
 	}
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pci-simplify-quirk-debug-output.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch

