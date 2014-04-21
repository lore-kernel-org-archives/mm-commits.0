From: akpm@linux-foundation.org
Subject: + rtc-m41t80-propagate-error-value-from-smbus-functions.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 13:08:51 -0700
Message-ID: <53557ad3.0jf3wRHw/dPooasb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaDUUIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, wsa@sang-engineering.com

Subject: + rtc-m41t80-propagate-error-value-from-smbus-functions.patch added to -mm tree
To: wsa@sang-engineering.com,a.zummo@towertech.it,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:08:51 -0700


The patch titled
     Subject: drivers/rtc/rtc-m41t80.c: propagate error value from smbus functions
has been added to the -mm tree.  Its filename is
     rtc-m41t80-propagate-error-value-from-smbus-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-m41t80-propagate-error-value-from-smbus-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-m41t80-propagate-error-value-from-smbus-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wolfram Sang <wsa@sang-engineering.com>
Subject: drivers/rtc/rtc-m41t80.c: propagate error value from smbus functions

Don't replace the value we got from the I2C layer, just pass it on.

Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-propagate-error-value-from-smbus-functions drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-propagate-error-value-from-smbus-functions
+++ a/drivers/rtc/rtc-m41t80.c
@@ -230,7 +230,7 @@ static ssize_t m41t80_sysfs_show_flags(s
 
 	val = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
 	if (val < 0)
-		return -EIO;
+		return val;
 	return sprintf(buf, "%#x\n", val);
 }
 static DEVICE_ATTR(flags, S_IRUGO, m41t80_sysfs_show_flags, NULL);
@@ -250,7 +250,7 @@ static ssize_t m41t80_sysfs_show_sqwfreq
 		reg_sqw = M41T80_REG_WDAY;
 	val = i2c_smbus_read_byte_data(client, reg_sqw);
 	if (val < 0)
-		return -EIO;
+		return val;
 	val = (val >> 4) & 0xf;
 	switch (val) {
 	case 0:
@@ -269,7 +269,7 @@ static ssize_t m41t80_sysfs_set_sqwfreq(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	int almon, sqw, reg_sqw;
+	int almon, sqw, reg_sqw, rc;
 	int val = simple_strtoul(buf, NULL, 0);
 
 	if (!(clientdata->features & M41T80_FEATURE_SQ))
@@ -289,21 +289,30 @@ static ssize_t m41t80_sysfs_set_sqwfreq(
 	/* disable SQW, set SQW frequency & re-enable */
 	almon = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
 	if (almon < 0)
-		return -EIO;
+		return almon;
 	reg_sqw = M41T80_REG_SQW;
 	if (clientdata->features & M41T80_FEATURE_SQ_ALT)
 		reg_sqw = M41T80_REG_WDAY;
 	sqw = i2c_smbus_read_byte_data(client, reg_sqw);
 	if (sqw < 0)
-		return -EIO;
+		return sqw;
 	sqw = (sqw & 0x0f) | (val << 4);
-	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-				      almon & ~M41T80_ALMON_SQWE) < 0 ||
-	    i2c_smbus_write_byte_data(client, reg_sqw, sqw) < 0)
-		return -EIO;
-	if (val && i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-					     almon | M41T80_ALMON_SQWE) < 0)
-		return -EIO;
+
+	rc = i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
+				      almon & ~M41T80_ALMON_SQWE);
+	if (rc < 0)
+		return rc;
+
+	if (val) {
+		rc = i2c_smbus_write_byte_data(client, reg_sqw, sqw);
+		if (rc < 0)
+			return rc;
+
+		rc = i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
+					     almon | M41T80_ALMON_SQWE);
+		if (rc <0)
+			return rc;
+	}
 	return count;
 }
 static DEVICE_ATTR(sqwfreq, S_IRUGO | S_IWUSR,
@@ -665,7 +674,7 @@ static int m41t80_probe(struct i2c_clien
 
 	if (rc < 0) {
 		dev_err(&client->dev, "Can't clear HT bit\n");
-		return -EIO;
+		return rc;
 	}
 
 	/* Make sure ST (stop) bit is cleared */
@@ -676,7 +685,7 @@ static int m41t80_probe(struct i2c_clien
 					      rc & ~M41T80_SEC_ST);
 	if (rc < 0) {
 		dev_err(&client->dev, "Can't clear ST bit\n");
-		return -EIO;
+		return rc;
 	}
 
 	rc = m41t80_sysfs_register(&client->dev);
_

Patches currently in -mm which might be from wsa@sang-engineering.com are

rtc-m41t80-remove-drv_version-macro.patch
rtc-m41t80-clean-up-error-paths.patch
rtc-m41t80-propagate-error-value-from-smbus-functions.patch
rtc-m41t80-add-support-for-microcrystal-rv4162.patch
linux-next.patch

