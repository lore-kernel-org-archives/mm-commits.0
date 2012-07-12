From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-use-module_device_table-instead-of-module_alias.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:50:06 -0700
Message-ID: <20120712215007.183411E004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41725 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab2GLVuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:50:10 -0400
Received: by yenl3 with SMTP id l3so281971yen.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:50:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it


The patch titled
     Subject: rtc/mc13xxx: use MODULE_DEVICE_TABLE instead of MODULE_AL=
IAS
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-use-module_device_table-instead-of-module_alias.patch

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
Subject: Subject: rtc/mc13xxx: use MODULE_DEVICE_TABLE instead of MODUL=
E_ALIAS

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
rtc-mc13xxx-use-module_device_table-instead-of-module_alias.patch
rtc-mc13xxx-add-support-for-the-rtc-in-the-mc34708-pmic.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
