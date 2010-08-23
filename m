From: akpm@linux-foundation.org
Subject: + mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update.patch added to -mm tree
Date: Mon, 23 Aug 2010 15:58:49 -0700
Message-ID: <201008232258.o7NMwnKE019659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab0HWW6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 18:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, linux-mmc@vger.kernel.org, msb@chromium.org


The patch titled
     mmc: add config and runtime option for number of mmcblk minors
has been added to the -mm tree.  Its filename is
     mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update.patch

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

Changes since v1:
	* Runtime override of config default
	* Better help text
	* DIV_ROUND_UP for max_devices calculation
	* Clarify mmcblk device count limitations

Changes since v2 based on feedback from Mandeep Baines:
	* DIV_ROUND_UP is doing the wrong thing, we'll end up using
	  the last fractional range of minors which we shouldn't.
	* Documentation/devices.txt update
	* No need to compute max_devices twice, just do it at runtime.
	* Permission fix for the module_param -- it's readonly.
									
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Mandeep Baines <msb@chromium.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt |    6 ++++++
 drivers/mmc/card/block.c  |   10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN Documentation/devices.txt~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update Documentation/devices.txt
--- a/Documentation/devices.txt~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update
+++ a/Documentation/devices.txt
@@ -2519,6 +2519,12 @@ Your cooperation is appreciated.
 		  8 = /dev/mmcblk1      Second SD/MMC card
 		    ...
 
+		The start of next SD/MMC card can be configured with
+		CONFIG_MMC_BLOCK_MINORS, or overridden at boot/modprobe
+		time using the mmcblk.perdev_minors option. That would
+		bump the offset between each card to be the configured
+		value instead of the default 8.
+
 179 char	CCube DVXChip-based PCI products
 		  0 = /dev/dvxirq0	First DVX device
 		  1 = /dev/dvxirq1	Second DVX device
diff -puN drivers/mmc/card/block.c~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update
+++ a/drivers/mmc/card/block.c
@@ -60,7 +60,7 @@ static int perdev_minors = CONFIG_MMC_BL
  * We've only got one major, so number of mmcblk devices is
  * limited to 256 / number of minors per device.
  */
-static int max_devices = DIV_ROUND_UP(256, CONFIG_MMC_BLOCK_MINORS);
+static int max_devices;
 
 /* 256 minors, so at most 256 separate devices */
 static DECLARE_BITMAP(dev_use, 256);
@@ -79,7 +79,7 @@ struct mmc_blk_data {
 
 static DEFINE_MUTEX(open_lock);
 
-module_param(perdev_minors, int, 0644);
+module_param(perdev_minors, int, 0444);
 MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
 
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
@@ -782,10 +782,10 @@ static int __init mmc_blk_init(void)
 {
 	int res;
 
-	if (perdev_minors != CONFIG_MMC_BLOCK_MINORS) {
+	if (perdev_minors != CONFIG_MMC_BLOCK_MINORS)
 		pr_info("mmcblk: using %d minors per device\n", perdev_minors);
-		max_devices = DIV_ROUND_UP(256, perdev_minors);
-	}
+
+	max_devices = 256 / perdev_minors;
 
 	res = register_blkdev(MMC_BLOCK_MAJOR, "mmc");
 	if (res)
_

Patches currently in -mm which might be from olof@lixom.net are

linux-next.patch
mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors.patch
mmc-add-config-and-runtime-option-for-number-of-mmcblk-minors-update.patch

