From: akpm@linux-foundation.org
Subject: +
 drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver.patch added to -mm tree
Date: Mon, 20 May 2013 16:22:55 -0700
Message-ID: <519ab04f.cAUuhfSW4s0tc75j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3ETXW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, giometti@enneenne.com, jlu@pengutronix.de

Subject: + drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver.patch added to -mm tree
To: jlu@pengutronix.de,giometti@enneenne.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:22:55 -0700


The patch titled
     Subject: drivers/pps/clients/pps-gpio.c: convert to module_platform_driver
has been added to the -mm tree.  Its filename is
     drivers-pps-clients-pps-gpioc-convert-to-module_platform_driver.patch

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
