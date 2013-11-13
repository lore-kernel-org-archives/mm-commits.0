From: akpm@linux-foundation.org
Subject: [merged] backlight-lm3639-dont-mix-different-enum-types.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:40 -0800
Message-ID: <5283e3c8.SyUIXT5oFqZjyIUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3KMUkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lm3639-dont-mix-different-enum-types.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:40 -0800


The patch titled
     Subject: backlight: lm3639: don't mix different enum types
has been removed from the -mm tree.  Its filename was
     backlight-lm3639-dont-mix-different-enum-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3639: don't mix different enum types

Don't mix different enum types to fix the sparse warnings.

drivers/video/backlight/lm3639_bl.c:80:51: warning: mixing different enum types
drivers/video/backlight/lm3639_bl.c:80:51:     int enum lm3639_fleds  versus
drivers/video/backlight/lm3639_bl.c:80:51:     int enum lm3639_bleds
drivers/video/backlight/lm3639_bl.c:82:51: warning: mixing different enum types
drivers/video/backlight/lm3639_bl.c:82:51:     int enum lm3639_fleds  versus
drivers/video/backlight/lm3639_bl.c:82:51:     int enum lm3639_bleds

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/lm3639_bl.c~backlight-lm3639-dont-mix-different-enum-types drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~backlight-lm3639-dont-mix-different-enum-types
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -76,10 +76,13 @@ static int lm3639_chip_init(struct lm363
 		goto out;
 
 	/* output pins config. */
-	if (!pdata->init_brt_led)
-		reg_val = pdata->fled_pins | pdata->bled_pins;
-	else
-		reg_val = pdata->fled_pins | pdata->bled_pins | 0x01;
+	if (!pdata->init_brt_led) {
+		reg_val = pdata->fled_pins;
+		reg_val |= pdata->bled_pins;
+	} else {
+		reg_val = pdata->fled_pins;
+		reg_val |= pdata->bled_pins | 0x01;
+	}
 
 	ret = regmap_update_bits(pchip->regmap, REG_ENABLE, 0x79, reg_val);
 	if (ret < 0)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

