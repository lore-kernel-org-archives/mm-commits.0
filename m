From: akpm@linux-foundation.org
Subject: + pnp-add-debug-message-for-adding-new-device.patch added to -mm tree
Date: Fri, 28 Sep 2007 16:31:37 -0700
Message-ID: <200709282331.l8SNVbs0022749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849AbXI1Xc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 19:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org


The patch titled
     PNP: add debug message for adding new device
has been added to the -mm tree.  Its filename is
     pnp-add-debug-message-for-adding-new-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: add debug message for adding new device
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Add PNP debug message when adding a device, remove similar PNPACPI message
with less information.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/core.c~pnp-add-debug-message-for-adding-new-device drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-add-debug-message-for-adding-new-device
+++ a/drivers/pnp/core.c
@@ -125,9 +125,11 @@ int __pnp_add_device(struct pnp_dev *dev
 	spin_unlock(&pnp_lock);
 
 	ret = device_register(&dev->dev);
-	if (ret == 0)
-		pnp_interface_attach_device(dev);
-	return ret;
+	if (ret)
+		return ret;
+
+	pnp_interface_attach_device(dev);
+	return 0;
 }
 
 /*
@@ -138,12 +140,27 @@ int __pnp_add_device(struct pnp_dev *dev
  */
 int pnp_add_device(struct pnp_dev *dev)
 {
+	int ret;
+	struct pnp_id *id;
+
 	if (dev->card)
 		return -EINVAL;
+
 	dev->dev.parent = &dev->protocol->dev;
 	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
 		dev->number);
-	return __pnp_add_device(dev);
+	ret = __pnp_add_device(dev);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_PNP_DEBUG
+	dev_printk(KERN_DEBUG, &dev->dev, "%s device, IDs",
+		dev->protocol->name);
+	for (id = dev->id; id; id = id->next)
+		printk(" %s", id->id);
+	printk(" (%s)\n", dev->active ? "active" : "disabled");
+#endif
+	return 0;
 }
 
 void __pnp_remove_device(struct pnp_dev *dev)
diff -puN drivers/pnp/pnpacpi/core.c~pnp-add-debug-message-for-adding-new-device drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnp-add-debug-message-for-adding-new-device
+++ a/drivers/pnp/pnpacpi/core.c
@@ -171,7 +171,6 @@ static int __init pnpacpi_add_device(str
 	    is_exclusive_device(device))
 		return 0;
 
-	pnp_dbg("ACPI device : hid %s", acpi_device_hid(device));
 	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
 	if (!dev) {
 		pnp_err("Out of memory");
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
