From: akpm@linux-foundation.org
Subject: + pnp-use-dev_printk-for-quirk-messages.patch added to -mm tree
Date: Tue, 04 Mar 2008 16:05:41 -0800
Message-ID: <200803050005.m2505fv0005045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763736AbYCEAFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 19:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com


The patch titled
     PNP: use dev_printk for quirk messages
has been added to the -mm tree.  Its filename is
     pnp-use-dev_printk-for-quirk-messages.patch

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
Subject: PNP: use dev_printk for quirk messages
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert quirk printks to dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-use-dev_printk-for-quirk-messages drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-use-dev_printk-for-quirk-messages
+++ a/drivers/pnp/quirks.c
@@ -51,7 +51,8 @@ static void quirk_awe32_resources(struct
 		port3->min += 0x800;
 		port3->max += 0x800;
 	}
-	printk(KERN_INFO "pnp: AWE32 quirk - adding two ports\n");
+	dev_info(&dev->dev, "AWE32 quirk - added ioports 0x%lx and 0x%lx\n",
+		(unsigned long) port2->min, (unsigned long) port3->min);
 }
 
 static void quirk_cmi8330_resources(struct pnp_dev *dev)
@@ -74,7 +75,8 @@ static void quirk_cmi8330_resources(stru
 			    IORESOURCE_DMA_8BIT)
 				dma->map = 0x000A;
 	}
-	printk(KERN_INFO "pnp: CMI8330 quirk - fixing interrupts and dma\n");
+	dev_info(&dev->dev, "CMI8330 quirk - forced possible IRQs to 5, 7, 10 "
+		"and DMA channels to 1, 3\n");
 }
 
 static void quirk_sb16audio_resources(struct pnp_dev *dev)
@@ -105,8 +107,7 @@ static void quirk_sb16audio_resources(st
 		changed = 1;
 	}
 	if (changed)
-		printk(KERN_INFO
-		       "pnp: SB audio device quirk - increasing port range\n");
+		dev_info(&dev->dev, "SB audio device quirk - increased port range\n");
 }
 
 static void quirk_supermicro_h8dce_system(struct pnp_dev *dev)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pci-simplify-quirk-debug-output.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch

