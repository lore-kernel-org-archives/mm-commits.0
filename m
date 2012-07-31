From: akpm@linux-foundation.org
Subject: [merged] rtc-mc13xxx-use-module_device_table-instead-of-module_alias.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:38 -0700
Message-ID: <20120731185239.21EC8100081@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab2GaSwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:49 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/mc13xxx: use MODULE_DEVICE_TABLE instead of MODULE_AL=
IAS
has been removed from the -mm tree.  Its filename was
     rtc-mc13xxx-use-module_device_table-instead-of-module_alias.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: rtc/mc13xxx: use MODULE_DEVICE_TABLE instead of MODULE_ALIAS

This allows automatic driver loading for all supported device types.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-use-module_device_table=
-instead-of-module_alias drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-use-module_device_table-ins=
tead-of-module_alias
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -405,8 +405,9 @@ static const struct platform_device_id m
 	}, {
 		.name =3D "mc13892-rtc",
 	},
-	{ }
+	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(platform, mc13xxx_rtc_idtable);
=20
 static struct platform_driver mc13xxx_rtc_driver =3D {
 	.id_table =3D mc13xxx_rtc_idtable,
@@ -432,4 +433,3 @@ module_exit(mc13xxx_rtc_exit);
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("RTC driver for Freescale MC13XXX PMIC");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:" DRIVER_NAME);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
