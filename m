From: akpm@linux-foundation.org
Subject: + mmc-add-gpio-based-mmc-sd-driver-add-locking.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:11:30 -0700
Message-ID: <200807220811.m6M8BUFg017941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbYGVIMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx


The patch titled
     gpiommc: Add locking
has been added to the -mm tree.  Its filename is
     mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

