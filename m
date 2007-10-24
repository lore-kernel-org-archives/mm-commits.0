From: akpm@linux-foundation.org
Subject: + rtc-pcf8583-dont-abuse-i2c_m_nostart.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:21:57 -0700
Message-ID: <200710242221.l9OMLvHf015582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbXJXWXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-pcf8583: Don't abuse I2C_M_NOSTART
has been added to the -mm tree.  Its filename is
     rtc-pcf8583-dont-abuse-i2c_m_nostart.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-pcf8583: Don't abuse I2C_M_NOSTART
From: Jean Delvare <khali@linux-fr.org>

The rtc-pcf8583 driver is using the I2C_M_NOSTART flag but shouldn't.  This
flag is only meant for broken chips and the PCF8583 RTC chip is not one of
these.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-dont-abuse-i2c_m_nostart drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-dont-abuse-i2c_m_nostart
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -163,27 +163,17 @@ static int pcf8583_read_mem(struct i2c_c
 
 static int pcf8583_write_mem(struct i2c_client *client, struct rtc_mem *mem)
 {
-	unsigned char addr[1];
-	struct i2c_msg msgs[2] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = addr,
-		}, {
-			.addr = client->addr,
-			.flags = I2C_M_NOSTART,
-			.len = mem->nr,
-			.buf = mem->data,
-		}
-	};
+	unsigned char buf[9];
+	int ret;
 
-	if (mem->loc < 8)
+	if (mem->loc < 8 || mem->nr > 8)
 		return -EINVAL;
 
-	addr[0] = mem->loc;
+	buf[0] = mem->loc;
+	memcpy(buf + 1, mem->data, mem->nr);
 
-	return i2c_transfer(client->adapter, msgs, 2) == 2 ? 0 : -EIO;
+	ret = i2c_master_send(client, buf, mem->nr + 1);
+	return ret == mem->nr + 1 ? 0 : -EIO;
 }
 
 static int pcf8583_rtc_read_time(struct device *dev, struct rtc_time *tm)
_

Patches currently in -mm which might be from khali@linux-fr.org are

i2c-add-support-for-the-pcf8575-chip.patch
git-hwmon.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
