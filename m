From: akpm@linux-foundation.org
Subject: - drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:55 -0700
Message-ID: <200708141912.l7EJCtIZ016447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183AbXHNTUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/irda/irda-usb.c: mostly kmalloc + memset conversion to k[cz]alloc
has been removed from the -mm tree.  Its filename was
     drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/net/irda/irda-usb.c: mostly kmalloc + memset conversion to k[cz]alloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/irda/irda-usb.c | 59694 -> 59541 (-153 bytes)
 drivers/net/irda/irda-usb.o | 170588 -> 169256 (-1332 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/irda-usb.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/net/irda/irda-usb.c~drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc drivers/net/irda/irda-usb.c
--- a/drivers/net/irda/irda-usb.c~drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc
+++ a/drivers/net/irda/irda-usb.c
@@ -1561,10 +1561,9 @@ static inline struct irda_class_desc *ir
 	struct irda_class_desc *desc;
 	int ret;
 
-	desc = kmalloc(sizeof (*desc), GFP_KERNEL);
-	if (desc == NULL) 
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
 		return NULL;
-	memset(desc, 0, sizeof(*desc));
 
 	/* USB-IrDA class spec 1.0:
 	 *	6.1.3: Standard "Get Descriptor" Device Request is not
@@ -1617,7 +1616,7 @@ static int irda_usb_probe(struct usb_int
 {
 	struct net_device *net;
 	struct usb_device *dev = interface_to_usbdev(intf);
-	struct irda_usb_cb *self = NULL;
+	struct irda_usb_cb *self;
 	struct usb_host_interface *interface;
 	struct irda_class_desc *irda_desc;
 	int ret = -ENOMEM;
@@ -1655,7 +1654,7 @@ static int irda_usb_probe(struct usb_int
 		self->header_length = USB_IRDA_HEADER;
 	}
 
-	self->rx_urb = kzalloc(self->max_rx_urb * sizeof(struct urb *),
+	self->rx_urb = kcalloc(self->max_rx_urb, sizeof(struct urb *),
 				GFP_KERNEL);
 
 	for (i = 0; i < self->max_rx_urb; i++) {
@@ -1715,7 +1714,7 @@ static int irda_usb_probe(struct usb_int
 	/* Find IrDA class descriptor */
 	irda_desc = irda_usb_find_class_desc(intf);
 	ret = -ENODEV;
-	if (irda_desc == NULL)
+	if (!irda_desc)
 		goto err_out_3;
 
 	if (self->needspatch) {
@@ -1738,15 +1737,13 @@ static int irda_usb_probe(struct usb_int
 	/* Don't change this buffer size and allocation without doing
 	 * some heavy and complete testing. Don't ask why :-(
 	 * Jean II */
-	self->speed_buff = kmalloc(IRDA_USB_SPEED_MTU, GFP_KERNEL);
-	if (self->speed_buff == NULL) 
+	self->speed_buff = kzalloc(IRDA_USB_SPEED_MTU, GFP_KERNEL);
+	if (!self->speed_buff)
 		goto err_out_3;
 
-	memset(self->speed_buff, 0, IRDA_USB_SPEED_MTU);
-
 	self->tx_buff = kzalloc(IRDA_SKB_MAX_MTU + self->header_length,
 				GFP_KERNEL);
-	if (self->tx_buff == NULL)
+	if (!self->tx_buff)
 		goto err_out_4;
 
 	ret = irda_usb_open(self);
@@ -1767,12 +1764,11 @@ static int irda_usb_probe(struct usb_int
 
 		/* replace IrDA class descriptor with what patched device is now reporting */
 		irda_desc = irda_usb_find_class_desc (self->usbintf);
-		if (irda_desc == NULL) {
+		if (!irda_desc) {
 			ret = -ENODEV;
 			goto err_out_6;
 		}
-		if (self->irda_desc)
-			kfree (self->irda_desc);
+		kfree(self->irda_desc);
 		self->irda_desc = irda_desc;
 		irda_usb_init_qos(self);
 	}
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
