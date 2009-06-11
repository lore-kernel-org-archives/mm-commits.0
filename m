From: akpm@linux-foundation.org
Subject: + gpio-pca953x-get-platform_data-from-openfirmware.patch added to -mm tree
Date: Thu, 11 Jun 2009 15:29:25 -0700
Message-ID: <200906112229.n5BMTPik007900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbZFKW36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 18:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ncase@xes-inc.com, david-b@pacbell.net


The patch titled
     gpio: pca953x: Get platform_data from OpenFirmware
has been added to the -mm tree.  Its filename is
     gpio-pca953x-get-platform_data-from-openfirmware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x: Get platform_data from OpenFirmware
From: Nate Case <ncase@xes-inc.com>

On OpenFirmware platforms, it makes the most sense to get platform_data
from the device tree.  Make an attempt to translate OF node properties
into platform_data struct before bailing out.

Note that the implementation approach taken differs from other device
drivers that make use of device tree information.  This is because I2C
chips are already registered automatically by of_i2c, so we can get by
with a small translator function in the driver.

Signed-off-by: Nate Case <ncase@xes-inc.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |   79 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 74 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-get-platform_data-from-openfirmware drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-get-platform_data-from-openfirmware
+++ a/drivers/gpio/pca953x.c
@@ -15,6 +15,10 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
+#ifdef CONFIG_OF_GPIO
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#endif
 
 #include <asm/gpio.h>
 
@@ -49,6 +53,7 @@ struct pca953x_chip {
 	uint16_t reg_direction;
 
 	struct i2c_client *client;
+	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
 	char **names;
 };
@@ -196,6 +201,55 @@ static void pca953x_setup_gpio(struct pc
 	gc->names = chip->names;
 }
 
+/*
+ * Handlers for alternative sources of platform_data
+ */
+#ifdef CONFIG_OF_GPIO
+/*
+ * Translate OpenFirmware node properties into platform_data
+ */
+static struct pca953x_platform_data *
+pca953x_get_alt_pdata(struct i2c_client *client)
+{
+	struct pca953x_platform_data *pdata;
+	struct device_node *node;
+	const uint16_t *val;
+
+	node = dev_archdata_get_node(&client->dev.archdata);
+	if (node == NULL)
+		return NULL;
+
+	pdata = kzalloc(sizeof(struct pca953x_platform_data), GFP_KERNEL);
+	if (pdata == NULL) {
+		dev_err(&client->dev, "Unable to allocate platform_data\n");
+		return NULL;
+	}
+
+	pdata->gpio_base = -1;
+	val = of_get_property(node, "linux,gpio-base", NULL);
+	if (val) {
+		if (*val < 0)
+			dev_warn(&client->dev,
+				 "invalid gpio-base in device tree\n");
+		else
+			pdata->gpio_base = *val;
+	}
+
+	val = of_get_property(node, "polarity", NULL);
+	if (val) {
+		pdata->invert = *val;
+	}
+
+	return pdata;
+}
+#else
+static struct pca953x_platform_data *
+pca953x_get_alt_pdata(struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
 static int __devinit pca953x_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
@@ -203,15 +257,25 @@ static int __devinit pca953x_probe(struc
 	struct pca953x_chip *chip;
 	int ret;
 
+	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
 	pdata = client->dev.platform_data;
 	if (pdata == NULL) {
-		dev_dbg(&client->dev, "no platform data\n");
-		return -EINVAL;
+		pdata = pca953x_get_alt_pdata(client);
+		/*
+		 * Unlike normal platform_data, this is allocated
+		 * dynamically and must be freed in the driver
+		 */
+		chip->dyn_pdata = pdata;
 	}
 
-	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		ret = -EINVAL;
+		goto out_failed;
+	}
 
 	chip->client = client;
 
@@ -253,6 +317,8 @@ static int __devinit pca953x_probe(struc
 	return 0;
 
 out_failed:
+	if (chip->dyn_pdata != NULL)
+		kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
 }
@@ -280,6 +346,9 @@ static int pca953x_remove(struct i2c_cli
 		return ret;
 	}
 
+	if (chip->dyn_pdata != NULL)
+		kfree(chip->dyn_pdata);
+
 	kfree(chip);
 	return 0;
 }
_

Patches currently in -mm which might be from ncase@xes-inc.com are

gpio-pca953x-get-platform_data-from-openfirmware.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
gpio-pca953x-add-support-for-pca9556.patch

