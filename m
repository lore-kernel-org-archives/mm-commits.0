From: akpm@linux-foundation.org
Subject: - rtc-ds1305-ds1306-driver-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:35:40 -0700
Message-ID: <200807232348.m6NNmHNq018575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYGWXsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: ds1305/ds1306 driver fix
has been removed from the -mm tree.  Its filename was
     rtc-ds1305-ds1306-driver-fix.patch

This patch was dropped because it was folded into rtc-ds1305-ds1306-driver.patch

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

origin.patch
atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-convert-the-pcf8583-driver-to-the-new-i2c-style-framework-with-device_ids.patch
rtc-rtc-s3c-add-__devexit-and-__devinit-markers.patch
rtc-rtc-s3c-update-irq-handling.patch
rtc-vr41xx-add-irq_set_freq-and-irq_set_state.patch

