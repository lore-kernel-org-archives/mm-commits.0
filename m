From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-rx8581c-fix-setdatetime.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:56:53 -0700
Message-ID: <201007212156.o6LLurrj017320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758788Ab0GUV5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rudolf.marek@sysgo.com, a.zummo@towertech.it, martyn.welch@gefanuc.com, mcuos.com@gmail.com


The patch titled
     drivers/rtc/rtc-rx8581.c: fix setdatetime
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-rx8581c-fix-setdatetime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-rx8581.c: fix setdatetime
From: Rudolf Marek <rudolf.marek@sysgo.com>

Fix the logic while writing new date/time to the chip.  The driver
incorrectly wrote back register values to different registers and even
with wrong mask.  The patch adds clearing of the VLF register, which
should be cleared if all date/time values are set.

Signed-off-by: Rudolf Marek <rudolf.marek@sysgo.com>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8581.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-rx8581.c~drivers-rtc-rtc-rx8581c-fix-setdatetime drivers/rtc/rtc-rx8581.c
--- a/drivers/rtc/rtc-rx8581.c~drivers-rtc-rtc-rx8581c-fix-setdatetime
+++ a/drivers/rtc/rtc-rx8581.c
@@ -168,7 +168,7 @@ static int rx8581_set_datetime(struct i2
 		return -EIO;
 	}
 
-	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_CTRL,
 		(data | RX8581_CTRL_STOP));
 	if (err < 0) {
 		dev_err(&client->dev, "Unable to write control register\n");
@@ -182,6 +182,20 @@ static int rx8581_set_datetime(struct i2
 		return -EIO;
 	}
 
+	/* get VLF and clear it */
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_FLAG);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read flag register\n");
+		return -EIO;
+	}
+
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
+		(data & ~(RX8581_FLAG_VLF)));
+	if (err != 0) {
+		dev_err(&client->dev, "Unable to write flag register\n");
+		return -EIO;
+	}
+
 	/* Restart the clock */
 	data = i2c_smbus_read_byte_data(client, RX8581_REG_CTRL);
 	if (data < 0) {
@@ -189,8 +203,8 @@ static int rx8581_set_datetime(struct i2
 		return -EIO;
 	}
 
-	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
-		(data | ~(RX8581_CTRL_STOP)));
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_CTRL,
+		(data & ~(RX8581_CTRL_STOP)));
 	if (err != 0) {
 		dev_err(&client->dev, "Unable to write control register\n");
 		return -EIO;
_

Patches currently in -mm which might be from rudolf.marek@sysgo.com are

drivers-rtc-rtc-rx8581c-fix-setdatetime.patch

