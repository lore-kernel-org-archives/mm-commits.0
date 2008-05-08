From: akpm@linux-foundation.org
Subject: - input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch removed from -mm tree
Date: Thu, 08 May 2008 12:05:41 -0700
Message-ID: <200805081905.m48J5f9n000854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758918AbYEHTGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ek9852@gmail.com, anti.sullin@artecdesign.ee, david-b@pacbell.net, dtor@mail.ru, hvr@gnu.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     input: add debouncing for generic gpio input device gpio_key.c
has been removed from the -mm tree.  Its filename was
     input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch

This patch was dropped because a similar patch got merged into git-input

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add debouncing for generic gpio input device gpio_key.c
From: Keith Mok <ek9852@gmail.com>

Add debouncing support for the generic gpio input device, since debouncing is
most likely to happen.

Signed-off-by: Keith Mok <ek9852@gmail.com>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Anti Sullin <anti.sullin@artecdesign.ee>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/gpio_keys.c |  127 ++++++++++++++++++++++-----
 1 file changed, 107 insertions(+), 20 deletions(-)

diff -puN drivers/input/keyboard/gpio_keys.c~input-add-debouncing-for-generic-gpio-input-device-gpio_keyc drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~input-add-debouncing-for-generic-gpio-input-device-gpio_keyc
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -26,33 +26,45 @@
 
 #include <asm/gpio.h>
 
+static void do_gpio_keys_timer(unsigned long);
+
+struct gpio_key_data {
+	struct timer_list gpio_keys_timer;
+	spinlock_t suspend_lock;
+	int suspended;
+};
+
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
-	int i;
 	struct platform_device *pdev = dev_id;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
+	int i;
+	unsigned long flags;
 
-	for (i = 0; i < pdata->nbuttons; i++) {
-		struct gpio_keys_button *button = &pdata->buttons[i];
-		int gpio = button->gpio;
-
-		if (irq == gpio_to_irq(gpio)) {
-			unsigned int type = button->type ?: EV_KEY;
-			int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;
+	spin_lock_irqsave(&(pgpiodata->suspend_lock), flags);
+	if (pgpiodata->suspended) {
+		spin_unlock_irqrestore(&(pgpiodata->suspend_lock), flags);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&(pgpiodata->suspend_lock), flags);
 
-			input_event(input, type, button->code, !!state);
-			input_sync(input);
-			return IRQ_HANDLED;
-		}
+	/* disable keyboard interrupt and schedule for handling */
+	for (i = 0; i < pdata->nbuttons; i++) {
+		int irq = gpio_to_irq(pdata->buttons[i].gpio);
+		disable_irq_nosync(irq);
 	}
 
-	return IRQ_NONE;
+	mod_timer(&(pgpiodata->gpio_keys_timer), jiffies + HZ / 100);
+
+	return IRQ_HANDLED;
 }
 
 static int __devinit gpio_keys_probe(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_key_data *pgpiodata;
 	struct input_dev *input;
 	int i, error;
 	int wakeup = 0;
@@ -61,6 +73,17 @@ static int __devinit gpio_keys_probe(str
 	if (!input)
 		return -ENOMEM;
 
+	pgpiodata = kmalloc(sizeof(struct gpio_key_data), GFP_KERNEL);
+	if (!pgpiodata) {
+		error = -ENOMEM;
+		goto fail2;
+	}
+
+	setup_timer(&(pgpiodata->gpio_keys_timer), do_gpio_keys_timer,
+		(unsigned long) pdev);
+	spin_lock_init(&(pgpiodata->suspend_lock));
+	pgpiodata->suspended = 0;
+
 	platform_set_drvdata(pdev, input);
 
 	input->evbit[0] = BIT_MASK(EV_KEY);
@@ -74,6 +97,8 @@ static int __devinit gpio_keys_probe(str
 	input->id.product = 0x0001;
 	input->id.version = 0x0100;
 
+	input_set_drvdata(input, pgpiodata);
+
 	for (i = 0; i < pdata->nbuttons; i++) {
 		struct gpio_keys_button *button = &pdata->buttons[i];
 		int irq;
@@ -83,7 +108,7 @@ static int __devinit gpio_keys_probe(str
 		if (error < 0) {
 			pr_err("gpio-keys: failed to request GPIO %d,"
 				" error %d\n", button->gpio, error);
-			goto fail;
+			goto fail1;
 		}
 
 		error = gpio_direction_input(button->gpio);
@@ -92,7 +117,7 @@ static int __devinit gpio_keys_probe(str
 				" direction for GPIO %d, error %d\n",
 				button->gpio, error);
 			gpio_free(button->gpio);
-			goto fail;
+			goto fail1;
 		}
 
 		irq = gpio_to_irq(button->gpio);
@@ -102,7 +127,7 @@ static int __devinit gpio_keys_probe(str
 				" for GPIO %d, error %d\n",
 				button->gpio, error);
 			gpio_free(button->gpio);
-			goto fail;
+			goto fail1;
 		}
 
 		error = request_irq(irq, gpio_keys_isr,
@@ -114,7 +139,7 @@ static int __devinit gpio_keys_probe(str
 			pr_err("gpio-keys: Unable to claim irq %d; error %d\n",
 				irq, error);
 			gpio_free(button->gpio);
-			goto fail;
+			goto fail1;
 		}
 
 		if (button->wakeup)
@@ -127,20 +152,21 @@ static int __devinit gpio_keys_probe(str
 	if (error) {
 		pr_err("gpio-keys: Unable to register input device, "
 			"error: %d\n", error);
-		goto fail;
+		goto fail1;
 	}
 
 	device_init_wakeup(&pdev->dev, wakeup);
 
 	return 0;
 
- fail:
+ fail1:
 	while (--i >= 0) {
 		free_irq(gpio_to_irq(pdata->buttons[i].gpio), pdev);
 		gpio_free(pdata->buttons[i].gpio);
 	}
 
 	platform_set_drvdata(pdev, NULL);
+ fail2:
 	input_free_device(input);
 
 	return error;
@@ -150,6 +176,7 @@ static int __devexit gpio_keys_remove(st
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 
 	device_init_wakeup(&pdev->dev, 0);
@@ -157,9 +184,15 @@ static int __devexit gpio_keys_remove(st
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
 		free_irq(irq, pdev);
-		gpio_free(pdata->buttons[i].gpio);
 	}
 
+	del_timer_sync(&(pgpiodata->gpio_keys_timer));
+
+	for (i = 0; i < pdata->nbuttons; i++)
+		gpio_free(pdata->buttons[i].gpio);
+
+	kfree(pgpiodata);
+
 	input_unregister_device(input);
 
 	return 0;
@@ -169,9 +202,30 @@ static int __devexit gpio_keys_remove(st
 #ifdef CONFIG_PM
 static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	unsigned long flags;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 
+	spin_lock_irqsave(&(pgpiodata->suspend_lock), flags);
+
+	/*
+	 * Re-enable the interrupt in case it has been masked by the
+	 * handler and a key is still pressed.  We need the interrupt
+	 * to wake us up from suspended.
+	 */
+
+	pgpiodata->suspended = 1;
+
+	spin_unlock_irqrestore(&(pgpiodata->suspend_lock), flags);
+	del_timer_sync(&(pgpiodata->gpio_keys_timer));
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		int irq = gpio_to_irq(pdata->buttons[i].gpio);
+		enable_irq(irq);
+	}
+
 	if (device_may_wakeup(&pdev->dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
@@ -188,8 +242,11 @@ static int gpio_keys_suspend(struct plat
 static int gpio_keys_resume(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 
+	pgpiodata->suspended = 0;
 	if (device_may_wakeup(&pdev->dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
@@ -207,6 +264,36 @@ static int gpio_keys_resume(struct platf
 #define gpio_keys_resume	NULL
 #endif
 
+static void do_gpio_keys_timer(unsigned long data)
+{
+	int pressed;
+	int i;
+	struct platform_device *pdev = (struct platform_device *)data;
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
+
+	/* check for any changes */
+	pressed = 0;
+	for (i = 0; i < pdata->nbuttons; i++) {
+		struct gpio_keys_button *button = &pdata->buttons[i];
+		int gpio = button->gpio;
+
+		unsigned int type = button->type ?: EV_KEY;
+		int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;
+
+		input_event(input, type, button->code, !!state);
+		pressed |= !!state;
+		input_sync(input);
+	}
+	if (pressed) {
+		int delay = HZ / 20;
+		/* some key is pressed - keep irq disabled and use timer
+		 * to poll */
+		mod_timer(&(pgpiodata->gpio_keys_timer), jiffies + delay);
+	}
+}
+
 struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
 	.remove		= __devexit_p(gpio_keys_remove),
_

Patches currently in -mm which might be from ek9852@gmail.com are

input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch

