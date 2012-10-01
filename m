From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:27 -0700
Message-ID: <20121001192828.2B65D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49410 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2JAT2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:30 -0400
Received: by weyx43 with SMTP id x43so335588wey.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add lis3lv02d device tree init
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: AnilKumar Ch <anilkumar@ti.com>
Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add lis3lv02d device tree init

Add lis3lv02d device tree initialization code/API to take pdata from
device node.  Also remove CONFIG_OF ifdef from the driver, if CONFIG_OF is
not defined then OF APIs returns 0.

[akpm@linux-foundation.org: fix CONFIG_OF=n build[
Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init drivers/misc/lis3lv02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -19,6 +19,7 @@
 #include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_device.h>
 
 #include "lis3lv02d.h"
 
@@ -87,10 +88,13 @@ static int __devinit lis302dl_spi_probe(
 	lis3_dev.pdata		= spi->dev.platform_data;
 
 #ifdef CONFIG_OF
-	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev))
+	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev)) {
 		lis3_dev.of_node = spi->dev.of_node;
+		ret = lis3lv02d_init_dt(&lis3_dev);
+		if (ret)
+			return ret;
+	}
 #endif
