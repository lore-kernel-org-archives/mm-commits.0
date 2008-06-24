From: akpm@linux-foundation.org
Subject: + sm501-gpio-i2c-support.patch added to -mm tree
Date: Mon, 23 Jun 2008 21:05:06 -0700
Message-ID: <200806240405.m5O456nj031886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYFXEFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, apatard@mandriva.com, david-b@pacbell.net


The patch titled
     sm501: gpio I2C support
has been added to the -mm tree.  Its filename is
     sm501-gpio-i2c-support.patch

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
Subject: sm501: gpio I2C support
From: Ben Dooks <ben-linux@fluff.org>

Add support for adding the GPIO based I2C resources.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <apatard@mandriva.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c   |   76 +++++++++++++++++++++++++++++++++++++++-
 include/linux/sm501.h |   10 ++++-
 2 files changed, 84 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-gpio-i2c-support drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-gpio-i2c-support
+++ a/drivers/mfd/sm501.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
+#include <linux/i2c-gpio.h>
 
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
@@ -1086,6 +1087,11 @@ static void sm501_gpio_remove(struct sm5
 		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
 }
 
+static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+{
+	struct sm501_gpio *gpio = &sm->gpio;
+	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+}
 #else
 static int sm501_register_gpio(struct sm501_devdata *sm)
 {
@@ -1095,8 +1101,66 @@ static int sm501_register_gpio(struct sm
 static void sm501_gpio_remove(struct sm501_devdata *sm)
 {
 }
+
+static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+{
+	return -1;
+}
 #endif
 
+static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
+					    struct sm501_platdata_gpio_i2c *iic)
+{
+	struct i2c_gpio_platform_data *icd;
+	struct platform_device *pdev;
+
+	pdev = sm501_create_subdev(sm, "i2c-gpio", 0,
+				   sizeof(struct i2c_gpio_platform_data));
+	if (!pdev)
+		return -ENOMEM;
+
+	icd = pdev->dev.platform_data;
+
+	/* We keep the pin_sda and pin_scl fields relative in case the
+	 * same platform data is passed to >1 SM501.
+	 */
+
+	icd->sda_pin = sm501_gpio_pin2nr(sm, iic->pin_sda);
+	icd->scl_pin = sm501_gpio_pin2nr(sm, iic->pin_scl);
+	icd->timeout = iic->timeout;
+	icd->udelay = iic->udelay;
+
+	/* note, we can't use either of the pin numbers, as the i2c-gpio
+	 * driver uses the platform.id field to generate the bus number
+	 * to register with the i2c core; The i2c core doesn't have enough
+	 * entries to deal with anything we currently use.
+	*/
+
+	pdev->id = iic->bus_num;
+
+	dev_info(sm->dev, "registering i2c-%d: sda=%d (%d), scl=%d (%d)\n",
+		 iic->bus_num,
+		 icd->sda_pin, iic->pin_sda, icd->scl_pin, iic->pin_scl);
+
+	return sm501_register_device(sm, pdev);
+}
+
+static int sm501_register_gpio_i2c(struct sm501_devdata *sm,
+				   struct sm501_platdata *pdata)
+{
+	struct sm501_platdata_gpio_i2c *iic = pdata->gpio_i2c;
+	int index;
+	int ret;
+
+	for (index = 0; index < pdata->gpio_i2c_nr; index++, iic++) {
+		ret = sm501_register_gpio_i2c_instance(sm, iic);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* sm501_dbg_regs
  *
  * Debug attribute to attach to parent device to show core registers
@@ -1204,6 +1268,7 @@ static unsigned int sm501_mem_local[] = 
 static int sm501_init_dev(struct sm501_devdata *sm)
 {
 	struct sm501_initdata *idata;
+	struct sm501_platdata *pdata;
 	resource_size_t mem_avail;
 	unsigned long dramctrl;
 	unsigned long devid;
@@ -1242,7 +1307,9 @@ static int sm501_init_dev(struct sm501_d
 
 	/* check to see if we have some device initialisation */
 
-	idata = sm->platdata ? sm->platdata->init : NULL;
+	pdata = sm->platdata;
+	idata = pdata ? pdata->init : NULL;
+
 	if (idata) {
 		sm501_init_regs(sm, idata);
 
@@ -1254,6 +1321,13 @@ static int sm501_init_dev(struct sm501_d
 			sm501_register_gpio(sm);
 	}
 
+	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
+		if (!sm->gpio.registered)
+			dev_err(sm->dev, "no gpio registered for i2c gpio.\n");
+		else
+			sm501_register_gpio_i2c(sm, pdata);
+	}
+
 	ret = sm501_check_clocks(sm);
 	if (ret) {
 		dev_err(sm->dev, "M1X and M clocks sourced from different "
diff -puN include/linux/sm501.h~sm501-gpio-i2c-support include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-gpio-i2c-support
+++ a/include/linux/sm501.h
@@ -84,11 +84,19 @@ struct sm501_platdata_fb {
 	struct sm501_platdata_fbsub	*fb_pnl;
 };
 
-/* gpio i2c */
+/* gpio i2c
+ *
+ * Note, we have to pass in the bus number, as the number used will be
+ * passed to the i2c-gpio driver's platform_device.id, subsequently used
+ * to register the i2c bus.
+*/
 
 struct sm501_platdata_gpio_i2c {
+	unsigned int		bus_num;
 	unsigned int		pin_sda;
 	unsigned int		pin_scl;
+	int			udelay;
+	int			timeout;
 };
 
 /* sm501_initdata
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch

