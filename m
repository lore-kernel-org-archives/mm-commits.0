From: akpm@linux-foundation.org
Subject: + input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch added to -mm tree
Date: Mon, 03 Mar 2008 14:30:42 -0800
Message-ID: <200803032230.m23MUgas010098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbYCCWdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 17:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ek9852@gmail.com, anti.sullin@artecdesign.ee, david-b@pacbell.net, dtor@mail.ru, hvr@gnu.org, jirislaby@gmail.com


The patch titled
     input: add debouncing for generic gpio input device gpio_key.c
has been added to the -mm tree.  Its filename is
     input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch

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

 drivers/input/keyboard/gpio_keys.c |  106 +++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 13 deletions(-)

diff -puN drivers/input/keyboard/gpio_keys.c~input-add-debouncing-for-generic-gpio-input-device-gpio_keyc drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~input-add-debouncing-for-generic-gpio-input-device-gpio_keyc
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -26,26 +26,36 @@
 
 #include <asm/gpio.h>
 
+static void do_gpio_keys_tasklet(unsigned long);
+static void do_gpio_keys_timer(unsigned long);
+
+static struct timer_list gpio_keys_timer;
+DECLARE_TASKLET_DISABLED(gpio_keys_tasklet, do_gpio_keys_tasklet, 0);
+static spinlock_t suspend_lock;
+static int suspended;
+
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
-	int i;
 	struct platform_device *pdev = dev_id;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
-	struct input_dev *input = platform_get_drvdata(pdev);
-
-	for (i = 0; i < pdata->nbuttons; i++) {
-		struct gpio_keys_button *button = &pdata->buttons[i];
-		int gpio = button->gpio;
+	int i;
+	unsigned long flags;
 
-		if (irq == gpio_to_irq(gpio)) {
-			unsigned int type = button->type ?: EV_KEY;
-			int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;
+	spin_lock_irqsave(&suspend_lock, flags);
+	if (suspended) {
+		spin_unlock_irqrestore(&suspend_lock, flags);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&suspend_lock, flags);
 
-			input_event(input, type, button->code, !!state);
-			input_sync(input);
-		}
+	/* disable keyboard interrupt and schedule for handling */
+	for (i = 0; i < pdata->nbuttons; i++) {
+		int irq = gpio_to_irq(pdata->buttons[i].gpio);
+		disable_irq(irq);
 	}
 
+	tasklet_schedule(&gpio_keys_tasklet);
+
 	return IRQ_HANDLED;
 }
 
@@ -63,6 +73,11 @@ static int __devinit gpio_keys_probe(str
 	platform_set_drvdata(pdev, input);
 
 	input->evbit[0] = BIT_MASK(EV_KEY);
+	setup_timer(&gpio_keys_timer, do_gpio_keys_timer, (unsigned long) pdev);
+	tasklet_enable(&gpio_keys_tasklet);
+	gpio_keys_tasklet.data = (unsigned long) pdev;
+	spin_lock_init(&suspend_lock);
+	suspended = 0;
 
 	input->name = pdev->name;
 	input->phys = "gpio-keys/input0";
@@ -156,9 +171,14 @@ static int __devexit gpio_keys_remove(st
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
 		free_irq(irq, pdev);
-		gpio_free(pdata->buttons[i].gpio);
 	}
 
+	del_timer_sync(&gpio_keys_timer);
+	tasklet_kill(&gpio_keys_tasklet);
+
+	for (i = 0; i < pdata->nbuttons; i++)
+		gpio_free(pdata->buttons[i].gpio);
+
 	input_unregister_device(input);
 
 	return 0;
@@ -168,9 +188,29 @@ static int __devexit gpio_keys_remove(st
 #ifdef CONFIG_PM
 static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	unsigned long flags;
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	int i;
 
+	spin_lock_irqsave(&suspend_lock, flags);
+
+	/*
+	 * Re-enable the interrupt in case it has been masked by the
+	 * handler and a key is still pressed.  We need the interrupt
+	 * to wake us up from suspended.
+	 */
+
+	suspended = 1;
+
+	spin_unlock_irqrestore(&suspend_lock, flags);
+	del_timer_sync(&gpio_keys_timer);
+	tasklet_kill(&gpio_keys_tasklet);
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		int irq = gpio_to_irq(pdata->buttons[i].gpio);
+		enable_irq(irq);
+	}
+
 	if (device_may_wakeup(&pdev->dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
@@ -189,6 +229,7 @@ static int gpio_keys_resume(struct platf
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	int i;
 
+	suspended = 0;
 	if (device_may_wakeup(&pdev->dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
@@ -206,6 +247,45 @@ static int gpio_keys_resume(struct platf
 #define gpio_keys_resume	NULL
 #endif
 
+static void do_gpio_keys_tasklet(unsigned long data)
+{
+	int pressed;
+	int i;
+	struct platform_device *pdev = (struct platform_device*)data;
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input = platform_get_drvdata(pdev);
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
+	if(pressed) {
+                int delay = HZ / 20;
+		/* some key is pressed - keep irq disabled and use timer
+		 * to poll */
+		mod_timer(&gpio_keys_timer, jiffies + delay);
+	} else {
+		for (i = 0; i < pdata->nbuttons; i++) {
+			int irq = gpio_to_irq(pdata->buttons[i].gpio);
+			enable_irq(irq);
+		}
+	}
+}
+
+static void do_gpio_keys_timer(unsigned long data)
+{
+	tasklet_schedule(&gpio_keys_tasklet);
+}
+
 struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
 	.remove		= __devexit_p(gpio_keys_remove),
_

Patches currently in -mm which might be from ek9852@gmail.com are

input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch

