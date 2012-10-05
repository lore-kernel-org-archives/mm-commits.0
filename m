From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:51 -0700
Message-ID: <20121005201751.AB31B100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44734 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2JEURw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:52 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so94098qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-em3027.c: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

