From: akpm@linux-foundation.org
Subject: - wistron_btns-add-led-support.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:17 -0700
Message-ID: <200705212009.l4LK9Gpw018759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965992AbXEUULu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, dtor@mail.ru, mitr@volny.cz, mm-commits@vger.kernel.org


The patch titled
     wistron_btns: add led support
has been removed from the -mm tree.  Its filename was
     wistron_btns-add-led-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wistron_btns: add led support
From: Eric Piel <eric.piel@tremplin-utc.net>

Add support to wistron_btns for leds that comes with the multimedia keys. 
Mail and wifi leds are supported, on laptops which have them.  Depending on
the laptop, wifi subsystem may control just the led, or both the led and
the wifi card.  Wifi led interface is activated only for the former type of
laptops, as the latter type is already managed.  Leds are controled by the
interface in /sys/class/leds.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Miloslav Trmac <mitr@volny.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig        |    5 +
 drivers/input/misc/wistron_btns.c |   88 +++++++++++++++++++++++++++-
 2 files changed, 91 insertions(+), 2 deletions(-)

diff -puN drivers/input/misc/Kconfig~wistron_btns-add-led-support drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~wistron_btns-add-led-support
+++ a/drivers/input/misc/Kconfig
@@ -65,9 +65,12 @@ config INPUT_COBALT_BTNS
 config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
 	depends on X86 && !X86_64
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  Say Y here for support of Winstron laptop button interface, used on
-	  laptops of various brands, including Acer and Fujitsu-Siemens.
+	  laptops of various brands, including Acer and Fujitsu-Siemens. If
+	  available, mail and wifi leds will be controlable via /sys/class/leds.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called wistron_btns.
diff -puN drivers/input/misc/wistron_btns.c~wistron_btns-add-led-support drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btns-add-led-support
+++ a/drivers/input/misc/wistron_btns.c
@@ -30,6 +30,7 @@
 #include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
+#include <linux/leds.h>
 
 /*
  * Number of attempts to read data from queue per poll;
@@ -46,11 +47,12 @@
 /* BIOS subsystem IDs */
 #define WIFI		0x35
 #define BLUETOOTH	0x34
+#define MAIL_LED	0x31
 
 MODULE_AUTHOR("Miloslav Trmac <mitr@volny.cz>");
 MODULE_DESCRIPTION("Wistron laptop button driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION("0.2");
+MODULE_VERSION("0.3");
 
 static int force; /* = 0; */
 module_param(force, bool, 0);
@@ -251,6 +253,7 @@ enum { KE_END, KE_KEY, KE_SW, KE_WIFI, K
 static const struct key_entry *keymap; /* = NULL; Current key map */
 static int have_wifi;
 static int have_bluetooth;
+static int have_leds;
 
 static int __init dmi_matched(struct dmi_system_id *dmi)
 {
@@ -263,6 +266,8 @@ static int __init dmi_matched(struct dmi
 		else if (key->type == KE_BLUETOOTH)
 			have_bluetooth = 1;
 	}
+	have_leds = key->code & (FE_MAIL_LED | FE_WIFI_LED);
+
 	return 1;
 }
 
@@ -1028,6 +1033,83 @@ static void report_switch(unsigned code,
 	input_sync(input_dev);
 }
 
+
+ /* led management */
+static void wistron_mail_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	bios_set_state(MAIL_LED, (value != LED_OFF) ? 1 : 0);
+}
+
+/* same as setting up wifi card, but for laptops on which the led is managed */
+static void wistron_wifi_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	bios_set_state(WIFI, (value != LED_OFF) ? 1 : 0);
+}
+
+static struct led_classdev wistron_mail_led = {
+	.name			= "mail:green",
+	.brightness_set		= wistron_mail_led_set,
+};
+
+static struct led_classdev wistron_wifi_led = {
+	.name			= "wifi:red",
+	.brightness_set		= wistron_wifi_led_set,
+};
+
+static void __devinit wistron_led_init(struct device *parent)
+{
+	if (have_leds & FE_WIFI_LED) {
+		u16 wifi = bios_get_default_setting(WIFI);
+		if (wifi & 1) {
+			wistron_wifi_led.brightness = (wifi & 2) ? LED_FULL : LED_OFF;
+			if (led_classdev_register(parent, &wistron_wifi_led))
+				have_leds &= ~FE_WIFI_LED;
+			else
+				bios_set_state(WIFI, wistron_wifi_led.brightness);
+
+		} else
+			have_leds &= ~FE_WIFI_LED;
+	}
+
+	if (have_leds & FE_MAIL_LED) {
+		/* bios_get_default_setting(MAIL) always retuns 0, so just turn the led off */
+		wistron_mail_led.brightness = LED_OFF;
+		if (led_classdev_register(parent, &wistron_mail_led))
+			have_leds &= ~FE_MAIL_LED;
+		else
+			bios_set_state(MAIL_LED, wistron_mail_led.brightness);
+	}
+}
+
+static void __devexit wistron_led_remove(void)
+{
+	if (have_leds & FE_MAIL_LED)
+		led_classdev_unregister(&wistron_mail_led);
+
+	if (have_leds & FE_WIFI_LED)
+		led_classdev_unregister(&wistron_wifi_led);
+}
+
+static inline void wistron_led_suspend(void)
+{
+	if (have_leds & FE_MAIL_LED)
+		led_classdev_suspend(&wistron_mail_led);
+
+	if (have_leds & FE_WIFI_LED)
+		led_classdev_suspend(&wistron_wifi_led);
+}
+
+static inline void wistron_led_resume(void)
+{
+	if (have_leds & FE_MAIL_LED)
+		led_classdev_resume(&wistron_mail_led);
+
+	if (have_leds & FE_WIFI_LED)
+		led_classdev_resume(&wistron_wifi_led);
+}
+
  /* Driver core */
 
 static int wifi_enabled;
@@ -1125,6 +1207,7 @@ static int __devinit wistron_probe(struc
 			bios_set_state(BLUETOOTH, bluetooth_enabled);
 	}
 
+	wistron_led_init(&dev->dev);
 	poll_bios(1); /* Flush stale event queue and arm timer */
 
 	return 0;
@@ -1133,6 +1216,7 @@ static int __devinit wistron_probe(struc
 static int __devexit wistron_remove(struct platform_device *dev)
 {
 	del_timer_sync(&poll_timer);
+	wistron_led_remove();
 	input_unregister_device(input_dev);
 	bios_detach();
 
@@ -1150,6 +1234,7 @@ static int wistron_suspend(struct platfo
 	if (have_bluetooth)
 		bios_set_state(BLUETOOTH, 0);
 
+	wistron_led_suspend();
 	return 0;
 }
 
@@ -1161,6 +1246,7 @@ static int wistron_resume(struct platfor
 	if (have_bluetooth)
 		bios_set_state(BLUETOOTH, bluetooth_enabled);
 
+	wistron_led_resume();
 	poll_bios(1);
 
 	return 0;
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

git-input.patch
