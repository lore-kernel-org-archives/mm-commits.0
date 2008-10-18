From: akpm@linux-foundation.org
Subject: - firmware-use-dev_printk-when-possible.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:02 -0700
Message-ID: <200810182319.m9INJ2xh029402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYJRXTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     firmware: use dev_printk when possible
has been removed from the -mm tree.  Its filename was
     firmware-use-dev_printk-when-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: use dev_printk when possible
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert printks to use dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-use-dev_printk-when-possible drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-use-dev_printk-when-possible
+++ a/drivers/base/firmware_class.c
@@ -164,8 +164,7 @@ static ssize_t firmware_loading_store(st
 		}
 		/* fallthrough */
 	default:
-		printk(KERN_ERR "%s: unexpected value (%d)\n", __func__,
-		       loading);
+		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
 		/* fallthrough */
 	case -1:
 		fw_load_abort(fw_priv);
@@ -309,7 +308,7 @@ static int fw_register_device(struct dev
 	*dev_p = NULL;
 
 	if (!fw_priv || !f_dev) {
-		printk(KERN_ERR "%s: kmalloc failed\n", __func__);
+		dev_err(device, "%s: kmalloc failed\n", __func__);
 		retval = -ENOMEM;
 		goto error_kfree;
 	}
@@ -329,8 +328,7 @@ static int fw_register_device(struct dev
 	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
-		printk(KERN_ERR "%s: device_register failed\n",
-		       __func__);
+		dev_err(device, "%s: device_register failed\n", __func__);
 		goto error_kfree;
 	}
 	*dev_p = f_dev;
@@ -363,15 +361,13 @@ static int fw_setup_device(struct firmwa
 	fw_priv->fw = fw;
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 	if (retval) {
-		printk(KERN_ERR "%s: sysfs_create_bin_file failed\n",
-		       __func__);
+		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
 		goto error_unreg;
 	}
 
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
-		printk(KERN_ERR "%s: device_create_file failed\n",
-		       __func__);
+		dev_err(device, "%s: device_create_file failed\n", __func__);
 		goto error_unreg;
 	}
 
@@ -401,8 +397,8 @@ _request_firmware(const struct firmware 
 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
-		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
-		       __func__);
+		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
+			__func__);
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -411,15 +407,15 @@ _request_firmware(const struct firmware 
 	     builtin++) {
 		if (strcmp(name, builtin->name))
 			continue;
-		printk(KERN_INFO "firmware: using built-in firmware %s\n",
-		       name);
+		dev_info(device, "firmware: using built-in firmware %s\n",
+			 name);
 		firmware->size = builtin->size;
 		firmware->data = builtin->data;
 		return 0;
 	}
 
 	if (uevent)
-		printk(KERN_INFO "firmware: requesting %s\n", name);
+		dev_info(device, "firmware: requesting %s\n", name);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
rtc-cmos-export-second-nvram-bank.patch

