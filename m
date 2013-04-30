From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver.patch added to -mm tree
Date: Tue, 30 Apr 2013 12:44:14 -0700
Message-ID: <20130430194414.713AA5A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36520 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab3D3ToP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:44:15 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so92835vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:44:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: l.stach@pengutronix.de, jlu@pengutronix.de


The patch titled
     Subject: drivers/rtc/rtc-rs5c372.c: add R2221T/L variant to the driver
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: drivers/rtc/rtc-rs5c372.c: add R2221T/L variant to the driver

Register layout is the same, so just add the variant to the appropriate
places.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/rtc/rtc-rs5c372.c~drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -68,6 +68,7 @@
 enum rtc_type {
 	rtc_undef = 0,
 	rtc_r2025sd,
+	rtc_r2221tl,
 	rtc_rs5c372a,
 	rtc_rs5c372b,
 	rtc_rv5c386,
@@ -76,6 +77,7 @@ enum rtc_type {
 
 static const struct i2c_device_id rs5c372_id[] = {
 	{ "r2025sd", rtc_r2025sd },
+	{ "r2221tl", rtc_r2221tl },
 	{ "rs5c372a", rtc_rs5c372a },
 	{ "rs5c372b", rtc_rs5c372b },
 	{ "rv5c386", rtc_rv5c386 },
@@ -529,6 +531,7 @@ static int rs5c_oscillator_setup(struct
 		rs5c372->time24 = 1;
 		break;
 	case rtc_r2025sd:
+	case rtc_r2221tl:
 	case rtc_rv5c386:
 	case rtc_rv5c387a:
 		buf[0] |= RV5C387_CTRL1_24;
@@ -609,6 +612,7 @@ static int rs5c372_probe(struct i2c_clie
 			rs5c372->time24 = 1;
 		break;
 	case rtc_r2025sd:
+	case rtc_r2221tl:
 	case rtc_rv5c386:
 	case rtc_rv5c387a:
 		if (rs5c372->regs[RS5C_REG_CTRL1] & RV5C387_CTRL1_24)
@@ -640,6 +644,7 @@ static int rs5c372_probe(struct i2c_clie
 	dev_info(&client->dev, "%s found, %s, driver version " DRV_VERSION "\n",
 			({ char *s; switch (rs5c372->type) {
 			case rtc_r2025sd:	s = "r2025sd"; break;
+			case rtc_r2221tl:	s = "r2221tl"; break;
 			case rtc_rs5c372a:	s = "rs5c372a"; break;
 			case rtc_rs5c372b:	s = "rs5c372b"; break;
 			case rtc_rv5c386:	s = "rv5c386"; break;
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

linux-next.patch
drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver.patch

