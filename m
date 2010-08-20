From: akpm@linux-foundation.org
Subject: + mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors.patch added to -mm tree
Date: Thu, 19 Aug 2010 18:15:05 -0700
Message-ID: <201008200112.o7K1CHWw019281__1739.84785001284$1282266745$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab0HTBMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 21:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, linux-mmc@vger.kernel.org


The patch titled
     mmc: add config and runtime option for number of mmcblk minors
has been added to the -mm tree.  Its filename is
     mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors.patch

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
Subject: mmc: add config and runtime option for number of mmcblk minors
From: Olof Johansson <olof@lixom.net>

The old limit of number of minor numbers per mmcblk device was hardcoded
at 8.  This isn't enough for some of the more elaborate partitioning
schemes, for example those used by Chrome OS.

Since there might be a bunch of systems out there with static /dev
contents that relies on the old numbering scheme, let's make it a
build-time option with the default set to the previous 8.

Also provide a boot/modprobe-time parameter to override the config
default: mmcblk.perdev_minors.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/Kconfig |   17 +++++++++++++++
 drivers/mmc/card/block.c |   41 +++++++++++++++++++++++++++----------
 2 files changed, 47 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/card/Kconfig~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors drivers/mmc/card/Kconfig
--- a/drivers/mmc/card/Kconfig~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors
+++ a/drivers/mmc/card/Kconfig
@@ -14,6 +14,23 @@ config MMC_BLOCK
 	  mount the filesystem. Almost everyone wishing MMC support
 	  should say Y or M here.
 
+config MMC_BLOCK_MINORS
+	int "Number of minors per block device"
+	range 4 256
+	default 8
+	help
+	  Number of minors per block device. One is needed for every
+	  partition on the disk (plus one for the whole disk).
+
+	  Number of total MMC minors available is 256, so your number
+	  of supported block devices will be limited to 256 divided
+	  by this number.
+
+	  Default is 8 to be backwards compatible with previous
+	  hardwired device numbering.
+
+	  If unsure, say 8 here.
+
 config MMC_BLOCK_BOUNCE
 	bool "Use bounce buffer for simple hosts"
 	depends on MMC_BLOCK
diff -puN drivers/mmc/card/block.c~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors
+++ a/drivers/mmc/card/block.c
@@ -44,14 +44,26 @@
 #include "queue.h"
 
 MODULE_ALIAS("mmc:block");
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "mmcblk."
+
+
+/*
+ * The defaults come from config options but can be overriden by module
+ * or bootarg options.
+ */
+static int perdev_minors = CONFIG_MMC_BLOCK_MINORS;
 
 /*
- * max 8 partitions per card
+ * We've only got one major, so number of mmcblk devices is
+ * limited to 256 / number of minors per device.
  */
-#define MMC_SHIFT	3
-#define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
+static int max_devices = DIV_ROUND_UP(256, CONFIG_MMC_BLOCK_MINORS);
 
-static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
+/* 256 minors, so at most 256 separate devices */
+static DECLARE_BITMAP(dev_use, 256);
 
 /*
  * There is one mmc_blk_data per slot.
@@ -67,6 +79,9 @@ struct mmc_blk_data {
 
 static DEFINE_MUTEX(open_lock);
 
+module_param(perdev_minors, int, 0644);
+MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
+
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 {
 	struct mmc_blk_data *md;
@@ -88,10 +103,10 @@ static void mmc_blk_put(struct mmc_blk_d
 	md->usage--;
 	if (md->usage == 0) {
 		int devmaj = MAJOR(disk_devt(md->disk));
-		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
+		int devidx = MINOR(disk_devt(md->disk)) / perdev_minors;
 
 		if (!devmaj)
-			devidx = md->disk->first_minor >> MMC_SHIFT;
+			devidx = md->disk->first_minor / perdev_minors;
 
 		blk_cleanup_queue(md->queue.queue);
 
@@ -567,8 +582,8 @@ static struct mmc_blk_data *mmc_blk_allo
 	struct mmc_blk_data *md;
 	int devidx, ret;
 
-	devidx = find_first_zero_bit(dev_use, MMC_NUM_MINORS);
-	if (devidx >= MMC_NUM_MINORS)
+	devidx = find_first_zero_bit(dev_use, max_devices);
+	if (devidx >= max_devices)
 		return ERR_PTR(-ENOSPC);
 	__set_bit(devidx, dev_use);
 
@@ -585,7 +600,7 @@ static struct mmc_blk_data *mmc_blk_allo
 	 */
 	md->read_only = mmc_blk_readonly(card);
 
-	md->disk = alloc_disk(1 << MMC_SHIFT);
+	md->disk = alloc_disk(perdev_minors);
 	if (md->disk == NULL) {
 		ret = -ENOMEM;
 		goto err_kfree;
@@ -602,7 +617,7 @@ static struct mmc_blk_data *mmc_blk_allo
 	md->queue.data = md;
 
 	md->disk->major	= MMC_BLOCK_MAJOR;
-	md->disk->first_minor = devidx << MMC_SHIFT;
+	md->disk->first_minor = devidx * perdev_minors;
 	md->disk->fops = &mmc_bdops;
 	md->disk->private_data = md;
 	md->disk->queue = md->queue.queue;
@@ -678,7 +693,6 @@ static int mmc_blk_probe(struct mmc_card
 {
 	struct mmc_blk_data *md;
 	int err;
