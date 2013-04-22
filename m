From: akpm@linux-foundation.org
Subject: + backlight-lp855x-remove-duplicate-platform-data.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:47:20 -0700
Message-ID: <20130422224720.D139A31C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61269 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3DVWrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:47:22 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so5707qad.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:47:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com


The patch titled
     Subject: backlight: lp855x: remove duplicate platform data
has been added to the -mm tree.  Its filename is
     backlight-lp855x-remove-duplicate-platform-data.patch

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
Subject: backlight: lp855x: remove duplicate platform data

The 'load_new_rom_data' was used for checking whether new ROM data should
be updated or not.

However, we can decide it with 'size_program' data.  If the size is
greater than 0, it means updating ROM area is required.  Otherwise, the
default ROM data will be used.  Therefore, this duplicate platform data
can be removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt |    4 ----
 drivers/video/backlight/lp855x_bl.c       |    2 +-
 include/linux/platform_data/lp855x.h      |    4 ----
 3 files changed, 1 insertion(+), 9 deletions(-)

diff -puN Documentation/backlight/lp855x-driver.txt~backlight-lp855x-remove-duplicate-platform-data Documentation/backlight/lp855x-driver.txt
--- a/Documentation/backlight/lp855x-driver.txt~backlight-lp855x-remove-duplicate-platform-data
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -36,9 +36,6 @@ For supporting platform specific data, t
 * initial_brightness : Initial value of backlight brightness.
 * period_ns : Platform specific PWM period value. unit is nano.
 	     Only valid when brightness is pwm input mode.
-* load_new_rom_data :
-	0 : use default configuration data
-	1 : update values of eeprom or eprom registers on loading driver
 * size_program : Total size of lp855x_rom_data.
 * rom_data : List of new eeprom/eprom registers.
 
@@ -55,7 +52,6 @@ static struct lp855x_platform_data lp855
 	.name = "lcd-bl",
 	.device_control = I2C_CONFIG(LP8552),
 	.initial_brightness = INITIAL_BRT,
-	.load_new_rom_data = 1,
 	.size_program = ARRAY_SIZE(lp8552_eeprom_arr),
 	.rom_data = lp8552_eeprom_arr,
 };
diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-remove-duplicate-platform-data drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-remove-duplicate-platform-data
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -192,7 +192,7 @@ static int lp855x_configure(struct lp855
 	if (ret)
 		goto err;
 
-	if (pd->load_new_rom_data && pd->size_program) {
+	if (pd->size_program > 0) {
 		for (i = 0; i < pd->size_program; i++) {
 			addr = pd->rom_data[i].addr;
 			val = pd->rom_data[i].val;
diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x-remove-duplicate-platform-data include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x-remove-duplicate-platform-data
+++ a/include/linux/platform_data/lp855x.h
@@ -115,9 +115,6 @@ struct lp855x_rom_data {
  * @initial_brightness : initial value of backlight brightness
  * @period_ns : platform specific pwm period value. unit is nano.
 		Only valid when mode is PWM_BASED.
- * @load_new_rom_data :
-	0 : use default configuration data
-	1 : update values of eeprom or eprom registers on loading driver
  * @size_program : total size of lp855x_rom_data
  * @rom_data : list of new eeprom/eprom registers
  */
@@ -126,7 +123,6 @@ struct lp855x_platform_data {
 	u8 device_control;
 	u8 initial_brightness;
 	unsigned int period_ns;
-	u8 load_new_rom_data;
 	int size_program;
 	struct lp855x_rom_data *rom_data;
 };
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

linux-next.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch
backlight-lp855x-convert-a-type-of-device-name.patch
backlight-lp855x-move-backlight-mode-platform-data.patch
backlight-lp855x-fix-initial-brightness-type.patch
backlight-lp855x-remove-duplicate-platform-data.patch
backlight-lp855x-add-a-device-tree-structure.patch

