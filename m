From: akpm@linux-foundation.org
Subject: + matroxfb-convert-struct-i2c_msg-initialization-to-c99-format.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:40:34 -0800
Message-ID: <20130228214034.9AD4F5A41DD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:62979 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3B1Vkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:40:36 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so255930qea.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:40:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: omaplinuxkernel@gmail.com, FlorianSchandinat@gmx.de, julia@diku.dk, khali@linux-fr.org, shubhrajyoti@ti.com


The patch titled
     Subject: matroxfb: convert struct i2c_msg initialization to C99 format
has been added to the -mm tree.  Its filename is
     matroxfb-convert-struct-i2c_msg-initialization-to-c99-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Subject: matroxfb: convert struct i2c_msg initialization to C99 format

Convert the struct i2c_msg initialization to C99 format.  This makes
maintaining and editing the code simpler.  Also helps once other fields
like transferred are added in future.

Thanks to Julia Lawall for automating the conversion.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Julia Lawall <julia@diku.dk>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_maven.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/video/matrox/matroxfb_maven.c~matroxfb-convert-struct-i2c_msg-initialization-to-c99-format drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~matroxfb-convert-struct-i2c_msg-initialization-to-c99-format
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -137,8 +137,20 @@ static int* get_ctrl_ptr(struct maven_da
 
 static int maven_get_reg(struct i2c_client* c, char reg) {
 	char dst;
-	struct i2c_msg msgs[] = {{ c->addr, I2C_M_REV_DIR_ADDR, sizeof(reg), &reg },
-				 { c->addr, I2C_M_RD | I2C_M_NOSTART, sizeof(dst), &dst }};
+	struct i2c_msg msgs[] = {
+		{
+			.addr = c->addr,
+			.flags = I2C_M_REV_DIR_ADDR,
+			.len = sizeof(reg),
+			.buf = &reg
+		},
+		{
+			.addr = c->addr,
+			.flags = I2C_M_RD | I2C_M_NOSTART,
+			.len = sizeof(dst),
+			.buf = &dst
+		}
+	};
 	s32 err;
 
 	err = i2c_transfer(c->adapter, msgs, 2);
_

Patches currently in -mm which might be from omaplinuxkernel@gmail.com are

matroxfb-convert-struct-i2c_msg-initialization-to-c99-format.patch

