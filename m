From: akpm@linux-foundation.org
Subject: [merged] parport-convert-drivers-parport-to-use-module_platform_driver.patch removed from -mm tree
Date: Thu, 01 Dec 2011 12:32:25 -0800
Message-ID: <201112012032.pB1KWPCK008723@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33357 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1LAUc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:32:28 -0500
Received: by ghrr18 with SMTP id r18so313565ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:32:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, ben@simtec.co.uk, greg@kroah.com, shadow@dementia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parport: convert drivers/parport/* to use module_platform_driver()
has been removed from the -mm tree.  Its filename was
     parport-convert-drivers-parport-to-use-module_platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: parport: convert drivers/parport/* to use module_platform_driver()

Convert the drivers in drivers/parport/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Derrick J. Brashear <shadow@dementia.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_ax88796.c |   13 +------------
 drivers/parport/parport_sunbpp.c  |   13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff -puN drivers/parport/parport_ax88796.c~parport-convert-drivers-parport-to-use-module_platform_driver drivers/parport/parport_ax88796.c
--- a/drivers/parport/parport_ax88796.c~parport-convert-drivers-parport-to-use-module_platform_driver
+++ a/drivers/parport/parport_ax88796.c
@@ -420,18 +420,7 @@ static struct platform_driver axdrv = {
 	.resume		= parport_ax88796_resume,
 };
 
-static int __init parport_ax88796_init(void)
-{
-	return platform_driver_register(&axdrv);
-}
-
-static void __exit parport_ax88796_exit(void)
-{
-	platform_driver_unregister(&axdrv);
-}
-
-module_init(parport_ax88796_init)
-module_exit(parport_ax88796_exit)
+module_platform_driver(axdrv);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("AX88796 Parport parallel port driver");
diff -puN drivers/parport/parport_sunbpp.c~parport-convert-drivers-parport-to-use-module_platform_driver drivers/parport/parport_sunbpp.c
--- a/drivers/parport/parport_sunbpp.c~parport-convert-drivers-parport-to-use-module_platform_driver
+++ a/drivers/parport/parport_sunbpp.c
@@ -391,21 +391,10 @@ static struct platform_driver bpp_sbus_d
 	.remove		= __devexit_p(bpp_remove),
 };
 
-static int __init parport_sunbpp_init(void)
-{
-	return platform_driver_register(&bpp_sbus_driver);
-}
-
-static void __exit parport_sunbpp_exit(void)
-{
-	platform_driver_unregister(&bpp_sbus_driver);
-}
+module_platform_driver(bpp_sbus_driver);
 
 MODULE_AUTHOR("Derrick J Brashear");
 MODULE_DESCRIPTION("Parport Driver for Sparc bidirectional Port");
 MODULE_SUPPORTED_DEVICE("Sparc Bidirectional Parallel Port");
 MODULE_VERSION("2.0");
 MODULE_LICENSE("GPL");
