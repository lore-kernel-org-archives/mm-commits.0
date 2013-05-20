From: akpm@linux-foundation.org
Subject: + drivers-pps-clients-pps-gpioc-convert-to-devm_-helpers.patch
 added to -mm tree
Date: Mon, 20 May 2013 16:22:54 -0700
Message-ID: <519ab04e.aB/xsq0eAw3f67tq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3ETXWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, giometti@enneenne.com, jlu@pengutronix.de

Subject: + drivers-pps-clients-pps-gpioc-convert-to-devm_-helpers.patch added to -mm tree
To: jlu@pengutronix.de,giometti@enneenne.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:22:54 -0700


The patch titled
     Subject: drivers/pps/clients/pps-gpio.c: convert to devm_* helpers
has been added to the -mm tree.  Its filename is
     drivers-pps-clients-pps-gpioc-convert-to-devm_-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: drivers/pps/clients/pps-gpio.c: convert to devm_* helpers

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-convert-to-devm_-helpers drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-convert-to-devm_-helpers
+++ a/drivers/pps/clients/pps-gpio.c
@@ -74,7 +74,7 @@ static int pps_gpio_setup(struct platfor
 	int ret;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
 
-	ret = gpio_request(pdata->gpio_pin, pdata->gpio_label);
+	ret = devm_gpio_request(&pdev->dev, pdata->gpio_pin, pdata->gpio_label);
 	if (ret) {
 		pr_warning("failed to request GPIO %u\n", pdata->gpio_pin);
 		return -EINVAL;
@@ -83,7 +83,6 @@ static int pps_gpio_setup(struct platfor
 	ret = gpio_direction_input(pdata->gpio_pin);
 	if (ret) {
 		pr_warning("failed to set pin direction\n");
-		gpio_free(pdata->gpio_pin);
 		return -EINVAL;
 	}
 
@@ -109,7 +108,6 @@ static int pps_gpio_probe(struct platfor
 	struct pps_gpio_device_data *data;
 	int irq;
 	int ret;
-	int err;
 	int pps_default_params;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
 
@@ -123,17 +121,14 @@ static int pps_gpio_probe(struct platfor
 	irq = gpio_to_irq(pdata->gpio_pin);
 	if (irq < 0) {
 		pr_err("failed to map GPIO to IRQ: %d\n", irq);
-		err = -EINVAL;
-		goto return_error;
+		return -EINVAL;
 	}
 
 	/* allocate space for device info */
 	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
 			    GFP_KERNEL);
-	if (data == NULL) {
-		err = -ENOMEM;
-		goto return_error;
-	}
+	if (data == NULL)
+		return -ENOMEM;
 
 	/* initialize PPS specific parts of the bookkeeping data structure. */
 	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
@@ -152,41 +147,32 @@ static int pps_gpio_probe(struct platfor
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (data->pps == NULL) {
 		pr_err("failed to register IRQ %d as PPS source\n", irq);
-		err = -EINVAL;
-		goto return_error;
+		return -EINVAL;
 	}
 
 	data->irq = irq;
 	data->pdata = pdata;
 
 	/* register IRQ interrupt handler */
-	ret = request_irq(irq, pps_gpio_irq_handler,
+	ret = devm_request_irq(&pdev->dev, irq, pps_gpio_irq_handler,
 			get_irqf_trigger_flags(pdata), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
 		pr_err("failed to acquire IRQ %d\n", irq);
-		err = -EINVAL;
-		goto return_error;
+		return -EINVAL;
 	}
 
 	platform_set_drvdata(pdev, data);
 	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n", irq);
 
 	return 0;
