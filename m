From: akpm@linux-foundation.org
Subject: + asic3-use-dev_-macros.patch added to -mm tree
Date: Mon, 12 May 2008 16:25:04 -0700
Message-ID: <200805122325.m4CNP4uT014438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbYELXZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:25:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sameo@openedhand.com


The patch titled
     asic3: use dev_* macros
has been added to the -mm tree.  Its filename is
     asic3-use-dev_-macros.patch

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
Subject: asic3: use dev_* macros
From: Samuel Ortiz <sameo@openedhand.com>

We replace the various printks, and use the dev_* macros instead.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-use-dev_-macros drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-use-dev_-macros
+++ a/drivers/mfd/asic3.c
@@ -145,8 +145,7 @@ static void asic3_irq_demux(unsigned int
 	}
 
 	if (iter >= MAX_ASIC_ISR_LOOPS)
-		printk(KERN_ERR "%s: interrupt processing overrun\n",
-		       __func__);
+		dev_err(asic->dev, "interrupt processing overrun\n");
 }
 
 static inline int asic3_irq_to_bank(struct asic3 *asic, int irq)
@@ -282,7 +281,7 @@ static int asic3_gpio_irq_type(unsigned 
 		 * be careful to not unmask them if mask was also called.
 		 * Probably need internal state for mask.
 		 */
-		printk(KERN_NOTICE "asic3: irq type not changed.\n");
+		dev_notice(asic->dev, "irq type not changed\n");
 	}
 	asic3_write_register(asic, bank + ASIC3_GPIO_LevelTrigger,
 			     level);
@@ -379,8 +378,8 @@ static int asic3_gpio_direction(struct g
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
 	if (gpio_base > ASIC3_GPIO_D_Base) {
-		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
-		       gpio_base, offset);
+		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
+			gpio_base, offset);
 		return -EINVAL;
 	}
 
@@ -425,8 +424,8 @@ static int asic3_gpio_get(struct gpio_ch
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
 	if (gpio_base > ASIC3_GPIO_D_Base) {
-		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
-		       gpio_base, offset);
+		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
+			gpio_base, offset);
 		return -EINVAL;
 	}
 
@@ -445,8 +444,8 @@ static void asic3_gpio_set(struct gpio_c
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
 	if (gpio_base > ASIC3_GPIO_D_Base) {
-		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
-		       gpio_base, offset);
+		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
+			gpio_base, offset);
 		return;
 	}
 
@@ -551,7 +550,7 @@ static int asic3_probe(struct platform_d
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
 		ret = -ENOMEM;
-		printk(KERN_ERR "asic3: no MEM resource\n");
+		dev_err(asic->dev, "no MEM resource\n");
 		goto out_free;
 	}
 
@@ -559,7 +558,7 @@ static int asic3_probe(struct platform_d
 	asic->mapping = ioremap(mem->start, PAGE_SIZE);
 	if (!asic->mapping) {
 		ret = -ENOMEM;
-		printk(KERN_ERR "asic3: couldn't ioremap\n");
+		dev_err(asic->dev, "Couldn't ioremap\n");
 		goto out_free;
 	}
 
@@ -575,7 +574,7 @@ static int asic3_probe(struct platform_d
 
 	ret = asic3_irq_probe(pdev);
 	if (ret < 0) {
-		printk(KERN_ERR "asic3: couldn't probe IRQs\n");
+		dev_err(asic->dev, "Couldn't probe IRQs\n");
 		goto out_unmap;
 	}
 
@@ -590,11 +589,11 @@ static int asic3_probe(struct platform_d
 			       pdata->gpio_config,
 			       pdata->gpio_config_num);
 	if (ret < 0) {
-		printk(KERN_ERR "GPIO probe failed\n");
+		dev_err(asic->dev, "GPIO probe failed\n");
 		goto out_irq;
 	}
 
-	printk(KERN_INFO "ASIC3 Core driver\n");
+	dev_info(asic->dev, "ASIC3 Core driver\n");
 
 	return 0;
 
_

Patches currently in -mm which might be from sameo@openedhand.com are

asic3-platform_get_irq-may-return-signed-unnoticed.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
asic3-use-dev_-macros.patch
asic3-use-uppercase-only-for-macros-and-defines.patch

