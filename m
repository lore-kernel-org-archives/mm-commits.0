From: akpm@linux-foundation.org
Subject: - v4l-stk11xx-use-retval-from-stk11xx_check_device.patch removed from -mm tree
Date: Mon, 05 Nov 2007 23:33:53 -0800
Message-ID: <200711060740.lA67efTF012695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619AbXKFHkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 02:40:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     V4L: stk11xx, use retval from stk11xx_check_device
has been removed from the -mm tree.  Its filename was
     v4l-stk11xx-use-retval-from-stk11xx_check_device.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: V4L: stk11xx, use retval from stk11xx_check_device
From: Jiri Slaby <jirislaby@gmail.com>

stk11xx_check_device returns 0 for success of non-inited device, 1 for success
of inited device and negative for error cases.  bubble the negative value to
the caller.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/stk1125.c  |    2 +-
 drivers/media/video/stk1135.c  |    2 +-
 drivers/media/video/stkdcnew.c |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/stk1125.c~v4l-stk11xx-use-retval-from-stk11xx_check_device drivers/media/video/stk1125.c
--- a/drivers/media/video/stk1125.c~v4l-stk11xx-use-retval-from-stk11xx_check_device
+++ a/drivers/media/video/stk1125.c
@@ -91,7 +91,7 @@ static int stk1125_load_microcode(struct
 		retok = stk11xx_check_device(dev, 500);
 		if (retok != 1) {
 			dev_err(&dev->udev->dev, "load microcode fail\n");
-			return -EIO;
+			return retok < 0 ? retok : -EIO;
 		}
 
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
diff -puN drivers/media/video/stk1135.c~v4l-stk11xx-use-retval-from-stk11xx_check_device drivers/media/video/stk1135.c
--- a/drivers/media/video/stk1135.c~v4l-stk11xx-use-retval-from-stk11xx_check_device
+++ a/drivers/media/video/stk1135.c
@@ -64,7 +64,7 @@ static int stk1135_load_microcode(struct
 		retok = stk11xx_check_device(dev, 500);
 		if (retok != 1) {
 			dev_err(&dev->udev->dev, "load microcode failed\n");
-			return -EIO;
+			return retok < 0 ? retok : -EIO;
 		}
 
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
diff -puN drivers/media/video/stkdcnew.c~v4l-stk11xx-use-retval-from-stk11xx_check_device drivers/media/video/stkdcnew.c
--- a/drivers/media/video/stkdcnew.c~v4l-stk11xx-use-retval-from-stk11xx_check_device
+++ a/drivers/media/video/stkdcnew.c
@@ -102,10 +102,9 @@ static int stkdcnew_load_microcode(struc
 		stk11xx_write_reg(dev, 0x0200, 0x01);
 
 		retok = stk11xx_check_device(dev, 500);
-
 		if (retok != 1) {
 			dev_err(&dev->udev->dev, "load microcode fail!\n");
-			return -EIO;
+			return retok < 0 ? retok : -EIO;
 		}
 
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
