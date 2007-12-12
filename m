From: akpm@linux-foundation.org
Subject: + usb-use-irqf_disabled-for-hcd-interrupt-handlers.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:30:32 -0800
Message-ID: <200712120830.lBC8UWtP001051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941AbXLLIbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:31:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, david-b@pacbell.net, greg@kroah.com


The patch titled
     USB: use IRQF_DISABLED for HCD interrupt handlers
has been added to the -mm tree.  Its filename is
     usb-use-irqf_disabled-for-hcd-interrupt-handlers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB: use IRQF_DISABLED for HCD interrupt handlers
From: Alan Stern <stern@rowland.harvard.edu>

Host controller IRQs are supposed to be serviced with interrupts disabled. 
This patch (as1026) adds an IRQF_DISABLED flag to all the controller
drivers that lack it.  It also replaces the spin_lock_irqsave() and
spin_unlock_irqrestore() calls in uhci_irq() with simple spin_lock() and
spin_unlock().

This fixes Bugzilla #9335.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd-pci.c      |    2 +-
 drivers/usb/host/ehci-fsl.c     |    2 +-
 drivers/usb/host/ohci-ppc-of.c  |    2 +-
 drivers/usb/host/ohci-ssb.c     |    2 +-
 drivers/usb/host/r8a66597-hcd.c |    2 +-
 drivers/usb/host/uhci-hcd.c     |    9 ++++-----
 6 files changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/usb/core/hcd-pci.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers drivers/usb/core/hcd-pci.c
--- a/drivers/usb/core/hcd-pci.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers
+++ a/drivers/usb/core/hcd-pci.c
@@ -125,7 +125,7 @@ int usb_hcd_pci_probe (struct pci_dev *d
 
 	pci_set_master (dev);
 
-	retval = usb_add_hcd (hcd, dev->irq, IRQF_SHARED);
+	retval = usb_add_hcd(hcd, dev->irq, IRQF_DISABLED | IRQF_SHARED);
 	if (retval != 0)
 		goto err4;
 	return retval;
diff -puN drivers/usb/host/ehci-fsl.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers drivers/usb/host/ehci-fsl.c
--- a/drivers/usb/host/ehci-fsl.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers
+++ a/drivers/usb/host/ehci-fsl.c
@@ -122,7 +122,7 @@ int usb_hcd_fsl_probe(const struct hc_dr
 	temp = in_le32(hcd->regs + 0x1a8);
 	out_le32(hcd->regs + 0x1a8, temp | 0x3);
 
-	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
 	if (retval != 0)
 		goto err4;
 	return retval;
diff -puN drivers/usb/host/ohci-ppc-of.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers drivers/usb/host/ohci-ppc-of.c
--- a/drivers/usb/host/ohci-ppc-of.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers
+++ a/drivers/usb/host/ohci-ppc-of.c
@@ -142,7 +142,7 @@ ohci_hcd_ppc_of_probe(struct of_device *
 
 	ohci_hcd_init(ohci);
 
-	rv = usb_add_hcd(hcd, irq, 0);
+	rv = usb_add_hcd(hcd, irq, IRQF_DISABLED);
 	if (rv == 0)
 		return 0;
 
diff -puN drivers/usb/host/ohci-ssb.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers drivers/usb/host/ohci-ssb.c
--- a/drivers/usb/host/ohci-ssb.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers
+++ a/drivers/usb/host/ohci-ssb.c
@@ -160,7 +160,7 @@ static int ssb_ohci_attach(struct ssb_de
 	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs)
 		goto err_put_hcd;
-	err = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
+	err = usb_add_hcd(hcd, dev->irq, IRQF_DISABLED | IRQF_SHARED);
 	if (err)
 		goto err_iounmap;
 
diff -puN drivers/usb/host/r8a66597-hcd.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -2197,7 +2197,7 @@ static int __init r8a66597_probe(struct 
 	INIT_LIST_HEAD(&r8a66597->child_device);
 
 	hcd->rsrc_start = res->start;
-	ret = usb_add_hcd(hcd, irq, 0);
+	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED);
 	if (ret != 0) {
 		err("Failed to add hcd");
 		goto clean_up;
diff -puN drivers/usb/host/uhci-hcd.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers drivers/usb/host/uhci-hcd.c
--- a/drivers/usb/host/uhci-hcd.c~usb-use-irqf_disabled-for-hcd-interrupt-handlers
+++ a/drivers/usb/host/uhci-hcd.c
@@ -378,7 +378,6 @@ static irqreturn_t uhci_irq(struct usb_h
 {
 	struct uhci_hcd *uhci = hcd_to_uhci(hcd);
 	unsigned short status;
-	unsigned long flags;
 
 	/*
 	 * Read the interrupt status, and write it back to clear the
@@ -398,7 +397,7 @@ static irqreturn_t uhci_irq(struct usb_h
 			dev_err(uhci_dev(uhci), "host controller process "
 					"error, something bad happened!\n");
 		if (status & USBSTS_HCH) {
-			spin_lock_irqsave(&uhci->lock, flags);
+			spin_lock(&uhci->lock);
 			if (uhci->rh_state >= UHCI_RH_RUNNING) {
 				dev_err(uhci_dev(uhci),
 					"host controller halted, "
@@ -415,16 +414,16 @@ static irqreturn_t uhci_irq(struct usb_h
 				 * pending unlinks */
 				mod_timer(&hcd->rh_timer, jiffies);
 			}
-			spin_unlock_irqrestore(&uhci->lock, flags);
+			spin_unlock(&uhci->lock);
 		}
 	}
 
 	if (status & USBSTS_RD)
 		usb_hcd_poll_rh_status(hcd);
 	else {
-		spin_lock_irqsave(&uhci->lock, flags);
+		spin_lock(&uhci->lock);
 		uhci_scan_schedule(uhci);
-		spin_unlock_irqrestore(&uhci->lock, flags);
+		spin_unlock(&uhci->lock);
 	}
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

git-acpi.patch
ohci-hcdcohci_irq-locking-fix.patch
scsi-early-detection-of-medium-not-present-updated.patch
usb-use-irqf_disabled-for-hcd-interrupt-handlers.patch
