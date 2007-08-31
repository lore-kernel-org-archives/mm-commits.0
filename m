From: akpm@linux-foundation.org
Subject: + v4l-stk11xx-use-retval-from-stk11xx_check_device.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:41:44 -0700
Message-ID: <200708311841.l7VIfi0B021266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965687AbXHaSlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mchehab@infradead.org


The patch titled
     V4L: stk11xx, use retval from stk11xx_check_device
has been added to the -mm tree.  Its filename is
     v4l-stk11xx-use-retval-from-stk11xx_check_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
git-net.patch
git-wireless.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
shrink_slab-handle-bad-shrinkers.patch
