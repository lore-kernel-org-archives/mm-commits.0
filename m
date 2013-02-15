From: akpm@linux-foundation.org
Subject: + drivers-pps-clients-pps-gpioc-use-devm_kzalloc.patch added to -mm tree
Date: Thu, 14 Feb 2013 16:04:22 -0800
Message-ID: <20130215000422.A1DE831C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56151 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935102Ab3BOAEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 19:04:23 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so304923yen.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 16:04:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, giometti@enneenne.com


The patch titled
     Subject: drivers/pps/clients/pps-gpio.c: use devm_kzalloc
has been added to the -mm tree.  Its filename is
     drivers-pps-clients-pps-gpioc-use-devm_kzalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-pps-clients-pps-gpioc-use-devm_kzalloc.patch

