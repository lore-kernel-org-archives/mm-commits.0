From: akpm@linux-foundation.org
Subject: [merged] pps-gpio-add-device-tree-binding-and-support.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:10 -0700
Message-ID: <51db14e6.AOhmMAAZE1rD/QfC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3GHThL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob.herring@calxeda.com, grant.likely@linaro.org, giometti@enneenne.com, arnd@arndb.de, jlu@pengutronix.de

Subject: [merged] pps-gpio-add-device-tree-binding-and-support.patch removed from -mm tree
To: jlu@pengutronix.de,arnd@arndb.de,giometti@enneenne.com,grant.likely@linaro.org,rob.herring@calxeda.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:10 -0700


The patch titled
     Subject: pps-gpio: add device-tree binding and support
has been removed from the -mm tree.  Its filename was
     pps-gpio-add-device-tree-binding-and-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: pps-gpio: add device-tree binding and support

Instead of allocating a struct pps_gpio_platform_data in the DT case,
store the necessary information in struct pps_gpio_device_data itself. 
This avoids an additional allocation and the ifdef.  It also gets rid of
some indirection.

Also use dev_err instead of pr_err in the changed code.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/pps/pps-gpio.txt |   20 +
 drivers/pps/clients/pps-gpio.c                     |  127 ++++++-----
 2 files changed, 93 insertions(+), 54 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/pps/pps-gpio.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/pps/pps-gpio.txt
@@ -0,0 +1,20 @@
+Device-Tree Bindings for a PPS Signal on GPIO
+
+These properties describe a PPS (pulse-per-second) signal connected to
+a GPIO pin.
+
+Required properties:
+- compatible: should be "pps-gpio"
+- gpios: one PPS GPIO in the format described by ../gpio/gpio.txt
+
+Optional properties:
+- assert-falling-edge: when present, assert is indicated by a falling edge
+                       (instead of by a rising edge)
+
+Example:
+	pps {
+		compatible = "pps-gpio";
+		gpios = <&gpio2 6 0>;
+
+		assert-falling-edge;
+	};
diff -puN drivers/pps/clients/pps-gpio.c~pps-gpio-add-device-tree-binding-and-support drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~pps-gpio-add-device-tree-binding-and-support
+++ a/drivers/pps/clients/pps-gpio.c
@@ -33,13 +33,17 @@
 #include <linux/pps-gpio.h>
 #include <linux/gpio.h>
 #include <linux/list.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
 
 /* Info for each registered platform device */
 struct pps_gpio_device_data {
 	int irq;			/* IRQ used as PPS source */
 	struct pps_device *pps;		/* PPS source device */
 	struct pps_source_info info;	/* PPS source information */
-	const struct pps_gpio_platform_data *pdata;
+	bool assert_falling_edge;
+	bool capture_clear;
+	unsigned int gpio_pin;
 };
 
 /*
@@ -57,45 +61,25 @@ static irqreturn_t pps_gpio_irq_handler(
 
 	info = data;
 
-	rising_edge = gpio_get_value(info->pdata->gpio_pin);
-	if ((rising_edge && !info->pdata->assert_falling_edge) ||
-			(!rising_edge && info->pdata->assert_falling_edge))
+	rising_edge = gpio_get_value(info->gpio_pin);
+	if ((rising_edge && !info->assert_falling_edge) ||
+			(!rising_edge && info->assert_falling_edge))
 		pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
-	else if (info->pdata->capture_clear &&
-			((rising_edge && info->pdata->assert_falling_edge) ||
-			 (!rising_edge && !info->pdata->assert_falling_edge)))
+	else if (info->capture_clear &&
+			((rising_edge && info->assert_falling_edge) ||
+			 (!rising_edge && !info->assert_falling_edge)))
 		pps_event(info->pps, &ts, PPS_CAPTURECLEAR, NULL);
 
 	return IRQ_HANDLED;
 }
 
-static int pps_gpio_setup(struct platform_device *pdev)
-{
-	int ret;
-	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
-
-	ret = devm_gpio_request(&pdev->dev, pdata->gpio_pin, pdata->gpio_label);
-	if (ret) {
-		pr_warning("failed to request GPIO %u\n", pdata->gpio_pin);
-		return -EINVAL;
-	}
-
-	ret = gpio_direction_input(pdata->gpio_pin);
-	if (ret) {
-		pr_warning("failed to set pin direction\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static unsigned long
-get_irqf_trigger_flags(const struct pps_gpio_platform_data *pdata)
+get_irqf_trigger_flags(const struct pps_gpio_device_data *data)
 {
-	unsigned long flags = pdata->assert_falling_edge ?
+	unsigned long flags = data->assert_falling_edge ?
 		IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
 
-	if (pdata->capture_clear) {
+	if (data->capture_clear) {
 		flags |= ((flags & IRQF_TRIGGER_RISING) ?
 				IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING);
 	}
@@ -106,34 +90,63 @@ get_irqf_trigger_flags(const struct pps_
 static int pps_gpio_probe(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data;
-	int irq;
+	const char *gpio_label;
 	int ret;
 	int pps_default_params;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 
+	/* allocate space for device info */
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
+			GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (pdata) {
+		data->gpio_pin = pdata->gpio_pin;
+		gpio_label = pdata->gpio_label;
+
+		data->assert_falling_edge = pdata->assert_falling_edge;
+		data->capture_clear = pdata->capture_clear;
+	} else {
+		ret = of_get_gpio(np, 0);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to get GPIO from device tree\n");
+			return ret;
+		}
+		data->gpio_pin = ret;
+		gpio_label = PPS_GPIO_NAME;
+
+		if (of_get_property(np, "assert-falling-edge", NULL))
+			data->assert_falling_edge = true;
+	}
 
 	/* GPIO setup */
