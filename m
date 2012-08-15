From: akpm@linux-foundation.org
Subject: + drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch added to -mm tree
Date: Wed, 15 Aug 2012 13:27:32 -0700
Message-ID: <20120815202733.9C38E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33745 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab2HOU1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 16:27:36 -0400
Received: by eaac1 with SMTP id c1so95215eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 13:27:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zonque@gmail.com, anilkumar@ti.com, eric.piel@tremplin-utc.net, robherring2@gmail.com


The patch titled
     Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching t=
able passthru code
has been added to the -mm tree.  Its filename is
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passth=
ru-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Daniel Mack <zonque@gmail.com>
Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching table =
passthru code

If probed from a device tree, this driver now passes the node informati=
on
to the generic part, so the runtime information can be derived.

Successfully tested on a PXA3xx board.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>
Reviewed-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d=
-lis3lv02d_spic-add-dt-matching-table-passthru-code drivers/misc/lis3lv=
02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis=
3lv02d_spic-add-dt-matching-table-passthru-code
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/pm.h>
+#include <linux/of_platform.h>
=20
 #include "lis3lv02d.h"
=20
@@ -58,6 +59,12 @@ static int lis3_spi_init(struct lis3lv02
 static union axis_conversion lis3lv02d_axis_normal =3D
 	{ .as_array =3D { 1, 2, 3 } };
=20
+static struct of_device_id lis302dl_spi_dt_ids[] =3D {
+	{ .compatible =3D "st,lis302dl-spi" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, lis302dl_spi_dt_ids);
+
 static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 {
 	int ret;
@@ -75,6 +82,12 @@ static int __devinit lis302dl_spi_probe(
 	lis3_dev.irq		=3D spi->irq;
 	lis3_dev.ac		=3D lis3lv02d_axis_normal;
 	lis3_dev.pdata		=3D spi->dev.platform_data;
+
+#ifdef CONFIG_OF
+	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev))
+		lis3_dev.of_node =3D spi->dev.of_node;
+#endif
+
 	spi_set_drvdata(spi, &lis3_dev);
=20
 	return lis3lv02d_init_device(&lis3_dev);
@@ -121,6 +134,7 @@ static struct spi_driver lis302dl_spi_dr
 		.name   =3D DRV_NAME,
 		.owner  =3D THIS_MODULE,
 		.pm	=3D &lis3lv02d_spi_pm,
+		.of_match_table =3D of_match_ptr(lis302dl_spi_dt_ids),
 	},
 	.probe	=3D lis302dl_spi_probe,
 	.remove	=3D __devexit_p(lis302dl_spi_remove),
_

Patches currently in -mm which might be from zonque@gmail.com are

origin.patch
linux-next.patch
drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-co=
de.patch
drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.=
patch
drivers-w1-masters-w1-gpioc-add-dt-bindings.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
