From: akpm@linux-foundation.org
Subject: - input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch removed from -mm tree
Date: Fri, 28 Mar 2008 14:29:47 -0700
Message-ID: <200803282129.m2SLTl4e011212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbYC1VaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 17:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ek9852@gmail.com, anti.sullin@artecdesign.ee, david-b@pacbell.net, dtor@mail.ru, hvr@gnu.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     input: add debouncing for generic gpio input device gpio_key.c (update)
has been removed from the -mm tree.  Its filename was
     input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch

This patch was dropped because it was folded into input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add debouncing for generic gpio input device gpio_key.c (update)
From: Keith Mok <ek9852@gmail.com>

I put the timer and the flag into a struct and save it using
input_set_drvdata.  This should make gpio-keys non single-instance-only
driver.

Signed-off-by: Keith Mok <ek9852@gmail.com>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Anti Sullin <anti.sullin@artecdesign.ee>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/gpio_keys.c |   98 ++++++++++++++-------------
 1 file changed, 53 insertions(+), 45 deletions(-)

diff -puN drivers/input/keyboard/gpio_keys.c~input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -26,35 +26,37 @@
 
 #include <asm/gpio.h>
 
-static void do_gpio_keys_tasklet(unsigned long);
 static void do_gpio_keys_timer(unsigned long);
 
-static struct timer_list gpio_keys_timer;
-DECLARE_TASKLET_DISABLED(gpio_keys_tasklet, do_gpio_keys_tasklet, 0);
-static spinlock_t suspend_lock;
-static int suspended;
+struct gpio_key_data {
+	struct timer_list gpio_keys_timer;
+	spinlock_t suspend_lock;
+	int suspended;
+};
 
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 	unsigned long flags;
 
-	spin_lock_irqsave(&suspend_lock, flags);
-	if (suspended) {
-		spin_unlock_irqrestore(&suspend_lock, flags);
+	spin_lock_irqsave(&(pgpiodata->suspend_lock), flags);
+	if (pgpiodata->suspended) {
+		spin_unlock_irqrestore(&(pgpiodata->suspend_lock), flags);
 		return IRQ_HANDLED;
 	}
-	spin_unlock_irqrestore(&suspend_lock, flags);
+	spin_unlock_irqrestore(&(pgpiodata->suspend_lock), flags);
 
 	/* disable keyboard interrupt and schedule for handling */
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
-		disable_irq(irq);
+		disable_irq_nosync(irq);
 	}
 
-	tasklet_schedule(&gpio_keys_tasklet);
+	mod_timer(&(pgpiodata->gpio_keys_timer), jiffies + HZ / 100);
 
 	return IRQ_HANDLED;
 }