-	ret = pps_gpio_setup(pdev);
-	if (ret)
+	ret = devm_gpio_request(&pdev->dev, data->gpio_pin, gpio_label);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request GPIO %u\n",
+			data->gpio_pin);
+		return ret;
+	}
+
+	ret = gpio_direction_input(data->gpio_pin);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to set pin direction\n");
 		return -EINVAL;
+	}
 
 	/* IRQ setup */
-	irq = gpio_to_irq(pdata->gpio_pin);
-	if (irq < 0) {
-		pr_err("failed to map GPIO to IRQ: %d\n", irq);
+	ret = gpio_to_irq(data->gpio_pin);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to map GPIO to IRQ: %d\n", ret);
 		return -EINVAL;
 	}
-
-	/* allocate space for device info */
-	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
-			    GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
+	data->irq = ret;
 
 	/* initialize PPS specific parts of the bookkeeping data structure. */
 	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
 		PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
-	if (pdata->capture_clear)
+	if (data->capture_clear)
 		data->info.mode |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR |
 			PPS_ECHOCLEAR;
 	data->info.owner = THIS_MODULE;
@@ -142,28 +155,27 @@ static int pps_gpio_probe(struct platfor
 
 	/* register PPS source */
 	pps_default_params = PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
-	if (pdata->capture_clear)
+	if (data->capture_clear)
 		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (data->pps == NULL) {
-		pr_err("failed to register IRQ %d as PPS source\n", irq);
+		dev_err(&pdev->dev, "failed to register IRQ %d as PPS source\n",
+			data->irq);
 		return -EINVAL;
 	}
 
-	data->irq = irq;
-	data->pdata = pdata;
-
 	/* register IRQ interrupt handler */
-	ret = devm_request_irq(&pdev->dev, irq, pps_gpio_irq_handler,
-			get_irqf_trigger_flags(pdata), data->info.name, data);
+	ret = devm_request_irq(&pdev->dev, data->irq, pps_gpio_irq_handler,
+			get_irqf_trigger_flags(data), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
-		pr_err("failed to acquire IRQ %d\n", irq);
+		dev_err(&pdev->dev, "failed to acquire IRQ %d\n", data->irq);
 		return -EINVAL;
 	}
 
 	platform_set_drvdata(pdev, data);
-	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n", irq);
+	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n",
+		 data->irq);
 
 	return 0;
 }
@@ -174,16 +186,23 @@ static int pps_gpio_remove(struct platfo
 
 	platform_set_drvdata(pdev, NULL);
 	pps_unregister_source(data->pps);
-	pr_info("removed IRQ %d as PPS source\n", data->irq);
+	dev_info(&pdev->dev, "removed IRQ %d as PPS source\n", data->irq);
 	return 0;
 }
 
+static const struct of_device_id pps_gpio_dt_ids[] = {
+	{ .compatible = "pps-gpio", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pps_gpio_dt_ids);
+
 static struct platform_driver pps_gpio_driver = {
 	.probe		= pps_gpio_probe,
 	.remove		= pps_gpio_remove,
 	.driver		= {
 		.name	= PPS_GPIO_NAME,
-		.owner	= THIS_MODULE
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(pps_gpio_dt_ids),
 	},
 };
 
_

Patches currently in -mm which might be from jlu@pengutronix.de are

origin.patch
linux-next.patch

