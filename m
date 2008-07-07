From: akpm@linux-foundation.org
Subject: - mfd-move-asic3-probe-functions-into-__init-section.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:06:15 -0700
Message-ID: <200807070306.m6736FrJ004901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbYGGDGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: move asic3 probe functions into __init section
has been removed from the -mm tree.  Its filename was
     mfd-move-asic3-probe-functions-into-__init-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: move asic3 probe functions into __init section
From: Philipp Zabel <philipp.zabel@gmail.com>

Potentially free some memory by moving the _probe functions into __init.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/mfd/asic3.c~mfd-move-asic3-probe-functions-into-__init-section drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~mfd-move-asic3-probe-functions-into-__init-section
+++ a/drivers/mfd/asic3.c
@@ -308,7 +308,7 @@ static struct irq_chip asic3_irq_chip = 
 	.unmask		= asic3_unmask_irq,
 };
 
-static int asic3_irq_probe(struct platform_device *pdev)
+static int __init asic3_irq_probe(struct platform_device *pdev)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
 	unsigned long clksel = 0;
@@ -467,8 +467,8 @@ static void asic3_gpio_set(struct gpio_c
 	return;
 }
 
-static int asic3_gpio_probe(struct platform_device *pdev,
-			    u16 *gpio_config, int num)
+static __init int asic3_gpio_probe(struct platform_device *pdev,
+				   u16 *gpio_config, int num)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
 	u16 alt_reg[ASIC3_NUM_GPIO_BANKS];
@@ -529,7 +529,7 @@ static int asic3_gpio_remove(struct plat
 
 
 /* Core */
-static int asic3_probe(struct platform_device *pdev)
+static int __init asic3_probe(struct platform_device *pdev)
 {
 	struct asic3_platform_data *pdata = pdev->dev.platform_data;
 	struct asic3 *asic;
@@ -636,7 +636,6 @@ static struct platform_driver asic3_devi
 	.driver		= {
 		.name	= "asic3",
 	},
-	.probe		= asic3_probe,
 	.remove		= __devexit_p(asic3_remove),
 	.shutdown	= asic3_shutdown,
 };
@@ -644,7 +643,7 @@ static struct platform_driver asic3_devi
 static int __init asic3_init(void)
 {
 	int retval = 0;
-	retval = platform_driver_register(&asic3_device_driver);
+	retval = platform_driver_probe(&asic3_device_driver, asic3_probe);
 	return retval;
 }
 
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch

