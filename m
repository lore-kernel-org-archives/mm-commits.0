From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:29 -0800
Message-ID: <20120123202130.24F1D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62897 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2AWUVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:32 -0500
Received: by eekb15 with SMTP id b15so139855eek.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp88x0_bl.c: fix bit testing logic
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/video/backlight/adp88x0_bl.c: fix bit testing logic

We need to write new value if the bit mask fields of new value is not
equal to old value.  It does not make sense to write new value only when
all the bit_mask bits are zero.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    2 +-
 drivers/video/backlight/adp8870_bl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -146,7 +146,7 @@ static int adp8860_set_bits(struct i2c_c
 
 	ret = adp8860_read(client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = adp8860_write(client, reg, reg_val);
 	}
diff -puN drivers/video/backlight/adp8870_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -160,7 +160,7 @@ static int adp8870_set_bits(struct i2c_c
 
 	ret = adp8870_read(client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = adp8870_write(client, reg, reg_val);
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

