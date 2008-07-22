From: akpm@linux-foundation.org
Subject: + mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch added to -mm tree
Date: Mon, 21 Jul 2008 17:15:01 -0700
Message-ID: <200807220015.m6M0F13w032454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbYGVAPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 20:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx


The patch titled
     gpiommc: fix for configfs API change
has been added to the -mm tree.  Its filename is
     mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch

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
Subject: gpiommc: fix for configfs API change
From: Michael Buesch <mb@bu3sch.de>

The configfs API changed in linux-next.  This patch fixes gpiommc to use
the new API.  This fixes a compiler warning.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/gpiommc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/gpiommc.c~mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change drivers/mmc/host/gpiommc.c
--- a/drivers/mmc/host/gpiommc.c~mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change
+++ a/drivers/mmc/host/gpiommc.c
@@ -499,19 +499,20 @@ static struct config_item_type gpiommc_d
 	.ct_owner	= THIS_MODULE,
 };
 
-static struct config_item *gpiommc_make_item(struct config_group *group,
-					     const char *name)
+static int gpiommc_make_item(struct config_group *group,
+			     const char *name,
+			     struct config_item **new_item)
 {
 	struct gpiommc_configfs_device *dev;
 
 	if (strlen(name) > GPIOMMC_MAX_NAMELEN) {
 		printk(KERN_ERR PFX "configfs: device name too long\n");
-		return NULL;
+		return -E2BIG;
 	}
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
-		return NULL;
+		return -ENOMEM;
 
 	config_item_init_type_name(&dev->item, name,
 				   &gpiommc_dev_ci_type);
@@ -526,7 +527,9 @@ static struct config_item *gpiommc_make_
 	dev->pdata.no_spi_delay = 0;
 	dev->pdata.max_bus_speed = 5000000; /* 5 MHz */
 
-	return &(dev->item);
+	*new_item = &(dev->item);
+
+	return 0;
 }
 
 static void gpiommc_drop_item(struct config_group *group,
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

