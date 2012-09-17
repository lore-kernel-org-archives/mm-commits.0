From: akpm@linux-foundation.org
Subject: + drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init.patch added to -mm tree
Date: Mon, 17 Sep 2012 15:36:18 -0700
Message-ID: <20120917223619.226EC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37144 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2IQWgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 18:36:20 -0400
Received: by ggnu1 with SMTP id u1so747246ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 15:36:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com


The patch titled
     Subject: drivers/misc/lis3lv02d: remove lis3lv02d driver DT init
has been added to the -mm tree.  Its filename is
     drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: AnilKumar Ch <anilkumar@ti.com>
Subject: drivers/misc/lis3lv02d: remove lis3lv02d driver DT init

Remove lis3lv02d driver device tree initialization from core driver and
move it to individual drivers.  With the current implementation some pdata
parameters are missing if we use lis3lv02d_init_device() in lis3lv02d_i2c
driver.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |    8 ++------
 drivers/misc/lis3lv02d/lis3lv02d.h |    1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init drivers/misc/lis3lv02d/lis3lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -944,7 +944,7 @@ static void lis3lv02d_8b_configure(struc
 }
 
 #ifdef CONFIG_OF
-static int lis3lv02d_init_dt(struct lis3lv02d *lis3)
+int lis3lv02d_init_dt(struct lis3lv02d *lis3)
 {
 	struct lis3lv02d_platform_data *pdata;
 	struct device_node *np = lis3->of_node;
@@ -1084,7 +1084,7 @@ static int lis3lv02d_init_dt(struct lis3
 }
 
 #else
-static int lis3lv02d_init_dt(struct lis3lv02d *lis3)
+int lis3lv02d_init_dt(struct lis3lv02d *lis3)
 {
 	return 0;
 }
@@ -1100,10 +1100,6 @@ int lis3lv02d_init_device(struct lis3lv0
 	irq_handler_t thread_fn;
 	int irq_flags = 0;
 
-	err = lis3lv02d_init_dt(lis3);
-	if (err < 0)
-		return err;
