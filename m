From: akpm@linux-foundation.org
Subject: - pnp-create-device-attributes-via-default-device-attributes.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:29:17 -0700
Message-ID: <200810032129.m93LTH6C016680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbYJCVe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmoseley@mvista.com, bjorn.helgaas@hp.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     PNP: create device attributes via default device attributes
has been removed from the -mm tree.  Its filename was
     pnp-create-device-attributes-via-default-device-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: create device attributes via default device attributes
From: Drew Moseley <dmoseley@mvista.com>

This creates the attributes before the uevent is sent.

Signed-off-by: Drew Moseley <dmoseley@mvista.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h      |    2 +-
 drivers/pnp/core.c      |   10 +---------
 drivers/pnp/driver.c    |    1 +
 drivers/pnp/interface.c |   37 ++++++++-----------------------------
 4 files changed, 11 insertions(+), 39 deletions(-)

diff -puN drivers/pnp/base.h~pnp-create-device-attributes-via-default-device-attributes drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-create-device-attributes-via-default-device-attributes
+++ a/drivers/pnp/base.h
@@ -4,6 +4,7 @@
  */
 
 extern spinlock_t pnp_lock;
+extern struct device_attribute pnp_interface_attrs[];
 void *pnp_alloc(long size);
 
 int pnp_register_protocol(struct pnp_protocol *protocol);
@@ -16,7 +17,6 @@ struct pnp_card *pnp_alloc_card(struct p
 
 int pnp_add_device(struct pnp_dev *dev);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
-int pnp_interface_attach_device(struct pnp_dev *dev);
 
 int pnp_add_card(struct pnp_card *card);
 void pnp_remove_card(struct pnp_card *card);
diff -puN drivers/pnp/core.c~pnp-create-device-attributes-via-default-device-attributes drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-create-device-attributes-via-default-device-attributes
+++ a/drivers/pnp/core.c
@@ -159,21 +159,13 @@ struct pnp_dev *pnp_alloc_dev(struct pnp
 
 int __pnp_add_device(struct pnp_dev *dev)
 {
-	int ret;
-
 	pnp_fixup_device(dev);
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
 	list_add_tail(&dev->global_list, &pnp_global);
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);
-
-	ret = device_register(&dev->dev);
-	if (ret)
-		return ret;
-
-	pnp_interface_attach_device(dev);
-	return 0;
+	return device_register(&dev->dev);
 }
 
 /*
diff -puN drivers/pnp/driver.c~pnp-create-device-attributes-via-default-device-attributes drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-create-device-attributes-via-default-device-attributes
+++ a/drivers/pnp/driver.c
@@ -205,6 +205,7 @@ struct bus_type pnp_bus_type = {
 	.remove  = pnp_device_remove,
 	.suspend = pnp_bus_suspend,
 	.resume  = pnp_bus_resume,
+	.dev_attrs = pnp_interface_attrs,
 };
 
 int pnp_register_driver(struct pnp_driver *drv)
diff -puN drivers/pnp/interface.c~pnp-create-device-attributes-via-default-device-attributes drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-create-device-attributes-via-default-device-attributes
+++ a/drivers/pnp/interface.c
@@ -243,8 +243,6 @@ static ssize_t pnp_show_options(struct d
 	return ret;
 }
 
-static DEVICE_ATTR(options, S_IRUGO, pnp_show_options, NULL);
-
 static ssize_t pnp_show_current_resources(struct device *dmdev,
 					  struct device_attribute *attr,
 					  char *buf)
@@ -420,9 +418,6 @@ done:
 	return count;
 }
 
-static DEVICE_ATTR(resources, S_IRUGO | S_IWUSR,
-		   pnp_show_current_resources, pnp_set_current_resources);
-
 static ssize_t pnp_show_current_ids(struct device *dmdev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -437,27 +432,11 @@ static ssize_t pnp_show_current_ids(stru
 	return (str - buf);
 }
 
-static DEVICE_ATTR(id, S_IRUGO, pnp_show_current_ids, NULL);
-
-int pnp_interface_attach_device(struct pnp_dev *dev)
-{
-	int rc = device_create_file(&dev->dev, &dev_attr_options);
-
-	if (rc)
-		goto err;
-	rc = device_create_file(&dev->dev, &dev_attr_resources);
-	if (rc)
-		goto err_opt;
-	rc = device_create_file(&dev->dev, &dev_attr_id);
-	if (rc)
-		goto err_res;
-
-	return 0;
