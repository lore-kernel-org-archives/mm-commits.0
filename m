From: akpm@linux-foundation.org
Subject: [merged]
 drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:08 -0700
Message-ID: <51db14e4.f7MLJDB0tXbxImAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3GHThI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, giometti@enneenne.com, jlu@pengutronix.de

Subject: [merged] drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver.patch removed from -mm tree
To: jlu@pengutronix.de,giometti@enneenne.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:08 -0700


The patch titled
     Subject: drivers/pps/clients/pps-gpio.c: convert to module_platform_driver
has been removed from the -mm tree.  Its filename was
     drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: drivers/pps/clients/pps-gpio.c: convert to module_platform_driver

This removes some boilerplate code (no functional changes).

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver
+++ a/drivers/pps/clients/pps-gpio.c
@@ -187,23 +187,7 @@ static struct platform_driver pps_gpio_d
 	},
 };
 
-static int __init pps_gpio_init(void)
-{
-	int ret = platform_driver_register(&pps_gpio_driver);
-	if (ret < 0)
-		pr_err("failed to register platform driver\n");
-	return ret;
-}
-
-static void __exit pps_gpio_exit(void)
-{
-	platform_driver_unregister(&pps_gpio_driver);
-	pr_debug("unregistered platform driver\n");
-}
-
-module_init(pps_gpio_init);
-module_exit(pps_gpio_exit);
