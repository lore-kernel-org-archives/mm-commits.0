From: akpm@linux-foundation.org
Subject: - hw_random-add-quality-categories.patch removed from -mm tree
Date: Tue, 26 Jun 2007 11:44:56 -0700
Message-ID: <200706261844.l5QIivqd032044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757362AbXFZSpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 14:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, jeff@garzik.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     hw_random: add quality categories
has been removed from the -mm tree.  Its filename was
     hw_random-add-quality-categories.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: hw_random: add quality categories
From: Michael Buesch <mb@bu3sch.de>

This adds quality categories for hardware random number generators.

The qualities of the HWRNGs are different from each other.  So the current
default policy of the hwrng core to default to the first found RNG is
broken.  This changes the default policy to select the RNG with the best
quality category.  So for a machine with a bcm43xx and a RNG in the CPU it
would always default to the RNG in the CPU, as that's the better one.

Of course, the selection can still be changed from userspace.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/amd-rng.c            |    1 
 drivers/char/hw_random/core.c               |  141 ++++++++++++++----
 drivers/char/hw_random/geode-rng.c          |    1 
 drivers/char/hw_random/intel-rng.c          |    1 
 drivers/char/hw_random/ixp4xx-rng.c         |    1 
 drivers/char/hw_random/pasemi-rng.c         |    1 
 drivers/char/hw_random/via-rng.c            |    1 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    1 
 include/linux/hw_random.h                   |   25 +++
 9 files changed, 148 insertions(+), 25 deletions(-)

diff -puN drivers/char/hw_random/amd-rng.c~hw_random-add-quality-categories drivers/char/hw_random/amd-rng.c
--- a/drivers/char/hw_random/amd-rng.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/amd-rng.c
@@ -99,6 +99,7 @@ static struct hwrng amd_rng = {
 	.cleanup	= amd_rng_cleanup,
 	.data_present	= amd_rng_data_present,
 	.data_read	= amd_rng_data_read,
+	.qual		= HWRNG_QUAL_NORMAL,
 };
 
 
diff -puN drivers/char/hw_random/core.c~hw_random-add-quality-categories drivers/char/hw_random/core.c
--- a/drivers/char/hw_random/core.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/core.c
@@ -78,6 +78,20 @@ static inline int hwrng_data_read(struct
 	return rng->data_read(rng, data);
 }
 
