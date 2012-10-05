From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:45 -0700
Message-ID: <20121005201745.A7693100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49101 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2JEURr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:47 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237019qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: drivers/rtc/rtc-pcf8563.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -78,8 +78,17 @@ static int pcf8563_get_datetime(struct i
 	unsigned char buf[13] = { PCF8563_REG_ST1 };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, buf },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 13, buf },	/* read status + date */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = buf
+		},
+		{/* read status + date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 13,
+			.buf = buf
+		},
 	};
 
 	/* read registers */
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch
linux-next.patch

