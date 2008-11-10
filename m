From: akpm@linux-foundation.org
Subject: + mfd-correct-wm8350-i2c-return-code-usage.patch added to -mm tree
Date: Mon, 10 Nov 2008 15:35:28 -0800
Message-ID: <200811102335.mAANZSb4017536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbYKJXgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 18:36:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, sameo@openedhand.com


The patch titled
     mfd: correct WM8350 I2C return code usage
has been added to the -mm tree.  Its filename is
     mfd-correct-wm8350-i2c-return-code-usage.patch

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
Subject: mfd: correct WM8350 I2C return code usage
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

The vendor BSP used for the WM8350 development provided an I2C driver
which incorrectly returned zero on succesful sends rather than the number
of transmitted bytes, an error which was then propagated into the WM8350
I2C accessors.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-i2c.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/wm8350-i2c.c~mfd-correct-wm8350-i2c-return-code-usage drivers/mfd/wm8350-i2c.c
--- a/drivers/mfd/wm8350-i2c.c~mfd-correct-wm8350-i2c-return-code-usage
+++ a/drivers/mfd/wm8350-i2c.c
@@ -28,7 +28,12 @@ static int wm8350_i2c_read_device(struct
 	ret = i2c_master_send(wm8350->i2c_client, &reg, 1);
 	if (ret < 0)
 		return ret;
-	return i2c_master_recv(wm8350->i2c_client, dest, bytes);
+	ret = i2c_master_recv(wm8350->i2c_client, dest, bytes);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes)
+		return -EIO;
+	return 0;
 }
 
 static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
@@ -36,13 +41,19 @@ static int wm8350_i2c_write_device(struc
 {
 	/* we add 1 byte for device register */
 	u8 msg[(WM8350_MAX_REGISTER << 1) + 1];
+	int ret;
 
 	if (bytes > ((WM8350_MAX_REGISTER << 1) + 1))
 		return -EINVAL;
 
 	msg[0] = reg;
 	memcpy(&msg[1], src, bytes);
-	return i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
+	ret = i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes + 1)
+		return -EIO;
+	return 0;
 }
 
 static int wm8350_i2c_probe(struct i2c_client *i2c,
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
mfd-correct-wm8350-i2c-return-code-usage.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

