From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-simplify-return-from-function.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:17:30 -0700
Message-ID: <553550ca.dMm0aBu7rQmR9vH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbDTTLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.r.kmiec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: simplify return from function
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-simplify-return-from-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert Kmiec <robert.r.kmiec@gmail.com>
Subject: drivers/rtc/rtc-pcf8563.c: simplify return from function

This commit does not change any logic here.  It just makes the code easier
to read.

This is how it looked like:
If err != 0 return err;
else return 0;

Signed-off-by: Robert Kmiec <robert.r.kmiec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-simplify-return-from-function drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-simplify-return-from-function
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -246,7 +246,6 @@ static int pcf8563_get_datetime(struct i
 static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	struct pcf8563 *pcf8563 = i2c_get_clientdata(client);
-	int err;
 	unsigned char buf[9];
 
 	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
@@ -272,12 +271,8 @@ static int pcf8563_set_datetime(struct i
 
 	buf[PCF8563_REG_DW] = tm->tm_wday & 0x07;
 
-	err = pcf8563_write_block_data(client, PCF8563_REG_SC,
+	return pcf8563_write_block_data(client, PCF8563_REG_SC,
 				9 - PCF8563_REG_SC, buf + PCF8563_REG_SC);
-	if (err)
-		return err;
