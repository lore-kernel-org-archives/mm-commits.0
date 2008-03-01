From: akpm@linux-foundation.org
Subject: + pci-use-dev_printk-in-quirk-messages.patch added to -mm tree
Date: Fri, 29 Feb 2008 16:06:53 -0800
Message-ID: <200803010006.m2106rfE027631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYCAAHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, greg@kroah.com


The patch titled
     pci: use dev_printk in quirk messages
has been added to the -mm tree.  Its filename is
     pci-use-dev_printk-in-quirk-messages.patch

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
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
pci-simplify-quirk-debug-output.patch
pci-consolidate-duplicated-msi-enable-functions.patch
pci-use-dev_printk-in-quirk-messages.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch

