From: akpm@linux-foundation.org
Subject: + pnp-simplify-pnpbios-insert_device.patch added to -mm tree
Date: Fri, 28 Sep 2007 16:31:35 -0700
Message-ID: <200709282331.l8SNVZFT022744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbXI1Xc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 19:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org


The patch titled
     PNP: simplify PNPBIOS insert_device
has been added to the -mm tree.  Its filename is
     pnp-simplify-pnpbios-insert_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: simplify PNPBIOS insert_device
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Hoist the struct pnp_dev alloc up into the function where it's used.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/pnpbios/core.c~pnp-simplify-pnpbios-insert_device drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnp-simplify-pnpbios-insert_device
+++ a/drivers/pnp/pnpbios/core.c
@@ -315,25 +315,31 @@ struct pnp_protocol pnpbios_protocol = {
 	.disable = pnpbios_disable_resources,
 };
 
-static int insert_device(struct pnp_dev *dev, struct pnp_bios_node *node)
+static int insert_device(struct pnp_bios_node *node)
 {
 	struct list_head *pos;
-	struct pnp_dev *pnp_dev;
+	struct pnp_dev *dev;
 	struct pnp_id *dev_id;
 	char id[8];
 
 	/* check if the device is already added */
-	dev->number = node->handle;
 	list_for_each(pos, &pnpbios_protocol.devices) {
-		pnp_dev = list_entry(pos, struct pnp_dev, protocol_list);
-		if (dev->number == pnp_dev->number)
+		dev = list_entry(pos, struct pnp_dev, protocol_list);
+		if (dev->number == node->handle)
 			return -1;
 	}
 
-	/* set the initial values for the PnP device */
+	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
+	if (!dev)
+		return -1;
+
 	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
-	if (!dev_id)
+	if (!dev_id) {
+		kfree(dev);
 		return -1;
+	}
+
+	dev->number = node->handle;
 	pnpid32_to_pnpid(node->eisa_id, id);
 	memcpy(dev_id->id, id, 7);
 	pnp_add_id(dev_id, dev);
@@ -367,7 +373,6 @@ static void __init build_devlist(void)
 	unsigned int nodes_got = 0;
 	unsigned int devs = 0;
 	struct pnp_bios_node *node;
-	struct pnp_dev *dev;
 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
@@ -388,12 +393,7 @@ static void __init build_devlist(void)
 				break;
 		}
 		nodes_got++;
-		dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
-		if (!dev)
-			break;
-		if (insert_device(dev, node) < 0)
-			kfree(dev);
-		else
+		if (insert_device(node) == 0)
 			devs++;
 		if (nodenum <= thisnodenum) {
 			printk(KERN_ERR
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch
serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch
pnp-remove-null-pointer-checks.patch
pnp-simplify-pnp-card-error-handling.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
pnp-use-dev_info-in-system-driver.patch
pnp-simplify-pnpbios-insert_device.patch
pnp-add-debug-message-for-adding-new-device.patch
