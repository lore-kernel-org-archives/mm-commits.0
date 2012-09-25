From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:39:02 -0700
Message-ID: <20120925193903.2EE5F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54298 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2IYTjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:39:03 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so66116qae.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:39:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: convert struct i2c_msg initialization to C99 format
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch

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

linux-next.patch
drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch

