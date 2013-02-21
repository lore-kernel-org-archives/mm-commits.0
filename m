From: akpm@linux-foundation.org
Subject: [folded-merged] fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:22:07 -0800
Message-ID: <20130221232207.F3AA95A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:54761 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3BUXWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:22:10 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so10810qcr.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:22:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fb: hx8357: Use static arrays for LCD configuration
has been removed from the -mm tree.  Its filename was
     fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch

This patch was dropped because it was folded into fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: fb: hx8357: Use static arrays for LCD configuration

This allows a smaller and less error-prone code by using static arrays
and the ARRAY_SIZE macro.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |  173 +++++++++++++++--------------
 1 file changed, 95 insertions(+), 78 deletions(-)

diff -puN drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration
+++ a/drivers/video/backlight/hx8357.c
@@ -78,6 +78,71 @@ struct hx8357_data {
 	int			state;
 };
 
+static u8 hx8357_seq_power[] = {
+	HX8357_SET_POWER, 0x44, 0x41, 0x06,
+};
+
+static u8 hx8357_seq_vcom[] = {
+	HX8357_SET_VCOM, 0x40, 0x10,
+};
+
+static u8 hx8357_seq_power_normal[] = {
+	HX8357_SET_POWER_NORMAL, 0x05, 0x12,
+};
+
+static u8 hx8357_seq_panel_driving[] = {
+	HX8357_SET_PANEL_DRIVING, 0x14, 0x3b, 0x00, 0x02, 0x11,
+};
+
+static u8 hx8357_seq_display_frame[] = {
+	HX8357_SET_DISPLAY_FRAME, 0x0c,
+};
+
+static u8 hx8357_seq_panel_related[] = {
+	HX8357_SET_PANEL_RELATED, 0x01,
+};
+
+static u8 hx8357_seq_undefined1[] = {
+	0xea, 0x03, 0x00, 0x00,
+};
+
+static u8 hx8357_seq_undefined2[] = {
+	0xeb, 0x40, 0x54, 0x26, 0xdb,
+};
+
+static u8 hx8357_seq_gamma[] = {
+	HX8357_SET_GAMMA, 0x00, 0x15, 0x00, 0x22, 0x00,
+	0x08, 0x77, 0x26, 0x77, 0x22, 0x04, 0x00,
+};
+
+static u8 hx8357_seq_address_mode[] = {
+	HX8357_SET_ADDRESS_MODE, 0xc0,
+};
+
+static u8 hx8357_seq_pixel_format[] = {
+	HX8357_SET_PIXEL_FORMAT,
+	HX8357_SET_PIXEL_FORMAT_DPI_18BIT |
+	HX8357_SET_PIXEL_FORMAT_DBI_18BIT,
+};
+
+static u8 hx8357_seq_column_address[] = {
+	HX8357_SET_COLUMN_ADDRESS, 0x00, 0x00, 0x01, 0x3f,
+};
+
+static u8 hx8357_seq_page_address[] = {
+	HX8357_SET_PAGE_ADDRESS, 0x00, 0x00, 0x01, 0xdf,
+};
+
+static u8 hx8357_seq_rgb[] = {
+	HX8357_SET_RGB, 0x02,
+};
+
+static u8 hx8357_seq_display_mode[] = {
+	HX8357_SET_DISPLAY_MODE,
+	HX8357_SET_DISPLAY_MODE_RGB_THROUGH |
+	HX8357_SET_DISPLAY_MODE_RGB_INTERFACE,
+};
+
 static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
 				u8 *txbuf, u16 txlen,
 				u8 *rxbuf, u16 rxlen)
@@ -179,7 +244,6 @@ static int hx8357_exit_standby(struct lc
 static int hx8357_lcd_init(struct lcd_device *lcdev)
 {
 	struct hx8357_data *lcd = lcd_get_data(lcdev);
-	u8 buf[16];
 	int ret;
 
 	/*
@@ -198,125 +262,78 @@ static int hx8357_lcd_init(struct lcd_de
 	gpio_set_value(lcd->reset, 1);
 	msleep(120);
 
-	buf[0] = HX8357_SET_POWER;
-	buf[1] = 0x44;
-	buf[2] = 0x41;
-	buf[3] = 0x06;
-	ret = hx8357_spi_write_array(lcdev, buf, 4);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_power,
+				ARRAY_SIZE(hx8357_seq_power));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_VCOM;
-	buf[1] = 0x40;
-	buf[2] = 0x10;
-	ret = hx8357_spi_write_array(lcdev, buf, 3);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_vcom,
+				ARRAY_SIZE(hx8357_seq_vcom));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_POWER_NORMAL;
-	buf[1] = 0x05;
-	buf[2] = 0x12;
-	ret = hx8357_spi_write_array(lcdev, buf, 3);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_power_normal,
+				ARRAY_SIZE(hx8357_seq_power_normal));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_PANEL_DRIVING;
-	buf[1] = 0x14;
-	buf[2] = 0x3b;
-	buf[3] = 0x00;
-	buf[4] = 0x02;
-	buf[5] = 0x11;
-	ret = hx8357_spi_write_array(lcdev, buf, 6);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_panel_driving,
+				ARRAY_SIZE(hx8357_seq_panel_driving));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_DISPLAY_FRAME;
-	buf[1] = 0x0c;
-	ret = hx8357_spi_write_array(lcdev, buf, 2);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_display_frame,
+				ARRAY_SIZE(hx8357_seq_display_frame));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_PANEL_RELATED;
-	buf[1] = 0x01;
-	ret = hx8357_spi_write_array(lcdev, buf, 2);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_panel_related,
+				ARRAY_SIZE(hx8357_seq_panel_related));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = 0xea;
-	buf[1] = 0x03;
-	buf[2] = 0x00;
-	buf[3] = 0x00;
-	ret = hx8357_spi_write_array(lcdev, buf, 4);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_undefined1,
+				ARRAY_SIZE(hx8357_seq_undefined1));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = 0xeb;
-	buf[1] = 0x40;
-	buf[2] = 0x54;
-	buf[3] = 0x26;
-	buf[4] = 0xdb;
-	ret = hx8357_spi_write_array(lcdev, buf, 5);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_undefined2,
+				ARRAY_SIZE(hx8357_seq_undefined2));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_GAMMA;
-	buf[1] = 0x00;
-	buf[2] = 0x15;
-	buf[3] = 0x00;
-	buf[4] = 0x22;
-	buf[5] = 0x00;
-	buf[6] = 0x08;
-	buf[7] = 0x77;
-	buf[8] = 0x26;
-	buf[9] = 0x77;
-	buf[10] = 0x22;
-	buf[11] = 0x04;
-	buf[12] = 0x00;
-	ret = hx8357_spi_write_array(lcdev, buf, 13);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_gamma,
+				ARRAY_SIZE(hx8357_seq_gamma));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_ADDRESS_MODE;
-	buf[1] = 0xc0;
-	ret = hx8357_spi_write_array(lcdev, buf, 2);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_address_mode,
+				ARRAY_SIZE(hx8357_seq_address_mode));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_PIXEL_FORMAT;
-	buf[1] = HX8357_SET_PIXEL_FORMAT_DPI_18BIT |
-		HX8357_SET_PIXEL_FORMAT_DBI_18BIT;
-	ret = hx8357_spi_write_array(lcdev, buf, 2);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_pixel_format,
+				ARRAY_SIZE(hx8357_seq_pixel_format));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_COLUMN_ADDRESS;
-	buf[1] = 0x00;
-	buf[2] = 0x00;
-	buf[3] = 0x01;
-	buf[4] = 0x3f;
-	ret = hx8357_spi_write_array(lcdev, buf, 5);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_column_address,
+				ARRAY_SIZE(hx8357_seq_column_address));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_PAGE_ADDRESS;
-	buf[1] = 0x00;
-	buf[2] = 0x00;
-	buf[3] = 0x01;
-	buf[4] = 0xdf;
-	ret = hx8357_spi_write_array(lcdev, buf, 5);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_page_address,
+				ARRAY_SIZE(hx8357_seq_page_address));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_RGB;
-	buf[1] = 0x02;
-	ret = hx8357_spi_write_array(lcdev, buf, 2);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_rgb,
+				ARRAY_SIZE(hx8357_seq_rgb));
 	if (ret < 0)
 		return ret;
 
-	buf[0] = HX8357_SET_DISPLAY_MODE;
-	buf[1] = HX8357_SET_DISPLAY_MODE_RGB_THROUGH |
-		HX8357_SET_DISPLAY_MODE_RGB_INTERFACE;
-	ret = hx8357_spi_write_array(lcdev, buf, 2);
+	ret = hx8357_spi_write_array(lcdev, hx8357_seq_display_mode,
+				ARRAY_SIZE(hx8357_seq_display_mode));
 	if (ret < 0)
 		return ret;
 
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

origin.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch

