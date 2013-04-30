From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x-remove-duplicate-platform-data.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:02 -0700
Message-ID: <20130430185302.776705A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63935 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3D3SxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:03 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86444vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x: remove duplicate platform data
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-remove-duplicate-platform-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

