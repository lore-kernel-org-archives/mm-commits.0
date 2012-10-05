From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:26 -0700
Message-ID: <20121005201726.AD8F6100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60081 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2JEURc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:32 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so172454yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1672.c: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

