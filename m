From: akpm@linux-foundation.org
Subject: + mfd-move-asic3-probe-functions-into-__init-section.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:39:12 -0700
Message-ID: <200806252139.m5PLdC9K028107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbYFYVjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, sameo@openedhand.com


The patch titled
     mfd: move asic3 probe functions into __init section
has been added to the -mm tree.  Its filename is
     mfd-move-asic3-probe-functions-into-__init-section.patch

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

mfd-move-asic3-probe-functions-into-__init-section.patch
mfd-fix-asic3-config-array-initialisation.patch

