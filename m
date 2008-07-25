From: akpm@linux-foundation.org
Subject: - mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:29:54 -0700
Message-ID: <200807252329.m6PNTsOP005100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbYGYXaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     gpiommc: fix for configfs API change
has been removed from the -mm tree.  Its filename was
     mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch

This patch was dropped because it was folded into mmc-add-gpio-based-mmc-sd-driver.patch

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
spi-add-spi-over-gpio-driver.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

