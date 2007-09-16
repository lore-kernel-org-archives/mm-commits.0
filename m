From: akpm@linux-foundation.org
Subject: - add-suspend-and-resume-to-gpio_keys-driver.patch removed from -mm tree
Date: Sat, 15 Sep 2007 22:03:12 -0700
Message-ID: <200709160503.l8G53CkT001061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbXIPFDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anti.sullin@artecdesign.ee, david-b@pacbell.net, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Add suspend and resume to gpio_keys driver
has been removed from the -mm tree.  Its filename was
     add-suspend-and-resume-to-gpio_keys-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add suspend and resume to gpio_keys driver
From: Anti Sullin <anti.sullin@artecdesign.ee>

This patch adds suspend/resume support and enables wakeup from gpio_keys
buttons. Buttons, that generate wakeup events, can be specified in
platform data.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/gpio_keys.c |   44 +++++++++++++++++++++++++++
 include/linux/gpio_keys.h          |    1 
 2 files changed, 45 insertions(+)

diff -puN drivers/input/keyboard/gpio_keys.c~add-suspend-and-resume-to-gpio_keys-driver drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~add-suspend-and-resume-to-gpio_keys-driver
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -54,6 +54,7 @@ static int __devinit gpio_keys_probe(str
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct input_dev *input;
 	int i, error;
+	int wakeup = 0;
 
 	input = input_allocate_device();
 	if (!input)
@@ -87,6 +88,9 @@ static int __devinit gpio_keys_probe(str
 			goto fail;
 		}
 
+	if (button->wakeup)
+		wakeup = 1;
+
 		input_set_capability(input, type, button->code);
 	}
 
@@ -96,6 +100,8 @@ static int __devinit gpio_keys_probe(str
 		goto fail;
 	}
 
+	device_init_wakeup(&pdev->dev, wakeup);
+
 	return 0;
 
  fail:
@@ -118,14 +124,52 @@ static int __devexit gpio_keys_remove(st
 		free_irq(irq, pdev);
 	}
 
+	device_init_wakeup(&pdev->dev, 0);
 	input_unregister_device(input);
 
 	return 0;
 }
 
+
+#ifdef CONFIG_PM
+static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	int i;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->nbuttons; i++) {
+			int irq = gpio_to_irq(pdata->buttons[i].gpio);
+			if (pdata->buttons[i].wakeup)
+				enable_irq_wake(irq);
+		}
+	}
+
+    return 0;
+}
+
+static int gpio_keys_resume(struct platform_device *pdev)
+{
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	int i;
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		int irq = gpio_to_irq(pdata->buttons[i].gpio);
+		disable_irq_wake(irq);
+	}
+
+    return 0;
+}
+#else
+#define gpio_keys_suspend    NULL
+#define gpio_keys_resume    NULL
+#endif
+
 struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
 	.remove		= __devexit_p(gpio_keys_remove),
+	.suspend    = gpio_keys_suspend,
+	.resume        = gpio_keys_resume,
 	.driver		= {
 		.name	= "gpio-keys",
 	}
diff -puN include/linux/gpio_keys.h~add-suspend-and-resume-to-gpio_keys-driver include/linux/gpio_keys.h
--- a/include/linux/gpio_keys.h~add-suspend-and-resume-to-gpio_keys-driver
+++ a/include/linux/gpio_keys.h
@@ -8,6 +8,7 @@ struct gpio_keys_button {
 	int active_low;
 	char *desc;
 	int type;		/* input event type (EV_KEY, EV_SW) */
+	int wakeup;        /* configure the button as wake-up source from suspend */
 };
 
 struct gpio_keys_platform_data {
_

Patches currently in -mm which might be from anti.sullin@artecdesign.ee are

bug-in-at91-mci-suspend-routines.patch
add-suspend-and-resume-to-gpio_keys-driver.patch
