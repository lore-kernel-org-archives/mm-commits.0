From: akpm@linux-foundation.org
Subject: [to-be-updated] input-misc-add-twl4030-pwrbutton-driver.patch removed from -mm tree
Date: Mon, 02 Mar 2009 12:29:56 -0800
Message-ID: <200903022029.n22KTv7F019355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbZCBUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 15:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: felipe.balbi@nokia.com, a.p.zijlstra@chello.nl, dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     input: misc: add twl4030-pwrbutton driver
has been removed from the -mm tree.  Its filename was
     input-misc-add-twl4030-pwrbutton-driver.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: misc: add twl4030-pwrbutton driver
From: Felipe Balbi <felipe.balbi@nokia.com>

This is part of the twl4030 multifunction device driver.

With this driver we add support for reporting KEY_POWER
events via the input layer.

[akpm@linux-foundation.org: make it compile]
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig             |    4 
 drivers/input/misc/Makefile            |    1 
 drivers/input/misc/twl4030-pwrbutton.c |  147 +++++++++++++++++++++++
 3 files changed, 152 insertions(+)

diff -puN drivers/input/misc/Kconfig~input-misc-add-twl4030-pwrbutton-driver drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~input-misc-add-twl4030-pwrbutton-driver
+++ a/drivers/input/misc/Kconfig
@@ -193,6 +193,10 @@ config INPUT_CM109
 	  To compile this driver as a module, choose M here: the module will be
 	  called cm109.
 
+config INPUT_TWL4030_PWRBUTTON
+	tristate "TWL4030 Power button Driver"
+	depends on TWL4030_CORE
+
 config INPUT_UINPUT
 	tristate "User level driver support"
 	help
diff -puN drivers/input/misc/Makefile~input-misc-add-twl4030-pwrbutton-driver drivers/input/misc/Makefile
--- a/drivers/input/misc/Makefile~input-misc-add-twl4030-pwrbutton-driver
+++ a/drivers/input/misc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_INPUT_YEALINK)		+= yealink.
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
+obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
diff -puN /dev/null drivers/input/misc/twl4030-pwrbutton.c
--- /dev/null
+++ a/drivers/input/misc/twl4030-pwrbutton.c
@@ -0,0 +1,147 @@
+/**
+ * drivers/i2c/chips/twl4030-pwrbutton.c
+ *
+ * Driver for sending triton2 power button event to input-layer
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Written by Peter De Schrijver <peter.de-schrijver@nokia.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
+
+#define PWR_PWRON_IRQ (1 << 0)
+
+#define STS_HW_CONDITIONS 0xf
+
+static struct input_dev *powerbutton_dev;
+static struct device *dbg_dev;
+
+static irqreturn_t powerbutton_irq(int irq, void *dev_id)
+{
+	int err;
+	u8 value;
+
+#ifdef CONFIG_LOCKDEP
+	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
+	 * we don't want and can't tolerate.  Although it might be
+	 * friendlier not to borrow this thread context...
+	 */
+	local_irq_enable();
+#endif
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
+				  STS_HW_CONDITIONS);
+	if (!err)  {
+		input_report_key(powerbutton_dev, KEY_POWER,
+				 value & PWR_PWRON_IRQ);
+	} else {
+		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
+			" PM_MASTER STS_HW_CONDITIONS register\n", err);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
+{
+	int err = 0;
+	int irq = platform_get_irq(pdev, 0);
+
+	dbg_dev = &pdev->dev;
+
+	/* PWRBTN == PWRON */
+	err = request_irq(irq, powerbutton_irq,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"twl4030-pwrbutton", NULL);
+	if (err < 0) {
+		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
+		goto out;
+	}
+
+	powerbutton_dev = input_allocate_device();
+	if (!powerbutton_dev) {
+		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+		err = -ENOMEM;
+		goto free_irq_and_out;
+	}
+
+	powerbutton_dev->evbit[0] = BIT_MASK(EV_KEY);
+	powerbutton_dev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	powerbutton_dev->name = "triton2-pwrbutton";
+
+	err = input_register_device(powerbutton_dev);
+	if (err) {
+		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
+		goto free_input_dev;
+	}
+
+	dev_info(&pdev->dev, "triton2 power button driver initialized\n");
+
+	return 0;
+
+
+free_input_dev:
+	input_free_device(powerbutton_dev);
+free_irq_and_out:
+	free_irq(irq, NULL);
+out:
+	return err;
+}
+
+static int __devexit twl4030_pwrbutton_remove(struct platform_device *pdev)
+{
+	int irq = platform_get_irq(pdev, 0);
+
+	free_irq(irq, NULL);
+	input_unregister_device(powerbutton_dev);
+	input_free_device(powerbutton_dev);
+
+	return 0;
+}
+
+struct platform_driver twl4030_pwrbutton_driver = {
+	.probe		= twl4030_pwrbutton_probe,
+	.remove		= twl4030_pwrbutton_remove,
+	.driver		= {
+		.name	= "twl4030-pwrbutton",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init twl4030_pwrbutton_init(void)
+{
+	return platform_driver_register(&twl4030_pwrbutton_driver);
+}
+module_init(twl4030_pwrbutton_init);
+
+static void __exit twl4030_pwrbutton_exit(void)
+{
+	platform_driver_unregister(&twl4030_pwrbutton_driver);
+}
+module_exit(twl4030_pwrbutton_exit);
+
+MODULE_DESCRIPTION("Triton2 Power Button");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter De Schrijver");
+
_

Patches currently in -mm which might be from felipe.balbi@nokia.com are

origin.patch
linux-next.patch
input-keyboard-introduce-lm8323-driver.patch
input-keyboard-introduce-lm8323-driver-checkpatch-fixes.patch
input-misc-add-twl4030-pwrbutton-driver.patch
mfd-twl4030-add-twl4030-pwrbutton-as-our-child.patch

