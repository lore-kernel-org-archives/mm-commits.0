From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:39:05 -0700
Message-ID: <20120925193906.7FC5520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33689 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab2IYTjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:39:08 -0400
Received: by weyx43 with SMTP id x43so75428wey.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:39:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com


The patch titled
     Subject: drivers/rtc/rtc-em3027.c: convert struct i2c_msg initialization to C99 format
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: drivers/rtc/rtc-em3027.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-em3027.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-em3027.c~drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-em3027.c
--- a/drivers/rtc/rtc-em3027.c~drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-em3027.c
@@ -49,8 +49,17 @@ static int em3027_get_time(struct device
 	unsigned char buf[7];
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},		/* setup read addr */
-		{client->addr, I2C_M_RD, 7, buf},	/* read time/date */
+		{/* setup read addr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* read time/date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 7,
+			.buf = buf
+		},
 	};
 
 	/* read time/date registers */
@@ -76,7 +85,9 @@ static int em3027_set_time(struct device
 	unsigned char buf[8];
 
 	struct i2c_msg msg = {
-		client->addr, 0, 8, buf,	/* write time/date */
+		.addr = client->addr,
+		.len = 8,
+		.buf = buf,	/* write time/date */
 	};
 
 	buf[0] = EM3027_REG_WATCH_SEC;
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

linux-next.patch
drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch

