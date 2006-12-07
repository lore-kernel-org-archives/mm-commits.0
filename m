From: akpm@osdl.org
Subject: - ipmi-fix-device-model-name.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:26 -0800
Message-ID: <200612072317.kB7NHQ4P030926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54375 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1164000AbWLGXW5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, cah@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: Fix device model name
has been removed from the -mm tree.  Its filename was
     ipmi-fix-device-model-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: Fix device model name
From: Corey Minyard <minyard@acm.org>

Add the product id to the driver model platform device name, in addition to
the device id.  The IPMI spec does not require that individual BMCs in a
system have unique devices IDs, but it does require that the product id/device
id combination be unique.

This also removes a redundant check and cleans up error handling
when the sysfs registration fails.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Carol Hebert <cah@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  147 ++++++++++++++++----------
 1 file changed, 91 insertions(+), 56 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-device-model-name drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-device-model-name
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -1817,13 +1817,12 @@ static int __find_bmc_prod_dev_id(struct
 	struct bmc_device *bmc = dev_get_drvdata(dev);
 
 	return (bmc->id.product_id == id->product_id
-		&& bmc->id.product_id == id->product_id
 		&& bmc->id.device_id == id->device_id);
 }
 
 static struct bmc_device *ipmi_find_bmc_prod_dev_id(
 	struct device_driver *drv,
-	unsigned char product_id, unsigned char device_id)
+	unsigned int product_id, unsigned char device_id)
 {
 	struct prod_dev_id id = {
 		.product_id = product_id,
@@ -1940,6 +1939,9 @@ static ssize_t guid_show(struct device *
 
 static void remove_files(struct bmc_device *bmc)
 {
+	if (!bmc->dev)
+		return;
+
 	device_remove_file(&bmc->dev->dev,
 			   &bmc->device_id_attr);
 	device_remove_file(&bmc->dev->dev,
@@ -1973,7 +1975,8 @@ cleanup_bmc_device(struct kref *ref)
 	bmc = container_of(ref, struct bmc_device, refcount);
 
 	remove_files(bmc);
-	platform_device_unregister(bmc->dev);
+	if (bmc->dev)
+		platform_device_unregister(bmc->dev);
 	kfree(bmc);
 }
 
@@ -1990,6 +1993,7 @@ static void ipmi_bmc_unregister(ipmi_smi
 
 	mutex_lock(&ipmidriver_mutex);
 	kref_put(&bmc->refcount, cleanup_bmc_device);
+	intf->bmc = NULL;
 	mutex_unlock(&ipmidriver_mutex);
 }
 
@@ -1997,6 +2001,56 @@ static int create_files(struct bmc_devic
 {
 	int err;
 
+	bmc->device_id_attr.attr.name = "device_id";
+	bmc->device_id_attr.attr.owner = THIS_MODULE;
+	bmc->device_id_attr.attr.mode = S_IRUGO;
+	bmc->device_id_attr.show = device_id_show;
+
+	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
+	bmc->provides_dev_sdrs_attr.attr.owner = THIS_MODULE;
+	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
+	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
+
+	bmc->revision_attr.attr.name = "revision";
+	bmc->revision_attr.attr.owner = THIS_MODULE;
+	bmc->revision_attr.attr.mode = S_IRUGO;
+	bmc->revision_attr.show = revision_show;
+
+	bmc->firmware_rev_attr.attr.name = "firmware_revision";
+	bmc->firmware_rev_attr.attr.owner = THIS_MODULE;
+	bmc->firmware_rev_attr.attr.mode = S_IRUGO;
+	bmc->firmware_rev_attr.show = firmware_rev_show;
+
+	bmc->version_attr.attr.name = "ipmi_version";
+	bmc->version_attr.attr.owner = THIS_MODULE;
+	bmc->version_attr.attr.mode = S_IRUGO;
+	bmc->version_attr.show = ipmi_version_show;
+
+	bmc->add_dev_support_attr.attr.name = "additional_device_support";
+	bmc->add_dev_support_attr.attr.owner = THIS_MODULE;
+	bmc->add_dev_support_attr.attr.mode = S_IRUGO;
+	bmc->add_dev_support_attr.show = add_dev_support_show;
+
+	bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
+	bmc->manufacturer_id_attr.attr.owner = THIS_MODULE;
+	bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
+	bmc->manufacturer_id_attr.show = manufacturer_id_show;
+
+	bmc->product_id_attr.attr.name = "product_id";
+	bmc->product_id_attr.attr.owner = THIS_MODULE;
+	bmc->product_id_attr.attr.mode = S_IRUGO;
+	bmc->product_id_attr.show = product_id_show;
+
+	bmc->guid_attr.attr.name = "guid";
+	bmc->guid_attr.attr.owner = THIS_MODULE;
+	bmc->guid_attr.attr.mode = S_IRUGO;
+	bmc->guid_attr.show = guid_show;
+
+	bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
+	bmc->aux_firmware_rev_attr.attr.owner = THIS_MODULE;
+	bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
+	bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
+
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->device_id_attr);
 	if (err) goto out;
@@ -2106,9 +2160,39 @@ static int ipmi_bmc_register(ipmi_smi_t 
 		       bmc->id.product_id,
 		       bmc->id.device_id);
 	} else {
-		bmc->dev = platform_device_alloc("ipmi_bmc",
-						 bmc->id.device_id);
+		char name[14];
+		unsigned char orig_dev_id = bmc->id.device_id;
+		int warn_printed = 0;
+
+		snprintf(name, sizeof(name),
+			 "ipmi_bmc.%4.4x", bmc->id.product_id);
+
+		while (ipmi_find_bmc_prod_dev_id(&ipmidriver,
+						 bmc->id.product_id,
+						 bmc->id.device_id))
+		{
+			if (!warn_printed) {
+				printk(KERN_WARNING PFX
+				       "This machine has two different BMCs"
+				       " with the same product id and device"
+				       " id.  This is an error in the"
+				       " firmware, but incrementing the"
+				       " device id to work around the problem."
+				       " Prod ID = 0x%x, Dev ID = 0x%x\n",
+				       bmc->id.product_id, bmc->id.device_id);
+				warn_printed = 1;
+			}
+			bmc->id.device_id++; /* Wraps at 255 */
+			if (bmc->id.device_id == orig_dev_id) {
+				printk(KERN_ERR PFX
+				       "Out of device ids!\n");
+				break;
+			}
+		}
+
+		bmc->dev = platform_device_alloc(name, bmc->id.device_id);
 		if (!bmc->dev) {
+			mutex_unlock(&ipmidriver_mutex);
 			printk(KERN_ERR
 			       "ipmi_msghandler:"
 			       " Unable to allocate platform device\n");
@@ -2121,6 +2205,8 @@ static int ipmi_bmc_register(ipmi_smi_t 
 		rv = platform_device_add(bmc->dev);
 		mutex_unlock(&ipmidriver_mutex);
 		if (rv) {
+			platform_device_put(bmc->dev);
+			bmc->dev = NULL;
 			printk(KERN_ERR
 			       "ipmi_msghandler:"
 			       " Unable to register bmc device: %d\n",
@@ -2130,57 +2216,6 @@ static int ipmi_bmc_register(ipmi_smi_t 
 			return rv;
 		}
 
-		bmc->device_id_attr.attr.name = "device_id";
-		bmc->device_id_attr.attr.owner = THIS_MODULE;
-		bmc->device_id_attr.attr.mode = S_IRUGO;
-		bmc->device_id_attr.show = device_id_show;
-
-		bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
-		bmc->provides_dev_sdrs_attr.attr.owner = THIS_MODULE;
-		bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
-		bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
-
-		bmc->revision_attr.attr.name = "revision";
-		bmc->revision_attr.attr.owner = THIS_MODULE;
-		bmc->revision_attr.attr.mode = S_IRUGO;
-		bmc->revision_attr.show = revision_show;
-
-		bmc->firmware_rev_attr.attr.name = "firmware_revision";
-		bmc->firmware_rev_attr.attr.owner = THIS_MODULE;
-		bmc->firmware_rev_attr.attr.mode = S_IRUGO;
-		bmc->firmware_rev_attr.show = firmware_rev_show;
-
-		bmc->version_attr.attr.name = "ipmi_version";
-		bmc->version_attr.attr.owner = THIS_MODULE;
-		bmc->version_attr.attr.mode = S_IRUGO;
-		bmc->version_attr.show = ipmi_version_show;
-
-		bmc->add_dev_support_attr.attr.name
-			= "additional_device_support";
-		bmc->add_dev_support_attr.attr.owner = THIS_MODULE;
-		bmc->add_dev_support_attr.attr.mode = S_IRUGO;
-		bmc->add_dev_support_attr.show = add_dev_support_show;
-
-		bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
-		bmc->manufacturer_id_attr.attr.owner = THIS_MODULE;
-		bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
-		bmc->manufacturer_id_attr.show = manufacturer_id_show;
-
-		bmc->product_id_attr.attr.name = "product_id";
-		bmc->product_id_attr.attr.owner = THIS_MODULE;
-		bmc->product_id_attr.attr.mode = S_IRUGO;
-		bmc->product_id_attr.show = product_id_show;
-
-		bmc->guid_attr.attr.name = "guid";
-		bmc->guid_attr.attr.owner = THIS_MODULE;
-		bmc->guid_attr.attr.mode = S_IRUGO;
-		bmc->guid_attr.show = guid_show;
-
-		bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
-		bmc->aux_firmware_rev_attr.attr.owner = THIS_MODULE;
-		bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
-		bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
-
 		rv = create_files(bmc);
 		if (rv) {
 			mutex_lock(&ipmidriver_mutex);
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

