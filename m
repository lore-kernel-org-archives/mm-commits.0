From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:41 -0700
Message-ID: <20121005201742.1DB1A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:51945 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2JEURo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:44 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so139005bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, a.zummo@towertech.it, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rs5c372.c: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: drivers/rtc/rtc-rs5c372.c: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.  while at it also fix a checkpatch
warn WARNING: sizeof rs5c->buf should be sizeof(rs5c->buf)

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rs5c372.c~drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~drivers-rtc-rtc-rs5c372c-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -104,7 +104,12 @@ static int rs5c_get_regs(struct rs5c372 
 {
 	struct i2c_client	*client = rs5c->client;
 	struct i2c_msg		msgs[] = {
-		{ client->addr, I2C_M_RD, sizeof rs5c->buf, rs5c->buf },
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(rs5c->buf),
+			.buf = rs5c->buf
+		},
 	};
 
 	/* This implements the third reading method from the datasheet, using
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch
linux-next.patch

