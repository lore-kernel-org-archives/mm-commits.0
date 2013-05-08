From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:28 -0700
Message-ID: <20130508183428.74BAE5A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57448 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3EHSe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:29 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so208034vcb.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, jlu@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rs5c372.c: add R2221T/L variant to the driver
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-rs5c372c-add-r2221t-l-variant-to-the-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

