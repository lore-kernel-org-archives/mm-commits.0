From: akpm@linux-foundation.org
Subject: [merged] backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:50 -0700
Message-ID: <20120326192850.6F958A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2CZT2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:52 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, dbaryshkov@gmail.com, hennerich@blackfin.uclinux.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: convert backlight i2c drivers to module_i2c_driver
has been removed from the -mm tree.  Its filename was
     backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
