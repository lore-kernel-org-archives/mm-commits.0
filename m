From: akpm@linux-foundation.org
Subject: [merged] drivers-pps-clients-pps-gpioc-use-devm_kzalloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:39 -0800
Message-ID: <20130228201739.9DDC731C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:45395 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3B1URk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:40 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261676qah.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pps/clients/pps-gpio.c: use devm_kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-pps-clients-pps-gpioc-use-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: drivers/pps/clients/pps-gpio.c: use devm_kzalloc

devm_kzalloc allocates memory that is released when a driver detaches. 
This patch uses devm_kzalloc for data that is allocated in the probe
function of a platform device and is only freed in the remove function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-use-devm_kzalloc drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-use-devm_kzalloc
+++ a/drivers/pps/clients/pps-gpio.c
@@ -128,7 +128,8 @@ static int pps_gpio_probe(struct platfor
 	}
 
 	/* allocate space for device info */
-	data = kzalloc(sizeof(struct pps_gpio_device_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
+			    GFP_KERNEL);
 	if (data == NULL) {
 		err = -ENOMEM;
 		goto return_error;
@@ -150,7 +151,6 @@ static int pps_gpio_probe(struct platfor
 		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (data->pps == NULL) {
-		kfree(data);
 		pr_err("failed to register IRQ %d as PPS source\n", irq);
 		err = -EINVAL;
 		goto return_error;
@@ -164,7 +164,6 @@ static int pps_gpio_probe(struct platfor
 			get_irqf_trigger_flags(pdata), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
-		kfree(data);
 		pr_err("failed to acquire IRQ %d\n", irq);
 		err = -EINVAL;
 		goto return_error;
@@ -190,7 +189,6 @@ static int pps_gpio_remove(struct platfo
 	gpio_free(pdata->gpio_pin);
 	pps_unregister_source(data->pps);
 	pr_info("removed IRQ %d as PPS source\n", data->irq);
-	kfree(data);
 	return 0;
 }
 
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch
linux-next.patch

