From: akpm@linux-foundation.org
Subject: + drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init.patch added to -mm tree
Date: Mon, 17 Sep 2012 15:36:21 -0700
Message-ID: <20120917223622.B7FA420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47780 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2IQWgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 18:36:25 -0400
Received: by eaac1 with SMTP id c1so423750eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 15:36:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com


The patch titled
     Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add lis3lv02d device tree init
has been added to the -mm tree.  Its filename is
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init.patch

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
Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add lis3lv02d device tree init

Add lis3lv02d device tree initialization code/API to take pdata from
device node.  Also remove CONFIG_OF ifdef from the driver, if CONFIG_OF is
not defined then OF APIs returns 0.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init drivers/misc/lis3lv02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -84,10 +84,12 @@ static int __devinit lis302dl_spi_probe(
 	lis3_dev.ac		= lis3lv02d_axis_normal;
 	lis3_dev.pdata		= spi->dev.platform_data;
 
-#ifdef CONFIG_OF
-	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev))
+	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev)) {
 		lis3_dev.of_node = spi->dev.of_node;
-#endif
+		ret = lis3lv02d_init_dt(&lis3_dev);
+		if (ret)
+			return ret;
+	}
 
 	spi_set_drvdata(spi, &lis3_dev);
 
_

Patches currently in -mm which might be from anilkumar@ti.com are

linux-next.patch
drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch
drivers-misc-lis3lv02d-remove-lis3lv02d-driver-dt-init.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init.patch
drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init.patch

