From: akpm@linux-foundation.org
Subject: - pnp-add-debug-message-for-adding-new-device.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:00 -0700
Message-ID: <200710180704.l9I740ea031488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759678AbXJRH1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PNP: add debug message for adding new device
has been removed from the -mm tree.  Its filename was
     pnp-add-debug-message-for-adding-new-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/pnp/core.c         |   28 ++++++++++++++++++++++++----
 drivers/pnp/pnpacpi/core.c |    1 -
 2 files changed, 24 insertions(+), 5 deletions(-)

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
@@ -138,12 +140,30 @@ int __pnp_add_device(struct pnp_dev *dev
  */
 int pnp_add_device(struct pnp_dev *dev)
 {
+	int ret;
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
+	{
+		struct pnp_id *id;
+
+		dev_printk(KERN_DEBUG, &dev->dev, "%s device, IDs",
+			dev->protocol->name);
+		for (id = dev->id; id; id = id->next)
+			printk(" %s", id->id);
+		printk(" (%s)\n", dev->active ? "active" : "disabled");
+	}
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

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
