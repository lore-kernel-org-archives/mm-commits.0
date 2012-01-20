From: akpm@linux-foundation.org
Subject: + platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:21:53 -0800
Message-ID: <20120120232154.498D05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58955 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab2ATXV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:21:57 -0500
Received: by eekb15 with SMTP id b15so41019eek.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:21:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, Durgadoss.r@intel.com, dsd@laptop.org, hong.liu@intel.com, mjg@redhat.com


The patch titled
     From: Axel Lin <axel.lin@gmail.com>
has been added to the -mm tree.  Its filename is
     platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: platform-drivers-x86: convert drivers/platform/x86/* to use module_platform_driver()

Convert the drivers in drivers/platform/x86/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Hong Liu <hong.liu@intel.com>
Acked-by: Durgadoss R <Durgadoss.r@intel.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_mid_powerbtn.c |   12 +-----------
 drivers/platform/x86/intel_mid_thermal.c  |   13 +------------
 drivers/platform/x86/xo1-rfkill.c         |   13 +------------
 3 files changed, 3 insertions(+), 35 deletions(-)

diff -puN drivers/platform/x86/intel_mid_powerbtn.c~platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver drivers/platform/x86/intel_mid_powerbtn.c
--- a/drivers/platform/x86/intel_mid_powerbtn.c~platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver
+++ a/drivers/platform/x86/intel_mid_powerbtn.c
@@ -118,17 +118,7 @@ static struct platform_driver mfld_pb_dr
 	.remove	= __devexit_p(mfld_pb_remove),
 };
 
-static int __init mfld_pb_init(void)
-{
-	return platform_driver_register(&mfld_pb_driver);
-}
-module_init(mfld_pb_init);
-
-static void __exit mfld_pb_exit(void)
-{
-	platform_driver_unregister(&mfld_pb_driver);
-}
-module_exit(mfld_pb_exit);
+module_platform_driver(mfld_pb_driver);
 
 MODULE_AUTHOR("Hong Liu <hong.liu@intel.com>");
 MODULE_DESCRIPTION("Intel Medfield Power Button Driver");
diff -puN drivers/platform/x86/intel_mid_thermal.c~platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver drivers/platform/x86/intel_mid_thermal.c
--- a/drivers/platform/x86/intel_mid_thermal.c~platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver
+++ a/drivers/platform/x86/intel_mid_thermal.c
@@ -565,18 +565,7 @@ static struct platform_driver mid_therma
 	.id_table = therm_id_table,
 };
 
-static int __init mid_thermal_module_init(void)
-{
-	return platform_driver_register(&mid_thermal_driver);
-}
-
-static void __exit mid_thermal_module_exit(void)
-{
-	platform_driver_unregister(&mid_thermal_driver);
-}
-
-module_init(mid_thermal_module_init);
-module_exit(mid_thermal_module_exit);
+module_platform_driver(mid_thermal_driver);
 
 MODULE_AUTHOR("Durgadoss R <durgadoss.r@intel.com>");
 MODULE_DESCRIPTION("Intel Medfield Platform Thermal Driver");
diff -puN drivers/platform/x86/xo1-rfkill.c~platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver drivers/platform/x86/xo1-rfkill.c
--- a/drivers/platform/x86/xo1-rfkill.c~platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver
+++ a/drivers/platform/x86/xo1-rfkill.c
@@ -67,19 +67,8 @@ static struct platform_driver xo1_rfkill
 	.remove		= __devexit_p(xo1_rfkill_remove),
 };
 
-static int __init xo1_rfkill_init(void)
-{
-	return platform_driver_register(&xo1_rfkill_driver);
-}
-
-static void __exit xo1_rfkill_exit(void)
-{
-	platform_driver_unregister(&xo1_rfkill_driver);
-}
+module_platform_driver(xo1_rfkill_driver);
 
 MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:xo1-rfkill");
