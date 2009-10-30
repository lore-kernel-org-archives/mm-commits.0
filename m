From: akpm@linux-foundation.org
Subject: [merged] twl4030-gpio-remove-__devexit-markings-from-remove-func.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:51:16 -0700
Message-ID: <200910302051.n9UKpGR6012596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283AbZJ3Uvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     twl4030-gpio: remove __devexit markings from remove func
has been removed from the -mm tree.  Its filename was
     twl4030-gpio-remove-__devexit-markings-from-remove-func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: twl4030-gpio: remove __devexit markings from remove func
From: Mike Frysinger <vapier@gentoo.org>

The gpio_twl4030_probe() function calls gpio_twl4030_remove(), and the
former has __devinit, so the latter cannot use __devexit.  Otherwise we
hit the section mismatch warning:

WARNING: drivers/gpio/built-in.o(.devinit.text+0x71a): Section mismatch
	in reference from the function _gpio_twl4030_probe() to the function
	.devexit.text:_gpio_twl4030_remove()
The function __devinit _gpio_twl4030_probe() references a function
	__devexit _gpio_twl4030_remove().
This is often seen when error handling in the init function uses
	functionality in the exit path.
The fix is often to remove the __devexit annotation of
	_gpio_twl4030_remove() so it may be used outside an exit section.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/gpio/twl4030-gpio.c~twl4030-gpio-remove-__devexit-markings-from-remove-func drivers/gpio/twl4030-gpio.c
--- a/drivers/gpio/twl4030-gpio.c~twl4030-gpio-remove-__devexit-markings-from-remove-func
+++ a/drivers/gpio/twl4030-gpio.c
@@ -460,7 +460,8 @@ no_irqs:
 	return ret;
 }
 
-static int __devexit gpio_twl4030_remove(struct platform_device *pdev)
+/* Cannot use __devexit as gpio_twl4030_probe() calls us */
+static int gpio_twl4030_remove(struct platform_device *pdev)
 {
 	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int status;
@@ -493,7 +494,7 @@ static struct platform_driver gpio_twl40
 	.driver.name	= "twl4030_gpio",
 	.driver.owner	= THIS_MODULE,
 	.probe		= gpio_twl4030_probe,
-	.remove		= __devexit_p(gpio_twl4030_remove),
+	.remove		= gpio_twl4030_remove,
 };
 
 static int __init gpio_twl4030_init(void)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
firmware-only-allow-edd-on-x86.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

