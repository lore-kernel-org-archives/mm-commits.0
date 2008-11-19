From: akpm@linux-foundation.org
Subject: - led-simplify-led_trigger_register_simple.patch removed from -mm tree
Date: Tue, 18 Nov 2008 16:30:57 -0800
Message-ID: <200811190030.mAJ0UvDV024514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbYKSAbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:31:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: felipe.balbi@nokia.com, cbou@mail.ru, drzeus@drzeus.cx, dwmw2@infradead.org, greg@kroah.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     leds: simplify led_trigger_register_simple
has been removed from the -mm tree.  Its filename was
     led-simplify-led_trigger_register_simple.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: simplify led_trigger_register_simple
From: Felipe Balbi <felipe.balbi@nokia.com>

We can make led_trigger_register_simple by returning a struct led_trigger
*, instead of passing a struct led_trigger ** as a parameter and changing
it inside the function.

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-triggers.c         |   25 ++++++++++--------
 drivers/leds/ledtrig-ide-disk.c     |    6 +++-
 drivers/mmc/core/host.c             |    4 ++
 drivers/mtd/nand/nand_base.c        |    5 ++-
 drivers/power/power_supply_leds.c   |   36 ++++++++++++++++++++------
 drivers/staging/at76_usb/at76_usb.c |    6 +++-
 include/linux/leds.h                |    5 +--
 7 files changed, 63 insertions(+), 24 deletions(-)

