From: akpm@linux-foundation.org
Subject: + hwrng-add-type-categories.patch added to -mm tree
Date: Tue, 26 Jun 2007 11:47:07 -0700
Message-ID: <200706261847.l5QIl7Sd032084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbXFZSsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 14:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, hmh@hmh.eng.br, mpm@selenic.com


The patch titled
     hwrng: add type categories
has been added to the -mm tree.  Its filename is
     hwrng-add-type-categories.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hwrng: add type categories
From: Michael Buesch <mb@bu3sch.de>

Don't use the word "quality", as people seem to think of the entropy
quality when hearing that word.  This uses the word "type", which is
probably better for understanding what the value really means.

This is just for building up a default policy on which device to use by
default after boot/insmod.  It has only implicitely to do with the entropy
quality of the device.

No functional change since the last patch. Just renaming.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/amd-rng.c            |    1 
 drivers/char/hw_random/core.c               |  141 ++++++++++++++----
 drivers/char/hw_random/geode-rng.c          |    1 
 drivers/char/hw_random/intel-rng.c          |    1 
 drivers/char/hw_random/ixp4xx-rng.c         |    1 
 drivers/char/hw_random/omap-rng.c           |    1 
 drivers/char/hw_random/pasemi-rng.c         |    1 
 drivers/char/hw_random/via-rng.c            |    1 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    1 
 include/linux/hw_random.h                   |   25 +++
 10 files changed, 149 insertions(+), 25 deletions(-)

