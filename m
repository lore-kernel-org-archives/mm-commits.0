From: akpm@linux-foundation.org
Subject: + backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:13:19 -0800
Message-ID: <20120113221320.A679E5C0066@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45037 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2AMWNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:13:23 -0500
Received: by eeke50 with SMTP id e50so26317eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:13:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, dbaryshkov@gmail.com, hennerich@blackfin.uclinux.org, rpurdie@rpsys.net


The patch titled
     Subject: backlight: convert backlight i2c drivers to module_i2c_driver
has been added to the -mm tree.  Its filename is
     backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch

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
Subject: backlight: convert backlight i2c drivers to module_i2c_driver

Factor out some boilerplate code for i2c driver registration into
module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |   12 +-----------
 drivers/video/backlight/adp8870_bl.c |   12 +-----------
 drivers/video/backlight/tosa_bl.c    |   13 +------------
 3 files changed, 3 insertions(+), 34 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~backlight-convert-backlight-i2c-drivers-to-module_i2c_driver drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~backlight-convert-backlight-i2c-drivers-to-module_i2c_driver
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -819,17 +819,7 @@ static struct i2c_driver adp8860_driver 
 	.id_table = adp8860_id,
 };
 
-static int __init adp8860_init(void)
-{
-	return i2c_add_driver(&adp8860_driver);
-}
-module_init(adp8860_init);
-
-static void __exit adp8860_exit(void)
-{
-	i2c_del_driver(&adp8860_driver);
-}
-module_exit(adp8860_exit);
+module_i2c_driver(adp8860_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff -puN drivers/video/backlight/adp8870_bl.c~backlight-convert-backlight-i2c-drivers-to-module_i2c_driver drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-convert-backlight-i2c-drivers-to-module_i2c_driver
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -991,17 +991,7 @@ static struct i2c_driver adp8870_driver 
 	.id_table = adp8870_id,
 };
 
-static int __init adp8870_init(void)
-{
-	return i2c_add_driver(&adp8870_driver);
-}
-module_init(adp8870_init);
-
-static void __exit adp8870_exit(void)
-{
-	i2c_del_driver(&adp8870_driver);
-}
-module_exit(adp8870_exit);
+module_i2c_driver(adp8870_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff -puN drivers/video/backlight/tosa_bl.c~backlight-convert-backlight-i2c-drivers-to-module_i2c_driver drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-convert-backlight-i2c-drivers-to-module_i2c_driver
+++ a/drivers/video/backlight/tosa_bl.c
@@ -181,18 +181,7 @@ static struct i2c_driver tosa_bl_driver 
 	.id_table	= tosa_bl_id,
 };
 
-static int __init tosa_bl_init(void)
-{
-	return i2c_add_driver(&tosa_bl_driver);
-}
-
-static void __exit tosa_bl_exit(void)
-{
-	i2c_del_driver(&tosa_bl_driver);
-}