@@ -62,6 +64,7 @@ static irqreturn_t gpio_keys_isr(int irq
 static int __devinit gpio_keys_probe(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_key_data *pgpiodata;
 	struct input_dev *input;
 	int i, error;
 	int wakeup = 0;
@@ -70,14 +73,20 @@ static int __devinit gpio_keys_probe(str
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
-	setup_timer(&gpio_keys_timer, do_gpio_keys_timer, (unsigned long) pdev);
-	tasklet_enable(&gpio_keys_tasklet);
-	gpio_keys_tasklet.data = (unsigned long) pdev;
-	spin_lock_init(&suspend_lock);
-	suspended = 0;
 
 	input->name = pdev->name;
 	input->phys = "gpio-keys/input0";
@@ -88,6 +97,8 @@ static int __devinit gpio_keys_probe(str
 	input->id.product = 0x0001;
 	input->id.version = 0x0100;
 
+	input_set_drvdata(input, pgpiodata);
+
 	for (i = 0; i < pdata->nbuttons; i++) {
 		struct gpio_keys_button *button = &pdata->buttons[i];
 		int irq;
@@ -97,7 +108,7 @@ static int __devinit gpio_keys_probe(str
 		if (error < 0) {
 			pr_err("gpio-keys: failed to request GPIO %d,"
 				" error %d\n", button->gpio, error);
-			goto fail;
+			goto fail1;
 		}
 
 		error = gpio_direction_input(button->gpio);
@@ -106,7 +117,7 @@ static int __devinit gpio_keys_probe(str
 				" direction for GPIO %d, error %d\n",
 				button->gpio, error);
 			gpio_free(button->gpio);
-			goto fail;
+			goto fail1;
 		}
 
 		irq = gpio_to_irq(button->gpio);
@@ -116,7 +127,7 @@ static int __devinit gpio_keys_probe(str
 				" for GPIO %d, error %d\n",
 				button->gpio, error);
 			gpio_free(button->gpio);
-			goto fail;
+			goto fail1;
 		}
 
 		error = request_irq(irq, gpio_keys_isr,
@@ -128,7 +139,7 @@ static int __devinit gpio_keys_probe(str
 			pr_err("gpio-keys: Unable to claim irq %d; error %d\n",
 				irq, error);
 			gpio_free(button->gpio);
-			goto fail;
+			goto fail1;
 		}
 
 		if (button->wakeup)
@@ -141,20 +152,21 @@ static int __devinit gpio_keys_probe(str
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
@@ -164,6 +176,7 @@ static int __devexit gpio_keys_remove(st
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 
 	device_init_wakeup(&pdev->dev, 0);
@@ -173,12 +186,13 @@ static int __devexit gpio_keys_remove(st
 		free_irq(irq, pdev);
 	}
 
-	del_timer_sync(&gpio_keys_timer);
-	tasklet_kill(&gpio_keys_tasklet);
+	del_timer_sync(&(pgpiodata->gpio_keys_timer));
 
 	for (i = 0; i < pdata->nbuttons; i++)
 		gpio_free(pdata->buttons[i].gpio);
 
+	kfree(pgpiodata);
+
 	input_unregister_device(input);
 
 	return 0;
@@ -190,9 +204,11 @@ static int gpio_keys_suspend(struct plat
 {
 	unsigned long flags;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 
-	spin_lock_irqsave(&suspend_lock, flags);
+	spin_lock_irqsave(&(pgpiodata->suspend_lock), flags);
 
 	/*
 	 * Re-enable the interrupt in case it has been masked by the
@@ -200,11 +216,10 @@ static int gpio_keys_suspend(struct plat
 	 * to wake us up from suspended.
 	 */
 
-	suspended = 1;
+	pgpiodata->suspended = 1;
 
-	spin_unlock_irqrestore(&suspend_lock, flags);
-	del_timer_sync(&gpio_keys_timer);
-	tasklet_kill(&gpio_keys_tasklet);
+	spin_unlock_irqrestore(&(pgpiodata->suspend_lock), flags);
+	del_timer_sync(&(pgpiodata->gpio_keys_timer));
 
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
@@ -227,9 +242,11 @@ static int gpio_keys_suspend(struct plat
 static int gpio_keys_resume(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 	int i;
 
-	suspended = 0;
+	pgpiodata->suspended = 0;
 	if (device_may_wakeup(&pdev->dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
@@ -247,13 +264,14 @@ static int gpio_keys_resume(struct platf
 #define gpio_keys_resume	NULL
 #endif
 
-static void do_gpio_keys_tasklet(unsigned long data)
+static void do_gpio_keys_timer(unsigned long data)
 {
 	int pressed;
 	int i;
-	struct platform_device *pdev = (struct platform_device*)data;
+	struct platform_device *pdev = (struct platform_device *)data;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct input_dev *input = platform_get_drvdata(pdev);
+	struct gpio_key_data *pgpiodata = input_get_drvdata(input);
 
 	/* check for any changes */
 	pressed = 0;
@@ -268,24 +286,14 @@ static void do_gpio_keys_tasklet(unsigne
 		pressed |= !!state;
 		input_sync(input);
 	}
-	if(pressed) {
-                int delay = HZ / 20;
+	if (pressed) {
+		int delay = HZ / 20;
 		/* some key is pressed - keep irq disabled and use timer
 		 * to poll */
-		mod_timer(&gpio_keys_timer, jiffies + delay);
-	} else {
-		for (i = 0; i < pdata->nbuttons; i++) {
-			int irq = gpio_to_irq(pdata->buttons[i].gpio);
-			enable_irq(irq);
-		}
+		mod_timer(&(pgpiodata->gpio_keys_timer), jiffies + delay);
 	}
 }
 
-static void do_gpio_keys_timer(unsigned long data)
-{
-	tasklet_schedule(&gpio_keys_tasklet);
-}
