From: akpm@linux-foundation.org
Subject: + pca953x-pca953x-driver-fixes-for-x86-mrst.patch added to -mm tree
Date: Fri, 22 Oct 2010 12:53:19 -0700
Message-ID: <201010221953.o9MJrJqK004168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759041Ab0JVTxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 15:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com, alan@linux.intel.com


The patch titled
     pca953x: pca953x driver fixes for x86 mrst
has been added to the -mm tree.  Its filename is
     pca953x-pca953x-driver-fixes-for-x86-mrst.patch

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
Subject: pca953x: pca953x driver fixes for x86 mrst
From: Alek Du <alek.du@intel.com>

Our Moorestown platform has two max7315 chips which is covered by pca953x
i2c gpio driver.

A while ago this driver got updated with nested irq thread support, and it
broke the compatibity with "request_irq".  For example, the gpio_keys.c
driver can not work with this driver now.  This patch fixes the issue by
switching to generic_handle_irq.

Also fix the irq_base issue: irq_base == 0 is valid, and a "-1" value
should mean invalid. IRQ 0 is not a valid IRQ, irq_base of 0 is valid.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/gpio/pca953x.c~pca953x-pca953x-driver-fixes-for-x86-mrst drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~pca953x-pca953x-driver-fixes-for-x86-mrst
+++ a/drivers/gpio/pca953x.c
@@ -345,7 +345,7 @@ static irqreturn_t pca953x_irq_handler(i
 
 	do {
 		level = __ffs(pending);
-		handle_nested_irq(level + chip->irq_base);
+		generic_handle_irq(level + chip->irq_base);
 
 		pending &= ~(1 << level);
 	} while (pending);
@@ -360,7 +360,8 @@ static int pca953x_irq_setup(struct pca9
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
 	int ret;
 
-	if (pdata->irq_base && (id->driver_data & PCA953X_INT)) {
+	if (pdata->irq_base != -1
+			&& (id->driver_data & PCA953X_INT)) {
 		int lvl;
 
 		ret = pca953x_read_reg(chip, PCA953X_INPUT,
@@ -383,7 +384,6 @@ static int pca953x_irq_setup(struct pca9
 			set_irq_chip_data(irq, chip);
 			set_irq_chip_and_handler(irq, &pca953x_irq_chip,
 						 handle_edge_irq);
-			set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
@@ -394,6 +394,7 @@ static int pca953x_irq_setup(struct pca9
 		ret = request_threaded_irq(client->irq,
 					   NULL,
 					   pca953x_irq_handler,
+					   IRQF_TRIGGER_RISING |
 					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 					   dev_name(&client->dev), chip);
 		if (ret) {
@@ -408,13 +409,13 @@ static int pca953x_irq_setup(struct pca9
 	return 0;
 
 out_failed:
-	chip->irq_base = 0;
+	chip->irq_base = -1;
 	return ret;
 }
 
 static void pca953x_irq_teardown(struct pca953x_chip *chip)
 {
-	if (chip->irq_base)
+	if (chip->irq_base != -1)
 		free_irq(chip->client->irq, chip);
 }
 #else /* CONFIG_GPIO_PCA953X_IRQ */
@@ -424,7 +425,7 @@ static int pca953x_irq_setup(struct pca9
 	struct i2c_client *client = chip->client;
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
 
-	if (pdata->irq_base && (id->driver_data & PCA953X_INT))
+	if (pdata->irq_base != -1 && (id->driver_data & PCA953X_INT))
 		dev_warn(&client->dev, "interrupt support not compiled in\n");
 
 	return 0;
_

Patches currently in -mm which might be from alek.du@intel.com are

linux-next.patch
pca953x-pca953x-driver-fixes-for-x86-mrst.patch
drivers-gpio-langwell_gpioc-remove-semicolons-after-function-definitions.patch

