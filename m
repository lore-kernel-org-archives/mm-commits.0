From: akpm@linux-foundation.org
Subject: [merged] matroxfb-convert-struct-i2c_msg-initialization-to-c99-format.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:33 -0700
Message-ID: <20130430184333.835D85A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:60130 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3D3Sne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:34 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so84380yen.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: omaplinuxkernel@gmail.com, FlorianSchandinat@gmx.de, julia@diku.dk, khali@linux-fr.org, shubhrajyoti@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: matroxfb: convert struct i2c_msg initialization to C99 format
has been removed from the -mm tree.  Its filename was
     matroxfb-convert-struct-i2c_msg-initialization-to-c99-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

