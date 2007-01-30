From: akpm@osdl.org
Subject: - fix-via-irq-quirk-breakage.patch removed from -mm tree
Date: Tue, 30 Jan 2007 10:15:09 -0800
Message-ID: <200701301815.l0UIF9XB024820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41168 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030190AbXA3SPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 13:15:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, alan@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     fix via irq quirk breakage
has been removed from the -mm tree.  Its filename was
     fix-via-irq-quirk-breakage.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: fix via irq quirk breakage
From: Jean Delvare <jdelvare@suse.de>

Fix VIA quirks that were recently broken by Alan Cox in the upstream
kernel (commit 1597cacbe39802d86656d1f2e6329895bd2ef531).

My understanding is that pci_find_present() doesn't work yet at the time
the quirks are run.  So I used a two-step quirk as is done for some other
quirks already.  First we detect the VIA south bridges and set the right
low and high device limits, then we are ready to actually run the quirks on
the affected devices.

Alan sayeth "This is a lot neater than the original patch too.  Only problem I
see is pci=reverse might need more care."

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Alan Cox <alan@redhat.com>
Needs-to-be-tested-by: Nick Piggin <nickpiggin@yahoo.com.au> (it failed)
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |   78 ++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff -puN drivers/pci/quirks.c~fix-via-irq-quirk-breakage drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~fix-via-irq-quirk-breakage
+++ a/drivers/pci/quirks.c
@@ -654,19 +654,40 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
  *	VIA bridges which have VLink
  */
 
-static const struct pci_device_id via_vlink_fixup_tbl[] = {
-	/* Internal devices need IRQ line routing, pre VLink */
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C686), 0 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8231), 17 },
-	/* Devices with VLink */
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233_0), 17},
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233A), 17 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233C_0), 17 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8235), 16 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8237), 15 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8237A), 15 },
-	{ 0, },
-};
+static int via_vlink_dev_lo = -1, via_vlink_dev_hi = 18;
+
+static void quirk_via_bridge(struct pci_dev *dev)
+{
+	/* See what bridge we have and find the device ranges */
+	switch (dev->device) {
+	case PCI_DEVICE_ID_VIA_82C686:
+		/* 82C686 is special */
+		via_vlink_dev_lo = 0;
+		via_vlink_dev_hi = 0;
+		break;
+	case PCI_DEVICE_ID_VIA_8237:
+	case PCI_DEVICE_ID_VIA_8237A:
+		via_vlink_dev_lo = 15;
+		break;
+	case PCI_DEVICE_ID_VIA_8235:
+		via_vlink_dev_lo = 16;
+		break;
+	case PCI_DEVICE_ID_VIA_8231:
+	case PCI_DEVICE_ID_VIA_8233_0:
+	case PCI_DEVICE_ID_VIA_8233A:
+	case PCI_DEVICE_ID_VIA_8233C_0:
+		via_vlink_dev_lo = 17;
+		break;
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8231,		quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233_0,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233A,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233C_0,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,		quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237,		quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237A,	quirk_via_bridge);
 
 /**
  *	quirk_via_vlink		-	VIA VLink IRQ number update
@@ -675,35 +696,20 @@ static const struct pci_device_id via_vl
  *	If the device we are dealing with is on a PIC IRQ we need to
  *	ensure that the IRQ line register which usually is not relevant
  *	for PCI cards, is actually written so that interrupts get sent
- *	to the right place
+ *	to the right place.
+ *	We only do this on systems where a VIA south bridge was detected,
+ *	and only for VIA devices on the motherboard (see quirk_via_bridge
+ *	above).
  */
 
 static void quirk_via_vlink(struct pci_dev *dev)
 {
-	const struct pci_device_id *via_vlink_fixup;
-	static int dev_lo = -1, dev_hi = 18;
 	u8 irq, new_irq;
 
-	/* Check if we have VLink and cache the result */
-
-	/* Checked already - no */
-	if (dev_lo == -2)
+	/* Check if we have VLink at all */
+	if (via_vlink_dev_lo == -1)
 		return;
 
-	/* Not checked - see what bridge we have and find the device
-	   ranges */
-
-	if (dev_lo == -1) {
-		via_vlink_fixup = pci_find_present(via_vlink_fixup_tbl);
-		if (via_vlink_fixup == NULL) {
-			dev_lo = -2;
-			return;
-		}
-		dev_lo = via_vlink_fixup->driver_data;
-		/* 82C686 is special - 0/0 */
-		if (dev_lo == 0)
-			dev_hi = 0;
-	}
 	new_irq = dev->irq;
 
 	/* Don't quirk interrupts outside the legacy IRQ range */
@@ -711,8 +717,8 @@ static void quirk_via_vlink(struct pci_d
 		return;
 
 	/* Internal device ? */
-	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) > dev_hi ||
-		PCI_SLOT(dev->devfn) < dev_lo)
+	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) > via_vlink_dev_hi ||
+	    PCI_SLOT(dev->devfn) < via_vlink_dev_lo)
 		return;
 
 	/* This is an internal VLink device on a PIC interrupt. The BIOS
_

Patches currently in -mm which might be from jdelvare@suse.de are

fix-via-irq-quirk-breakage.patch
fix-via-quirks.patch