diff -puN drivers/leds/led-triggers.c~led-simplify-led_trigger_register_simple drivers/leds/led-triggers.c
--- a/drivers/leds/led-triggers.c~led-simplify-led_trigger_register_simple
+++ a/drivers/leds/led-triggers.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -222,24 +223,28 @@ void led_trigger_event(struct led_trigge
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
-void led_trigger_register_simple(const char *name, struct led_trigger **tp)
+struct led_trigger *led_trigger_register_simple(const char *name)
 {
 	struct led_trigger *trigger;
 	int err;
 
 	trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-
-	if (trigger) {
-		trigger->name = name;
-		err = led_trigger_register(trigger);
-		if (err < 0)
-			printk(KERN_WARNING "LED trigger %s failed to register"
-				" (%d)\n", name, err);
-	} else
+	if (!trigger) {
 		printk(KERN_WARNING "LED trigger %s failed to register"
 			" (no memory)\n", name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	trigger->name = name;
+	err = led_trigger_register(trigger);
+	if (err < 0) {
+		printk(KERN_WARNING "LED trigger %s failed to register"
+				" (%d)\n", name, err);
+		kfree(trigger);
+		return ERR_PTR(err);
+	}
 
-	*tp = trigger;
+	return trigger;
 }
 EXPORT_SYMBOL_GPL(led_trigger_register_simple);
 
diff -puN drivers/leds/ledtrig-ide-disk.c~led-simplify-led_trigger_register_simple drivers/leds/ledtrig-ide-disk.c
--- a/drivers/leds/ledtrig-ide-disk.c~led-simplify-led_trigger_register_simple
+++ a/drivers/leds/ledtrig-ide-disk.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/leds.h>
@@ -46,7 +47,10 @@ static void ledtrig_ide_timerfunc(unsign
 
 static int __init ledtrig_ide_init(void)
 {
-	led_trigger_register_simple("ide-disk", &ledtrig_ide);
+	ledtrig_ide = led_trigger_register_simple("ide-disk");
+	if (IS_ERR(ledtrig_ide))
+		return PTR_ERR(ledtrig_ide);
+
 	return 0;
 }
 
diff -puN drivers/mmc/core/host.c~led-simplify-led_trigger_register_simple drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~led-simplify-led_trigger_register_simple
+++ a/drivers/mmc/core/host.c
@@ -120,7 +120,9 @@ int mmc_add_host(struct mmc_host *host)
 	WARN_ON((host->caps & MMC_CAP_SDIO_IRQ) &&
 		!host->ops->enable_sdio_irq);
 
-	led_trigger_register_simple(dev_name(&host->class_dev), &host->led);
+	host->led = led_trigger_register_simple(dev_name(&host->class_dev));
+	if (IS_ERR(host->led))
+		return PTR_ERR(host->led);
 
 	err = device_add(&host->class_dev);
 	if (err)
diff -puN drivers/mtd/nand/nand_base.c~led-simplify-led_trigger_register_simple drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~led-simplify-led_trigger_register_simple
+++ a/drivers/mtd/nand/nand_base.c
@@ -2781,7 +2781,10 @@ EXPORT_SYMBOL_GPL(nand_release);
 
 static int __init nand_base_init(void)
 {
-	led_trigger_register_simple("nand-disk", &nand_led_trigger);
+	nand_led_trigger = led_trigger_register_simple("nand-disk");
+	if (IS_ERR(nand_led_trigger))
+		return PTR_ERR(nand_led_trigger);
+
 	return 0;
 }
 
diff -puN drivers/power/power_supply_leds.c~led-simplify-led_trigger_register_simple drivers/power/power_supply_leds.c
--- a/drivers/power/power_supply_leds.c~led-simplify-led_trigger_register_simple
+++ a/drivers/power/power_supply_leds.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/power_supply.h>
 
 #include "power_supply.h"
@@ -63,15 +64,32 @@ static int power_supply_create_bat_trigg
 	if (!psy->full_trig_name)
 		goto full_failed;
 
-	led_trigger_register_simple(psy->charging_full_trig_name,
-				    &psy->charging_full_trig);
-	led_trigger_register_simple(psy->charging_trig_name,
-				    &psy->charging_trig);
-	led_trigger_register_simple(psy->full_trig_name,
-				    &psy->full_trig);
+	psy->charging_full_trig = led_trigger_register_simple(
+			psy->charging_full_trig_name);
+	if (IS_ERR(psy->charging_full_trig)) {
+		rc = PTR_ERR(psy->charging_full_trig);
+		goto full_failed;
+	}
+
+	psy->charging_trig = led_trigger_register_simple(
+			psy->charging_trig_name);
+	if (IS_ERR(psy->charging_trig)) {
+		rc = PTR_ERR(psy->charging_full_trig);
+		goto charging_trig_failed;
+	}
+
+	psy->full_trig = led_trigger_register_simple(psy->full_trig_name);
+	if (IS_ERR(psy->full_trig)) {
+		rc = PTR_ERR(psy->charging_full_trig);
+		goto full_trig_failed;
+	}
 
 	goto success;
 
+full_trig_failed:
+	led_trigger_unregister_simple(psy->charging_trig);
+charging_trig_failed:
+	led_trigger_unregister_simple(psy->charging_full_trig);
 full_failed:
 	kfree(psy->charging_trig_name);
 charging_failed:
@@ -117,7 +135,11 @@ static int power_supply_create_gen_trigg
 	if (!psy->online_trig_name)
 		goto online_failed;
 
-	led_trigger_register_simple(psy->online_trig_name, &psy->online_trig);
+	psy->online_trig = led_trigger_register_simple(psy->online_trig_name);
+	if (IS_ERR(psy->online_trig)) {
+		rc = PTR_ERR(psy->online_trig);
+		goto online_failed;
+	}
 
 	goto success;
 
diff -puN drivers/staging/at76_usb/at76_usb.c~led-simplify-led_trigger_register_simple drivers/staging/at76_usb/at76_usb.c
--- a/drivers/staging/at76_usb/at76_usb.c~led-simplify-led_trigger_register_simple
+++ a/drivers/staging/at76_usb/at76_usb.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -2724,7 +2725,10 @@ static int __init at76_mod_init(void)
 		printk(KERN_ERR DRIVER_NAME
 		       ": usb_register failed (status %d)\n", result);
 
-	led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
+	ledtrig_tx = led_trigger_register_simple("at76_usb-tx");
+	if (IS_ERR(ledtrig_tx))
+		result = PTR_ERR(ledtrig_tx);
+
 	return result;
 }
 
diff -puN include/linux/leds.h~led-simplify-led_trigger_register_simple include/linux/leds.h
--- a/include/linux/leds.h~led-simplify-led_trigger_register_simple
+++ a/include/linux/leds.h
@@ -94,8 +94,7 @@ extern void led_trigger_unregister(struc
 /* Registration functions for simple triggers */
 #define DEFINE_LED_TRIGGER(x)		static struct led_trigger *x;
 #define DEFINE_LED_TRIGGER_GLOBAL(x)	struct led_trigger *x;
-extern void led_trigger_register_simple(const char *name,
-				struct led_trigger **trigger);
+extern struct led_trigger *led_trigger_register_simple(const char *name);
 extern void led_trigger_unregister_simple(struct led_trigger *trigger);
 extern void led_trigger_event(struct led_trigger *trigger,
 				enum led_brightness event);
@@ -105,7 +104,7 @@ extern void led_trigger_event(struct led
 /* Triggers aren't active - null macros */
 #define DEFINE_LED_TRIGGER(x)
 #define DEFINE_LED_TRIGGER_GLOBAL(x)
-#define led_trigger_register_simple(x, y) do {} while(0)
+#define led_trigger_register_simple(x) NULL
 #define led_trigger_unregister_simple(x) do {} while(0)
 #define led_trigger_event(x, y) do {} while(0)
 
_

Patches currently in -mm which might be from felipe.balbi@nokia.com are

linux-next.patch
led-simplify-led_trigger_register_simple.patch

