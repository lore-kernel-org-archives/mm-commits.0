From: akpm@linux-foundation.org
Subject: - mmc-add-gpio-based-mmc-sd-driver-add-locking.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:30:03 -0700
Message-ID: <200807252330.m6PNU4J4005124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYGYXaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     gpiommc: Add locking
has been removed from the -mm tree.  Its filename was
     mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

This patch was dropped because it was folded into mmc-add-gpio-based-mmc-sd-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiommc: Add locking
From: Michael Buesch <mb@bu3sch.de>

The gpiommc configfs context structure needs locking, as configfs does not
lock access between files (or if it does, we shouldn't depend on this to
magically happen).

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/gpiommc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/mmc/host/gpiommc.c~mmc-add-gpio-based-mmc-sd-driver-add-locking drivers/mmc/host/gpiommc.c
--- a/drivers/mmc/host/gpiommc.c~mmc-add-gpio-based-mmc-sd-driver-add-locking
+++ a/drivers/mmc/host/gpiommc.c
@@ -143,6 +143,8 @@ struct gpiommc_configfs_device {
 	struct platform_device *pdev;
 	/* The configuration */
 	struct gpiommc_platform_data pdata;
+	/* Mutex to protect this structure */
+	struct mutex mutex;
 };
 
 #define GPIO_INVALID	-1
@@ -233,6 +235,8 @@ static ssize_t gpiommc_config_attr_show(
 	unsigned int gpio;
 	int err = 0;
 
+	mutex_lock(&dev->mutex);
+
 	if (attr == &gpiommc_attr_DI) {
 		gpio = dev->pdata.pins.gpio_di;
 		if (gpio == GPIO_INVALID)
@@ -293,6 +297,8 @@ static ssize_t gpiommc_config_attr_show(
 	WARN_ON(1);
 	err = -ENOSYS;
 out:
+	mutex_unlock(&dev->mutex);
+
 	return err ? err : count;
 }
 
@@ -352,6 +358,8 @@ static ssize_t gpiommc_config_attr_store
 	int err = -EINVAL;
 	unsigned long data;
 
+	mutex_lock(&dev->mutex);
+
 	if (attr == &gpiommc_attr_register) {
 		err = strict_strtoul(page, 10, &data);
 		if (err)
@@ -477,6 +485,8 @@ static ssize_t gpiommc_config_attr_store
 	WARN_ON(1);
 	err = -ENOSYS;
 out:
+	mutex_unlock(&dev->mutex);
+
 	return err ? err : count;
 }
 
@@ -514,6 +524,7 @@ static int gpiommc_make_item(struct conf
 	if (!dev)
 		return -ENOMEM;
 
+	mutex_init(&dev->mutex);
 	config_item_init_type_name(&dev->item, name,
 				   &gpiommc_dev_ci_type);
 
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
spi-add-spi-over-gpio-driver.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

