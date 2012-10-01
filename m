From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:18 -0700
Message-ID: <20121001192819.697AC20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59253 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2JAT2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:22 -0400
Received: by wgbdt11 with SMTP id dt11so328797wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zonque@gmail.com, anilkumar@ti.com, eric.piel@tremplin-utc.net, robherring2@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching t=
able passthru code
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passth=
ru-code.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Daniel Mack <zonque@gmail.com>
Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching table =
passthru code

If probed from a device tree, this driver now passes the node informati=
on
to the generic part, so the runtime information can be derived.

Successfully tested on a PXA3xx board.

[akpm@linux-foundation.org: fix lis302dl_spi_dt_ids unused warning when=
 CONFIG_OF=3Dn]
Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>
Reviewed-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d=
-lis3lv02d_spic-add-dt-matching-table-passthru-code drivers/misc/lis3lv=
02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis=
3lv02d_spic-add-dt-matching-table-passthru-code
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -17,6 +17,8 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/pm.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
=20
 #include "lis3lv02d.h"
=20
@@ -58,6 +60,14 @@ static int lis3_spi_init(struct lis3lv02
 static union axis_conversion lis3lv02d_axis_normal =3D
 	{ .as_array =3D { 1, 2, 3 } };
=20
+#ifdef CONFIG_OF
+static struct of_device_id lis302dl_spi_dt_ids[] =3D {
+	{ .compatible =3D "st,lis302dl-spi" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, lis302dl_spi_dt_ids);
+#endif
+
 static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 {
 	int ret;
@@ -75,6 +85,12 @@ static int __devinit lis302dl_spi_probe(
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
@@ -121,6 +137,7 @@ static struct spi_driver lis302dl_spi_dr
 		.name   =3D DRV_NAME,
 		.owner  =3D THIS_MODULE,
 		.pm	=3D &lis3lv02d_spi_pm,
+		.of_match_table =3D of_match_ptr(lis302dl_spi_dt_ids),
 	},
 	.probe	=3D lis302dl_spi_probe,
 	.remove	=3D __devexit_p(lis302dl_spi_remove),
_

Patches currently in -mm which might be from zonque@gmail.com are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