+static const char * hwrng_quality_string(enum hwrng_quality qual)
+{
+	switch (qual) {
+	case HWRNG_QUAL_HIGH:
+		return "high";
+	case HWRNG_QUAL_NORMAL:
+		return "normal";
+	case HWRNG_QUAL_LOW:
+		return "low";
+	case HWRNG_QUAL_PSEUDO:
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
+static ssize_t hwrng_attr_qualities_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	int err;
+	ssize_t ret = 0;
+	struct hwrng *rng;
+	const char *qual;
+
+	err = mutex_lock_interruptible(&rng_mutex);
+	if (err)
+		return -ERESTARTSYS;
+	buf[0] = '\0';
+	list_for_each_entry(rng, &rng_list, list) {
+		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
+		ret += strlen(rng->name);
+		strncat(buf, " quality: ", PAGE_SIZE - ret - 1);
+		ret += 10;
+		qual = hwrng_quality_string(rng->qual);
+		strncat(buf, qual, PAGE_SIZE - ret - 1);
+		ret += strlen(qual);
+		strncat(buf, "\n", PAGE_SIZE - ret - 1);
+		ret += 1;
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
+static DEVICE_ATTR(rng_qualities, S_IRUGO,
+		   hwrng_attr_qualities_show,
+		   NULL);
+
+
+/* Returns the RNG with the highest quality value.
+ * Expects rng_mutex locked. */
+static struct hwrng * select_best_hwrng(void)
+{
+	struct hwrng *rng, *ret = NULL;
+
+	list_for_each_entry(rng, &rng_list, list) {
+		if (!ret || (rng->qual > ret->qual))
+			ret = rng;
+	}
+
+	return ret;
+}
 
+/* Initializes the RNG with the highest quality value.
+ * Expects rng_mutex locked. */
+static int init_best_hwrng(void)
+{
+	struct hwrng *rng, *prev_rng = NULL;
+	int err;
+
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
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_qualities);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 	misc_deregister(&rng_miscdev);
@@ -268,9 +359,16 @@ static int register_miscdev(void)
 				 &dev_attr_rng_available);
 	if (err)
 		goto err_remove_current;
+	err = device_create_file(rng_miscdev.this_device,
+				 &dev_attr_rng_qualities);
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
diff -puN drivers/char/hw_random/geode-rng.c~hw_random-add-quality-categories drivers/char/hw_random/geode-rng.c
--- a/drivers/char/hw_random/geode-rng.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/geode-rng.c
@@ -73,6 +73,7 @@ static struct hwrng geode_rng = {
 	.name		= "geode",
 	.data_present	= geode_rng_data_present,
 	.data_read	= geode_rng_data_read,
+	.qual		= HWRNG_QUAL_NORMAL,
 };
 
 
diff -puN drivers/char/hw_random/intel-rng.c~hw_random-add-quality-categories drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/intel-rng.c
@@ -216,6 +216,7 @@ static struct hwrng intel_rng = {
 	.cleanup	= intel_rng_cleanup,
 	.data_present	= intel_rng_data_present,
 	.data_read	= intel_rng_data_read,
+	.qual		= HWRNG_QUAL_NORMAL,
 };
 
 struct intel_rng_hw {
diff -puN drivers/char/hw_random/ixp4xx-rng.c~hw_random-add-quality-categories drivers/char/hw_random/ixp4xx-rng.c
--- a/drivers/char/hw_random/ixp4xx-rng.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/ixp4xx-rng.c
@@ -38,6 +38,7 @@ static int ixp4xx_rng_data_read(struct h
 static struct hwrng ixp4xx_rng_ops = {
 	.name		= "ixp4xx",
 	.data_read	= ixp4xx_rng_data_read,
+	.qual		= HWRNG_QUAL_NORMAL,
 };
 
 static int __init ixp4xx_rng_init(void)
diff -puN drivers/char/hw_random/pasemi-rng.c~hw_random-add-quality-categories drivers/char/hw_random/pasemi-rng.c
--- a/drivers/char/hw_random/pasemi-rng.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/pasemi-rng.c
@@ -137,6 +137,7 @@ static struct of_platform_driver rng_dri
 	.match_table	= rng_match,
 	.probe		= rng_probe,
 	.remove		= rng_remove,
+	.qual		= HWRNG_QUAL_NORMAL,
 };
 
 static int __init rng_init(void)
diff -puN drivers/char/hw_random/via-rng.c~hw_random-add-quality-categories drivers/char/hw_random/via-rng.c
--- a/drivers/char/hw_random/via-rng.c~hw_random-add-quality-categories
+++ a/drivers/char/hw_random/via-rng.c
@@ -150,6 +150,7 @@ static struct hwrng via_rng = {
 	.init		= via_rng_init,
 	.data_present	= via_rng_data_present,
 	.data_read	= via_rng_data_read,
+	.qual		= HWRNG_QUAL_NORMAL,
 };
 
 
diff -puN drivers/net/wireless/bcm43xx/bcm43xx_main.c~hw_random-add-quality-categories drivers/net/wireless/bcm43xx/bcm43xx_main.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c~hw_random-add-quality-categories
+++ a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3278,6 +3278,7 @@ static int bcm43xx_rng_init(struct bcm43
 	bcm->rng.name = bcm->rng_name;
 	bcm->rng.data_read = bcm43xx_rng_read;
 	bcm->rng.priv = (unsigned long)bcm;
+	bcm->rng.qual = HWRNG_QUAL_LOW;
 	err = hwrng_register(&bcm->rng);
 	if (err)
 		printk(KERN_ERR PFX "RNG init failed (%d)\n", err);
diff -puN include/linux/hw_random.h~hw_random-add-quality-categories include/linux/hw_random.h
--- a/include/linux/hw_random.h~hw_random-add-quality-categories
+++ a/include/linux/hw_random.h
@@ -16,6 +16,29 @@
 #include <linux/types.h>
 #include <linux/list.h>
 
+
+/**
+ * enum hwrng_quality - Quality identifier for RNG hardware
+ * @HWRNG_QUAL_HIGH:	High quality RNG. Higher quality than
+ * 			what is found on the usual PC mainboards.
+ * 			Use that for special dedicated RNG
+ * 			extension boards.
+ * @HWRNG_QUAL_NORMAL:	PC-onboard-RNG devices.
+ * @HWRNG_QUAL_LOW:	Low quality RNG devices. Use this for
+ * 			devices which gather the entropy from possibly
+ * 			bad sources, like the network.
+ * @HWRNG_QUAL_PSEUDO:	Pseudo RNG device. Use this for devices
+ * 			which are not RNG devices by definition, but
+ * 			could be used as such. For example various
+ * 			hardware sensors, like a motion sensor.
+ */
+enum hwrng_quality {
+	HWRNG_QUAL_HIGH		= 3,
+	HWRNG_QUAL_NORMAL	= 2,
+	HWRNG_QUAL_LOW		= 1,
+	HWRNG_QUAL_PSEUDO	= 0,
+};
+
 /**
  * struct hwrng - Hardware Random Number Generator driver
  * @name:		Unique RNG name.
@@ -28,6 +51,7 @@
  *			Returns the number of lower random bytes in "data".
  *			Must not be NULL.
  * @priv:		Private data, for use by the RNG driver.
+ * @qual:		The quality category of the RNG device.
  */
 struct hwrng {
 	const char *name;
@@ -36,6 +60,7 @@ struct hwrng {
 	int (*data_present)(struct hwrng *rng);
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	unsigned long priv;
+	enum hwrng_quality qual;
 
 	/* internal. */
 	struct list_head list;
_

Patches currently in -mm which might be from mb@bu3sch.de are

o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
hw_random-add-quality-categories.patch
