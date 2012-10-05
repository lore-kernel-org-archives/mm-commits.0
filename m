From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:37 -0700
Message-ID: <20121005201738.26A6620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:43587 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2JEURl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:41 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98877lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s35390a.c: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: drivers/rtc/rtc-s35390a.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s35390a.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s35390a.c~drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-s35390a.c
@@ -50,7 +50,11 @@ static int s35390a_set_reg(struct s35390
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
-		{ client->addr, 0, len, buf },
+		{
+			.addr = client->addr,
+			.len = len,
+			.buf = buf
+		},
 	};
 
 	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
@@ -63,7 +67,12 @@ static int s35390a_get_reg(struct s35390
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
-		{ client->addr, I2C_M_RD, len, buf },
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = buf
+		},
 	};
 
 	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch
linux-next.patch

