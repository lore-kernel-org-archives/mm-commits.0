From: akpm@linux-foundation.org
Subject: [merged] input-change-timer-function-to-workqueue-for-gpio_keys-driver.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:17 -0700
Message-ID: <200906121822.n5CIMHKY031055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755917AbZFLSZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alek.du@intel.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: change timer function to workqueue for gpio_keys driver
has been removed from the -mm tree.  Its filename was
     input-change-timer-function-to-workqueue-for-gpio_keys-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: change timer function to workqueue for gpio_keys driver
From: Alek Du <alek.du@intel.com>

The gpio_get_value function of I2C/SPI GPIO expander may sleep thus this
function call can not be called in a timer function.

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/gpio_keys.c |   32 +++++++++++----------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN drivers/input/keyboard/gpio_keys.c~input-change-timer-function-to-workqueue-for-gpio_keys-driver drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~input-change-timer-function-to-workqueue-for-gpio_keys-driver
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -22,13 +22,17 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/workqueue.h>
 
 #include <asm/gpio.h>
 
 struct gpio_button_data {
 	struct gpio_keys_button *button;
 	struct input_dev *input;
-	struct timer_list timer;
+/* Change timer func to workqueue func due to the fact that gpio_get_value
+ * may sleep for some i2c and spi GPIO expander
+ */
+	struct delayed_work work;
 };
 
 struct gpio_keys_drvdata {
@@ -36,8 +40,10 @@ struct gpio_keys_drvdata {
 	struct gpio_button_data data[0];
 };
 
-static void gpio_keys_report_event(struct gpio_button_data *bdata)
+static void gpio_keys_report_event(struct work_struct *work)
 {
+	struct gpio_button_data *bdata = container_of(work,
+			struct gpio_button_data, work.work);
 	struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
 	unsigned int type = button->type ?: EV_KEY;
@@ -47,13 +53,6 @@ static void gpio_keys_report_event(struc
 	input_sync(input);
 }
 
-static void gpio_check_button(unsigned long _data)
-{
-	struct gpio_button_data *data = (struct gpio_button_data *)_data;
-
-	gpio_keys_report_event(data);
-}
-
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
 	struct gpio_button_data *bdata = dev_id;
@@ -62,10 +61,10 @@ static irqreturn_t gpio_keys_isr(int irq
 	BUG_ON(irq != gpio_to_irq(button->gpio));
 
 	if (button->debounce_interval)
-		mod_timer(&bdata->timer,
-			jiffies + msecs_to_jiffies(button->debounce_interval));
+		schedule_delayed_work(&bdata->work,
+			msecs_to_jiffies(button->debounce_interval));
 	else
-		gpio_keys_report_event(bdata);
+		schedule_work(&bdata->work.work);
 
 	return IRQ_HANDLED;
 }
@@ -112,8 +111,7 @@ static int __devinit gpio_keys_probe(str
 
 		bdata->input = input;
 		bdata->button = button;
-		setup_timer(&bdata->timer,
-			    gpio_check_button, (unsigned long)bdata);
+		INIT_DELAYED_WORK(&bdata->work, gpio_keys_report_event);
 
 		error = gpio_request(button->gpio, button->desc ?: "gpio_keys");
 		if (error < 0) {
@@ -172,8 +170,7 @@ static int __devinit gpio_keys_probe(str
  fail2:
 	while (--i >= 0) {
 		free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
-		if (pdata->buttons[i].debounce_interval)
-			del_timer_sync(&ddata->data[i].timer);
+		cancel_delayed_work_sync(&ddata->data[i].work);
 		gpio_free(pdata->buttons[i].gpio);
 	}
 
@@ -197,8 +194,7 @@ static int __devexit gpio_keys_remove(st
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
 		free_irq(irq, &ddata->data[i]);
-		if (pdata->buttons[i].debounce_interval)
-			del_timer_sync(&ddata->data[i].timer);
+		cancel_delayed_work_sync(&ddata->data[i].work);
 		gpio_free(pdata->buttons[i].gpio);
 	}
 
_

Patches currently in -mm which might be from alek.du@intel.com are

linux-next.patch

