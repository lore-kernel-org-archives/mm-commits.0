From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:48 -0700
Message-ID: <20121005201748.B6AA4100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55471 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2JEURt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:49 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235379ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: drivers/rtc/rtc-isl1208.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-isl1208.c
@@ -68,9 +68,17 @@ isl1208_i2c_read_regs(struct i2c_client 
 {
 	u8 reg_addr[1] = { reg };
 	struct i2c_msg msgs[2] = {
-		{client->addr, 0, sizeof(reg_addr), reg_addr}
-		,
-		{client->addr, I2C_M_RD, len, buf}
+		{
+			.addr = client->addr,
+			.len = sizeof(reg_addr),
+			.buf = reg_addr
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = buf
+		}
 	};
 	int ret;
 
@@ -90,7 +98,11 @@ isl1208_i2c_set_regs(struct i2c_client *
 {
 	u8 i2c_buf[ISL1208_REG_USR2 + 2];
 	struct i2c_msg msgs[1] = {
-		{client->addr, 0, len + 1, i2c_buf}
+		{
+			.addr = client->addr,
+			.len = len + 1,
+			.buf = i2c_buf
+		}
 	};
 	int ret;
 
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch
linux-next.patch

