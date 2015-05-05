From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc-v3.patch
 removed from -mm tree
Date: Tue, 05 May 2015 16:18:42 -0700
Message-ID: <55494fd2./Y4R/tZpLQuzelnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbEEXSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 19:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.belloni@free-electrons.com, a.zummo@towertech.it, arnd@arndb.de, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc-v3
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc-v3.patch

This patch was dropped because it was folded into rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc.patch

------------------------------------------------------
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc-v3

 - renamed buffer from date to buf in abx80x_rtc_read_time()

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-abx80x.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-abx80x.c~rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc-v3 drivers/rtc/rtc-abx80x.c
--- a/drivers/rtc/rtc-abx80x.c~rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc-v3
+++ a/drivers/rtc/rtc-abx80x.c
@@ -95,23 +95,23 @@ static int abx80x_enable_trickle_charger
 static int abx80x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned char date[8];
+	unsigned char buf[8];
 	int err;
 
 	err = i2c_smbus_read_i2c_block_data(client, ABX8XX_REG_HTH,
-					    sizeof(date), date);
+					    sizeof(buf), buf);
 	if (err < 0) {
 		dev_err(&client->dev, "Unable to read date\n");
 		return -EIO;
 	}
 
-	tm->tm_sec = bcd2bin(date[ABX8XX_REG_SC] & 0x7F);
-	tm->tm_min = bcd2bin(date[ABX8XX_REG_MN] & 0x7F);
-	tm->tm_hour = bcd2bin(date[ABX8XX_REG_HR] & 0x3F);
-	tm->tm_wday = date[ABX8XX_REG_WD] & 0x7;
-	tm->tm_mday = bcd2bin(date[ABX8XX_REG_DA] & 0x3F);
-	tm->tm_mon = bcd2bin(date[ABX8XX_REG_MO] & 0x1F) - 1;
-	tm->tm_year = bcd2bin(date[ABX8XX_REG_YR]) + 100;
+	tm->tm_sec = bcd2bin(buf[ABX8XX_REG_SC] & 0x7F);
+	tm->tm_min = bcd2bin(buf[ABX8XX_REG_MN] & 0x7F);
+	tm->tm_hour = bcd2bin(buf[ABX8XX_REG_HR] & 0x3F);
+	tm->tm_wday = buf[ABX8XX_REG_WD] & 0x7;
+	tm->tm_mday = bcd2bin(buf[ABX8XX_REG_DA] & 0x3F);
+	tm->tm_mon = bcd2bin(buf[ABX8XX_REG_MO] & 0x1F) - 1;
+	tm->tm_year = bcd2bin(buf[ABX8XX_REG_YR]) + 100;
 
 	err = rtc_valid_tm(tm);
 	if (err < 0)
_

Patches currently in -mm which might be from alexandre.belloni@free-electrons.com are

documentation-bindings-add-abraconabx80x.patch
rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc.patch
rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time.patch
drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch
linux-next.patch