diff -puN drivers/char/hw_random/amd-rng.c~hwrng-add-type-categories drivers/char/hw_random/amd-rng.c
--- a/drivers/char/hw_random/amd-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/amd-rng.c
@@ -99,6 +99,7 @@ static struct hwrng amd_rng = {
 	.cleanup	= amd_rng_cleanup,
 	.data_present	= amd_rng_data_present,
 	.data_read	= amd_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 
diff -puN drivers/char/hw_random/core.c~hwrng-add-type-categories drivers/char/hw_random/core.c
--- a/drivers/char/hw_random/core.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/core.c
@@ -78,6 +78,20 @@ static inline int hwrng_data_read(struct
 	return rng->data_read(rng, data);
 }
 
+static const char * hwrng_type_string(enum hwrng_type type)
+{
+	switch (type) {
+	case HWRNG_TYPE_DEDIC:
+		return "dedicated";
+	case HWRNG_TYPE_ONBOARD:
+		return "onboard";
+	case HWRNG_TYPE_BAD:
+		return "bad";
+	case HWRNG_TYPE_PSEUDO:
+		return "pseudo";
+	}
+	return "unknown";
+}
 
 static int rng_dev_open(struct inode *inode, struct file *filp)
 {
@@ -210,7 +224,7 @@ static ssize_t hwrng_attr_current_show(s
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
 	mutex_unlock(&rng_mutex);
 
-	return ret;
+	return min(ret, (ssize_t)PAGE_SIZE);
 }
 
 static ssize_t hwrng_attr_available_show(struct device *dev,
@@ -235,7 +249,36 @@ static ssize_t hwrng_attr_available_show
 	ret++;
 	mutex_unlock(&rng_mutex);
 
-	return ret;
+	return min(ret, (ssize_t)PAGE_SIZE);
+}
+
+static ssize_t hwrng_attr_types_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	int err;
+	ssize_t ret = 0;
+	struct hwrng *rng;
+	const char *type;
+
+	err = mutex_lock_interruptible(&rng_mutex);
+	if (err)
+		return -ERESTARTSYS;
+	buf[0] = '\0';
+	list_for_each_entry(rng, &rng_list, list) {
+		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
+		ret += strlen(rng->name);
+		strncat(buf, " type: \"", PAGE_SIZE - ret - 1);
+		ret += 8;
+		type = hwrng_type_string(rng->type);
+		strncat(buf, type, PAGE_SIZE - ret - 1);
+		ret += strlen(type);
+		strncat(buf, "\"\n", PAGE_SIZE - ret - 1);
+		ret += 2;
+	}
+	mutex_unlock(&rng_mutex);
+
+	return min(ret, (ssize_t)PAGE_SIZE);
 }
 
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
@@ -244,10 +287,58 @@ static DEVICE_ATTR(rng_current, S_IRUGO 
 static DEVICE_ATTR(rng_available, S_IRUGO,
 		   hwrng_attr_available_show,
 		   NULL);
+static DEVICE_ATTR(rng_types, S_IRUGO,
+		   hwrng_attr_types_show,
+		   NULL);
+
+
+/* Returns the RNG with the highest type value
+ * Expects rng_mutex locked. */
+static struct hwrng * select_best_hwrng(void)
+{
+	struct hwrng *rng, *ret = NULL;
+
+	list_for_each_entry(rng, &rng_list, list) {
+		if (!ret || (rng->type > ret->type))
+			ret = rng;
+	}
+
+	return ret;
+}
+
+/* Initializes the RNG with the highest type value.
+ * Expects rng_mutex locked. */
+static int init_best_hwrng(void)
+{
+	struct hwrng *rng, *prev_rng = NULL;
+	int err;
 
+	rng = select_best_hwrng();
+	if (!rng)
+		return -ENODEV;
+	if (rng == current_rng)
+		return 0;
+	if (current_rng) {
+		/* Shutdown current RNG */
+		prev_rng = current_rng;
+		hwrng_cleanup(current_rng);
+		current_rng = NULL;
+	}
+	err = hwrng_init(rng);
+	if (err) {
+		/* Try to enable the old one again. */
+		if (prev_rng && (hwrng_init(prev_rng) == 0))
+			current_rng = prev_rng;
+		return err;
+	}
+	current_rng = rng;
+
+	return 0;
+}
 
 static void unregister_miscdev(void)
 {
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_types);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 	misc_deregister(&rng_miscdev);
@@ -268,9 +359,16 @@ static int register_miscdev(void)
 				 &dev_attr_rng_available);
 	if (err)
 		goto err_remove_current;
+	err = device_create_file(rng_miscdev.this_device,
+				 &dev_attr_rng_types);
+	if (err)
+		goto err_remove_available;
+
 out:
 	return err;
 
+err_remove_available:
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 err_remove_current:
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 err_misc_dereg:
@@ -282,7 +380,7 @@ int hwrng_register(struct hwrng *rng)
 {
 	int must_register_misc;
 	int err = -EINVAL;
-	struct hwrng *old_rng, *tmp;
+	struct hwrng *tmp;
 
 	if (rng->name == NULL ||
 	    rng->data_read == NULL)
@@ -297,27 +395,26 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 
-	must_register_misc = (current_rng == NULL);
-	old_rng = current_rng;
-	if (!old_rng) {
-		err = hwrng_init(rng);
-		if (err)
-			goto out_unlock;
-		current_rng = rng;
-	}
+	must_register_misc = list_empty(&rng_list);
+	INIT_LIST_HEAD(&rng->list);
+	list_add(&rng->list, &rng_list);
+
+	init_best_hwrng();
+	/* We ignore the error code of init_best_hwrng(), as
+	 * it doesn't matter for hwrng_register(). */
 	err = 0;
 	if (must_register_misc) {
 		err = register_miscdev();
 		if (err) {
-			if (!old_rng) {
-				hwrng_cleanup(rng);
+			if (current_rng) {
+				hwrng_cleanup(current_rng);
 				current_rng = NULL;
 			}
+			list_del(&rng->list);
 			goto out_unlock;
 		}
 	}
-	INIT_LIST_HEAD(&rng->list);
-	list_add_tail(&rng->list, &rng_list);
+
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
@@ -327,21 +424,15 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
 void hwrng_unregister(struct hwrng *rng)
 {
-	int err;
-
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		hwrng_cleanup(rng);
-		if (list_empty(&rng_list)) {
-			current_rng = NULL;
-		} else {
-			current_rng = list_entry(rng_list.prev, struct hwrng, list);
-			err = hwrng_init(current_rng);
-			if (err)
-				current_rng = NULL;
-		}
+		current_rng = NULL;
+		/* Now try to init another hwrng, if any.
+		 * We're not interested if this fails or not. */
+		init_best_hwrng();
 	}
 	if (list_empty(&rng_list))
 		unregister_miscdev();
diff -puN drivers/char/hw_random/geode-rng.c~hwrng-add-type-categories drivers/char/hw_random/geode-rng.c
--- a/drivers/char/hw_random/geode-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/geode-rng.c
@@ -73,6 +73,7 @@ static struct hwrng geode_rng = {
 	.name		= "geode",
 	.data_present	= geode_rng_data_present,
 	.data_read	= geode_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 
diff -puN drivers/char/hw_random/intel-rng.c~hwrng-add-type-categories drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/intel-rng.c
@@ -216,6 +216,7 @@ static struct hwrng intel_rng = {
 	.cleanup	= intel_rng_cleanup,
 	.data_present	= intel_rng_data_present,
 	.data_read	= intel_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 struct intel_rng_hw {
diff -puN drivers/char/hw_random/ixp4xx-rng.c~hwrng-add-type-categories drivers/char/hw_random/ixp4xx-rng.c
--- a/drivers/char/hw_random/ixp4xx-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/ixp4xx-rng.c
@@ -38,6 +38,7 @@ static int ixp4xx_rng_data_read(struct h
 static struct hwrng ixp4xx_rng_ops = {
 	.name		= "ixp4xx",
 	.data_read	= ixp4xx_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 static int __init ixp4xx_rng_init(void)
diff -puN drivers/char/hw_random/omap-rng.c~hwrng-add-type-categories drivers/char/hw_random/omap-rng.c
--- a/drivers/char/hw_random/omap-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/omap-rng.c
@@ -81,6 +81,7 @@ static struct hwrng omap_rng_ops = {
 	.name		= "omap",
 	.data_present	= omap_rng_data_present,
 	.data_read	= omap_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 static int __init omap_rng_probe(struct platform_device *pdev)
diff -puN drivers/char/hw_random/pasemi-rng.c~hwrng-add-type-categories drivers/char/hw_random/pasemi-rng.c
--- a/drivers/char/hw_random/pasemi-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/pasemi-rng.c
@@ -137,6 +137,7 @@ static struct of_platform_driver rng_dri
 	.match_table	= rng_match,
 	.probe		= rng_probe,
 	.remove		= rng_remove,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 static int __init rng_init(void)
diff -puN drivers/char/hw_random/via-rng.c~hwrng-add-type-categories drivers/char/hw_random/via-rng.c
--- a/drivers/char/hw_random/via-rng.c~hwrng-add-type-categories
+++ a/drivers/char/hw_random/via-rng.c
@@ -150,6 +150,7 @@ static struct hwrng via_rng = {
 	.init		= via_rng_init,
 	.data_present	= via_rng_data_present,
 	.data_read	= via_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 
diff -puN drivers/net/wireless/bcm43xx/bcm43xx_main.c~hwrng-add-type-categories drivers/net/wireless/bcm43xx/bcm43xx_main.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c~hwrng-add-type-categories
+++ a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3278,6 +3278,7 @@ static int bcm43xx_rng_init(struct bcm43
 	bcm->rng.name = bcm->rng_name;
 	bcm->rng.data_read = bcm43xx_rng_read;
 	bcm->rng.priv = (unsigned long)bcm;
+	bcm->rng.type = HWRNG_TYPE_BAD;
 	err = hwrng_register(&bcm->rng);
 	if (err)
 		printk(KERN_ERR PFX "RNG init failed (%d)\n", err);
diff -puN include/linux/hw_random.h~hwrng-add-type-categories include/linux/hw_random.h
--- a/include/linux/hw_random.h~hwrng-add-type-categories
+++ a/include/linux/hw_random.h
@@ -16,6 +16,29 @@
 #include <linux/types.h>
 #include <linux/list.h>
 
+
+/**
+ * enum hwrng_type - Type identifier for RNG hardware
+ * @HWRNG_TYPE_DEDIC:	Dedicated RNG extension board/device.
+ * 			Use for special (non-onboard) RNG boards
+ * 			that gather entropy from good sources.
+ * @HWRNG_TYPE_ONBOARD:	Onboard-RNG or In-CPU-RNG devices.
+ * @HWRNG_TYPE_BAD:	RNG devices with an unknown quality of the
+ * 			entropy or entropy sources that could
+ * 			be influenced from outside (like normal radio
+ * 			receivers)
+ * @HWRNG_TYPE_PSEUDO:	Pseudo RNG device. Use this for devices
+ * 			which are not RNG devices by definition, but
+ * 			could be used as such. For example various
+ * 			hardware sensors, like a motion sensor.
+ */
+enum hwrng_type {
+	HWRNG_TYPE_DEDIC	= 3,
+	HWRNG_TYPE_ONBOARD	= 2,
+	HWRNG_TYPE_BAD		= 1,
+	HWRNG_TYPE_PSEUDO	= 0,
+};
+
 /**
  * struct hwrng - Hardware Random Number Generator driver
  * @name:		Unique RNG name.
@@ -28,6 +51,7 @@
  *			Returns the number of lower random bytes in "data".
  *			Must not be NULL.
  * @priv:		Private data, for use by the RNG driver.
+ * @type:		The type identifier of the RNG device.
  */
 struct hwrng {
 	const char *name;
@@ -36,6 +60,7 @@ struct hwrng {
 	int (*data_present)(struct hwrng *rng);
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	unsigned long priv;
+	enum hwrng_type type;
 
 	/* internal. */
 	struct list_head list;
_

Patches currently in -mm which might be from mb@bu3sch.de are

o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
hwrng-add-type-categories.patch
