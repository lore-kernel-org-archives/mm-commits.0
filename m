From: akpm@linux-foundation.org
Subject: + backlight-lp855x-convert-a-type-of-device-name.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:47:14 -0700
Message-ID: <20130422224714.CA74D31C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61554 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3DVWrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:47:17 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so5669qab.5
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:47:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com


The patch titled
     Subject: backlight: lp855x: convert a type of device name
has been added to the -mm tree.  Its filename is
     backlight-lp855x-convert-a-type-of-device-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch
backlight-lp855x-convert-a-type-of-device-name.patch
backlight-lp855x-move-backlight-mode-platform-data.patch
backlight-lp855x-fix-initial-brightness-type.patch
backlight-lp855x-remove-duplicate-platform-data.patch
backlight-lp855x-add-a-device-tree-structure.patch

