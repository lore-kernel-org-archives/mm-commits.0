From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:38:50 -0700
Message-ID: <20120925193851.2F1E6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34182 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2IYTiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:38:52 -0400
Received: by ghbz15 with SMTP id z15so951107ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:38:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com


The patch titled
     Subject: drivers/rtc/rtc-x1205.c: convert struct i2c_msg initialization to C99 format
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format.patch

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
Subject: drivers/rtc/rtc-x1205.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |   92 ++++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-x1205.c~drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-x1205.c
@@ -97,8 +97,17 @@ static int x1205_get_datetime(struct i2c
 	int i;
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, dt_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 8, buf },	/* read date */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 2,
+			.buf = dt_addr
+		},
+		{/* read date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 8,
+			.buf = buf
+		},
 	};
 
 	/* read date registers */
@@ -142,8 +151,17 @@ static int x1205_get_status(struct i2c_c
 	static unsigned char sr_addr[2] = { 0, X1205_REG_SR };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, sr_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, sr },	/* read status */
+		{     /* setup read ptr */
+			.addr = client->addr,
+			.len = 2,
+			.buf = sr_addr
+		},
+		{    /* read status */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = sr
+		},
 	};
 
 	/* read status register */
@@ -279,8 +297,17 @@ static int x1205_get_dtrim(struct i2c_cl
 	static unsigned char dtr_addr[2] = { 0, X1205_REG_DTR };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, dtr_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &dtr }, 	/* read dtr */
+		{	/* setup read ptr */
+			.addr = client->addr,
+			.len = 2,
+			.buf = dtr_addr
+		},
+		{      /* read dtr */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = &dtr
+		},
 	};
 
 	/* read dtr register */
@@ -311,8 +338,17 @@ static int x1205_get_atrim(struct i2c_cl
 	static unsigned char atr_addr[2] = { 0, X1205_REG_ATR };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, atr_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &atr }, 	/* read atr */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 2,
+			.buf = atr_addr
+		},
+		{/* read atr */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = &atr
+		},
 	};
 
 	/* read atr register */
@@ -381,8 +417,17 @@ static int x1205_validate_client(struct 
 		unsigned char addr[2] = { 0, probe_zero_pattern[i] };
 
 		struct i2c_msg msgs[2] = {
-			{ client->addr, 0, 2, addr },
-			{ client->addr, I2C_M_RD, 1, &buf },
+			{
+				.addr = client->addr,
+				.len = 2,
+				.buf = addr
+			},
+			{
+				.addr = client->addr,
+				.flags = I2C_M_RD,
+				.len = 1,
+				.buf = &buf
+			},
 		};
 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
@@ -409,8 +454,17 @@ static int x1205_validate_client(struct 
 		unsigned char addr[2] = { 0, probe_limits_pattern[i].reg };
 
 		struct i2c_msg msgs[2] = {
-			{ client->addr, 0, 2, addr },
-			{ client->addr, I2C_M_RD, 1, &reg },
+			{
+				.addr = client->addr,
+				.len = 2,
+				.buf = addr
+			},
+			{
+				.addr = client->addr,
+				.flags = I2C_M_RD,
+				.len = 1,
+				.buf = &reg
+			},
 		};
 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
@@ -444,8 +498,18 @@ static int x1205_rtc_read_alarm(struct d
 	static unsigned char int_addr[2] = { 0, X1205_REG_INT };
 	struct i2c_client *client = to_i2c_client(dev);
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, int_addr },        /* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &intreg },  /* read INT register */
+		{ /* setup read ptr */
+			.addr = client->addr,
+			.len = 2,
+			.buf = int_addr
+		},
+		{/* read INT register */
+
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = &intreg
+		},
 	};
 
 	/* read interrupt register and status register */
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

