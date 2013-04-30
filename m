From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x-convert-a-type-of-device-name.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:53 -0700
Message-ID: <20130430185253.733015A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35860 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Swy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:54 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so87913qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x: convert a type of device name
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-convert-a-type-of-device-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: lp855x: convert a type of device name

Configurable data, backlight device name is set to constant character type.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c  |    2 +-
 include/linux/platform_data/lp855x.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-convert-a-type-of-device-name drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-convert-a-type-of-device-name
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -273,7 +273,7 @@ static int lp855x_backlight_register(str
 	struct backlight_device *bl;
 	struct backlight_properties props;
 	struct lp855x_platform_data *pdata = lp->pdata;
-	char *name = pdata->name ? : DEFAULT_BL_NAME;
+	const char *name = pdata->name ? : DEFAULT_BL_NAME;
 
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = MAX_BRIGHTNESS;
diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x-convert-a-type-of-device-name include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x-convert-a-type-of-device-name
+++ a/include/linux/platform_data/lp855x.h
@@ -128,7 +128,7 @@ struct lp855x_rom_data {
  * @rom_data : list of new eeprom/eprom registers
  */
 struct lp855x_platform_data {
-	char *name;
+	const char *name;
 	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
linux-next.patch

