From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:22 -0700
Message-ID: <20121001192823.8E8BB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35837 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2JAT20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:26 -0400
Received: by lbol12 with SMTP id l12so254863lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lis3lv02d: remove lis3lv02d driver DT init
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1101,10 +1101,6 @@ int lis3lv02d_init_device(struct lis3lv0
 	irq_handler_t thread_fn;
 	int irq_flags = 0;
 
-	err = lis3lv02d_init_dt(lis3);
-	if (err < 0)
-		return err;
