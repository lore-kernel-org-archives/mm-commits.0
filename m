From: akpm@linux-foundation.org
Subject: + rtc-ds1305-ds1306-driver-fix.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:14:38 -0700
Message-ID: <200807021714.m62HEcdR027151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbYGBROz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc: ds1305/ds1306 driver fix
has been added to the -mm tree.  Its filename is
     rtc-ds1305-ds1306-driver-fix.patch

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
Subject: rtc: ds1305/ds1306 driver fix
From: David Brownell <david-b@pacbell.net>

Be differently paranoid about params from userspace: prevent
overflows too, 96 + 96 fits in an "unsigned long".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-ds1305-ds1306-driver-fix drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-ds1305-ds1306-driver-fix
+++ a/drivers/rtc/rtc-ds1305.c
@@ -557,6 +557,8 @@ ds1305_nvram_read(struct kobject *kobj, 
 
 	if (unlikely(off >= DS1305_NVRAM_LEN))
 		return 0;
+	if (count >= DS1305_NVRAM_LEN)
+		count = DS1305_NVRAM_LEN;
 	if ((off + count) > DS1305_NVRAM_LEN)
 		count = DS1305_NVRAM_LEN - off;
 	if (unlikely(!count))
@@ -585,6 +587,8 @@ ds1305_nvram_write(struct kobject *kobj,
 
 	if (unlikely(off >= DS1305_NVRAM_LEN))
 		return -EFBIG;
+	if (count >= DS1305_NVRAM_LEN)
+		count = DS1305_NVRAM_LEN;
 	if ((off + count) > DS1305_NVRAM_LEN)
 		count = DS1305_NVRAM_LEN - off;
 	if (unlikely(!count))
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_read_alarm-handles-wraparound.patch
gpio-pca953x-i2c-handles-max7310-too.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_nand-speedup-via-readwritesbw.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch

