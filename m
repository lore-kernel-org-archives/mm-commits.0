From: akpm@linux-foundation.org
Subject: - agp-prevent-probe-collision-of-sis-agp-and-amd64_agp.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:56 -0700
Message-ID: <200704062008.l36K8u6H017883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32805 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXDFUJB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oneukum@suse.de, mm-commits@vger.kernel.org


The patch titled
     agp: prevent probe collision of sis-agp and amd64_agp
has been removed from the -mm tree.  Its filename was
     agp-prevent-probe-collision-of-sis-agp-and-amd64_agp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: agp: prevent probe collision of sis-agp and amd64_agp
From: Oliver Neukum <oneukum@suse.de>

For some vendor/id pairs the kernel will autoload both the sis-agp and the
amd64_agp modules as the sis-agp module will load for all sis devices. 
This collision causes the bug reported in:
http://bugzilla.novell.com/show_bug.cgi?id=248665

As currently sis_probe does its own matching, requesting the whole range
gains nothing.  The clean fix seems to me to leave the matching to the core
and advertise only the devices actually supported.  This patch does so.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/sis-agp.c |  278 +++++++++++++++++++++--------------
 1 file changed, 167 insertions(+), 111 deletions(-)

diff -puN drivers/char/agp/sis-agp.c~agp-prevent-probe-collision-of-sis-agp-and-amd64_agp drivers/char/agp/sis-agp.c
--- a/drivers/char/agp/sis-agp.c~agp-prevent-probe-collision-of-sis-agp-and-amd64_agp
+++ a/drivers/char/agp/sis-agp.c
@@ -143,96 +143,6 @@ static struct agp_bridge_driver sis_driv
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-static struct agp_device_ids sis_agp_device_ids[] __devinitdata =
-{
-	{
-		.device_id	= PCI_DEVICE_ID_SI_5591_AGP,
-		.chipset_name	= "5591",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_530,
-		.chipset_name	= "530",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_540,
-		.chipset_name	= "540",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_550,
-		.chipset_name	= "550",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_620,
-		.chipset_name	= "620",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_630,
-		.chipset_name	= "630",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_635,
-		.chipset_name	= "635",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_645,
-		.chipset_name	= "645",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_646,
-		.chipset_name	= "646",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_648,
-		.chipset_name	= "648",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_650,
-		.chipset_name	= "650",
-	},
-	{
-		.device_id  = PCI_DEVICE_ID_SI_651,
-		.chipset_name   = "651",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_655,
-		.chipset_name	= "655",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_661,
-		.chipset_name	= "661",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_730,
-		.chipset_name	= "730",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_735,
-		.chipset_name	= "735",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_740,
-		.chipset_name	= "740",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_741,
-		.chipset_name	= "741",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_745,
-		.chipset_name	= "745",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_746,
-		.chipset_name	= "746",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_760,
-		.chipset_name	= "760",
-	},
-	{ }, /* dummy final entry, always present */
-};
-
-
 // chipsets that require the 'delay hack'
 static int sis_broken_chipsets[] __devinitdata = {
 	PCI_DEVICE_ID_SI_648,
@@ -269,29 +179,15 @@ static void __devinit sis_get_driver(str
 static int __devinit agp_sis_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-	struct agp_device_ids *devs = sis_agp_device_ids;
 	struct agp_bridge_data *bridge;
 	u8 cap_ptr;
-	int j;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
 
-	/* probe for known chipsets */
-	for (j = 0; devs[j].chipset_name; j++) {
-		if (pdev->device == devs[j].device_id) {
-			printk(KERN_INFO PFX "Detected SiS %s chipset\n",
-					devs[j].chipset_name);
-			goto found;
-		}
-	}
-
-	printk(KERN_ERR PFX "Unsupported SiS chipset (device id: %04x)\n",
-		    pdev->device);
-	return -ENODEV;
 
-found:
+	printk(KERN_INFO PFX "Detected SiS chipset - id:%i\n", pdev->device);
 	bridge = agp_alloc_bridge();
 	if (!bridge)
 		return -ENOMEM;
@@ -320,12 +216,172 @@ static void __devexit agp_sis_remove(str
 
 static struct pci_device_id agp_sis_pci_table[] = {
 	{
-	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
-	.class_mask	= ~0,
-	.vendor		= PCI_VENDOR_ID_SI,
-	.device		= PCI_ANY_ID,
-	.subvendor	= PCI_ANY_ID,
-	.subdevice	= PCI_ANY_ID,
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_5591_AGP,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_530,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_540,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_550,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_620,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_630,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_635,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_645,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_646,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_648,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_650,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_651,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_655,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_661,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_730,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_735,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_740,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_741,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_745,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_746,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_760,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
 	},
 	{ }
 };
_

Patches currently in -mm which might be from oneukum@suse.de are

git-agpgart.patch
git-dvb.patch
