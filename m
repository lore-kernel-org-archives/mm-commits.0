From: akpm@linux-foundation.org
Subject: + gpio_keys-driver-shouldnt-be-arm-specific.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:48:08 -0800
Message-ID: <200703020148.l221m8in029131@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34744 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXCBBsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, dtor@mail.ru, hskinnemoen@atmel.com, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, rpurdie@rpsys.net


The patch titled
     gpio_keys driver shouldn't be ARM-specific
has been added to the -mm tree.  Its filename is
     gpio_keys-driver-shouldnt-be-arm-specific.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gpio_keys driver shouldn't be ARM-specific
From: David Brownell <david-b@pacbell.net>

The gpio_keys driver is wrongly ARM-specific; it can't build on
other platforms with GPIO suport.  This fixes that problem.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/gpio_keys.c   |    4 +---
 include/asm-arm/hardware/gpio_keys.h |   17 -----------------
 include/linux/gpio_keys.h            |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 20 deletions(-)

diff -puN drivers/input/keyboard/gpio_keys.c~gpio_keys-driver-shouldnt-be-arm-specific drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~gpio_keys-driver-shouldnt-be-arm-specific
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -23,11 +23,9 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/irq.h>
+#include <linux/gpio_keys.h>
 
 #include <asm/gpio.h>
-#include <asm/arch/hardware.h>
-
-#include <asm/hardware/gpio_keys.h>
 
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
diff -puN include/asm-arm/hardware/gpio_keys.h~gpio_keys-driver-shouldnt-be-arm-specific /dev/null
--- a/include/asm-arm/hardware/gpio_keys.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _GPIO_KEYS_H
-#define _GPIO_KEYS_H
-
-struct gpio_keys_button {
-	/* Configuration parameters */
-	int keycode;
-	int gpio;
-	int active_low;
-	char *desc;
-};
-
-struct gpio_keys_platform_data {
-	struct gpio_keys_button *buttons;
-	int nbuttons;
-};
-
-#endif
diff -puN /dev/null include/linux/gpio_keys.h
--- /dev/null
+++ a/include/linux/gpio_keys.h
@@ -0,0 +1,17 @@
+#ifndef _GPIO_KEYS_H
+#define _GPIO_KEYS_H
+
+struct gpio_keys_button {
+	/* Configuration parameters */
+	int keycode;
+	int gpio;
+	int active_low;
+	char *desc;
+};
+
+struct gpio_keys_platform_data {
+	struct gpio_keys_button *buttons;
+	int nbuttons;
+};
+
+#endif
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_cmos-oops-fix.patch
parport-is-an-orphan.patch
add-config_generic_gpio.patch
gpio_keys-driver-shouldnt-be-arm-specific.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
