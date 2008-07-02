From: akpm@linux-foundation.org
Subject: + mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:55:37 -0700
Message-ID: <200807020855.m628tbmE008308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbYGBI5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, lizf@cn.fujitsu.com


The patch titled
     mfd: sm501 build fixes when CONFIG_MFD_SM501_GPIO unset
has been added to the -mm tree.  Its filename is
     mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: sm501 build fixes when CONFIG_MFD_SM501_GPIO unset
From: Ben Dooks <ben-linux@fluff.org>

Fix the build problems if CONFIG_MFD_SM501_GPIO is not set, which is
generally when there is no gpiolib support available as currently happens
on x86 when building PCI SM501.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN drivers/mfd/sm501.c~mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset
+++ a/drivers/mfd/sm501.c
@@ -19,7 +19,6 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <linux/gpio.h>
 #include <linux/i2c-gpio.h>
 
 #include <linux/sm501.h>
@@ -35,6 +34,9 @@ struct sm501_device {
 
 struct sm501_gpio;
 
+#ifdef CONFIG_MFD_SM501_GPIO
+#include <linux/gpio.h>
+
 struct sm501_gpio_chip {
 	struct gpio_chip	gpio;
 	struct sm501_gpio	*ourgpio;	/* to get back to parent. */
@@ -50,6 +52,11 @@ struct sm501_gpio {
 	void __iomem		*regs;
 	struct resource		*regs_res;
 };
+#else
+struct sm501_gpio {
+	/* no gpio support, empty definition for sm501_devdata. */
+};
+#endif
 
 struct sm501_devdata {
 	spinlock_t			 reg_lock;
@@ -1082,6 +1089,9 @@ static void sm501_gpio_remove(struct sm5
 	struct sm501_gpio *gpio = &sm->gpio;
 	int ret;
 
+	if (!sm->gpio.registered)
+		return;
+
 	ret = gpiochip_remove(&gpio->low.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
@@ -1100,6 +1110,11 @@ static inline int sm501_gpio_pin2nr(stru
 	struct sm501_gpio *gpio = &sm->gpio;
 	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
 }
+
+static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)
+{
+	return sm->gpio.registered;
+}
 #else
 static inline int sm501_register_gpio(struct sm501_devdata *sm)
 {
@@ -1114,6 +1129,11 @@ static inline int sm501_gpio_pin2nr(stru
 {
 	return -1;
 }
+
+static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)
+{
+	return 0;
+}
 #endif
 
 static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
@@ -1330,8 +1350,8 @@ static int sm501_init_dev(struct sm501_d
 	}
 
 	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
-		if (!sm->gpio.registered)
-			dev_err(sm->dev, "no gpio registered for i2c gpio.\n");
+		if (!sm501_gpio_isregistered(sm))
+			dev_err(sm->dev, "no gpio available for i2c gpio.\n");
 		else
 			sm501_register_gpio_i2c(sm, pdata);
 	}
@@ -1643,8 +1663,7 @@ static void sm501_dev_remove(struct sm50
 
 	device_remove_file(sm->dev, &dev_attr_dbg_regs);
 
-	if (sm->gpio.registered)
-		sm501_gpio_remove(sm);
+	sm501_gpio_remove(sm);
 }
 
 static void sm501_pci_remove(struct pci_dev *dev)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

mfd-maintainer.patch
linux-next.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

