From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-remove-redundant-return-variables.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:20 -0800
Message-ID: <20130222204020.99B3531C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47771 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3BVUkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:21 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103866ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: remove redundant return variables
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-remove-redundant-return-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: remove redundant return variables

Redundant return variables are removed to reduce the code.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-remove-redundant-return-variables drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-remove-redundant-return-variables
+++ a/drivers/video/backlight/ld9040.c
@@ -513,14 +513,9 @@ gamma_err:
 
 static int ld9040_gamma_ctl(struct ld9040 *lcd, int gamma)
 {
-	int ret = 0;
-
-	ret = _ld9040_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
-
-	return ret;
+	return _ld9040_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
 }
 
-
 static int ld9040_ldi_init(struct ld9040 *lcd)
 {
 	int ret, i;
@@ -549,11 +544,7 @@ static int ld9040_ldi_init(struct ld9040
 
 static int ld9040_ldi_enable(struct ld9040 *lcd)
 {
-	int ret = 0;
-
-	ret = ld9040_panel_send_sequence(lcd, seq_display_on);
-
-	return ret;
+	return ld9040_panel_send_sequence(lcd, seq_display_on);
 }
 
 static int ld9040_ldi_disable(struct ld9040 *lcd)
@@ -696,7 +687,6 @@ static const struct backlight_ops ld9040
 	.update_status = ld9040_set_brightness,
 };
 
-
 static int ld9040_probe(struct spi_device *spi)
 {
 	int ret = 0;
@@ -802,7 +792,6 @@ static int ld9040_remove(struct spi_devi
 #if defined(CONFIG_PM)
 static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	int ret = 0;
 	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
@@ -811,21 +800,16 @@ static int ld9040_suspend(struct spi_dev
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
 	 */
-	ret = ld9040_power(lcd, FB_BLANK_POWERDOWN);
-
-	return ret;
+	return ld9040_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ld9040_resume(struct spi_device *spi)
 {
-	int ret = 0;
 	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
-	ret = ld9040_power(lcd, FB_BLANK_UNBLANK);
