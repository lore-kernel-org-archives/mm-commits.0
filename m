From: akpm@linux-foundation.org
Subject: + w1-gpio-add-external-pull-up-enable-callback.patch added to -mm tree
Date: Tue, 12 May 2009 14:47:29 -0700
Message-ID: <200905122147.n4CLlTRM004400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbZELVuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, johnpol@2ka.mipt.ru, syrjala@sci.fi


The patch titled
     w1-gpio: add external pull-up enable callback
has been added to the -mm tree.  Its filename is
     w1-gpio-add-external-pull-up-enable-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-gpio: add external pull-up enable callback
From: Daniel Mack <daniel@caiaq.de>

On embedded devices, sleep mode conditions can be tricky to handle,
Especially when processors tend to pull-down the w1 bus during sleep.  Bus
slaves (such as the ds2760) may interpret this as a reason for power-down
conditions and entirely switch off the device.

This patch adds a callback function pointer to let users switch on and off
the external pull-up resistor.  This lets the outside world know whether
the processor is currently actively driving the bus or not.

When this callback is not provided, the code behaviour won't change.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/w1-gpio.c |   35 +++++++++++++++++++++++++++++++++
 include/linux/w1-gpio.h      |    1 
 2 files changed, 36 insertions(+)

diff -puN drivers/w1/masters/w1-gpio.c~w1-gpio-add-external-pull-up-enable-callback drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~w1-gpio-add-external-pull-up-enable-callback
+++ a/drivers/w1/masters/w1-gpio.c
@@ -74,6 +74,9 @@ static int __init w1_gpio_probe(struct p
 	if (err)
 		goto free_gpio;
 
+	if (pdata->enable_external_pullup)
+		pdata->enable_external_pullup(1);
+
 	platform_set_drvdata(pdev, master);
 
 	return 0;
@@ -91,6 +94,9 @@ static int __exit w1_gpio_remove(struct 
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
 
+	if (pdata->enable_external_pullup)
+		pdata->enable_external_pullup(0);
+
 	w1_remove_master_device(master);
 	gpio_free(pdata->pin);
 	kfree(master);
@@ -98,12 +104,41 @@ static int __exit w1_gpio_remove(struct 
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata->enable_external_pullup)
+		pdata->enable_external_pullup(0);
+
+	return 0;
+}
+
+static int w1_gpio_resume(struct platform_device *pdev)
+{
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata->enable_external_pullup)
+		pdata->enable_external_pullup(1);
+
+	return 0;
+}
+
+#else
+#define w1_gpio_suspend	NULL
+#define w1_gpio_resume	NULL
+#endif
+
 static struct platform_driver w1_gpio_driver = {
 	.driver = {
 		.name	= "w1-gpio",
 		.owner	= THIS_MODULE,
 	},
 	.remove	= __exit_p(w1_gpio_remove),
+	.suspend = w1_gpio_suspend,
+	.resume = w1_gpio_resume,
 };
 
 static int __init w1_gpio_init(void)
diff -puN include/linux/w1-gpio.h~w1-gpio-add-external-pull-up-enable-callback include/linux/w1-gpio.h
--- a/include/linux/w1-gpio.h~w1-gpio-add-external-pull-up-enable-callback
+++ a/include/linux/w1-gpio.h
@@ -18,6 +18,7 @@
 struct w1_gpio_platform_data {
 	unsigned int pin;
 	unsigned int is_open_drain:1;
+	void (*enable_external_pullup)(int enable);
 };
 
 #endif /* _LINUX_W1_GPIO_H */
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch
w1-gpio-add-external-pull-up-enable-callback.patch

