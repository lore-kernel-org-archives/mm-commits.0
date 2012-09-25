From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:38:46 -0700
Message-ID: <20120925193847.A391D5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36462 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2IYTiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:38:51 -0400
Received: by eaak14 with SMTP id k14so182419eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:38:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com


The patch titled
     Subject: drivers/rtc/rtc-ds1672.c: convert struct i2c_msg initialization to C99 format
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch

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
Subject: drivers/rtc/rtc-ds1672.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1672.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1672.c~drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-ds1672.c
@@ -37,8 +37,17 @@ static int ds1672_get_datetime(struct i2
 	unsigned char buf[4];
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},	/* setup read ptr */
-		{client->addr, I2C_M_RD, 4, buf},	/* read date */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* read date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 4,
+			.buf = buf
+		},
 	};
 
 	/* read date registers */
@@ -99,8 +108,17 @@ static int ds1672_get_control(struct i2c
 	unsigned char addr = DS1672_REG_CONTROL;
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},	/* setup read ptr */
-		{client->addr, I2C_M_RD, 1, status},	/* read control */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* read control */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = status
+		},
 	};
 
 	/* read control register */
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

