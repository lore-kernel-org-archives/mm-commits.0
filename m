From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:38:53 -0700
Message-ID: <20120925193854.1C76D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59869 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2IYTiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:38:55 -0400
Received: by qcqs25 with SMTP id s25so663592qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:38:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com


The patch titled
     Subject: drivers/rtc/rtc-s35390a.c: convert struct i2c_msg initialization to C99 format
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch

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

linux-next.patch
drivers-rtc-rtc-ds1672c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-x1205c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-s35390ac-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-pcf8563c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-isl1208c-convert-struct-i2c_msg-initialization-to-c99-format.patch
drivers-rtc-rtc-em3027c-convert-struct-i2c_msg-initialization-to-c99-format.patch

