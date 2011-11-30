From: akpm@linux-foundation.org
Subject: + parport-convert-drivers-parport-to-use-module_platform_driver.patch added to -mm tree
Date: Wed, 30 Nov 2011 13:03:41 -0800
Message-ID: <201111302103.pAUL3fnS021171@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:40425 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1K3VDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 16:03:45 -0500
Received: by vcbfl11 with SMTP id fl11so124593vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 13:03:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, ben@simtec.co.uk, greg@kroah.com, shadow@dementia.org


The patch titled
     Subject: parport: convert drivers/parport/* to use module_platform_driver()
has been added to the -mm tree.  Its filename is
     parport-convert-drivers-parport-to-use-module_platform_driver.patch

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
