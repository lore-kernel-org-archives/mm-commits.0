From: akpm@linux-foundation.org
Subject: + tpmc-fix-crash-during-device-removal.patch added to -mm tree
Date: Tue, 20 Nov 2007 12:10:13 -0800
Message-ID: <200711202010.lAKKADOm021194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757882AbXKTUKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 15:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.musil@st.com, tpm@selhorst.net


The patch titled
     tpm.c: fix crash during device removal
has been added to the -mm tree.  Its filename is
     tpmc-fix-crash-during-device-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tpm.c: fix crash during device removal
From: Richard MUSIL <richard.musil@st.com>

The clean up procedure now uses platform device "release" callback to
handle memory clean up.  For this purpose "release" function callback was
added to struct tpm_vendor_specific, so hw device driver provider can get
called when it is safe to remove all allocated resources.

This is supposed to fix a bug in device removal, where device while in
receive function (waiting on timeout) was prone to segfault, if the
tpm_chip struct was unallocated before the timeout expired (in
tpm_remove_hardware).

Acked-by: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   44 +++++++++++++++++++++++----------------
 drivers/char/tpm/tpm.h |    2 +
 2 files changed, 29 insertions(+), 17 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpmc-fix-crash-during-device-removal drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpmc-fix-crash-during-device-removal
+++ a/drivers/char/tpm/tpm.c
@@ -1031,18 +1031,13 @@ void tpm_remove_hardware(struct device *
 
 	spin_unlock(&driver_lock);
 
-	dev_set_drvdata(dev, NULL);
 	misc_deregister(&chip->vendor.miscdev);
-	kfree(chip->vendor.miscdev.name);
 
 	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
 	tpm_bios_log_teardown(chip->bios_dir);
 
-	clear_bit(chip->dev_num, dev_mask);
-
-	kfree(chip);
-
-	put_device(dev);
+	/* write it this way to be explicit (chip->dev == dev) */
+	put_device(chip->dev);
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
@@ -1083,6 +1078,26 @@ int tpm_pm_resume(struct device *dev)
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 /*
+ * Once all references to platform device are down to 0,
+ * release all allocated structures.
+ * In case vendor provided release function,
+ * call it too.
+ */
+static void tpm_dev_release(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	if (chip->vendor.release)
+		chip->vendor.release(dev);
+
+	chip->release(dev);
+
+	clear_bit(chip->dev_num, dev_mask);
+	kfree(chip->vendor.miscdev.name);
+	kfree(chip);
+}
+
+/*
  * Called from tpm_<specific>.c probe function only for devices 
  * the driver has determined it should claim.  Prior to calling
  * this function the specific probe function has called pci_enable_device
@@ -1136,23 +1151,21 @@ struct tpm_chip *tpm_register_hardware(s
 
 	chip->vendor.miscdev.parent = dev;
 	chip->dev = get_device(dev);
+	chip->release = dev->release;
+	dev->release = tpm_dev_release;
+	dev_set_drvdata(dev, chip);
 
 	if (misc_register(&chip->vendor.miscdev)) {
 		dev_err(chip->dev,
 			"unable to misc_register %s, minor %d\n",
 			chip->vendor.miscdev.name,
 			chip->vendor.miscdev.minor);
-		put_device(dev);
-		clear_bit(chip->dev_num, dev_mask);
-		kfree(chip);
-		kfree(devname);
+		put_device(chip->dev);
 		return NULL;
 	}
 
 	spin_lock(&driver_lock);
 
-	dev_set_drvdata(dev, chip);
-
 	list_add(&chip->list, &tpm_chip_list);
 
 	spin_unlock(&driver_lock);
@@ -1160,10 +1173,7 @@ struct tpm_chip *tpm_register_hardware(s
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
 		list_del(&chip->list);
 		misc_deregister(&chip->vendor.miscdev);
-		put_device(dev);
-		clear_bit(chip->dev_num, dev_mask);
-		kfree(chip);
-		kfree(devname);
+		put_device(chip->dev);
 		return NULL;
 	}
 
diff -puN drivers/char/tpm/tpm.h~tpmc-fix-crash-during-device-removal drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~tpmc-fix-crash-during-device-removal
+++ a/drivers/char/tpm/tpm.h
@@ -74,6 +74,7 @@ struct tpm_vendor_specific {
 	int (*send) (struct tpm_chip *, u8 *, size_t);
 	void (*cancel) (struct tpm_chip *);
 	u8 (*status) (struct tpm_chip *);
+	void (*release) (struct device *);
 	struct miscdevice miscdev;
 	struct attribute_group *attr_group;
 	struct list_head list;
@@ -106,6 +107,7 @@ struct tpm_chip {
 	struct dentry **bios_dir;
 
 	struct list_head list;
+	void (*release) (struct device *);
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
_

Patches currently in -mm which might be from richard.musil@st.com are

tpmc-fix-crash-during-device-removal.patch
